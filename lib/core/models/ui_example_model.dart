import 'package:flutter/material.dart';

class UIExampleModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget page;
  final bool isNew;

  const UIExampleModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.page,
    this.isNew = false,
  });
}
