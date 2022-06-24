// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:pingware/shared/shared.dart';

class DomainTextField extends StatelessWidget {
  const DomainTextField({
    required this.controller,
    required this.label,
    this.enabled,
    this.expands = false,
    this.errorText,
    this.keyboardType,
    this.suffixIcon,
    this.withoutPrefixIcon = false,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final bool? enabled;
  final bool expands;
  final String? errorText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool withoutPrefixIcon;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) {
        return TextField(
          autocorrect: false,
          controller: controller,
          decoration: InputDecoration(
            errorText: errorText,
            labelText: label,
            prefixIcon: withoutPrefixIcon
                ? null
                : const Icon(
                    Icons.language_rounded,
                  ),
            suffixIcon: suffixIcon,
          ),
          expands: expands,
          maxLines: expands ? null : 1,
          onChanged: onChanged,
        );
      },
      iosBuilder: (context) {
        return CupertinoSearchTextField(
          autocorrect: false,
          controller: controller,
          placeholder: label,
          enabled: enabled,
          onChanged: onChanged,
        );
      },
    );
  }
}
