import 'package:flutter/material.dart';
import 'package:habits_tracker/generated/l10n.dart';
import 'package:habits_tracker/res/assets.dart';
import 'package:habits_tracker/utils/app_utils.dart';

class IconChoosePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        height: MediaQuery.of(context).size.height * 3 / 2,
        child: ListView(
          children: <Widget>[
            getHeader(context, S.of(context).popular),
            getGridIcons(otherIcon),
            getHeader(context, S.of(context).sports),
            getGridIcons(sportIcon),
            getHeader(context, S.of(context).technology),
            getGridIcons(devicesIcon),
          ],
        ),
      ),
    );
  }

  Widget getHeader(BuildContext context, String text) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Text(text,style: Theme.of(context).textTheme.bodyText2,),
    );
  }

  Widget getGridIcons(List items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        childAspectRatio: 1.0,
        crossAxisSpacing: 30.0,
        mainAxisSpacing: 20.0,
        maxCrossAxisExtent: 70,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => FlatButton(
        onPressed: () => Navigator.of(context).pop(items[i]),
        shape: CircleBorder(),
        child: ImageAssets.svgAssets(ImageAssets.serverIconMap[items[i]], color: Theme.of(context).primaryColor),
      ),
    );
  }
}
