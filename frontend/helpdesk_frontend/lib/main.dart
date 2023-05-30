// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk_frontend/constants.dart';
import 'package:helpdesk_frontend/model/report.dart';
import 'package:helpdesk_frontend/pages/login.dart';
import 'package:helpdesk_frontend/provider/report_provider.dart';
import 'package:helpdesk_frontend/widget/ReportWidget.dart';
import 'package:helpdesk_frontend/widget/addReportWidget.dart';
import 'package:helpdesk_frontend/widget/bottomNavBarWidget.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReportsProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => ReplyProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: colorpalette,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
