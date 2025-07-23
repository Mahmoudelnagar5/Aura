import 'package:aura/core/networking/api_failure.dart';
import 'package:aura/core/services/gemini_service.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';
import 'summary_repo.dart';

class SummaryRepoImpl implements SummaryRepo {
  @override
  Future<Either<Failure, String>> summarizeDoc(File file) async {
    try {
      final summary = await GeminiService.summarizeFile(
        file: file,
        systemContext:
            'You are an expert document summarizer. Please provide a clear, concise, and comprehensive summary of the attached document. Focus on:\n'
            '- Main ideas and key points\n'
            '- Important details and findings\n'
            '- Any conclusions or recommendations\n'
            '- Technical content explained in simple terms\n\n',
        responseFormat:
            'Please provide a well-structured summary that would be helpful for someone who has not read the original document.',
      );
      if (summary == null || summary.isEmpty) {
        return left(Failure('No summary returned'));
      }
      final cleanedSummary = summary.replaceAll('*', '');
      return right(cleanedSummary);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
