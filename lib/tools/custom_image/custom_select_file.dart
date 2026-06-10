import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

enum SelectFileType { imageOnly, fileOnly, all }

class CustomSelectFile extends StatefulWidget {
  final Function(PlatformFile? p0)? onFileSelected;
  final SelectFileType type;

  const CustomSelectFile({
    super.key,
    this.onFileSelected,
    this.type = SelectFileType.imageOnly,
  });

  @override
  State<CustomSelectFile> createState() => _CustomSelectFileState();
}

class _CustomSelectFileState extends State<CustomSelectFile> {
  PlatformFile? selectedFile;

  Future<void> pickFile() async {
    FileType fileType;
    List<String>? allowedExtensions;

    switch (widget.type) {
      case SelectFileType.imageOnly:
        fileType = FileType.image;
        break;

      case SelectFileType.fileOnly:
        fileType = FileType.custom;
        allowedExtensions = ['pdf', 'doc', 'docx', 'xls', 'xlsx'];
        break;

      case SelectFileType.all:
        fileType = FileType.any;
        break;
    }

    final result = await FilePicker.platform.pickFiles(
      type: fileType,
      allowedExtensions: allowedExtensions,
      withData: true, // مهم للويب
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });

      widget.onFileSelected?.call(selectedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedFile != null;

    String text;
    IconData icon;

    if (!isSelected) {
      text = widget.type == SelectFileType.imageOnly
          ? "اختر صورة"
          : widget.type == SelectFileType.fileOnly
          ? "اختر ملف"
          : "اختر ملف";
      icon = Icons.upload_file;
    } else {
      text = widget.type == SelectFileType.imageOnly
          ? "تم اختيار الصورة"
          : "تم اختيار الملف";
      icon = Icons.check_circle;
    }

    return InkWell(
      onTap: pickFile,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 180,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: isSelected ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.green : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
