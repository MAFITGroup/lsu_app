import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class SeleccionadorVideo extends StatefulWidget {
  final File file;

  const SeleccionadorVideo(this.file);

  @override
  SeleccionadorVideoState createState() => SeleccionadorVideoState();
}


class SeleccionadorVideoState extends State<SeleccionadorVideo> {
  VideoPlayerController _controladorDeVideo;
  bool _enReproduccion = false;
  Color _colorAzul = Colors.blue;

  Widget videoStatusAnimation;

  @override
  void initState() {
    super.initState();

    videoStatusAnimation = Container();

    _controladorDeVideo = VideoPlayerController.file(widget.file)
      ..addListener(() {
        final bool enReproduccion = _controladorDeVideo.value.isPlaying;
        if (enReproduccion != _enReproduccion) {
          setState(() {
            _enReproduccion = enReproduccion;
          });
        }
      })
      ..initialize().then((_) {
        Timer(Duration(milliseconds: 0), () {
          if (!mounted) return;

          setState(() {});
          // INICIO EL VIDEO EN PLAY
          _controladorDeVideo.play();
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controladorDeVideo.dispose();
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 4 / 3,
        child: _controladorDeVideo.value.isInitialized
            ? videoPlayer()
            : Container(),
      );

  Widget videoPlayer() => Stack(
        children: <Widget>[
          video(),
          Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgressIndicator(
              _controladorDeVideo,
              allowScrubbing: true,
              colors: VideoProgressColors(playedColor: _colorAzul),
              padding: EdgeInsets.all(16.0),
            ),
          ),
          Center(child: videoStatusAnimation),
        ],
      );

  Widget video() => GestureDetector(
        child: VideoPlayer(_controladorDeVideo),
        onTap: () {
          if (!_controladorDeVideo.value.isInitialized) {
            return;
          }
          if (_controladorDeVideo.value.isPlaying) {
            videoStatusAnimation =
                FadeAnimation(child: const Icon(Icons.pause, size: 100.0));
            _controladorDeVideo.pause();
          } else {
            videoStatusAnimation =
                FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
            _controladorDeVideo.play();
          }
        },
      );
}

class FadeAnimation extends StatefulWidget {
  const FadeAnimation(
      {this.child, this.duration = const Duration(milliseconds: 1000)});

  final Widget child;
  final Duration duration;

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => animationController.isAnimating
      ? Opacity(
          opacity: 1.0 - animationController.value,
          child: widget.child,
        )
      : Container();
}
