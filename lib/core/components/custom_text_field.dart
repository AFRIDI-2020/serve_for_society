import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final Widget? prefix;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffix;
  final EdgeInsets? contentPadding;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool enabled;
  final int? maxLine;

  const CustomTextField(
      {Key? key,
        this.labelText = '',
        this.prefix,
        this.controller,
        this.obscureText = false,
        this.suffix,
        this.textInputType = TextInputType.text,
        this.inputFormatters,
        this.validator,
        this.contentPadding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        this.enabled = true,
        this.maxLine = 1
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLine,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        isDense: true,
        enabled: enabled,
        labelText: labelText,
        prefix: prefix,
        suffix: suffix,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      cursorColor: Colors.black,
    );
  }
}
