import 'package:flutter/material.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/theme/app_theme.dart';

class SingleCalendarDateWidget extends StatelessWidget {
  DateTime selectedDate;
  Function changeToday;
  SingleCalendarDateWidget({
    super.key,
    required this.selectedDate,
    required this.changeToday,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: AppColors.grey200,
              ),
            ),
            child: Text(
              '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
              style: AppTextTheme.sm.semiBold.copyWith(
                color: AppColors.grey700,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        GestureDetector(
          onTap: () {
            changeToday();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: AppColors.grey300,
              ),
            ),
            child: Text(
              '오늘',
              style: AppTextTheme.sm.semiBold.copyWith(
                color: AppColors.grey700,
              ),
            ),
          ),
        )
      ],
    );
  }
}
