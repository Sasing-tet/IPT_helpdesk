// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable, prefer_typing_uninitialized_variables, camel_case_types

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk_frontend/model/report.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../provider/report_provider.dart';
import 'package:http/http.dart' as http;

import 'alertNotif.dart';

class addReportWidget extends StatefulWidget {
  const addReportWidget({super.key});

  @override
  State<addReportWidget> createState() => _addReportWidgetState();
}

class _addReportWidgetState extends State<addReportWidget> {
  final reportTitleController = TextEditingController();
  final reportDescController = TextEditingController();
  final reportCatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final uProvider = Provider.of<UserProvider>(context);
    final cProvider = Provider.of<CategoryProvider>(context);
    final currentUser = uProvider.user;

    void onAdd() {
      final String titleVal = reportTitleController.text;
      final String desVal = reportDescController.text;
      String catId = "";

      for (int i = 0; i < cProvider.categoryList.length; i++) {
        if (reportCatController.text ==
            cProvider.categoryList[i].categoryName) {
          catId = cProvider.categoryList[i].catId;
        }
      }
      if (titleVal.isNotEmpty && catId.isNotEmpty) {
        final reportId = Uuid().v4();
        final report = Report(
          userId: currentUser!.userId,
          repId: reportId,
          title: titleVal,
          description: desVal,
          catId: catId,
          created: DateTime.now().toString(),
        );

        Map<String, String> headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
        String url = 'http://127.0.0.1:8000/reports/create/';

        http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(report.toJson()),
        );
        final provider = Provider.of<ReportsProvider>(context, listen: false);
        provider.addRep(report);
        Navigator.of(context).pop();
        AlertNotif.ShowSnackBar(context, 'Report created Successfully.');
      } else if (titleVal.isEmpty) {
        AlertNotif.ShowSnackBar(context, 'Report Title must not be empty.');
      } else if (catId.isEmpty) {
        AlertNotif.ShowSnackBar(context, 'Report Category must not be empty.');
      }
    }

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Create Helpdesk Report',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Column(
            children: [
              Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Report Title...',
                    ),
                    controller: reportTitleController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Report Description/Details...',
                    ),
                    controller: reportDescController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Report Category...',
                    ),
                    controller: reportCatController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        onAdd();
                      },
                      child: Text("Add report"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
