// Flutter imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:pingware/dns_lookup/dns_lookup.dart';
import 'package:pingware/introduction/introduction.dart';
import 'package:pingware/ip_geo/ip_geo.dart';
import 'package:pingware/lan_scanner/lan_scanner.dart';
import 'package:pingware/network_status/network_status.dart';
import 'package:pingware/ping/ping.dart';
import 'package:pingware/wake_on_lan/wake_on_lan.dart';
import 'package:pingware/whois/whois.dart';

abstract class Constants {
  static const String appName = 'PingWare';
  static const String appDesc = '''
PingWare is a network diagnostics
  tool equipped with various
      useful utilities.
      ''';
  static const String sourceCodeURL =
      'https://github.com/zaidmukaddam/pingware-flutter';

  static const String usageDesc = 'We never share this data with anyone.';

  static final Map<String, Widget Function(BuildContext)> routes = {
    '/introduction': (context) => IntroductionScreen(
          pages: pagesList,
          isTopSafeArea: true,
          isBottomSafeArea: true,
          controlsPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).padding.bottom,
            horizontal: 16.0,
          ),
          done: const Text('Done'),
          next: const Icon(Icons.navigate_next),
          onDone: () => Navigator.of(context).pop(),
          dotsDecorator: DotsDecorator(
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ),
    '/wifi': (context) => const WifiDetailedView(),
    '/carrier': (context) => const CarrierDetailView(),
    '/tools/ping': (context) => const PingView(),
    '/tools/lan': (context) => const LanScannerView(),
    '/tools/wol': (context) => const WakeOnLanView(),
    '/tools/ip_geo': (context) => const IpGeoView(),
    '/tools/whois': (context) => const WhoisView(),
    '/tools/dns_lookup': (context) => const DnsLookupView(),
  };

  // Styles
  static const EdgeInsets listPadding = EdgeInsets.all(10.0);

  static const EdgeInsets bodyPadding = EdgeInsets.all(10.0);

  static const double listSpacing = 10.0;

  static const double linearProgressWidth = 50.0;

  static const Divider listDivider = Divider(
    height: 0.0,
    indent: 12.0,
    endIndent: 0.0,
  );

  // Description styles
  static final TextStyle descStyleLight = TextStyle(
    color: Colors.grey[600],
  );

  static final TextStyle descStyleDark = TextStyle(
    color: Colors.grey[400],
  );

  // Tools descriptions
  static const String pingDesc =
      'Send ICMP pings to specific IP address or domain';

  static const String lanScannerDesc =
      'Discover network devices in the local network';

  static const String wolDesc = 'Send magic packets on your local network';

  static const String ipGeoDesc =
      'Get the geolocation of a specific IP address';

  static const String whoisDesc = 'Lookup information about a specific domain';

  static const String dnsDesc = 'Lookup DNS records of a specific domain';

  // Error descriptions
  static const String defaultError = "Couldn't read the data";

  static const String simError = 'No SIM card';

  static const String noReplyError = 'No reply received from the host';

  static const String unknownError = 'Unknown error';

  static const String unknownHostError = 'Unknown host';

  static const String requestTimedOutError = 'Request timed out';

  // Permissions descriptions
  static const String locationPermissionDesc =
      'We need your location permission in order to access Wi-Fi information';

  static const String phoneStatePermissionDesc =
      'We need your phone permission in order to access carrier information';

  // Permissions snackbars
  static const String _permissionGranted = 'Permission granted!';

  static const String _permissionDenied =
      '''Permission denied, the app may not function properly, check the app's settings''';

  static const String _permissionDefault =
      'Something gone wrong, check app permissions';

  static final SnackBar permissionGrantedSnackbar = SnackBar(
    content: Row(
      children: const [
        Icon(Icons.check_circle_rounded, color: Colors.green),
        SizedBox(width: 10.0),
        Expanded(child: Text(_permissionGranted)),
      ],
    ),
  );

  static final SnackBar permissionDeniedSnackbar = SnackBar(
    content: Row(
      children: const [
        Icon(Icons.error_rounded, color: Colors.red),
        SizedBox(width: 10.0),
        Expanded(child: Text(_permissionDenied)),
      ],
    ),
    action: SnackBarAction(
      label: 'Open settings',
      onPressed: () => openAppSettings(),
    ),
  );

  static final SnackBar permissionDefaultSnackbar = SnackBar(
    content: Row(
      children: const [
        Icon(Icons.warning_rounded, color: Colors.orange),
        SizedBox(width: 10.0),
        Expanded(child: Text(_permissionDefault)),
      ],
    ),
    action: SnackBarAction(
      label: 'Open settings',
      onPressed: () => openAppSettings(),
    ),
  );

  static final ElegantNotification permissionGrantedNotification =
      ElegantNotification.success(
    title: const Text('Success'),
    description: const Text(_permissionGranted),
    dismissible: true,
    notificationPosition: NotificationPosition.bottom,
    animation: AnimationType.fromBottom,
  );

  static final ElegantNotification permissionDeniedNotification =
      ElegantNotification.error(
    title: const Text('Error'),
    description: const Text(_permissionDenied),
    dismissible: true,
    notificationPosition: NotificationPosition.bottom,
    animation: AnimationType.fromBottom,
    toastDuration: const Duration(milliseconds: 4000),
    height: 140.0,
    action: const Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        'Open Settings',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    ),
    onActionPressed: () {
      openAppSettings();
    },
  );

  static final ElegantNotification permissionDefaultNotification =
      ElegantNotification.error(
    title: const Text('Warning'),
    description: const Text(_permissionDefault),
    dismissible: true,
    notificationPosition: NotificationPosition.bottom,
    animation: AnimationType.fromBottom,
  );

  static final ElegantNotification wifistatus = ElegantNotification.info(
    height: 100.0,
    width: double.infinity,
    title:
        const Text('Wi-Fi Disconnected', style: TextStyle(color: Colors.blue)),
    description: const Text(
      'Connect to a Wi-Fi network to use this feature',
      style: TextStyle(color: Colors.blueGrey),
    ),
    dismissible: true,
    notificationPosition: NotificationPosition.bottom,
    animation: AnimationType.fromBottom,
    background: FlexColor.aquaBlueDarkPrimaryContainer,
  );
}
