// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:pingware/constants.dart';
import 'package:pingware/dns_lookup/dns_lookup.dart';
import 'package:pingware/shared/shared_widgets.dart';

class DnsRecordCard extends StatelessWidget {
  const DnsRecordCard(
    this.record, {
    Key? key,
  }) : super(key: key);

  final DnsRecord record;

  @override
  Widget build(BuildContext context) {
    return DataCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${rrCodeToName(record.type).name} Record',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              Text('TTL: ${record.ttl.toString()}'),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              record.name,
              style: Constants.descStyleDark,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.topLeft,
            child: Text(record.data),
          ),
        ],
      ),
    );
  }
}
