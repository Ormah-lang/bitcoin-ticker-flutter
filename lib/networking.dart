import 'dart:convert';

import 'package:http/http.dart' as http;

const apiKey = {'x-ba-key': 'NTBjNTBkOTlkYzk4NGY2MWI4ZWI0MWIyZGNlNGIxOTg'};

class NetworkData {
  NetworkData(this.url);

  final String url;

  Future getCurrencies() async {
    http.Response response = await http.get(
      Uri.parse(url),
      headers: apiKey,
    );
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
