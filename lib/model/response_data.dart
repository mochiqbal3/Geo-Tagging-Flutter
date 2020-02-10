import 'dart:convert';

class ListResponseData {
  final bool status;
  final String message;
  final List<dynamic> data;
  
  ListResponseData({this.status = false, this.message ,this.data});

  factory ListResponseData.fromJson(Map<String, dynamic> map) {
    return ListResponseData(
      status: map["status"],
      message: map["message"],
      data: map["data"] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data,
    };
  }

  static ListResponseData toJsonFromString(String str) {
    final jsonData = json.decode(str);
    return ListResponseData.fromJson(jsonData);
  }

  String authToJson(ListResponseData data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}


class ObjectResponseData {
  final bool status;
  final String message;
  final dynamic data;
  
  ObjectResponseData({this.status = false, this.message,  this.data});

  factory ObjectResponseData.fromJson(Map<String, dynamic> map) {
    return ObjectResponseData(
      status: map["status"],
      message: map["message"],
      data: map["data"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data,
    };
  }

  static ObjectResponseData toJsonFromString(String str) {
    final jsonData = json.decode(str);
    return ObjectResponseData.fromJson(jsonData);
  }

  String authToJson(ObjectResponseData data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}