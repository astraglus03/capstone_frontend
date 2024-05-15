import 'package:capstone_frontend/calendar/utils.dart';
import 'package:capstone_frontend/const/api_utils.dart';
import 'package:capstone_frontend/screen/chatbot/chatbot_screen.dart';
import 'package:capstone_frontend/screen/diary_detail_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;

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
  final WeatherFactory _wf = WeatherFactory(dotenv.env['OPENWEATHER_API_KEY']!);
  Weather? _weather;
  DateTime currentDate = DateTime.now();
  late int daysInMonth;
  late CarouselController carouselController;
  final userId = UserManager().getUserId();

  @override
  void initState() {
    super.initState();
    daysInMonth = _daysInMonth(currentDate);
    carouselController = CarouselController();
    _animationcontroller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animationcontroller.addListener(() {
      setState(() {
        offsetY = _animationcontroller.value;
      });
    });
    _getLocationAndWeather();
  }

  @override
  void dispose() {
    _animationcontroller.dispose();
    super.dispose();
  }

  int _daysInMonth(DateTime date) {
    return DateUtils.getDaysInMonth(date.year, date.month);
  }

  void _updateMonth(int change) {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month + change);
      daysInMonth = _daysInMonth(currentDate);
    });
  }

  void _showYearMonthPicker(BuildContext context) {
    showYearMonthPicker(
      context: context,
      initialDate: currentDate,
      onDateChanged: (DateTime selectedDate) {
        setState(() {
          print(selectedDate);
          print(selectedDate.day);
          currentDate = DateTime(selectedDate.year, selectedDate.month);
          daysInMonth = _daysInMonth(currentDate);
          carouselController.jumpToPage(selectedDate.day - 1);
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

  // 유저 정보를 가져와 출력하는 함수
  // Future<void> _fetchUserInfo() async {
  //   final dio = Dio();
  //   final resp = await dio.post('$ip/receive_user_info',
  //       options: Options(headers: {
  //         'Content-Type': 'application/json',
  //       }));
  //   print(resp.data);
  //   User user = User.fromJson(jsonDecode(resp.data));
  //   print(user);
  //   setState(() {
  //     UserID = resp.data['userId'];
  //     UserNickname = resp.data['nickname'];
  //   });
  // }

  // openWeatherApi 호출
  Future<void> _getLocationAndWeather() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
    } else if (permission == LocationPermission.deniedForever) {
    } else {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // print(position.latitude);
      // print(position.longitude);

      _wf.currentWeatherByLocation(position.latitude, position.longitude).then((w) {
        if (mounted) {
          setState(() {
            _weather = w;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ko_KR');
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            _weather != null
                ? ImageIcon(
              NetworkImage(
                  "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
              size: 40,
            )
                : const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ),
            GestureDetector(
              onTap: () {}, // 클릭했을때 해당 월 달력으로 이동
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: DateFormat(' yyyy년 MM월 dd일', 'ko_KR')
                          .format(DateTime.now()),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                      '\n${DateFormat(' EEEE', 'ko_KR').format(DateTime.now())}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
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
                  .push(MaterialPageRoute(builder: (_) => ChatbotScreen()));
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
                ),
                itemBuilder: (context, index, realIndex) {
                  return FlipCard(
                    front: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: AssetImage('asset/img.webp'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              onPressed: (){},
                              icon: Icon(Icons.more_horiz_outlined, color: Colors.white,),
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
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용'
                                          '심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용'
                                          '심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용'
                                          '심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용'
                                          '심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용'
                                          '심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용'
                                          '심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용 심종혜 김건동 배재민 박지용',
                                      style: TextStyle(fontSize: 12),
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
                                        maxLines: 6),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('#행복 #불안 #화남 #중립'),
                                  IconButton(
                                    onPressed: () {
                                      // Navigator.of(context).push(MaterialPageRoute(builder: (_) => DiaryDetailScreen()));
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
