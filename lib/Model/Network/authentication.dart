import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sfe_courrier/Model/login_result_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Objects/user.dart';
import '../../Screens/components/achivment.dart';
import '../add_result_model.dart';
import '../login_model.dart';
import 'api_link.dart';
class Authentication{
  // login(String username, String Password) async {
  //   var url = Uri.parse('$api/Authentication/login');
  //   var response = await http.post(url,headers: {
  //     "Content-type":"application/json",
  //     "Accept":"application/json"
  //   }, body: jsonEncode({"Username":"$username", "Password": "$Password"})) ;
  //   Map<String, dynamic> stringToMap(String s) {
  //     Map<String, dynamic> map = json.decode(s);
  //     return map;
  //   }
  //   print(response.statusCode);
  //   if(response.statusCode != 200){
  //
  //   }
  //   else{
  //     print(stringToMap(response.body)['accessToken']);
  //   }
  // }

  Future<LoginResultModel> login(LoginModel login) async{
    var url = Uri.parse('$api/Authentication/login');
    var response = await http.post(url,headers: {
      "Content-type":"application/json",
      "Accept":"application/json"
    }, body: jsonEncode({"Username": login.username, "Password": login.password})) ;


    if(response.statusCode == 401) {
      return LoginResultModel(401, 'mot de passe inccorect');
    } else if(response.statusCode == 200) {
      Map<String, dynamic> stringToMap(String s) {
        Map<String, dynamic> map = json.decode(s);
        return map;
      }
      String res = response.body;
      String token = stringToMap(res)['accessToken'].toString();
      String refreshtoken = stringToMap(res)['refreshToken'].toString();
      String idUser = stringToMap(res)['id'].toString();
      String nom = stringToMap(res)['nom'].toString();
      String prenom = stringToMap(res)['prenom'].toString();
      String cin = stringToMap(res)['cin'].toString();
      String email = stringToMap(res)['email'].toString();
      String dateNais = stringToMap(res)['date'].toString();
      String numTele = stringToMap(res)['phone'].toString();
      String avatar = stringToMap(res)['avatar'].toString();
      int isAdmin = stringToMap(res)['isAdmin'];
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("token", token);
      await pref.setString("refresh_token", refreshtoken);
      await pref.setString("id_user", idUser);
      await pref.setString("nom_user", nom);
      await pref.setString("prenom_user", prenom);
      await pref.setString("cin_user", cin);
      await pref.setString("email_user", email);
      await pref.setString("date_nais_user", dateNais);
      await pref.setString("num_tele_user", numTele);
      await pref.setString("avatar_user", avatar);
      await pref.setInt("is_admin", isAdmin);
      await pref.setInt('initScreen', 1);
      return LoginResultModel(200,response.body);
    } else {
      return LoginResultModel(response.statusCode.toInt(),response.body);
    }
  }
  Future<AddResultModel> RegisterUser(User user) async{
    var url = Uri.parse('$api/Authentication/register');
    var response = await http.post(url,headers: {
      "Content-type":"application/json",
      "Accept":"application/json"
    }, body: jsonEncode({
      "email": user.Email,
      "firstName": user.FirstName,
      "lastName": user.LastName,
      "birthDay": user.BirthDay,
      "cin": user.Cin,
      "password": user.Password,
      "confirmPassword": user.Password,
      "numTele": user.NumTele
    })) ;
    return AddResultModel(200, 'message');
  }
  Future<void> Logout(String userId, context) async{
    Uri link = Uri.parse('$api/Authentication/logout');
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString('token')!;
    var response = await http.delete(link, headers: {
      "Content-type":"application/json",
      "Accept":"application/json",
      "Authorization" : "Bearer "+accessToken
    }, body: jsonEncode({
      "userId": userId
    }));
    await pref.clear();
    await pref.setInt('initScreen', 1);
    if(response.statusCode == 200){
      showAchievementView(context, true, 'Loged out !!!');
    } else{
      if(response.statusCode == 200){
        showAchievementView(context, false, response.statusCode);
      }
    }
  }

}