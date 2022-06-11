import 'package:flutter/material.dart';

import 'constatnts.dart';

class WelcomeWidget extends StatelessWidget {
  final int? _numPage;
  final String? _title;
  final Color? _titleColor;
  final String? _assetPath;
  final String? _bottomTitle;
  final Color? _textColor;
  final String? _bodyContent;
  final Widget _form;
  const WelcomeWidget({
    Key? key, int? numPage, String? title, Color? titleColor, String? assetPath, String? bottomTitle, Color? textColor, String? bodyContent, Widget form = const Text("")
  }) : _numPage = numPage, _title = title, _titleColor = titleColor, _assetPath = assetPath, _bottomTitle = bottomTitle, _textColor = textColor, _bodyContent = bodyContent, _form = form;


  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: const Alignment(0, 0.1),
                end: Alignment.bottomCenter,
                colors: [
                  welcomePrimaryColor,
                  accentWelcomeColor
                ]
            )
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.05,
              ),
              Text(
                "$_title",
                style: TextStyle(
                    fontSize: 40,
                    color: _titleColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
                  child: Image(
                    image: AssetImage("$_assetPath"),
                    width: MediaQuery.of(context).size.width*0.80,
                  )
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05,),
                child: Text(
                  "$_bottomTitle",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.02,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB( MediaQuery.of(context).size.width*0.05, 10,  MediaQuery.of(context).size.width*0.05, 5),
                child: Text(
                  "$_bodyContent",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 15,
                    color: _textColor,
                  ),
                ),
              ),
              Form(
                child: _form,
              )
            ],
          ),
        )
    );
  }
}