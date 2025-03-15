import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/theme/app_theme.dart';
import 'package:fitple/features/user/domain/employee.dart';
import 'package:fitple/features/user/presentation/state/employee_controller.dart';
import 'package:fitple/features/work_record/domain/sum_for_time_and_salary.dart';
import 'package:fitple/features/work_record/domain/time.dart';
import 'package:fitple/features/work_record/domain/work_info.dart';
import 'package:fitple/features/work_record/domain/work_record.dart';
import 'package:fitple/features/work_record/domain/work_record_for_detail.dart';
import 'package:fitple/features/work_record/domain/work_records_for_employee.dart';
import 'package:fitple/features/work_record/presentation/state/controller/work_info_controller.dart';
import 'package:fitple/features/work_record/presentation/state/controller/work_record_controller.dart';
import 'package:fitple/features/work_record/presentation/state/work_record_state.dart';
import 'package:fitple/features/work_record/presentation/widgets/name_icon_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/post_work_record_sheet/create_work_record_sheet.dart';
import 'package:fitple/features/work_record/presentation/widgets/post_work_record_sheet/update_work_record_sheet.dart';
import 'package:fitple/features/work_record/util/formatter_util.dart';
import 'package:fitple/features/work_record/util/weekday_extension.dart';

//특정 날짜에 대한 특정 사용자 근무 기록 스크린
class WorkRecordForEmployeeScreen extends ConsumerWidget {
  DateTime date;
  String employeeId;

  WorkRecordForEmployeeScreen({
    super.key,
    required this.date,
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WorkRecordState workRecord = ref.watch(workRecordControllerProvider).value!;
    ref.watch(employeeListProvider);

    WorkRecordForDetail workRecordForDetail = getWorkRecordForDetail(
      workRecord: ref
          .read(workRecordControllerProvider.notifier)
          .getWorkRecordForDateTime(date),
      employee:
          ref.read(employeeListProvider.notifier).getEmployeeById(employeeId),
    );

    return Scaffold(
      backgroundColor: AppColors.grey25,
      appBar: getAppBar(
        date,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    EmployeeWidget(
                      employee: workRecordForDetail.employee,
                    ),
                    const SizedBox(
                      height: 36.0,
                    ),
                    WorkInfosWidget(
                      workInfos:
                          workRecordForDetail.workRecordForEmployee.workInfos,
                      date: date,
                      employee: ref
                          .read(employeeListProvider.notifier)
                          .getEmployeeById(employeeId),
                    ),
                    const SizedBox(
                      height: 36.0,
                    ),
                    WorkInfosSumWidget(
                      sumForTimeAndSalary:
                          workRecordForDetail.calcualteTimeAndSalary(),
                    ),
                  ],
                ),
              ),
            ),
            AddForDateWidget(
              date: date,
              employee: ref
                  .read(employeeListProvider.notifier)
                  .getEmployeeById(employeeId),
            ),
          ],
        ),
      ),
    );
  }

  WorkRecordForDetail getWorkRecordForDetail({
    required WorkRecord? workRecord,
    required Employee employee,
  }) {
    if (workRecord == null) {
      return WorkRecordForDetail(
        date: date,
        employee: employee,
        workRecordForEmployee: WorkRecordForEmployee(
          employeeId: employeeId,
        ),
      );
    }

    WorkRecordForEmployee workRecordForEmployee = WorkRecordForEmployee(
      employeeId: employeeId,
    );

    for (WorkInfo workInfo in workRecord.workInfos) {
      if (workInfo.employeeId == employeeId) {
        workRecordForEmployee.addWorkInfo(workInfo);
      }
    }

    return WorkRecordForDetail(
      date: date,
      employee: employee,
      workRecordForEmployee: workRecordForEmployee,
    );
  }

  AppBar getAppBar(DateTime date) {
    return AppBar(
      backgroundColor: AppColors.grey25,
      scrolledUnderElevation: 0,
      title: Text(
        '${date.month}월 ${date.day}일, ${date.getKoreanWeekDay()}요일',
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: Color(0xff475467),
        ),
      ),
    );
  }
}

class AddForDateWidget extends ConsumerStatefulWidget {
  DateTime date;
  Employee employee;

