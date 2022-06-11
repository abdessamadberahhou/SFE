import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';
import 'package:sfe_courrier/Model/Network/courier_methods.dart';
import 'package:sfe_courrier/Screens/components/achivment.dart';
import 'package:sfe_courrier/Screens/components/fixed_page.dart';
import 'package:sfe_courrier/Screens/list_users/edit_user.dart';
import 'package:sfe_courrier/Screens/list_users/show_user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/Network/api_link.dart';
import '../../Objects/user.dart';
import '../components/constatnts.dart';
import '../components/rounded_input_field.dart';


class ListUsers extends StatefulWidget {
  const ListUsers({Key? key}) : super(key: key);

  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  final PageController _pageController = PageController();
  List FetchedUsers = [];
  List FetchedInvitaions = [];
  bool isLoading = false;
  int? totalInvits;
  CourierMethods methods = CourierMethods();
  bool? isSelected;
  bool noResualt1 = false;
  bool noResualt2 = false;
  TextEditingController _search1 = TextEditingController();
  TextEditingController _search2 = TextEditingController();

  FetchUsers() async {
    setState(() {
      isLoading = true;
    });
    if(await expiredToken()){
      refreshToken();
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('token');
    int? isAdmin = pref.getInt('is_admin');
    var _link = Uri.parse(api+"/admin/allusers/" + isAdmin.toString());
    var result = await http.post(_link, headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + accessToken.toString()
    });
    if (result.statusCode == 200) {
      setState(() {
        FetchedUsers = json.decode(result.body)['users'];
        FetchedInvitaions = json.decode(result.body)['invitations'];
        totalInvits = json.decode(result.body)['totalInvitation'];
        isLoading = false;
      });
    }
    else {
      showAchievementView(context, false, 'problem de connexion');
    }
  }




