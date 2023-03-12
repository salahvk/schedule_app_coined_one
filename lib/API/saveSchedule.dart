import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:schedule_app_coined_one/API/endPoint.dart';

Future<String> saveSchedule({
  name,
  startTime,
  endTime,
  date,
}) async {
  final url = Uri.parse(saveUrl);
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    'name': '$name',
    'startTime': '$startTime',
    'endTime': '$endTime',
    'date': '$date',
    'phoneNumber': '9400366139'
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    return 'success';
  } else {
    return 'failure';
  }
}
