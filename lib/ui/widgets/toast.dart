import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String title, {String label, Function action}){
  final snackBar = SnackBar(
    content: Text(title),
    action: SnackBarAction(
      label: label,
      onPressed: () {
        action();
      },
    ),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}