import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:sfe_courrier/Model/Network/authentication.dart';
import 'package:sfe_courrier/Screens/components/achivment.dart';
import 'package:sfe_courrier/Screens/components/validators.dart';
import 'package:sfe_courrier/Screens/login/login_page.dart';

import '../../Objects/user.dart';
import '../components/constatnts.dart';
import '../components/rounded_button.dart';
import '../components/rounded_input_field.dart';
import '../components/rounded_password_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  DateTime? newDate;
  Authentication auth = Authentication();
  bool passwordDoesMatch = true;
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _numTeleController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final TextEditingController _confirmerMotDePasseController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: const Alignment(0, 0.1),
                  end: Alignment.bottomCenter,
                  colors: [welcomePrimaryColor, accentWelcomeColor])),
          child:Form(
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
                        "Inscription",
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
                          "assets/login.svg",
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: MediaQuery.of(context).size.width * 0.55,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: Column(
                            children: [
                              RoundedTextField(
                                textController: _nomController,
                                icon: IconlyBroken.profile,
                                iconColor: Colors.white,
                                hintText: "Entrer Nom",
                                labelText: "Nom *",
                                labelColor: Colors.white,
                                validator: (value) {
                                  return null;
                                

                                },
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.02,
                              ),
                              RoundedTextField(
                                textController: _prenomController,
                                icon: IconlyBroken.profile,
                                iconColor: Colors.white,
                                hintText: "Entrer pr??nom",
                                labelText: "Pr??nom *",
                                labelColor: Colors.white,
                                validator: (value) {
                                  return null;
                                

                                },
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.02,
                              ),
                              RoundedTextField(
                                textController: _emailController,
                                icon: IconlyBroken.message,
                                iconColor: Colors.white,
                                hintText: "Entrer email",
                                labelText: "Email *",
                                labelColor: Colors.white,
                                validator: (value) {
                                  return null;
                                

                                },
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.02,
                              ),
                              RoundedTextField(
                                textController: _cinController,
                                icon: IconlyBroken.document,
                                iconColor: Colors.white,
                                hintText: "Entrer CIN",
                                labelText: "CIN *",
                                labelColor: Colors.white,
                                validator: (value) {
                                  if (!value!.ValidateCin()) {
                                    return 'Enter CIN valid??';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.02,
                              ),
                              DateTimeFormField(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white, width: 0.75)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.white, width: 0.75)),
                                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
                                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(IconlyLight.calendar, color: Colors.white),
                                  labelText: 'Date *',
                                  labelStyle: const TextStyle(color: Colors.white)
                                ),
                                dateTextStyle: const TextStyle(
                                    color: Colors.white
                                ),
                                mode: DateTimeFieldPickerMode.date,
                                autovalidateMode: AutovalidateMode.always,
                                validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                                onDateSelected: (DateTime value) {
                                  setState(() {
                                    newDate = value;
                                  });
                                },
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.02,
                              ),
                              RoundedTextField(
                                isNumber: true,
                                textController: _numTeleController,
                                icon: IconlyBroken.call,
                                iconColor: Colors.white,
                                hintText: "Entrer num??ro de t??l??phone",
                                labelText: "Num??ro de t??l??phone *",
                                labelColor: Colors.white,
                                validator: (value) {
                                  if (RegExp(r'^[A-Za-z]+$').hasMatch(value!)) {
                                    return 'Enter num??ro de t??l??phone valid??';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.02,
                              ),
                              RoundedPasswordField(
                                  textController: _motDePasseController,
                                  borderColor: Colors.white,
                                  icon: Icons.lock,
                                  iconColor: Colors.white,
                                  suffixIconColor: Colors.white,
                                  hintText: "Entrer mot de passe",
                                  labelText: "Mot de passe *",
                                  labelColor: Colors.white,
                                  validator: (value) {
                                    if (!passwordDoesMatch) {
                                      return 'verifi?? les mots de passes';
                                    } else {
                                      return null;
                                    }
                                  }),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.02,
                              ),
                              RoundedPasswordField(
                                  textController: _confirmerMotDePasseController,
                                  borderColor: Colors.white,
                                  icon: Icons.lock,
                                  iconColor: Colors.white,
                                  suffixIconColor: Colors.white,
                                  hintText: "Confirmer mot de passe",
                                  labelText: "Confirmer mot de passe *",
                                  labelColor: Colors.white,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *0.050,
                              ),
                              RoundedButton(
                                press: () async {
                                  if(_motDePasseController.text != _confirmerMotDePasseController.text){
                                    showAchievementView(context, false, 'verifi?? les mots de passe');
                                  }
                                  else{
                                    if(
                                        _nomController.text.contains(RegExp(r'[0-9]')) ||
                                        _prenomController.text.contains(RegExp(r'[0-9]')) ||
                                        _numTeleController.text.contains(RegExp(r'[A-Za-z]')) ||
                                        !_emailController.text.contains(RegExp(r'^(?=.*?[a-z])(?=.*?[@]).{8,}$')) ||
                                        _numTeleController.text == '' ||
                                        _nomController.text == '' ||
                                        _emailController.text == '' ||
                                        _cinController.text == '' ||
                                        _prenomController.text == ''
                                    ){
                                      showAchievementView(context, false, 'Respect?? les types des champs svp');}
                                    else{
                                      if(_emailController.text.isValidEmail()){
                                        User user = User() ;
                                        user.LastName = _nomController.text;
                                        user.FirstName = _prenomController.text;
                                        user.Email = _emailController.text;
                                        user.Cin = _cinController.text;
                                        user.NumTele = _numTeleController.text;
                                        user.BirthDay = newDate.toString().split(' ').first;
                                        user.Password = _motDePasseController.text;
                                        user.Avatar = defaultAvatar;
                                        var result = await auth.RegisterUser(user);
                                        if(result.statusCode == 200){
                                          showAchievementView(context, true, jsonDecode(result.message));
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
                                        }else{
                                          showAchievementView(context, false, jsonDecode(result.message)['errorMessage']);
                                        }
                                      }else{
                                        showAchievementView(context, false, 'Entrer un email valid??');
                                      }
                                    }
                                  }
                                },
                                text: "S'incrire",
                                color: Colors.white,
                                textColor: welcomePrimaryColor,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.02,
                              ),
                              // RoundedButton(
                              //     text: 'Connexion',
                              //     color: Colors.white,
                              //     textColor: welcomePrimaryColor,
                              //     press: (){
                              //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                              //     }),
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.02,
                              ),
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
