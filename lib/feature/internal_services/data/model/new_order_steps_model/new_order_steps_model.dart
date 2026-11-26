import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_services_statistics/Internal_services_page/widgets/create_new_order.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_services_statistics/Internal_services_page/widgets/processing_request.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_services_statistics/Internal_services_page/widgets/waiting_payment.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class NewOrderStepsModel {
  final String title, date;
  final Widget content;
  final bool isActive;

  NewOrderStepsModel(
      {required this.date,
      required this.isActive,
      required this.title,
      required this.content});
}

final List<NewOrderStepsModel> steps = [
  NewOrderStepsModel(
      title: LocaleKeys.createNewOrderKey,
      content: const CreateNewOrder(
        isProcessingRequest: false,
      ),
      isActive: true,
      date: ''),
  NewOrderStepsModel(
      title: LocaleKeys.orderInProgressKey,
      content: const ProcessingRequest(),
      isActive: false,
      date: ''),
  NewOrderStepsModel(
      title: LocaleKeys.waitingForPaymentKey,
      content: const ProcessingRequest(),
      isActive: false,
      date: ''),
  NewOrderStepsModel(
      title: LocaleKeys.serviceDeliveredKey,
      content: const WaitingPayment(),
      isActive: false,
      date: ''),
];
