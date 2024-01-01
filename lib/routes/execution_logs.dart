import 'package:cabinet/database/execution_log.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/utils/formatDuration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ExecutionLogsRoute extends StatefulWidget {
  const ExecutionLogsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ExecutionLogsRoute> createState() => _ExecutionLogsRouteState();
}

class _ExecutionLogsRouteState extends State<ExecutionLogsRoute> {
  ResponsiveGridCol buildSpacing() {
    return ResponsiveGridCol(
      xs: 12,
      child: const SizedBox(height: 12),
    );
  }

  ResponsiveGridCol buildItem(String title, String content, {int? xs}) {
    xs ??= 6;

    return ResponsiveGridCol(
        xs: xs,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(content, style: Theme.of(context).textTheme.bodySmall),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final holder = Provider.of<RepositoryHolder>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Execution Logs'),
        ),
        body: FutureBuilder(
          future: holder.executionLog
              .findAll()
              .then((list) => list.reversed.toList()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final logs = snapshot.data as List<ExecutionLog>;

              return ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final startedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(
                      DateTime.fromMillisecondsSinceEpoch(log.startedAt!));

                  final finishedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(
                      DateTime.fromMillisecondsSinceEpoch(log.finishedAt!));

                  final executionTime = formatDuration(log.executionTime);

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Execution #${log.id}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          ResponsiveGridRow(
                            children: [
                              buildItem('New Posts',
                                  log.postCount?.toString() ?? '0'),
                              buildItem('New Images',
                                  log.imageCount?.toString() ?? '0'),
                              buildSpacing(),
                              buildItem('Execution Time', executionTime),
                              buildSpacing(),
                              buildItem('Started At', startedTime),
                              buildItem('Finished At', finishedTime),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
