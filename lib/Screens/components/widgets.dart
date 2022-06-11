import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconly/iconly.dart';
import 'package:http/http.dart' as http;
import 'package:sfe_courrier/Screens/components/achivment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/Network/api_link.dart';
import '../../Model/Network/courier_methods.dart';
import '../../Objects/courrier.dart';
import '../../Objects/files.dart';
import '../courriers/edit_courier.dart';
import '../courriers/show_courier.dart';
import 'constatnts.dart';



//Build Card Widget
Widget buildCards(BuildContext context, Courier c) {
  String subtitle = "";
  if(c.typeCourier == 'Courier Arrive'){
    subtitle = c.dest;
  } else{
    subtitle = c.exporter;
  }
  return Container(
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
              offset: Offset(0,0.5)
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
          leading: SizedBox(
            child:Center(
              child: c.typeCourier == 'Courrier Arrivé' ? Icon(IconlyBold.arrow_down_square, color: editColor,size: 35,) : Icon(IconlyBold.arrow_up_square, color: removeColor,size: 35,),
            ),
            width: 45,
          ),
          title: Text(c.objet),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(child: c.typeCourier == 'Courrier Arrivé'? const Text("de:") : const Text("à:"),width: 35,),
              SizedBox(child: Text(subtitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),width: 90,),
              SizedBox(width: MediaQuery.of(context).size.width*0.05,),
              Text(c.date)
            ],
          ),
          trailing: IconButton(
            icon: c.isFavorised == 1 ? const Icon(IconlyBold.star, color: Colors.yellow,) : const Icon(IconlyLight.star),
            onPressed: () async {
              var favoriseLink = Uri.parse('$api/courrier/favorise/'+c.id.toString());
              SharedPreferences pref = await SharedPreferences.getInstance();
              String accessToken = pref.getString('token')!;
              if(c.isFavorised == 1){
                var respo = await http.post(favoriseLink,headers: {
                  "Content-type":"application/json",
                  "Accept":"application/json",
                  "Authorization" : accessToken
                }, body: json.encode(''));
                if(respo.statusCode == 200){
                  c.isFavorised == 0;
                }

              } else{
                var respo = await http.post(favoriseLink);
                if(respo.statusCode == 200){
                  c.isFavorised == 1;
                }
              }
            },
          )
      ),
    ),
  );
}




class BuildList extends StatefulWidget {
  final Courier? c;
  final void function;
  const BuildList({Key? key, this.c, this.function}) : super(key: key);

  @override
  State<BuildList> createState() => _BuildListState();
}

class _BuildListState extends State<BuildList> {
  String subtitle = "";
  checkSub(){
    if(widget.c!.typeCourier == 'Courier Arrive'){
      subtitle = widget.c!.dest;
    } else{
      subtitle = widget.c!.exporter;
    }
  }
  bool? favorise ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSub();
    if(widget.c!.isFavorised == 1){
      setState(() {
        favorise = true;
      });
    }
    else{
      setState(() {
        favorise = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
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
                offset: Offset(0,0.5)
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
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowCourier(widget.c),
              ),
            );
          },
            leading: SizedBox(
              child:Center(
                child: widget.c!.typeCourier == 'Courrier Arrivé' ? Icon(IconlyBold.arrow_down_square, color: editColor,size: 35,) : Icon(IconlyBold.arrow_up_square, color: removeColor,size: 35,),
              ),
              width: 45,
            ),
            title: Row(
              children: [
                Text(widget.c!.objet),
                const SizedBox(width: 10,),
                widget.c!.isUrgent == 1 ? const Icon(IconlyLight.danger, color: Colors.red, size: 18,) : const Text('')
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(child: widget.c!.typeCourier == 'Courrier Arrivé'? const Text("de:") : const Text("à:"),width: 35,),
                SizedBox(child: Text(subtitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),width: 90,),
                SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                Text(widget.c!.date)
              ],
            ),
            trailing: IconButton(
              icon: favorise! ? const Icon(IconlyBold.star, color: Colors.yellow,) : const Icon(IconlyLight.star),
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                String accessToken = pref.getString('token')!;
                var favoriseLink = Uri.parse('$api/courrier/favorise/'+widget.c!.id.toString());
                var respo = await http.post(favoriseLink,headers: {
                  "Content-type":"application/json",
                  "Accept":"application/json",
                  "Authorization" : "Bearer "+accessToken
                }, body: json.encode(''));
                
                if(respo.statusCode == 200){
                  setState(() {
                    favorise = !favorise!;
                  });
                }
              },
            )
        ),
      ),
    );
  }
}


