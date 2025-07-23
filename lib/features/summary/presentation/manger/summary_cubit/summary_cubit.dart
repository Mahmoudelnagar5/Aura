import 'dart:io';

import 'package:aura/features/summary/data/repos/summary_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

part 'summary_state.dart';

class SummaryCubit extends Cubit<SummaryState> {
  final SummaryRepo summaryRepo;
  String? currentDocumentId; // Track current document being processed

  SummaryCubit(this.summaryRepo) : super(SummaryInitial());

  Future<void> summarizeDoc(File file, {String? documentId}) async {
    // Set the current document ID
    currentDocumentId = documentId ?? file.path;

    emit(SummaryLoading());
    final result = await summaryRepo.summarizeDoc(file);
    result.fold(
      (failure) => emit(SummaryFailure(
          error: failure.errorMessage, documentId: currentDocumentId)),
      (summary) =>
          emit(SummarySuccess(summary: summary, documentId: currentDocumentId)),
    );
  }
}
