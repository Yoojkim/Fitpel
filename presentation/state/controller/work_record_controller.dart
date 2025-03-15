import 'dart:async';
import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitple/features/work_record/data/work_record_repository.dart';
import 'package:fitple/features/work_record/domain/selected_data.dart';
import 'package:fitple/features/work_record/domain/work_record.dart';
import 'package:fitple/features/work_record/presentation/state/repository/work_record_repository_provider.dart';
import 'package:fitple/features/work_record/presentation/state/work_record_state.dart';

final workRecordControllerProvider =
    AsyncNotifierProvider<WorkRecordController, WorkRecordState>(
  () {
    return WorkRecordController();
  },
);

class WorkRecordController extends AsyncNotifier<WorkRecordState> {
  late WorkRecordRepository workRecordRepository;

  WorkRecordController();

  @override
  FutureOr<WorkRecordState> build() async {
    workRecordRepository = ref.read(workRecordRepositoryProvider);

    SelectedDate selectedDate = SelectedDate.initSelectedDate();
    List<WorkRecord> workRecords = await fetchRecords(
      selectedDate.startDate,
      selectedDate.endDate,
    );

    return WorkRecordState(
      selectedDate: selectedDate,
      workRecords: workRecords,
    );
  }

  WorkRecord? getWorkRecordForDateTime(DateTime date) {
    return state.value!.workRecords.where((e) => e.date == date).firstOrNull;
  }

  void changeSelectedDate(SelectedDate selectedDate) async {
    if (state.value!.selectedDate == selectedDate) {
      return;
    }

    state = const AsyncValue.loading();
    try {
      final workRecords = await fetchRecords(
        selectedDate.startDate,
        selectedDate.endDate,
      );

      state = AsyncValue.data(
        WorkRecordState(
          selectedDate: selectedDate,
          workRecords: workRecords,
        ),
      );
    } catch (e) {
      //todo: Log 처리
      state = AsyncValue.data(
        WorkRecordState(
          selectedDate: selectedDate,
          workRecords: [],
        ),
      );
    }
  }

  Future<List<WorkRecord>> fetchRecords(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await workRecordRepository.fetch(
      startDate,
      endDate,
    );
  }

  bool isDateBetweenSelectedDate(DateTime date) {
    return state.value!.selectedDate.isDateBetweenSelectedDate(date);
  }

  bool hasWorkRecordForDate(DateTime date) {
    return state.value!.workRecords.any((e) => e.date == date);
  }

  void updateWorkRecordForLocal(WorkRecord workRecord) {
    if (hasWorkRecordForDate(workRecord.date)) {
      List<WorkRecord> workRecords = state.value!.workRecords.map((e) {
        return e.date == workRecord.date ? workRecord : e;
      }).toList();

      state = AsyncValue.data(
        state.value!.copyWith(
          workRecords: workRecords,
        ),
      );

      return;
    }

    List<WorkRecord> workRecords = state.value!.workRecords;
    workRecords.add(workRecord);

    state = AsyncValue.data(
      state.value!.copyWith(
        workRecords: workRecords,
      ),
    );
  }
}
