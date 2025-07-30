import 'package:flutter/material.dart';

class NewsCategory {
  final String id;
  final String name;
  final String displayName;
  final IconData icon;
  final Color color;
  bool isSelected;
  final int? articleCount;

  NewsCategory({
    required this.id,
    required this.name,
    required this.displayName,
    required this.icon,
    required this.color,
    this.isSelected = false,
    this.articleCount,
  });

  NewsCategory copyWith({
    bool? isSelected,
    int? articleCount,
  }) {
    return NewsCategory(
      id: id,
      name: name,
      displayName: displayName,
      icon: icon,
      color: color,
      isSelected: isSelected ?? this.isSelected,
      articleCount: articleCount ?? this.articleCount,
    );
  }
}