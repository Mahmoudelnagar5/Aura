import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

import '../../../data/models/summary_model.dart';
import 'summary_card.dart';
import 'package:easy_localization/easy_localization.dart';

class ListViewSummaries extends StatelessWidget {
  final List<Summary> summaries;
  final void Function(Summary summary) onDelete;
  const ListViewSummaries(
      {super.key, required this.summaries, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: summaries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final summary = summaries[index];
        return SwipeActionCell(
          backgroundColor: Colors.transparent,
          key: ValueKey(summary.docName + summary.uploadDate),
          trailingActions: [
            SwipeAction(
              title: "delete".tr(),
              color: Colors.red,
              icon: const Icon(Icons.delete, color: Colors.white),
              onTap: (handler) async {
                onDelete(summary);
                handler(false);
              },
            ),
          ],
          child: SummaryCard(summary: summary),
        );
      },
    );
  }
}
