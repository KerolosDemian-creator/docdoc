import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';

class SeeAllRow extends StatelessWidget {
  const SeeAllRow({
    super.key,
    required this.title,
    this.actionLabel = 'See All',
    this.onAction,
    this.showAction = true,
  });

  final String title;
  final String actionLabel;
  final VoidCallback? onAction;
  final bool showAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.font18DarkBlue600W,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (showAction)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel,
              style: AppTextStyles.font12MainBlue400W,
            ),
          ),
      ],
    );
  }
}
