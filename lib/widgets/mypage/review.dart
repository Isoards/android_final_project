import 'package:flutter/material.dart';
import 'package:android_final_project/services/review_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewDialog extends StatefulWidget {
  final String targetId;
  final Function onReviewSubmitted;

  const ReviewDialog({
    Key? key,
    required this.targetId,
    required this.onReviewSubmitted,
  }) : super(key: key);

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final _contentController = TextEditingController();
  double _rating = 5.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('리뷰 작성'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1.0;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: '리뷰를 작성해주세요',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_contentController.text.isEmpty) return;

            final reviewService = ReviewService(Supabase.instance.client);
            await reviewService.createReview(
              targetId: widget.targetId,
              content: _contentController.text,
              rating: _rating,
            );

            widget.onReviewSubmitted();
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('작성완료'),
        ),
      ],
    );
  }
}
