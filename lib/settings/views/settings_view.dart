// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:pingware/constants.dart';
import 'package:pingware/package_info/cubit/package_info_cubit.dart';
import 'package:pingware/package_info/views/package_info_view.dart';
import 'package:pingware/shared/shared.dart';
import 'package:pingware/theme/theme.dart';


class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _canLaunchUrl = true;

  @override
  void initState() {
    super.initState();

    context.read<PackageInfoCubit>().fetchPackageInfo();
    canLaunchUrl(Uri.parse(Constants.sourceCodeURL))
        .then((canLaunch) => _canLaunchUrl = canLaunch);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return _buildBody(context);
  }

  CupertinoPageScaffold _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const CupertinoSliverNavigationBar(
            stretch: true,
            border: null,
            largeTitle: Text('Settings'),
          ),
        ],
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final themeBloc = context.read<ThemeBloc>();

    return ContentListView(
      children: [
        const SmallDescription(text: 'Theme settings'),
        DataCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: FlexThemeModeSwitch(
                  themeMode: themeBloc.state.mode,
                  onThemeModeChanged: (mode) {
                    setState(() {
                      themeBloc.add(ThemeModeChangedEvent(themeMode: mode));
                    });
                  },
                  flexSchemeData: Themes
                      .schemesListWithDynamic[themeBloc.state.scheme.index],
                  optionButtonBorderRadius: 10.0,
                ),
              ),
              ThemePopupMenu(
                schemeIndex: themeBloc.state.scheme.index,
                onChanged: (index) async {
                  // Await for popup menu to close (to avoid jank)
                  await Future.delayed(const Duration(milliseconds: 300));

                  setState(() {
                    themeBloc.add(
                      ThemeSchemeChangedEvent(
                        scheme: CustomFlexScheme.values[index],
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
        const SmallDescription(text: 'Help'),
        Column(
          children: [
            const SizedBox(height: Constants.listSpacing),
            ActionCard(
              title: 'Onboarding screen',
              desc: 'Resolve permissions issues',
              icon: Icons.info_outline_rounded,
              onTap: () => Navigator.pushNamed(context, '/introduction'),
            ),
            const SizedBox(height: Constants.listSpacing),
            ActionCard(
              title: 'Source code',
              desc: 'Feel free to contribute!',
              icon: FontAwesomeIcons.github,
              onTap: _canLaunchUrl ? _openSourceCode : null,
            ),
          ],
        ),
        const SizedBox(height: Constants.listSpacing),
        const PackageInfoView(),
      ],
    );
  }


  Future<void> _openSourceCode() async {
    if (!await launchUrl(Uri.parse(Constants.sourceCodeURL))) {
      throw 'Could not launch URL';
    }
  }
}
