import 'package:aura/features/home/data/models/recent_doc_model.dart';

abstract class RecentUploadsState {}

class RecentUploadsInitial extends RecentUploadsState {}

class RecentUploadsLoaded extends RecentUploadsState {
  final List<RecentDocModel> docs;
  RecentUploadsLoaded(this.docs);
}

class RecentUploadsError extends RecentUploadsState {
  final String message;
  RecentUploadsError(this.message);
}
