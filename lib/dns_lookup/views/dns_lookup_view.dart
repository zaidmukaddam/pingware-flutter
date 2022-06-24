// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:pingware/constants.dart';
import 'package:pingware/dns_lookup/dns_lookup.dart';
import 'package:pingware/dns_lookup/widgets/dns_record_card.dart';
import 'package:pingware/shared/shared.dart';
import 'package:pingware/utils/utils.dart';

class DnsLookupView extends StatefulWidget {
  const DnsLookupView({Key? key}) : super(key: key);

  @override
  _DnsLookupViewState createState() => _DnsLookupViewState();
}

class _DnsLookupViewState extends State<DnsLookupView> {
  final _targetDomainController = TextEditingController();
  String get _target => _targetDomainController.text;

  RrCodeName _selectedDnsQueryType = RrCodeName.ANY;

  bool _shouldCheckButtonBeActive = false;

  @override
  void initState() {
    super.initState();
  }

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
        title: const Text('DNS Lookup'),
        actions: [
          TextButton(
            onPressed: _shouldCheckButtonBeActive ? _handleCheck : null,
            child: Text(
              'Check',
              style: TextStyle(
                color: _shouldCheckButtonBeActive ? Colors.green : Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              largeTitle: const Text('DNS Lookup'),
              border: null,
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _handleCheck,
                child: Text(
                  'Check',
                  style: TextStyle(
                    color: CupertinoDynamicColor.resolve(
                      CupertinoColors.activeGreen,
                      context,
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return ContentListView(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                flex: 3,
                child: DomainTextField(
                  label: 'Domain',
                  controller: _targetDomainController,
                  expands: true,
                  onChanged: (_) {
                    setState(() {
                      _shouldCheckButtonBeActive = _target.isNotEmpty;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: DropdownButtonFormField<RrCodeName>(
                  items: _getQueryTypes(),
                  value: _selectedDnsQueryType,
                  hint: const Text('Type'),
                  icon: const Icon(Icons.arrow_downward_rounded),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  isExpanded: true,
                  onChanged: (type) {
                    setState(() {
                      _selectedDnsQueryType = type!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Constants.listSpacing),
        BlocBuilder<DnsLookupBloc, DnsLookupState>(
          builder: (context, state) {
            if (state is DnsLookupLoadInProgress) {
              return const LoadingCard();
            }

            if (state is DnsLookupLoadFailure) {
              return const ErrorCard(
                message: 'Failed to load data',
              );
            }

            if (state is DnsLookupLoadSuccess) {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Found ${state.response.answer.length} records',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  const SizedBox(height: Constants.listSpacing),
                  _buildRecords(state.response),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }

  void _handleCheck() {
    final queryCode = nameToRrCode(_selectedDnsQueryType);

    context
        .read<DnsLookupBloc>()
        .add(DnsLookupRequested(hostname: _target, type: queryCode));

    hideKeyboard(context);
  }

  List<DropdownMenuItem<RrCodeName>> _getQueryTypes() {
    return RrCodeName.values.map((type) {
      return DropdownMenuItem(
        value: type,
        child: Text(type.name),
      );
    }).toList();
  }

  Widget _buildRecords(DnsLookupResponse response) {
    return LiveList(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: response.answer.length,
      itemBuilder: (context, index, animation) {
        final record = response.answer[index];

        return FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.5),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.ease)).animate(animation),
            child: DnsRecordCard(record),
          ),
        );
      },
    );
  }
}
