// Flutter Imports
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

// Project Imports
import 'package:pingware/home.dart';
import 'package:pingware/theme/apptextstyle.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  Future<void> _sessionCheck(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.wait([_sessionCheck(context)]);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(flex: 3),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [AppShadow.card],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.asset(
                  'assets/icons/launcher_icon.png',
                  width: 100,
                ),
              ),
            ),
            const Spacer(flex: 3),
            Text(
              'PingWare',
              style: AppTextStyle.bigTitle,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
