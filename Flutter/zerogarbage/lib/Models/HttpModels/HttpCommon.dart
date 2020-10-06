import 'package:http/http.dart' as http;

class HttpCommon {
  String baseUrl = "http://zerogarbage.tk/api";

  Map<String, String> headers;
  Map data;

  bool methodget = false;

  HttpCommon({this.headers, this.data, this.methodget});

  Future<http.Response> process(
    String route,
  ) async {
    if (methodget == false) {
      print(baseUrl + "/" + route);
      var response = await http.post(baseUrl + "/" + route,
          body: this.data, headers: this.headers);
      print(response.statusCode);
      print(response.body);
      return response;
    } else {
      print(baseUrl + "/" + route);
      var response = await http.get(baseUrl + "/" + route);
      print(response.statusCode);
      print(response.body);
      return response;
    }
  }
}
