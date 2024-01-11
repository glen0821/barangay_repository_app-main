import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../containers/dialog/dialogs.dart';

class CoreImageVideoHolder extends StatefulWidget {
  final Function(File?) onComplaintMediaChanged;

  const CoreImageVideoHolder({
    Key? key,
    required this.onComplaintMediaChanged,
  }) : super(key: key);

  @override
  _CoreImageVideoHolderState createState() => _CoreImageVideoHolderState();
}

class _CoreImageVideoHolderState extends State<CoreImageVideoHolder> {
  File? _imageVideoFile;
  bool isImage = true;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;


  Future<void> _uploadComplaintImage() async {
    try {
      final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (imageFile == null) {
        return;
      }

      final complaintImageFile = File(imageFile.path);
      setState(() {
        _imageVideoFile = complaintImageFile;
        isImage = true;
      });

      widget.onComplaintMediaChanged(_imageVideoFile);
    } catch (error) {
      print('Error uploading profile image: $error');
    }
  }

  Future<void> _uploadComplaintVideo() async {
    try {
      final videoFile = await ImagePicker().pickVideo(source: ImageSource.gallery);

      if (videoFile == null) {
        return;
      }

      final complaintVideoFile = File(videoFile.path);
      setState(() {
        _imageVideoFile = complaintVideoFile;
        isImage = false;
      });

      widget.onComplaintMediaChanged(_imageVideoFile);
    } catch (error) {
      print('Error uploading video: $error');
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Widget _buildVideoPreview() {
    if (_imageVideoFile != null) {
      _videoPlayerController = VideoPlayerController.file(_imageVideoFile!);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        autoPlay: false,
        looping: false,
        allowedScreenSleep: false,
        allowFullScreen: true,
        fullScreenByDefault: false,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF50ACAA).withOpacity(0.3),
                width: 1, // Border width
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Container(
              height: 200,
              child: _imageVideoFile != null
                  ? Chewie(controller: _chewieController!)
                  : Container(), // Placeholder if no video
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildImagePreview() {
    return Image.file(
      _imageVideoFile!,
      width: 160,
      height: 160,
      fit: BoxFit.cover,
    );
  }

  Widget _buildDefaultPreview() {
    return Image.asset(
      'assets/avatar.png',
      width: 160,
      height: 160,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: _imageVideoFile != null
                ? isImage
                ? _buildImagePreview()
                : _buildVideoPreview()
                : _buildDefaultPreview(),
          ),
          Positioned(
            bottom: 0,
            right: 100,
            child: GestureDetector(
              onTap: () async {
                showMediaOptionDialog(context, (bool isImage) {
                  if (isImage) {
                    _uploadComplaintImage();
                  } else {
                    _uploadComplaintVideo();
                  }
                });
              },
              child: Container(
                width: 30,
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
      ),
    );
  }
}