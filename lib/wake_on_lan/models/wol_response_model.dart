// Package imports:
import 'package:wake_on_lan/wake_on_lan.dart';

// Project imports:
import 'package:pingware/wake_on_lan/wake_on_lan.dart';

class WolResponseModel {
  WolResponseModel(this.ipv4, this.mac, this.packetBytes, this.status);

  final IPv4Address ipv4;
  final MACAddress mac;
  final List<int> packetBytes;
  final WolStatus status;
}
