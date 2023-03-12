import 'package:flutter/material.dart';
import 'package:schedule_app_coined_one/components/color_manager.dart';

class ScheduleOverlapPopup extends StatelessWidget {
  final String message;
  final void Function() onOkayPressed;

  const ScheduleOverlapPopup(
      {super.key, required this.message, required this.onOkayPressed});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: const Text(
        'This overlaps with another schedule and can\'t be saved',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      content: const Text(
        'Please modify and try again.',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: ColorManager.blue,
        ),
      ),
      actions: [
        SizedBox(
          width: size.width,
          height: 60,
          child: ElevatedButton(
            onPressed: onOkayPressed,
            child: const Text('Okay'),
          ),
        ),
      ],
    );
  }
}
