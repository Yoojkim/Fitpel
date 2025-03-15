import 'package:fitple/features/user/domain/employee.dart';
import 'package:fitple/features/user/domain/salary.dart';
import 'package:fitple/features/work_record/domain/sum_for_time_and_salary.dart';
import 'package:fitple/features/work_record/domain/time.dart';
import 'package:fitple/features/work_record/domain/work_info.dart';
import 'package:fitple/features/work_record/util/work_record_sum_util.dart';

//특정 날짜에 한정한 특정 근무자 근무기록 모음
class WorkRecordForEmployee {
  String employeeId;
  List<WorkInfo> workInfos = [];

  WorkRecordForEmployee({
    required this.employeeId,
  });

//현재 workInfos 바탕으로 전체 시간과 시급 반환
  SumForTimeAndSalary getSumForTimeAndSalary(Employee employee, DateTime date) {
    final totalMinutes = workInfos.fold(
      0,
      (prev, e) => prev + e.endDate.difference(e.startDate).inMinutes,
    );
    Salary salary = getProfitSalary(employee, date);
    Time time = Time.getTimeByTotalMinute(totalMinutes);

    return SumForTimeAndSalary(
      time: time,
      salary: getSalaryForWorkInfo(salary, time),
    );
  }

  Salary getProfitSalary(Employee employee, DateTime date) {
    return WorkRecordSumUtil.getProfitSalary(employee, date);
  }

  //todo: 일급, 주급 기준 수정
  int getSalaryForWorkInfo(Salary salary, Time time) {
    return WorkRecordSumUtil.getSalaryForTime(salary, time);
  }

  int getThisMonthDays() {
    DateTime today = DateTime.now();
    return DateTime(today.year, today.month + 1, 1)
        .subtract(const Duration(days: 1))
        .day;
  }

  void addWorkInfo(WorkInfo workInfo) {
    validateEmployee(workInfo.employeeId);

    workInfos.add(workInfo);
  }

  void validateEmployee(String employeeId) {
    if (employeeId != this.employeeId) {
      //todo: 에러처리
      throw Exception();
    }
  }
}
