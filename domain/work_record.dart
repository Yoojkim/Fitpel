import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:fitple/common/constants/json_functions.dart';
import 'package:fitple/features/work_record/domain/work_info.dart';

part 'work_record.freezed.dart';
part 'work_record.g.dart';

@freezed
class WorkRecord with _$WorkRecord {
  factory WorkRecord({
    required String id,
    @JsonKey(
        fromJson: JsonFunctions.timestampToDateTime,
        toJson: JsonFunctions.dateTimeToTimeStamp)
    required DateTime date,
    required List<WorkInfo> workInfos,
  }) = _WorkRecord;

  factory WorkRecord.create({
    required DateTime date,
    required List<WorkInfo> workInfos,
  }) {
    return WorkRecord(
      id: Uuid().v4(),
      date: date,
      workInfos: workInfos,
    );
  }

  factory WorkRecord.fromJson(Map<String, Object?> json) =>
      _$WorkRecordFromJson(json);

  //todo: add, update 메소드 따로 빼서 구현! *이 클래스는 immutable
}
