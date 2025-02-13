import 'package:capstone_frontend/home/enum/emotion.dart';
import 'package:capstone_frontend/home/models/diary_detail_model.dart';
import 'package:flutter/material.dart';



class EmotionChangeChart extends StatelessWidget {
  final List<EmotionChange>? emotionChanges;
  final String? overallFeedback;
  final List<String>? absEmotions;
  final bool isSimpleMode;

  const EmotionChangeChart({
    super.key,
    this.emotionChanges,
    this.overallFeedback,
    this.absEmotions,
    this.isSimpleMode = false,
  }) : assert(
         (isSimpleMode && absEmotions != null) || 
         (!isSimpleMode && emotionChanges != null),
         'Simple mode requires absEmotions, detailed mode requires emotionChanges'
       );

  Widget _buildEmotionImage(String emotionText) {
    final emotion = Emotion.fromString(emotionText);
    return Container(
      width: 35,
      height: 75,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(emotion.imagePath),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _buildEmotionChangeItem(EmotionChange change, int index) {
    return Column(
      children: [
        if (index > 0) const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEmotionImage(change.fromEmotion),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_right_rounded, size: 70, color: Colors.black),
            const SizedBox(width: 10),
            _buildEmotionImage(change.toEmotion),
          ],
        ),
        const SizedBox(height: 10),
        Text(change.changeComment),
      ],
    );
  }

  Widget _buildSimpleEmotionChange() {
    if (absEmotions == null || absEmotions!.isEmpty) return const SizedBox.shrink();
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEmotionImage(absEmotions!.first),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_right_rounded, size: 70, color: Colors.black),
            const SizedBox(width: 10),
            _buildEmotionImage(absEmotions!.last),
          ],
        ),
        if (overallFeedback != null) ...[
          const SizedBox(height: 10),
          Text(overallFeedback!),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSimpleMode)
            _buildSimpleEmotionChange()
          else ...[
            if (overallFeedback != null) ...[
              const Text(
                '<전체 감정 변화 피드백>',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(overallFeedback!),
              const SizedBox(height: 20),
            ],
            ...emotionChanges!.asMap().entries.map(
              (entry) => _buildEmotionChangeItem(entry.value, entry.key),
            ),
          ],
        ],
      ),
    );
  }
}