class ArchiveButton extends StatefulWidget {
  const ArchiveButton({Key? key}) : super(key: key);

  @override
  State<ArchiveButton> createState() => _ArchiveButtonState();
}
class _ArchiveButtonState extends State<ArchiveButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(left: 3,right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[400],
      ),
      child: IconButton(
        onPressed: () {  },
        icon: const Icon(IconlyLight.hide, color: Colors.white,),

      ),
    );
  }
}




//Edit Button
class EditButton extends StatelessWidget {
  Courier? c;
  EditButton(Courier c){
    this.c = c;
  }

  @override
  Widget build(BuildContext context) {
    return IconSlideAction(
      iconWidget: Container(
        margin: const EdgeInsets.only(left:5),
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: editColor,
        ),
        child:  const Icon(IconlyLight.edit, color: Colors.white,),
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EditCourier(c),
        ));
      },
    );
  }
}








class ShowImageBuilder extends StatefulWidget {
  const ShowImageBuilder({Key? key, this.paths, this.bckColor, this.onPress, this.isvisible, this.type, this.newPaths}) : super(key: key);

  @override
  State<ShowImageBuilder> createState() => _ShowImageBuilderState();
  final List<FileRequest>? paths;
  final List<FileRequest>? newPaths;
  final bool? isvisible;
  final Color? bckColor;
  final String? type;
  final void Function()? onPress;

}

class _ShowImageBuilderState extends State<ShowImageBuilder> {
  CourierMethods methods = CourierMethods();
  @override
  void initState(){
    super.initState();
    checkType();
  }
  String text = '';
  checkType(){
    if(widget.type == 'ajoute'){
      setState(() {
        text = 'Ajouter un courrier';
      });
    }
    else if(widget.type == 'modifier'){
      setState(() {
        text = 'Modifier un courrier';
      });
    }
    else{
      setState(() {
        text = 'Visualiser un courrier';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.paths!.isEmpty ? MediaQuery.of(context).size.height*0.2 : 480,
      child: widget.paths!.isEmpty ?  Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
        ),) : Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: widget.bckColor,
            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15))
        ),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.paths!.length,
            itemBuilder: (context, index){
              return Column(
                children: [
                  ShowImageViewer(path: widget.paths![index]),
                  Visibility(
                    visible: widget.isvisible!,
                      child: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () async{
                          var _link = Uri.parse('$api/courrier/delete/file/'+widget.paths![index].IdFile.toString());
                          if(widget.paths![index].IdFile == '00000000-0000-0000-0000-000000000000'){
                            setState(() {
                              widget.paths!.removeAt(index);
                            });
                          }
                          else{
                            methods.showMyDialog(context, () async {
                              var response = await http.post(_link, headers: {
                                "Content-type":"application/json",
                                "Accept":"application/json"
                              });
                              Navigator.of(context).pop();
                              if(response.statusCode == 200){
                                showAchievementView(context, true, response.body);
                              }
                              else{
                                showAchievementView(context, false, response.body);
                              }
                              setState(() {
                                widget.paths!.removeAt(index);
                              });
                            },'cette image');
                          }
                        },
                      )
                  )
                ],
              );
            }
        ),
      ),
    );
  }
}


class ShowImageViewer extends StatelessWidget {
  FileRequest? path;
  ShowImageViewer({Key? key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.memory(base64Decode(path!.FILE)),
          ),
        ),
      ),
    );
  }
}












class ImageBuilder extends StatefulWidget {
  const ImageBuilder({
    Key? key,
    required this.paths,
    this.bckColor,
    this.onPress,
  }) : super(key: key);

  final List<File> paths;
  final Color? bckColor;
  final void Function()? onPress;

  @override
  State<ImageBuilder> createState() => _ImageBuilderState();
}

class _ImageBuilderState extends State<ImageBuilder> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.paths.isEmpty ? MediaQuery.of(context).size.height*0.2 : 480,
      child: widget.paths.isEmpty ? const  Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            "Ajouter un courrier",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
        ),) : Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: widget.bckColor,
            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15))
        ),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.paths.length,
            itemBuilder: (context, index){
              return Column(
                children: [
                  ImageViewer(path: widget.paths[index]),
                  IconButton(
                      onPressed: (){
                        setState(() {
                          widget.paths.removeAt(index);
                        });
                      },
                      icon: const Icon(Icons.clear, size: 35, color: Colors.white,)),
                ],
              );
            }
        ),
      ),
    );
  }
}




class ImageViewer extends StatelessWidget {
  File? path;
  ImageViewer({
    this.path,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.file(path!),
          ),
        ),
      ),
    );
  }
}

