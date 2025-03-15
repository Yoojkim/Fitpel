import 'dart:collection';

import 'package:fitple/common/constants/salary_units.dart';
import 'package:fitple/common/exceptions/app_exception.dart';
import 'package:fitple/features/user/domain/employee.dart';
import 'package:fitple/features/user/domain/salary.dart';
import 'package:fitple/features/work_record/domain/time.dart';
import 'package:fitple/features/work_record/domain/work_info.dart';
import 'package:fitple/features/work_record/domain/work_record.dart';
import 'package:fitple/features/work_record/domain/work_records_for_employee.dart';
import 'package:fitple/features/work_record/domain/work_records_sum.dart';
import 'package:fitple/features/work_record/domain/sum_for_time_and_salary.dart';
import 'package:fitple/features/work_record/domain/work_record_sum_for_date.dart';

class WorkRecordSumUtil {
  //workRecords 바탕으로 총 근무시간, 총 급여 반환
  //workRecords 바탕으로 특정 날짜에 따른 근무기록 정제 데이터 반환

  //workRecords 바탕으로 총 근무시간, 총 급여, 특정 날짜에 따른 근무기록 정제 데이터 반환 메소드
  static WorkRecordsSum getWorkRecordsSum({
    required List<WorkRecord> workRecords,
    required List<Employee> employees,
  }) {
    int minAllSum = 0; //총 근무시간
    int salaryAllSum = 0; //총 급여

    Map<String, Employee> employeeMap = HashMap.fromIterable(
      employees,
      key: (employee) => employee.id,
      value: (employee) => employee,
    );

    //근무기록 정제 데이터 리스트
    List<WorkRecordSumForDate> workRecordSumForDates = [];
    for (WorkRecord workRecord in workRecords) {
      //Employee Id, 특정 employee의 work infos
      HashMap<String, WorkRecordForEmployee> employeeAndWorkInfosMap =
          HashMap();

      for (WorkInfo workInfo in workRecord.workInfos) {
        if (!employeeMap.containsKey(workInfo.employeeId)) {
          continue;
        }

        WorkRecordForEmployee workRecordsForEmployee;
        if (employeeAndWorkInfosMap.containsKey(workInfo.employeeId)) {
          workRecordsForEmployee =
              employeeAndWorkInfosMap[workInfo.employeeId]!;
        } else {
          workRecordsForEmployee = WorkRecordForEmployee(
            employeeId: workInfo.employeeId,
          );
        }

        workRecordsForEmployee.workInfos.add(workInfo);
        employeeAndWorkInfosMap[workInfo.employeeId] = workRecordsForEmployee;
      }

      //특정 날짜에 대한 근무 시간, 직원 수,
      int minSumForDate = 0;
      int salarySumForDate = 0;
      //전체 map 계산
      for (WorkRecordForEmployee workRecordsForEmployee
          in employeeAndWorkInfosMap.values) {
        Employee employee = employeeMap[workRecordsForEmployee.employeeId]!;

        SumForTimeAndSalary sumForTimeAndSalary =
            workRecordsForEmployee.getSumForTimeAndSalary(
          employee,
          workRecord.date,
        );

        minSumForDate += sumForTimeAndSalary.time.getAllMin();
        salarySumForDate += sumForTimeAndSalary.salary;
      }

      workRecordSumForDates.add(
        WorkRecordSumForDate(
          date: workRecord.date,
          workingTime: Time.getTimeByTotalMinute(minSumForDate),
          employeeCount: employeeAndWorkInfosMap.length,
          salary: salarySumForDate,
          workRecordsForEmployees: employeeAndWorkInfosMap.values.toList(),
        ),
      );

      minAllSum += minSumForDate;
      salaryAllSum += salarySumForDate;
    }

    return WorkRecordsSum(
      workRecordsSumForAll: SumForTimeAndSalary(
        time: Time.getTimeByTotalMinute(minAllSum),
        salary: salaryAllSum,
      ),
      workRecordsSumForDates: workRecordSumForDates,
    );
  }

