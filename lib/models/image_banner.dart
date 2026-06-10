class ImageBanner {
  final int id;
  final String url;
  final int byId;
  final String time;
  final bool isActive;

  ImageBanner({
    required this.id,
    required this.url,
    required this.byId,
    required this.time,
    required this.isActive,
  });

  factory ImageBanner.fromJson(Map<String, dynamic> json) {
    return ImageBanner(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      byId: json['by_id'] ?? 0,
      time: json['time'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'by_id': byId,
      'time': time,
      'is_active': isActive,
    };
  }

  /// convert List<dynamic> to List<ImageBanner>
  static List<ImageBanner> fromList(List<dynamic> list) {
    return list
        .map((e) => ImageBanner.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
