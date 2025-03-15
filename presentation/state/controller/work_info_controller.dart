import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitple/common/exceptions/app_exception.dart';
import 'package:fitple/features/user/domain/employee.dart';
import 'package:fitple/features/work_record/data/work_record_repository.dart';
import 'package:fitple/features/work_record/domain/time.dart';
import 'package:fitple/features/work_record/domain/work_info.dart';
import 'package:fitple/features/work_record/domain/work_record.dart';
import 'package:fitple/features/work_record/presentation/state/repository/work_record_repository_provider.dart';
import 'package:fitple/features/work_record/presentation/state/work_info_state.dart';
import 'package:fitple/features/work_record/presentation/state/controller/work_record_controller.dart';

//autoDispose 적용하면 Null Exception
final workInfoControllerProvider =
    StateNotifierProvider<WorkInfoController, WorkInfoState>(
  (ref) {
    return WorkInfoController(
      workRecordRepository: ref.read(workRecordRepositoryProvider),
      workRecordStateNotifier: ref.read(workRecordControllerProvider.notifier),
    );
  },
);

class WorkInfoController extends StateNotifier<WorkInfoState> {
  WorkRecordRepository workRecordRepository;
  WorkRecordController workRecordStateNotifier;

  WorkInfoController({
    required this.workRecordRepository,
    required this.workRecordStateNotifier,
  }) : super(WorkInfoState());

  void setDate(DateTime newDate) {
    state = state.copyWith(
      date: newDate,
      start: DateTime(newDate.year, newDate.month, newDate.day, 9),
      end: DateTime(newDate.year, newDate.month, newDate.day, 17),
      employee: null,
      role: null,
    );
  }

  void setDateAndEmployee(DateTime newDate, Employee employee) {
    state = state.copyWith(
      date: newDate,
      start: DateTime(newDate.year, newDate.month, newDate.day, 9),
      end: DateTime(newDate.year, newDate.month, newDate.day, 17),
      employee: employee,
      role: employee.role,
    );
  }

  void setDatesAndEmployeeAndRole(
      DateTime start, DateTime end, Employee employee, String? role) {
    state = state.copyWith(
      date: start.copyWith(
        hour: 0,
        minute: 0,
      ),
      start: start,
      end: end,
      employee: employee,
      role: role,
    );
  }

  void setDateAndEmployeeAndRole(
      DateTime date, Employee employee, String? role) {
    state = state.copyWith(
      date: date,
      start: DateTime(date.year, date.month, date.day, 9),
      end: DateTime(date.year, date.month, date.day, 17),
      employee: employee,
      role: role,
    );
  }

  void setWorkInfo({
    required DateTime date,
    required Employee employee,
    required WorkInfo workInfo,
  }) {
    state = state.copyWith(
      workInfoId: workInfo.id,
      date: date,
      start: workInfo.startDate,
      end: workInfo.endDate,
      employee: employee,
      role: workInfo.role,
    );
  }

  void changeDate(DateTime date) {
    state = state.copyWith(
      date: date,
    );
  }

  void changeStart(int newHour, int newMin) {
    state = state.copyWith(
      start: state.date!.copyWith(
        hour: newHour,
        minute: newMin,
      ),
      end: state.date!.copyWith(
        hour: state.end!.hour,
        minute: state.end!.minute,
      ),
    );

    if (!isEndDateLater()) {
      changeEndDateToTomorrow();
    }
  }

  void changeEnd(int newHour, int newMin) {
    state = state.copyWith(
      end: state.date!.copyWith(
        hour: newHour,
        minute: newMin,
      ),
      start: state.date!.copyWith(
        hour: state.start!.hour,
        minute: state.start!.minute,
      ),
    );

    if (!isEndDateLater()) {
      changeEndDateToTomorrow();
    }
  }

  void changeEmployee(Employee? newEmoloyee) {
    state = state.copyWith(
      employee: newEmoloyee,
      role: newEmoloyee?.role,
    );
  }

