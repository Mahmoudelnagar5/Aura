part of 'summary_cubit.dart';

abstract class SummaryState {}

class SummaryInitial extends SummaryState {}

class SummaryLoading extends SummaryState {}

class SummarySuccess extends SummaryState {
  final String summary;
  final String? documentId;

  SummarySuccess({required this.summary, this.documentId});
}

class SummaryFailure extends SummaryState {
  final String error;
  final String? documentId;

  SummaryFailure({required this.error, this.documentId});
}
