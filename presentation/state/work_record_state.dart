import 'package:fitple/features/work_record/domain/selected_data.dart';
import 'package:fitple/features/work_record/domain/work_record.dart';

class WorkRecordState {
  SelectedDate selectedDate;
  List<WorkRecord> workRecords;

  WorkRecordState({
    required this.selectedDate,
    required this.workRecords,
  });

  static WorkRecordState initWorkRecordState() {
    return WorkRecordState(
      selectedDate: SelectedDate.initSelectedDate(),
      workRecords: [],
    );
  }

  WorkRecordState copyWith({
    SelectedDate? selectedDate,
    List<WorkRecord>? workRecords,
  }) {
    return WorkRecordState(
      selectedDate: selectedDate ?? this.selectedDate,
      workRecords: workRecords ?? this.workRecords,
    );
  }
}
