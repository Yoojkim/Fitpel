import 'package:fitple/features/work_record/domain/sum_for_time_and_salary.dart';
import 'package:fitple/features/work_record/domain/work_record_sum_for_date.dart';

class WorkRecordsSum {
  SumForTimeAndSalary workRecordsSumForAll;
  List<WorkRecordSumForDate> workRecordsSumForDates;

  WorkRecordsSum({
    required this.workRecordsSumForAll,
    required this.workRecordsSumForDates,
  });
}
