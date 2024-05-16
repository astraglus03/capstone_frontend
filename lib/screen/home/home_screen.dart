import 'dart:convert';
import 'package:capstone_frontend/calendar/utils.dart';
import 'package:capstone_frontend/const/api_utils.dart';
import 'package:capstone_frontend/screen/chatbot/chatbot_screen.dart';
import 'package:capstone_frontend/screen/chatbot/q_and_a.dart';
import 'package:capstone_frontend/screen/diary_detail_screen.dart';
import 'package:capstone_frontend/screen/home/month_emotion_resp_model.dart';
import 'package:capstone_frontend/screen/statistic/model/diary_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather/weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationcontroller;
  double offsetY = 0.0;

  //openWeather api 호출
  // final WeatherFactory _wf = WeatherFactory(dotenv.env['OPENWEATHER_API_KEY']!);
  // Weather? _weather;
  DateTime currentDate = DateTime.now();
  late int daysInMonth;
  late CarouselController carouselController;
  final userId = UserManager().getUserId();
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    daysInMonth = _daysInMonth(currentDate);
    carouselController = CarouselController();
    _animationcontroller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animationcontroller.addListener(() {
      setState(() {
        offsetY = _animationcontroller.value;
      });
    });

    // _getLocationAndWeather();
  }

  // 슬라이드 넘길 때도 날짜 업데이트 하기 위한 코드
  // void onPageChanged(int index, CarouselPageChangedReason reason) {
  //   setState(() {
  //     currentDate = DateTime(currentDate.year, currentDate.month, index + 1);
  //     print('슬라이더 넘겼을 때 $currentDate');
  //   });
  // }

  @override
  void dispose() {
    _animationcontroller.dispose();
    super.dispose();
  }

  int _daysInMonth(DateTime date) {
    return DateUtils.getDaysInMonth(date.year, date.month);
  }

  void _updateMonth(int change) {
    int newYear = currentDate.year;
    int newMonth = currentDate.month + change;

    // 1월보다 숫자 작으면 이전년도 12월
    if (newMonth < 1) {
      newYear--;
      newMonth = 12;
    }
    // 12월보다 숫자 크면 다음 년도 1월
    else if (newMonth > 12) {
      newYear++;
      newMonth = 1;
    }

    // 새로운 달의 마지막 날(일) 계산
    int lastDayOfMonth = _daysInMonth(DateTime(newYear, newMonth));
    int newDay = lastDayOfMonth < currentDate.day ? lastDayOfMonth : currentDate.day;

    setState(() {
      currentDate = DateTime(newYear, newMonth, newDay);
      daysInMonth = _daysInMonth(currentDate);
      carouselController.jumpToPage(newDay - 1);
    });
  }

  void _showYearMonthPicker(BuildContext context) {
    showYearMonthPicker(
      context: context,
      initialDate: currentDate,
      onDateChanged: (DateTime selectedDate) {
        setState(() {
          currentDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
          daysInMonth = _daysInMonth(currentDate);
          print(currentDate);
        });
        Future.delayed(Duration(milliseconds: 200), () {
          final selectedDay = selectedDate.day;
          carouselController.jumpToPage(selectedDay - 1);
        });
      },
    );
  }

  // 카루셀 슬라이더 위아래 드래그로 챗봇스크린 이동
  void onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      offsetY += details.primaryDelta!;
    });
  }

  // 카루셀 슬라이더 위아래 드래그로 챗봇스크린 이동
  void onVerticalDragEnd(DragEndDetails details) {
    if (offsetY > 100 || offsetY < -70) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ChatbotScreen()));
    }
    _animationcontroller.reverse(from: offsetY);
  }

  // openWeatherApi 호출
  // Future<void> _getLocationAndWeather() async {
  //   LocationPermission permission = await Geolocator.requestPermission();
  //
  //   if (permission == LocationPermission.denied) {
  //   } else if (permission == LocationPermission.deniedForever) {
  //   } else {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     // print(position.latitude);
  //     // print(position.longitude);
  //     _wf.currentWeatherByLocation(position.latitude, position.longitude)
  //         .then((w) {
  //       if (mounted) {
  //         setState(() {
  //           _weather = w;
  //         });
  //       }
  //     });
  //   }
  // }

  Future<List<DiaryModel>> getListEmotion() async {
    print(DateFormat('yyyy-MM').format(currentDate));
    try {

      final resp = await dio.post('$ip/Search_Diary_api/searchdiary', data: {
        'userId': userId,
        'date': 'None',
        'month': DateFormat('yyyy-MM').format(currentDate),
        'limit': 'None',
      });

      // print(resp.body);
      if (resp.statusCode == 200) {
        List<dynamic> jsonData = resp.data;
        var emotionList = jsonData.map((item) => DiaryModel.fromJson(item)).toList();
        print(emotionList.length);
        return emotionList;
      } else if (resp.statusCode == 404) {
        // 데이터가 없을 때 404 오류를 반환하는 경우에도 빈 리스트를 반환하도록 처리
        return [];
      } else {
        throw Exception('Failed to load data ${resp.statusCode}');
      }
    } catch (e) {
      print('Error parsing photos: $e');
      throw Exception('Error parsing photos: $e');
    }
  }

  Widget _buildContainerSkeletonUI(){
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: CarouselSlider.builder(
        itemCount: daysInMonth,
        carouselController: carouselController,
        options: CarouselOptions(
          height: 440,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction: 0.75,
          initialPage: currentDate.day - 1,
          enableInfiniteScroll: false,
          //onPageChanged: onPageChanged,
        ),
        itemBuilder: (context, index, realIndex) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(30),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthEmotionSkeletonUI() {
    return FutureBuilder<DiaryMonthModel>(
      future: getMonthEmotion(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data;
          final emotionIconMap = {
            'sad': 'asset/sadEmoticon.webp',
            'happy': 'asset/happyEmoticon.webp',
            'angry': 'asset/angryEmoticon.webp',
            'embarrassed': 'asset/embarrassedEmoticon.webp',
            'anxiety': 'asset/anxietyEmoticon.webp',
            'hurt': 'asset/hurtEmoticon.webp',
            'neutral': 'asset/neutralEmoticon.webp',
          };
          return Row(
            children: List.generate(data!.representEmotion.length, (index) {
              String emotion = data.representEmotion[index];
              String imagePath = emotionIconMap[emotion] ?? 'asset/img.webp';
              return Container(
                width: 30.0, // 원하는 크기 설정
                height: 30.0, // 원하는 크기 설정
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(imagePath))),
              );
            }),
          );
        } else {
          return SizedBox(
            width: 20,
            height: 20,
            child: _buildMonthEmotionSkeletonUI(),
          );
        }
      },
    );
  }

  Future<DiaryMonthModel> getMonthEmotion() async {

    final resp = await dio.post('$ip/Count_Month_Emotion/countmonthemotion', data: {
      'userId': userId,
      'month': DateFormat('yyyy-MM').format(DateTime.now()),
    });

    if (resp.statusCode == 200) {
      return DiaryMonthModel.fromJson(resp.data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ko_KR');
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            FutureBuilder<DiaryMonthModel>(
              future: getMonthEmotion(),
              builder: (_, AsyncSnapshot<DiaryMonthModel> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildMonthEmotionSkeletonUI();
                } else if (snapshot.hasData) {
                  final data = snapshot.data;
                  final emotionIconMap = {
                    'sad': 'asset/sadEmoticon.webp',
                    'happy': 'asset/happyEmoticon.webp',
                    'angry': 'asset/angryEmoticon.webp',
                    'embarrassed': 'asset/embarrassedEmoticon.webp',
                    'anxiety': 'asset/anxietyEmoticon.webp',
                    'hurt': 'asset/hurtEmoticon.webp',
                    'neutral': 'asset/neutralEmoticon.webp',
                  };
                  return Row(
                    children:
                    List.generate(data!.representEmotion.length, (index) {
                      // 현재 감정 상태를 가져와서 해당하는 이미지 경로를 찾음
                      String emotion = data.representEmotion[index];
                      String imagePath = emotionIconMap[emotion] ?? 'asset/img.webp';
                      // print(imagePath);

                      return Container(
                        width: 30.0, // 원하는 크기 설정
                        height: 30.0, // 원하는 크기 설정
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover, // 이미지가 컨테이너에 꽉 차도록 조정
                                image: AssetImage(imagePath))),
                      );
                    }),
                  );
                } else {
                  return SizedBox(
                    width: 20,
                    height: 20,
                    child: _buildMonthEmotionSkeletonUI(),
                  );
                }
              },
            ),
            // _weather != null
            //     ? ImageIcon(
            //         NetworkImage(
            //             "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"), size: 40,
            //       )
            //     : const SizedBox(
            //         width: 20,
            //         height: 20,
            //         child: CircularProgressIndicator(),
            //       ),
            SizedBox(
              width: 20,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: DateFormat('yyyy년 MM월 dd일', 'ko_KR')
                        .format(DateTime.now()),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text:
                    '\n${DateFormat('EEEE', 'ko_KR').format(DateTime.now())}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: const ImageIcon(AssetImage('asset/conversation.png')),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => QandAScreen()));
            }, // Q&A 페이지로 이동
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => _updateMonth(-1),
              ),
              GestureDetector(
                onTap: () => _showYearMonthPicker(context),
                child: Text(
                  DateFormat('yy.MM').format(currentDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () => _updateMonth(1),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            child: Transform.translate(
              offset: Offset(0, offsetY),
              child: FutureBuilder<List<DiaryModel>>(
                future: getListEmotion(),
                builder: (_, AsyncSnapshot<List<DiaryModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildContainerSkeletonUI();
                  }
                  else if (snapshot.hasData) {
                    final List<DiaryModel> diaries = snapshot.data!;
                    return CarouselSlider.builder(
                      itemCount: daysInMonth,
                      carouselController: carouselController,
                      options: CarouselOptions(
                        height: 440,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.75,
                        initialPage: currentDate.day - 1,
                        enableInfiniteScroll: false,
                        // onPageChanged: onPageChanged, // Add onPageChanged callback
                      ),
                      itemBuilder: (context, index, realIndex) {
                        DateTime sliderDate = DateTime(currentDate.year, currentDate.month, index + 1);
                        // 해당 날짜에 해당하는 모든 일기 필터링
                        List<DiaryModel> filteredDiaries = diaries.where((diary) =>
                        diary.date?.day == sliderDate.day &&
                            diary.date?.month == sliderDate.month &&
                            diary.date?.year == sliderDate.year).toList();
                        // 첫 번째 일기 선택
                        DiaryModel? dayDiary = filteredDiaries.isNotEmpty ? filteredDiaries.first : null;

                        if (dayDiary != null) {
                          return FlipCard(
                            front: Container(
                              width: double.infinity,
                              margin:
                              const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                  image: Image.memory(dayDiary.image!).image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}일',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                      ),
                                    ),
                                    // 사진 변경하기 버튼
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.more_horiz_outlined,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            back: Container(
                                width: double.infinity,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dayDiary.content!,
                                              style: TextStyle(fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 8,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                '피드벡: 여기는 피드백하는 공간 여기는 피드백하는 공간 여기는 피드백하는 공간 여기는 피드백하는 공간 여기는 피드백하는 공간 여기는 피드백하는 공간'
                                                    '여기는 피드백하는 공간 여기는 피드백하는 공간 여기는 피드백하는 공간 여기는 피드백하는 공간 여기는 피드백하는 공간 여기는 피드백하는 공간 여기는 피드백하는 공간'
                                                    '여기는 피드백하는 공간 여기는 피드백하는 공간 여기는 피드백하는 공간 여기는 피드백하는 공간 여기는 피드백하는 공간',
                                                style: TextStyle(fontSize: 14),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 6
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(dayDiary.textEmotion!.toSet().map((e) => '#$e').join(' '), style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          )),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => DiaryDetailScreen(
                                                photoDetail: dayDiary,
                                              )));
                                            },
                                            icon: Icon(
                                              Icons.more_horiz_outlined,
                                              color: Colors.black,
                                              size: 32,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        } else {
                          return FlipCard(
                            front: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}일',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                      ),
                                    ),
                                    // 사진 변경하기 버튼
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.more_horiz_outlined,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            back: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Center(
                                      child: Text(
                                          '일기가 없습니다.',
                                          style: TextStyle(fontSize: 20)
                                      )
                                  )),
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return CarouselSlider.builder(
                      itemCount: daysInMonth,
                      carouselController: carouselController,
                      options: CarouselOptions(
                        height: 440,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.75,
                        initialPage: currentDate.day - 1,
                        enableInfiniteScroll: false,
                      ),
                      itemBuilder: (context, index, realIndex) {
                        DateTime sliderDate = DateTime(currentDate.year, currentDate.month, index + 1);
                        // 해당 날짜에 해당하는 모든 일기 필터링

                        return FlipCard(
                          front: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${index + 1}일',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                  // 사진 변경하기 버튼
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.more_horiz_outlined,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          back: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Center(
                                    child: Text(
                                        '일기가 없습니다.',
                                        style: TextStyle(fontSize: 20)
                                    )
                                )),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
