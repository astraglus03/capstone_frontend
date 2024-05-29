import 'package:capstone_frontend/screen/statistic/model/diary_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:capstone_frontend/screen/diary_detail_screen.dart';
import 'package:capstone_frontend/const/api_utils.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

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
  final dio = Dio();

  Future<List<DiaryModel>> getPhoto(String userId, String date, String month, String limit) async {

    final resp = await dio.post('$ip/Search_Diary_api/searchdiary', data: {
      'userId': userId,
      'date': date,
      'month': month,
      'limit': limit,
    }, options: Options(
      headers: {
        'content-type': 'application/json',
      },
    )
    );

    if (resp.statusCode == 200) {
      try {
        print(resp.data.length);  // 성공적으로 출력

        List<dynamic> data = resp.data;
        return data.reversed.map((e) => DiaryModel.fromJson(e)).toList();
      } catch (e) {
        print('Error parsing photos: $e');  // 파싱 중 발생한 에러 출력
        throw Exception('Error parsing photos: $e');
      }
    } else {
      print('Failed to load photo with status code: ${resp.statusCode}');
      print('Error body: ${resp.data}');
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
      body: FutureBuilder<List<DiaryModel>>(
        future: getPhoto(userId!, 'None', 'None','None'),
        builder: (_, AsyncSnapshot<List<DiaryModel>> snapshot) {
          // print('데이터${snapshot.data}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildAllPhotoSkeletonUI();
          }
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
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 한 줄에 2개 이미지
                            crossAxisSpacing: 10, // 가로 간격
                            mainAxisSpacing: 10, // 세로 간격
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final pItem = snapshot.data![index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DiaryDetailScreen(
                                    photoDetail : pItem,
                                  )),
                                );
                              },
                              child: GridTile(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.memory(pItem.image!, fit: BoxFit.cover)
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                      child: Text(DateFormat('yyyy년 MM월 dd일').format(pItem.date!), style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: Text(pItem.speechEmotion!.toSet().map((e) => '#$e').join(' ')  , style: TextStyle(color: Colors.grey[600])),
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

  Widget _buildAllPhotoSkeletonUI(){
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 한 줄에 2개 이미지
          crossAxisSpacing: 10, // 가로 간격
          mainAxisSpacing: 10, // 세로 간격
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: GridTile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Container(
                      color: Colors.grey,
                      height: 20,
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      color: Colors.grey,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          );
        },
      );
  }
}