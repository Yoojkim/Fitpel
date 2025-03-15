import 'package:flutter/material.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/theme/app_theme.dart';
import 'package:fitple/features/work_record/domain/time.dart';
import 'package:fitple/features/work_record/domain/sum_for_time_and_salary.dart';
import 'package:fitple/features/work_record/util/formatter_util.dart';

class WorkRecordSumWidget extends StatelessWidget {
  final SumForTimeAndSalary workRecordsSumForAll;

  TextStyle semiTitleStyle = AppTextTheme.sm.semiBold.copyWith(
    color: AppColors.grey500,
  );

  TextStyle borderStyle = AppTextTheme.xl.semiBold.copyWith(
    color: AppColors.grey900,
  );

  TextStyle normalStyle = AppTextTheme.sm.medium.copyWith(
    color: AppColors.grey900,
  );

  WorkRecordSumWidget({
    super.key,
    required this.workRecordsSumForAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getTimeSumWidget(
            workRecordsSumForAll.time,
          ),
          const SizedBox(
            width: 12.0,
          ),
          getSalarySumWidget(
            workRecordsSumForAll.salary,
          ),
        ],
      ),
    );
  }

  Widget getTimeSumWidget(Time time) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: AppColors.grey200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '총 근무 시간',
              style: semiTitleStyle,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: FormatterUtil.getFormattedTimePart(time.hour),
                    style: borderStyle,
                  ),
                  TextSpan(
                    text: '시간 ',
                    style: normalStyle,
                  ),
                  TextSpan(
                    text: FormatterUtil.getFormattedTimePart(time.min),
                    style: borderStyle,
                  ),
                  TextSpan(
                    text: '분',
                    style: normalStyle,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSalarySumWidget(int salary) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: AppColors.grey200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '총 급여',
              style: semiTitleStyle,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: FormatterUtil.getForamttedWage(salary),
                    style: borderStyle,
                  ),
                  TextSpan(
                    text: '원',
                    style: normalStyle,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
