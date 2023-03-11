import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app_coined_one/bloc/schedule_bloc.dart';
import 'package:schedule_app_coined_one/components/color_manager.dart';
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
  String? moYear;
  List<Data> sList = [];

  @override
  void initState() {
    super.initState();

    _scheduleBloc.add(FetchScheduleEvent());
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
    moYear = DateFormat('yMMMM').format(_selectedDate);
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
                "$moYear",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: ColorManager.textColor),
              ),
            ),
            CalendarTimeline(
              // showYears: true,
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
              onDateSelected: (date) {
                setState(() => {
                      moYear = DateFormat('yMMMM').format(date),
                      _selectedDate = date
                    });
                print(_selectedDate);
              },
              leftMargin: 20,
              monthColor: ColorManager.textColor,
              dayColor: ColorManager.textColor,
              dayNameColor: const Color(0xFF333A47),
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.blue,
              dotsColor: const Color(0xFF333A47),
              selectableDayPredicate: (date) => date.day != 23,
              locale: 'en',
            ),
            const SizedBox(height: 20),
            BlocProvider(
              create: (_) => _scheduleBloc,
              child: BlocBuilder<ScheduleBloc, ScheduleState>(
                builder: (context, state) {
                  if (state is ScheduleInitial) {
                    return _buildLoading();
                  } else if (state is ScheduleLoading) {
                    return _buildLoading();
                  } else if (state is ScheduleLoaded) {
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(_selectedDate);
                    // print(formattedDate);
                    // final sDate = _selectedDate.toString().substring(0, 11);
                    // print(sDate);
                    // print(state.schedules.data?.contains(sDate));
                    sList.clear();
                    state.schedules.data?.forEach((element) {
                      // print(element.date);
                      if (element.date == formattedDate) {
                        sList.add(element);
                        print(sList);
                        // print(element.toJson());
                      }
                      // print(element.date == formattedDate);
                    });

                    return _buildScheduleTable(context, state.schedules, sList);
                  } else if (state is ScheduleError) {
                    return Container();
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 16),
            //   child: TextButton(
            //     style: ButtonStyle(
            //       backgroundColor: MaterialStateProperty.all(Colors.teal[200]),
            //     ),
            //     child: const Text(
            //       'RESET',
            //       style: TextStyle(color: Color(0xFF333A47)),
            //     ),
            //     onPressed: () => setState(() => _resetSelectedDate()),
            //   ),
            // ),
            // const SizedBox(height: 20),
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
    BuildContext context, ScheduleModel model, List list) {
  return SizedBox(
    height: 300,
    child: ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          child: Card(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: const <Widget>[
                  // Text("Country: ${model.countries![index].country}"),
                  // Text(
                  //     "Total Confirmed: ${model.countries![index].totalConfirmed}"),
                  // Text("Total Deaths: ${model.countries![index].totalDeaths}"),
                  // Text(
                  //     "Total Recovered: ${model.countries![index].totalRecovered}"),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildLoading() => const Center(child: CircularProgressIndicator());
