import 'package:flutter/material.dart';

enum SelectionType {
  category(label: 'カテゴリー', code: '001'),
  scene(label:'シーン', code: '002'),
  recommendation(label: 'オススメ話題週', code: '003');

  const SelectionType({
    required this.label,
    required this.code
  });

  final String label;
  final String code;

  String getLabel() {
    return label;
  }

  String getCode() {
    return code;
  }
}