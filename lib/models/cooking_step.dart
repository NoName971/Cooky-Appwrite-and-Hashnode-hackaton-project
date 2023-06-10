import 'package:flutter/material.dart';

class CookingStep {
  final String attachment;
  final TextEditingController instructions;
  CookingStep({
    required this.attachment,
    required this.instructions,
  });

  CookingStep copyWith({
    String? attachment,
    TextEditingController? instructions,
  }) {
    return CookingStep(
      attachment: attachment ?? this.attachment,
      instructions: instructions ?? this.instructions,
    );
  }
}
