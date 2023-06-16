import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

void showSnackBar(BuildContext context, String content, [Duration? duration]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration ?? const Duration(seconds: 4),
      content: Text(content),
    ),
  );
}

Future showCustomModalBottomSheet(BuildContext context, Widget content) {
  return showModalBottomSheet(
    isScrollControlled: true,
    constraints: const BoxConstraints(
      minWidth: double.infinity,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    context: context,
    builder: (context) {
      return content;
    },
  );
}

showLoadingIndicator({
  required BuildContext context,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 5,
            ),
          ),
        );
      });
}

String getNameFromEmail(String email) {
  return email.split('@')[0];
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  final ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage();
  if (imageFiles.isNotEmpty) {
    for (final image in imageFiles) {
      images.add(File(image.path));
    }
  }
  return images;
}

Future<File?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final imageFile = await picker.pickImage(
    source: ImageSource.gallery,
  );
  if (imageFile != null) {
    return File(imageFile.path);
  }
  return null;
}

String generateFileName(String someString) {
  final uuid = const Uuid().v4();
  return '$someString/$uuid';
}

String removeCharacterFromString(String string, String char) {
  return string.split(char).join('');
}

extension StringExtensions on String {
  readableDateFormat() {
    return DateFormat.yMMMMEEEEd('en_US')
        .add_Hm()
        .format(DateTime.parse(this))
        .toString();
  }
}
