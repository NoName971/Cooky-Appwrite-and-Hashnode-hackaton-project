import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/common/appbar.dart';
import 'package:hackaton_v1/common/custom_button.dart';
import 'package:hackaton_v1/common/custom_image_icon.dart';
import 'package:hackaton_v1/common/custom_list_tile.dart';
import 'package:hackaton_v1/common/custom_textfield.dart';
import 'package:hackaton_v1/common/network_image_widget.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/controllers/recipe_creation_controller.dart';
import 'package:hackaton_v1/helpers/extensions.dart';
import 'package:hackaton_v1/helpers/utils.dart';
import 'package:hackaton_v1/features/create_recipe/views/image_preview.dart';
import 'package:hackaton_v1/features/create_recipe/widgets/cooking_step_widget.dart';
import 'package:hackaton_v1/features/create_recipe/widgets/new_recipe_textfield.dart';
import 'package:hackaton_v1/features/create_recipe/widgets/textfield_label_widget.dart';
import 'package:hackaton_v1/gen/assets.gen.dart';
import 'package:hackaton_v1/main.dart';
import 'package:hackaton_v1/models/cooking_step.dart';
import 'package:hackaton_v1/models/recipe_model.dart';

final ingredientsProvider = StateProvider.autoDispose<List<String>>((ref) {
  return [];
});

final newIngredientTextEditingControllerProvider =
    StateProvider.autoDispose((ref) {
  return TextEditingController();
});

final titleProvider = StateProvider.autoDispose((ref) {
  return TextEditingController();
});

final cookingTimeProvider = StateProvider.autoDispose((ref) {
  return TextEditingController();
});

final descriptionProvider = StateProvider.autoDispose((ref) {
  return TextEditingController();
});

final mainPictureProvider = StateProvider.autoDispose((ref) {
  return '';
});

final cookingStepsProvider = StateProvider.autoDispose((ref) {
  return <CookingStep>[];
});

final scrollControllerProvider = StateProvider.autoDispose((ref) {
  return ScrollController();
});

