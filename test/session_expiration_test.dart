import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_admin_san/core/networking/local_services.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/session_expired_dialog.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('24-Hour Session Expiration Tests', () {
    test('Session is treated as expired if no timestamp is saved', () async {
      FlutterSecureStorage.setMockInitialValues({});

      final isExpired = await AuthLocalStorage.isSessionExpired();
      expect(isExpired, isTrue);
    });

    test('Session is valid when manual login occurred recently (< 24h)',
        () async {
      final recentLogin =
          DateTime.now().subtract(const Duration(hours: 2)).toIso8601String();
      FlutterSecureStorage.setMockInitialValues({
        AuthLocalStorage.manualLoginTimeKey: recentLogin,
      });

      final isExpired = await AuthLocalStorage.isSessionExpired();
      expect(isExpired, isFalse);
    });

    test('Session is expired when manual login occurred > 24 hours ago',
        () async {
      final oldLogin =
          DateTime.now().subtract(const Duration(hours: 25)).toIso8601String();
      FlutterSecureStorage.setMockInitialValues({
        AuthLocalStorage.manualLoginTimeKey: oldLogin,
      });

      final isExpired = await AuthLocalStorage.isSessionExpired();
      expect(isExpired, isTrue);
    });

    test('saveManualLoginDate, getManualLoginDate, and clearManualLoginDate',
        () async {
      FlutterSecureStorage.setMockInitialValues({});

      final now = DateTime.now();
      await AuthLocalStorage.saveManualLoginDate(now);

      final retrieved = await AuthLocalStorage.getManualLoginDate();
      expect(retrieved, isNotNull);
      expect(retrieved!.year, now.year);
      expect(retrieved.month, now.month);
      expect(retrieved.day, now.day);
      expect(retrieved.hour, now.hour);
      expect(retrieved.minute, now.minute);

      await AuthLocalStorage.clearManualLoginDate();
      final cleared = await AuthLocalStorage.getManualLoginDate();
      expect(cleared, isNull);
    });

    test('AuthSessionExpired state instantiates cleanly with message', () {
      final state = AuthSessionExpired(message: 'Session has expired');
      expect(state.message, 'Session has expired');
    });
  });

  group('SessionExpiredDialog Widget Tests', () {
    testWidgets('Renders non-dismissible dialog with confirm action',
        (WidgetTester tester) async {
      bool confirmTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SessionExpiredDialog.show(
                      context,
                      onConfirm: () {
                        confirmTapped = true;
                      },
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      );

      // Tap button to show dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Verify Dialog and elements exist
      expect(find.byType(SessionExpiredDialog), findsOneWidget);
      expect(find.byType(PopScope), findsWidgets);
      expect(find.byIcon(Icons.lock_clock_outlined), findsOneWidget);

      // Verify clicking confirm pops dialog and triggers callback
      final actionButton = find.byType(ElevatedButton).last;
      await tester.tap(actionButton);
      await tester.pumpAndSettle();

      expect(confirmTapped, isTrue);
      expect(find.byType(SessionExpiredDialog), findsNothing);
    });
  });
}
