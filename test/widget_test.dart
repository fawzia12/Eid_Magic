import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eid_magic/main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    // Setup Hive for testing
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
  });

  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EidMagicApp());
    // Basic verification that the app launched
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
