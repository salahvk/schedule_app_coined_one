class ScheduleModel {
  bool? success;
  List<Data>? data;
  String? msg;
  String? error;

  ScheduleModel({
    this.success,
    this.data,
    this.msg,
  });

  ScheduleModel.withError(String errorMessage) {
    error = errorMessage;
  }

  ScheduleModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = msg;

    return data;
  }
}

class Data {
  String? sId;
  String? name;
  String? startTime;
  String? endTime;
  String? date;

  Data({this.sId, this.name, this.startTime, this.endTime, this.date});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['date'] = date;
    return data;
  }
}
