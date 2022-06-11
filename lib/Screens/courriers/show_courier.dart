import 'dart:convert';
import 'dart:io';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:sfe_courrier/Model/Network/api_link.dart';
import 'package:sfe_courrier/Model/Network/courier_methods.dart';
import 'package:sfe_courrier/Objects/files.dart';
import 'package:sfe_courrier/Screens/components/constatnts.dart';
import 'package:sfe_courrier/Screens/components/fixed_page.dart';
import 'package:sfe_courrier/Screens/components/rounded_button.dart';
import 'package:sfe_courrier/Screens/components/rounded_input_field.dart';
import 'package:sfe_courrier/Screens/home_sccren/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Objects/courrier.dart';
import '../components/widgets.dart';

class ShowCourier extends StatefulWidget {
  Courier? c;
  ShowCourier(this.c);
  @override
  State<ShowCourier> createState() => _ShowCourierState();
}

class _ShowCourierState extends State<ShowCourier> {


  final List<String> tags = [];
  bool isLoading = false;

  File? image;
  List<FileRequest> allFiles = [];
  Map<String, dynamic> stringToMap(String s) {
    Map<String, dynamic> map = json.decode(s);
    return map;
  }
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
    for(int i = 0;i<files.length;i++){
      FileRequest f = FileRequest(
          files[i]['idFile'],
          files[i]['idCourrier'],
          files[i]['file1'],
          files[i]['fileName'],
          files[i]['fileExtention'],
      );
      allFiles.add(f);
    }
    setState(() {
      isLoading = false;
    });
  }
  Courier? cour;
  bool? isChecked;
  DateTime? da;
  List<String>? tdate;
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
    GetFiles();
    if(cour!.typeCourier == 'Courrier Départ'){
      typeValue = 'Courrier Départ';
    }
    else{
      typeValue = 'Courrier Arrivé';
    }
  }
  String typeValue = 'Courrier Départ';
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
      body: SingleChildScrollView(
        child: isLoading ? Padding(child: Center(child: SpinKitWave(color: welcomePrimaryColor,)), padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.40),) : Container(
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
                    child: ShowImageBuilder(paths: allFiles,isvisible: false,),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 45),
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: false ? welcomePrimaryColor : Colors.grey,),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: DropdownButton<String>(
                            hint: const Text("Type de courrier"),
                            value: typeValue,
                            icon: const Icon(IconlyLight.arrow_down_2),
                            isExpanded: true,
                            underline: const SizedBox(),
                            onChanged: (newValue) {

                            },
                            items: <String>[typeValue]
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
                        enabled: false,
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
                        enabled: false,
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
                        enabled: false,
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
                        enabled: false,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: false ? welcomePrimaryColor : Colors.grey, width: 0.75)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color:welcomePrimaryColor, width: 0.75)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
                          border: InputBorder.none,
                          prefixIcon: Icon(IconlyLight.calendar, color: false ? welcomePrimaryColor : Colors.grey),
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
                      TagTextField(tagArray: tags,initTags: listTags, enabled: false,),
                      const SizedBox(
                        height: 20,
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
                            activeColor: Colors.grey,
                            checkColor: Colors.white,
                            value: isChecked,
                            onChanged: (bool? value) {

                            },
                          )
                        ],
                      ),
                      RoundedButton(
                        text: "Annuler",
                        press: ()async{
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const HomePage()), (route) => false);
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



