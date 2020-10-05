import 'package:flutter/material.dart';

class AppbarBottomSheet extends StatefulWidget {
  final String title;
  final Widget leftWidget;
  final Widget rightWidget;
  final Widget centerWidget;
  final VoidCallback onTapLeft;
  final VoidCallback onTapRight;
  final Color backgroundColor;
  final EdgeInsets padding;
  final double elevation;

  AppbarBottomSheet(
      {this.title,
        this.leftWidget,
        this.rightWidget,
        this.centerWidget,
        this.onTapLeft,
        this.onTapRight,
        this.padding,
        this.backgroundColor = Colors.white,
        this.elevation});

  @override
  _AppbarBottomSheetState createState() => _AppbarBottomSheetState();
}

class _AppbarBottomSheetState extends State<AppbarBottomSheet> {
  Widget _leftWidget() {
    if (widget.leftWidget != null) {
      return widget.leftWidget;
    } else {
      return Container();
    }
  }

  Widget _centerWidget() {
    if (widget.centerWidget != null) {
      return widget.centerWidget;
    } else {
      return Text(
        _getTitle(),
        style: Theme.of(context).textTheme.headline6,
      );
    }
  }

  _getTitle() {
    if (widget.title != null) {
      return widget.title;
    } else {
      return "";
    }
  }

  Widget _rightWidget() {
    if (widget.rightWidget != null) {
      return widget.rightWidget;
    } else {
      /*return Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).cardColor,
        ),
        child: Icon(
          Icons.close,
          color: Colors.black,
        ),
      );*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: new BorderRadius.only(
        topLeft: const Radius.circular(20.0),
        topRight: const Radius.circular(20.0),
      ),
      elevation: widget.elevation,
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
          ),
        ),
        padding: widget.padding,
        child: Stack(
          children: <Widget>[
            Center(
                child: Container(
                    margin: EdgeInsets.only(top: 5), child: _centerWidget())),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: widget.onTapLeft,
                  child: _leftWidget(),
                ),
                InkWell(
                  onTap: widget.onTapRight,
                  child: widget.rightWidget,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
