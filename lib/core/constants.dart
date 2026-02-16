import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF962038); // Vermelho Bordô UFOP
  static const Color secondary = Color(0xFF53565A); // Cinza Chumbo UFOP
  static const Color background = Color(0xFFF5F5F5); // Cinza claro
  static const Color surface = Colors.white;
  static const Color onSurface = Colors.black;
  static const Color chipBackground = Color(0xFFE3F2FD);
  static const Color chipSelected = Color(0xFFFFE0B2);
}

class AppIcons {
  static const IconData event = Icons.event;
  static const IconData favorite = Icons.star;
  static const IconData admin = Icons.admin_panel_settings;
  static const IconData person = Icons.person;
  static const IconData description = Icons.description;
  static const IconData location = Icons.location_on;
  static const IconData time = Icons.access_time;
  static const IconData category = Icons.category;
  static const IconData email = Icons.email;
  static const IconData lock = Icons.lock;
  static const IconData title = Icons.title;
  static const IconData info = Icons.info;
}

class AppStrings {
  static const List<String> activityTypes = ['Todos', 'Palestra', 'Workshop'];
  static const List<String> tabs = ['Programação', 'Minha Agenda'];
}