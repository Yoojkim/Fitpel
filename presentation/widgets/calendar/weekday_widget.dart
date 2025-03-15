import 'package:flutter/material.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/theme/app_theme.dart';

class WeekDayWidget extends StatelessWidget {
  String weekDay;
  WeekDayWidget({
    super.key,
    required this.weekDay,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.0,
      height: 40.0,
      child: Center(
        child: Text(
          weekDay,
          style: AppTextTheme.sm.semiBold.copyWith(
            color: AppColors.grey700,
          ),
        ),
      ),
    );
  }
}
