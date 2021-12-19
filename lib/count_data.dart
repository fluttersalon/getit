import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'count_data.freezed.dart';
part 'count_data.g.dart';

@freezed
class CountData with _$CountData {
  static final formatter = NumberFormat("#,###");
  const CountData._();

  static const KEY_SETTING_DATA = 'key';
  static final Future<SharedPreferences> _preferences =
      GetIt.I.get<Future<SharedPreferences>>();

  const factory CountData({
    required int count,
  }) = _CountData;

  factory CountData.fromJson(Map<String, dynamic> json) =>
      _$CountDataFromJson(json);

  String toFormattedString() {
    return formatter.format(count);
  }

  Future<void> save() async {
    _preferences.then((pref) {
      pref.setString(KEY_SETTING_DATA, json.encode(this.toJson()));
      return;
    });
  }

  static Future<CountData> load() async {
    SharedPreferences pref = await _preferences;

    final String? jsonData = pref.getString(KEY_SETTING_DATA);
    if (jsonData == null) {
      return CountData(count: 0);
    }
    return CountData.fromJson(json.decode(jsonData) as Map<String, dynamic>);
  }

  static void reset() async {
    _preferences.then(
      (pref) => pref.remove(KEY_SETTING_DATA),
    );
  }
}
