// ignore_for_file: use_build_context_synchronously

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:pingware/lan_scanner/bloc/lan_scanner_bloc.dart';
import 'package:pingware/lan_scanner/widgets/host_card.dart';
import 'package:pingware/models/animated_list_model.dart';
import 'package:pingware/shared/action_app_bar.dart';
import 'package:pingware/shared/content_list_view.dart';
import 'package:pingware/shared/cupertino_action_app_bar.dart';
import 'package:pingware/shared/shared_widgets.dart';

class LanScannerView extends StatefulWidget {
  const LanScannerView({Key? key}) : super(key: key);

  @override
  _LanScannerViewState createState() => _LanScannerViewState();
}

class _LanScannerViewState extends State<LanScannerView> {
  final _appBarKey = GlobalKey<ActionAppBarState>();
  final _listKey = GlobalKey<AnimatedListState>();
  late final AnimatedListModel<InternetAddress> _hosts;
  late final LanScannerBloc _bloc;

  double currProgress = 0.0;

  @override
  void initState() {
    super.initState();

    _hosts =
        AnimatedListModel(listKey: _listKey, removedItemBuilder: _buildItem);
    _bloc = context.read<LanScannerBloc>();
  }

  @override
  void dispose() {
    super.dispose();

    _bloc.add(LanScannerStopped());
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
      appBar: ActionAppBar(
        title: 'LAN Scanner',
        isActive: true,
        onStartPressed: _handleStart,
        onStopPressed: _handleStop,
        key: _appBarKey,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          BlocBuilder<LanScannerBloc, LanScannerState>(
            builder: (context, state) {
              return state is LanScannerRunStart ||
                      state is LanScannerRunProgressUpdate
                  ? CupertinoActionAppBar(
                      context,
                      title: 'Ping',
                      action: ButtonAction.stop,
                      isActive: true,
                      onPressed: _handleStop,
                    )
                  : CupertinoActionAppBar(
                      context,
                      title: 'Ping',
                      action: ButtonAction.start,
                      isActive: true,
                      onPressed: _handleStart,
                    );
            },
          ),
        ],
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return ContentListView(
      children: [
        BlocConsumer<LanScannerBloc, LanScannerState>(
          listener: (context, state) {
            if (state is LanScannerRunProgressUpdate) {
              currProgress = state.progress;
            }

            if (state is LanScannerRunComplete) {
              _appBarKey.currentState!.toggleAnimation();
            }

            if (state is LanScannerRunNewHost) {
              final host = InternetAddress(state.host.ip);

              _hosts.insert(_hosts.length, host);
            }
          },
          buildWhen: (previous, current) =>
              current is LanScannerRunProgressUpdate,
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: LinearProgressIndicator(
                      // TODO: animate progress
                      value: currProgress,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text('${(currProgress * 100).toInt()}%'),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        AnimatedList(
          key: _listKey,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          initialItemCount: _hosts.length,
          itemBuilder: (context, index, animation) {
            return _buildItem(
              context,
              animation,
              _hosts[index],
            );
          },
        ),
      ],
    );
  }

  FadeTransition _buildItem(
    BuildContext context,
    Animation<double> animation,
    InternetAddress item,
  ) {
    return FadeTransition(
      opacity: animation.drive(_hosts.fadeTween),
      child: SlideTransition(
        position: animation.drive(_hosts.slideTween),
        child: HostCard(item: item),
      ),
    );
  }

  void _handleStop() {
    context.read<LanScannerBloc>().add(LanScannerStopped());
  }

  Future<void> _handleStart() async {
    await _hosts.removeAllElements(context);

    context.read<LanScannerBloc>().add(LanScannerStarted());

    await Future.delayed(Duration.zero);
  }
}
