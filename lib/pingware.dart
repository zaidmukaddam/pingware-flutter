// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dynamic_color/dynamic_color.dart';
import 'package:feedback/feedback.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:pingware/constants.dart';
import 'package:pingware/dns_lookup/dns_lookup.dart';
import 'package:pingware/home.dart';
import 'package:pingware/ip_geo/ip_geo.dart';
import 'package:pingware/lan_scanner/lan_scanner.dart';
import 'package:pingware/network_status/network_status.dart';
import 'package:pingware/package_info/package_info.dart';
import 'package:pingware/permissions/permissions.dart';
import 'package:pingware/ping/ping.dart';
import 'package:pingware/shared/shared_widgets.dart';
import 'package:pingware/theme/theme.dart';
import 'package:pingware/wake_on_lan/wake_on_lan.dart';
import 'package:pingware/whois/whois.dart';
import 'package:pingware/wrapper.dart';

class PingWare extends StatelessWidget {
  PingWare({Key? key}) : super(key: key);

  final NetworkStatusRepository networkStatusRepository =
      NetworkStatusRepository();
  final pingRepository = PingRepository();
  final lanScannerRepository = LanScannerRepository();
  final ipGeoRepository = IpGeoRepository();
  final whoisRepository = WhoisRepository();
  final dnsLookupRepository = DnsLookupRepository();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: networkStatusRepository),
        RepositoryProvider.value(value: pingRepository),
        RepositoryProvider.value(value: lanScannerRepository),
        RepositoryProvider.value(value: ipGeoRepository),
        RepositoryProvider.value(value: whoisRepository),
        RepositoryProvider.value(value: dnsLookupRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeBloc(),
          ),
          BlocProvider(
            create: (context) => PermissionsBloc(),
          ),
          BlocProvider(
            create: (context) => PackageInfoCubit(),
          ),
          BlocProvider(
            create: (context) => NetworkStatusBloc(networkStatusRepository),
          ),
          BlocProvider(
            create: (context) => PingBloc(pingRepository),
          ),
          BlocProvider(
            create: (context) => LanScannerBloc(lanScannerRepository),
          ),
          BlocProvider(
            create: (context) => WakeOnLanBloc(),
          ),
          BlocProvider(
            create: (context) => IpGeoBloc(ipGeoRepository),
          ),
          BlocProvider(
            create: (context) => WhoisBloc(whoisRepository),
          ),
          BlocProvider(
            create: (context) => DnsLookupBloc(dnsLookupRepository),
          ),
        ],
        child: PlatformWidget(
          androidBuilder: _buildAndroid,
          iosBuilder: _buildIOS,
        ),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    Themes.schemesListWithDynamic.first =
        context.read<ThemeBloc>().state.dynamicScheme ??
            Themes.schemesListWithDynamic.first;

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        handleDynamicColors(lightDynamic, darkDynamic, context);

        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            final themeData = Themes.getLightThemeDataFor(state.scheme);
            final darkThemeData = Themes.getDarkThemeDataFor(state.scheme);

            final feedbackBackgroundColor = state.mode == ThemeMode.light
                ? themeData.colorScheme.background.withOpacity(0.9)
                : darkThemeData.colorScheme.background.withOpacity(0.9);

            return BetterFeedback(
              theme: FeedbackThemeData(
                background: feedbackBackgroundColor,
              ),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: Constants.appName,
                theme: themeData,
                darkTheme: darkThemeData,
                themeMode: state.mode,
                routes: Constants.routes,
                home: const Wrapper(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIOS(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MediaQuery.fromWindow(
          child: BetterFeedback(
            child: CupertinoApp(
              useInheritedMediaQuery: true,
              localizationsDelegates: const [
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
              ],
              title: Constants.appName,
              theme: state.mode == ThemeMode.light
                  ? Themes.cupertinoLightThemeData
                  : Themes.cupertinoDarkThemeData,
              routes: Constants.routes,
              home: const Home(),
            ),
          ),
        );
      },
    );
  }

  void handleDynamicColors(
    ColorScheme? lightDynamic,
    ColorScheme? darkDynamic,
    BuildContext context,
  ) {
    if (lightDynamic != null && darkDynamic != null) {
      final lightColorScheme = lightDynamic.harmonized();
      final darkColorScheme = darkDynamic.harmonized();

      final lightFlexSchemeColor = FlexSchemeColor(
        primary: lightColorScheme.primary,
        primaryContainer: lightColorScheme.primaryContainer,
        secondary: lightColorScheme.secondary,
        secondaryContainer: lightColorScheme.secondaryContainer,
        tertiary: lightColorScheme.tertiary,
        tertiaryContainer: lightColorScheme.tertiaryContainer,
        error: lightColorScheme.error,
        errorContainer: lightColorScheme.errorContainer,
      );

      final darkFlexSchemeColor = FlexSchemeColor(
        primary: darkColorScheme.primary,
        primaryContainer: darkColorScheme.primaryContainer,
        secondary: darkColorScheme.secondary,
        secondaryContainer: darkColorScheme.secondaryContainer,
        tertiary: darkColorScheme.tertiary,
        tertiaryContainer: darkColorScheme.tertiaryContainer,
        error: darkColorScheme.error,
        errorContainer: darkColorScheme.errorContainer,
      );

      final newDynamicScheme = FlexSchemeData(
        name: 'System dynamic',
        description: 'Dynamic color theme, based on your system scheme',
        light: lightFlexSchemeColor,
        dark: darkFlexSchemeColor,
      );

      final themeBloc = context.read<ThemeBloc>();
      if (themeBloc.state.dynamicScheme != newDynamicScheme) {
        themeBloc.add(
          ThemeDynamicSchemeChangedEvent(
            newDynamicScheme: newDynamicScheme,
          ),
        );

        themeBloc.add(
          const ThemeSchemeChangedEvent(
            scheme: CustomFlexScheme.amber,
          ),
        );
      }
    }
  }
}
