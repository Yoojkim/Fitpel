import 'package:flutter/material.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/theme/app_theme.dart';
import 'package:fitple/features/work_record/util/weekday_extension.dart';

class WorkDateWidget extends StatelessWidget {
  DateTime date;
  WorkDateWidget({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    String weekDayStr =
        '${date.month}월 ${date.day}일, ${date.getKoreanWeekDay()}요일';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: AppColors.grey200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '근무 날짜',
              style: AppTextTheme.md.regular.copyWith(
                color: AppColors.grey700,
              ),
            ),
            Text(
              weekDayStr,
              style: AppTextTheme.md.medium.copyWith(
                color: AppColors.grey700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
