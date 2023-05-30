// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables, prefer_const_declarations, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:flutter_Report_provider/provider/ReportProvider.dart';
// import 'package:flutter_Report_provider/widget/Alert.dart';
// import 'package:provider/provider.dart';

import '../constants.dart';
import '../model/report.dart';
import '../pages/viewReport.dart';
import '../provider/report_provider.dart';
import 'alertNotif.dart';
import 'categoriesWidget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReportWidget extends StatelessWidget {
  final Report report;

  const ReportWidget({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    context.read<ReportsProvider>();

    bool slidableBtn = true;

    final uProvider = Provider.of<UserProvider>(context, listen: false);
    final toggleSlidable = context.select<UserProvider, bool>((provider) {
      for (int i = 0; i < uProvider.userList.length; i++) {
        if (uProvider.user!.userId == uProvider.userList[i].userId) {
          if (uProvider.user!.userId == "1") {
            return slidableBtn = true;
          } else {
            return slidableBtn = false;
          }
        }
      }
      return slidableBtn;
    });
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: toggleSlidable
          ? Slidable(
              endActionPane: ActionPane(
                extentRatio: 0.25,
                motion: const BehindMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                    onPressed: (context) => deleteReport(context, report),
                  ),
                ],
              ),
              child: buildReport(context),
            )
          : buildReport(context),
    );
  }

  Widget buildReport(BuildContext context) {
    final uProvider = Provider.of<UserProvider>(context, listen: false);
    final username = context.select<UserProvider, String>((provider) {
      for (int i = 0; i < uProvider.userList.length; i++) {
        if (report.userId == uProvider.userList[i].userId) {
          return provider.userList.elementAt(i).username;
        }
      }
      return '';
    });

    return GestureDetector(
      onTap: () => showReport(context, report),
      child: Container(
        color: colorpalette,
        padding: const EdgeInsets.only(
          left: 15,
          right: 5,
          top: 20,
          bottom: 20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle_outlined,
              color: colorpaletteAccent,
              size: 35,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.campaign_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                report.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  // color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                width: double.infinity,
                                // padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  ' · ${DateFormat('MM-dd-yyyy HH:mm').format(DateTime.parse(report.created))}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorpalette.shade300,
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.more_vert,
                              color: colorpalette.shade300,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'created by $username',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorpalette.shade300,
                    ),
                  ),
                  if (report.description.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 5, right: 15),
                      child: Text(
                        report.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                    ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: colorpalette.shade400,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_circle_up,
                          color: colorpalette.shade300,
                        ),
                        SizedBox(width: 20),
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: colorpalette.shade300,
                        ),
                        SizedBox(width: 20),
                        Icon(
                          Icons.share_outlined,
                          color: colorpalette.shade300,
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteReport(BuildContext context, Report report) {
    final provider = Provider.of<ReportsProvider>(context, listen: false);
    provider.removeReport(report);

    AlertNotif.ShowSnackBar(context, 'Report Deleted Successfully.');
  }

  void showReport(BuildContext context, Report report) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewReportPage(report: report),
      ),
    );
  }
}

class ReportListItems extends StatelessWidget {
  const ReportListItems({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> refresh() async {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final String _baseUrl = 'localhost:8000';
      final String _charactersPath = 'reports/';
      final Uri url = Uri.http(_baseUrl, _charactersPath);
      final response = http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      context.read<ReportsProvider>().retrieveReports();
    }

    final cProvider = context.watch<CategoryProvider>();
    final provider = context.watch<ReportsProvider>();
    final reports = provider.reports;

    return Scaffold(
      backgroundColor: colorpalette.shade700,
      body: Column(
        children: [
          Row(
            children: [
              CategoriesWidget(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: colorpalette.shade400,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    'REPORT LIST',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          reports.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(
                    child: Text(
                      'No Reports to Show...',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                )
              : Flexible(
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      separatorBuilder: (context, index) => Container(
                        height: 15,
                      ),
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        return ReportWidget(report: report);
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
