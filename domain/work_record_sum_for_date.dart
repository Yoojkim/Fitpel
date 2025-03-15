import 'package:fitple/features/work_record/domain/time.dart';
import 'package:fitple/features/work_record/domain/work_records_for_employee.dart';

class WorkRecordSumForDate {
  DateTime date;
  Time workingTime;
  int employeeCount;
  int salary;
  List<WorkRecordForEmployee> workRecordsForEmployees;

  WorkRecordSumForDate({
    required this.date,
    required this.workingTime,
    required this.employeeCount,
    required this.salary,
    required this.workRecordsForEmployees,
  });

  static WorkRecordSumForDate createEmptyWorkRecordsSum(DateTime date) {
    return WorkRecordSumForDate(
      date: date,
      workingTime: Time(hour: 0, min: 0),
      employeeCount: 0,
      salary: 0,
      workRecordsForEmployees: [],
    );
  }
}
