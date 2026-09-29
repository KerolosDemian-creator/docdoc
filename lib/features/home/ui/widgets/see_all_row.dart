import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';

class SeeAllRow extends StatelessWidget {
  const SeeAllRow({
    super.key,
    required this.seeAllRowTitle,
    this.seeAllRowTitleStyle,
  });
  final String seeAllRowTitle;
  final TextStyle? seeAllRowTitleStyle;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          seeAllRowTitle,
          style: seeAllRowTitleStyle ?? AppTextStyles.font18DarkBlue600W,
        ),
        Spacer(),
        Text('See All', style: AppTextStyles.font12MainBlue400W),
      ],
    );
  }
}
