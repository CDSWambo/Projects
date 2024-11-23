import 'package:flutter/material.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  String? inputFilePath;
  String? outputFilePath;
  bool isConverting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MP4 to MP3 Converter')),
      body: Center(
        child: isConverting
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(inputFilePath != null ? 'Selected: $inputFilePath' : 'No file selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                requestStoragePermission().then((_) => selectFile());
              },
              child: Text('Select MP4 File'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: inputFilePath != null ? convertToMp3 : null,
              child: Text('Convert to MP3'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      print('Storage permission denied.');
      return;
    }
  }

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      setState(() {
        inputFilePath = result.files.single.path;
      });

      // Get the path of the Downloads directory
      Directory? downloadsDir = Directory('/storage/emulated/0/Download');
      if (downloadsDir.existsSync()) {
        outputFilePath = "${downloadsDir.path}/${inputFilePath!.split('/').last.replaceAll('.mp4', '.mp3')}";
        print('Input Path: $inputFilePath');
        print('Output Path: $outputFilePath');
      } else {
        print('Downloads directory does not exist.');
      }
    } else {
      print('No file selected.');
    }
  }

  Future<void> convertToMp3() async {
    setState(() {
      isConverting = true;
    });

    // Execute the FFmpeg command
    FFmpegKit.execute('-i "$inputFilePath" -acodec libmp3lame "$outputFilePath"').then((session) async {
      final returnCode = await session.getReturnCode();
      setState(() {
        isConverting = false;
      });

      if (mounted) {
        if (ReturnCode.isSuccess(returnCode)) {
          print('Conversion completed successfully!');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Conversion completed!')));
        } else {
          final log = await session.getOutput();
          showLogDialog(log ?? 'No log available');
        }
      }
    });
  }

  void showLogDialog(String log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Conversion Log'),
        content: SingleChildScrollView(
          child: Text(log),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
