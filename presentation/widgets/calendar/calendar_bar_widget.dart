import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/theme/app_theme.dart';

class CalendarBar extends StatelessWidget {
  DateTime standard;
  Function goPreviousMonth;
  Function goNextMonth;
  CalendarBar({
    super.key,
    required this.standard,
    required this.goPreviousMonth,
    required this.goNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PreviousNavigator(
          goPreviousMonth: goPreviousMonth,
        ),
        DateTextWidget(
          standard: standard,
        ),
        NextNavigator(
          goNextMonth: goNextMonth,
        ),
      ],
    );
  }
}

class DateTextWidget extends StatelessWidget {
  DateTime standard;
  DateTextWidget({
    super.key,
    required this.standard,
  });

  @override
  Widget build(BuildContext context) {
    String year = standard.year.toString();
    String month = standard.month.toString();

    return Text(
      '$year년 $month월',
      style: AppTextTheme.md.semiBold.copyWith(
        color: AppColors.grey700,
      ),
    );
  }
}

class PreviousNavigator extends StatelessWidget {
  Function goPreviousMonth;
  PreviousNavigator({
    super.key,
    required this.goPreviousMonth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36.0,
      height: 36.0,
      child: IconButton(
        onPressed: () {
          goPreviousMonth();
        },
        icon: SvgPicture.asset(
          'asset/icons/left_icon.svg',
          color: const Color(0xff344054),
        ),
      ),
    );
  }
}

class NextNavigator extends StatelessWidget {
  Function goNextMonth;
  NextNavigator({
    super.key,
    required this.goNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36.0,
      height: 36.0,
      child: IconButton(
        onPressed: () {
          goNextMonth();
        },
        icon: SvgPicture.asset(
          'asset/icons/right_icon.svg',
          color: const Color(0xff344043),
        ),
      ),
    );
  }
}
