import 'package:flutter/material.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/features/work_record/presentation/widgets/calendar/single_calendar/single_calendar_bar_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/calendar/single_calendar/single_calendar_bottom_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/calendar/single_calendar/single_calendar_date_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/calendar/single_calendar/single_calendar_dates_widget.dart';
import 'package:fitple/features/work_record/util/dates_calculator.dart';

//todo: 날짜 하나만 선택하는 캘린더 구현
class SingelCalendarWidget extends StatefulWidget {
  DateTime selectedDate;
  late DateTime standardDate;

  SingelCalendarWidget({
    super.key,
    required this.selectedDate,
  }) {
    standardDate = DatesCalculator.getStartDate(selectedDate);
  }

  @override
  State<SingelCalendarWidget> createState() => _SingelCalendarWidgetState();
}

class _SingelCalendarWidgetState extends State<SingelCalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        border: Border.all(
          width: 1,
          color: AppColors.grey100,
        ),
        color: AppColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 24.0,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.grey100,
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleCalendarBarWidget(
                  standardDate: widget.standardDate,
                  goNextMonth: goNextMonth,
                  goPreviousMonth: goPreviousMonth,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                SingleCalendarDateWidget(
                  selectedDate: widget.selectedDate,
                  changeToday: changeToday,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                FittedBox(
                  child: SingleCalendarDatesWidget(
                    selectedDate: widget.selectedDate,
                    changeDate: changeSelectedDate,
                    standardDate: widget.standardDate,
                  ),
                )
              ],
            ),
          ),
          SingleCalendarBottomWidget(
            store: store,
          ),
        ],
      ),
    );
  }

  void changeSelectedDate(DateTime date) {
    setState(() {
      widget.selectedDate = date;
    });
  }

  void goNextMonth() {
    setState(() {
      widget.standardDate = DateTime(
        widget.standardDate.year,
        widget.standardDate.month + 1,
      );
    });
  }

  void goPreviousMonth() {
    setState(() {
      widget.standardDate = DateTime(
        widget.standardDate.year,
        widget.standardDate.month - 1,
      );
    });
  }

  void changeToday() {
    setState(() {
      DateTime today = DateTime.now();
      widget.selectedDate = DateTime(today.year, today.month, today.day);
      widget.standardDate = DatesCalculator.getStartDate(widget.selectedDate);
    });
  }

  DateTime store() {
    return widget.selectedDate;
  }
}
