import 'package:flutter/material.dart';
import 'package:towner/app/routes.dart';
import 'package:towner/utils/theme.dart';

class TownerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Towner',
      theme: TownerTheme.lightTheme,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}