  void changeRole(String? newRole) {
    state = state.copyWith(
      role: newRole,
    );
  }

  Time getTimeDifference() {
    //todo: 예외처리
    return Time.getTimeByTotalMinute(
      state.end!.difference(state.start!).inMinutes,
    );
  }

  bool canTriggeredButton() {
    return state.date != null &&
        state.start != null &&
        state.end != null &&
        state.employee != null &&
        state.role != null;
  }

  bool canCalculateSalary() {
    return state.date != null &&
        state.start != null &&
        state.end != null &&
        state.employee != null;
  }

  void addWorkInfo() async {
    WorkInfo workInfo = WorkInfo.create(
      state.employee!.id,
      state.start!,
      state.end!,
      state.role,
    );

    WorkRecord? workRecord = await getWorkRecord(state.date!);

    if (workRecord == null) {
      workRecord = WorkRecord.create(
        date: state.date!,
        workInfos: [workInfo],
      );

      workRecordRepository.addWorkRecord(workRecord);
    } else {
      workRecord = workRecord.copyWith(
        workInfos: [...workRecord.workInfos, workInfo],
      );

      workRecordRepository.updateWorkInfo(workRecord);
    }

    if (workRecordStateNotifier.isDateBetweenSelectedDate(state.date!)) {
      workRecordStateNotifier.updateWorkRecordForLocal(workRecord);
    }
  }

  void updateWorkInfo() async {
    WorkRecord? workRecord = await getWorkRecord(state.date!);

    WorkInfo workInfo = WorkInfo(
      id: state.workInfoId!,
      employeeId: state.employee!.id,
      startDate: state.start!,
      endDate: state.end!,
      role: state.role,
    );

    if (workRecord == null) {
      workRecord = WorkRecord.create(
        date: state.date!,
        workInfos: [workInfo],
      );

      workRecordRepository.addWorkRecord(workRecord);
    } else {
      List<WorkInfo> workInfos = workRecord.workInfos;
      workInfos = workInfos.map((e) {
        if (e.id == workInfo.id) {
          return workInfo;
        }

        return e;
      }).toList();

      workRecord = workRecord.copyWith(
        workInfos: workInfos,
      );

      workRecordRepository.updateWorkInfo(workRecord);
    }

    if (workRecordStateNotifier.isDateBetweenSelectedDate(state.date!)) {
      workRecordStateNotifier.updateWorkRecordForLocal(workRecord);
    }
  }

  void deleteWorkInfo() async {
    WorkRecord? workRecord = await getWorkRecord(state.date!);

    if (workRecord == null) {
      throw NotFoundWorkRecord();
    }

    List<WorkInfo> newWorkInfos = [];
    for (WorkInfo workInfo in workRecord.workInfos) {
      if (workInfo.id != state.workInfoId) {
        newWorkInfos.add(workInfo);
      }
    }

    workRecord = workRecord.copyWith(
      workInfos: newWorkInfos,
    );

    workRecordRepository.updateWorkInfo(workRecord);

    if (workRecordStateNotifier.isDateBetweenSelectedDate(state.date!)) {
      workRecordStateNotifier.updateWorkRecordForLocal(workRecord);
    }
  }

  Future<WorkRecord?> getWorkRecord(DateTime date) async {
    if (workRecordStateNotifier.isDateBetweenSelectedDate(date)) {
      return workRecordStateNotifier.getWorkRecordForDateTime(date);
    }

    return await workRecordRepository.getWorkRecordForDate(date);
  }

  bool isEndDateLater() {
    return state.end!.isAfter(state.start!) ||
        state.end!.isAtSameMomentAs(state.start!);
  }

  void changeEndDateToTomorrow() {
    state = state.copyWith(
      end: DateTime(state.end!.year, state.end!.month, state.end!.day + 1,
          state.end!.hour, state.end!.minute),
    );
  }
}
