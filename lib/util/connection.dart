import 'dart:convert';
import 'dart:io';

import 'package:geotagging/model/response_data.dart';
import 'package:http/http.dart' show Client;

class ApiService {
  final String baseUrl = "https://5e3cdabca49e540014dc055a.mockapi.io";
  Client client = Client();

  // Future<Auth> auth(LoginModel login) async {
  //   print(login.loginToJson(login));
  //   print("$baseUrl/oauth/token");
  //   final response = await client.post("$baseUrl/oauth/token",
  //       headers: {
  //         HttpHeaders.contentTypeHeader: "application/json",
  //         HttpHeaders.acceptHeader: "application/json"
  //       },
  //       body: login.loginToJson(login));
  //   if (response.statusCode == 200) {
  //     return Auth().authFromJson(response.body);
  //   } else {
  //     return null;
  //   }
  // }

  Future<ObjectResponseData> getWithSingleResponse(
  data, String path, String token) async {
    print("$baseUrl/$path");
    final response = await client.get(
      "$baseUrl/$path",
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
    );
    return ObjectResponseData.toJsonFromString(response.body);
  }

  Future<ListResponseData> getWithListResponse(
  data, String path, String token) async {
    print("$baseUrl/$path");
    final response = await client.get(
      "$baseUrl/$path",
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
    );
    return ListResponseData.toJsonFromString(response.body);
  }
}
