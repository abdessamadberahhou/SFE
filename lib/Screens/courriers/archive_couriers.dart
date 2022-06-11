
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconly/iconly.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sfe_courrier/Screens/components/constatnts.dart';
import 'package:sfe_courrier/Screens/components/fixed_page.dart';
import 'package:sfe_courrier/Screens/components/rounded_input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:sfe_courrier/Model/Network/api_link.dart';
import 'package:http/http.dart' as http;


import '../../Model/Network/api_link.dart';
import '../../Model/Network/courier_methods.dart';
import '../../Objects/courrier.dart';
import '../components/achivment.dart';
import '../components/widgets.dart';

class ArchivedCouriers extends StatefulWidget {
  const ArchivedCouriers({Key? key}) : super(key: key);

  @override
  State<ArchivedCouriers> createState() => _ArchivedCouriersState();
}


class _ArchivedCouriersState extends State<ArchivedCouriers> {
  String token = "";
  List couriers =[];
  String? idUser;
  int counter = 1;
  late int totalPage ;
  String query = '';
  bool noResult = false;
  RefreshController refreshController = RefreshController();
  TextEditingController searchController = TextEditingController();
  CourierMethods methods = CourierMethods();



  Future<bool> FetchArchivedCouriers({bool isRefresh = false}) async {
      if(await expiredToken()){
        refreshToken();
      }
      SharedPreferences pref = await SharedPreferences.getInstance();
      String idUser = pref.getString('id_user').toString();
      String accessToken = pref.getString('token')!;
      if(isRefresh){
        counter = 1;
      }
      else{
        if(counter > 5){
          refreshController.loadFailed();
          return false;
        }
      }
      var link = Uri.parse("$api/courrier/allarchived/$idUser/page"+counter.toString());
      final response = await http.get(link, headers: {
        "Content-type":"application/json",
        "Accept":"application/json",
        "Authorization" : "Bearer "+accessToken
      });
      if(response.statusCode == 200){
        if(isRefresh){
          couriers = json.decode(response.body)['courier'];
        }
        else{
          couriers.addAll(json.decode(response.body)['courier']);
        }
        counter++;
        totalPage = json.decode(response.body)['page'];
        setState(() {});
        return true;
      }else{
        return false;
      }
  }
  SearchArchivedCourrier(String query) async{
      SharedPreferences pref = await SharedPreferences.getInstance();
      String idUser = pref.getString('id_user').toString();
      String accessToken = pref.getString('token')!;
      if(query != ''){
        var link = Uri.parse("$api/courrier/search/archivedcouriers?id=$idUser&query=$query");
        final response = await http.post(link, headers: {
          "Content-type":"application/json",
          "Accept":"application/json",
          "Authorization" : "Bearer "+accessToken
        });
        if(response.statusCode == 200){
          setState(() {
            couriers = json.decode(response.body)['courier'];
            noResult = false;
          });
        }
        else if(response.statusCode == 404){
          setState(() {
            noResult = true;
          });
        }
      }
      else{
        setState(() {
          noResult = false;
          FetchArchivedCouriers(isRefresh: true);
        });
      }
    //
    // if(response.statusCode ==200){
    //   setState(() {
    //     noResult = false;
    //     couriers = json.decode(response.body)['courier'];
    //   });
    // }else if(response.statusCode == 404){
    //   setState(() {
    //     noResult = true;
    //   });
    // }
  }


  // void SearchArchivedCourrier() async{
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String idUser = pref.getString('id_user').toString();
  //   String accessToken = pref.getString('token')!;
  //   var link = Uri.parse("$api/courrier/search/archivedcouriers?id=$idUser&query=$query");
  //   final response = await http.post(link, headers: {
  //     "Content-type":"application/json",
  //     "Accept":"application/json",
  //     "Authorization" : "Bearer "+accessToken
  //   });
  //   print(response.statusCode);
  //   if(response.statusCode ==200){
  //     setState(() {
  //       noResult = false;
  //       couriers = json.decode(response.body)['courier'];
  //     });
  //   }else if(response.statusCode == 404){
  //     setState(() {
  //       noResult = true;
  //     });
  //   }
  // }

  @override
  void initState(){
    super.initState();
    getCreds();
    FetchArchivedCouriers();
  }




  removeCourreir(index){
    setState(() {
      couriers.removeAt(index);
    });
  }




