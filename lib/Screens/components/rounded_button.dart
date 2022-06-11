import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color? color, textColor;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    this.color,
    this.textColor = Colors.white
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width*0.6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
            onPressed: (){
              press();
            },
            color: color,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 70),
            child: Text(
              text,
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            ),
        ),
      ),
    );
  }
}