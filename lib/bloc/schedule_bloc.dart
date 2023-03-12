import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:schedule_app_coined_one/API/getSchedule.dart';
import 'package:schedule_app_coined_one/model/scheduleModel.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial()) {
    on<FetchScheduleEvent>((event, emit) async {
      try {
        emit(ScheduleInitial());
        print("Data Fetching");
        emit(ScheduleLoading());
        final data = await ApiProvider().getScheduleDataList();

        emit(ScheduleLoaded(schedules: data));
      } catch (_) {}
    });
  }
}
