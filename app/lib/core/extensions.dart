import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension IterableExt on Iterable<Widget> {
  Iterable<Widget> separated(final Widget separator) {
    List<Widget> list = map((final element) => [element, separator]).expand((final e) => e).toList();
    if (list.isNotEmpty) list = list..removeLast();
    return list;
  }
}

extension DateTimeEx on DateTime {
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }
}

extension StringEx on String? {
  bool get isTrue => this?.toLowerCase() == 'true';
  bool get isFalse => this?.toLowerCase() == 'false';
}
