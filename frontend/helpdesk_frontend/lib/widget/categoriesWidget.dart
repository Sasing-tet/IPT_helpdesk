// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_frontend/model/categories.dart';
import 'package:helpdesk_frontend/widget/addCategoryWidget.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../provider/report_provider.dart';
import 'package:http/http.dart' as http;

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<CategoryProvider>();
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    final categories = provider.categoryList;
    bool addCategoryBtn = true;

    final uProvider = Provider.of<UserProvider>(context, listen: false);
    final toggleAddCat = context.select<UserProvider, bool>((provider) {
      for (int i = 0; i < uProvider.userList.length; i++) {
        if (uProvider.user!.userId == uProvider.userList[i].userId) {
          if (uProvider.user!.userId == "1") {
            return addCategoryBtn = true;
          } else {
            return addCategoryBtn = false;
          }
        }
      }
      return addCategoryBtn;
    });

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
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
                    'CATEGORIES',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                toggleAddCat
                    ? ElevatedButton(
                        onPressed: () => showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            context
                                .watch<CategoryProvider>()
                                .fetchCategoryList();
                            return addCategoryWidget();
                          },
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder()),
                          padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return colorpaletteAccent;
                              }
                            },
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 15,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(
                right: 20,
                left: 20,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            categories.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: CategoriesDesign(
                                category: categories[index],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoriesDesign extends StatelessWidget {
  final Categories category;

  const CategoriesDesign({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    context.watch<CategoryProvider>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorpaletteAccent,
      ),
      child: Text(
        category.categoryName,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
