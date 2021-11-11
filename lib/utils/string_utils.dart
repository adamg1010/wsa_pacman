// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:collection';
import 'int_utils.dart';
import 'dart:io';

extension StringUtils on String {

  int? get ipv4AsInt => InternetAddress.tryParse(this)?.rawAddress.buffer.asByteData().getInt32(0);

  bool isNumeric() => contains(RegExp(r'^[0-9]*$'));
  bool isSignedNumeric() => contains(RegExp(r'^[+-]?[0-9]*$'));

  String? find(String regexp, [int group = 0]) {
    var matches = RegExp(regexp).firstMatch(this);
      return  matches?.group(group)!;
  }

  /// Maps folding repeated entries per key
  Map<K, V> foldToMap<K,V>(String regexp, K Function(RegExpMatch match) key, V Function(RegExpMatch match, V? prev) value) {
    Map<K,V> map = {};
    for (var m in RegExp(regexp).allMatches(this)) map.update(key(m), (v) => value(m, v), ifAbsent: () => value(m, null));
    return map;
  }

  /// Maps the string, assumes a single match per key
  Map<K, V> toMap<K,V>(String regexp, K Function(RegExpMatch match) key, V Function(RegExpMatch match) value) {
    return {for (var m in RegExp(regexp).allMatches(this)) key(m) : value(m)};
  }

  /// Maps the string, assumes a single match per key
  Set<E> toSet<E>(String regexp, E? Function(RegExpMatch match) value, [int Function(E key1, E key2)? compare]) {
    final Set<E> set = compare != null ? SplayTreeSet(compare) : <E>{};
    for (var m in RegExp(regexp).allMatches(this)) {
      var nv = value(m);
      if (nv != null) set.add(nv);
      else if (null is E) (set as Set<E?>).add(nv);
    }
    return set;
  }

  Iterable<String> findAll(String regexp, [int group = 0]) {
    return RegExp(regexp).allMatches(this).map((m) => m.group(group)!);
  }

  Iterable<R> findAllAnd<R>(String regexp, R Function(Match) provider) {
    return RegExp(regexp).allMatches(this).map((m) => provider(m));
  }
}