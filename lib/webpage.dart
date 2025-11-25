import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webpage extends StatefulWidget {
  Webpage({super.key, required this.url});
  final String url;

  @override
  _WebpageState createState() => _WebpageState();
  
}

class _WebpageState extends State<Webpage> {
  late WebViewController _webController;
  bool _isLoading = true; // Track loading state
  bool _initialized = false; // Prevent multiple initializations
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _webController),
        if (_isLoading)
          Container(
            color: ColorScheme.of(context).surface.withAlpha(135), // Semi-transparent overlay
            child: const Center(
              child: CircularProgressIndicator(), // Loading spinner
            ),
          ),
      ],
    );
  }

  //---------------------------------------------------------------//
  //               Put all Functions Below This Line               //
  //---------------------------------------------------------------//

  // Function to initalise the webview instance.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final Color bgColor = ColorScheme.of(context).surface;

      _webController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(bgColor) // Set theme-based background
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              setState(() => _isLoading = true);
            },
            onPageFinished: (String url) {
              setState(() => _isLoading = false);
            },
            onNavigationRequest: (request) => NavigationDecision.prevent,
          ),
        )
        ..loadRequest(Uri.parse(widget.url));

      _initialized = true; // Mark initialization complete
    }
  }

  // Function to check if the url changed.
  // Needed to fix bug where page doesn't change when going between the Live Map & Service Status
  @override
  void didUpdateWidget(covariant Webpage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _webController.loadRequest(Uri.parse(widget.url)); // Update the WebView URL
    }
  }
  
  // Function to just handle refreshing of the page
  // TODO - Fix Refresh so it actually recognises user inputs.

  Future<void> handleRefresh() async {
    setState(() => _isLoading = true); // Show loading animation on refresh
    await _webController.clearCache();
    await _webController.reload();
  }

}
