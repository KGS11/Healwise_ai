import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdfx/pdfx.dart';

class OcrService {
  OcrService({TextRecognizer? textRecognizer})
    : _textRecognizer =
          textRecognizer ?? TextRecognizer(script: TextRecognitionScript.latin);

  final TextRecognizer _textRecognizer;

  // Extracts text from a single image file using Google ML Kit OCR.
  Future<String> extractTextFromImage(File image) async {
    debugPrint('[OCR] Reading image: ${image.path}');
    final inputImage = InputImage.fromFile(image);
    
    try {
      final recognizedText = await _textRecognizer.processImage(inputImage).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('[OCR] ML Kit processImage timed out for: ${image.path}');
          throw const OcrTimeoutException('ML Kit text recognition timed out.');
        },
      );
      debugPrint('[OCR] Image text length: ${recognizedText.text.length}');
      return recognizedText.text.trim();
    } catch (e) {
      debugPrint('[OCR] Error during processImage: $e');
      rethrow;
    }
  }

  // Renders PDF pages to temporary images and extracts text from each page.
  Future<String> extractTextFromPdf(File pdf) async {
    debugPrint('[OCR] Reading PDF: ${pdf.path}');
    final stopwatch = Stopwatch()..start();
    
    final document = await PdfDocument.openFile(pdf.path).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        debugPrint('[OCR] PdfDocument openFile timed out.');
        throw const OcrTimeoutException('Opening PDF document timed out.');
      },
    );
    final buffer = StringBuffer();

    try {
      for (
        var pageNumber = 1;
        pageNumber <= document.pagesCount;
        pageNumber++
      ) {
        // Prevent background execution leak if the overall process has timed out
        if (stopwatch.elapsed.inSeconds > 20) {
          debugPrint('[OCR] PDF processing exceeded time limit inside loop.');
          throw const OcrTimeoutException('PDF page processing timed out.');
        }

        debugPrint('[OCR] Processing PDF page $pageNumber / ${document.pagesCount}');
        final page = await document.getPage(pageNumber).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            debugPrint('[OCR] PDF getPage $pageNumber timed out.');
            throw const OcrTimeoutException('Reading PDF page timed out.');
          },
        );

        try {
          final pageImage = await page.render(
            width: page.width * 2,
            height: page.height * 2,
            format: PdfPageImageFormat.png,
            backgroundColor: '#FFFFFF',
          ).timeout(
            const Duration(seconds: 8),
            onTimeout: () {
              debugPrint('[OCR] PDF page $pageNumber rendering timed out.');
              throw const OcrTimeoutException('PDF page rendering timed out.');
            },
          );

          if (pageImage == null) {
            debugPrint('[OCR] PDF page $pageNumber rendered empty.');
            continue;
          }

          final tempFile = File(
            '${Directory.systemTemp.path}/healwise_report_${DateTime.now().microsecondsSinceEpoch}_$pageNumber.png',
          );
          
          await tempFile.writeAsBytes(pageImage.bytes, flush: true).timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              debugPrint('[OCR] PDF page $pageNumber temp file write timed out.');
              throw const OcrTimeoutException('Writing temporary PDF page image timed out.');
            },
          );

          try {
            final pageText = await extractTextFromImage(tempFile);
            buffer.writeln(pageText);
          } finally {
            if (await tempFile.exists()) {
              await tempFile.delete();
            }
          }
        } finally {
          await page.close();
        }
      }
    } finally {
      await document.close();
    }

    final text = buffer.toString().trim();
    debugPrint('[OCR] PDF text length: ${text.length}');
    return text;
  }

  // Releases ML Kit native resources.
  Future<void> dispose() async {
    await _textRecognizer.close();
  }
}

class OcrTimeoutException implements Exception {
  final String message;
  const OcrTimeoutException(this.message);

  @override
  String toString() => message;
}
