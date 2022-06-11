import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sfe_courrier/Model/Network/courier_methods.dart';
import 'package:sfe_courrier/Objects/files.dart';
import 'package:sfe_courrier/Screens/components/widgets.dart';
import 'package:sfe_courrier/Screens/components/constatnts.dart';
import 'package:sfe_courrier/Screens/components/fixed_page.dart';
import 'package:sfe_courrier/Screens/components/rounded_button.dart';
import 'package:sfe_courrier/Screens/components/rounded_input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Objects/courrier.dart';
import '../components/achivment.dart';

class AddCourier extends StatefulWidget {
  const AddCourier({Key? key}) : super(key: key);

  @override
  State<AddCourier> createState() => _AddCourierState();
}

class _AddCourierState extends State<AddCourier> {
  final List<String> tags = [];
  List<File> paths = [];


  List<FileRequest> files = [];

  File? image;

  Future pickImageFromGallery(List<FileRequest> files) async{
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      image = File(img!.path);
      if(image == null) return;

      final imageTemp = File(image!.path);
      image = imageTemp;
      setState((){
        List<int> imageBytes = image!.readAsBytesSync();
        FileRequest f = FileRequest(
            "00000000-0000-0000-0000-000000000000",
            "0",
            base64Encode(imageBytes),
            image!.path.split('/').last,
            image!.path.split('/').last.split('.').last);
        files.add(f);
        paths.add(image!);
      });
  }
  Future pickImageFromCamera(List<FileRequest> files) async{
    final img = await ImagePicker().pickImage(source: ImageSource.camera);
    image = File(img!.path);
    if(image == null) return;

    setState((){
      List<int> imageBytes = image!.readAsBytesSync();
      FileRequest f = FileRequest(
          "00000000-0000-0000-0000-000000000000",
          "0",
          base64Encode(imageBytes),
          image!.path.split('/').last,
          image!.path.split('/').last.split('.').last);
      files.add(f);
      paths.add(image!);
    });
  }
  String typeValue = 'Courrier Départ';
  String date = '';
  final TextEditingController _objetController =  TextEditingController();
  final TextEditingController _expediteurController =  TextEditingController();
  final TextEditingController _destinataireController =  TextEditingController();
  CourierMethods methods = CourierMethods();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FixedPage(
      canBack: true,
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: testColor,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                  ),
                  child: InkWell(
                    onTap: (){
                      paths.isEmpty ? null : methods.DialogViewer(context, paths);
                    },
                    child: ImageBuilder(paths: paths, bckColor: testColor,),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: welcomePrimaryColor,
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: MaterialButton(
                                child: const Icon(IconlyLight.image, size: 50, color: Colors.white,),
                                onPressed: () {
                                  pickImageFromGallery(files);
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: welcomePrimaryColor,
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: MaterialButton(
                                child: const Center(child: Icon(IconlyLight.camera, size: 50, color: Colors.white,)),
                                onPressed: () {
                                  pickImageFromCamera(files);
                                },
                              ),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: welcomePrimaryColor,),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: DropdownButton<String>(
                          hint: const Text("Type de courrier"),
                          value: typeValue,
                          icon: const Icon(IconlyLight.arrow_down_2),
                          isExpanded: true,
                          underline: const SizedBox(),
                          onChanged: (newValue) {
                            setState(() {
                              typeValue = newValue!;
                            });
                          },
                          items: <String>['Courrier Départ', 'Courrier Arrivé']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      ),
                      SizedBox(
                        height: size.height*0.03,
                      ),
                      RoundedTextField(
                        textController: _objetController,
                        borderColor: welcomePrimaryColor,
                        labelText: "Objet *",
                        hintText: "Entrer l'objet",
                        icon: IconlyLight.paper,
                        labelColor: Colors.grey[600],
                        iconColor: welcomePrimaryColor,
                      ),
                      SizedBox(
                        height: size.height*0.03,
                      ),
                      RoundedTextField(
                        textController: _expediteurController,
                        borderColor: welcomePrimaryColor,
                        labelText: "Expediteur *",
                        hintText: "Expediteur",
                        icon: IconlyLight.upload,
                        labelColor: Colors.grey[600],
                        iconColor: welcomePrimaryColor,
                      ),
                      SizedBox(
                        height: size.height*0.03,
                      ),
                      RoundedTextField(
                        textController: _destinataireController,
                        borderColor: welcomePrimaryColor,
                        labelText: "Destinataire *",
                        hintText: "Destinataire",
                        icon: IconlyLight.download,
                        labelColor: Colors.grey[600],
                        iconColor: welcomePrimaryColor,
                      ),
                      SizedBox(
                        height: size.height*0.03,
                      ),
                      DateTimeFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: welcomePrimaryColor, width: 0.75)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color:welcomePrimaryColor, width: 0.75)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
                          border: InputBorder.none,
                          prefixIcon: Icon(IconlyLight.calendar, color: welcomePrimaryColor),
                          labelText: 'Date',
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                        onDateSelected: (DateTime value) {
                          String s = value.toString();
                          int idx = s.indexOf(" ");
                          List parts = [s.substring(0,idx).trim()];
                          setState(() {
                            date = parts[0];
                          });
                        },
                      ),
                      SizedBox(
                        height: size.height*0.03,
                      ),
                      Container(
                          child: TagTextField(tagArray: tags)
                      ),
                      SizedBox(
                        height: size.height*0.015,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Urgent",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: removeColor,
                              fontSize: 18
                            ),
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RoundedButton(
                        text: "Ajouter",
                        press: ()async{
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          String idUser = pref.getString('id_user')!;
                          List<String> result = LinkedHashSet<String>.from(tags).toList();
                          String finaltags = '';
                          int checked;
                          for(int i = 0;i<result.length;i++){
                            finaltags += result[i]+' ';
                          }
                          if(isChecked){
                            checked = 1;
                          }
                          else{
                            checked = 0;
                          }
                           Courier courier = Courier('',typeValue,_objetController.text,_expediteurController.text,_destinataireController.text,date,finaltags,0,0,checked,idUser);
                           var response = await methods.SaveCourier(courier, files);
                          if(response.statusCode == 200){
                            showAchievementView(context, true, response.message);
                            _objetController.clear();
                            _expediteurController.clear();
                            _destinataireController.clear();
                            result.clear();
                          }
                          else{
                            showAchievementView(context, false, response.message);
                          }
                        },
                        color: welcomePrimaryColor,
                        textColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


