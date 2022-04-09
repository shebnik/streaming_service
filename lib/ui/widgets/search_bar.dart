import 'package:flutter/material.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';
import 'package:streaming_service/ui/widgets/app_button.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.textFieldController,
    this.onSubmitted,
  }) : super(key: key);

  final TextEditingController textFieldController;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: AppTheme.grayMiddle,
              borderRadius: BorderRadius.circular(32),
            ),
            child: TextField(
              cursorColor: AppTheme.primaryColor,
              controller: textFieldController,
              textInputAction: TextInputAction.go,
              onSubmitted: onSubmitted,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10.0,
                ),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: () => textFieldController.text = '',
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        AppButton(
          text: 'Search',
          height: 35,
          onPressed: () => textFieldController.text.isNotEmpty
              ? onSubmitted?.call(textFieldController.text)
              : null,
        ),
      ],
    );
  }
}
