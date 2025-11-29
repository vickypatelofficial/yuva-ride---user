import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';

import 'package:video_player/video_player.dart';

class PreviewScreen extends StatefulWidget {
  final String? networkUrl;
  final File? localFile;

  const PreviewScreen({super.key, this.networkUrl, this.localFile});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  VideoPlayerController? _controller;

  bool get isVideo {
    final path = widget.networkUrl ?? widget.localFile!.path;
    return path.endsWith(".mp4") || path.endsWith(".mov");
  }

  @override
  void initState() {
    super.initState();

    if (isVideo) {
      _controller = widget.networkUrl != null
          ? VideoPlayerController.networkUrl(Uri.parse(widget.networkUrl!))
          : VideoPlayerController.file(widget.localFile!)
        ..initialize().then((_) {
          setState(() {});
          _controller!.play();
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNet = widget.networkUrl != null;

    return CustomScaffold(
      appBar: AppBar(title: Text("Preview")),
      body: Center(
        child: isVideo
            ? _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : CircularProgressIndicator()
            : isNet
                ? Image.network(widget.networkUrl!)
                : Image.file(widget.localFile!),
      ),
    );
  }
}
