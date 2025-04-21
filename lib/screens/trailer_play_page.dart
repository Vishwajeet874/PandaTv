import 'package:flutter/material.dart';
import 'package:panda_tv/utils/modified_text.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome

class TrailerPlayerPage extends StatefulWidget {
  final String youtubeVideoId;

  const TrailerPlayerPage({super.key, required this.youtubeVideoId});

  @override
  _TrailerPlayerPageState createState() => _TrailerPlayerPageState();
}

class _TrailerPlayerPageState extends State<TrailerPlayerPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Set preferred orientations to landscape and fullscreen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
          Uri.parse('https://www.youtube.com/embed/${widget.youtubeVideoId}'));
  }

  @override
  void dispose() {
    // Reset preferred orientations when the page is disposed
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
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
