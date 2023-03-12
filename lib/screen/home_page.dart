import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app_coined_one/bloc/schedule_bloc.dart';
import 'package:schedule_app_coined_one/components/color_manager.dart';
import 'package:schedule_app_coined_one/components/style_manager.dart';
import 'package:schedule_app_coined_one/model/scheduleModel.dart';
import 'package:schedule_app_coined_one/schedule_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScheduleBloc _scheduleBloc = ScheduleBloc();
  late DateTime _selectedDate;
  String? initMonth;
  List<Data> scheduleList = [];

  @override
  void initState() {
    super.initState();
    _scheduleBloc.add(FetchScheduleEvent());
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
    initMonth = DateFormat('yMMMM').format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddScheduleBottomSheet(context),
        child: const Icon(Icons.add),
      ),
      backgroundColor: ColorManager.primary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "$initMonth",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: ColorManager.textColor),
              ),
            ),
            CalendarTimeline(
              initialDate: _selectedDate,
              firstDate: DateTime.now().subtract(const Duration(days: 365 * 4)),
              lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
              onDateSelected: (date) {
                setState(() => {
                      initMonth = DateFormat('yMMMM').format(date),
                      _selectedDate = date
                    });
              },
              leftMargin: 20,
              shrink: false,
              monthColor: ColorManager.textColor,
              dayColor: ColorManager.textColor,
              dayNameColor: const Color(0xFF333A47),
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.blue,
              dotsColor: const Color(0xFF333A47),
              selectableDayPredicate: (date) => date.day != 23,
              locale: 'en',
            ),
            const SizedBox(
              height: 10,
            ),
            // BlocBuilder,
            BlocProvider(
              create: (_) => _scheduleBloc,
              child: BlocListener<ScheduleBloc, ScheduleState>(
                listener: (context, state) {},
                child: BlocBuilder<ScheduleBloc, ScheduleState>(
                  builder: (context, state) {
                    if (state is ScheduleInitial) {
                      return _buildLoading();
                    } else if (state is ScheduleLoading) {
                      return _buildLoading();
                    } else if (state is ScheduleLoaded) {
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(_selectedDate);

                      scheduleList.clear();
                      state.schedules.data?.forEach((element) {
                        if (element.date == formattedDate) {
                          scheduleList.add(element);
                        }
                      });

                      return _buildScheduleTable(
                          context, state.schedules, scheduleList);
                    } else if (state is ScheduleError) {
                      return Container();
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddScheduleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const AddScheduleBottomSheet();
      },
    );
  }
}

Widget _buildScheduleTable(
    BuildContext context, ScheduleModel model, List<Data> list) {
  final size = MediaQuery.of(context).size;
  return Container(
    decoration: BoxDecoration(
        color: ColorManager.secondry, borderRadius: BorderRadius.circular(20)),
    height: size.height * .7,
    child: ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.fromLTRB(50, 20, 10, 0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: ColorManager.calenderBlue,
                    borderRadius: BorderRadius.circular(30)),
                width: 50,
                height: 70,
                child: const Icon(
                  Icons.calendar_month,
                  color: ColorManager.blue,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(list[index].startTime ?? ''),
                      const Text(' - '),
                      Text(list[index].endTime ?? ''),
                    ],
                  ),
                  Text(
                    list[index].name ?? '',
                    style: getMediumtStyle(
                        color: ColorManager.black, fontSize: 18),
                  ),
                ],
              )
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildLoading() => const Center(child: CircularProgressIndicator());
