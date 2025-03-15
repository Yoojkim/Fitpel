import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/features/user/domain/employee.dart';
import 'package:fitple/features/user/presentation/state/employee_controller.dart';
import 'package:fitple/features/work_record/domain/work_records_sum.dart';
import 'package:fitple/features/work_record/presentation/state/work_record_state.dart';
import 'package:fitple/features/work_record/presentation/state/controller/work_record_controller.dart';
import 'package:fitple/features/work_record/presentation/widgets/post_work_record_sheet/default_app_bar_with_records.dart';
import 'package:fitple/features/work_record/presentation/widgets/selected_date_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/work_records_sum_widget.dart';
import 'package:fitple/features/work_record/presentation/widgets/work_records_widget.dart';
import 'package:fitple/features/work_record/util/work_record_sum_util.dart';

//근무 기록 조회 스크린
class WorkRecordsScreen extends ConsumerStatefulWidget {
  const WorkRecordsScreen({super.key});

  @override
  ConsumerState<WorkRecordsScreen> createState() => _WorkRecordsScreenState();
}

class _WorkRecordsScreenState extends ConsumerState<WorkRecordsScreen> {
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(employeeListProvider);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    isScrolled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workRecordState = ref.watch(workRecordControllerProvider);
    final employeeState = ref.watch(employeeListProvider);

    if (workRecordState.isLoading || employeeState.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.grey25,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    WorkRecordState workRecord = workRecordState.value!;
    List<Employee> employees = employeeState.valueOrNull ?? [];

    WorkRecordsSum workRecordsSum = WorkRecordSumUtil.getWorkRecordsSum(
      workRecords: workRecord.workRecords,
      employees: employees,
    );

    return Scaffold(
      backgroundColor: AppColors.grey25,
      appBar: DefaultAppBarWithRecords(
        isScrolled: isScrolled,
        title: '근무 기록',
      ),
      body: Column(
        children: [
          getAppBarBottomWidget(
            workRecordsSum,
            workRecord,
          ),
          Expanded(
            child: WorkRecordsWidget(
              scrollController: scrollController,
              workRecordSumForDates: workRecordsSum.workRecordsSumForDates,
              selectedDate: workRecord.selectedDate,
            ),
          ),
        ],
      ),
    );
  }

  Widget getAppBarBottomWidget(
    WorkRecordsSum workRecordsSum,
    WorkRecordState workRecordState,
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
              SelectedDateWidget(
                selectedDate: workRecordState.selectedDate,
              ),
              const SizedBox(
                height: 12.0,
              ),
              WorkRecordSumWidget(
                workRecordsSumForAll: workRecordsSum.workRecordsSumForAll,
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
}
