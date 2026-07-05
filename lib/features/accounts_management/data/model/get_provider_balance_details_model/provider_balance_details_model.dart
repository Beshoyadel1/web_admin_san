import 'package:web_admin_san/features/accounts_management/data/model/get_provider_balance_details_model/recent_order_model.dart';

class ProviderBalanceDetailsModel {
  final double totalBalance;
  final double electronicBalance;
  final double cashBalance;
  final List<RecentOrderModel> recentOrders;

  ProviderBalanceDetailsModel({
    required this.totalBalance,
    required this.electronicBalance,
    required this.cashBalance,
    required this.recentOrders,
  });

  factory ProviderBalanceDetailsModel.fromJson(
      Map<String, dynamic> json) {

    final data = json['data'];

    return ProviderBalanceDetailsModel(
      totalBalance: (data['totalBalance'] ?? 0).toDouble(),

      electronicBalance:
      (data['electronicBalance'] ?? 0).toDouble(),

      cashBalance:
      (data['cashBalance'] ?? 0).toDouble(),

      recentOrders:
      (data['recentOrders'] as List<dynamic>?)
          ?.map((e) => RecentOrderModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}