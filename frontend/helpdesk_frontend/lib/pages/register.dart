// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helpdesk_frontend/constants.dart';
import 'package:helpdesk_frontend/widget/alertNotif.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../model/user.dart';
import '../provider/report_provider.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    context.watch<ReportsProvider>();
    context.watch<CommentProvider>();
    context.watch<ReplyProvider>();

    void onAdd() {
      final String firstName = firstNameController.text;
      final String lastName = lastNameController.text;
      final String username = usernameController.text;
      final String password = passwordController.text;

      if (firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty) {
        final userId = Uuid().v4();
        final comment = User(
          userId: userId,
          firstName: firstName,
          is_superuser: false,
          lastName: lastName,
          password: password,
          username: username,
        );

        final String _baseUrl = 'localhost:8000';
        final String _charactersPath = 'register/';

        final Uri url = Uri.http(_baseUrl, _charactersPath);
        final response = http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(comment.toJson()),
        );
        context.read<UserProvider>().fethUsers();
        Navigator.of(context).pop();
        AlertNotif.ShowSnackBar(context, 'Account registered Successfully.');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Register Account"),
        shape: Border(
          bottom: BorderSide(
            color: colorpalette.shade400,
            width: 1.5,
          ),
        ),
      ),
      backgroundColor: colorpalette,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_tree_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      "Help.Desk",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'First Name...',
                        ),
                        controller: firstNameController,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Last Name...',
                        ),
                        controller: lastNameController,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Username...',
                        ),
                        controller: usernameController,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Password...',
                        ),
                        controller: passwordController,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints.tightFor(width: double.infinity),
                          child: ElevatedButton(
                            onPressed: () {
                              onAdd();
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: Text("Register"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
