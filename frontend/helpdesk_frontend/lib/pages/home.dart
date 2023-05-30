// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../provider/report_provider.dart';
import '../widget/ReportWidget.dart';
import '../widget/addReportWidget.dart';
import '../widget/alertNotif.dart';
import '../widget/bottomNavBarWidget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final reportsL = Provider.of<ReportsProvider>(context);
    return Scaffold(
      backgroundColor: colorpalette.shade600,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text("Help.Desk"),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(Icons.account_tree_outlined),
        ),
        leadingWidth: 20,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<UserProvider>().logout();
                    context.read<CategoryProvider>().logout();
                    context.read<ReportsProvider>().logout();
                    context.read<CommentProvider>().logout();
                    context.read<ReplyProvider>().logout();
                    Navigator.pop(context);
                    AlertNotif.ShowSnackBar(
                        context, 'Account Logout Successfully.');
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )),
                  child: SizedBox(
                    child: Text(
                      "Logout",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ReportListItems(),
      bottomNavigationBar: ItemBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            context.watch<ReportsProvider>().retrieveReports();
            return addReportWidget();
          },
        ),
        backgroundColor: colorpaletteAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
