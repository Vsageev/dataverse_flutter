import 'package:flutter/material.dart';

showPopup(BuildContext context,String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.blue,
    content: Text(text),
  ));
}
