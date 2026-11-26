import 'package:flutter_test/flutter_test.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/internal_orders_filter/internal_orders_filter.dart';
import 'package:web_admin_san/feature/companies_page/data/model/car_group_model/car_group_model.dart';
import 'package:web_admin_san/feature/companies_page/data/model/get_company_drivers_model/get_company_drivers_model.dart';
import 'package:web_admin_san/feature/companies_page/data/request/get_company_drivers_request/get_company_drivers_request.dart';

void main() {
  group('CarGroupModel Serialization Tests', () {
    test(
        'CarGroupModel deserializes correctly with cars and nested brand/model',
        () {
      final json = {
        'id': 10,
        'name': 'المحاسبين',
        'companyid': 101,
        'companyName': 'شركة الرياض',
        'companyPhone': '+966500000000',
        'cars': [
          {
            'id': 4,
            'plateNo': 'س ث ت 4 4 4',
            'releaseDate': 2022,
            'name': 'كامري',
            'brand': {
              'carBrandId': 1,
              'brandName': 'تويوتا',
              'brandLatinName': 'Toyota',
            },
            'model': {
              'carModelId': 15,
              'modelName': 'كامري',
              'modelLatinName': 'Camry',
            },
          },
          {
            'id': 5,
            'plateNo': '123',
            'releaseDate': 2021,
            'name': 'صني',
            'brand': {
              'carBrandId': 2,
              'brandName': 'نيسان',
              'brandLatinName': 'Nissan',
            },
            'model': {
              'carModelId': 20,
              'modelName': 'صني',
              'modelLatinName': 'Sunny',
            },
          }
        ],
      };

      final group = CarGroupModel.fromJson(json);

      expect(group.id, 10);
      expect(group.name, 'المحاسبين');
      expect(group.companyId, 101);
      expect(group.companyName, 'شركة الرياض');
      expect(group.cars.length, 2);

      final car1 = group.cars[0];
      expect(car1.id, 4);
      expect(car1.plateNo, 'س ث ت 4 4 4');
      expect(car1.brand?.brandName, 'تويوتا');
      expect(car1.brand?.brandLatinName, 'Toyota');
      expect(car1.model?.modelName, 'كامري');

      final car2 = group.cars[1];
      expect(car2.id, 5);
      expect(car2.plateNo, '123');
      expect(car2.brand?.brandName, 'نيسان');
      expect(car2.model?.modelName, 'صني');
    });

    test('CarGroupModel handles empty cars list safely', () {
      final json = {
        'id': 11,
        'name': 'المبيعات',
        'companyid': 101,
        'cars': [],
      };

      final group = CarGroupModel.fromJson(json);

      expect(group.id, 11);
      expect(group.name, 'المبيعات');
      expect(group.cars, isEmpty);
    });

    test('CarGroupModel handles null cars safely', () {
      final json = {
        'id': 12,
        'name': 'الإدارة',
      };

      final group = CarGroupModel.fromJson(json);

      expect(group.id, 12);
      expect(group.cars, isEmpty);
    });
  });

  group('GetCompanyDriversModel Serialization Tests', () {
    test('GetCompanyDriversModel deserializes from data wrapper Map', () {
      final json = {
        'data': [
          {
            'id': 1,
            'companyid': 101,
            'name': 'محمد أحمد',
            'phone': '0555555555',
            'email': 'driver@company.com',
            'isactive': true,
            'car': {
              'id': 4,
              'brandname': 'تويوتا',
              'brandlatinname': 'Toyota',
              'modelname': 'كامري',
              'plateno': '1234',
            },
          },
          {
            'id': 2,
            'companyid': 101,
            'name': 'سائق غير نشط',
            'phone': '0566666666',
            'email': 'inactive@company.com',
            'isactive': false,
          }
        ],
      };

      final model = GetCompanyDriversModel.fromJson(json);

      expect(model.drivers.length, 2);
      expect(model.drivers[0].name, 'محمد أحمد');
      expect(model.drivers[0].isActive, isTrue);
      expect(model.drivers[0].car?.brandName, 'تويوتا');
      expect(model.drivers[0].car?.plateNo, '1234');

      expect(model.drivers[1].name, 'سائق غير نشط');
      expect(model.drivers[1].isActive, isFalse);
      expect(model.drivers[1].car, isNull);
    });

    test('GetCompanyDriversModel deserializes from raw List directly', () {
      final rawList = [
        {
          'id': 3,
          'companyid': 101,
          'name': 'علي خالد',
          'phone': '0577777777',
          'email': 'ali@company.com',
          'isactive': true,
        }
      ];

      final model = GetCompanyDriversModel.fromJson(rawList);

      expect(model.drivers.length, 1);
      expect(model.drivers.first.id, 3);
      expect(model.drivers.first.name, 'علي خالد');
    });

    test('GetCompanyDriversRequest generates correct query parameters', () {
      final reqActiveOnly = GetCompanyDriversRequest(companyId: 101);
      expect(reqActiveOnly.toQueryParams(), {'companyId': 101});

      final reqWithInactive =
          GetCompanyDriversRequest(companyId: 101, includeNotActive: true);
      expect(reqWithInactive.toQueryParams(), {
        'companyId': 101,
        'includeNotActive': true,
      });
    });
  });

  group('Order Tabs & Filter Mapping Tests', () {
    test('mapOrderType maps tabs to backend order types correctly', () {
      expect(mapOrderType(OrdersTabs.all), isNull);
      expect(mapOrderType(OrdersTabs.newOrders), 1);
      expect(mapOrderType(OrdersTabs.inProgress), 2);
      expect(mapOrderType(OrdersTabs.completed), 3);
    });
  });
}
