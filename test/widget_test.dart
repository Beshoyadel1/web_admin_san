import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';

void main() {
  testWidgets('App basic theme and color token smoke test',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.scaffoldColor,
          primaryColor: AppColors.orangeColor,
        ),
        home: const Scaffold(
          body: Center(
            child: Text('San Admin Dashboard'),
          ),
        ),
      ),
    );

    expect(find.text('San Admin Dashboard'), findsOneWidget);
  });
}
