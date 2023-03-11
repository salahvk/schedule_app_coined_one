import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app_coined_one/bloc/schedule_bloc.dart';
import 'package:schedule_app_coined_one/components/color_manager.dart';
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
            const SizedBox(height: 20),
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
