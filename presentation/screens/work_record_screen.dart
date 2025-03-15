//특정 날짜에 대한 근무 기록 화면
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/routes.dart';
import 'package:fitple/common/theme/app_theme.dart';
import 'package:fitple/features/user/domain/employee.dart';
import 'package:fitple/features/user/presentation/state/employee_controller.dart';
import 'package:fitple/features/work_record/domain/sum_for_time_and_salary.dart';
import 'package:fitple/features/work_record/domain/work_record.dart';
import 'package:fitple/features/work_record/domain/work_record_sum_for_date.dart';
import 'package:fitple/features/work_record/domain/work_records_for_employee.dart';
import 'package:fitple/features/work_record/presentation/state/controller/work_info_controller.dart';
import 'package:fitple/features/work_record/presentation/state/controller/work_record_controller.dart';
import 'package:fitple/features/work_record/presentation/widgets/name_icon_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/post_work_record_sheet/create_work_record_sheet.dart';
import 'package:fitple/features/work_record/presentation/widgets/post_work_record_sheet/default_app_bar_with_records.dart';
import 'package:fitple/features/work_record/presentation/widgets/work_date_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/work_records_sum_widget.dart';
import 'package:fitple/features/work_record/util/formatter_util.dart';
import 'package:fitple/features/work_record/util/work_record_sum_util.dart';

class WorkRecordScreen extends ConsumerStatefulWidget {
  DateTime selectedDate;
  WorkRecordScreen({
    super.key,
    required this.selectedDate,
  });

  @override
  ConsumerState<WorkRecordScreen> createState() => _WorkRecordScreenState();
}

class _WorkRecordScreenState extends ConsumerState<WorkRecordScreen> {
  ScrollController scrollController = ScrollController();
  ValueNotifier<bool> isScrolled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    scrollController.addListener(
      () {
        if (scrollController.offset > 0) {
          isScrolled.value = true;
        } else {
          isScrolled.value = false;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(workRecordControllerProvider);

    WorkRecord? workRecord = ref
        .read(
          workRecordControllerProvider.notifier,
        )
        .getWorkRecordForDateTime(
          widget.selectedDate,
        );

    WorkRecordSumForDate workRecordSumForDate;

    if (workRecord == null) {
      workRecordSumForDate = WorkRecordSumForDate.createEmptyWorkRecordsSum(
        widget.selectedDate,
      );
    } else {
      workRecordSumForDate = WorkRecordSumUtil.getWorkRecordSumForDate(
        workRecord: workRecord,
        employees: ref.watch(employeeListProvider).value!,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.grey25,
      appBar: DefaultAppBarWithRecords(
        isScrolled: isScrolled,
        title: '근무 상세 기록',
      ),
      body: Column(
        children: [
          getAppBarBottomWidget(
            workRecordSumForDate,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    getEmployeeCountWidget(workRecordSumForDate.employeeCount),
                    Column(
                      children: workRecordSumForDate.workRecordsForEmployees
                          .map(
                            (e) => Column(
                              children: [
                                const SizedBox(
                                  height: 16.0,
                                ),
                                WorkRecordForEmployeeWidget(
                                  workRecordForEmployee: e,
                                  date: widget.selectedDate,
                                )
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ref
              .read(workInfoControllerProvider.notifier)
              .setDate(widget.selectedDate);

          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return const CreateWorkRecordSheet();
            },
          );
        },
        shape: const CircleBorder(),
        backgroundColor: const Color(0xff13AB62),
        child: SvgPicture.asset('asset/icons/plus.svg'),
      ),
    );
  }

  Widget getAppBarBottomWidget(
    WorkRecordSumForDate workRecordSumForDate,
  ) {
    return AnimatedBuilder(
      animation: isScrolled,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: isScrolled.value ? AppColors.white : AppColors.grey25,
            border: isScrolled.value
                ? const Border(
                    bottom: BorderSide(
                      color: AppColors.grey200,
                      width: 1,
                    ),
                  )
                : null,
          ),
          child: Column(
            children: [
              WorkDateWidget(
                date: workRecordSumForDate.date,
              ),
              const SizedBox(
                height: 12.0,
              ),
              WorkRecordSumWidget(
                workRecordsSumForAll: SumForTimeAndSalary(
                  time: workRecordSumForDate.workingTime,
                  salary: workRecordSumForDate.salary,
                ),
              ),
              const SizedBox(
                height: 12.0,
              )
            ],
          ),
        );
      },
    );
  }

  Widget getEmployeeCountWidget(int cnt) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              height: 1.0,
              color: AppColors.grey200,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            '근무자 목록 ($cnt)',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: AppColors.grey400,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Container(
              height: 1.0,
              color: AppColors.grey200,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkRecordForEmployeeWidget extends ConsumerWidget {
  DateTime date;
  WorkRecordForEmployee workRecordForEmployee;
  WorkRecordForEmployeeWidget({
    super.key,
    required this.date,
    required this.workRecordForEmployee,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Employee employee = ref.read(employeeListProvider.notifier).getEmployeeById(
          workRecordForEmployee.employeeId,
        );

    return GestureDetector(
      onTap: () {
        context.push(
          AppRoute.workRecordForEmployee.path,
          extra: {
            'date': date.toString(),
            'employeeId': workRecordForEmployee.employeeId,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.only(
          top: 12.0,
          right: 8.0,
          bottom: 12.0,
          left: 16.0,
        ), //overflowed bottom
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: AppColors.grey200,
            )),
        child: Row(
          children: [
            getNameWidget(employee.name),
            const SizedBox(
              width: 16.0,
            ),
            getWorkInfoWidget(
              workRecordForEmployee.getSumForTimeAndSalary(
                employee,
                date,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getNameWidget(String name) {
    return Expanded(
      child: Row(
        children: [
          NameIconWidget(
            name: name,
            size: const Size(
              40.0,
              40.0,
            ),
            textStyle: AppTextTheme.md.medium,
          ),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            name,
            style: AppTextTheme.md.semiBold,
          )
        ],
      ),
    );
  }

  Widget getWorkInfoWidget(SumForTimeAndSalary sumForTimeAndSalary) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              FormatterUtil.getFormattedWageWithWon(sumForTimeAndSalary.salary),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              (sumForTimeAndSalary.time.min != 0)
                  ? '${sumForTimeAndSalary.time.hour}시간 ${sumForTimeAndSalary.time.min}분'
                  : '${sumForTimeAndSalary.time.hour}시간',
              style: AppTextTheme.sm.regular.copyWith(
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 16.0,
        ),
        SvgPicture.asset(
          'asset/icons/right_icon.svg',
          width: 20.0,
          height: 20.0,
          color: AppColors.grey300,
        ),
      ],
    );
  }
}
