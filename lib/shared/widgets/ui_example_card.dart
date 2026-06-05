import 'package:flutter/material.dart';
import '../../core/models/ui_example_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class UIExampleCard extends StatelessWidget {
  final UIExampleModel example;
  final VoidCallback onTap;

  const UIExampleCard({
    super.key,
    required this.example,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: AppConstants.shadowBlurRadius,
            offset: const Offset(0, AppConstants.shadowOffset),
          ),
        ],
      ),
      child: Card(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppConstants.largePadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              gradient: LinearGradient(
                colors: [
                  example.color.withValues(alpha: 0.1),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                _buildIcon(),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(child: _buildContent(context)),
                const SizedBox(width: AppConstants.smallPadding),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: AppConstants.arrowIconSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.smallPadding + 4),
      decoration: BoxDecoration(
        color: example.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppConstants.containerBorderRadius),
      ),
      child: Icon(
        example.icon,
        color: example.color,
        size: AppConstants.iconSize,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                example.title,
                style: AppTheme.titleStyle,
              ),
            ),
            if (example.isNew) _buildNewBadge(),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          example.subtitle,
          style: AppTheme.subtitleStyle,
        ),
      ],
    );
  }

  Widget _buildNewBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.newBadgeColor,
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
      ),
      child: Text(
        AppConstants.newBadgeText,
        style: AppTheme.badgeTextStyle,
      ),
    );
  }
}
