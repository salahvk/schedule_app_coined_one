import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schedule_app_coined_one/API/endpoint.dart';
import 'package:schedule_app_coined_one/model/scheduleModel.dart';

class ApiProvider {
  Future<ScheduleModel> getScheduleDataList() async {
    try {
      final url = Uri.parse(getUrl);
      final headers = {'Content-Type': 'application/json'};
      final response = await http.get(url, headers: headers);
      var jsonResponse = jsonDecode(response.body);
      return ScheduleModel.fromJson(jsonResponse);
    } catch (_) {
      return ScheduleModel.withError("Data Not Found");
    }
  }
}
