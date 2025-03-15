import 'package:flutter/material.dart';
import 'package:fitple/features/work_record/domain/time.dart';
import 'package:fitple/features/work_record/util/formatter_util.dart';

class TimeAndSalaryForEmployeeWidget extends StatelessWidget {
  Time time;
  int? salary;

  TimeAndSalaryForEmployeeWidget({
    super.key,
    required this.time,
    this.salary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF2F4F7),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SumStandardWidget(
              type: '근무 시간',
              amount: FormatterUtil.getFormattedTimeWithColon(time),
            ),
            const SizedBox(
              width: 12.0,
            ),
            SumStandardWidget(
              type: '급여',
              amount: salary == null
                  ? '--'
                  : FormatterUtil.getFormattedWageWithWon(
                      salary!,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class SumStandardWidget extends StatelessWidget {
  String type;
  String amount;
  SumStandardWidget({
    super.key,
    required this.type,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          type,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Color(0xff344054),
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Color(0xff344054),
          ),
        ),
      ],
    );
  }
}
