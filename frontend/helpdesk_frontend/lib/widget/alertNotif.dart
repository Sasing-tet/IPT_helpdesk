// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class AlertNotif {
  static void ShowSnackBar(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
