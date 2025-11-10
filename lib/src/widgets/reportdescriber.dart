import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

typedef PdfBuilder = Future<pw.Document> Function();

class ReportDescriber extends StatelessWidget {
  final String title;
  final String description;
  final PdfBuilder buildPdf;
  final String filename;
  final Color previewColor;
  final Color pdfColor;
  final bool showDivider;

  const ReportDescriber({
    Key? key,
    required this.title,
    required this.description,
    required this.buildPdf,
    required this.filename,
    this.previewColor = Colors.blue,
    this.pdfColor = Colors.green,
    this.showDivider = true,
  }) : super(key: key);

  Future<T> _withLoadingDialog<T>(BuildContext context, Future<T> Function() task) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      return await task();
    } finally {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    }
  }

  Future<void> _openPreview(BuildContext context) async {
    final pdf = await _withLoadingDialog(context, buildPdf);
    await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: PdfPreview(build: (format) => pdf.save()),
        ),
      ),
    );
  }

  Future<void> _sharePdf(BuildContext context) async {
    final pdf = await _withLoadingDialog(context, buildPdf);
    await Printing.sharePdf(bytes: await pdf.save(), filename: filename);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Texto del reporte 
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),

              // Botones
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _openPreview(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: previewColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    icon: const Icon(Icons.visibility, size: 18, color: Colors.white),
                    label: const Text('Previa', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _sharePdf(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pdfColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    icon: const Icon(Icons.download, size: 18, color: Colors.white),
                    label: const Text('PDF', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, thickness: 1),
      ],
    );
  }
}
