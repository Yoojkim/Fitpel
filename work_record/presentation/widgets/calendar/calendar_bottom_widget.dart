import 'package:flutter/material.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/theme/app_theme.dart';
import 'package:fitple/features/work_record/domain/selected_data.dart';

class CalendarBottomWidget extends StatelessWidget {
  DateTime? startDate;
  DateTime? endDate;

  CalendarBottomWidget({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        16.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Expanded(
            child: CancelWidget(),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: ApplyWidget(startDate: startDate, endDate: endDate),
          ),
        ],
      ),
    );
  }
}

class CancelWidget extends StatelessWidget {
  const CancelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 16.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xffD0D5DD),
            width: 1,
          ),
          color: const Color(0xffFFFFFF),
        ),
        child: Text(
          '취소',
          style: AppTextTheme.sm.semiBold.copyWith(
            color: AppColors.grey700,
          ),
        ),
      ),
    );
  }
}

class ApplyWidget extends StatelessWidget {
  DateTime? startDate;
  DateTime? endDate;
  ApplyWidget({super.key, required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context) {
    Color applyColor = getApplyButtonColor();

    return GestureDetector(
      onTap: () {
        if (startDate == null || endDate == null) {
          return;
        }

        Navigator.pop<SelectedDate>(
          context,
          SelectedDate(
            startDate: startDate!,
            endDate: endDate!,
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 16.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: (applyColor == Colors.white)
                ? const Color(0xffD0D5DD)
                : applyColor,
            width: 1,
          ),
          color: applyColor,
        ),
        child: Text(
          '적용하기',
          style: AppTextTheme.sm.semiBold.copyWith(
            color: (applyColor == AppColors.white)
                ? AppColors.grey700
                : AppColors.white,
          ),
        ),
      ),
    );
  }

  Color getApplyButtonColor() {
    if (startDate == null || endDate == null) {
      return const Color(0xffFFFFFF);
    }

    return const Color(0xff13AB62);
  }
}
