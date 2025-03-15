import 'package:flutter/material.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/theme/app_theme.dart';
import 'package:fitple/features/work_record/presentation/widgets/calendar/weekday_widget.dart';
import 'package:fitple/features/work_record/util/dates_calculator.dart';

class SingleCalendarDatesWidget extends StatelessWidget {
  DateTime selectedDate;
  DateTime standardDate;
  Function changeDate;

  SingleCalendarDatesWidget({
    super.key,
    required this.selectedDate,
    required this.changeDate,
    required this.standardDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: getWeeks(),
    );
  }

  List<Widget> getWeeks() {
    List<Widget> rows = [];
    int idx = 0;

    List<String> weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    List<DateTime> dates = DatesCalculator.getCalendarDates(standardDate);

    rows.add(
      Row(
        children: weekdays
            .map(
              (e) => WeekDayWidget(
                weekDay: e,
              ),
            )
            .toList(),
      ),
    );

    while (true) {
      if (idx == dates.length) {
        break;
      }

      rows.add(
        Column(
          children: [
            const SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: dates
                  .sublist(idx, idx + 7)
                  .map(
                    (e) => DayWidget(
                      day: e,
                      selectedDate: selectedDate,
                      changeDate: changeDate,
                      standardDate: standardDate,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );

      idx += 7;
    }

    return rows;
  }
}

class DayWidget extends StatelessWidget {
  DateTime day;
  DateTime selectedDate;
  DateTime standardDate;
  Function changeDate;

  DayWidget({
    super.key,
    required this.day,
    required this.selectedDate,
    required this.changeDate,
    required this.standardDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (selectedDate != day) {
          changeDate(day);
        }
      },
      child: Container(
        decoration: getDecoration(),
        width: 40.0,
        height: 40.0,
        child: Center(
          child: Text(
            day.day.toString(),
            style: AppTextTheme.sm.regular.copyWith(
              color: getFontColor(),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration getDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: getColor(),
    );
  }

  Color getColor() {
    if (day == selectedDate) {
      return AppColors.brand600;
    }

    if (DateUtils.isSameDay(DateTime.now(), day)) {
      return AppColors.grey200;
    }

    return Colors.transparent;
  }

  getFontColor() {
    if (day == selectedDate) {
      return AppColors.white;
    }

    if (day.month == standardDate.month + 1) {
      return AppColors.grey400;
    }

    return AppColors.grey700;
  }
}
