import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static void storePref(String key,String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Setting to " + key + " : " + token);
    await prefs.setString(key, token);
  }

  static void storeBool(String key,bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static getStringPref(String key) async{
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString(key);
    });
  }

  static getBoolPref(String key) async{
    return await SharedPreferences.getInstance().then((prefs) {
      if(prefs.getBool(key) == null){
        return false;
      }
      return prefs.getBool(key);
    });
  }
}