  AddForDateWidget({
    super.key,
    required this.date,
    required this.employee,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      AddForDateWidgetState();
}

class AddForDateWidgetState extends ConsumerState<AddForDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GestureDetector(
        onTap: () {
          ref.watch(employeeListProvider);

          ref.read(workInfoControllerProvider.notifier).setDateAndEmployee(
                widget.date,
                widget.employee,
              );

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return const CreateWorkRecordSheet();
            },
          );
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            color: const Color(0xff13AB62),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Text(
            '이 날짜에 추가하기',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}

class WorkInfosSumWidget extends StatelessWidget {
  SumForTimeAndSalary sumForTimeAndSalary;
  WorkInfosSumWidget({
    super.key,
    required this.sumForTimeAndSalary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '총 근무',
            style: AppTextTheme.md.semiBold.copyWith(
              color: AppColors.grey900,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          getTimeAndSalaryWidget(),
        ],
      ),
    );
  }

  Widget getTimeAndSalaryWidget() {
    return Container(
      padding: const EdgeInsets.all(
        16.0,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF2F4F7),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: getSumStandardWidget(
              '근무 시간',
              FormatterUtil.getFormattedTimeWithColon(sumForTimeAndSalary.time),
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: getSumStandardWidget(
              '급여',
              FormatterUtil.getFormattedWageWithWon(sumForTimeAndSalary.salary),
            ),
          ),
        ],
      ),
    );
  }

  Widget getSumStandardWidget(String type, String amount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          type,
          style: AppTextTheme.sm.regular.copyWith(
            color: AppColors.grey700,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          amount,
          style: AppTextTheme.lg.semiBold.copyWith(
            color: AppColors.grey700,
          ),
        ),
      ],
    );
  }
}

class WorkInfosWidget extends StatelessWidget {
  Employee employee;
  DateTime date;
  List<WorkInfo> workInfos;
  WorkInfosWidget({
    super.key,
    required this.employee,
    required this.date,
    required this.workInfos,
  });

  @override
  Widget build(BuildContext context) {
    if (workInfos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '근무 목록',
            style: AppTextTheme.md.semiBold.copyWith(
              color: AppColors.grey900,
            ),
          ),
          Column(
            children: workInfos
                .map(
                  (e) => Column(
                    children: [
                      const SizedBox(
                        height: 12.0,
                      ),
                      WorkInfoWidget(
                        workInfo: e,
                        date: date,
                        employee: employee,
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class WorkInfoWidget extends ConsumerWidget {
  WorkInfo workInfo;
  DateTime date;
  Employee employee;

  WorkInfoWidget({
    super.key,
    required this.workInfo,
    required this.employee,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(workInfoControllerProvider.notifier).setWorkInfo(
              date: date,
              employee: employee,
              workInfo: workInfo,
            );

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return const UpdateWorkRecordSheet();
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 16.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(8),
          border: Border.all(
            color: const Color(0xffE4E7EC),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: getTimeStandardWidget(
                '시작',
                FormatterUtil.getKoreanFormattedTime(
                  workInfo.startDate,
                ),
              ),
            ),
            Expanded(
              child: getTimeStandardWidget(
                '종료',
                FormatterUtil.getKoreanFormattedTime(
                  workInfo.endDate,
                ),
              ),
            ),
            Expanded(
              child: getTimeStandardWidget(
                '근무 시간',
                getFormattedWorkingTime(
                  workInfo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTimeStandardWidget(String type, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          type,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: Color(0xff475467),
          ),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Text(
          time,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Color(0xff101828),
          ),
        ),
      ],
    );
  }

  String getFormattedWorkingTime(WorkInfo workInfo) {
    int workingMinute =
        workInfo.endDate.difference(workInfo.startDate).inMinutes;

    Time time = Time.getTimeByTotalMinute(workingMinute);

    return FormatterUtil.getFormattedTimeWithColon(time);
  }

  String getFormattedTime(DateTime date) {
    Time time = Time(hour: date.hour, min: date.minute);

    String res = '';
    if (time.hour < 12) {
      res += '오전 ';
    } else {
      res += '오후 ';

      time = Time(hour: time.hour - 12, min: time.min);
    }

    res += FormatterUtil.getFormattedTimeWithColon(time);

    return res;
  }
}

class EmployeeWidget extends StatelessWidget {
  Employee employee;
  EmployeeWidget({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: AppColors.grey200,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          NameIconWidget(
            name: employee.name,
            size: const Size(
              48.0,
              48.0,
            ),
            textStyle: AppTextTheme.lg.medium,
          ),
          const SizedBox(
            width: 12.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey700,
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'asset/icons/phone.svg',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    employee.phone == null
                        ? "전화번호 없음"
                        : getFormattedPhoneNumber(employee.phone!),
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey700,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  String getFormattedPhoneNumber(String phone) {
    //todo: 유효성 검사 로직 추가되면 사용 예정

    // String res = '';

    // res += phone.substring(0, 3);
    // res += '-';
    // res += phone.substring(3, 7);
    // res += '-';
    // res += phone.substring(7);

    return phone;
  }
}
