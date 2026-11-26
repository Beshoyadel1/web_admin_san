import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_all_harage_model/chat_harag_model.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_all_harage_model/harage_data.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/request/change_harage_status_request/change_harage_status_request.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/request/get_all_harages_request/get_all_harages_request.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/request/get_user_harages_request/get_user_harages_request.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/harag_filter_tabs_widget.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/harag_messages_panel_widget.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/harag_status_dropdown_widget.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/harage_chat_dialog.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/widget_design_list_harag.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_cubit.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

void main() {
  group('Haraj Filter Tabs Tests', () {
    testWidgets('HaragFilterTabsWidget renders all 4 tabs and responds to tap',
        (tester) async {
      HaragFilterTab selected = HaragFilterTab.all;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HaragFilterTabsWidget(
              selectedTab: selected,
              onTabChanged: (tab) {
                selected = tab;
              },
            ),
          ),
        ),
      );

      expect(find.text(LocaleKeys.allCars.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.newCars.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.usedCars.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.soldCars.tr()), findsOneWidget);

      await tester.tap(find.text(LocaleKeys.newCars.tr()));
      await tester.pumpAndSettle();

      expect(selected, HaragFilterTab.newCars);

      await tester.tap(find.text(LocaleKeys.soldCars.tr()));
      await tester.pumpAndSettle();

      expect(selected, HaragFilterTab.soldCars);
    });
  });

  group('Haraj Item Card Tests', () {
    testWidgets(
        'WidgetDesignListHarag renders correct labels and status badges',
        (tester) async {
      bool detailsTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetDesignListHarag(
              haragId: '42',
              name: 'محمد خالد',
              kilometers: '45000',
              releaseDate: '2023',
              isNew: false,
              status: 1, // نشط
              onTabDetails: () {
                detailsTapped = true;
              },
            ),
          ),
        ),
      );

      // Verify label "المعرف" and ID
      expect(find.text(LocaleKeys.identifier.tr()), findsOneWidget);
      expect(find.text('42'), findsOneWidget);

      // Verify label "حالة السيارة" and condition "مستعملة"
      expect(find.text(LocaleKeys.carCondition.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.usedCar.tr()), findsOneWidget);

      // Verify label "الحالة" and status "نشط"
      expect(find.text(LocaleKeys.status.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.active.tr()), findsOneWidget);

      // Verify user name and kilometers
      expect(find.text('محمد خالد'), findsOneWidget);
      expect(find.text('45000'), findsOneWidget);

      // Verify details button tap
      await tester.tap(find.text(LocaleKeys.details.tr()));
      await tester.pumpAndSettle();
      expect(detailsTapped, isTrue);
    });

    testWidgets('WidgetDesignListHarag renders "تم البيع" for sold status (3)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WidgetDesignListHarag(
              haragId: '99',
              name: 'علي حسن',
              kilometers: '10000',
              releaseDate: '2024',
              isNew: true,
              status: 3, // تم البيع
            ),
          ),
        ),
      );

      expect(find.text(LocaleKeys.newCar.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.sold.tr()), findsOneWidget);
    });

    testWidgets('WidgetDesignListHarag renders "معلق" for suspended status (2)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WidgetDesignListHarag(
              haragId: '100',
              name: 'خالد',
              status: 2, // معلق
            ),
          ),
        ),
      );

      expect(find.text(LocaleKeys.pending.tr()), findsOneWidget);
    });

    testWidgets('WidgetDesignListHarag renders "محذوف" for deleted status (4)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WidgetDesignListHarag(
              haragId: '101',
              name: 'سالم',
              status: 4, // محذوف
            ),
          ),
        ),
      );

      expect(find.text(LocaleKeys.deleted.tr()), findsOneWidget);
    });
  });

  group('Haraj Details Status Dropdown Tests', () {
    testWidgets(
        'HaragStatusDropdownWidget displays current status and dropdown items',
        (tester) async {
      final cubit = HaragCubit();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: const HaragStatusDropdownWidget(
                harageId: 55,
                currentStatus: 1, // نشط
              ),
            ),
          ),
        ),
      );

      expect(find.text(LocaleKeys.active.tr()), findsOneWidget);

      // Open dropdown
      await tester.tap(find.byType(DropdownButton<int>));
      await tester.pumpAndSettle();

      // Changeable status pending should be visible in dropdown
      expect(find.text(LocaleKeys.pending.tr()), findsOneWidget);
    });
  });

  group('Haraj Chat Dialog & Request Tests', () {
    test(
        'GetAllHaragesRequest and GetUserHaragesRequest serialize includeSuspended',
        () {
      final req1 = GetAllHaragesRequest(
        pageNumber: 1,
        includeSuspended: false,
      );
      expect(req1.toJson()['includeSuspended'], false);

      final req2 = GetUserHaragesRequest(
        userId: 10,
        userType: 1,
        pageNumber: 1,
        includeSuspended: true,
      );
      expect(req2.toJson()['includeSuspended'], true);
    });

    testWidgets(
        'HarageChatDialog renders cleanly inside BlocProvider without throwing',
        (tester) async {
      final cubit = HaragCubit();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: const HarageChatDialog(
                harageId: 42,
                title: 'تويوتا كامري 2024',
              ),
            ),
          ),
        ),
      );

      expect(find.text('تويوتا كامري 2024'), findsOneWidget);
      expect(find.text(LocaleKeys.haragMessagesSubtitle.tr()), findsOneWidget);
    });

    test('ChangeHarageStatusRequest properly serializes notes', () {
      final req = ChangeHarageStatusRequest(
        harageId: 10,
        status: 2, // Suspended
        notes: 'مخالف لشروط النشر',
      );

      final json = req.toJson();
      expect(json['harageid'], 10);
      expect(json['status'], 2);
      expect(json['notes'], 'مخالف لشروط النشر');
    });

    testWidgets('HaragMessagesPanelWidget renders empty state when no messages',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HaragMessagesPanelWidget(
              harage: HarageData(id: 1, chats: []),
            ),
          ),
        ),
      );

      expect(find.text(LocaleKeys.messagesTitle.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.noMessagesForCar.tr()), findsOneWidget);
    });

    testWidgets('HaragMessagesPanelWidget renders message items with badges',
        (tester) async {
      final chats = [
        ChatHaragModel(
          lastMessage: 'كام السوم من فضلك',
          lastMessageDate: DateTime(2025, 1, 2, 18, 0),
          notViewedCount: 5,
        ),
        ChatHaragModel(
          lastMessage: 'هلا حبيبنا',
          lastMessageDate: DateTime(2025, 1, 2, 18, 0),
          notViewedCount: null,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HaragMessagesPanelWidget(
              harage: HarageData(id: 1, chats: chats),
            ),
          ),
        ),
      );

      expect(find.text(LocaleKeys.messagesTitle.tr()), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // Total items counter in header
      expect(find.text('كام السوم من فضلك'), findsOneWidget);
      expect(find.text('هلا حبيبنا'), findsOneWidget);
      expect(find.text('5'), findsOneWidget); // Unread badge on first item
    });
  });
}
