// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:pingware/constants.dart';
import 'package:pingware/introduction/introduction.dart';
import 'package:pingware/permissions/permissions.dart';

final List<PageViewModel> pagesList = [
  PageViewModel(
    title: 'Welcome to PingWare!',
    image: SafeArea(
      child: Builder(
        builder: (context) {
          // final isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
          const semanticsLabel = 'PingWare logo';

          return Image.asset(
            'assets/icons/launcher_icon.png',
            semanticLabel: semanticsLabel,
            height: MediaQuery.of(context).size.height * 3,
            width: MediaQuery.of(context).size.width * 3,
          );
        },
      ),
    ),
    decoration: const PageDecoration(
      imagePadding: EdgeInsets.only(top: 40.0, bottom: 10.0),
      bodyFlex: 3,
    ),
    bodyWidget: Column(
      children: const [
        Text(
          Constants.appDesc,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(height: Constants.listSpacing),
        OnboardingFeature(
          icon: Icons.wifi_rounded,
          title: 'WiFi',
          description: 'Explore detailed information about your Wi-Fi network',
        ),
        SizedBox(height: Constants.listSpacing),
        OnboardingFeature(
          icon: Icons.cell_tower_rounded,
          title: 'Carrier',
          description:
              'Explore detailed information about your cellular network',
        ),
        SizedBox(height: Constants.listSpacing),
        OnboardingFeature(
          icon: Icons.settings_rounded,
          title: 'Tools',
          description:
              'Test your networks thanks to various diagnostic tools such as ping, Wake on LAN, LAN Scanner and more',
        ),
      ],
    ),
  ),
  PageViewModel(
    titleWidget: SafeArea(
      child: Builder(
        builder: (context) {
          return Text(
            'Permissions',
            style: Theme.of(context).textTheme.headline6,
          );
        },
      ),
    ),
    useScrollView: false,
    decoration: const PageDecoration(
      titlePadding: EdgeInsets.symmetric(vertical: 16.0),
      contentMargin: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
    ),
    bodyWidget: const Expanded(child: PermissionsView()),
    footer: Align(
      alignment: Alignment.bottomCenter,
      child: TextButton(
        child: const Text('Open app settings'),
        onPressed: () {
          openAppSettings();
        },
      ),
    ),
  ),
];
