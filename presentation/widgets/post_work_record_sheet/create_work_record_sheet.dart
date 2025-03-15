import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/routes.dart';
import 'package:fitple/common/theme/app_theme.dart';
import 'package:fitple/features/user/domain/employee.dart';
import 'package:fitple/features/work_record/domain/time.dart';
import 'package:fitple/features/work_record/presentation/state/work_info_state.dart';
import 'package:fitple/features/work_record/presentation/state/controller/work_info_controller.dart';
import 'package:fitple/features/work_record/presentation/widgets/calendar/single_calendar/single_date_calendar_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/post_work_record_sheet/standard_sheet_part_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/post_work_record_sheet/store_button_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/post_work_record_sheet/work_record_sheet_bar.dart';
import 'package:fitple/features/work_record/presentation/widgets/post_work_record_sheet/work_record_sheet_employee_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/time_and_salary_for_employee_widget.dart';
import 'package:fitple/features/work_record/util/formatter_util.dart';
import 'package:fitple/features/work_record/util/work_record_sum_util.dart';

class CreateWorkRecordSheet extends ConsumerStatefulWidget {
  const CreateWorkRecordSheet({
    super.key,
  });

  ConsumerState<ConsumerStatefulWidget> createState() =>
      CreateWorkRecordSheetState();
}

class CreateWorkRecordSheetState extends ConsumerState<CreateWorkRecordSheet> {
  @override
  Widget build(BuildContext context) {
    ref.watch(workInfoControllerProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              const WorkRecordSheetBar(),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      getDateWidget(),
                      getStartTimeWidget(),
                      getEndTimeWidget(),
                      getEmployeeWidget(),
                      getRoleWidget(),
                      Container(
                        width: double.infinity,
                        height: 1.0,
                        color: const Color(0xffE4E7EC),
                      ),
                      getSumWidget(),
                    ],
                  ),
                ),
              ),
              StoreButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSumWidget() {
    Time time = ref
        .read(
          workInfoControllerProvider.notifier,
        )
        .getTimeDifference();

    int? salary;
    if (ref.read(workInfoControllerProvider.notifier).canCalculateSalary()) {
      WorkInfoState workInfo = ref.read(workInfoControllerProvider);

      salary = WorkRecordSumUtil.getTimeAndSalaryPerWorkInfo(
        workInfo.date!,
        workInfo.start!,
        workInfo.end!,
        workInfo.employee!,
      );
    }

    return TimeAndSalaryForEmployeeWidget(
      time: time,
      salary: salary,
    );
  }

  Widget getDateWidget() {
    return GestureDetector(
      onTap: () async {
        DateTime? date = await showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.88,
                child: Dialog(
                  insetPadding: EdgeInsets.zero,
                  surfaceTintColor: Colors.white,
                  child: SingelCalendarWidget(
                    selectedDate: ref.read(workInfoControllerProvider).date!,
                  ),
                ),
              ),
            );
          },
        );

        if (date != null) {
          ref.read(workInfoControllerProvider.notifier).changeDate(date);
        }
      },
      child: StandardSheetPartWidget.createStandardSheetPartWidgetWithStrValue(
        type: '날짜',
        value: FormatterUtil.getKoreanFormattedFullDate(
          ref.watch(workInfoControllerProvider).date!,
        ),
      ),
    );
  }

  Widget getStartTimeWidget() {
    return GestureDetector(
      child: StandardSheetPartWidget.createStandardSheetPartWidgetWithStrValue(
        type: '시작 시간',
        value: FormatterUtil.getKoreanFormattedTime(
          ref.read(workInfoControllerProvider).start!,
        ),
      ),
      onTap: () async {
        TimeOfDay? newTimeOfDay = await showCustomTimePicker(
          initialTime: ref.read(workInfoControllerProvider).start!,
        );

        if (newTimeOfDay == null) {
          return;
        }

        ref.read(workInfoControllerProvider.notifier).changeStart(
              newTimeOfDay.hour,
              newTimeOfDay.minute,
            );
      },
    );
  }

  Widget getEndTimeWidget() {
    return GestureDetector(
      child: StandardSheetPartWidget.createStandardSheetPartWidgetWithStrValue(
        type: '종료 시간',
        value: FormatterUtil.getKoreanFormattedTime(
          ref.read(workInfoControllerProvider).end!,
        ),
      ),
      onTap: () async {
        TimeOfDay? newTimeOfDay = await showCustomTimePicker(
          initialTime: ref.read(workInfoControllerProvider).end!,
        );

        if (newTimeOfDay == null) {
          return;
        }

        ref.read(workInfoControllerProvider.notifier).changeEnd(
              newTimeOfDay.hour,
              newTimeOfDay.minute,
            );
      },
    );
  }

  Future<TimeOfDay?> showCustomTimePicker({required DateTime initialTime}) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
                primary: AppColors.brand500, onSurface: AppColors.grey900),
            timePickerTheme: TimePickerThemeData(
              dayPeriodColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? AppColors.brand500
                      : AppColors.brand50),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Widget getEmployeeWidget() {
    if (ref.read(workInfoControllerProvider).employee == null) {
      return StandardSheetPartWidget(
        type: '직원',
        valueWidget: getNonSelectedWidgetForEmployee(),
      );
    }

    return StandardSheetPartWidget(
      type: '직원',
      valueWidget: getSelectedEmployeeWidget(),
    );
  }

  Widget getNonSelectedWidgetForEmployee() {
    return GestureDetector(
      onTap: () async {
        Employee? employee = await context.push(
          AppRoute.workRecordEmployeeSelect.path,
          extra: null,
        );

        if (employee != null) {
          ref
              .read(workInfoControllerProvider.notifier)
              .changeEmployee(employee);
        }
      },
      child: Text(
        '직원을 선택해주세요',
        style: AppTextTheme.md.medium.copyWith(
          color: AppColors.grey500,
        ),
      ),
    );
  }

  Widget getNonSelectedWidgetForRole() {
    return GestureDetector(
      onTap: () async {
        context.push(AppRoute.workRecordroleSelect.path);
      },
      child: Text(
        '역할을 선택해주세요',
        style: AppTextTheme.md.medium.copyWith(
          color: AppColors.grey500,
        ),
      ),
    );
  }

  Widget getSelectedEmployeeWidget() {
    Employee employee = ref.read(workInfoControllerProvider).employee!;

    return GestureDetector(
      onTap: () async {
        Employee? newEmployee = await context.push(
          AppRoute.workRecordEmployeeSelect.path,
          extra: employee.id,
        );

        if (newEmployee != null && employee.id != newEmployee.id) {
          ref
              .read(workInfoControllerProvider.notifier)
              .changeEmployee(newEmployee);
        }
      },
      child: WorkRecordSheetEmployeeWidget(
        name: employee.name,
      ),
    );
  }

  Widget getRoleWidget() {
    if (ref.read(workInfoControllerProvider).role == null) {
      return StandardSheetPartWidget(
        type: '역할',
        valueWidget: getNonSelectedWidgetForRole(),
      );
    }

    return GestureDetector(
      onTap: () {
        context.push(AppRoute.workRecordroleSelect.path);
      },
      child: StandardSheetPartWidget.createStandardSheetPartWidgetWithStrValue(
        type: '역할',
        value: ref.read(workInfoControllerProvider).role!,
      ),
    );
  }
}
