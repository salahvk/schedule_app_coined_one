import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:schedule_app_coined_one/API/endPoint.dart';
import 'package:schedule_app_coined_one/bloc/schedule_bloc.dart';

final ScheduleBloc _scheduleBloc = ScheduleBloc();
Future<String> saveSchedule(
    {name, startTime, endTime, date, BuildContext? context}) async {
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
    return 'success';

    // _scheduleBloc.add(FetchScheduleEvent());
  } else {
    return 'failure';
  }
}
