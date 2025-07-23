import 'package:aura/features/home/data/models/doc_model.dart';

import '../../../data/models/recent_doc_model.dart';

abstract class RecentUploadsState {}

class RecentUploadsInitial extends RecentUploadsState {}

class RecentUploadsLoading extends RecentUploadsState {}

class RecentUploadsLoaded extends RecentUploadsState {
  final List<Data> docs;
  final List<RecentDocModel> cacheDocs;
  final String? nextCursor;

  RecentUploadsLoaded(this.docs, this.cacheDocs, this.nextCursor);
}

class UploadDocLoaded extends RecentUploadsState {}

class RecentUploadsError extends RecentUploadsState {
  final String message;
  RecentUploadsError(this.message);
}
