import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:wallpaper_app/core/network/url_component.dart';

import '../core/network/exeption.dart';

class NetWorkController {
  Future<Response?> restApi(
    String endPoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    var url = Uri.parse("$baseUrl/$endPoint");
    http.Response? response;
    url = url.replace(queryParameters: queryParameters);

    response = await http.get(
      url,
      headers: header,
    );

    if ((response.statusCode) >= 200 && (response.statusCode) <= 299) {
      return response;
    } else if ((response.statusCode) == 400) {
      throw CustomException("Bad Request", 400);
    } else if ((response.statusCode) == 401 || (response.statusCode) == 403) {
      throw CustomException("API key not valid", 401);
    } else if ((response.statusCode) == 404) {
      throw CustomException("Not Found", 404);
    } else if ((response.statusCode) == 500) {
      throw CustomException("Internal Server Error", 500);
    }
    return null;
  }
}
