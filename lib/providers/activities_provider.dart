import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class ActivitiesProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ActivityModel> _activities = [];
  List<String> _favorites = [];
  String _filterType = 'Todos';
  String? _userName;
  String? _userRole;

  List<ActivityModel> get activities => _filterType == 'Todos'
      ? _activities
      : _activities.where((a) => a.type == _filterType).toList();

  List<ActivityModel> get favoriteActivities =>
      _activities.where((a) => _favorites.contains(a.id)).toList();

  bool get isAdmin => _userRole == 'admin';
  bool get isLoggedIn => _authService.currentUser != null;
  String? get userName => _userName;

  List<String> get favorites => _favorites;
  String get filterType => _filterType;
  List<ActivityModel> get allActivities => _activities;
  AuthService get authService => _authService;

  ActivitiesProvider() {
    _loadFavorites();
    _listenToActivities();
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authService.userStream.listen((user) async {
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _userName = null;
        _userRole = null;
        _loadFavorites(); // Carregar favoritos locais
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _userName = doc['name'];
        _userRole = doc['role'];
        await _loadFavoritesFromFirestore(uid);
      }
    } catch (e) {
      // Fallback para local
      _userName = null;
      _userRole = 'user';
      _loadFavorites();
    }
  }

  void _listenToActivities() {
    _firestoreService.getActivities().listen((activities) {
      _activities = activities;
      notifyListeners();
    });
  }

  void setFilter(String type) {
    _filterType = type;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    _saveFavorites();
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }

  Future<void> _loadFavoritesFromFirestore(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        List<dynamic> favs = doc['favorites'] ?? [];
        _favorites = favs.map((e) => e.toString()).toList();
      } else {
        _favorites = [];
      }
    } catch (e) {
      _favorites = [];
    }
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    if (isLoggedIn && _authService.currentUser != null) {
      // Salvar no Firestore
      await _firestore.collection('users').doc(_authService.currentUser!.uid).update({
        'favorites': _favorites,
      });
    } else {
      // Salvar localmente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorites', _favorites);
    }
  }

  Future<void> addActivity(ActivityModel activity) async {
    await _firestoreService.addActivity(activity);
  }

  Future<void> updateActivity(String id, ActivityModel activity) async {
    await _firestoreService.updateActivity(id, activity);
  }

  Future<void> deleteActivity(String id) async {
    await _firestoreService.deleteActivity(id);
  }
}