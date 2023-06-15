import 'dart:ffi';

import 'package:flutter/material.dart';

enum BottomTab {
  search(label: '検索'),
  myList(label:'マイリスト'),
  browse(label: '見つける');

  const BottomTab({
    required this.label
  });

  final String label;

  String getLabel() {
    return label;
  }
}