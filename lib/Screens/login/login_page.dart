
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:sfe_courrier/Model/Network/authentication.dart';
import 'package:sfe_courrier/Model/login_model.dart';
import 'package:sfe_courrier/Screens/components/achivment.dart';
import 'package:sfe_courrier/Screens/components/validators.dart';
import 'package:sfe_courrier/Screens/home_sccren/home_screen.dart';
import 'package:sfe_courrier/Screens/register/register_page.dart';


import '../components/constatnts.dart';
import '../components/rounded_button.dart';
import '../components/rounded_input_field.dart';
import '../components/rounded_password_field.dart';

class LoginPage extends StatefulWidget {
  final int? _numPage;
  final String? _title;
  final Color? _titleColor;
  final String? _assetPath;
  final String? _bottomTitle;
  final Color? _textColor;
  final String? _bodyContent;
  const LoginPage(
      {Key? key,
      int? numPage,
      String? title,
      Color? titleColor,
      String? assetPath,
      String? bottomTitle,
      Color? textColor,
      String? bodyContent})
      : _numPage = numPage,
        _title = title,
        _titleColor = titleColor,
        _assetPath = assetPath,
        _bottomTitle = bottomTitle,
        _textColor = textColor,
        _bodyContent = bodyContent;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }
  final formKey = GlobalKey<FormState>();

  final TextEditingController _accountControlle = TextEditingController();
  final TextEditingController _passwordControlle = TextEditingController();
  bool isLoginin = false;
  int? _resultCode;
  String? _resultMessage;
  Authentication auth = Authentication();
  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   _accountControlle.text = 'D871829';
    //   _passwordControlle.text = 'Berahhou@2001';
    // });
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: const Alignment(0, 0.1),
                  end: Alignment.bottomCenter,
                  colors: [welcomePrimaryColor, accentWelcomeColor])),
          child: isLoginin ? SafeArea(child: Container( color: Colors.white,child: Center(child: SpinKitWave(color: testColor,),),)) : Form(
            key: formKey,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.89,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: const Alignment(0, 0.1),
                        end: Alignment.bottomCenter,
                        colors: [welcomePrimaryColor, accentWelcomeColor])),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      const Text(
                        "Connecter",
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.07,
                            bottom:
                            MediaQuery.of(context).size.height * 0.07),
                        child: SvgPicture.asset(
                          "assets/login-other-1.svg",
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: MediaQuery.of(context).size.width * 0.55,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: Column(
                            children: [
                              RoundedTextField(
                                textController: _accountControlle,
                                icon: IconlyBroken.profile,
                                iconColor: Colors.white,
                                hintText: "Entrer identifiant",
                                labelText: "Identifiant",
                                labelColor: Colors.white,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.02,
                              ),
                              RoundedPasswordField(
                                  borderColor: Colors.white,
                                  textController: _passwordControlle,
                                  icon: Icons.lock,
                                  iconColor: Colors.white,
                                  suffixIconColor: Colors.white,
                                  hintText: "Entrer mot de passe",
                                  labelText: "Mot de passe",
                                  labelColor: Colors.white,
                                  validator: (value) {
                                    if (_resultCode == 401 || _resultCode == 400) {
                                      return '$_resultMessage';
                                    } else {
                                      return null;
                                    }
                                  }),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *0.050,
                              ),
                              RoundedButton(
                                press: () async {
                                  setState(() {
                                    isLoginin = true;
                                  });
                                  var result = await auth.login(LoginModel(_accountControlle.text, _passwordControlle.text));
                                  if(result.statusCode == 400){
                                    setState(() {
                                      isLoginin = false;
                                    });
                                    print(jsonDecode(result.message));
                                    if(jsonDecode(result.message).toString().contains('errorMessage')){
                                      showAchievementView(context, false, jsonDecode(result.message)['errorMessage']);
                                    }
                                    else{
                                      Map<String, dynamic> res= jsonDecode(result.message)['errors'];
                                      for(var er in res.values){
                                        showAchievementView(context, false, er.toString().split('[').last.split(']').first);
                                      }
                                    }
                                    //showAchievementView(context, false, jsonDecode(result.message))
                                    //showAchievementView(context, false, jsonDecode(result.message)['errorMessage']);
                                  }
                                  else if(result.statusCode == 401){
                                    setState(() {
                                      isLoginin = false;
                                    });
                                    showAchievementView(context, false, result.message);
                                  }
                                  else if(result.statusCode == 200){
                                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => const HomePage()), (route) => false,);
                                  }
                                  else{
                                    print(result.message);
                                    //showAchievementView(context, false, jsonDecode(result.message)['errorMessage']);
                                  }

                                },
                                text: 'Connecter',
                                color: Colors.white,
                                textColor: welcomePrimaryColor,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.02,
                              ),
                              RoundedButton(
                                  text: 'Inscription',
                                  color: Colors.white,
                                  textColor: welcomePrimaryColor,
                                  press: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterPage()));
                                  }),
                              SizedBox(
                                height: 50,
                              )
                            ],
                          )),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
