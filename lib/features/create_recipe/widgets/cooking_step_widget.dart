import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/core/extensions.dart';
import '../../../common/custom_image_icon.dart';
import '../../../common/custom_list_tile.dart';
import '../../../common/custom_textfield.dart';
import '../../../common/network_image_widget.dart';
import '../../../core/utils.dart';
import '../../../gen/assets.gen.dart';
import '../controller/recipe_creation_controller.dart';
import '../views/image_preview.dart';
import '../views/recipe_creation_view.dart';

class CookingStepWidget extends StatelessWidget {
  const CookingStepWidget({
    super.key,
    required this.textTheme,
    required this.ref,
    required this.cookingStep,
    required this.cookingStepNumber,
  });

  final TextTheme textTheme;

  final WidgetRef ref;
  final CookingStep cookingStep;
  final int cookingStepNumber;

  @override
  Widget build(BuildContext context) {
    final cookingSteps = ref.watch(cookingStepsProvider);
    final List<CookingStep> steps = ref.watch(cookingStepsProvider);
    final cookingCreationController =
        ref.watch(recipeCreationProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                maxRadius: 12,
                child: Text('$cookingStepNumber', style: context.h6),
              ),
              IconButton(
                onPressed: () {},
                icon: PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      onTap: () {
                        final cookingStep = CookingStep(
                          attachment: '',
                          instructions: TextEditingController(),
                        );
                        ref.read(cookingStepsProvider.notifier).state = [
                          ...cookingSteps,
                          cookingStep
                        ];
                        SchedulerBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          ref
                              .read(scrollControllerProvider.notifier)
                              .state
                              .animateTo(
                                ref
                                    .read(scrollControllerProvider.notifier)
                                    .state
                                    .position
                                    .maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                        });
                      },
                      child: const CustomListTile(
                        title: Text('Add new step'),
                        leading: Icon(Icons.add),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        int currentStepIndex = steps.indexOf(cookingStep);
                        steps.removeAt(currentStepIndex);
                        ref.read(cookingStepsProvider.notifier).update((state) {
                          return [...steps];
                        });
                      },
                      value: 2,
                      child: const CustomListTile(
                        title: Text('Delete'),
                        leading: Icon(Icons.delete),
                      ),
                    ),
                  ],
                  elevation: 2,
                  child: const Icon(Icons.more_horiz),
                ),
              ),
            ],
          ),
          CustomListTile(
            title: CustomTextField(
              maxlines: null,
              controller: cookingStep.instructions,
              hintText: 'E.g. Chop onions in little pieces',
              validator: (value) {
                if (value == null || value.length < 20) {
                  return "20 characters minimum";
                }
                return null;
              },
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  Visibility(
                    visible: cookingStep.attachment.isEmpty,
                    replacement: GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        height: 140,
                        width: 180,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: NetworkImageWidget(
                          imageId: cookingStep.attachment,
                          height: 70,
                          width: 90,
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        //pick an image

                        final image = await pickImage();

                        //get the current index of the step

                        int currentStepIndex =
                            cookingSteps.indexOf(cookingStep);

                        //upload the image and get the id back

                        final imageId =
                            await cookingCreationController.uploadAttachment(
                          index: '${currentStepIndex}_',
                          fileName:
                              generateFileName(currentStepIndex.toString()),
                          filePath: image!.path,
                        );

                        //update the curent step attachment

                        cookingSteps[currentStepIndex] =
                            steps[currentStepIndex].copyWith(
                          attachment: imageId,
                        );

                        //update the cookings step list

                        ref
                            .watch(cookingStepsProvider.notifier)
                            .update((state) {
                          return [...steps];
                        });
                      },
                      child: Container(
                        height: 70,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade300,
                        ),
                        child: CustomImageIcon(
                          color: Colors.grey.shade700,
                          iconPath: Assets.icons.photoPicker.path,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ).addHorizontalPadding(16),
    );
  }

  Future<dynamic> newMethod(BuildContext context, String e) {
    List<CookingStep> cookingSteps = ref.watch(cookingStepsProvider);
    int currentStepIndex = cookingSteps.indexOf(cookingStep);
    CookingStep currentStep = cookingSteps[currentStepIndex];
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomListTile(
                  leading: const Icon(Icons.visibility),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ImagePreviewView(imagePath: e),
                      ),
                    );
                  },
                  title: const Text('Preview'),
                ),
                CustomListTile(
                  leading: const Icon(Icons.refresh),
                  onTap: () async {
                    Navigator.pop(context);

                    //delete the image from api

                    await ref
                        .read(recipeCreationProvider.notifier)
                        .deleteAttachment(e);

                    //pick an image from storage

                    final image = await pickImage();

                    //upload the image and get the id back

                    final imageId = await ref
                        .read(recipeCreationProvider.notifier)
                        .uploadAttachment(
                          index: '${currentStepIndex}_',
                          fileName:
                              generateFileName(currentStepIndex.toString()),
                          filePath: image!.path,
                        );

                    currentStep = currentStep.copyWith(attachment: imageId);
                    ref.read(cookingStepsProvider.notifier).update((state) {
                      return [...cookingSteps];
                    });
                  },
                  title: const Text('Change'),
                ),
                CustomListTile(
                  leading: const Icon(Icons.delete),
                  onTap: () {
                    currentStep = currentStep.copyWith(attachment: '');
                    ref
                        .read(recipeCreationProvider.notifier)
                        .deleteAttachment(e);
                    ref.read(cookingStepsProvider.notifier).update((state) {
                      return [...cookingSteps];
                    });
                    Navigator.pop(context);
                  },
                  title: const Text('Remove'),
                ),
              ],
            ),
          );
        });
  }
}
