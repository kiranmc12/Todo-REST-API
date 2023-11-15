import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ApiCalls {
  Future<void> postdata(String title, String description) async {
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      print('Creation Success');
      Fluttertoast.showToast(msg: "Creation sucess");
    } else {
      print("creation failed");
      Fluttertoast.showToast(msg: "Creation failed");

      print(response);
    }
  }
}
