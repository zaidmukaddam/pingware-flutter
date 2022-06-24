// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:pingware/constants.dart';
import 'package:pingware/shared/shared_widgets.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    Key? key,
    this.message,
  }) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return DataCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.circleXmark,
            color: Theme.of(context).colorScheme.error,
            size: 25,
          ),
          const SizedBox(width: 10),
          Text(
            message ?? Constants.defaultError,
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
