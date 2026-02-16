import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class ActivitiesProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  List<ActivityModel> _activities = [];
  List<String> _favorites = [];
  String _filterType = 'Todos';

  List<ActivityModel> get activities => _filterType == 'Todos'
      ? _activities
      : _activities.where((a) => a.type == _filterType).toList();

  List<ActivityModel> get favoriteActivities =>
      _activities.where((a) => _favorites.contains(a.id)).toList();

  bool get isAdmin {
    final user = _authService.currentUser;
    return user != null && ['admin@example.com'].contains(user.email); // hardcoded
  }

  List<String> get favorites => _favorites;
  String get filterType => _filterType;
  List<ActivityModel> get allActivities => _activities;
  AuthService get authService => _authService;

  ActivitiesProvider() {
    _loadFavorites();
    _listenToActivities();
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

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
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