  static WorkRecordSumForDate getWorkRecordSumForDate({
    required WorkRecord workRecord,
    required List<Employee> employees,
  }) {
    Map<String, Employee> employeeMap = HashMap.fromIterable(
      employees,
      key: (employee) => employee.id,
      value: (employee) => employee,
    );
    HashMap<String, WorkRecordForEmployee> map = HashMap();

    for (WorkInfo workInfo in workRecord.workInfos) {
      if (!employeeMap.containsKey(workInfo.employeeId)) {
        continue;
      }

      WorkRecordForEmployee workRecordForEmployee;

      if (map.containsKey(workInfo.employeeId)) {
        workRecordForEmployee = map[workInfo.employeeId]!;
      } else {
        workRecordForEmployee = WorkRecordForEmployee(
          employeeId: workInfo.employeeId,
        );
      }

      workRecordForEmployee.workInfos.add(workInfo);
      map[workInfo.employeeId] = workRecordForEmployee;
    }

    int workingMinute = 0;
    int salary = 0;
    for (WorkRecordForEmployee workRecordForEmployee in map.values) {
      Employee employee = employeeMap[workRecordForEmployee.employeeId]!;
      SumForTimeAndSalary sumForTimeAndSalary =
          workRecordForEmployee.getSumForTimeAndSalary(
        employee,
        workRecord.date,
      );

      workingMinute += sumForTimeAndSalary.time.getAllMin();
      salary += sumForTimeAndSalary.salary;
    }

    return WorkRecordSumForDate(
      date: workRecord.date,
      workingTime: Time.getTimeByTotalMinute(workingMinute),
      employeeCount: map.length,
      salary: salary,
      workRecordsForEmployees: map.values.toList(),
    );
  }

  static int getTimeAndSalaryPerWorkInfo(
    DateTime date,
    DateTime start,
    DateTime end,
    Employee employee,
  ) {
    int minutes = end.difference(start).inMinutes;

    return getSalaryForTime(
      getProfitSalary(employee, date),
      Time.getTimeByTotalMinute(minutes),
    );
  }

  //todo: 추후 계산 로직 수정
  static int getSalaryForTime(Salary salary, Time time) {
    if (salary.type == SalaryMethod.hourly) {
      return time.hour * salary.wage + (time.min * (salary.wage / 60)).ceil();
    }

    //todo: 일급/주급 추후 계산 로직 구현 예정
    //일급
    if (salary.type == SalaryMethod.daily) {
      return ((time.hour * salary.wage / SalaryUnits.standardHoursPerDay) +
              (time.min * salary.wage / SalaryUnits.standardMinutesPerDay))
          .ceil();
    }

    //주급
    if (salary.type == SalaryMethod.weekly) {
      return ((time.hour * salary.wage / SalaryUnits.standardHoursPerWeek) +
              (time.min * salary.wage / SalaryUnits.standardMinutesPerWeek))
          .ceil();
    }

    //월급
    return ((time.hour * salary.wage / SalaryUnits.standardHoursPerMonth) +
            (time.min * salary.wage / SalaryUnits.standardMinutesPerMonth))
        .ceil();
  }

  static int getThisMonthDays() {
    DateTime today = DateTime.now();
    return DateTime(today.year, today.month + 1, 1)
        .subtract(const Duration(days: 1))
        .day;
  }

  static Salary getProfitSalary(Employee employee, DateTime date) {
    if (employee.salaries.isEmpty) {
      return Salary(
        id: '1',
        type: SalaryMethod.hourly,
        wage: 0,
        startDate: DateTime(1900, 1, 1, 0, 0),
      );
    }

    //내림차순으로 정렬(최신 순)
    List<Salary> salaries = List.from(employee.salaries);
    salaries.sort(
      (a, b) => b.startDate.compareTo(a.startDate),
    );

    for (Salary salary in salaries) {
      if (salary.startDate.isBefore(date) ||
          salary.startDate.isAtSameMomentAs(date)) {
        return salary;
      }
    }

    //급여 중 제일 처음 것도 날짜보다 늦는 경우 <- 해당하는 급여가 존재하지 않음
    return salaries.last; //그 중 제일 가까운 것으로 반영

    //todo: Exception 처리
    throw SalaryNotFoundException();
  }
}
