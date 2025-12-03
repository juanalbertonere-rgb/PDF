import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class BuilderTab extends StatefulWidget {
  final Function(String) onPdfCreated;

  const BuilderTab({Key? key, required this.onPdfCreated}) : super(key: key);

  @override
  _BuilderTabState createState() => _BuilderTabState();
}

class _BuilderTabState extends State<BuilderTab> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final PdfService _pdfService = PdfService();
  bool _isGenerating = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Título'),
          ),
          SizedBox(height: 10),
          Expanded(
            child: TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Contenido',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isGenerating ? null : _saveAndNavigate,
              child: _isGenerating
                ? CircularProgressIndicator(color: Colors.white)
                : Text("Guardar y Ver"),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _saveAndNavigate() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final file = await _pdfService.createPdf(
        _titleController.text,
        _contentController.text,
      );
      widget.onPdfCreated(file.path);
      // Clear fields after successful creation
      _titleController.clear();
      _contentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear PDF: $e')),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }
}
