
import 'package:flutter/material.dart';

Future showModalBottomPage(BuildContext context, Widget screen,
    {bool enableDrag = true}) {
  return showModalBottomSheet(
      context: context,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => screen);
}