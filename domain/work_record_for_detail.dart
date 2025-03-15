import 'package:fitple/features/user/domain/employee.dart';
import 'package:fitple/features/work_record/domain/sum_for_time_and_salary.dart';
import 'package:fitple/features/work_record/domain/work_records_for_employee.dart';

class WorkRecordForDetail {
  DateTime date;
  Employee employee;
  WorkRecordForEmployee workRecordForEmployee;

  WorkRecordForDetail({
    required this.date,
    required this.employee,
    required this.workRecordForEmployee,
  });

  SumForTimeAndSalary calcualteTimeAndSalary() {
    return workRecordForEmployee.getSumForTimeAndSalary(
      employee,
      date,
    );
  }

  DateTime getStartDate() {
    return workRecordForEmployee.workInfos[0].startDate;
  }
}
