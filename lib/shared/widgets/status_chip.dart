import 'package:flutter/material.dart';

import '../../core/constants/enums.dart';

/// A compact chip that visually represents a [SubmissionStatus].
/// Uses distinct background / foreground colours per status for at-a-glance
/// recognition without relying on colour alone (label is always shown).
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final SubmissionStatus status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (bg, fg) = _palette(status, cs);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 11,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // Returns (background, foreground) colour pair for each status.
  static (Color, Color) _palette(SubmissionStatus s, ColorScheme cs) =>
      switch (s) {
        SubmissionStatus.draft => (
            cs.surfaceVariant,
            cs.onSurfaceVariant,
          ),
        SubmissionStatus.pendingPic => (
            const Color(0xFFFFE0B2),
            const Color(0xFF7B4F00),
          ),
        SubmissionStatus.pendingFinance => (
            const Color(0xFFE8EAF6),
            const Color(0xFF1A237E),
          ),
        SubmissionStatus.approved => (
            const Color(0xFFE8F5E9),
            const Color(0xFF1B5E20),
          ),
        SubmissionStatus.rejected => (cs.errorContainer, cs.onErrorContainer),
        SubmissionStatus.revision => (
            const Color(0xFFF3E5F5),
            const Color(0xFF4A148C),
          ),
        SubmissionStatus.paid => (
            const Color(0xFF1565C0),
            Colors.white,
          ),
      };
}
