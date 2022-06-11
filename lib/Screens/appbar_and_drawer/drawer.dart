import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:sfe_courrier/Model/Network/authentication.dart';
import 'package:sfe_courrier/Model/Network/courier_methods.dart';
import 'package:sfe_courrier/Screens/courriers/add_courier.dart';
import 'package:sfe_courrier/Screens/courriers/archive_couriers.dart';
import 'package:sfe_courrier/Screens/courriers/important_courier.dart';
import 'package:sfe_courrier/Screens/list_users/list_users.dart';
import 'package:sfe_courrier/Screens/login/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:sfe_courrier/Screens/profile_screen/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/Network/api_link.dart';
import '../components/constatnts.dart';
import '../home_sccren/home_screen.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  String name = '';
  String avatar = defaultAvatar;
  int? isAdmin;
  int? totalInvitation;
  Authentication auth = Authentication();
  @override
  void initState() {
    getCreds() async{
      SharedPreferences pref = await SharedPreferences.getInstance();
      name = pref.getString('nom_user')! + ' '+ pref.getString('prenom_user')!;
      isAdmin = pref.getInt('is_admin');
      setState(() {
        avatar =  pref.getString('avatar_user') == null || pref.getString('avatar_user') == ''  ? defaultAvatar : pref.getString('avatar_user').toString();
      });
    }
    getCreds();
    getTotalInvitation();
    super.initState();
  }

  getTotalInvitation() async {
    if(await expiredToken()){
      refreshToken();
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString('token')!;
    Uri url = Uri.parse('$api/admin/allusers/'+isAdmin.toString());
    var respo = await http.post(url, headers: {
      "Content-type":"application/json",
      "Accept":"application/json",
      "Authorization" : "Bearer "+accessToken
    });
    if(respo.statusCode == 200){
      setState(() {
        totalInvitation = jsonDecode(respo.body)['totalInvitation'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
        child: Drawer(
          child: Material(
            color: testColor,
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
                      child: ProfileImage(avatar, false, (){

                      })
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(15, 20, 10, 0),
                          child: Text(name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,

                            ),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
                            child: IconButton(
                              icon: const Icon(
                                IconlyBroken.setting,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfilePage()));
                              },
                            )
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                buildMenuItem(
                    text: "Tout les courriers",
                    icon: const Icon(IconlyLight.message, color: Colors.white,),
                    onClicked: () => selectedItem(context, 0)
                ),
                buildMenuItem(
                  text: "Ajouter un courrier",
                  icon: const Icon(IconlyLight.plus, color: Colors.white,),
                  onClicked: () => selectedItem(context, 1)
                ),
                buildMenuItem(
                    text: "Importants",
                    icon: const Icon(IconlyLight.star, color: Colors.white,),
                    onClicked: () => selectedItem(context, 2)
                ),
                buildMenuItem(
                    text: "Archive",
                    icon: const Icon(IconlyLight.folder, color: Colors.white,),
                    onClicked: () => selectedItem(context, 3)
                ),
                isAdmin == 1 ? buildMenuItem(
                    text: "Listes des utilisateurs",
                    icon: SizedBox(
                      width: 30,
                      height: 30,
                      child: Stack(
                        children: [
                          const Icon(
                            IconlyLight.user,
                            color: Colors.white,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.red
                              ),
                              child: Center(
                                  child: totalInvitation == null ? const SizedBox( width: 10, height: 10,child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,)) :
                                  Text('$totalInvitation', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onClicked: () => selectedItem(context, 5)
                ) : const SizedBox(),
                buildMenuItem(
                    text: "Deconnexion",
                    icon: const Icon(IconlyLight.logout, color: Colors.white,),
                    onClicked: () async {
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      String id = pref.getString('id_user').toString();
                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginPage()), (route) => false);
                      auth.Logout(id, context);
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectedItem(BuildContext context, int i) {
    switch (i){
      case 0 :
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage()
        )
        );
        break;
      case 1 :
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddCourier()
        )
        );
        break;
      case 2 :
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ImportantCouriers(),
          )
        );
        break;
      case 3 :
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ArchivedCouriers(),
        )
        );
        break;
        case 5 :
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ListUsers(),
        )
        );
        break;
    }
  }
}
Widget buildMenuItem({
  required String text,
  required Widget icon,
  VoidCallback? onClicked
}){
  const color = Colors.white;
  return ListTile(
    leading: icon,
    title: Text(text,style: const TextStyle(color: color),),
    onTap: onClicked,
  );
}

