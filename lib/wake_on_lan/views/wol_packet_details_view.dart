// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:pingware/shared/shared.dart';
import 'package:pingware/wake_on_lan/models/wol_response_model.dart';
import 'package:pingware/wake_on_lan/widgets/hex_bytes_viewer.dart';

class WolPacketDetailsView extends StatelessWidget {
  const WolPacketDetailsView(this.response, {Key? key}) : super(key: key);

  final WolResponseModel response;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Packet details'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            [
          const CupertinoSliverNavigationBar(
            stretch: true,
            border: null,
            largeTitle: Text('Packet details'),
          ),
        ],
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ContentListView(
      children: [
        RoundedList(
          children: [
            ListTextLine(
              widgetL: const Text('MAC address'),
              widgetR: Text(response.mac.address),
            ),
            ListTextLine(
              widgetL: const Text('IP address'),
              widgetR: Text(response.ipv4.address),
            ),
            HexBytesViewer(
              title: 'Magic packet bytes',
              bytes: response.packetBytes,
            ),
          ],
        ),
      ],
    );
  }
}
