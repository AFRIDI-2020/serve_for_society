import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldBuilder {
  Widget showtextFormBuilder(
      BuildContext context,
      String _labelText,
      IconData _prefixIconData,
      TextEditingController _textEditingController,
      String? _errorText,
      bool obscureText,
      Widget? _suffixIconData,
      {TextInputType textInputType = TextInputType.text, List<TextInputFormatter>? inputFormatters,}) {
    Size size = MediaQuery.of(context).size;

    return TextFormField(
      obscureText: obscureText,
      controller: _textEditingController,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.only(top: size.width * .04, bottom: size.width * .01),
        errorText: _errorText,
        labelText: _labelText,
        prefixIcon: Icon(
          _prefixIconData,
          color: Colors.grey,
        ),
        suffixIcon: _labelText == 'Password' || _labelText == 'Confirm Password'
            ? _suffixIconData
            : null,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      cursorColor: Colors.black,
    );
  }
}
