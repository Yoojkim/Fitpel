import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitple/common/data/firebase/firestore_collections.dart';
import 'package:fitple/common/exceptions/app_exception.dart';
import 'package:fitple/features/work_record/domain/work_record.dart';

class WorkRecordRepository {
  final CollectionRef _collection;

  WorkRecordRepository({
    required CollectionRef collection,
  }) : _collection = collection;

  void updateWorkInfo(WorkRecord workRecord) async {
    try {
      await _collection.doc(workRecord.id).set(workRecord.toJson());
    } catch (e) {
      throw FirestoreUploadException();
    }
  }

  void addWorkRecord(WorkRecord workRecord) async {
    try {
      await _collection.doc(workRecord.id).set(workRecord.toJson());
    } catch (e) {
      throw FirestoreUploadException();
    }
  }

  Future<List<WorkRecord>> fetch(DateTime startDate, DateTime endDate) async {
    QuerySnapshot snapshot = await _collection
        .where(
          "date",
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where(
          "date",
          isLessThanOrEqualTo: Timestamp.fromDate(endDate),
        )
        .get();

    List<WorkRecord> workRecords = snapshot.docs
        .map((e) => WorkRecord.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    return workRecords;
  }

  Future<WorkRecord?> getWorkRecordForDate(DateTime date) async {
    QuerySnapshot snapshot = await _collection
        .where(
          "date",
          isEqualTo: Timestamp.fromDate(date),
        )
        .get();

    if (snapshot.docs.length > 1) {
      throw WorkRecordNotSinlgeDateException();
    }

    if (snapshot.docs.length == 1) {
      return WorkRecord.fromJson(
          snapshot.docs[0].data() as Map<String, dynamic>);
    }

    return null;
  }
}
