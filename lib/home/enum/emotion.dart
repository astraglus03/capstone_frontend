enum Emotion {
  neutral('중립', 'asset/emotion/neutral.png'),
  sad('슬픔', 'asset/emotion/sad.png'),
  angry('분노', 'asset/emotion/angry.png'),
  happy('행복', 'asset/emotion/happy.png'),
  embarrassed('당황', 'asset/emotion/embarrassed.png'),
  hurt('상처', 'asset/emotion/hurt.png'),
  anxious('걱정', 'asset/emotion/anxiety.png');

  final String text;
  final String imagePath;
  const Emotion(this.text, this.imagePath);

  static Emotion fromString(String text) {
    return Emotion.values.firstWhere(
          (e) => e.text == text,
      orElse: () => Emotion.neutral,
    );
  }
}