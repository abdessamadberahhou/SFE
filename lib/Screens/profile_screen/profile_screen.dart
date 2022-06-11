import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sfe_courrier/Model/Network/courier_methods.dart';
import 'package:sfe_courrier/Screens/components/achivment.dart';
import 'package:sfe_courrier/Screens/components/fixed_page.dart';
import 'package:sfe_courrier/Screens/components/constatnts.dart';
import 'package:sfe_courrier/Screens/components/rounded_button.dart';
import 'package:sfe_courrier/Screens/components/rounded_input_field.dart';
import 'package:sfe_courrier/Screens/components/rounded_password_field.dart';
import 'package:sfe_courrier/Screens/components/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Objects/user.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _teleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _ConfirmNewPasswordController = TextEditingController();
  final CourierMethods methods = CourierMethods();
  int? _resultCode;
  String? _resultMessage;
  String id = '';
  String nom = '';
  String prenom = '' ;
  String cin = '' ;
  String email = '' ;
  DateTime? dateNais;
  DateTime? newDate;
  String numTele = '' ;
  bool? isLoading;
  bool editPassword = false;
  bool enabled = false;
  String avatarDef = defaultAvatar;
  String avatar = defaultAvatar;
  Uint8List? bytes;
  String textButton = 'Modifier';
  getCreds() async{
    setState(() {
      isLoading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString('id_user')!;
      nom = pref.getString('nom_user')!;
      prenom = pref.getString('prenom_user')!;
      cin = pref.getString('cin_user')!;
      email = pref.getString('email_user')!;
      avatarDef = pref.getString('default_avatar').toString();
      avatar = pref.getString('avatar_user')!;
      List<String> splitedDate = pref.getString('date_nais_user')!.split('-');
      String tempDate = splitedDate[0]+splitedDate[1]+splitedDate[2]+'T000000' ;
      dateNais = DateTime.parse(tempDate);
      numTele = pref.getString('num_tele_user')!;
      List<int> list = avatarDef.codeUnits;
      bytes = Uint8List.fromList(list);
      isLoading = false;
      _nomController.text = nom;
      _prenomController.text = prenom;
      _teleController.text = numTele;
      _cinController.text = cin;
      _emailController.text = email;
      newDate = dateNais;
    });
  }
  @override
  void initState() {
    super.initState();
    getCreds();
  }

  File? image;
  Future PickImageFromGallery() async{
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    image = File(img!.path);
    if(image == null) return;

    final imageTemp = File(image!.path);
    setState((){
      image = imageTemp;
      List<int> imageBytes = image!.readAsBytesSync();
      avatar = base64Encode(imageBytes);
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
      avatar = base64Encode(imageBytes);
      Navigator.pop(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return FixedPage(
      canBack: true,
        body: isLoading! ? Center(child: SpinKitWave(
          color: welcomePrimaryColor,
        )) : SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: testColor,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                ),
                padding: const EdgeInsets.only(top: 25, bottom: 45),
                child: Center(
                  child: ProfileImage(avatar == '' ? avatarDef : avatar, enabled, (){
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
                      enabled: enabled,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.user,
                      hintText: 'Entrer votre nom',
                      labelText: 'Nom *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      textController: _prenomController,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.user,
                      hintText: 'Entrer votre prénom',
                      labelText: 'Prénom *',
                      labelColor: Colors.grey,
                      enabled: enabled,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      textController: _cinController,
                      enabled: enabled,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.document,
                      hintText: 'Entrer votre CIN',
                      labelText: 'CIN *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      textController: _emailController,
                      enabled: enabled,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.message,
                      hintText: 'Entrer votre e-mail',
                      labelText: 'E-mail *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DateTimeFormField(
                      initialValue: dateNais,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 15),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: enabled ? welcomePrimaryColor : Colors.grey, width: 0.75)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color:welcomePrimaryColor, width: 0.75)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
                        border: InputBorder.none,
                        prefixIcon: Icon(IconlyLight.calendar, color: enabled ? welcomePrimaryColor : Colors.grey),
                        labelText: 'Date',
                      ),
                      dateTextStyle: TextStyle(
                          color: enabled ? Colors.black : Colors.grey[600]
                      ),
                      enabled: enabled,
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                      onDateSelected: (DateTime value) {
                        setState(() {
                          newDate = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      isNumber: true,
                      textController: _teleController,
                      enabled: enabled,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.call,
                      hintText: 'Entrer votre numéro de téléphone',
                      labelText: 'Téléphone *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: enabled,
                      child: RoundedPasswordField(
                        validator: (value){if (!value!.ValidateCin()) {
                          return 'Enter un idantifiant validé';
                        } else if (_resultCode == 400) {
                          return '$_resultMessage';
                        } else {
                          return null;
                        }
                        },
                        textController: _passwordController,
                        enabled: enabled,
                        borderColor: welcomePrimaryColor,
                        iconColor: welcomePrimaryColor,
                        icon: IconlyLight.password,
                        hintText: editPassword ? 'Entrer votre ancien mot de passe' : 'Entrer votre mot de passe',
                        labelText: 'Mot de passe *',
                        labelColor: Colors.grey,
                      ),
                    ),
                    Visibility(
                      visible: enabled,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            editPassword = !editPassword;
                          });
                        },
                        child: const Text('Modifier le mot de passe'),
                      ),
                    ),
                    Visibility(
                      visible: editPassword,
                      child: RoundedPasswordField(
                        textController: _newPasswordController,
                        enabled: enabled,
                        borderColor: welcomePrimaryColor,
                        iconColor: welcomePrimaryColor,
                        icon: IconlyLight.password,
                        hintText: 'Entrer votre nouveau mot de passe',
                        labelText: 'Nouveau mot de passe',
                        labelColor: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: editPassword ? 20 : 0,
                    ),
                    Visibility(
                      visible: editPassword,
                      child: RoundedPasswordField(
                        textController: _ConfirmNewPasswordController,
                        enabled: enabled,
                        borderColor: welcomePrimaryColor,
                        iconColor: welcomePrimaryColor,
                        icon: IconlyLight.password,
                        hintText: 'Confirmer votre nouveau mot de passe',
                        labelText: 'Confirmer mot de passe',
                        labelColor: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: editPassword ? 20 : 0,
                    ),
                    RoundedButton(
                        text: textButton,
                        color: welcomePrimaryColor,
                        press: () async {
                          if(textButton == 'Modifier'){
                            if(await expiredToken()){
                              refreshToken();
                            }
                            setState(() {
                              textButton = 'Enregistrer';
                              enabled = true;
                            });
                          }else{
                            if(editPassword){
                              if (_newPasswordController.text != _ConfirmNewPasswordController.text) {
                                showAchievementView(context, false, 'Verifier vos nouveau mot de passe');
                              }
                              else{
                                setState(() {
                                  isLoading = false;
                                });
                                User user = User();
                                user.Id = id;
                                user.FirstName = _prenomController.text;
                                user.NumTele = _teleController.text;
                                user.BirthDay = newDate.toString().split(' ').first;
                                user.LastName = _nomController.text;
                                user.Email = _emailController.text;
                                user.Cin = _cinController.text;
                                user.Password = _passwordController.text;
                                user.NewPassword = _newPasswordController.text;
                                user.Avatar = avatar;
                                var result = await methods.UpdateUser(user);
                              if (result.statusCode == 200) {
                                  showAchievementView(
                                      context, true, jsonDecode(result.message));
                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                  await pref.setString("nom_user", user.LastName.toString());
                                  await pref.setString("prenom_user", user.FirstName.toString());
                                  await pref.setString("cin_user", user.Cin.toString());
                                  await pref.setString("email_user", user.Email.toString());
                                  await pref.setString("date_nais_user", user.BirthDay.toString());
                                  await pref.setString("num_tele_user", user.NumTele.toString());
                                  await pref.setString('avatar_user', avatar);
                                  setState(() {
                                    isLoading = false;
                                    textButton = 'Modifier';
                                    enabled = false;
                                    editPassword = false;
                                    _passwordController.clear();
                                    _newPasswordController.clear();
                                    _ConfirmNewPasswordController.clear();
                                  });
                                } else {
                                if (result.message.contains('Password')) {
                                  showAchievementView(context, false,'Champs mot de passe obligatoire');return 0;
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                                else {
                                  showAchievementView(context, false,jsonDecode(result.message)['errorMessage']);
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                              }
                            } else{
                              setState(() {
                                isLoading = false;
                              });
                              User user = User();
                              user.Id = id;
                              user.FirstName = _prenomController.text;
                              user.NumTele = _teleController.text;
                              user.BirthDay = newDate.toString().split(' ').first;
                              user.LastName = _nomController.text;
                              user.Email = _emailController.text;
                              user.Cin = _cinController.text;
                              user.Password = _passwordController.text;
                              user.NewPassword = '';
                              user.Avatar = avatar;
                              var result = await methods.UpdateUser(user);
                              if (result.statusCode == 200) {
                                showAchievementView(
                                    context, true, jsonDecode(result.message));
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                await pref.setString("nom_user", user.LastName.toString());
                                await pref.setString("prenom_user", user.FirstName.toString());
                                await pref.setString("cin_user", user.Cin.toString());
                                await pref.setString("email_user", user.Email.toString());
                                await pref.setString("date_nais_user", user.BirthDay.toString());
                                await pref.setString("num_tele_user", user.NumTele.toString());
                                await pref.setString('avatar_user', avatar);
                                setState(() {
                                  isLoading = false;
                                  textButton = 'Modifier';
                                  enabled = false;
                                  editPassword = false;
                                  _passwordController.clear();
                                  _newPasswordController.clear();
                                  _ConfirmNewPasswordController.clear();
                                });
                              } else {
                                if (result.message.contains('Password')) {
                                  showAchievementView(context, false,' Mot de passe obligatoire ou incorrect');return 0;
                                }
                                else {
                                  showAchievementView(context, false,jsonDecode(result.message)['errorMessage']);
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }

                            }
                          }
                         }
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RoundedButton(
                        text: 'Annuler',
                        color: welcomePrimaryColor,
                        press: () {
                          if(textButton == 'Enregistrer'){
                            setState(() {
                              textButton = 'Modifier';
                              _newPasswordController.text = '';
                              _ConfirmNewPasswordController.text = '';
                              editPassword = false;
                              enabled = false;
                            });
                          }
                          else{
                            Navigator.of(context).pop();
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
}
Widget ProfileImage(avatar, isVisible, function) {
  return SizedBox(
    width: 200,
    height: 200,
    child: Stack(
      children:[
        SizedBox(
          width: 200,
          height: 200,
          child : ClipOval(
              child: Image.memory(base64Decode(avatar ?? defaultAvatar) ,fit: BoxFit.cover,)
          ),
        ),
        Align(
          alignment: const Alignment(0.7,1),
          child: Container(
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            width: 35,
            height: 35,
            child: Visibility(
              visible: isVisible,
              child: FloatingActionButton(
                onPressed: function,
                child: const Icon(IconlyLight.camera, color: Colors.black,),
                elevation: 1,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


