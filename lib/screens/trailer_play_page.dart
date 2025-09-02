import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import '../utils/modified_text.dart';

class TrailerPlayPage extends StatefulWidget {
  final String youtubeVideoId;

  const TrailerPlayPage({super.key, required this.youtubeVideoId});

  @override
  State<TrailerPlayPage> createState() => _TrailerPlayPageState();
}

class _TrailerPlayPageState extends State<TrailerPlayPage> {
  late final PlatformWebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Set preferred orientations to landscape and fullscreen
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    _controller = PlatformWebViewController(
      const PlatformWebViewControllerCreationParams(),
    )..loadRequest(
        LoadRequestParams(
          uri: Uri.parse(
              'https://www.youtube.com/embed/${widget.youtubeVideoId}'),
        ),
      );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ModifiedText(text: 'PandaTv', size: 26, color: Colors.black),
      ),
      body: SafeArea(
        top: true,
        child: PlatformWebViewWidget(
          PlatformWebViewWidgetCreationParams(controller: _controller),
        ).build(context),
      ),
    );
  }
}
