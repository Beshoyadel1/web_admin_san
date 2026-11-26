import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';
import 'order_car_services_table_card.dart';
import 'order_customer_card.dart';
import 'order_delivery_card.dart';
import 'order_details_header_section.dart';
import 'order_invoice_breakdown_card.dart';
import 'order_location_map_card.dart';
import 'order_notes_card.dart';
import 'order_provider_card.dart';
import 'order_rates_section_card.dart';
import 'order_rejection_banner_card.dart';
import 'order_status_timeline_card.dart';
import 'order_technicians_card.dart';

class OrderDetailsMainWidget extends StatelessWidget {
  final OrderDetailsModel orderDetails;

  const OrderDetailsMainWidget({
    super.key,
    required this.orderDetails,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDelivery = orderDetails.deliveryOrder != null ||
        (orderDetails.isDeliveryOrder ?? false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth >= 1000;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Section & 4 Summary Metrics StatCards
            OrderDetailsHeaderSection(orderDetails: orderDetails),
            const SizedBox(height: 16),

            // Rejection / Cancellation Reason Banner (if applicable)
            OrderRejectionBannerCard(orderDetails: orderDetails),
            const SizedBox(height: 8),

            // Main Responsive Layout (Desktop 2-Columns vs Compact 1-Column)
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sidebar Column (340px)
                  SizedBox(
                    width: 340,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OrderStatusTimelineCard(orderDetails: orderDetails),
                        const SizedBox(height: 16),
                        OrderCustomerCard(orderDetails: orderDetails),
                        const SizedBox(height: 16),
                        OrderNotesCard(orderDetails: orderDetails),
                        const SizedBox(height: 16),
                        OrderProviderCard(orderDetails: orderDetails),
                        if (hasDelivery) ...[
                          const SizedBox(height: 16),
                          OrderDeliveryCard(orderDetails: orderDetails),
                        ],
                        const SizedBox(height: 16),
                        OrderInvoiceBreakdownCard(orderDetails: orderDetails),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Main Content Column (Expanded)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OrderCarServicesTableCard(orderDetails: orderDetails),
                        const SizedBox(height: 16),
                        OrderTechniciansCard(orderDetails: orderDetails),
                        const SizedBox(height: 16),
                        OrderRatesSectionCard(orderDetails: orderDetails),
                        const SizedBox(height: 16),
                        OrderLocationMapCard(orderDetails: orderDetails),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OrderStatusTimelineCard(orderDetails: orderDetails),
                  const SizedBox(height: 16),
                  OrderCarServicesTableCard(orderDetails: orderDetails),
                  const SizedBox(height: 16),
                  OrderInvoiceBreakdownCard(orderDetails: orderDetails),
                  const SizedBox(height: 16),
                  OrderCustomerCard(orderDetails: orderDetails),
                  const SizedBox(height: 16),
                  OrderNotesCard(orderDetails: orderDetails),
                  const SizedBox(height: 16),
                  OrderProviderCard(orderDetails: orderDetails),
                  const SizedBox(height: 16),
                  OrderTechniciansCard(orderDetails: orderDetails),
                  const SizedBox(height: 16),
                  OrderRatesSectionCard(orderDetails: orderDetails),
                  if (hasDelivery) ...[
                    const SizedBox(height: 16),
                    OrderDeliveryCard(orderDetails: orderDetails),
                  ],
                  const SizedBox(height: 16),
                  OrderLocationMapCard(orderDetails: orderDetails),
                ],
              ),
          ],
        );
      },
    );
  }
}
