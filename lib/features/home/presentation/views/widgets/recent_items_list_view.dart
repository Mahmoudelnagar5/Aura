import 'package:flutter/material.dart';
import 'recent_item.dart';

class RecentItemsListView extends StatelessWidget {
  const RecentItemsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: const RecentItem(),
      ),
      itemCount: 5,
    );
  }
}
