import 'package:flutter/material.dart';
import 'package:tynerail_tracker/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ServiceStatusPage extends StatefulWidget {
  const ServiceStatusPage({super.key});

  @override
  _ServiceStatusPageState createState() => _ServiceStatusPageState();
  
}

class _ServiceStatusPageState extends State<ServiceStatusPage> {
  late WebViewController _controller;
  
  @override
  void initState() {
    super.initState();

    WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.nexus.org.uk/metro/app_menu/service-status')
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
