import 'package:flutter/material.dart';
import 'package:ipssisqy2023/controller/firestore_helper.dart';
import 'package:ipssisqy2023/globale.dart';
import 'package:ipssisqy2023/model/my_user.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({super.key});

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  List<MyUser> maListeAmis = [];

  @override
  void initState() {
    // TODO: implement initState
    for(String uid in me.favoris!){
      FirestoreHelper().getUser(uid).then((value){
        setState(() {
          maListeAmis.add(value);
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: maListeAmis.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 5,mainAxisSpacing: 5),
        itemBuilder: (context,index){
        MyUser otherUser = maListeAmis[index];
          return Container(
            padding: const EdgeInsets.all(10),
           decoration: BoxDecoration(
             color: Colors.amberAccent,
             borderRadius: BorderRadius.circular(15)
           ),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(otherUser.avatar ?? defaultImage,),
                  ),
                  Text(otherUser.fullName)
                ],
              ),
            ),
          );
      }
    );
  }
}
