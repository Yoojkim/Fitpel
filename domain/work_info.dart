import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:fitple/common/constants/json_functions.dart';

part 'work_info.freezed.dart';
part 'work_info.g.dart';

@freezed
class WorkInfo with _$WorkInfo {
  factory WorkInfo({
    required String id,
    required String employeeId,
    @JsonKey(
        fromJson: JsonFunctions.timestampToDateTime,
        toJson: JsonFunctions.dateTimeToTimeStamp)
    required DateTime startDate,
    @JsonKey(
        fromJson: JsonFunctions.timestampToDateTime,
        toJson: JsonFunctions.dateTimeToTimeStamp)
    required DateTime endDate,
    String? role,
  }) = _WorkInfo;

  factory WorkInfo.create(
    String employeeId,
    DateTime startDate,
    DateTime endDate,
    String? role,
  ) {
    return WorkInfo(
      id: Uuid().v4(),
      employeeId: employeeId,
      startDate: startDate,
      endDate: endDate,
      role: role,
    );
  }

  factory WorkInfo.fromJson(Map<String, Object?> json) =>
      _$WorkInfoFromJson(json);
}
