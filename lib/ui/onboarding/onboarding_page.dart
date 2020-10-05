import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habits_tracker/generated/l10n.dart';
import 'package:habits_tracker/res/assets.dart';
import 'package:habits_tracker/ui/tab_page.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State< OnboardingPage> {
  List<SliderModel> mySLides = new List<SliderModel>();
  int slideIndex = 0;
  PageController controller;

  Widget _buildPageIndicator(bool isCurrentPage){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 15.0 : 10.0,
      width: isCurrentPage ? 15.0 : 10.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    mySLides.add(SliderModel(imageAssetPath: ImageAssets.onboarding_identify, title: S.current.identify, desc: S.current.identifyDes));
    mySLides.add(SliderModel(imageAssetPath: ImageAssets.onboarding_routine, title: S.current.routine, desc: S.current.routineDes));
    mySLides.add(SliderModel(imageAssetPath: ImageAssets.onboarding_reminder, title: S.current.reminder, desc: S.current.reminderDes));
    mySLides.add(SliderModel(imageAssetPath: ImageAssets.onboarding_progress, title: S.current.progress, desc: S.current.progressDes));
    mySLides.add(SliderModel(imageAssetPath: ImageAssets.onboarding_success, title: S.current.success, desc: S.current.successDes));
    controller = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [const Color(0xff3C8CE7), const Color(0xff00EAFF)])),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  slideIndex = index;
                });
              },
              children: mySLides.asMap().map((key, value) => MapEntry(key, SlideTile(
                imagePath: mySLides[key].imageAssetPath,
                title: mySLides[key].title,
                desc: mySLides[key].desc,
              ))).values.toList()
            /*<Widget>[
              SlideTile(
                imagePath: mySLides[0].getImageAssetPath(),
                title: mySLides[0].getTitle(),
                desc: mySLides[0].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[1].getImageAssetPath(),
                title: mySLides[1].getTitle(),
                desc: mySLides[1].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[2].getImageAssetPath(),
                title: mySLides[2].getTitle(),
                desc: mySLides[2].getDesc(),
              )
            ],*/
          ),
        ),
        bottomSheet: slideIndex != 4 ? Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TabPage()));
                },
                splashColor: Colors.blue[50],
                child: Text(
                  S.of(context).skip,
                  style: TextStyle(color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    for (int i = 0; i < 5 ; i++) i == slideIndex ? _buildPageIndicator(true): _buildPageIndicator(false),
                  ],),
              ),
              FlatButton(
                onPressed: (){
                  controller.animateToPage(slideIndex + 1, duration: Duration(milliseconds: 500), curve: Curves.linear);
                },
                splashColor: Colors.blue[50],
                child: Text(
                  S.of(context).next,
                  style: TextStyle(color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ): InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TabPage()));
          },
          child: Container(
            height: Platform.isIOS ? 70 : 60,
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text(
              "GET STARTED NOW",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  String imagePath, title, desc;

  SlideTile({this.imagePath, this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imagePath),
          SizedBox(
            height: 40,
          ),
          Text(title.toUpperCase(), textAlign: TextAlign.center,style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20
          ),),
          SizedBox(
            height: 20,
          ),
          Text(desc, textAlign: TextAlign.center,style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16, color: Theme.of(context).textTheme.caption.color))
        ],
      ),
    );
  }
}

class SliderModel{

  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath,this.title,this.desc});
}

