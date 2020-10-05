import 'package:flutter/material.dart';

class FirstHabit extends StatelessWidget {
  final String title;
  final Function onTab;

  FirstHabit({this.title, this.onTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: Theme.of(context).textTheme.caption.color, ),
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: onTab ?? () {

              },
              child: Icon(Icons.add_circle_outline, size: 36, color: Theme.of(context).primaryColor,),
            )
          ],
        ),
      ),
    );
  }
}
