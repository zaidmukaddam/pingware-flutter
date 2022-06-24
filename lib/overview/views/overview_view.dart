// Flutter imports:
import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:pingware/constants.dart';
import 'package:pingware/network_status/bloc/bloc.dart';
import 'package:pingware/network_status/views/views.dart';
import 'package:pingware/overview/overview.dart';
import 'package:pingware/shared/shared.dart';

class OverviewView extends StatefulWidget {
  const OverviewView({Key? key}) : super(key: key);

  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  @override
  void initState() {
    super.initState();

    Permission.location.isGranted.then((bool isGranted) {
      if (!isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          Constants.permissionDeniedSnackbar,
        );
      }
    });

    context.read<NetworkStatusBloc>().add(NetworkStatusStreamStarted());
    context.read<NetworkStatusBloc>().add(NetworkStatusExtIPRequested());
  }

  @override
  void dispose() {
    super.dispose();
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
            largeTitle: Text('Overview'),
          ),
        ],
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<NetworkStatusBloc, NetworkStatusState>(
      builder: (context, state) {
        return ContentListView(
          children: [
            const SmallDescription(text: 'Networks', leftPadding: 8.0),
            const WifiStatusCard(),
            const SizedBox(height: Constants.listSpacing),
            const CarrierStatusCard(),
            const SizedBox(height: Constants.listSpacing),
            const SmallDescription(text: 'Utilities', leftPadding: 8.0),
            ToolCard(
              toolName: 'Ping',
              toolDesc: Constants.pingDesc,
              onPressed: () =>
                  Navigator.pushNamed(context, '/tools/ping', arguments: ''),
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'LAN Scanner',
              toolDesc: Constants.lanScannerDesc,
              onPressed: state.isWifiConnected
                  ? () => Navigator.pushNamed(context, '/tools/lan')
                  : () => Constants.wifistatus.show(context),
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'Wake On LAN',
              toolDesc: Constants.wolDesc,
              onPressed: state.isWifiConnected
                  ? () => Navigator.pushNamed(context, '/tools/wol')
                  : () => Constants.wifistatus.show(context),
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'IP Geolocation',
              toolDesc: Constants.ipGeoDesc,
              onPressed: () => Navigator.pushNamed(context, '/tools/ip_geo'),
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'Whois',
              toolDesc: Constants.whoisDesc,
              onPressed: () => Navigator.pushNamed(context, '/tools/whois'),
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'DNS Lookup',
              toolDesc: Constants.dnsDesc,
              onPressed: () =>
                  Navigator.pushNamed(context, '/tools/dns_lookup'),
            ),
            const SizedBox(height: Constants.listSpacing),
            // if (kDebugMode) const DebugSection(),
          ],
        );
      },
    );
  }
}
