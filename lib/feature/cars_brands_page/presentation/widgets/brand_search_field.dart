import 'package:flutter/material.dart';

import '../../../../core/helpers/colors/app_colors.dart';

class BrandSearchField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const BrandSearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.onClear,
  });

  @override
  State<BrandSearchField> createState() => _BrandSearchFieldState();
}

class _BrandSearchFieldState extends State<BrandSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged('');
    widget.onClear?.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.greyColorSearch,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.cardStroke,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            size: 20,
            color: AppColors.darkGreyColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (val) {
                setState(() {});
                widget.onChanged(val);
              },
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkColor,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: AppColors.darkGreyColor,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _handleClear,
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.darkGreyColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
