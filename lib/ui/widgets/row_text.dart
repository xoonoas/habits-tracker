import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RowText extends StatefulWidget {
  final Widget icons;
  final String title;
  final bool next;
  final Widget iconRight;
  final bool isDivider;
  final Function onTap;
  RowText(
      {this.icons,
        this.title,
        this.next = true,
        this.onTap,
        this.iconRight,
        this.isDivider = false});

  @override
  _RowTextState createState() => _RowTextState();
}

class _RowTextState extends State<RowText> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onTap(),
        child: Container(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            children: [
              Row(
                children: [
                  if (widget.icons != null) widget.icons,
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child: Text(widget.title)),
                  if (widget.iconRight != null) widget.iconRight,
                  if (widget.next) Icon(Icons.navigate_next),
                ],
              ),
              SizedBox(height:16,),
              if (widget.isDivider) Container(height: 0.5,color: Colors.grey[300],)
            ],
          ),
        ),
      ),
    );
  }
}
