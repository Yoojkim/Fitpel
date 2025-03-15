import 'package:flutter/material.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/theme/app_theme.dart';

class StandardSheetPartWidget extends StatelessWidget {
  String type;
  Widget valueWidget;

  StandardSheetPartWidget({
    super.key,
    required this.type,
    required this.valueWidget,
  });

  static StandardSheetPartWidget createStandardSheetPartWidgetWithStrValue({
    required String type,
    required String value,
  }) {
    Widget valueWidget = Text(
      value,
      style: AppTextTheme.lg.medium.copyWith(
        color: AppColors.grey700,
      ),
    );

    return StandardSheetPartWidget(type: type, valueWidget: valueWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xffE4E7EC),
          ),
        ),
      ),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 24.0,
        vertical: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.0,
            ),
          ),
          valueWidget,
        ],
      ),
    );
  }
}
