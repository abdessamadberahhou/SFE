import 'dart:convert';
import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sfe_courrier/Model/Network/courier_methods.dart';
import 'package:sfe_courrier/Screens/components/achivment.dart';

import '../../Objects/user.dart';
import '../components/constatnts.dart';
import '../components/fixed_page.dart';
import '../components/rounded_button.dart';
import '../components/rounded_input_field.dart';
import '../components/rounded_password_field.dart';
import '../profile_screen/profile_screen.dart';



class EditUser extends StatefulWidget {
  final User? user;
  const EditUser({Key? key, this.user}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  User user = User();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numTeleController = TextEditingController();
  final TextEditingController _motDePasseTeleController = TextEditingController();
  DateTime finalDate = DateTime.now();
  String avatar = defaultAvatar;
  File? image;
  CourierMethods methods = CourierMethods();



  Future PickImageFromGallery() async{
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    image = File(img!.path);
    if(image == null) return;

    final imageTemp = File(image!.path);
    setState((){
      image = imageTemp;
      List<int> imageBytes = image!.readAsBytesSync();
      user.Avatar = base64Encode(imageBytes);
      Navigator.pop(context);
    });
  }

  Future PickImageFromCamera() async{
    final img = await ImagePicker().pickImage(source: ImageSource.camera);
    image = File(img!.path);
    if(image == null) return;

    final imageTemp = File(image!.path);
    setState((){
      image = imageTemp;
      List<int> imageBytes = image!.readAsBytesSync();
      user.Avatar = base64Encode(imageBytes);
      Navigator.pop(context);
    });
  }




  Future<void> showCameraDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            title: Row(
              children: const [
                Text('Image')
              ],
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: (){
                      PickImageFromGallery();
                    },
                    child: const SizedBox(
                      height: 50,
                      child: Center(
                        child: Icon(IconlyLight.image, size: 75),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      PickImageFromCamera();
                    },
                    child: const SizedBox(
                      height: 50,
                      child: Center(
                        child: Icon(IconlyLight.camera, size: 75),
                      ),
                    ),
                  ),
                ],
              ),
            actions: [
              TextButton(
                child: const Text('Annuler', style: TextStyle(color: Colors.black),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }



  @override
  void initState() {
    super.initState();
    user = widget.user!;
    FillUser();
  }
  FillUser(){
    _nomController.text = user.LastName.toString();
    _prenomController.text = user.FirstName.toString();
    _cinController.text = user.Cin.toString();
    _emailController.text = user.Email.toString();
    _numTeleController.text = user.NumTele.toString();
    finalDate = DateTime.parse(user.BirthDay.toString()+'T000000');
  }
  @override

  @override
  Widget build(BuildContext context) {
    return FixedPage(
        canBack: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: testColor,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                ),
                padding: const EdgeInsets.only(top: 25, bottom: 45),
                child: Center(
                    child: ProfileImage(user.Avatar == '' ? defaultAvatar : user.Avatar, true, (){
                      showCameraDialog(context);
                    })
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal:  25),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    RoundedTextField(
                      textController: _nomController,
                      //initValue: _nomController.text,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.user,
                      hintText: 'Entrer nom',
                      labelText: 'Nom *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      textController: _prenomController,
                      //initValue: _prenomController.text,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.user,
                      hintText: 'Entrer prénom',
                      labelText: 'Prénom *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      textController: _cinController,
                      //initValue: _cinController.text,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.document,
                      hintText: 'Entrer CIN',
                      labelText: 'CIN *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      textController: _emailController,
                      //initValue: _emailController.text,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.message,
                      hintText: 'Entrer e-mail',
                      labelText: 'E-mail *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DateTimeFormField(
                      initialValue: finalDate,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 15),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: welcomePrimaryColor)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color:welcomePrimaryColor, width: 0.75)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
                        border: InputBorder.none,
                        prefixIcon: Icon(IconlyLight.calendar, color: welcomePrimaryColor),
                        labelText: 'Date',
                      ),
                      dateTextStyle: const TextStyle(
                          color: Colors.black
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                      onDateSelected: (DateTime value) {
                        setState(() {
                          finalDate = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      textController: _numTeleController,
                      //initValue: _numTeleController.text,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.call,
                      hintText: 'Entrer numéro de téléphone',
                      labelText: 'Téléphone *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedPasswordField(
                      textController: _motDePasseTeleController,
                      enabled: true,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.password,
                      hintText: 'Entrer nouveau mot de passe',
                      labelText: 'Mot de passe *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedButton(
                        text: 'Modifier',
                        color: welcomePrimaryColor,
                        press: () async {
                          user.LastName = _nomController.text;
                          user.FirstName =_prenomController.text;
                          user.Cin = _cinController.text;
                          user.Email = _emailController.text ;
                          user.NumTele = _numTeleController.text;
                          user.BirthDay = finalDate.toString().split(' ').first;
                          if(_motDePasseTeleController.text != ''){
                            user.Password = _motDePasseTeleController.text;
                          }else{
                            user.Password = '';
                          }
                          var response  = await methods.AdminUpdateUser(user);
                          if(response.statusCode == 200){
                            showAchievementView(context, true, response.message);
                          }else{
                            showAchievementView(context, false, response.statusCode.toString());
                          }
                        }
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}
