import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/data/remote/web_constants.dart';

import 'web_exceptions.dart';

class Webservice {
  static final Webservice _instance = Webservice._internal();

  factory Webservice() => _instance;

  Webservice._internal();

  Map<String, String> postHeaders = {
    'Content-Type': 'application/json; charset=UTF-8'
  };

  Map<String, String> getHeaders = {"Accept": "application/json"};



  Future<dynamic> getFromService(String action) async {
    Map mapResponseJson;

    debugPrint("Post Webservice Action $action");

    try {
      final response = await http.get(Uri.parse(action),
          headers: getHeaders);
      mapResponseJson = processResponseToJson(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return mapResponseJson;
  }

  Map processResponseToJson(http.Response response) {
    var returnedResponseBody = response.body;

    switch (response.statusCode) {
      case 200:
        // 200 - Success
        debugPrint("Webservice Decodable Response $returnedResponseBody");
        var responseJson = json.decode(returnedResponseBody);

        debugPrint("Json Type ${responseJson.runtimeType}");

        return responseJson;
      case 400:
        Map responseJson = json.decode(returnedResponseBody);
        debugPrint("Webservice Request 400 $responseJson");
        return responseJson;
      case 403:
        Map responseJson = json.decode(WebConstants.statusCode404Message);
        debugPrint("Webservice Request 403 $responseJson");
        return responseJson;
      case 404:
        Map responseJson = json.decode(WebConstants.statusCode404Message);
        debugPrint("Webservice Request 404 $responseJson");
        return responseJson;
      case 500:
        Map responseJson = json.decode(WebConstants.statusCode502Message);
        debugPrint("Webservice Request 500 $responseJson");
        return responseJson;
      case 502:
        Map responseJson = json.decode(WebConstants.statusCode502Message);
        debugPrint("Webservice Request 502 $responseJson", wrapWidth: 1024);
        return responseJson;
      case 503:
        Map responseJson = json.decode(WebConstants.statusCode503Message);
        debugPrint("Webservice Request 503 $responseJson", wrapWidth: 1024);
        return responseJson;
      default:
        Map responseJson = json.decode(WebConstants.statusCode503Message);
        debugPrint("Webservice Request default $responseJson");
        return responseJson;
    }
  }
}











// Future<dynamic> postWithAuthAndRequest(String action, dynamic params) async {
//   Map mapResponseJson;
//
//   var requestJson = jsonEncode(params);
//
//   debugPrint("Post Webservice Action $action");
//   debugPrint("Post Webservice Request $requestJson");
//
//   try {
//     final response = await http.post(Uri.parse(action),
//         headers: postHeaders, body: requestJson);
//     mapResponseJson = processResponseToJson(response);
//   } on SocketException {
//     throw FetchDataException('No Internet connection');
//   }
//   return mapResponseJson;
// }
