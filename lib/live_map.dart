import 'package:flutter/material.dart';
import 'package:tynerail_tracker/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LiveMapPage extends StatefulWidget {
  const LiveMapPage({super.key});

  @override
  _LiveMapPageState createState() => _LiveMapPageState();
  
}

class _LiveMapPageState extends State<LiveMapPage> {
  late WebViewController _controller;
  
  @override
  void initState() {
    super.initState();

    WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://metro-rti.nexus.org.uk/MapEmbedded')
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
