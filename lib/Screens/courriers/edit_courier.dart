import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sfe_courrier/Model/Network/courier_methods.dart';
import 'package:sfe_courrier/Screens/components/constatnts.dart';
import 'package:sfe_courrier/Screens/components/fixed_page.dart';
import 'package:sfe_courrier/Screens/components/rounded_button.dart';
import 'package:sfe_courrier/Screens/components/rounded_input_field.dart';
import 'package:sfe_courrier/Screens/home_sccren/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/Network/api_link.dart';
import '../../Objects/courrier.dart';
import '../../Objects/files.dart';
import '../components/achivment.dart';
import '../components/widgets.dart';

class EditCourier extends StatefulWidget {
  Courier? c;
  EditCourier(this.c);
  @override
  State<EditCourier> createState() => _EditCourierState();
}

class _EditCourierState extends State<EditCourier> {


  final List<String> tags = [];


  File? image;

  bool isLoading = false;


  Future pickImageFromGallery() async{
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    image = File(img!.path);
    if(image == null) return;

    final imageTemp = File(image!.path);
    image = imageTemp;
    setState((){
      List<int> imageBytes = image!.readAsBytesSync();
      FileRequest f = FileRequest(
          '00000000-0000-0000-0000-000000000000',
          '',
          base64Encode(imageBytes),
          image!.path.split('/').last,
          image!.path.split('/').last.split('.').last);
      allFiles.add(f);
    });
  }
  Future pickImageFromCamera() async{
    final img = await ImagePicker().pickImage(source: ImageSource.camera);
    image = File(img!.path);
    if(image == null) return;

    final imageTemp = File(image!.path);
    image = imageTemp;
    setState((){
      List<int> imageBytes = image!.readAsBytesSync();
      FileRequest f = FileRequest(
          '00000000-0000-0000-0000-000000000000',
          '',
          base64Encode(imageBytes),
          image!.path.split('/').last,
          image!.path.split('/').last.split('.').last);
      allFiles.add(f);
    });
  }
  Courier? cour;
  bool? isChecked;
  DateTime? da;
  List<String>? tdate;
  String typeValue = '';
  List<FileRequest> allFiles = [];
  List<FileRequest> newFiles = [];


  void GetFiles() async{
   setState(() {
     isLoading = true;
   });
   SharedPreferences pref = await SharedPreferences.getInstance();
   String? accessToken = pref.getString('token');
    var _link = Uri.parse(api+"/courrier/show/"+cour!.id);
    var result = await http.get(_link, headers: {
      "Content-type":"application/json",
      "Accept":"application/json",
      "Authorization" : "Bearer "+accessToken.toString()
    });
    List files = await json.decode(result.body)['files'];
    if(files.isEmpty){
      setState(() {
        isLoading = false;
      });
    }
    for(int i = 0;i<files.length;i++){
      FileRequest f = FileRequest(
        files[i]['idFile'],
        files[i]['idCourrier'],
        files[i]['file1'],
        files[i]['fileName'],
        files[i]['fileExtention'],
      );
      setState(() {
        allFiles.add(f);
        isLoading = false;
      });
    }
  }





  @override
  void initState() {
    super.initState();
    cour = widget.c!;
    isChecked =  widget.c!.isUrgent == 1 ? true : false;
    _objetController.text = widget.c!.objet;
    _expediteurController.text = widget.c!.exporter;
    _destinataireController.text = widget.c!.dest;
    tdate = cour!.date.split("-");
    String newDate = tdate![0]+tdate![1]+tdate![2]+'T000000';
    da = DateTime.parse(newDate);
    if(cour!.typeCourier == 'Courrier Départ'){
      typeValue = 'Courrier Départ';
    }
    else{
      typeValue = 'Courrier Arrivé';
    }
    GetFiles();
  }


   final TextEditingController _objetController =  TextEditingController();
  final TextEditingController _expediteurController =  TextEditingController();
  final TextEditingController _destinataireController =  TextEditingController();
  CourierMethods methods = CourierMethods();

  @override
  Widget build(BuildContext context) {
    String initTags = cour!.tags;
    List<String> listTags = initTags.split(" ");
    if(listTags[listTags.length-1] == ''){
      listTags.removeAt(listTags.length-1);
    }
    return FixedPage(
      canBack: true,
      body: isLoading ? Center(child: SpinKitWave(
        color: welcomePrimaryColor,
      )) : SingleChildScrollView(
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
                      allFiles.isEmpty ? null : methods.DialogViewer(context, allFiles);
                    },
                    child: ShowImageBuilder(paths: allFiles,isvisible: true, onPress: (){

                    },type:  'modifier',),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 45),
                  child: Column(
                    children: [
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
                        height: MediaQuery.of(context).size.height*0.03,
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
                        height: MediaQuery.of(context).size.height*0.03,
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
                        height: MediaQuery.of(context).size.height*0.03,
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
                        height: MediaQuery.of(context).size.height*0.03,
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
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                        initialValue:  da,
                        onDateSelected: (DateTime value) {
                          setState(() {
                            da = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.03,
                      ),
                      TagTextField(tagArray: tags,initTags: listTags,),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
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
                                pickImageFromGallery();
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
                                pickImageFromCamera();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
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
                      RoundedButton(
                          text: "Modifier",
                        press: ()async{
                          if(isChecked!){
                            cour!.isUrgent = 1;
                          }
                          else{
                            cour!.isUrgent = 0;
                          }
                          List<String> result =LinkedHashSet<String>.from(tags).toList();
                          String type= typeValue;
                          String? objet= _objetController.text;
                          String? expediteur = _expediteurController.text;
                          String? destinataire = _destinataireController.text;
                          String finaltags = '';
                          for(int i = 0;i<result.length;i++){
                            finaltags += result[i]+' ';
                          }
                          List finalDate = da.toString().split(' ');
                          cour!.objet = objet;
                          cour!.typeCourier = type;
                          cour!.exporter = expediteur;
                          cour!.dest = destinataire;
                          cour!.tags = finaltags;
                          cour!.date = finalDate[0];
                          var response = await methods.EditCourier(cour, allFiles);
                          if(response.statusCode == 200){
                            showAchievementView(context, true, response.message);
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const HomePage()), (route) => false);
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



