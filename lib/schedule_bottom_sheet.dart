// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app_coined_one/API/saveSchedule.dart';
import 'package:schedule_app_coined_one/bloc/schedule_bloc.dart';
import 'package:schedule_app_coined_one/components/color_manager.dart';
import 'package:schedule_app_coined_one/components/style_manager.dart';
import 'package:schedule_app_coined_one/controllers/controllers.dart';
import 'package:schedule_app_coined_one/screen/home_page.dart';
import 'package:schedule_app_coined_one/utils/popup.dart';

class AddScheduleBottomSheet extends StatefulWidget {
  const AddScheduleBottomSheet({Key? key}) : super(key: key);

  @override
  _AddScheduleBottomSheetState createState() => _AddScheduleBottomSheetState();
}

class _AddScheduleBottomSheetState extends State<AddScheduleBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  final ScheduleBloc _scheduleBloc = ScheduleBloc();
  final today = DateFormat("dd-MM-yyyy").format(DateTime.now());
  bool isLoading = false;

  void _submitForm() async {
    setState(() {
      isLoading = true;
    });
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();

      final status = await saveSchedule(
        name: BottomSheetControllers.nameController.text,
        startTime: BottomSheetControllers.startTimeController.text,
        endTime: BottomSheetControllers.endTimeController.text,
        date: BottomSheetControllers.dateController.text,
      );

      if (status != 'success') {
        showOverlapPopup(context);
        setState(() {
          isLoading = false;
        });
      } else {
        _scheduleBloc.add(FetchScheduleEvent());

        // Navigator.of(context).pop();
        await Future.delayed(const Duration(seconds: 3));
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (ctx) {
          return const HomePage();
        }));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    BottomSheetControllers.startTimeController.text = '9:00 AM';
    BottomSheetControllers.endTimeController.text = '10:00 AM';
    BottomSheetControllers.dateController.text = today;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add Schedule",
                    style: getSemiBoldtStyle(
                        color: ColorManager.blue, fontSize: 16),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.close))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Name",
                style: getRegularStyle(color: ColorManager.black, fontSize: 12),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorManager.lightBlue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: BottomSheetControllers.nameController,
                  decoration: const InputDecoration(
                    // labelText: 'Name',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a name' : null,
                  onSaved: (value) => _name = value!,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Date & Time",
                style: getRegularStyle(color: ColorManager.black, fontSize: 12),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                // height: 200,
                decoration: BoxDecoration(
                  color: ColorManager.lightBlue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              flex: 4,
                              child: Text('Start Time',
                                  style: getRegularStyle(
                                      color: ColorManager.black,
                                      fontSize: 14))),
                          Flexible(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () async {
                                TimeOfDay? time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  BottomSheetControllers.startTimeController
                                      .text = time.format(context);
                                }
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: BottomSheetControllers
                                      .startTimeController,
                                  style:
                                      const TextStyle(color: ColorManager.blue),
                                  decoration: const InputDecoration(
                                    suffix: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                    ),
                                    // labelText: 'Name',
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  ),
                                  // decoration: const InputDecoration(
                                  //   labelText: 'Time',
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: ColorManager.black, thickness: .1),
                      // EndTime Widget

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              flex: 4,
                              child: Text('End Time',
                                  style: getRegularStyle(
                                      color: ColorManager.black,
                                      fontSize: 14))),
                          Flexible(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () async {
                                TimeOfDay? time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  BottomSheetControllers.endTimeController
                                      .text = time.format(context);
                                }
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller:
                                      BottomSheetControllers.endTimeController,
                                  style:
                                      const TextStyle(color: ColorManager.blue),
                                  decoration: const InputDecoration(
                                    suffix: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                    ),
                                    // labelText: 'Name',
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  ),
                                  // decoration: const InputDecoration(
                                  //   labelText: 'Time',
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: ColorManager.black, thickness: .1),

                      // Date Widget

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              flex: 4,
                              child: Text('Date',
                                  style: getRegularStyle(
                                      color: ColorManager.black,
                                      fontSize: 14))),
                          Flexible(
                            flex: 3,
                            child: GestureDetector(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller:
                                      BottomSheetControllers.dateController,
                                  style:
                                      const TextStyle(color: ColorManager.blue),

                                  decoration: const InputDecoration(
                                    suffix: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(30, 0, 10, 0),
                                  ),
                                  // decoration: const InputDecoration(
                                  //   labelText: 'Time',
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    _submitForm();
                    // context.watch<ScheduleBloc>().add(FetchScheduleEvent());
                    // setState(() {});
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: ColorManager.primary,
                        )
                      : const Text('Add Schedule'),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
                colorScheme:
                    const ColorScheme.light(primary: ColorManager.blue)),
            child: child!,
          );
        },
        context: context,
        initialDate: selectedDate,
        lastDate: DateTime(2100, 8),
        firstDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        BottomSheetControllers.dateController.text =
            DateFormat("dd-MM-yyyy").format(selectedDate);
      });
    }
  }

  void showOverlapPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScheduleOverlapPopup(
          message: 'This overlaps with another schedule and can\'t be saved.',
          onOkayPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
