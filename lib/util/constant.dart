import 'package:intl/intl.dart';
class Constant{
  static getTodayDate(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd').format(now);
    return formattedDate;
  }
  static getTimeNow(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('H:m:s').format(now);
    return formattedDate;
  }
}