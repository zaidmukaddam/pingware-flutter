// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:pingware/shared/cards/cards.dart';
import 'package:pingware/shared/list_circular_progress_indicator.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: const [
          Spacer(),
          ListCircularProgressIndicator(),
          Spacer(),
        ],
      ),
    );
  }
}
