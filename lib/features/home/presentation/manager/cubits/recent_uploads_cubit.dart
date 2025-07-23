import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura/features/home/data/repos/uploads_repo.dart';
import '../../../../../core/helpers/database/docs_cache_helper.dart';
import '../../../data/models/recent_doc_model.dart';
import '../../../data/models/doc_model.dart';
import 'recent_uploads_state.dart';
import 'dart:io';

class RecentUploadsCubit extends Cubit<RecentUploadsState> {
  final UploadsRepo uploadsRepo;

  RecentUploadsCubit({required this.uploadsRepo})
      : super(RecentUploadsInitial());

  String? _nextCursor;

  Future<void> loadRecentUploads({String? cursor}) async {
    emit(RecentUploadsLoading());
    final result = await uploadsRepo.getDocs(cursor: cursor);
    final cacheDocs = DocsCacheHelper.getDocs();
    result.fold(
      (failure) => emit(RecentUploadsError(failure.errorMessage)),
      (tuple) {
        final docs = tuple.$1;
        final metaData = tuple.$2;
        _nextCursor = metaData;
        if (cacheDocs.isNotEmpty) {
          final docsMap = <String, Data>{};
          for (final doc in docs) {
            docsMap[doc.document] = doc;
          }
          final sortedDocs = <Data>[];
          for (final cacheDoc in cacheDocs) {
            final apiDoc = docsMap[cacheDoc.path];
            if (apiDoc != null) {
              sortedDocs.add(apiDoc);
            }
          }
          if (sortedDocs.isEmpty) {
            final reversedDocs = docs.reversed.toList();
            emit(RecentUploadsLoaded(reversedDocs, cacheDocs, _nextCursor));
          } else {
            emit(RecentUploadsLoaded(sortedDocs, cacheDocs, _nextCursor));
          }
        } else {
          final reversedDocs = docs.reversed.toList();
          emit(RecentUploadsLoaded(reversedDocs, cacheDocs, _nextCursor));
        }
      },
    );
  }

  Future<void> uploadDoc(File file) async {
    emit(RecentUploadsLoading());
    final result = await uploadsRepo.uploadDoc(file);
    result.fold(
      (failure) => emit(RecentUploadsError(failure.errorMessage)),
      (docModel) {
        if (docModel.data.isNotEmpty) {
          final firstDoc = docModel.data.first;
          final cacheDoc = RecentDocModel(
            name: firstDoc.documentName,
            path: firstDoc.document,
            uploadDate: DateTime.now(),
          );
          addRecentUpload(cacheDoc);
        }
        loadRecentUploads();
      },
    );
  }

  Future<void> addRecentUpload(RecentDocModel doc) async {
    await DocsCacheHelper.addDoc(doc);
  }

  Future<void> clearRecentUploads() async {
    await DocsCacheHelper.clearDocs();
    loadRecentUploads();
  }

  Future<void> loadMoreUploads() async {
    if (_nextCursor == null) return;

    final result = await uploadsRepo.getDocs(cursor: _nextCursor);
    result.fold(
      (failure) => emit(RecentUploadsError(failure.errorMessage)),
      (tuple) {
        final moreDocs = tuple.$1;
        final metaData = tuple.$2;
        _nextCursor = metaData;
        if (state is RecentUploadsLoaded) {
          final currentState = state as RecentUploadsLoaded;
          final allDocs = [...currentState.docs, ...moreDocs];
          emit(RecentUploadsLoaded(
              allDocs, currentState.cacheDocs, _nextCursor));
        }
      },
    );
  }
}
