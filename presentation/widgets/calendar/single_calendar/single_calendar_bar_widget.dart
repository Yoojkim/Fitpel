import 'package:flutter/material.dart';
import 'package:fitple/features/work_record/presentation/widgets/calendar/calendar_bar_widget.dart';

class SingleCalendarBarWidget extends StatelessWidget {
  DateTime standardDate;
  Function goNextMonth;
  Function goPreviousMonth;
  SingleCalendarBarWidget({
    super.key,
    required this.standardDate,
    required this.goNextMonth,
    required this.goPreviousMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PreviousNavigator(
          goPreviousMonth: goPreviousMonth,
        ),
        DateTextWidget(
          standard: standardDate,
        ),
        NextNavigator(
          goNextMonth: goNextMonth,
        ),
      ],
    );
  }
}
