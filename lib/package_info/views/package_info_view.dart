// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:pingware/package_info/package_info.dart';
import 'package:pingware/shared/cards/cards.dart';
import 'package:pingware/shared/list_text_line.dart';
import 'package:pingware/shared/rounded_list.dart';

class PackageInfoView extends StatelessWidget {
  const PackageInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackageInfoCubit, PackageInfoState>(
      builder: (context, state) {
        if (state is PackageInfoLoadInProgress) {
          return const LoadingCard();
        }

        if (state is PackageInfoLoadSuccess) {
          return RoundedList(
            header: 'About',
            footer: 'Made with ❤️ by Zaid',
            children: [
              ListTextLine(
                widgetL: const Text('App name'),
                widgetR: Text(state.packageInfo.appName),
              ),
              ListTextLine(
                widgetL: const Text('Version'),
                widgetR: Text(state.packageInfo.version),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
