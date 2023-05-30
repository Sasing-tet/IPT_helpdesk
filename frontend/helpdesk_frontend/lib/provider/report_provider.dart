// ignore_for_file: prefer_final_fields, non_constant_identifier_names, unrelated_type_equality_checks, prefer_const_declarations, no_leading_underscores_for_local_identifiers, unused_import, unnecessary_this

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helpdesk_frontend/model/comment.dart';
import 'package:helpdesk_frontend/model/user.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../model/categories.dart';
import '../model/reply.dart';
import '../model/report.dart';

class ReportsProvider extends ChangeNotifier {
  ReportsProvider() {
    this.retrieveReports();
  }

  final List<Report> _reports = [];
  List<Report> get reports {
    return [..._reports];
  }

  Report? _report;
  Report? get report => _report;

  void setTopic(Report report) {
    _report = report;
    notifyListeners();
  }

  Future<void> retrieveReports() async {
    const url = 'http://127.0.0.1:8000/reports/';
    //final url = Uri.parse('localhost:8000/reports/');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _reports.clear();
      for (var reportData in data) {
        final report = Report.fromJson(reportData);
        _reports.add(report);
      }
      notifyListeners();
    }
  }

  addRep(Report report) async {
    _reports.add(report);
    notifyListeners();
  }

  Future<void> removeReport(Report report) async {
    final url =
        Uri.parse('http://127.0.0.1:8000/reports/${report.repId}/delete');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(report.toJson()),
    );

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      throw Exception('Failed to delete');
    }
    notifyListeners();
    _reports.remove(report);
    notifyListeners();
  }

  void logout() {
    _reports.clear();
    notifyListeners();
  }
}

class CategoryProvider extends ChangeNotifier {
  CategoryProvider() {
    this.fetchCategoryList();
  }

  List<Categories> _categoryList = [];
  bool activeCategory = false;
  late Categories _currentCategory;
  Categories get currentCategory => _currentCategory;
  List<Categories> get categoryList => _categoryList;

  Future<void> fetchCategoryList() async {
    final String _baseUrl = 'localhost:8000';
    final String _charactersPath = 'categories/';
    final Map<String, String> _queryParameters = <String, String>{
      'format': 'json',
    };
    final Uri url = Uri.http(_baseUrl, _charactersPath, _queryParameters);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _categoryList.clear();
      for (var catData in data) {
        final categories = Categories.fromJson(catData);
        _categoryList.add(categories);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to fetch category list');
    }
  }

  addReport(Categories category) async {
    final String _baseUrl = 'localhost:8000';
    final String _charactersPath = 'categories/create/';

    final Uri url = Uri.http(_baseUrl, _charactersPath);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(category),
    );
    if (response.statusCode == 201) {
      category.catId = json.decode(response.body)['catId'];
      _categoryList.add(category);
      notifyListeners();
    }
    notifyListeners();
  }

  void logout() {
    _categoryList.clear();
    notifyListeners();
  }
}

class CommentProvider extends ChangeNotifier {
  CommentProvider() {
    this.fetchComments();
  }

  List<RepComment> _commentList = [];

  List<RepComment> get commentList => _commentList;

  Future<void> fetchComments() async {
    final String _baseUrl = 'localhost:8000';
    final String _charactersPath = 'comments/';
    final Map<String, String> _queryParameters = <String, String>{
      'format': 'json',
    };
    final Uri url = Uri.http(_baseUrl, _charactersPath, _queryParameters);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _commentList.clear();
      for (var commentData in data) {
        final comments = RepComment.fromJson(commentData);
        _commentList.add(comments);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to fetch category list');
    }
  }

  addComment(RepComment comment) async {
    final String _baseUrl = 'localhost:8000';
    final String _charactersPath = 'comments/create/';
    final Uri url = Uri.http(_baseUrl, _charactersPath);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(comment),
    );
    if (response.statusCode == 201) {
      comment.commentId = json.decode(response.body)['commmentId'];
      _commentList.add(comment);
      notifyListeners();
    }
  }

  void removeComment(RepComment comment) {
    _commentList.remove(comment);
    notifyListeners();
  }

  // Future<void> toggleShowReply(RepComment comment) async {
  //   comment.showReply = !comment.showReply;
  //   final url = Uri.parse('localhost:8000/comments/${comment.commentId}/');
  //   final response = await http.put(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(comment.toJson()),
  //   );

  //   if (response.statusCode == 200) {
  //     notifyListeners();
  //   } else {
  //     throw Exception('Failed to toggle show reply');
  //   }
  // }

  bool toggleReplies(RepComment comment) {
    comment.showReply = !comment.showReply;
    notifyListeners();
    return comment.showReply;
  }

  void logout() {
    _commentList.clear();
    notifyListeners();
  }
}

class ReplyProvider extends ChangeNotifier {
  ReplyProvider() {
    this.fetchReplies();
  }

  List<CommentReply> _replyList = [];

  List<CommentReply> get replyList => _replyList;

  Future<void> fetchReplies() async {
    final String _baseUrl = 'localhost:8000';
    final String _charactersPath = 'replies/';
    final Map<String, String> _queryParameters = <String, String>{
      'format': 'json',
    };
    final Uri url = Uri.http(_baseUrl, _charactersPath, _queryParameters);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _replyList.clear();
      for (var replyData in data) {
        final replies = CommentReply.fromJson(replyData);
        _replyList.add(replies);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to fetch category list');
    }
  }

  addReply(CommentReply reply) async {
    final String _baseUrl = 'localhost:8000';
    final String _charactersPath = 'replies/create/';
    final Uri url = Uri.http(_baseUrl, _charactersPath);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reply),
    );
    if (response.statusCode == 201) {
      reply.replyId = json.decode(response.body)['replyId'];
      _replyList.add(reply);
      notifyListeners();
    }
  }

  void logout() {
    _replyList.clear();
    notifyListeners();
  }
}

class UserProvider extends ChangeNotifier {
  UserProvider() {
    this.fethUsers();
  }

  List<User> _userList = [];

  List<User> get userList => _userList;

  User? _user;
  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<void> fethUsers() async {
    final String _baseUrl = 'localhost:8000';
    final String _charactersPath = 'users/';
    final Map<String, String> _queryParameters = <String, String>{
      'format': 'json',
    };
    final Uri url = Uri.http(_baseUrl, _charactersPath, _queryParameters);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _userList.clear();
      for (var replyData in data) {
        final users = User.fromJson(replyData);
        _userList.add(users);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to fetch category list');
    }
  }

  registerUser(User user) async {
    final String _baseUrl = 'localhost:8000';
    final String _charactersPath = 'register/';
    final Uri url = Uri.http(_baseUrl, _charactersPath);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user),
    );
    if (response.statusCode == 201) {
      user.userId = json.decode(response.body)['userId'];
      _userList.add(user);
      notifyListeners();
    }
  }

  void removeUser(User user) {
    _userList.remove(user);
    notifyListeners();
  }

  void logout() {
    _userList.clear();
    notifyListeners();
  }
}
