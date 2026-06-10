class GoodImage {
  final int id;
  final String url;
  final String time;
  final int byId;
  final int goodId;

  GoodImage({
    required this.id,
    required this.url,
    required this.time,
    required this.byId,
    required this.goodId,
  });

  factory GoodImage.fromMap(Map<String, dynamic> json) {
    return GoodImage(
      id: json['id'] as int,
      url: json['url'] as String,
      time: json['time'].toString(),
      byId: json['by_id'] as int,
      goodId: json['good_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'time': time,
      'by_id': byId,
      'good_id': goodId,
    };
  }

  static List<GoodImage> fromList(List<dynamic> list) {
    return list
        .map((e) => GoodImage.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
