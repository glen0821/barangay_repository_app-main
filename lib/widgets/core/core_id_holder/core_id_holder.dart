// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, unnecessary_new, non_constant_identifier_names, library_private_types_in_public_api

import 'dart:io';
import 'package:barangay_repository_app/global/responsive_sizing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barangay_repository_app/constants/colors.dart';
import 'package:image_picker/image_picker.dart';

class CoreIdHolder extends StatefulWidget {
  final Function(File?) onIdImageChanged;
  const CoreIdHolder(
      {Key? key,
        required this.onIdImageChanged,
      }) : super(key: key);
  @override
  _CoreIdHolderState createState() => _CoreIdHolderState();
}

class _CoreIdHolderState extends State<CoreIdHolder> {
  final FocusNode _focusNode = FocusNode();
  // String _idImageUrl = '';
  // String? _idImageUrl;
  File? _idImageFile;

  Future<void> _uploadProfileImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        return;
      }
      final profileImageFile = File(pickedFile.path);
      setState(() {
        _idImageFile = profileImageFile;
      });

      widget.onIdImageChanged(_idImageFile);
    } catch (error) {
      print('Error uploading profile image: $error');
    }
  }

  Future<void> _uploadProfileVideo() async {
    try {
      final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);

      if (pickedFile == null) {
        return;
      }

      final mediaFile = File(pickedFile.path);
      // Handle the video file as needed
    } catch (error) {
      print('Error uploading video: $error');
    }
  }



  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

    @override
    Widget build(BuildContext context) {
      ResponsiveSizing responsiveSizing = new ResponsiveSizing(context);
      return SizedBox(
          width: responsiveSizing.calc_width(365),// 311 original
          child:  Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image(
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                  image: _idImageFile != null
                      ? FileImage(_idImageFile!)
                      : AssetImage('assets/avatar.png') as ImageProvider<Object>,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 100,
                child: GestureDetector(
                  onTap: _uploadProfileImage,
                  child: Container(
                    width:
                    30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: const Color(0xFF00695C),
                    ),
                  ),
                ),
              )
            ],
          ));
    }
  }
