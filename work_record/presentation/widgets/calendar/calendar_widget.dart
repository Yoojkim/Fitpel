import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/features/work_record/domain/selected_data.dart';
import 'package:fitple/features/work_record/presentation/widgets/calendar/calendar_bar_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/calendar/calendar_bottom_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/calendar/dates_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/selected_dates_bar.dart';
import 'package:fitple/features/work_record/util/dates_calculator.dart';

class Calendar extends StatefulWidget {
  //startDate / endDate는 Calendar 위젯(자식 위젯 포함)에서 모두 사용하는 개념
  //기존 WorkRecordsScreen에서 정의한 SelectedDate 값으로 정의되지만 사용자 선택에 따라 값이 계속 변경됨 (null 값도 가능) *주의
  DateTime? startDate;
  DateTime? endDate;

  late DateTime standard;

  Calendar({
    super.key,
    required SelectedDate selectedDate,
  }) {
    standard = DatesCalculator.getStartDate(
      selectedDate.startDate,
    ); //기준: 선택된 날짜 중 첫째날의 달 첫일

    startDate = selectedDate.startDate;
    endDate = selectedDate.endDate;
  }

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
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
                  color: Color(0xffF2F4F7),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarBar(
                  standard: widget.standard,
                  goPreviousMonth: goPreviousMonth,
                  goNextMonth: goNextMonth,
                ),
                const SizedBox(
                  height: 12,
                ),
                SelectedDateBar(
                  startDate: widget.startDate,
                  endDate: widget.endDate,
                ),
                const SizedBox(
                  height: 12,
                ),
                //날짜 나타내는 위젯
                FittedBox(
                  child: Dates(
                    startDate: widget.startDate,
                    endDate: widget.endDate,
                    standard: widget.standard,
                    changeStart: changeStartDate,
                    changeEnd: changeEndDate,
                  ),
                ),
              ],
            ),
          ),
          CalendarBottomWidget(
            startDate: widget.startDate,
            endDate: widget.endDate,
          ),
        ],
      ),
    );
  }

  List<DateTime?> getSelectedDateTime() {
    return [widget.startDate, widget.endDate];
  }

  void changeStartDate(DateTime? newStart) {
    setState(() {
      widget.startDate = newStart;
    });
  }

  void changeEndDate(DateTime? newEnd) {
    setState(() {
      widget.endDate = newEnd;
    });
  }

  void goPreviousMonth() {
    setState(() {
      widget.standard = DateTime(
        widget.standard.year,
        widget.standard.month - 1,
      );
    });
  }

  void goNextMonth() {
    setState(() {
      widget.standard = DateTime(
        widget.standard.year,
        widget.standard.month + 1,
      );
    });
  }
}
