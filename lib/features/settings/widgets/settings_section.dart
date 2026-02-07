import 'package:flutter/material.dart';
import '../../../core/theme/custom_colors.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: custom.nightLight,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: _buildChildrenWithDividers(theme),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildrenWithDividers(ThemeData theme) {
    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(Divider(
          height: 0.5,
          thickness: 0.5,
          indent: 60,
          color: theme.colorScheme.outline,
        ));
      }
    }
    return result;
  }
}
