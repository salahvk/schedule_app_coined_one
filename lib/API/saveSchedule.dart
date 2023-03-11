import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:schedule_app_coined_one/API/endPoint.dart';

void saveSchedule({name, startTime, endTime, date}) async {
  final url = Uri.parse(saveUrl);
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    'name': '$name',
    'startTime': '$startTime',
    'endTime': '$endTime',
    'date': '$date',
    'phoneNumber': '9400366137'
  });

  final response = await http.post(url, headers: headers, body: body);
  print(response.body);
  if (response.statusCode == 200) {
    print('Schedule saved successfully');
  } else {
    print('Failed to save schedule');
  }
}
