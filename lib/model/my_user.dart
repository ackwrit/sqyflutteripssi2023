

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ipssisqy2023/globale.dart';

class MyUser {
  late String id;
  late String mail;
  late String nom;
  late String prenom;
  String? pseudo;
  DateTime? birthday;
  String? avatar;
  Gender genre = Gender.indefini;
  List? favoris;




  int age(){
    DateTime now = DateTime.now();
    int age = now.year - birthday!.year;
    int month1 = now.month;
    int month2 = birthday!.month;
    if(month2>month1){
      age --;
    }
    else if (month1 == month2) {
      int day1 = now.day;
      int day2 = birthday!.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;


  }



  String get fullName {
    return prenom + " "+ nom;
  }


  //
  MyUser.empty(){
    id = "";
    mail = "";
    nom = "";
    prenom = "";
  }

  MyUser(DocumentSnapshot snapshot){
    id = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    mail = map["EMAIL"];
    nom = map["NOM"];
    prenom = map["PRENOM"];
    String? provisoirePseudo =  map["PSEUDO"];
    favoris = map["FAVORIS"] ?? [];
    if(provisoirePseudo == null){
      pseudo = "";
    }
    else
      {
        pseudo = provisoirePseudo;
      }

    Timestamp? birthdaytprovisoire = map["BIRTHDAY"];
    if(birthdaytprovisoire == null){
      birthday = DateTime.now();
    }
    else
      {
        birthday = birthdaytprovisoire.toDate();
      }

    avatar = map["AVATAR"] ?? defaultImage;
    String? porviosireGenre = map["GENRE"];
    if(porviosireGenre == null){
      genre = Gender.indefini;
    }
    else
      {
        genre = conversion(porviosireGenre);
      }

  }






  IconData conversionIcon() {
    switch (this.genre){
      case Gender.indefini:return FontAwesomeIcons.infinity;
    case Gender.femme:return FontAwesomeIcons.venus;
    case Gender.homme:return FontAwesomeIcons.mars;
    case Gender.transgenre:return FontAwesomeIcons.transgender;
  }
}


}