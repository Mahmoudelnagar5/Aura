import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura/core/helpers/database/docs_cache_helper.dart';
import 'package:aura/features/home/data/models/recent_doc_model.dart';

import 'recent_uploads_state.dart';

class RecentUploadsCubit extends Cubit<RecentUploadsState> {
  RecentUploadsCubit() : super(RecentUploadsInitial());

  void loadRecentUploads() {
    final docs = DocsCacheHelper.getDocs();
    emit(RecentUploadsLoaded(docs));
  }

  Future<void> addRecentUpload(RecentDocModel doc) async {
    await DocsCacheHelper.addDoc(doc);
    loadRecentUploads();
  }

  Future<void> clearRecentUploads() async {
    await DocsCacheHelper.clearDocs();
    loadRecentUploads();
  }
}
