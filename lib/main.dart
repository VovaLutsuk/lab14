import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageScreen(),
    );
  }
}

class ImageScreen extends StatefulWidget {
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  static const platform = MethodChannel('com.example.text/channel'); // Оновлений канал
  File? _image; // Змінна для збереження вибраного зображення
  String _nativeMessage = ""; // Змінна для збереження повідомлення від нативного коду

  // Метод для відкриття камери та отримання зображення
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Оновлюємо змінну _image
      });
    }
  }

  // Метод для виклику нативного коду
  Future<void> _getNativeMessage() async {
    try {
      final String result = await platform.invokeMethod('getNativeMessage'); // Оновлений метод
      setState(() {
        _nativeMessage = result; // Оновлюємо повідомлення
      });
    } on PlatformException catch (e) {
      setState(() {
        _nativeMessage = "Failed to get message: '${e.message}'"; // Відображення помилки
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera & Native Code'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Відображення фотографії в рамці
            _image == null
                ? Text('No image selected.')
                : Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 4),
                borderRadius: BorderRadius.circular(3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Image.file(
                  _image!,
                  fit: BoxFit.cover, // Масштабування зображення
                ),
              ),
            ),
            SizedBox(height: 10),
            // Відображення повідомлення від нативного коду
            Text(
              _nativeMessage,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage, // Викликаємо метод для фотографування
              icon: Icon(Icons.camera_alt), // Іконка камери
              label: Text('Take a Photo'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _getNativeMessage, // Викликаємо метод для отримання повідомлення
              icon: Icon(Icons.message), // Іконка повідомлення
              label: Text('Native Message'),
            ),
          ],
        ),
      ),
    );
  }
}
