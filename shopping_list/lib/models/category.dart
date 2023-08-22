import 'package:flutter/material.dart';

enum Categories {
  vegetables,
  meat,
  dairy,
  fruit,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other,
}

class Category {
  final String category;
  final Color color;

  const Category(this.category, this.color);
}