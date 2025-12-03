import 'package:flutter/material.dart';
import 'tabs/viewer_tab.dart';
import 'tabs/builder_tab.dart';

void main() {
  runApp(PdfMasterApp());
}

class PdfMasterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Master',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? _filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Master')),
      body: IndexedStack(
        index: _currentIndex,
        children: [
           ViewerTab(
             filePath: _filePath,
             onFileSelected: (path) {
               setState(() {
                 _filePath = path;
               });
             },
           ),
           BuilderTab(
             onPdfCreated: (path) {
               setState(() {
                 _filePath = path;
                 _currentIndex = 0;
               });
             },
           ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.picture_as_pdf), label: 'Visor'),
          BottomNavigationBarItem(icon: Icon(Icons.create), label: 'Creador'),
        ],
      ),
    );
  }
}
