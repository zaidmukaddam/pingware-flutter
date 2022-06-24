// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Project imports:
import 'package:pingware/constants.dart';
import 'package:pingware/ip_geo/bloc/ip_geo_bloc.dart';
import 'package:pingware/shared/shared.dart';
import 'package:pingware/utils/utils.dart';

class IpGeoView extends StatefulWidget {
  const IpGeoView({Key? key}) : super(key: key);

  @override
  State<IpGeoView> createState() => _IpGeoViewState();
}

class _IpGeoViewState extends State<IpGeoView> {
  final Completer<GoogleMapController> _controller = Completer();
  final Map<String, Marker> _markers = {};

  late final String _darkModeMapStyle;

  final _targetHostController = TextEditingController();
  String get _target => _targetHostController.text;

  bool _shouldCheckBeActive = false;

  @override
  void initState() {
    super.initState();

    loadDarkModeMapStyle();
  }

  @override
  void dispose() {
    super.dispose();

    _targetHostController.dispose();
    _controller.future.then((ctr) => ctr.dispose());
  }

  Future<void> loadDarkModeMapStyle() async {
    _darkModeMapStyle =
        await rootBundle.loadString('assets/dark_mode_map_style.txt');
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
        title: const Text('IP Geolocation'),
        actions: [
          TextButton(
            onPressed: _shouldCheckBeActive ? _handleCheck : null,
            child: Text(
              'Check',
              style: TextStyle(
                color: _shouldCheckBeActive ? Colors.green : Colors.grey,
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
              border: null,
              largeTitle: const Text('IP Geolocation'),
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
        DomainTextField(
          controller: _targetHostController,
          label: 'IP address (e.g. 1.1.1.1)',
          onChanged: (_) {
            setState(() {
              _shouldCheckBeActive = _target.isNotEmpty;
            });
          },
        ),
        const SizedBox(height: Constants.listSpacing),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: SizedBox(
            height: 300,
            child: GoogleMap(
              markers: _markers.values.toSet(),
              initialCameraPosition: const CameraPosition(target: LatLng(0, 0)),
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

                Theme.of(context).brightness == Brightness.dark
                    ? controller.setMapStyle(_darkModeMapStyle)
                    : controller.setMapStyle(null);
              },
            ),
          ),
        ),
        const SizedBox(height: Constants.listSpacing),
        BlocConsumer<IpGeoBloc, IpGeoState>(
          listener: (context, state) {
            if (state is IpGeoLoadSuccess) {
              _onSuccesfullUpdate(state);
            }
          },
          builder: (context, state) {
            if (state is IpGeoLoadSuccess) {
              return RoundedList(
                children: [
                  ListTextLine(
                    widgetL: const Text('IP'),
                    widgetR: Text(state.ipGeoModel.query ?? 'N/A'),
                  ),
                  ListTextLine(
                    widgetL: const Text('Country'),
                    widgetR: Text(state.ipGeoModel.country ?? 'N/A'),
                  ),
                  ListTextLine(
                    widgetL: const Text('Region'),
                    widgetR: Text(state.ipGeoModel.region ?? 'N/A'),
                  ),
                  ListTextLine(
                    widgetL: const Text('City'),
                    widgetR: Text(state.ipGeoModel.city ?? 'N/A'),
                  ),
                  ListTextLine(
                    widgetL: const Text('Latitude'),
                    widgetR: Text(state.ipGeoModel.lat.toString()),
                  ),
                  ListTextLine(
                    widgetL: const Text('Longitude'),
                    widgetR: Text(state.ipGeoModel.lon.toString()),
                  ),
                  ListTextLine(
                    widgetL: const Text('Timezone'),
                    widgetR: Text(state.ipGeoModel.timezone ?? 'N/A'),
                  ),
                  ListTextLine(
                    widgetL: const Text('Zipcode'),
                    widgetR: Text(state.ipGeoModel.zip ?? 'N/A'),
                  ),
                  ListTextLine(
                    widgetL: const Text('ISP'),
                    widgetR: Text(state.ipGeoModel.isp ?? 'N/A'),
                  ),
                  ListTextLine(
                    widgetL: const Text('Organization'),
                    widgetR: Text(state.ipGeoModel.org ?? 'N/A'),
                  ),
                  ListTextLine(
                    widgetL: const Text('As'),
                    widgetR: Text(state.ipGeoModel.as ?? 'N/A'),
                  ),
                ],
              );
            }

            if (state is IpGeoLoadInProgress) {
              return const LoadingCard();
            }

            if (state is IpGeoLoadFailure) {
              return const ErrorCard(
                message: 'Error while loading the data',
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }

  void _handleCheck() {
    context.read<IpGeoBloc>().add(IpGeoRequested(ip: _target));

    hideKeyboard(context);
  }

  void _onSuccesfullUpdate(IpGeoLoadSuccess state) {
    _controller.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              state.ipGeoModel.lat!,
              state.ipGeoModel.lon!,
            ),
            zoom: 2,
          ),
        ),
      );

      final marker = Marker(
        markerId: MarkerId(state.ipGeoModel.query!),
        position: LatLng(
          state.ipGeoModel.lat!,
          state.ipGeoModel.lon!,
        ),
        infoWindow: InfoWindow(
          title: state.ipGeoModel.query,
          snippet: state.ipGeoModel.country,
        ),
      );

      setState(() {
        _markers[state.ipGeoModel.query!] = marker;
      });
    });
  }
}
