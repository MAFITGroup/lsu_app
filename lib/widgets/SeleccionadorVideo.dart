import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../manejadores/Colores.dart';

class SeleccionadorVideo extends StatelessWidget {
  final File? file;
  final String? url;

  SeleccionadorVideo({this.file, this.url});

  @override
  Widget build(BuildContext context) {
    VideoPlayerController? _videoController;
    ChewieController? _chewieController;

    if (file != null) {
      _videoController = VideoPlayerController.file(file!);
    } else if (url != null) {
      _videoController = VideoPlayerController.network(url!);
    }

    if (_videoController != null) {
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        aspectRatio: 16 / 9, // You can customize the aspect ratio here
        autoPlay: true,
        looping: true,
        showControls: true,
        // Add more ChewieController configurations as needed
      );
    }

    return _chewieController != null
        ? Chewie(controller: _chewieController!)
        : Container(
      // Placeholder widget when there is no video to display
      child: Center(
        child: Icon(Icons.video_library_outlined,
            color: Colores().colorTextos, size: 150),
      ),
    );
  }

}
