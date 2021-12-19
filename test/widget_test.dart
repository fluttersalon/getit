// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:getit/count_data.dart';

import 'package:getit/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    GetIt.I.allowReassignment = true;
  });

  testWidgets('get_it', (WidgetTester tester) async {
    CountData dummy = CountData(count: 123456789);

    GetIt.I.registerSingleton<Future<CountData>>(
      Future.value(dummy),
    );
    GetIt.I.registerSingleton<Future<SharedPreferences>>(
      SharedPreferences.getInstance(),
    );
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('123,456,789'), findsOneWidget);
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    Map<String, Object> values = <String, Object>{'test': 1};
    SharedPreferences.setMockInitialValues(values);
    var pref = await SharedPreferences.getInstance();
    expect(pref.getInt('test'), 1);

    GetIt.I.registerSingleton<Future<SharedPreferences>>(
      SharedPreferences.getInstance(),
    );

    CountData dummy = CountData(count: 123456789);
    GetIt.I.registerSingleton<Future<CountData>>(
      Future.value(dummy),
    );

    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Verify that our counter starts at 0.
    expect(find.text('123,456,789'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await dummy.save();

    // Verify that our counter has incremented.
    expect(find.text('123,456,790'), findsOneWidget);

    CountData prefResult =
        CountData.fromJson(json.decode(pref.getString('key') ?? ''));
    expect(prefResult.count, 123456789);
  });
}
