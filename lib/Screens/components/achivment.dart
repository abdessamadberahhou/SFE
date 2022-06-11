import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

void showAchievementView(BuildContext context,status,text){
  AchievementView(
      context,
      title: status ? "Succée" : "Erreur",
      subTitle: text,
      isCircle: true,
      borderRadius: BorderRadius.circular(15),
      icon: Icon(status?Icons.check_circle_outline_outlined : Boxicons.bx_x_circle, color: Colors.white,),
      typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
      color: status ? HexColor('1bfa27') : Colors.redAccent,
      textStyleTitle: const TextStyle(
          fontFamily: 'cairo',
          fontSize: 14,
          color: Colors.white,
      ),
      textStyleSubTitle: const TextStyle(
          fontFamily: 'cairo',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white
      ),
      alignment: Alignment.topCenter,
      duration: const Duration(seconds: 5),
  ).show();
}