  void getCreds() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("token")!;
      idUser = pref.getString('id_user')!;
    });
  }




  int index = 0;
  @override
  Widget build(BuildContext context) {
    return FixedPage(
      title: 'Archivés',
      canBack: true,
        body: SafeArea(
            child: Column(
              children: [
                Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
                    child: Row(
                      children: [
                        SizedBox(
                          child: RoundedInputNormal(
                            textController: searchController,
                            borderColor: welcomePrimaryColor,
                            hintText: "Entrer mot clé pour rechercher",
                            suffixIcon: IconlyBroken.search,
                            suffixIconColor: welcomePrimaryColor,
                            onChanged: (text){
                                setState(() {
                                  SearchArchivedCourrier(text);
                                });
                            },
                          ),
                          width: MediaQuery.of(context).size.width*0.98,
                        ),
                      ],
                    )
                ),
                Expanded(
                    child: Container(
                      child: noResult ? const Center(child: Text('Aucun resultat'),) :buildListView(),
                    )
                )
              ],
            )
        )
    );
  }



  Widget buildListView(){
    return SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        onRefresh: ()async {
          final result = await FetchArchivedCouriers(isRefresh: true);
          if(result){
            refreshController.refreshCompleted();
          }
          else{
            refreshController.refreshFailed();
          }
        },
        onLoading: ()async {
          final result = await FetchArchivedCouriers();
          if(result){
            refreshController.loadComplete();
          }
          else{
            refreshController.loadFailed();
          }
        },
      child: couriers.length == 0 ? Center(child: Text('aucun courrier archivés'),) : ListView.separated(
        separatorBuilder: (context,index){
          return const SizedBox(
            height: 12,
          );
        },
        itemCount: couriers.length,
        itemBuilder: (BuildContext context, int index) {
          String date = couriers[index]['dateCourrier'].toString();
          int sp = date.indexOf('T');
          String finalDate = date.substring(0,sp).trim();
          Courier c = Courier(
              couriers[index]['id'].toString(),
              couriers[index]['typeCourrier'].toString(),
              couriers[index]['objetCourrier'].toString(),
              couriers[index]['expiditeurCourrier'].toString(),
              couriers[index]['destinataireCourrier'].toString(),
              finalDate,
              couriers[index]['tagsCourrier'].toString(),
              couriers[index]['courrierFavoriser'],
              couriers[index]['courrierArchiver'],
              couriers[index]['courrierUrgent'],
              idUser,
          );
          return Slidable(
            actionPane: const SlidableDrawerActionPane(),
            actionExtentRatio: 0.21,
            actions: [
              EditButton(c)
            ],
            secondaryActions: [
              Container(
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: removeColor,
                ),
                child: IconSlideAction(
                  color: Colors.transparent,
                  icon: IconlyLight.delete,
                  onTap: (){
                    methods.showMyDialog(context, ()async {
                      if(await expiredToken()){
                        refreshToken();
                      }
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      String accessToken = pref.getString('token')!;
                      var _link = Uri.parse('$api/courrier/delete/'+c.id.toString());
                      var respo = await http.post(_link, headers: {
                        "Content-type":"application/json",
                        "Accept":"application/json",
                        "Authorization" : "Bearer "+accessToken
                      });
                      setState(() {
                        couriers.removeAt(index);
                      });
                      if(respo.statusCode == 200){
                        showAchievementView(context, true, jsonDecode(respo.body));
                      }
                      else{
                        showAchievementView(context, false, jsonDecode(respo.body));
                      }
                      Navigator.of(context).pop();
                    }, 'ce courrier');
                  },
                ),
              ),
              Container(
                  height: 90,
                  margin: const EdgeInsets.only(left: 3,right: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[400],
                  ),
                  child: IconSlideAction(
                    color: Colors.transparent,
                    icon: IconlyLight.show,
                    onTap: () async{
                      if(await expiredToken()){
                        refreshToken();
                      }
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      String accessToken = pref.getString('token')!;
                      var _link = Uri.parse('$api/courrier/archive/'+c.id.toString());
                      var respo = await http.post(_link, headers: {
                        "Content-type":"application/json",
                        "Accept":"application/json",
                        "Authorization" : "Bearer "+accessToken
                      });
                      if(respo.statusCode == 200){
                        showAchievementView(context, true, jsonDecode(respo.body));
                        setState(() {
                          couriers.removeAt(index);
                        });
                      }
                      else{
                        showAchievementView(context, false, jsonDecode(respo.body));
                      }
                    },
                  )
              )
            ],
            child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                ),
                child: BuildList(c: c)
            ),
          );
        },
      ),
    );
  }
}







