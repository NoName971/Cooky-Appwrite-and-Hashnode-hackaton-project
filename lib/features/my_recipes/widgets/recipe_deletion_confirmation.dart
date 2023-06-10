import 'package:flutter/material.dart';
import 'package:hackaton_v1/common/custom_button.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/core/extensions.dart';

class RecipeDeletionConfirmationModal extends StatelessWidget {
  final void Function()? onDelete;
  const RecipeDeletionConfirmationModal({
    super.key,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: kBottomNavigationBarHeight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Are you sure to delete ?',
            style: context.h5,
          ).addFullPading(16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  buttonType: ButtonType.filled,
                  buttonSize: ButtonSize.medium,
                  onPressed: onDelete,
                  child: const Text('Delete'),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: CustomButton(
                  buttonType: ButtonType.outlined,
                  buttonSize: ButtonSize.medium,
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ).addHorizontalPadding(16)
        ],
      ),
    );
  }
}
