import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key});

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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),

        TextButton.icon(onPressed: pickedImage,
          label:Text('Add Image',style: TextStyle(color: Theme.of(context).primaryColor),),
          icon: const Icon(Icons.image),)
      ],
    );
  }
}
