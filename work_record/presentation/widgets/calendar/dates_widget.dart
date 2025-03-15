import 'package:flutter/material.dart';
import 'package:fitple/common/theme/app_theme.dart';
import 'package:fitple/features/work_record/presentation/widgets/calendar/weekday_widget.dart';
import 'package:fitple/features/work_record/util/dates_calculator.dart';

class Dates extends StatefulWidget {
  DateTime? startDate;
  DateTime? endDate;
  DateTime standard;

  Function changeStart;
  Function changeEnd;

  Dates(
      {super.key,
      required this.startDate,
      required this.endDate,
      required this.standard,
      required this.changeStart,
      required this.changeEnd});

  @override
  State<Dates> createState() => _DatesState();
}

class _DatesState extends State<Dates> {
  late List<DateTime> dates;

  @override
  void initState() {
    super.initState();
    dates = DatesCalculator.getCalendarDates(widget.standard);
  }

  @override
  Widget build(BuildContext context) {
    //날짜 재계산
    if (widget.standard.month != dates[7].month) {
      dates = DatesCalculator.getCalendarDates(widget.standard);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: getWeeks(),
    );
  }

  List<Widget> getWeeks() {
    List<Widget> rows = [];
    int idx = 0;

    List<String> weekdays = ['월', '화', '수', '목', '금', '토', '일'];

    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: dates
                  .sublist(idx, idx + 7)
                  .map(
                    (e) => DayWidget(
                      day: e,
                      start: widget.startDate,
                      end: widget.endDate,
                      standard: widget.standard,
                      changePressed: changePressedDay,
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

  void changePressedDay(DateTime pressedDay) {
    setState(() {
      if (widget.startDate != null && widget.endDate != null) {
        widget.startDate = pressedDay;
        widget.endDate = null;

        changeDates();
        return;
      }

      if (widget.endDate == null) {
        widget.endDate = pressedDay;

        if (widget.endDate!.isBefore(widget.startDate!)) {
          DateTime tmp = widget.endDate!;
          widget.endDate = widget.startDate;
          widget.startDate = tmp;
        }

        changeDates();
        return;
      }
    });
  }

  void changeDates() {
    widget.changeStart(widget.startDate);
    widget.changeEnd(widget.endDate);
  }
}

class DayWidget extends StatelessWidget {
  final DateTime day;
  DateTime? start;
  DateTime? end;
  DateTime standard;
  Function changePressed;
  DayWidget(
      {super.key,
      required this.day,
      required this.start,
      required this.end,
      required this.standard,
      required this.changePressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changePressed(day);
      },
      child: Container(
        decoration: getBackgroundDecoration(),
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
      ),
    );
  }

  BoxDecoration getBackgroundDecoration() {
    if (start == null || end == null) {
      return const BoxDecoration();
    }

    if (day != start && day != end) {
      return const BoxDecoration();
    }

    if (day == start && day.weekday != DateTime.sunday) {
      return const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(100),
          bottomLeft: Radius.circular(100),
        ),
        color: Color(0xffF9FAFB),
      );
    }

    if (day == end && day.weekday != DateTime.monday) {
      return const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(100),
          bottomRight: Radius.circular(100),
        ),
        color: Color(0xffF9FAFB),
      );
    }

    return const BoxDecoration();
  }

  BoxDecoration getDecoration() {
    return BoxDecoration(
      borderRadius: getRadius(),
      color: getColor(),
    );
  }

  BorderRadiusGeometry? getRadius() {
    if (day == start || day == end) {
      return BorderRadius.circular(100);
    }

    if (start == null || end == null) {
      return null;
    }

    if (day.isAfter(start!) && day.isBefore(end!)) {
      if (day.weekday == DateTime.monday) {
        return const BorderRadius.only(
          topLeft: Radius.circular(100),
          bottomLeft: Radius.circular(100),
        );
      }

      if (day.weekday == DateTime.sunday) {
        return const BorderRadius.only(
          topRight: Radius.circular(100),
          bottomRight: Radius.circular(100),
        );
      }
    }

    return null;
  }

  Color getColor() {
    if (day == start) {
      return const Color(0xff13AB62);
    }

    if (day == end) {
      return const Color(0xff13AB62);
    }

    if (start == null || end == null) {
      return Colors.transparent;
    }

    if (day.isBefore(end!) && day.isAfter(start!)) {
      return const Color(0xffF9FAFB);
    }

    return Colors.transparent;
  }

  Color getFontColor() {
    if (day == start || day == end) {
      return const Color(0xffFFFFFF);
    }

    if (day.month == standard.month) {
      return const Color(0xff344054);
    }

    return const Color(0xff98A2B3);
  }
}
