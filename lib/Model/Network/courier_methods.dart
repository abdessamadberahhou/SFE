import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:sfe_courrier/Model/Network/api_link.dart';
import 'package:http/http.dart' as http;
import 'package:sfe_courrier/Model/add_result_model.dart';
import 'package:sfe_courrier/Objects/courrier.dart';
import 'package:sfe_courrier/Objects/files.dart';
import 'package:sfe_courrier/Screens/components/achivment.dart';
import 'package:sfe_courrier/Screens/components/constatnts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Objects/user.dart';
import '../../Screens/components/widgets.dart';

class CourierMethods {


  Future<AddResultModel> EditCourier(Courier? c, List<FileRequest> newFiles) async{
    if(await expiredToken()){
      refreshToken();
    }

    List<Map> fileOptionJson = [];
    for(int i =0;i< newFiles.length;i++){
      FileJson fileJson = FileJson(newFiles[i]);
      fileOptionJson.add(fileJson.TojsonData());
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString('token')!;
    var _link = Uri.parse('$api/courrier/edit/'+c!.id.toString());
    var response = await http.post(_link,headers: {
      "Content-type":"application/json",
      "Accept":"application/json",
      "Authorization" : "Bearer "+accessToken
    }, body: jsonEncode({
      "typeCourrier": c.typeCourier.toString(),
      "objetCourrier": c.objet,
      "expiditeurCourrier": c.exporter,
      "destinataireCourrier": c.dest,
      "dateCourrier": c.date,
      "tagsCourrier": c.tags,
      "courrierUrgent": c.isUrgent,
      "files": fileOptionJson
    }));
    if(response.statusCode == 200){
      return AddResultModel(200, 'Courrier modifié avec succée');
    } else if(response.statusCode == 400){
      return AddResultModel(400, response.body);
    } else{
      return AddResultModel(response.statusCode, response.body);
    }
  }

  Future<AddResultModel> UpdateUser (User user) async {
    if(await expiredToken()){
      refreshToken();
    }
    var _link = Uri.parse('$api/admin/modify/user/'+user.Id.toString());
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString('token')!;
    var respo = await  http.post(_link, headers: {
      "Content-type":"application/json",
      "Accept":"application/json",
      "Authorization" : "Bearer "+accessToken
    }, body: jsonEncode({
        "email": user.Email,
        "firstName": user.FirstName,
        "lastName": user.LastName,
        "birthDay": user.BirthDay,
        "cin": user.Cin,
        "password": user.Password,
        "newPassword": user.NewPassword,
        "numTele": user.NumTele,
        "avatar": user.Avatar
    }));
    final body = json.decode(respo.body);
    if (respo.statusCode == 400){
      return AddResultModel(respo.statusCode,body['errors']['Password'][0]);
    }
    else{
      return AddResultModel(respo.statusCode, respo.body);
      }
    }




  Future<AddResultModel> SaveCourier(Courier c, List<FileRequest> images) async{
    if(await expiredToken()){
      refreshToken();
    }
    List<Map> fileOptionJson = [];
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString('token')!;
    for(int i =0;i< images.length;i++){
      FileJson fileJson = FileJson(images[i]);
      fileOptionJson.add(fileJson.TojsonData());
    }
    var _link = Uri.parse('$api/courrier/add/courier');
    var response = await http.post(_link,headers: {
        "Content-type":"application/json",
        "Accept":"application/json",
        "Authorization" : "Bearer "+accessToken
    }, body: jsonEncode({
      "id": "",
      "typeCourrier": c.typeCourier,
      "objetCourrier": c.objet,
      "expiditeurCourrier": c.exporter,
      "destinataireCourrier": c.dest,
      "dateCourrier": c.date,
      "tagsCourrier": c.tags,
      "courrierUrgent": c.isUrgent,
      "idUser": c.idUser,
      "files": fileOptionJson
    }));
    if(response.statusCode == 200){
      return AddResultModel(200, 'Courrier ajouté avec succée');
    } else if(response.statusCode == 400){
      return AddResultModel(400, response.body);
    } else{
      return AddResultModel(response.statusCode, response.body);
    }
  }







  Future<void> showMyDialog(context, function, message) async {
    if(message == ''){
      message = '';
    }else{
      message = message;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          title: Row(
            children: [
              Icon(IconlyLight.danger, color: removeColor,size: 35,),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Vous-voulez vraiment supprimer $message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler', style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Supprimer', style: TextStyle(color: removeColor),),
              onPressed: function,
            ),
          ],
        );
      },
    );
  }



  Future<void> DialogViewer(context, List paths) async {
    PageController? _controller;
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: paths.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: paths.runtimeType.toString() == 'List<FileRequest>' ? ShowImageViewer(path: paths[index]) :  ImageViewer(path: paths[index]),
                );
              }
          ),
        );
      },
    );
  }

  Future<AddResultModel> uploadImage(id, base64, filename, fileExtention) async {
    if(await expiredToken()){
      refreshToken();
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString('token')!;
    var request = await http.post(Uri.parse('$api/courrier/upload-file/'+id), headers: {
      "Content-type":"application/json",
      "Accept":"application/json",
      "Authorization" : "Bearer "+accessToken
    }, body: jsonEncode({
      "idCourrier":'',
      "file": "$base64",
      "fileName":"$filename",
      "fileExtention":"$fileExtention"
    }));
    return AddResultModel(request.statusCode, (request.body));
  }

  Future<AddResultModel> AdminUpdateUser(User user) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('token');
    Uri _link = Uri.parse('$api/admin/modify/'+1.toString());
    var response = await http.post(_link, headers: {
      "Content-type":"application/json",
      "Accept":"application/json",
      "Authorization" : "Bearer "+accessToken.toString()
    }, body: jsonEncode({
      "id": user.Id,
      "email": user.Email,
      "firstName": user.FirstName,
      "lastName": user.LastName,
      "birthDay": user.BirthDay,
      "cin": user.Cin,
      "password": user.Password,
      "numTele": user.NumTele,
      "avatar": user.Avatar
    }));
    return AddResultModel(response.statusCode, jsonDecode(response.body));

  }


}

class FileJson {
  FileRequest file;
  FileJson(this.file);
  Map<String, dynamic> TojsonData() {
    var map = <String, dynamic>{};
    map["id"] = file.IdFile;
    map["idCourrier"] = file.IdCourrier;
    map["file"] = file.FILE;
    map["fileName"] = file.FileName;
    map["fileExtention"] = file.FileExtention;
    return map;
  }
}





  refreshToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String refreshToken = pref.getString('refresh_token').toString();
    var url = Uri.parse('$api/Authentication/refresh');
    var result = await  http.post(url, headers: {
      "Content-type":"application/json",
      "Accept":"application/json"
    }, body:jsonEncode({
      "refreshToken" : refreshToken
    }));
    if(result.statusCode == 200){
      String newToken = jsonDecode(result.body)['accessToken'];
      String newRefreshToken = jsonDecode(result.body)['refreshToken'];
      pref.setString('token', newToken);
      pref.setString('refresh_token', newRefreshToken);
    }
}


 Future<bool> expiredToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? accessToken = pref.getString('token');
  if(accessToken != null){
    var _link = Uri.parse('$api/Authentication/data');
    var respo = await http.get(_link, headers: {
      "Content-type":"application/json",
      "Accept":"application/json",
      "Authorization" : "Bearer "+accessToken.toString()
    });
    if(respo.statusCode == 200){
      return false;
    }
    else{
      return true;
    }
  }else {
    return false;
  }
}






