import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitple/common/routes.dart';
import 'package:fitple/features/work_record/domain/selected_data.dart';
import 'package:fitple/features/work_record/domain/time.dart';
import 'package:fitple/features/work_record/domain/work_record_sum_for_date.dart';
import 'package:fitple/features/work_record/util/formatter_util.dart';
import 'package:fitple/features/work_record/util/weekday_extension.dart';

class WorkRecordsWidget extends StatelessWidget {
  List<WorkRecordSumForDate> workRecordSumForDates;
  SelectedDate selectedDate;
  ScrollController scrollController;
  WorkRecordsWidget({
    super.key,
    required this.scrollController,
    required this.workRecordSumForDates,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    HashMap<DateTime, WorkRecordSumForDate> map = HashMap.fromIterable(
      workRecordSumForDates,
      key: (item) => item.date,
      value: (item) => item,
    );

    int daysCnt =
        selectedDate.endDate.difference(selectedDate.startDate).inDays + 1;

    return ListView.builder(
      controller: scrollController,
      itemCount: daysCnt,
      itemBuilder: (context, index) {
        DateTime date = selectedDate.endDate.subtract(Duration(days: index));

        Widget workRecordInfoWidget;
        onPressed() {
          context.push(
            AppRoute.workRecord.path,
            extra: date.toString(),
          );
        }

        if (!map.containsKey(date)) {
          workRecordInfoWidget = const WorkRecordInfoBlankWidget();
        } else {
          if (map[date]!.employeeCount == 0) {
            workRecordInfoWidget = const WorkRecordInfoBlankWidget();
          } else {
            workRecordInfoWidget = WorkRecordInfoWidget(
              workRecordSumForDate: map[date]!,
            );
          }
        }

        GestureDetector workRecordWidget = GestureDetector(
          onTap: onPressed,
          child: WorkRecordWidget(
            date: date,
            workRecordInfoWidget: workRecordInfoWidget,
          ),
        );

        if (isFirstDatisFirstDayOfMonthAndNotLastElement(
            date, index, daysCnt)) {
          return ListTile(
            title: Column(
              children: [
                workRecordWidget,
                const SizedBox(
                  height: 10.0,
                ),
                MonthBoundaryWidget(
                  month: date.subtract(const Duration(days: 1)).month,
                ),
              ],
            ),
          );
        }

        return ListTile(
          title: workRecordWidget,
        );
      },
    );
  }

  bool isFirstDatisFirstDayOfMonthAndNotLastElement(
      DateTime date, int index, int daysCnt) {
    if (date.day != 1 || index == daysCnt - 1) {
      return false;
    }

    return true;
  }
}

class MonthBoundaryWidget extends StatelessWidget {
  int month;
  MonthBoundaryWidget({
    super.key,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    Widget line = Container(
      height: 1.0,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xffE4E7EC),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Expanded(child: line),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            '$month월',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.0,
              color: Color(0xff98A2B3),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(child: line),
        ],
      ),
    );
  }
}

class WorkRecordWidget extends StatelessWidget {
  DateTime date;
  Widget workRecordInfoWidget;
  WorkRecordWidget({
    super.key,
    required this.date,
    required this.workRecordInfoWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        12.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: const Color(0xffE4E7EC),
        ),
      ),
      child: Row(
        children: [
          WorkRecordDateWidget(
            date: date,
          ),
          workRecordInfoWidget,
        ],
      ),
    );
  }
}

class WorkRecordInfoBlankWidget extends StatelessWidget {
  const WorkRecordInfoBlankWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: WorkRecordInfoSingleWidget(infoName: '근무 시간', info: '--'),
          ),
          Expanded(
            child: WorkRecordInfoSingleWidget(infoName: '직원 수', info: '--'),
          ),
          Expanded(
            child: WorkRecordInfoSingleWidget(infoName: '급여', info: '--'),
          ),
        ],
      ),
    );
  }
}

class WorkRecordInfoWidget extends StatelessWidget {
  WorkRecordSumForDate workRecordSumForDate;
  WorkRecordInfoWidget({
    super.key,
    required this.workRecordSumForDate,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: WorkRecordInfoSingleWidget(
              infoName: '근무 시간',
              info: FormatterUtil.getFormattedTimeWithColon(
                workRecordSumForDate.workingTime,
              ),
            ),
          ),
          Expanded(
            child: WorkRecordInfoSingleWidget(
              infoName: '직원 수',
              info: workRecordSumForDate.employeeCount.toString(),
            ),
          ),
          Expanded(
            child: WorkRecordInfoSingleWidget(
              infoName: '급여',
              info: FormatterUtil.getFormattedWageWithWon(
                workRecordSumForDate.salary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getWorkTimeStr() {
    Time workTime = workRecordSumForDate.workingTime;
    return '${getFormattedTimeNumber(workTime.hour)}:${getFormattedTimeNumber(workTime.min)}';
  }

  String getFormattedTimeNumber(int number) {
    return number.toString().padLeft(2, '0');
  }
}

class WorkRecordInfoSingleWidget extends StatelessWidget {
  String infoName;
  String info;
  WorkRecordInfoSingleWidget({
    super.key,
    required this.infoName,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          infoName,
          style: const TextStyle(
            color: Color(0xff475467),
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Text(
          info,
          style: const TextStyle(
            color: Color(0xff101828),
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}

//todo: width, height 변경
class WorkRecordDateWidget extends StatelessWidget {
  DateTime date;
  WorkRecordDateWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    Color fontColor = getFontColor();

    return Container(
      height: 57.0,
      width: 48.0,
      decoration: BoxDecoration(
        color: const Color(0xffF2F4F7),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
              color: fontColor,
            ),
          ),
          Text(
            date.getKoreanWeekDay(),
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: fontColor,
            ),
          ),
        ],
      ),
    );
  }

  Color getFontColor() {
    DateTime now = DateTime.now();

    if (now.year == date.year &&
        now.month == date.month &&
        now.day == date.day) {
      return const Color(0xff13AB62);
    }

    return const Color(0xff101828);
  }
}
