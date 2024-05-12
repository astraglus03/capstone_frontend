import 'dart:convert';

import 'package:capstone_frontend/screen/statistic/model/photo_detail_model.dart';
import 'package:capstone_frontend/screen/statistic/model/photo_model.dart';
import 'package:flutter/material.dart';
import 'package:capstone_frontend/screen/diary_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:capstone_frontend/const/api_utils.dart';
import 'package:intl/intl.dart';

class PhotoDetailScreen extends StatefulWidget {
  const PhotoDetailScreen({Key? key}) : super(key: key);

  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {

  @override
  void initState() {
    super.initState();
  }

  final userId = UserManager().getUserId();

  Future<List<PhotoDetailModel>> getPhoto(String userId, String date, String month, String limit) async {
    final resp = await http.post(Uri.parse('$ip/Search_Diary_api/searchdiary'), headers: {
      'content-type': 'application/json',
    }, body: jsonEncode({
      'userId': userId,
      'date': date,
      'month': month,
      'limit': limit,
    }));
    if (resp.statusCode == 200) {
      try {
        List<dynamic> jsonData = jsonDecode(resp.body);
        print(jsonData.length);  // 성공적으로 출력

        var photoList = jsonData.map((item) => PhotoDetailModel.fromJson(item)).toList();
        print(photoList);  // 변환 성공 후 출력
        return photoList;
      } catch (e) {
        print('Error parsing photos: $e');  // 파싱 중 발생한 에러 출력
        throw Exception('Error parsing photos: $e');
      }
    } else {
      print('Failed to load photo with status code: ${resp.statusCode}');
      print('Error body: ${resp.body}');
      throw Exception('Failed to load photo with status code: ${resp.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(135, 206, 235, 1),
        title: const Text(
          '앨범',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<PhotoDetailModel>>(
        future: getPhoto(userId!, 'None', 'None','None'),
        builder: (_, AsyncSnapshot<List<PhotoDetailModel>> snapshot) {
          print('데이터${snapshot.data}');
          if (snapshot.hasData) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('나의 앨범', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(), // 스크롤뷰 내부의 그리드 스크롤 방지
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 한 줄에 2개 이미지
                            crossAxisSpacing: 10, // 가로 간격
                            mainAxisSpacing: 10, // 세로 간격
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DiaryDetailScreen()), // diary_detail_screen() 호출
                                );
                              },
                              child: GridTile(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.memory(snapshot.data![index].image!, fit: BoxFit.cover)
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                      child: Text(DateFormat('yyyy년 MM월 dd일').format(snapshot.data![index].date!), style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: Text(snapshot.data![index].speechEmotion!.toSet().toList().join('*'), style: TextStyle(color: Colors.grey[600])),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
            );
          }
          else {
            return Center(child: Text("데이터가 없습니다"));
          }
        }
      ),
    );
  }
}

