import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  Future<List<MyUser>> getFriendsList(MyUser other) async {
    List<MyUser> listFriends = [];
    for (String uid in other.favoris!) {
      MyUser friend = await FirestoreHelper().getUser(uid);
      listFriends.add(friend);
    }
    return listFriends;
  }



  //fonction
  SnackBar detailProfil(MyUser other){
    List<MyUser> listFriends = [];
    for(String uid in other.favoris!){
      FirestoreHelper().getUser(uid).then((value) {
        setState(() {
          listFriends.add(value);
        });
      });
    }
    return SnackBar(
      backgroundColor: Colors.orangeAccent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))),
      duration: const Duration(seconds: 15),
        content: Container(

          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(other.avatar ?? defaultImage),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(other.conversionIcon(),size: 45,),
                  const SizedBox(width: 20,),
                  Text("${other.age()} ans",style: TextStyle(fontSize: 25),),
                ],
              ),

              const Divider(thickness: 3,color: Colors.black,),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.person),
                title: Text(other.fullName),
                subtitle: Text(other.pseudo?? ""),
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.envelope),
                title: Text(other.mail),
              ),
              const Divider(thickness: 3,color: Colors.black,),
              const Text("Friends"),
              Expanded(
                child: FutureBuilder<List<MyUser>>(
                  future: getFriendsList(other),
                    builder: (context,snap){
                    if(snap.connectionState == ConnectionState.waiting){
                      return  const CircularProgressIndicator.adaptive();
                    }
                    else if (snap.hasError){
                      return const Text('Erreur lors du chargement');
                    }
                    else
                      {
                        final List<MyUser> listFriends = snap.data!;
                        if(listFriends.isEmpty){
                          return Text("Aucun Amis");

                        }
                        else {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: listFriends.length,
                              itemBuilder: (context,index) {
                                MyUser mesAmis = listFriends[index];
                                if (listFriends.isEmpty) {

                                  return const Center(
                                    child: Text("Aucun Amis"),
                                  );
                                }
                                else {

                                  return ListTile(
                                    onTap: (){
                                      showDialog(
                                        barrierDismissible: false,
                                          context: context,
                                          builder: (context){
                                            return Card(
                                              elevation: 0,
                                              color: Colors.transparent,
                                              child: CupertinoAlertDialog(

                                                title: ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundImage: NetworkImage(other.avatar ?? defaultImage),
                                                  ),
                                                  title: Text(other.fullName,style: TextStyle(color: Colors.white),),
                                                  trailing: FaIcon(other.conversionIcon(),color: Colors.white,),
                                                ),
                                                content: Column(
                                                  children: [
                                                    ListTile(
                                                      leading: FaIcon(FontAwesomeIcons.envelope,color: Colors.white,),
                                                      title: Text(other.mail,style: TextStyle(color: Colors.white),),

                                                    )
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  }, child: const Text("OK")
                                                  )
                                                ],
                                              ),

                                            );
                                          }
                                      );
                                    },

                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          mesAmis.avatar ?? defaultImage),

                                    ),
                                    title: Text(mesAmis.fullName),
                                    subtitle: Text(mesAmis.mail),
                                  );
                                }
                              }
                          );
                        }
                      }


                    }
                ),
              )



            ],
          ),

        )
    );
  }

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
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 5,mainAxisSpacing: 5),
        itemBuilder: (context,index){
        MyUser otherUser = maListeAmis[index];
          return InkWell(
            onTap: (){
              ScaffoldMessenger.of(context).showSnackBar(detailProfil(otherUser));
            },
            child: Container(
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
            ),
          );
      }
    );
  }
}
