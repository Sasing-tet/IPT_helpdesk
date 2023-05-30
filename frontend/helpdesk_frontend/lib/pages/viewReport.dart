// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, prefer_const_declarations, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../constants.dart';
import '../model/comment.dart';
import '../model/report.dart';
import '../provider/report_provider.dart';
import '../widget/alertNotif.dart';
import '../widget/bottomNavBarWidget.dart';
import '../widget/commentsWidget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ViewReportPage extends StatefulWidget {
  final Report report;

  const ViewReportPage({super.key, required this.report});

  @override
  State<ViewReportPage> createState() => _ViewReportPageState();
}

class _ViewReportPageState extends State<ViewReportPage> {
  late String title;
  late String description;
  late String catId;
  late String repId;

  @override
  void initState() {
    super.initState();
    title = widget.report.title;
    description = widget.report.description;
    catId = widget.report.catId;
    repId = widget.report.repId;
  }

  @override
  Widget build(BuildContext context) {
    final repCommentController = TextEditingController();
    final currentReport = context.select<ReportsProvider, Report?>(
      (provider) => provider.report,
    );
    final uProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = uProvider.user;
    final username = context.select<UserProvider, String>((provider) {
      for (int i = 0; i < uProvider.userList.length; i++) {
        if (widget.report.userId == uProvider.userList[i].userId) {
          return provider.userList.elementAt(i).username;
        }
      }
      return '';
    });
    final cProvider = Provider.of<CategoryProvider>(context, listen: false);
    final catName = context.select<CategoryProvider, String>((provider) {
      for (int i = 0; i < cProvider.categoryList.length; i++) {
        if (widget.report.catId == cProvider.categoryList[i].catId) {
          return provider.categoryList.elementAt(i).categoryName;
        }
      }
      return '';
    });

    context.watch<ReportsProvider>();
    context.watch<CommentProvider>();
    context.watch<ReplyProvider>();

    void onAdd() {
      final String repComment = repCommentController.text;

      if (repComment.isNotEmpty) {
        final commentId = Uuid().v4();
        final comment = RepComment(
          userId: currentUser!.userId,
          commentId: commentId,
          content: repComment,
          repId: repId,
          created: DateTime.now().toString(),
        );

        Map<String, String> headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
        final String _baseUrl = 'localhost:8000';
        final String _charactersPath = 'comments/create/';

        final Uri url = Uri.http(_baseUrl, _charactersPath);
        final response = http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(comment.toJson()),
        );
        context.read<CommentProvider>().fetchComments();
        Navigator.of(context).pop();
        AlertNotif.ShowSnackBar(context, 'Comment posted successfully.');
      } else {
        AlertNotif.ShowSnackBar(context, 'Comment must not be empty.');
      }
    }

    return Scaffold(
      backgroundColor: colorpalette.shade700,
      appBar: AppBar(
        title: Text(title),
        shape: Border(
          bottom: BorderSide(
            color: colorpalette.shade400,
            width: 1.5,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
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
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.campaign_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        username,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.more_vert,
                                    color: colorpalette.shade300,
                                  ),
                                ],
                              ),
                              Text(
                                'Created on: ${DateFormat('MM-dd-yyyy HH:mm').format(DateTime.parse(widget.report.created))}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorpalette.shade300,
                                ),
                              ),
                              Text(
                                'created by $username',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorpalette.shade300,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      'Category: ',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        height: 1.5,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Text(
                                        catName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Text(
                                              title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (description.isNotEmpty)
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, right: 15),
                                  child: Text(
                                    description,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorpalette,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(
                                    width: 1.5, color: colorpalette.shade400),
                              ),
                            ),
                            child: Column(
                              children: [
                                CommentsWidget(
                                  report: widget.report,
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              context.watch<CommentProvider>().fetchComments();
                              return AlertDialog(
                                content: Form(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Post a comment on this report',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            child: Column(
                                              children: [
                                                TextField(
                                                  decoration: InputDecoration(
                                                    hintText: 'Comment...',
                                                  ),
                                                  controller:
                                                      repCommentController,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      onAdd();
                                                    },
                                                    child: Text("Comment"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 10),
                            child: Text(
                              'Post a comment on this report...',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ItemBottomNavBar(),
    );
  }
}
