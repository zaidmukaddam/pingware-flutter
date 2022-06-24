// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:pingware/constants.dart';
import 'package:pingware/shared/shared_widgets.dart';

class ContentListView extends StatelessWidget {
  const ContentListView({
    required this.children,
    this.scrollController,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) {
        return SingleChildScrollView(
          controller: scrollController,
          child: _buildBody(context),
        );
      },
      iosBuilder: _buildBody,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: Constants.bodyPadding,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: children,
        ),
      ),
    );
  }
}
