import 'package:flutter/material.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/theme/app_theme.dart';
import 'package:fitple/features/work_record/presentation/widgets/name_icon_widget.dart';

class WorkRecordSheetEmployeeWidget extends StatelessWidget {
  String name;
  WorkRecordSheetEmployeeWidget({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 32.0,
          height: 32.0,
          child: NameIconWidget(
            name: name,
            size: const Size(
              32.0,
              32.0,
            ),
            textStyle: AppTextTheme.xs.semiBold,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          name,
          style: AppTextTheme.lg.medium.copyWith(
            color: AppColors.grey700,
          ),
        )
      ],
    );
  }
}
