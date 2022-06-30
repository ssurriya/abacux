import 'package:flutter/material.dart';

import 'app_constant.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(this.controller, this.labelText,
      {this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.onchanged,
      this.isValidate = true,
      this.isRead = false});
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon, suffixIcon;
  final Function validator;
  final Function onchanged;
  final bool isValidate, isRead;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
      controller: controller,
      readOnly: isRead,
      validator: (text) {
        // return validator(value);
        // if (isHsnCode) {
        //   if (value.length > 10) {
        //     return "Invalid HSN Code";
        //   }
        // }
        if (isValidate) {
          if (text.isEmpty) {
            return labelText + " is empty";
          }
        }
        return null;
      },
      onChanged: (value) {
        onchanged(value);
      },
      decoration: InputDecoration(
        labelText: labelText,
        // hintText: hintText,
        labelStyle: TextStyle(
            fontSize: 16.0,
            color: Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.w600),
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        suffixIcon: suffixIcon == null
            ? null
            : Icon(
                suffixIcon,
                color: AppConstant().appThemeColor,
              ),
        fillColor: Color(0xFFEEEEFF),
      ),
    );
  }
}
