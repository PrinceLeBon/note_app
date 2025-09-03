// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_app/data/providers/firestore.dart';
import 'package:note_app/main.dart';
import 'package:note_app/services/connectivity_service.dart';
import 'package:note_app/services/sync_service.dart';

void main() {
  testWidgets('App startup test', (WidgetTester tester) async {
    // Create mock services for testing
    final connectivityService = ConnectivityService();
    final syncService = SyncService(
      firestoreAPI: const FirestoreAPI(),
      connectivityService: connectivityService,
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      connectivityService: connectivityService,
      syncService: syncService,
    ));

    // This is a basic test to ensure the app starts
    // You can add more specific tests based on your app's behavior
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