class EditRecipe extends ConsumerStatefulWidget {
  final RecipeModel recipeModel;
  static route(RecipeModel recipeModel) => MaterialPageRoute(
        builder: (context) => EditRecipe(
          recipeModel: recipeModel,
        ),
      );
  const EditRecipe({super.key, required this.recipeModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditRecipeState();
}

class _EditRecipeState extends ConsumerState<EditRecipe> {
  void setData() {
    ref.read(ingredientsProvider.notifier).update(
          (state) => widget.recipeModel.ingredients,
        );
    ref.read(titleProvider.notifier).update(
          (state) => TextEditingController(text: widget.recipeModel.title),
        );
    ref.read(cookingTimeProvider.notifier).update(
          (state) => TextEditingController(
            text: widget.recipeModel.cookingTime,
          ),
        );
    ref.read(descriptionProvider.notifier).update(
          (state) => TextEditingController(
            text: widget.recipeModel.description,
          ),
        );
    ref.read(mainPictureProvider.notifier).update(
          (state) => widget.recipeModel.illustrationPic,
        );

    ref.read(cookingStepsProvider.notifier).update(
      (state) {
        List<CookingStep> cookingSteps = [];
        final cookingStepsPics = widget.recipeModel.cookingStepsPics;
        final instructions = widget.recipeModel.cookingSteps;
        for (int index = 0; index < instructions.length; index++) {
          cookingSteps.add(
            CookingStep(
              attachment: cookingStepsPics[index],
              instructions: TextEditingController(text: instructions[index]),
            ),
          );
        }

        return [...cookingSteps];
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      setData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cookingSteps = ref.watch(cookingStepsProvider);
    final scrollController = ref.watch(scrollControllerProvider);
    final mainPic = ref.watch(mainPictureProvider);
    final titleTextEditingController = ref.watch(titleProvider);
    final descriptionTextEditingController = ref.watch(descriptionProvider);
    final cookingTimeTextEditingController = ref.watch(cookingTimeProvider);
    List<String> ingredients = ref.watch(ingredientsProvider);
    final isLoading = ref.watch(recipeCreationProvider);

    ref.listen(recipeCreationProvider.select((value) => value),
        (previous, next) {
      if (next) {
        showLoadingIndicator(
          context: context,
        );
      } else if (!next) {
        Navigator.pop(context);
      }
    });
    return Scaffold(
      appBar: appBar(const Text('Edit recipe'), true, [
        TextButton(
          onPressed: () async {
            FocusScope.of(context).unfocus();
            if (mainPic.isEmpty) {
              showSnackBar(context, 'Picture is required.');
            } else if (ingredients.length < 2) {
              showSnackBar(context, 'At least 2 ingredients are required.');
            } else if (cookingSteps.length < 2) {
              showSnackBar(context, 'At least 2 steps are required.');
            } else {
              final validation = _formKey.currentState!.validate();
              if (validation) {
                List<String> cookingStepsDirections = [];
                for (final instruction in cookingSteps) {
                  cookingStepsDirections.add(instruction.instructions.text);
                }

                final attachments =
                    cookingSteps.map((e) => e.attachment).toList();
                final recipe = RecipeModel(
                  userName: ref.watch(globalCurrentUserProvider).name,
                  id: widget.recipeModel.id,
                  uid: widget.recipeModel.uid,
                  title: titleTextEditingController.text,
                  description: descriptionTextEditingController.text,
                  illustrationPic: mainPic,
                  ingredients: ingredients,
                  cookingTime: cookingTimeTextEditingController.text,
                  cookingSteps: cookingStepsDirections,
                  cookingStepsPics: attachments,
                  likes: 0,
                );
                await ref.read(recipeCreationProvider.notifier).updateRecipe(
                      recipeModel: recipe,
                      context: context,
                    );
              } else {
                showSnackBar(context, 'Please fill all required fields.');
              }
            }
          },
          child: Text(
            'Update',
            style: context.h4,
          ),
        ),
      ]),
      body: WillPopScope(
        onWillPop: () async {
          if (isLoading) {
            return false;
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const FittedBox(
                  child: Text('Are you sure to go back?'),
                ),
                content: const Text('All changes will be lost.'),
                actions: [
                  CustomButton(
                    buttonType: ButtonType.outlined,
                    buttonSize: ButtonSize.small,
                    child: const FittedBox(child: Text('Cancel')),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CustomButton(
                    buttonType: ButtonType.filled,
                    buttonSize: ButtonSize.small,
                    child: const FittedBox(child: Text('Confirm')),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
            return true;
          }
        },
        child: LayoutBuilder(builder: (context, constraints) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewPadding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFieldLabel(
                    textTheme: textTheme,
                    label: 'Picture',
                  ).addHorizontalPadding(16),
                  const SizedBox(
                    height: 8,
                  ).addHorizontalPadding(16),
                  Visibility(
                    visible: mainPic.isNotEmpty,
                    replacement: GestureDetector(
                      onTap: () async {
                        final image = await pickImage();
                        final imageId = await ref
                            .read(recipeCreationProvider.notifier)
                            .uploadAttachment(
                              fileName: generateFileName('mainPic'),
                              filePath: image!.path,
                            );
                        ref.read(mainPictureProvider.notifier).update((_) {
                          return imageId;
                        });
                      },
                      child: Container(
                        height: 250,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade300,
                        ),
                        child: Center(
                          child: CustomImageIcon(
                            iconPath: Assets.icons.photoPicker.path,
                            color: Colors.grey.shade700,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        updateAttachment(
                          assetPath: mainPic,
                          context: context,
                          onDelete: () {
                            Navigator.pop(context);
                            ref
                                .read(mainPictureProvider.notifier)
                                .update((state) {
                              return '';
                            });
                          },
                          onChange: () async {
                            Navigator.pop(context);
                            final image = await pickImage();
                            final imageId = await ref
                                .read(recipeCreationProvider.notifier)
                                .uploadAttachment(
                                  fileName: generateFileName('mainPic'),
                                  filePath: image!.path,
                                );
                            ref.read(mainPictureProvider.notifier).update((_) {
                              return imageId;
                            });
                          },
                        );
                      },
                      child: NetworkImageWidget(
                        imageId: mainPic,
                        height: 250,
                        width: double.infinity,
                      ),
                    ),
                  ).addHorizontalPadding(16),
                  const SizedBox(
                    height: 16,
                  ),
                  NewRecipeTextField(
                    maxLength: 100,
                    validator: (value) {
                      if (value == null || value.length < 10) {
                        return '10 characters minimum';
                      }
                      return null;
                    },
                    textTheme: textTheme,
                    label: 'Title',
                    hintText: 'E.g. Garba',
                    maxLines: 1,
                    textEditingController: titleTextEditingController,
                  ).addHorizontalPadding(16),
                  const SizedBox(
                    height: 16,
                  ),
                  NewRecipeTextField(
                    textTheme: textTheme,
                    maxLength: 200,
                    textEditingController: descriptionTextEditingController,
                    label: 'Description',
                    maxLines: null,
                    hintText: 'E.g. A loved ivorian meal...',
                    validator: (value) {
                      if (value == null || value.length < 10) {
                        return '10 characters minimum';
                      }
                      return null;
                    },
                  ).addHorizontalPadding(16),
                  const SizedBox(
                    height: 16,
                  ),
                  NewRecipeTextField(
                    maxLength: 10,
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.length < 3) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onTap: () async {
                      var resultingDuration = await showDurationPicker(
                        snapToMins: 5,
                        context: context,
                        initialTime: const Duration(minutes: 30),
                      );
                      cookingTimeTextEditingController.text =
                          '${resultingDuration!.inMinutes} min';
                    },
                    textTheme: textTheme,
                    textEditingController: cookingTimeTextEditingController,
                    label: 'Cooking time',
                    maxLines: 1,
                    hintText: 'E.g. 45min',
                  ).addHorizontalPadding(16),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFieldLabel(
                    textTheme: textTheme,
                    label: 'Ingredients (${ingredients.length})',
                  ).addHorizontalPadding(16),
                  const SizedBox(
                    height: 8,
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            addNewIngredient(context, ingredients);
                          },
                          child: const Chip(
                            label: Text('Add new'),
                            avatar: Icon(Icons.add),
                          ),
                        ),
                      ),
                      ...ingredients.map(
                        (ingredient) {
                          return Chip(
                            onDeleted: () {
                              ingredients.remove(ingredient);
                              ref.read(ingredientsProvider.notifier).state = [
                                ...ingredients
                              ];
                            },
                            label: Text(ingredient),
                            deleteIcon: const Icon(Icons.close),
                          );
                        },
                      ).toList()
                    ],
                  ).addHorizontalPadding(16),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFieldLabel(
                    textTheme: textTheme,
                    label: 'Steps (${cookingSteps.length})',
                  ).addHorizontalPadding(16),
                  const SizedBox(
                    height: 16,
                  ),
                  ReorderableListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      CookingStep cookingStep = cookingSteps[index];
                      return GestureDetector(
                        key: ValueKey(cookingStep.hashCode + index),
                        child: CookingStepWidget(
                          provider: cookingStepsProvider,
                          cookingStepNumber: index + 1,
                          cookingStep: cookingStep,
                          ref: ref,
                          textTheme: textTheme,
                        ),
                      );
                    },
                    itemCount: cookingSteps.length,
                    onReorder: (oldIndex, newIndex) {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      CookingStep currentStep =
                          cookingSteps.elementAt(oldIndex);
                      cookingSteps
                        ..remove(currentStep)
                        ..insert(newIndex, currentStep);
                      ref.read(cookingStepsProvider.notifier).update((state) {
                        return [...cookingSteps];
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: CustomButton(
                      buttonType: ButtonType.filledIcon,
                      buttonSize: ButtonSize.medium,
                      icon: CustomImageIcon(iconPath: Assets.icons.add.path),
                      onPressed: () {
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
                      child: const Text('Add step'),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<dynamic> addNewIngredient(
    BuildContext context,
    List<String> ingredients,
  ) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        context: context,
        builder: (context) {
          final controller =
              ref.watch(newIngredientTextEditingControllerProvider);
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              right: 16,
              left: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  MediaQuery.of(context).viewPadding.bottom +
                  20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        autoFocus: true,
                        hintText: 'e.g. 200g rice',
                        controller: controller,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                        ref.read(ingredientsProvider.notifier).state = [
                          controller.text,
                          ...ingredients,
                        ];
                        controller.clear();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  updateAttachment({
    required BuildContext context,
    required String assetPath,
    void Function()? onDelete,
    void Function()? onChange,
  }) async {
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
                      builder: (_) => ImagePreviewView(imagePath: assetPath),
                    ),
                  );
                },
                title: const Text('Preview'),
              ),
              CustomListTile(
                leading: const Icon(Icons.refresh),
                onTap: onChange,
                title: const Text('Change'),
              ),
              CustomListTile(
                leading: const Icon(Icons.delete),
                onTap: onDelete,
                title: const Text('Remove'),
              ),
            ],
          ),
        );
      },
    );
  }
}
