import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/providers_page/data/model/facility_provider_model/get_provider_branches_model/provider_branch_model.dart';
import 'package:web_admin_san/feature/providers_page/data/model/facility_provider_model/upload_provider_work_times_model/work_time_model.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/branches_providers/screens/branch_card_item.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/branches_providers/screens/branch_details_dialog.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/working_hours_providers/screens/work_time_shift_card.dart';

void main() {
  group('Branches & Work Times Redesign Tests', () {
    testWidgets(
        'WorkTimeShiftCard renders shift time and active day chips without overflow',
        (tester) async {
      final shift = WorkTimeModel(
        worktimeid: 1,
        provid: 101,
        fromTime: "08:00:00",
        toTime: "22:00:00",
        sat: true,
        sun: true,
        mon: true,
        tue: true,
        wed: true,
        thr: true,
        fri: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 500,
              child: WorkTimeShiftCard(
                shift: shift,
                shiftIndex: 1,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(WorkTimeShiftCard), findsOneWidget);
      expect(find.text('#1'), findsOneWidget);
      // Active days chips render check icons (6 active days)
      expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(6));
    });

    testWidgets(
        'BranchCardItem renders branch details and triggers onViewDetails callback',
        (tester) async {
      bool detailsClicked = false;
      final branch = ProviderBranchModel(
        branchId: 42,
        branchName: 'Main Branch',
        branchLatinName: 'Main Branch',
        addressText: 'King Fahd Road, Riyadh',
        nationalAddress: 'RRRR1111',
        lat: 24.6561,
        long: 46.7275,
        isActive: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 450,
              height: 250,
              child: BranchCardItem(
                branch: branch,
                onViewDetails: () {
                  detailsClicked = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Main Branch'), findsOneWidget);
      expect(find.text('King Fahd Road, Riyadh'), findsOneWidget);
      expect(find.text(LocaleKeys.branchActiveStatus.tr()), findsOneWidget);

      // Tap on View details button
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(detailsClicked, isTrue);
    });

    testWidgets('BranchDetailsDialog renders branch details in AlertDialog',
        (tester) async {
      final branch = ProviderBranchModel(
        branchId: 99,
        branchName: 'فرع العليا',
        branchLatinName: 'Olaya Branch',
        addressText: 'طريق الملك فهد، العليا',
        nationalAddress: 'OLAY1234',
        lat: 24.7136,
        long: 46.6753,
        isActive: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => BranchDetailsDialog(branch: branch),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('فرع العليا'), findsWidgets);
      expect(find.text('Olaya Branch'), findsOneWidget);
      expect(find.text('OLAY1234'), findsOneWidget);
      expect(find.text('طريق الملك فهد، العليا'), findsOneWidget);
      expect(find.text('#99'), findsOneWidget);

      // Verify close button dismisses dialog
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
