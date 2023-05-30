// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_const_declarations, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:helpdesk_frontend/model/reply.dart';
import 'package:helpdesk_frontend/widget/repliesWdiget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../model/report.dart';
import '../provider/report_provider.dart';
import '../model/comment.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'alertNotif.dart';

class CommentsWidget extends StatelessWidget {
  const CommentsWidget({super.key, required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CommentProvider>();
    final comments = provider.commentList;
    final comList = provider.commentList
        .where((comment) => comment.repId == report.repId)
        .toList();

    return comList.isEmpty
        ? Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                'NO COMMENTS',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              right: 5,
              left: 5,
              bottom: 5,
            ),
            separatorBuilder: (context, index) => Container(
              height: 15,
            ),
            itemCount: comList.length,
            itemBuilder: (context, index) {
              final comment = comList[index];
              return CommentCardWidget(comment: comment);
            },
          );
  }
}

class CommentCardWidget extends StatefulWidget {
  final RepComment comment;

  const CommentCardWidget({super.key, required this.comment});

  @override
  State<CommentCardWidget> createState() => _CommentCardWidgetState();
}

class _CommentCardWidgetState extends State<CommentCardWidget> {
  late String commentId;
  final commentReplyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    commentId = widget.comment.commentId;
  }

  void onAdd() {
    final String commentReply = commentReplyController.text;
    final uProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = uProvider.user;

    if (commentReply.isNotEmpty) {
      final replyId = Uuid().v4();
      final reply = CommentReply(
        userId: currentUser!.userId,
        replyId: replyId,
        replyContent: commentReply,
        commentId: commentId,
        created: DateTime.now().toString(),
      );

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final String _baseUrl = 'localhost:8000';
      final String _charactersPath = 'replies/create/';

      final Uri url = Uri.http(_baseUrl, _charactersPath);
      final response = http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reply.toJson()),
      );
      context.read<ReplyProvider>().fetchReplies();
      Navigator.of(context).pop();
      AlertNotif.ShowSnackBar(context, 'Reply posted successfully.');
    } else {
      AlertNotif.ShowSnackBar(context, 'Reply must not be empty.');
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<ReportsProvider>();

    return buildComment(context);
  }

  Widget buildComment(BuildContext context) {
    final rProvider = context.read<ReplyProvider>();
    final uProvider = Provider.of<UserProvider>(context, listen: false);
    final username = context.select<UserProvider, String>((provider) {
      for (int i = 0; i < uProvider.userList.length; i++) {
        if (widget.comment.userId == uProvider.userList[i].userId) {
          return provider.userList.elementAt(i).username;
        }
      }
      return '';
    });
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorpalette.shade400,
            width: 1.5,
          ),
        ),
      ),
      padding: const EdgeInsets.only(
        right: 5,
        top: 5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.account_circle_outlined,
            color: colorpaletteAccent,
            size: 30,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              username,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
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
                  DateFormat('MM-dd-yyyy HH:mm').format(
                    DateTime.parse(widget.comment.created),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: colorpalette.shade300,
                  ),
                ),
                if (widget.comment.content.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 5, right: 15),
                    child: Text(
                      widget.comment.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
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
                      Row(
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
                      ElevatedButton(
                        onPressed: () => showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            context.watch<ReplyProvider>().fetchReplies();
                            return AlertDialog(
                              content: Form(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Post a reply to this comment',
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
                                                  hintText: 'Reply...',
                                                ),
                                                controller:
                                                    commentReplyController,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    onAdd();
                                                  },
                                                  child: Text("Reply"),
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
                        child: SizedBox(
                          child: Text("Reply..."),
                        ),
                      ),
                    ],
                  ),
                ),
                widget.comment.showReply
                    ? Column(
                        children: [
                          rProvider.replyList.isNotEmpty
                              ? RepliesWidget(repComment: widget.comment)
                              : const SizedBox(),
                        ],
                      )
                    : const SizedBox(),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<CommentProvider>()
                        .toggleReplies(widget.comment);
                  },
                  child: SizedBox(
                    child: Text(
                      widget.comment.showReply
                          ? "Hide Replies..."
                          : "Show Replies...",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void deleteReport(BuildContext context, Comment comment) {
  //   final provider = Provider.of<CommentProvider>(context, listen: false);
  // }
}
