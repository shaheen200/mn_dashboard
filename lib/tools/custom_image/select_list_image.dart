// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mn1/methods/page_size.dart';
import 'package:mn1/tools/container/custom_out_line_container.dart';
import 'package:mn1/tools/custom_image/custom_image.dart';
import 'package:mn1/tools/custom_image/custom_memory_image.dart';
import 'package:mn1/tools/custom_image/custom_network_image.dart';
import 'package:mn1/tools/custom_image/show_image_dialog.dart';

class SelectListImage extends StatefulWidget {
  final List<SelectListImageData> listImage;
  final void Function(List<SelectListImageData> listImage) selected;
  const SelectListImage({
    super.key,
    required this.listImage,
    required this.selected,
  });

  @override
  State<SelectListImage> createState() => _SelectListImageState();
}

class _SelectListImageState extends State<SelectListImage> {
  List<SelectListImageData> images = [];
  @override
  void initState() {
    images = widget.listImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.15,

      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: CustomOutLineContainer(
              margin: const EdgeInsets.all(7),
              pading: const EdgeInsets.all(10),
              width: 1,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(0),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showImageDialog(
                        context,
                        type: ShowImageDialogType.network,
                        url: images[index].path,
                      );
                    },
                    child: images[index].type == SelectListImagetype.network
                        ? CustomNetworkImage(
                            url: images[index].path,
                            w: pageSizeWidth(context, 0.1),
                            h: pageSizeHeight(context, 0.14),
                          )
                        : images[index].type == SelectListImagetype.assets
                        ? CustomImage(
                            path: images[index].path,
                            w: pageSizeWidth(context, 0.1),
                            h: pageSizeHeight(context, 0.14),
                          )
                        : CustomMemoryImage(
                            bytes: images[index].bytes,
                            w: pageSizeWidth(context, 0.1),
                            h: pageSizeHeight(context, 0.14),
                          ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: CustomOutLineContainer(
              margin: const EdgeInsets.all(7),
              pading: const EdgeInsets.all(10),
              width: 1,
              child: Center(
                child: IconButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                          allowMultiple: true,
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'png', 'jpeg'],
                        );
                    if (result != null) {
                      final path = result.files;
                      for (var element in path) {
                        images.add(
                          SelectListImageData(
                            type: SelectListImagetype.memory,
                            path: element.path!,
                            bytes: element.bytes!,
                          ),
                        );
                      }
                      widget.selected.call(images);
                      setState(() {});
                    }
                  },
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum SelectListImagetype { network, file, assets, memory }

class SelectListImageData {
  final String path;
  final Uint8List bytes;
  final SelectListImagetype type;
  const SelectListImageData({
    required this.type,
    required this.path,
    required this.bytes,
  });
}
