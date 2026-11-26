import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'create_new_order.dart';

class ProcessingRequest extends StatelessWidget {
  const ProcessingRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return const CreateNewOrder(
        textButton: LocaleKeys.orderCompletionKey, isProcessingRequest: true);
  }
}
