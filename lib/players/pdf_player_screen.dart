import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../widgets/button_favorite.dart';
import '../widgets/download_item.dart';

class PdfPlayerScreen extends StatefulWidget {
  final String link;
  final String title;
  final String id;
  const PdfPlayerScreen({
    super.key,
    required this.link,
    required this.title,
    required this.id,
  });

  @override
  State<PdfPlayerScreen> createState() => _PdfPlayerScreenState();
}

class _PdfPlayerScreenState extends State<PdfPlayerScreen> {
  PdfViewerController pdfViewerController = PdfViewerController();
  TextEditingController textEditingController = TextEditingController();

  searchWord(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ادخل كلمة البحث'),
          content: TextField(
            controller: textEditingController,
            keyboardType: TextInputType.text,
            onSubmitted: (val) {
              textEditingController.text = val;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                pdfViewerController.searchText(textEditingController.text);
                Navigator.pop(context);
              },
              child: const Text('بحث'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('رجوع'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: () {
                searchWord(context);
              },
              icon: const Icon(Icons.search),
            ),
            ButtonFavorite(id: widget.id, title: widget.title),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SfPdfViewer.network(
                widget.link,
                controller: pdfViewerController,
              ),
            ),
            DownloadItem(
              title: widget.title,
              url: widget.link,
            ),
          ],
        ),
      ),
    );
  }
}
