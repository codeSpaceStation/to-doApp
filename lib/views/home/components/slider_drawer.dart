import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/extensions/space_exs.dart';
import 'package:todo_app/utils/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  //Icons
  final List<IconData> icons = [
    CupertinoIcons.house,
    CupertinoIcons.person,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle,
  ];

  /// Teks
  final List<String> texts = [
    "Home",
    "Profile",
    "Settings",
    "Details",
  ];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 90),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradientColor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  "https://avatars.githubusercontent.com/u/55615106?v=4"),
            ),
            8.h,
            Text(
              "Code Space Station",
              style: textTheme.displayMedium,
            ),
            Text(
              "Flutter dev",
              style: textTheme.displaySmall,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 10,
              ),
              width: double.infinity,
              // height: 300,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Expanded(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: icons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          log('${texts[index]} Item Tapped!');
                        },
                        child: Container(
                          margin: EdgeInsets.all(3),
                          child: ListTile(
                            leading: Icon(
                              icons[index],
                              color: Colors.white,
                              size: 30,
                            ),
                            title: Text(
                              texts[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "© 2025 Code Space Station",
                style: textTheme.bodySmall!.copyWith(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
