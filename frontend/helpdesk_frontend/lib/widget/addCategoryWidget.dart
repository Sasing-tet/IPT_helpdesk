// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable, prefer_typing_uninitialized_variables, prefer_const_declarations, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers, camel_case_types

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helpdesk_frontend/model/categories.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../provider/report_provider.dart';
import 'package:http/http.dart' as http;

import 'alertNotif.dart';

class addCategoryWidget extends StatefulWidget {
  const addCategoryWidget({super.key});

  @override
  State<addCategoryWidget> createState() => _addCategoryWidgetState();
}

class _addCategoryWidgetState extends State<addCategoryWidget> {
  final catNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.watch<CategoryProvider>();
    final cProvider = Provider.of<CategoryProvider>(context, listen: false);
    final uProvider = Provider.of<UserProvider>(context);
    final currentUser = uProvider.user;

    void onAdd() {
      final String catName = catNameController.text;

      if (catName.isNotEmpty) {
        final catId = Uuid().v4();
        final category = Categories(
          userId: currentUser!.userId,
          catId: catId,
          categoryName: catName,
        );

        Map<String, String> headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
        final String _baseUrl = 'localhost:8000';
        final String _charactersPath = 'categories/create/';

        final Uri url = Uri.http(_baseUrl, _charactersPath);
        final response = http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(category.toJson()),
        );
        Navigator.of(context).pop();
        AlertNotif.ShowSnackBar(context, 'Category created successfully.');
      } else {
        AlertNotif.ShowSnackBar(context, 'Category must not be empty.');
      }
    }

    return AlertDialog(
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create Helpdesk Category',
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
                          hintText: 'Category Name...',
                        ),
                        controller: catNameController,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            onAdd();
                          },
                          child: Text("Add Category"),
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
  }
}
