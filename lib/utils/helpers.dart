// Dart imports:
// import 'dart:io';

// Flutter imports:
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:elegant_notification/elegant_notification.dart';


void showElegantNotification(
  BuildContext context,
  ElegantNotification notification,
) {
  notification.background = Theme.of(context).colorScheme.surfaceVariant;
  notification.showProgressIndicator = false;
  notification.radius = 10.0;

  notification.show(context);
}

void hideKeyboard(BuildContext context) {
  final FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}
