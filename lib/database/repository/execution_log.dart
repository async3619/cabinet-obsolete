import 'package:cabinet/database/execution_log.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';

class ExecutionLogRepository extends BaseRepository<ExecutionLog> {
  ExecutionLogRepository(Box<ExecutionLog> box) : super(box);

  Future<void> create(
    int startedAt,
    int finishedAt,
    int imageCount,
    int postCount,
    int watcherCount,
  ) async {
    final entity = ExecutionLog(
      startedAt: startedAt,
      finishedAt: finishedAt,
      imageCount: imageCount,
      postCount: postCount,
      watcherCount: watcherCount,
    );

    await box.putAsync(entity);
  }
}
