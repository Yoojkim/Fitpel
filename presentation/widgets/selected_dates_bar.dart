import 'package:flutter/material.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/theme/app_theme.dart';

class SelectedDateBar extends StatelessWidget {
  DateTime? startDate;
  DateTime? endDate;
  SelectedDateBar({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  TextStyle textStyle = AppTextTheme.sm.regular.copyWith(
    color: AppColors.grey700,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        getDateWidget(startDate, textStyle),
        const SizedBox(
          width: 8.0,
        ),
        Container(
          width: 8,
          height: 1,
          color: AppColors.grey500,
        ),
        const SizedBox(
          width: 8.0,
        ),
        getEndDateWidget(endDate, startDate!),
      ],
    );
  }

  String getDateStr(DateTime? date) {
    if (date == null) {
      return "";
    }

    return "${date.year}년 ${date.month}월 ${date.day}일";
  }

  Widget getEndDateWidget(DateTime? endDate, DateTime startDate) {
    if (endDate != null) {
      return getDateWidget(endDate, textStyle);
    }

    return getDateWidget(
      startDate,
      textStyle.copyWith(
        color: Colors.transparent,
      ),
    );
  }

  Widget getDateWidget(
    DateTime? date,
    TextStyle style,
  ) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 16.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.grey300,
            width: 1,
          ),
        ),
        child: Text(
          getDateStr(date),
          style: style,
        ),
      ),
    );
  }
}
