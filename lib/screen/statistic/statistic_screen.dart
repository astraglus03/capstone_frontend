import 'package:capstone_frontend/const/default_sliver_padding.dart';
import 'package:flutter/material.dart';

class StatisticScreen extends StatelessWidget {
  final bool hasImage = false;

  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: CustomScrollView(
          slivers: [
            _diaryInfoSliver(),
            _diaryCountSliver(),
            _photoVideoSliver(),
            _emotionSliver(),
          ],
        ),
      ),
    );
  }

  DefaultSliverContainer _diaryInfoSliver() {
    return DefaultSliverContainer(
      height: 150,
      child: Stack(
        children: [
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '다이어리 이름',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '메모',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 5,
            child: IconButton(
              onPressed: () {}, // 다이어리 내용 수정 이벤트처리
              icon: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }

  DefaultSliverContainer _diaryCountSliver() {
    return DefaultSliverContainer(
      height: 100,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '0',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Text(
                      '모든 일기',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 1,
              height: 40,
              child: Container(
                color: Colors.grey[400],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '0',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Text(
                      '즐겨보는 일기',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DefaultSliverContainer _photoVideoSliver() {
    return DefaultSliverContainer(
      height: 200,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '사진 / 비디오',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('0 >'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  DefaultSliverContainer _emotionSliver() {
    return const DefaultSliverContainer(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('감정'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ // 텍스트가 아닌 아이콘으로 대체 예정
              Text('놀람'),
              Text('공포'),
              Text('분노'),
              Text('중립'),
              Text('행복'),
              Text('혐오'),
            ],
          ),
        ],
      ),
    );
  }
}
