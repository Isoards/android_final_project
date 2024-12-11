class ReviewModel {
  final String id;
  final String reviewerId;
  final String targetId;
  final String content;
  final double rating;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.reviewerId,
    required this.targetId,
    required this.content,
    required this.rating,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      reviewerId: json['reviewer_id'],
      targetId: json['target_id'],
      content: json['content'],
      rating: json['rating'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
