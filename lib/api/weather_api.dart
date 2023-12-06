import 'dart:io';

import 'package:dio/dio.dart';

class DioRequestClass {
  static String baseURl = "https://api.open-meteo.com/v1/forecast";
  static Future getWeatherDetails(
      {required double latitude, required double longitude}) async {
    try {
      final response = await Dio().get(
          "$baseURl?latitude=$latitude&longitude=$longitude&daily=temperature_2m_min&daily=temperature_2m_max");
      if (response.statusCode == 200) {
        return {"status": 200, "body": response.data};
      } else {
        return {"status": response.statusCode, "body": response.statusMessage};
      }
    } on SocketException {
      return {"message": "Internet Issue! No Internet connection 😑"};
    } catch (e) {
      if (e is DioException) {
        return {"status": "400", "message": e.message};
      }
    }
  }

  static Future getLatitudeLongitude({required String name}) async {
    try {
      final response = await Dio().get(
          "https://geocoding-api.open-meteo.com/v1/search?name=$name&count=10&language=en&format=json");
      if (response.statusCode == 200) {
        return {"status": 200, "body": response.data};
      } else {
        return {"status": response.statusCode, "body": response.statusMessage};
      }
    } on SocketException {
      return {"message": "Internet Issue! No Internet connection 😑"};
    } catch (e) {
      if (e is DioException) {
        return {"status": "400", "message": e.message};
      }
    }
  }

  static Future getRequest(url) async {
    try {
      var response = await Dio().get(url,
          options: Options(headers: {
            "X-CSCAPI-KEY":
                "VE4wV3VsU2hQSkJTRHNMZUlDTUM1NFg0RnZCbmRqUDFCcWE5bHpsdg=="
          }));
      return response.data;
    } on SocketException {
      return {"message": "Internet Issue! No Internet connection 😑"};
    } catch (e) {
      if (e is DioException) {
        return {"status": "400", "message": e.message};
      }
    }
  }
}
