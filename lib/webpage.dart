import 'dart:async';

import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'constants.dart';

class WebPage extends StatefulWidget {
  String url;

  WebPage({this.url});
  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    //Completer<WebViewController> _controller = Completer<WebViewController>();
    bool loading;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          title: Center(
              child: Text(
            'Flutter Restaurants',
            style: TextStyle(
              color: errorStateLightRed,
            ),
          )),
        ),
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (value) {
            print('started');
          },
          onPageFinished: (value) {
            print('ended');

            setState(() {
              loading = false;
            });
          },
        ),
      ),
    );
  }
}
