import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ClovaScreen extends StatefulWidget {
  @override
  _ClovaScreenState createState() => _ClovaScreenState();
}

class _ClovaScreenState extends State<ClovaScreen> {
  final String _uri = 'https://naveropenapi.apigw.ntruss.com/recog/v1/stt'; // 네이버 클로바 STT API 엔드포인트
  final String _clientID = '7n25oz359z'; // 네이버 클로바 STT API 클라이언트 ID
  final String _clientSecret = 'NSXD78R0dTpd2SnlTH5c7lO0tmULRYwTcyf3zBNN'; // 네이버 클로바 STT API 클라이언트 Secret

  final Dio _dio = Dio();
  bool _isListening = false;
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('음성 인식'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_text),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _isListening ? _stopListening : _startListening,
              child: Icon(_isListening ? Icons.stop : Icons.mic),
            ),
          ],
        ),
      ),
    );
  }

  void _startListening() async {
    setState(() {
      _isListening = true;
    });
    try {
      String filePath = '/Users/astraglus/Desktop/'; // 음성 파일 경로
      FormData formData = FormData.fromMap({
        'lang': 'Kor',
        'file': await MultipartFile.fromFile(filePath, filename: 'audio.wav'),
      });
      Options options = Options(
        headers: {
          'Content-Type': 'application/octet-stream',
          'X-NCP-APIGW-API-KEY-ID': _clientID,
          'X-NCP-APIGW-API-KEY': _clientSecret,
        },
      );
      Response response = await _dio.post(_uri, data: formData, options: options);
      setState(() {
        _text = response.data['text'];
        _isListening = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isListening = false;
      });
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
  }
}
