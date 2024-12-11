import 'package:android_final_project/models/review_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewService {
  final SupabaseClient _supabaseClient;

  ReviewService(this._supabaseClient);

  Future<void> createReview({
    required String targetId,
    required String content,
    required double rating,
  }) async {
    await _supabaseClient.from('reviews').insert({
      'reviewer_id': _supabaseClient.auth.currentUser!.id,
      'target_id': targetId,
      'content': content,
      'rating': rating,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<ReviewModel>> getReviewsForUser(String userId) async {
    final response = await _supabaseClient
        .from('reviews')
        .select()
        .eq('target_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((review) => ReviewModel.fromJson(review))
        .toList();
  }
}
