// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, prefer_const_declarations, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk_frontend/constants.dart';
import 'package:helpdesk_frontend/pages/home.dart';
import 'package:helpdesk_frontend/pages/register.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../provider/report_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../widget/alertNotif.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool? isAdmin;

  @override
  Widget build(BuildContext context) {
    final userController = TextEditingController();
    final passController = TextEditingController();

    context.watch<ReportsProvider>();
    context.watch<CommentProvider>();
    context.watch<ReplyProvider>();

    Future<User> onLogin() async {
      final String username = userController.text;
      final String password = passController.text;

      final String _baseUrl = 'localhost:8000';
      final String _charactersPath = 'login/';

      final Uri url = Uri.http(_baseUrl, _charactersPath);
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final user = User.fromJson(responseData);
        final superuser = responseData['is_superuser'];
        AlertNotif.ShowSnackBar(
            context, 'Login Successfully. Welcome $username!');
        return user;
      } else {
        AlertNotif.ShowSnackBar(
            context, 'Login Failed. Username or Login is invalid.');
      }
      throw Exception('Failed to login');
    }

    return Scaffold(
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
                          hintText: 'Username...',
                        ),
                        controller: userController,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Password...',
                        ),
                        obscureText: true,
                        controller: passController,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints.tightFor(width: double.infinity),
                          child: ElevatedButton(
                            onPressed: () async {
                              User user = await onLogin();
                              context.read<UserProvider>().setUser(user);
                              context.read<UserProvider>().fethUsers();
                              context
                                  .read<CategoryProvider>()
                                  .fetchCategoryList();
                              context.read<ReportsProvider>().retrieveReports();
                              context.read<CommentProvider>().fetchComments();
                              context.read<ReplyProvider>().fetchReplies();

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MyHomePage(),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: Text("Login"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints.tightFor(width: double.infinity),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
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
