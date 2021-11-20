import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class SeleccionadorVideo extends StatefulWidget {
  final File file;
  final String url;

  const SeleccionadorVideo(this.file, this.url);

  @override
  SeleccionadorVideoState createState() => SeleccionadorVideoState();
}

class SeleccionadorVideoState extends State<SeleccionadorVideo> {
  VideoPlayerController _controladorDeVideo;
  ChewieController chewieController;
  Chewie playerWidget;

  @override
  void initState() {
    super.initState();

    if (widget.file != null) {
      chewieController = ChewieController(
        aspectRatio: kIsWeb ? 16 / 9 : 4 / 3,
        allowMuting: true,
        autoPlay: true,
        looping: true,
        showControls: true,
        showControlsOnInitialize: true,
        showOptions: true,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        placeholder: Container(
          color: Colors.black,
        ),
        videoPlayerController: _controladorDeVideo =
            VideoPlayerController.file(widget.file),
      );

      /*
      Uso tanto para reproductor web, como para visualizador de senias
       */
    } else if (widget.url != null) {
      chewieController = ChewieController(
          aspectRatio: kIsWeb ? 16 / 9 : 4 / 3,
          allowMuting: true,
          autoPlay: true,
          looping: true,
          showControls: true,
          showControlsOnInitialize: true,
          showOptions: true,
          allowFullScreen: false,
          deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
          placeholder: Container(
            color: Colors.black,
          ),
          videoPlayerController: _controladorDeVideo =
              VideoPlayerController.network(widget.url));
    }
  }

  @override
  void dispose() {
    super.dispose();
    chewieController.dispose();
    _controladorDeVideo.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Chewie(
        controller: chewieController,
      ),
    );
  }
}
