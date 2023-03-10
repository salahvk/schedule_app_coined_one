import 'package:flutter/material.dart';

class AddScheduleBottomSheet extends StatefulWidget {
  const AddScheduleBottomSheet({Key? key}) : super(key: key);

  @override
  _AddScheduleBottomSheetState createState() => _AddScheduleBottomSheetState();
}

class _AddScheduleBottomSheetState extends State<AddScheduleBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late DateTime _startTime;
  late DateTime _endTime;
  late DateTime _date;

  void _submitForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      // TODO: Add the new schedule to the database or state management system
      Navigator.of(context).pop();
    }
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a name' : null,
                onSaved: (value) => _name = value!,
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
}
