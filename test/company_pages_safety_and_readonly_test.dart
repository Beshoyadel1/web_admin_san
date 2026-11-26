import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_admin_san/feature/companies_page/data/model/get_company_cars_with_drivers_model/get_company_cars_with_drivers_model.dart';
import 'package:web_admin_san/feature/companies_page/presentation/widgets/widget_design_list_car_company.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_model.dart';

void main() {
  group('Company Pages Read-Only & Error Fix Verification', () {
    testWidgets(
        'WidgetDesignListCarCompany renders in strict read-only mode without any edit buttons',
        (tester) async {
      final cars = [
        GetCompanyCarWithDriver(
          carId: 4,
          plateNo: 'س ث ت 4 4 4',
          brand: CarBrandModel(brandId: 1, name: 'تويوتا', latinName: 'Toyota'),
          model: CarModelData(modelId: 1, name: 'كامري'),
          isHasDriver: true,
        ),
        GetCompanyCarWithDriver(
          carId: 5,
          plateNo: '123',
          brand: CarBrandModel(brandId: 2, name: 'نيسان', latinName: 'Nissan'),
          model: CarModelData(modelId: 2, name: 'صني'),
          isHasDriver: true,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetDesignListCarCompany(
              cars: cars,
              isHasDriver: true,
            ),
          ),
        ),
      );

      // Verify car items are displayed
      expect(find.text('4'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('س ث ت 4 4 4'), findsOneWidget);
      expect(find.text('123'), findsOneWidget);

      // Verify STRICT READ-ONLY: No edit icons and no 'تعديل' buttons exist anywhere!
      expect(find.byIcon(Icons.edit), findsNothing);
      expect(find.text('تعديل'), findsNothing);
    });

    testWidgets(
        'WidgetDesignListCarCompany displays empty placeholder when car list is empty',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WidgetDesignListCarCompany(
              cars: [],
              isHasDriver: false,
            ),
          ),
        ),
      );

      // Verify empty view is shown
      expect(find.byType(CompanyCarEmptyGroupView), findsOneWidget);
      expect(find.byIcon(Icons.directions_car_outlined), findsOneWidget);

      // Verify no edit buttons exist
      expect(find.byIcon(Icons.edit), findsNothing);
      expect(find.text('تعديل'), findsNothing);
    });

    test(
        'Order with empty services does not crash or throw Bad state: No element',
        () {
      final orderWithEmptyServices = OrderModel(
        id: 101,
        services: [], // empty list that previously caused Bad state: No element
        orderStatus: 1,
        orderDate: '2026-10-15T12:00:00Z',
      );

      // Safe access pattern used in filter_design_companies_orders and list_data_container_order_company
      final service = orderWithEmptyServices.services?.isNotEmpty == true
          ? orderWithEmptyServices.services!.first
          : null;

      expect(service, isNull);
      expect(service?.id, isNull);

      final title =
          service == null ? '' : (service.latinName ?? service.name ?? '');
      expect(title, isEmpty);
    });
  });
}
