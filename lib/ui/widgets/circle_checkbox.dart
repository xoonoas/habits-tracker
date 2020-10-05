import 'package:flutter/material.dart';

class CircleCheckBox extends StatelessWidget {
  final bool checked;
  final double size;
  final bool whiteCheckedColor;
  final Color selectedColor;
  final Color unselectedColor;
  final Function(bool) onTap;

  const CircleCheckBox(this.checked,
      {Key key,
        this.size = 22,
        this.selectedColor ,
        this.unselectedColor = Colors.grey,
        this.whiteCheckedColor = false,
        this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> onTap(checked),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: checked
              ? Border.all(
              color: whiteCheckedColor ? Colors.white : selectedColor)
              : Border.all(color: unselectedColor),
        ),
        child: checked
            ? Icon(
          Icons.check,
          size: whiteCheckedColor ? size - 4 : size - 2,
          color: selectedColor,
        )
            : Container(),
      ),
    );
  }
}
