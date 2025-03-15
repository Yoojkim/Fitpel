import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitple/common/data/firebase/firestore_collections.dart';
import 'package:fitple/features/work_record/data/work_record_repository.dart';

final workRecordRepositoryProvider = Provider<WorkRecordRepository>(
  (ref) {
    return WorkRecordRepository(
      collection: ref.watch(firestoreCollectionsProvider).workRecord,
    );
  },
);
