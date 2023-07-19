import 'package:ipssisqy2023/model/my_user.dart';
import 'package:permission_handler/permission_handler.dart';

enum Gender {homme,femme,transgenre,indefini}

MyUser me = MyUser.empty();
String defaultImage = "https://tse1.mm.bing.net/th?id=OIP.zRmpjD_EOxCboGENHfjxHAHaEc&pid=Api";


String conversionGenre(Gender genre){
  switch(genre){
    case Gender.indefini:return "indéfini";
    case Gender.femme:return "femme";
    case Gender.homme:return "homme";
    case Gender.transgenre:return "transgenre";

  }




}

Gender conversion(String value) {
  switch (value) {
    case "homme":
      return Gender.homme;
    case "femme":
      return Gender.femme;
    case "transgenre":
      return Gender.transgenre;
    case "indéfini":
      return Gender.indefini;
    default :
      return Gender.indefini;
  }
}
