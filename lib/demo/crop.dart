// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';

// class CropperScreen extends StatefulWidget {
//   File imageFile;
//   CropperScreen({Key? key, required this.imageFile}) : super(key: key);
  
//   @override
//   _CropperScreenState createState() => _CropperScreenState();
// }

// enum AppState {
//   free,
//   picked,
//   cropped,
// }

// class _CropperScreenState extends State<CropperScreen> {
//   late AppState state;

//   @override
//   void initState() {
//     super.initState();
//     state = AppState.free;
//   }

//    @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Cropped"),
//       ),
//       body: _cropImage();
//       ),
//     );
//   }

//   Widget _buildButtonIcon() {
//     if (state == AppState.free)
//       return Icon(Icons.add);
//     else if (state == AppState.picked)
//       return Icon(Icons.crop);
//     else if (state == AppState.cropped)
//       return Icon(Icons.clear);
//     else
//       return Container();
//   }

//   // Future<Null> _pickImage() async {
//   //   final pickedImage =
//   //       await ImagePicker().getImage(source: ImageSource.gallery);
//   //   imageFile = pickedImage != null ? File(pickedImage.path) : null;
//   //   if (imageFile != null) {
//   //     setState(() {
//   //       state = AppState.picked;
//   //     });
//   //   }
//   // }


//     if (croppedFile != null) {
//       imageFile = croppedFile;
//       setState(() {
//         state = AppState.cropped;
//       });
//     }
//   }

//   void _clearImage() {
//     imageFile = null;
//     setState(() {
//       state = AppState.free;
//     });
//   }
// }