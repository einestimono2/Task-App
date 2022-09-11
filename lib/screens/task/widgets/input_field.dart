import 'package:flutter/material.dart';

import '../../../config/app_size.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final Widget? widget;
  final String? Function(String?)? validator;

  const InputField({
    Key? key,
    required this.title,
    required this.hintText,
    this.controller,
    this.widget,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey,
        width: getProportionateScreenWidth(1),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          " " + title,
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(height: getProportionateScreenHeight(11)),
        TextFormField(
          readOnly: widget != null,
          controller: controller,
          validator: validator,
          style: Theme.of(context).textTheme.headline4,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            contentPadding: EdgeInsets.only(
              top: 15,
              bottom: 15,
              left: 10,
            ),
            border: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            suffixIcon: widget,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(22)),
      ],
    );
  }
}
