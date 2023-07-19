import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ipssisqy2023/controller/firestore_helper.dart';
import 'package:ipssisqy2023/globale.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  //variable
  bool isSript = false;
  TextEditingController pseudo = TextEditingController();
  String? nameImage;
  Uint8List? bytesImages;

  //fonction
  popImage(){
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context){
         return CupertinoAlertDialog(
           title: const Text("Souhaitez-vous enregistrer cette image ?"),
           content: Image.memory(bytesImages!),
           actions: [
             TextButton(onPressed: (){
               Navigator.pop(context);
             },
                 child: const Text("Annulation")
             ),
             TextButton(
                 onPressed: (){
                   //effectuer l'enregsitrement
                   //stokcer notre image
                   FirestoreHelper().stockageData("images", me.id, nameImage!, bytesImages!).then((value){
                     setState(() {
                       me.avatar = value;
                     });
                   });
                   Map<String,dynamic> map = {
                     "AVATAR": me.avatar
                   };
                   //mettre à jour les informations de l'utilisateur
                   FirestoreHelper().updateUser(me.id, map);



                   Navigator.pop(context);

                 }, child: const Text("Enregistrement")
             ),
           ],
         );
        }
    );
  }

  accesPhoto() async{
    FilePickerResult? resultat = await FilePicker.platform.pickFiles(
      type: FileType.image,
        withData: true
    );
    if(resultat != null){
      nameImage = resultat.files.first.name;
      bytesImages = resultat.files.first.bytes;
      popImage();
    }
  }

   genreChoice(){
     Gender? _genre = Gender.indefini;
    return showDialog(
      context: context,
      builder: (context){

        return Material(
          color: Colors.transparent,
          child: CupertinoAlertDialog(
            title: Text("Quel est ton genre ?"),
            content: StatefulBuilder(
              builder: (context,setState){
                return Column(
                  children: [
                    ListTile(
                      title: Text("Indéfini"),
                      trailing: const FaIcon(FontAwesomeIcons.infinity),
                      leading: Radio<Gender>(
                        value: Gender.indefini,
                        groupValue: _genre,
                        onChanged: (Gender? value){
                          setState(() {
                            _genre = value;
                          });
                        },
                      ),
                    ),

                    ListTile(
                      title: const Text("homme"),
                      trailing: const FaIcon(FontAwesomeIcons.mars),
                      leading: Radio<Gender>(
                        value: Gender.homme,
                        groupValue: _genre,
                        onChanged: (Gender? value){
                          setState(() {
                            _genre = value;
                          });
                        },
                      ),
                    ),


                    ListTile(
                      title: const Text("femme"),
                      trailing: const FaIcon(FontAwesomeIcons.venus),
                      leading: Radio<Gender>(
                        value: Gender.femme,
                        groupValue: _genre,
                        onChanged: (Gender? value){
                          setState(() {
                            _genre = value;
                          });
                        },
                      ),
                    ),


                    ListTile(
                      title: const Text("transgenre"),
                      trailing: const FaIcon(FontAwesomeIcons.transgender),
                      leading: Radio<Gender>(
                        value: Gender.transgenre,
                        groupValue: _genre,
                        onChanged: (Gender? value){
                          setState(() {
                            _genre = value;
                          });
                        },
                      ),
                    ),





                  ],
                );
              },
            ),

            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("Annulation")
              ),
              TextButton(
                  onPressed: (){
                    setState(() {
                      me.genre = _genre!;
                    });
                    Map<String,dynamic> map = {
                      "GENRE": conversionGenre(_genre!)
                    };
                    FirestoreHelper().updateUser(me.id, map);

                    Navigator.pop(context);

                  },
                  child: const Text("Enregistrement")
              )
            ],
          ),
        );
      }

    );
  }

  dateAnniversaire() async{
    DateTime? time = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,

    );
    if(time != null){
      setState(() {
        me.birthday = time;
      });
      Map<String,dynamic> data = {
        "BIRTHDAY":time
      };
      FirestoreHelper().updateUser(me.id, data);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: Column(
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: (){
                        print("J'ai appuyé");
                        accesPhoto();
                      },
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(me.avatar ?? defaultImage),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            genreChoice();
                          },
                          child: Icon(me.conversionIcon(),size: 45,)
                        ),

                        const SizedBox(width: 20,),
                        GestureDetector(
                          onTap: (){
                            dateAnniversaire();
                          },
                            child: Text("${me.age()} ans",style: TextStyle(fontSize: 25),))
                      ],
                    )
                  ],
                ),
                const Divider(
                  thickness: 3,
                  color: Colors.black,
                ),
                ListTile(
                  leading: const  Icon(Icons.mail,color: Colors.purple,),
                  title: Text(me.mail,style: const TextStyle(fontSize: 20),),
                ),

                ListTile(
                  leading: const  Icon(Icons.person,color: Colors.purple,),
                  title: Text(me.fullName,style: const TextStyle(fontSize: 20),textAlign: TextAlign.center,),

                ),
                ListTile(
                  leading: const  Icon(Icons.person,color: Colors.purple,),
                  title: (isSript)?TextField(
                    controller: pseudo,
                    decoration: InputDecoration(
                      hintText: me.pseudo ?? ""
                    ),
                  ):Text(me.pseudo ?? "",style: const TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                  trailing: IconButton(
                    icon: Icon((isSript)?FontAwesomeIcons.floppyDisk:FontAwesomeIcons.pencil,color: Colors.black,),
                    onPressed: (){
                      if(isSript){
                        if(pseudo != null && pseudo.text != "" && pseudo.text != me.pseudo){
                          Map<String,dynamic> map = {
                            "PSEUDO": pseudo.text
                          };
                          setState(() {
                            me.pseudo = pseudo.text;
                          });
                          FirestoreHelper().updateUser(me.id, map);
                        }


                      }
                      setState(() {
                        isSript = !isSript;
                      });


                    },
                  ),
                ),



              ],
            )
        )
    );
  }
}

