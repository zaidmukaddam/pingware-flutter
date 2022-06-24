// ignore_for_file: use_build_context_synchronously

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:pingware/constants.dart';
import 'package:pingware/permissions/bloc/permissions_bloc.dart';
import 'package:pingware/permissions/widgets/usage_desc.dart';
import 'package:pingware/permissions/widgets/widgets.dart';
import 'package:pingware/shared/shared.dart';

class PermissionsView extends StatefulWidget {
  const PermissionsView({Key? key}) : super(key: key);

  @override
  State<PermissionsView> createState() => _PermissionsViewState();
}

class _PermissionsViewState extends State<PermissionsView> {
  @override
  void initState() {
    super.initState();

    context
        .read<PermissionsBloc>()
        .add(const PermissionsStatusRefreshRequested());
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<PermissionsBloc, PermissionsState>(
      listener: (context, state) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        if (state.latestRequested == Permission.locationWhenInUse) {
          if (state.locationStatus == PermissionStatus.granted) {
            scaffoldMessenger.showSnackBar(
              Constants.permissionGrantedSnackbar,
            );
          } else if (state.locationStatus ==
              PermissionStatus.permanentlyDenied) {
            scaffoldMessenger.showSnackBar(
              Constants.permissionDeniedSnackbar,
            );
          } else {
            scaffoldMessenger.showSnackBar(
              Constants.permissionDefaultSnackbar,
            );
          }
        }

        if (state.latestRequested == Permission.phone) {
          if (state.phoneStateStatus == PermissionStatus.granted) {
            scaffoldMessenger.showSnackBar(
              Constants.permissionGrantedSnackbar,
            );
          } else if (state.phoneStateStatus ==
              PermissionStatus.permanentlyDenied) {
            scaffoldMessenger.showSnackBar(
              Constants.permissionDeniedSnackbar,
            );
          } else {
            scaffoldMessenger.showSnackBar(
              Constants.permissionDefaultSnackbar,
            );
          }
        }
      },
      builder: (context, state) {
        return ContentListView(
          children: [
            PermissionCard(
              title: 'Location',
              description: Constants.locationPermissionDesc,
              icon: const FaIcon(FontAwesomeIcons.locationArrow),
              status: state.locationStatus ?? PermissionStatus.denied,
              onPressed: () {
                context
                    .read<PermissionsBloc>()
                    .add(const PermissionsLocationRequested());
              },
            ),
            // iOS doesn't need this permission
            PlatformWidget(
              androidBuilder: (_) {
                return PermissionCard(
                  title: 'Phone',
                  description: Constants.phoneStatePermissionDesc,
                  icon: const FaIcon(FontAwesomeIcons.phoneFlip),
                  status: state.phoneStateStatus ?? PermissionStatus.denied,
                  onPressed: () {
                    context
                        .read<PermissionsBloc>()
                        .add(const PermissionsPhoneStateRequested());
                  },
                );
              },
            ),
            const Align(
              child: UsageDesc(),
            ),
          ],
        );
      },
    );
  }
}
