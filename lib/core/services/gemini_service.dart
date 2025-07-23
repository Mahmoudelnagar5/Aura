import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class GeminiService {
  static final Gemini _gemini =
      Gemini.init(apiKey: dotenv.env['GEMINI_API_KEY'] ?? '');

  static Future<String?> summarizeFile({
    io.File? file,
    Uint8List? bytes,
    String? fileName,
    String? systemContext,
    String? responseFormat,
  }) async {
    try {
      String extractedText = '';

      if (file == null) throw Exception('No file for mobile/desktop');
      extractedText = await _extractTextFromFile(file);

      if (extractedText.trim().isEmpty) {
        return 'Error: No text could be extracted from the file.';
      }

      int maxLen = 30000;
      if (extractedText.length > maxLen) {
        extractedText = extractedText.substring(0, maxLen);
        extractedText += '\n\n[NOTE: Document truncated due to length limit.]';
      }

      final prompt = _buildSystemPrompt(
        text: extractedText,
        contextDescription: systemContext,
        responseInstructions: responseFormat,
      );

      final response = await _gemini.prompt(
        parts: [Part.text(prompt)],
      );

      if (response?.output == null || response!.output!.trim().isEmpty) {
        return 'Error: Gemini did not return a summary.';
      }

      return response.output;
    } catch (e) {
      if (e.toString().contains('400')) {
        return 'Error: Bad request to Gemini. The document may be empty, too large, or the prompt is malformed.';
      }
      return 'Error: Unable to summarize document with Gemini.';
    }
  }

  static Future<String> _extractTextFromFile(io.File file) async {
    if (!await file.exists()) {
      throw Exception('File does not exist');
    }

    final ext = file.path.split('.').last.toLowerCase();

    try {
      if (ext == 'pdf') {
        final bytes = await file.readAsBytes();
        final PdfDocument document = PdfDocument(inputBytes: bytes);
        final extractor = PdfTextExtractor(document);
        final text = extractor.extractText();
        document.dispose();
        return text;
      } else {
        throw Exception('Unsupported file type: $ext');
      }
    } catch (e) {
      throw Exception('Failed to extract text from $ext file: ${e.toString()}');
    }
  }
}

String _buildSystemPrompt({
  required String text,
  String? contextDescription,
  String? responseInstructions,
}) {
  final buffer = StringBuffer();
  buffer.write(contextDescription ?? 'Summarize the following document:\n\n');
  buffer.write(text);
  buffer.write('\n');
  buffer.write(responseInstructions ?? 'Return a helpful summary.');
  return buffer.toString();
}
