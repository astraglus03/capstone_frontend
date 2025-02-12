import 'package:capstone_frontend/common/utils/utils.dart';
import 'package:capstone_frontend/common/view_models/go_router.dart';
import 'package:capstone_frontend/home/models/diary_model.dart';
import 'package:capstone_frontend/home/models/month_emotion_resp_model.dart';
import 'package:capstone_frontend/home/view/diary_detail_screen.dart';
import 'package:capstone_frontend/home/view_models/diary_provider.dart';
import 'package:capstone_frontend/home/view_models/emotion_list_provider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final CarouselController carouselController = CarouselController();

  // 감정 리스트 및 이미지 경로 매핑
  static const Map<String, String> emotionImages = {
    '분노': 'asset/emotion/angry.png',
    '걱정': 'asset/emotion/worry.png',
    '당황': 'asset/emotion/embarrassed.png',
    '행복': 'asset/emotion/happy.png',
    '상처': 'asset/emotion/hurt.png',
    '중립': 'asset/emotion/neutral.png',
    '슬픔': 'asset/emotion/sad.png',
  };

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR');
  }

  void _updateMonth(int change) {
    final state = ref.read(diaryProvider);
    final currentDate = state.currentDate;

    int newYear = currentDate.year;
    int newMonth = currentDate.month + change;

    if (newMonth < 1) {
      newYear--;
      newMonth = 12;
    } else if (newMonth > 12) {
      newYear++;
      newMonth = 1;
    }

    final lastDayOfMonth = DateUtils.getDaysInMonth(newYear, newMonth);
    final newDay =
        lastDayOfMonth < currentDate.day ? lastDayOfMonth : currentDate.day;
    final newDate = DateTime(newYear, newMonth, newDay);

    ref.read(diaryProvider.notifier).updateCurrentDate(newDate);
    carouselController.animateTo(
      newDay - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showYearMonthPicker(BuildContext context) {
    showYearMonthPicker(
      context: context,
      initialDate: ref.read(diaryProvider).currentDate,
      onDateChanged: (DateTime selectedDate) {
        ref.read(diaryProvider.notifier).updateCurrentDate(selectedDate);
        Future.delayed(const Duration(milliseconds: 200), () {
          carouselController.animateTo(
            selectedDate.day - 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      },
    );
  }

  Widget _buildDiaryCard(DiaryModel? diary, int index) {
    return FlipCard(
      front: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
          image: diary?.image != null
              ? DecorationImage(
                  image: Image.memory(diary!.image!).image,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            '${index + 1}일',
            style: TextStyle(
              color: diary != null ? Colors.black : Colors.white,
              fontSize: 30,
            ),
          ),
        ),
      ),
      back: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
        ),
        child: diary != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '일기 내용',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            diary.content ?? '내용 없음',
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '피드백',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            diary.feedback ?? '피드백 없음',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 6,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (diary.absEmotion ?? []).toSet().map((e) => '#$e').join(' '),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: 상세 페이지로 이동
                            context.goNamed(DiaryDetailScreen.routeName, pathParameters:{
                              'did': diary.id!,
                            });
                          },
                          icon: const Icon(
                            Icons.more_horiz_outlined,
                            color: Colors.black,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : const Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Center(
                  child: Text('일기가 없습니다.', style: TextStyle(fontSize: 20)),
                ),
              ),
      ),
    );
  }

  Widget _buildCarouselSlider(DiaryState state) {
    final daysInMonth = DateUtils.getDaysInMonth(
      state.currentDate.year,
      state.currentDate.month,
    );

    return carousel.CarouselSlider.builder(
      itemCount: daysInMonth,
      // carouselController: carouselController,
      options: carousel.CarouselOptions(
        height: 440,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.75,
        initialPage: state.currentDate.day - 1,
        enableInfiniteScroll: false,
      ),
      itemBuilder: (context, index, realIndex) {
        final sliderDate = DateTime(
          state.currentDate.year,
          state.currentDate.month,
          index + 1,
        );

        final dayDiary = state.diaries.firstWhere(
          (diary) =>
              diary.date?.day == sliderDate.day &&
              diary.date?.month == sliderDate.month &&
              diary.date?.year == sliderDate.year,
          orElse: () => DiaryModel(),
        );

        return _buildDiaryCard(dayDiary.id != null ? dayDiary : null, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryProvider);
    final monthBestEmotionState = ref.watch(emotionListProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            if (monthBestEmotionState.emotions != null)
              ...monthBestEmotionState.emotions.map((emotion) {
                final imagePath = emotionImages[emotion];
                if (imagePath == null) return const SizedBox.shrink();

                return Container(
                  width: 24.0,
                  height: 24.0,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            const SizedBox(width: 12),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: DateFormat('yyyy년 MM월 dd일', 'ko_KR')
                          .format(DateTime.now()),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const ImageIcon(AssetImage('asset/conversation.png')),
            onPressed: () {
              // TODO: 챗봇 화면으로 이동
            },
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
                  DateFormat('yy.MM').format(state.currentDate),
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
          const SizedBox(height: 10),
          if (state.isLoading)
            _buildContainerSkeletonUI()
          else
            _buildCarouselSlider(state),
        ],
      ),
    );
  }

  Widget _buildContainerSkeletonUI() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 270,
        height: 440,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
