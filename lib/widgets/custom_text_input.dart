import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final void Function()? onEditingComplete;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  const CustomTextInput({
    required this.controller,
    this.hintText,
    this.validator,
    this.onEditingComplete,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      style: TextStyle(fontSize: 15),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 0),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 15),
      ),
    );
  }
}
