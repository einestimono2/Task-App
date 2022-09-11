import 'package:flutter/material.dart';
import 'package:tasks_app/config/app_size.dart';

import '../../config/app_size.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    this.centerTitle = false,
  }) : super(key: key);

  final String title;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue.shade400,
      centerTitle: centerTitle,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline3!
            .copyWith(color: Colors.white),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 18,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      // iconTheme: IconThemeData(color: Colors.black),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(getProportionateScreenHeight(50));
}
