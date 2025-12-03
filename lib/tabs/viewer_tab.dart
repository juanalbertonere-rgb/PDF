import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ViewerTab extends StatefulWidget {
  final String? filePath;
  final Function(String) onFileSelected;

  const ViewerTab({Key? key, this.filePath, required this.onFileSelected}) : super(key: key);

  @override
  _ViewerTabState createState() => _ViewerTabState();
}

class _ViewerTabState extends State<ViewerTab> {
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    if (widget.filePath != null) {
      return Stack(
        children: [
          PDFView(
            key: Key(widget.filePath!),
            filePath: widget.filePath,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
            },
            onViewCreated: (PDFViewController pdfViewController) {
              // controller = pdfViewController;
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                currentPage = page;
              });
            },
          ),
          if (errorMessage.isNotEmpty)
            Center(child: Text(errorMessage))
        ],
      );
    }

    return Center(
      child: ElevatedButton(
        child: Text("Abrir PDF"),
        onPressed: _pickFile,
      ),
    );
  }

  Future<void> _pickFile() async {
    // Request permissions first
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String? path = result.files.single.path;
        if (path != null) {
          widget.onFileSelected(path);
          setState(() {
            errorMessage = '';
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error picking file: $e';
      });
    }
  }
}
