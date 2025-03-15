import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fitple/features/user/domain/employee.dart';

part 'work_info_state.freezed.dart';

@freezed
class WorkInfoState with _$WorkInfoState {
  factory WorkInfoState({
    String? workInfoId,
    DateTime? date,
    DateTime? start,
    DateTime? end,
    Employee? employee,
    String? role,
  }) = _WorkInfoState;
}
