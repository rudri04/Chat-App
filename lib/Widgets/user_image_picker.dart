import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key,required this.onPickedImage});
  final void Function(File pickedImage) onPickedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;
  void pickedImage()async{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 50,maxWidth: 140);

    // THIS METHOD IS DONE IN COURSE
    if(pickedImage == null){
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickedImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         InkWell(
           onTap: pickedImage,
           child: CircleAvatar(
            radius: 40,
            foregroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile!) : const AssetImage('Assets/Images/images.png'),
                   ),
         ),
      ],
    );
  }
}
