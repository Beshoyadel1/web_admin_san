import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';

class ReadOnlyImageCard extends StatelessWidget {
  final String title;
  final Uint8List? image;

  const ReadOnlyImageCard({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Column(
        children: [
          GestureDetector(
            onTap: image == null
                ? null
                : () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  child: InteractiveViewer(
                    child: Image.memory(image!),
                  ),
                ),
              );
            },
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey.shade200,
              backgroundImage:
              image != null ? MemoryImage(image!) : null,
              child: image == null
                  ? const Icon(
                Icons.image_not_supported_outlined,
                size: 28,
                color: Colors.grey,
              )
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          TextInAppWidget(
            text: title,
            textSize: 13,
            textColor: AppColors.blackColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}