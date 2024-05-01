import 'package:capstone_frontend/login/kakao_login.dart';
import 'package:capstone_frontend/login/main_view_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weather/weather.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //openWeather api 호출
  final WeatherFactory _wf = WeatherFactory(dotenv.env['OPENWEATHER_API_KEY']!);
  Weather? _weather;

  void initState() {
    super.initState();
    _getLocationAndWeather();
  }

  // openWeatherApi 호출
  Future<void> _getLocationAndWeather() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
    } else if (permission == LocationPermission.deniedForever) {
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // print(position.latitude);
      // print(position.longitude);

      _wf.currentWeatherByLocation(position.latitude, position.longitude)
          .then((w) {
        setState(() {
          _weather = w;
        });
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
            _weather != null ?
            ImageIcon(NetworkImage(
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
              size: 40,
            ) : const SizedBox(
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
            icon: const Icon(Icons.search),
            onPressed: () {}, // 검색엔진
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: Text(
                  '2024',
                  style: Theme.of(context).textTheme.button?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              IconButton(
                onPressed: () {},
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
          const SizedBox(height: 15),
          CarouselSlider(
            options: CarouselOptions(
              height: 400,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.75,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
              scrollDirection: Axis.horizontal,
            ),
            items: List.generate(
              12,
              (index) => Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${index + 1}월',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.more_horiz_outlined, color: Colors.white,),
                        ),
                      ],
                    ),
                ),
                ),
              ),
            ),
          const SizedBox(height: 15),
          IconButton(
            onPressed: () {},
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(
                  Icons.calendar_month_outlined,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
