import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/provider/language/get_text.dart';
import 'package:mn1/tools/container/custom_container.dart';
import 'package:mn1/tools/customText.dart';
import 'package:mn1/tools/msg_dialog.dart';

class CustomSelectImage extends StatefulWidget {
  final void Function(Uint8List? bytes)? bytes;
  final String initImage;

  const CustomSelectImage({super.key, this.bytes, this.initImage = ''});

  @override
  State<CustomSelectImage> createState() => _CustomSelectImageState();
}

class _CustomSelectImageState extends State<CustomSelectImage> {
  Uint8List? imageBytes;
  bool deletedInitImage = false;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        imageBytes = result.files.single.bytes;
        deletedInitImage = true;
      });
      widget.bytes?.call(imageBytes);
    }
  }

  void _deleteImage() {
    msgDialog(
      context1: context,
      state: 0,
      text: getText('delete_msg'),
      onClick: () {
        Navigator.pop(context);
        setState(() {
          imageBytes = null;
          deletedInitImage = true;
        });
        widget.bytes?.call(null);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNetworkImage =
        widget.initImage.isNotEmpty && !deletedInitImage;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomContainer(
          width: pageSizeWidth(context, 0.12),
          height: pageSizeHeight(context, 0.17),
          child: GestureDetector(
            onTap: imageBytes != null || hasNetworkImage
                ? _deleteImage
                : _pickImage,
            child: Builder(
              builder: (_) {
                if (imageBytes != null) {
                  return Image.memory(
                    imageBytes!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  );
                }

                if (hasNetworkImage) {
                  return Image.network(
                    widget.initImage,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 40),
                  );
                }

                return const Icon(Icons.add_a_photo_outlined, size: 50);
              },
            ),
          ),
        ),
        const SizedBox(height: 6),
        TEXT(text: getText('select_image'), size: 15, center: true),
      ],
    );
  }
}
