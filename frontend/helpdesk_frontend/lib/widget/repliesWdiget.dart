// ignore_for_file: prefer_const_constructors

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:helpdesk_frontend/model/reply.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../model/report.dart';
import '../provider/report_provider.dart';
import '../model/comment.dart';
import 'package:intl/intl.dart';

class RepliesWidget extends StatelessWidget {
  const RepliesWidget({super.key, required this.repComment});

  final RepComment repComment;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReplyProvider>();
    final comments = provider.replyList;
    final comList = provider.replyList
        .where((reply) => reply.commentId == repComment.commentId)
        .toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(5),
      separatorBuilder: (context, index) => Container(
        height: 15,
      ),
      itemCount: comList.length,
      itemBuilder: (context, index) {
        final comment = comList[index];
        return ReplyCardWidget(reply: comment);
      },
    );
  }
}

class ReplyCardWidget extends StatelessWidget {
  final CommentReply reply;

  const ReplyCardWidget({super.key, required this.reply});

  @override
  Widget build(BuildContext context) {
    context.watch<ReportsProvider>();

    return buildReply(context);
  }

  Widget buildReply(BuildContext context) {
    final rProvider = context.watch<ReplyProvider>();
    final uProvider = Provider.of<UserProvider>(context, listen: false);
    final username = context.select<UserProvider, String>((provider) {
      for (int i = 0; i < uProvider.userList.length; i++) {
        if (reply.userId == uProvider.userList[i].userId) {
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
      child: Column(
        children: [
          Row(
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
                        DateTime.parse(reply.created),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: colorpalette.shade300,
                      ),
                    ),
                    if (reply.replyContent.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 5, right: 15),
                        child: Text(
                          reply.replyContent,
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
            ],
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
    );
  }
}
