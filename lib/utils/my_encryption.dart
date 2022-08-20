import 'dart:convert';

class TextEncryption {
  String encodeText(String text) {
    return base64.encode(utf8.encode(text));
  }

  String decodeText(String text) {
    return utf8.decode(base64.decode(text));
  }
}
