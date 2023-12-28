import 'package:flutter/material.dart';
import 'package:mechanic/utils/app_strings.dart';
import 'package:mechanic/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool enabled;
  final bool optional;
  final TextEditingController controller;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChange ;
  const CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.onSaved,
    this.onChange,
    this.enabled = true ,
    this.optional = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled:enabled ,
        textInputAction: TextInputAction.next,
        obscureText: labelText.contains('Password') || labelText.contains('password'),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          floatingLabelStyle: TextStyle(color: AppColors.primary2Color),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.primary2Color, width: 2.0),
              borderRadius: BorderRadius.circular(10.0)),
          labelText: labelText,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          hintText: hintText,
        ),
        controller: controller,
        onChanged: onChange,
        validator: optional ?  null: (value) {
          if (value!.isEmpty) {
            return AppString.cantEmpty;
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }
}