  SearchAcceptedUsers(String query) async{
    Uri uri = Uri.parse('$api/admin/search/users/accepted?query='+query);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString('token').toString();
    var response = await http.post(uri, headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + accessToken
    });
    if(query.isNotEmpty){
      if(response.statusCode == 200){
        setState(() {
          FetchedUsers = json.decode(response.body)['users'];
          noResualt1 = false;
        });
      }
      else if(response.statusCode == 400){
        setState(() {
          noResualt1 = true;
        });
      }
    }
    else{
      String? accessToken = pref.getString('token');
      int? isAdmin = pref.getInt('is_admin');
      var _link = Uri.parse(api+"/admin/allusers/" + isAdmin.toString());
      var result = await http.post(_link, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + accessToken.toString()
      });
      setState(() {
        FetchedUsers = json.decode(result.body)['users'];
        noResualt1 = false;
      });
    }
  }




  SearchInvitations(String query) async{
    Uri uri = Uri.parse('$api/admin/search/users/notaccepted?query='+query);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString('token').toString();
    var response = await http.post(uri, headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + accessToken
    });
    if(query.isNotEmpty){
      if(response.statusCode == 200){
        setState(() {
          FetchedInvitaions = json.decode(response.body)['invitations'];
          noResualt2 = false;
        });
      }
      else if(response.statusCode == 400){
        setState(() {
          noResualt2 = true;
        });
      }
    }
    else{
      String? accessToken = pref.getString('token');
      int? isAdmin = pref.getInt('is_admin');
      var _link = Uri.parse(api+"/admin/allusers/" + isAdmin.toString());
      var result = await http.post(_link, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + accessToken.toString()
      });
      setState(() {
        FetchedInvitaions = json.decode(result.body)['invitations'];
        noResualt2 = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected = true;
    FetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return FixedPage(
      canBack: true,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: testColor,
            ),
            height: 50,
            child: Row(
              children: [
                Center(
                  child: Container(
                    decoration :BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      border: isSelected ! ? Border.all(color: Colors.white, width: 1) : null,
                      color: isSelected! ? Colors.white : testColor,
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.5,
                    child: IconButton(
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Invitaions",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),),
                          const SizedBox(width: 5,),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 25.0,
                              minWidth: 25.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red
                              ),
                              child: Center(
                                child: totalInvits == null
                                    ? const SizedBox(width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2,))
                                    : Text(
                                  '$totalInvits', style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                            ),
                          )
                        ],
                      ),
                      onPressed: () {
                        setState(() {

                        });
                        _pageController.animateToPage(0, duration: const Duration(
                            microseconds: 400000), curve: Curves.linear);
                      },
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: const Radius.circular(10), topRight: const Radius.circular(10), bottomLeft: isSelected! ? const Radius.circular(10)  : Radius.zero),
                      border: !isSelected ! ? Border.all(color: Colors.white, width: 1) : null,
                      color: !isSelected! ? Colors.white : testColor,
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.5,
                    child: IconButton(
                      icon: const Text("List des utilisateurs", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      onPressed: () {
                        setState(() {

                        });
                        _pageController.animateToPage(1, duration: const Duration(
                            microseconds: 400000), curve: Curves.linear);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading ? Center(
                child: SpinKitWave(color: welcomePrimaryColor,)) : PageView(
              onPageChanged: (page) {
                setState(() {
                  isSelected = !isSelected!;
                });
              },
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 3),
                          child: Row(
                            children: [
                              SizedBox(
                                child: RoundedInputNormal(
                                  textController: _search1,
                                  borderColor: welcomePrimaryColor,
                                  hintText: "Entrer mot clé pour rechercher",
                                  suffixIcon: IconlyBroken.search,
                                  suffixIconColor: welcomePrimaryColor,
                                  onChanged: (text) {
                                      setState(() {
                                        SearchInvitations(_search1.text);
                                      });
                                  },
                                ),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.98,
                              ),
                            ],
                          )
                      ),
                      Expanded(
                        child: Container(
                          child: noResualt2 ? Center(child: Text('Aucun resultat'),) : BuildListInvitaions(),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 3),
                          child: Row(
                            children: [
                              SizedBox(
                                child: RoundedInputNormal(
                                  textController: _search2,
                                  borderColor: welcomePrimaryColor,
                                  hintText: "Entrer mot clé pour rechercher",
                                  suffixIcon: IconlyBroken.search,
                                  suffixIconColor: welcomePrimaryColor,
                                  onChanged: (text) {
                                      setState(() {
                                        SearchAcceptedUsers(_search2.text);
                                      });
                                  },
                                ),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.98,
                              ),
                            ],
                          )
                      ),
                      Expanded(
                        child: Container(
                          child: noResualt1 ? Center(child: Text('Aucun resultat'),) : BuildListUsers(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget BuildListUsers() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            indent: 4,
            height: 4,
            thickness: 3,
          ),
        );
      },
      itemCount: FetchedUsers.length,
      itemBuilder: (BuildContext context, int index) {
        User user = User();
        user.Email = FetchedUsers[index]['email'];
        user.FirstName = FetchedUsers[index]['firstName'];
        user.LastName = FetchedUsers[index]['lastName'];
        user.BirthDay = FetchedUsers[index]['birthDay'];
        user.Cin = FetchedUsers[index]['cin'];
        user.Avatar = FetchedUsers[index]['avatar'];
        user.NumTele = FetchedUsers[index]['numTele'];
        user.Id = FetchedUsers[index]['id'];
        user.isAdmin = FetchedUsers[index]['isAdmin'];
        return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
            ),
            child: Slidable(
              actionPane: const SlidableDrawerActionPane(),
              actions: [
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: editColor,
                  ),
                  child: IconSlideAction(
                    color: Colors.transparent,
                    icon: IconlyLight.edit,
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => EditUser(user: user,)));
                    },
                  ),
                ),
              ],
              secondaryActions: [
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  child: IconSlideAction(
                    color: Colors.transparent,
                    icon: IconlyLight.delete,
                    onTap: () {
                      methods.showMyDialog(context, () async {
                        Uri _link = Uri.parse('$api/admin/delete');
                        SharedPreferences pref = await SharedPreferences
                            .getInstance();
                        String accessToken = pref.getString('token')!;
                        var response = await http.post(_link, headers: {
                          "Content-type": "application/json",
                          "Accept": "application/json",
                          "Authorization": "Bearer " + accessToken
                        }, body: jsonEncode({
                          "id": user.Id,
                          "isAdmin": 1
                        }));
                        if (response.statusCode == 200) {
                          showAchievementView(context, true, response.body);
                          setState(() {
                            FetchedUsers.removeAt(index);
                          });
                          Navigator.of(context).pop();
                        }
                      }, 'cette utilisateur');
                    },
                  ),
                ),
              ],
              child: Container(
                height: 90,
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    //border: Border.all(color: welcomePrimaryColor, width: 0.25),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1.75,
                          offset: Offset(0, 0.5)
                      ),
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset(-0.5, 0)
                      ),
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset(0, 0.5)
                      ),
                    ]
                ),
                child: Center(
                  child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) =>
                                ShowUser(user: user,)));
                      },
                      leading: SizedBox(
                        child: Center(
                          child: CircleAvatar(
                            backgroundImage: user.Avatar == '' || user.Avatar == null ? MemoryImage(
                                base64Decode(defaultAvatar)) : MemoryImage(
                                base64Decode(user.Avatar!)),
                            radius: 30,
                          ),
                        ),
                        width: 45,
                      ),
                      title: Text(user.FirstName.toString() + ' ' +
                          user.LastName.toString()),
                      subtitle: Text('CIN : ' + user.Cin.toString()),
                      trailing: IconButton(
                        icon: const Icon(
                          CupertinoIcons.checkmark_alt, color: Colors.green,),
                        onPressed: () async {


                        },
                      )
                  ),
                ),
              ),
            )
        );
      },
    );
  }

  Widget BuildListInvitaions() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            indent: 4,
            height: 4,
            thickness: 3,
          ),
        );
      },
      itemCount: FetchedInvitaions.length,
      itemBuilder: (BuildContext context, int index) {
        User user = User();
        user.Email = FetchedInvitaions[index]['email'];
        user.FirstName = FetchedInvitaions[index]['firstName'];
        user.LastName = FetchedInvitaions[index]['lastName'];
        user.BirthDay = FetchedInvitaions[index]['birthDay'];
        user.Cin = FetchedInvitaions[index]['cin'];
        user.Avatar = FetchedInvitaions[index]['avatar'];
        user.NumTele = FetchedInvitaions[index]['numTele'];
        user.Id = FetchedInvitaions[index]['id'];
        user.isAdmin = FetchedInvitaions[index]['isAdmin'];
        return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
            ),
            child: InvitationTile(user, index)
        );
      },
    );
  }

  Widget InvitationTile(user, index) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          //border: Border.all(color: welcomePrimaryColor, width: 0.25),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 1.75,
                offset: Offset(0, 0.5)
            ),
            BoxShadow(
                color: Colors.white,
                offset: Offset(-0.5, 0)
            ),
            BoxShadow(
                color: Colors.white,
                offset: Offset(0, 0.5)
            ),
          ]
      ),
      child: Center(
        child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShowUser(user: user,)));
            },
            leading: const SizedBox(
              child: Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/default.png'),
                  radius: 30,
                ),
              ),
              width: 45,
            ),
            title: Row(
              children: [
                Text(
                    user.FirstName.toString() + ' ' + user.LastName.toString()),
                const SizedBox(width: 10,),
              ],
            ),
            trailing: Container(
              decoration: BoxDecoration(
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3.0,
                        offset: Offset(0.0, 0.75)
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8)
              ),
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () async {
                        Uri url = Uri.parse('$api/admin/accept/user/' + user!.Id.toString());
                        SharedPreferences pref = await SharedPreferences
                            .getInstance();
                        String accessToken = pref.getString('token')!;
                        var respo = await http.post(url, headers: {
                          "Content-type": "application/json",
                          "Accept": "application/json",
                          "Authorization": "Bearer " + accessToken
                        });
                        if (respo.statusCode == 200) {
                          showAchievementView(context, true, respo.body);
                          setState(() {
                            FetchedInvitaions.removeAt(index);
                            FetchUsers();
                          });
                        }
                        else{
                          showAchievementView(context, false, 'Errueur');
                        }
                      },
                      icon: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green
                        ),
                        child: const Icon(
                          CupertinoIcons.checkmark_alt, color: Colors.white,),
                      )
                  ),
                  IconButton(
                      onPressed: () {
                        methods.showMyDialog(context, () async {
                          Uri _link = Uri.parse('$api/admin/delete');
                          SharedPreferences pref = await SharedPreferences
                              .getInstance();
                          String accessToken = pref.getString('token')!;
                          var response = await http.post(_link, headers: {
                            "Content-type": "application/json",
                            "Accept": "application/json",
                            "Authorization": "Bearer " + accessToken
                          }, body: jsonEncode({
                            "id": user.Id,
                            "isAdmin": 1
                          }));
                          if (response.statusCode == 200) {
                            showAchievementView(context, true, response.body);
                            setState(() {
                              FetchedUsers.removeAt(index);
                            });
                            Navigator.of(context).pop();
                          }
                        }, 'cette invitation');
                      },
                      icon: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red
                        ),
                        child: const Icon(IconlyLight.delete, color: Colors.white,),
                      )
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}































