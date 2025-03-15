import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/constants/image_paths.dart';
import 'package:fitple/common/theme/app_theme.dart';
import 'package:fitple/features/work_record/domain/selected_data.dart';
import 'package:fitple/features/work_record/presentation/state/controller/work_record_controller.dart';
import 'package:fitple/features/work_record/presentation/widgets/calendar/calendar_widget.dart';

class SelectedDateWidget extends ConsumerWidget {
  SelectedDate selectedDate;

  SelectedDateWidget({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: InkWell(
        onTap: () {
          showCalendarModalSheet(context, ref);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 14.0,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.grey300,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                ImagePaths.calendarBlank,
                width: 20.0,
                height: 20.0,
              ),
              Text(
                getSelectedDateText(),
                style: AppTextTheme.md.medium,
              ),
              const SizedBox(
                width: 20,
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  void showCalendarModalSheet(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<SelectedDate>(
      context: context,
      builder: (context) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.83,
            height: double.infinity,
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              surfaceTintColor: Colors.white,
              child: Calendar(
                selectedDate: selectedDate,
              ),
            ),
          ),
        );
      },
    );

    if (result == null) {
      return;
    }

    ref.read(workRecordControllerProvider.notifier).changeSelectedDate(result);
  }

  String getSelectedDateText() {
    String startText = getFormattedDate(selectedDate.startDate);
    String combine = '-';
    String endText = getFormattedDate(selectedDate.endDate);

    return startText + combine + endText;
  }

  String getFormattedDate(DateTime date) {
    return '${getFormattedNumber(date.month)}.${getFormattedNumber(date.day)}';
  }

  String getFormattedNumber(int number) {
    return number.toString().padLeft(2, '0');
  }
}
