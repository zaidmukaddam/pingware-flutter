// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';

// Project imports:
import 'package:pingware/constants.dart';
import 'package:pingware/introduction/introduction_pages.dart';
import 'package:pingware/overview/views/overview_view.dart';
import 'package:pingware/permissions/permissions.dart';
import 'package:pingware/settings/settings.dart';
import 'package:pingware/shared/shared_widgets.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    context
        .read<PermissionsBloc>()
        .add(const PermissionsStatusRefreshRequested());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box('settings');
    final bool hasIntroductionBeenShown = settingsBox
        .get('hasIntroductionBeenShown', defaultValue: false) as bool;

    return hasIntroductionBeenShown
        ? PlatformWidget(
            androidBuilder: _androidBuilder,
            iosBuilder: _iosBuilder,
          )
        : IntroductionScreen(
            pages: pagesList,
            done: const Text('Done'),
            next: const Icon(Icons.navigate_next),
            onDone: () {
              setState(() {
                settingsBox.put('hasIntroductionBeenShown', true);
              });
            },
          );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _selectedIndex == 0
            ? const Icon(Icons.network_ping)
            : const Icon(Icons.settings),
        title: _selectedIndex == 0
            ? const Text('Overview')
            : const Text('Settings'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Overview',
            icon: Icon(CupertinoIcons.home),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(CupertinoIcons.settings),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              defaultTitle: 'Overview',
              routes: Constants.routes,
              builder: (context) => const OverviewView(),
            );
          case 1:
            return CupertinoTabView(
              defaultTitle: 'Settings',
              routes: Constants.routes,
              builder: (context) => const SettingsView(),
            );
          default:
            throw 'Unexpected tab';
        }
      },
    );
  }
}

const List<Widget> _pages = <Widget>[
  OverviewView(),
  SettingsView(),
];
