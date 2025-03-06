import 'package:flutter/material.dart';
import 'package:tynerail_tracker/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webpage extends StatefulWidget {
  const Webpage({super.key, required this.url});
  final String url;

  @override
  _WebpageState createState() => _WebpageState();
  
}

class _WebpageState extends State<Webpage> {
  late WebViewController _controller;
  
  @override
  void initState() {
    super.initState();

    WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url)
      );
    
    _controller = webViewController;
      
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      backgroundColor: AppColors.background,
      child: WebViewWidget(
        controller: _controller,
      ),
      );

    
  }

  //---------------------------------------------------------------//
  //               Put all Functions Below This Line               //
  //---------------------------------------------------------------//

    Future<void> _handleRefresh() async {
    // Trigger WebView refresh (reload the page)
    await _controller.reload();
  }
  
}
