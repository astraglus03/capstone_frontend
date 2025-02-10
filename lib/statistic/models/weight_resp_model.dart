class WeightRespModel {
  final double weight;

  WeightRespModel({
    required this.weight,
  });
  factory WeightRespModel.fromJson(Map<String, dynamic> json) {
    return WeightRespModel(
      weight: json['weight'],
    );
  }
}
