import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app_coined_one/API/saveSchedule.dart';
import 'package:schedule_app_coined_one/components/color_manager.dart';
import 'package:schedule_app_coined_one/controllers/controllers.dart';

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

  void _submitForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      saveSchedule(
          name: BottomSheetControllers.nameController.text,
          startTime: BottomSheetControllers.startTimeController.text,
          endTime: BottomSheetControllers.endTimeController.text,
          date: BottomSheetControllers.dateController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BottomSheetControllers.startTimeController.text = '9AM';
    BottomSheetControllers.endTimeController.text = '10AM';
    BottomSheetControllers.dateController.text = '12/2/2021';
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
                  const Text("Add Schedule"),
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
              const Text("Name"),
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
              const Text("Date & Time"),

              Container(
                // height: 200,
                decoration: BoxDecoration(
                  color: ColorManager.lightBlue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(flex: 4, child: Text('Start Time')),
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

                                  decoration: const InputDecoration(
                                    suffixIcon:
                                        Icon(Icons.arrow_forward_ios_rounded),
                                    // labelText: 'Name',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10),
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

                      // EndTime Widget

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(flex: 4, child: Text('End Time')),
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

                                  decoration: const InputDecoration(
                                    suffixIcon:
                                        Icon(Icons.arrow_forward_ios_rounded),
                                    // labelText: 'Name',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10),
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

                      // Date Widget

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(flex: 4, child: Text('Date')),
                          Flexible(
                            flex: 3,
                            child: GestureDetector(
                              // onTap: () async {
                              //   TimeOfDay? time = await showTimePicker(
                              //     context: context,
                              //     initialTime: TimeOfDay.now(),
                              //   );
                              //   if (time != null) {
                              //     _timeController.text = time.format(context);
                              //   }
                              // },
                              onTap: () {
                                _selectDate(context);
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller:
                                      BottomSheetControllers.dateController,

                                  decoration: const InputDecoration(
                                    suffixIcon:
                                        Icon(Icons.arrow_forward_ios_rounded),
                                    // labelText: 'Name',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10),
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
              // DateTimePicker(
              //   type: DateTimePickerType.dateTimeSeparate,
              //   initialValue: DateTime.now().toString(),
              //   firstDate: DateTime(2000),
              //   lastDate: DateTime(2100),
              //   dateLabelText: 'Start Time',
              //   timeLabelText: 'Time',
              //   onChanged: (value) => _startTime = DateTime.parse(value),
              //   validator: (value) => value == null ? 'Please enter a start time' : null,
              // ),
              // SizedBox(height: 16.0),
              // DateTimePicker(
              //   type: DateTimePickerType.dateTimeSeparate,
              //   initialValue: DateTime.now().toString(),
              //   firstDate: DateTime(2000),
              //   lastDate: DateTime(2100),
              //   dateLabelText: 'End Time',
              //   timeLabelText: 'Time',
              //   onChanged: (value) => _endTime = DateTime.parse(value),
              //   validator: (value) => value == null ? 'Please enter an end time' : null,
              // ),
              // SizedBox(height: 16.0),
              // DateTimePicker(
              //   type: DateTimePickerType.date,
              //   initialValue: DateTime.now().toString(),
              //   firstDate: DateTime(2000),
              //   lastDate: DateTime(2100),
              //   dateLabelText: 'Date',
              //   onChanged: (value) => _date = DateTime.parse(value),
              //   validator: (value) => value == null ? 'Please enter a date' : null,
              // ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Schedule'),
              ),
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
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        BottomSheetControllers.dateController.text =
            DateFormat("dd-MM-yyyy").format(selectedDate);
      });
    }
  }
}
