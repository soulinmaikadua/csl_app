import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyWebViewPage extends StatefulWidget {
  const MyWebViewPage({super.key});

  @override
  State<MyWebViewPage> createState() => _MyWebViewPageState();
}

class _MyWebViewPageState extends State<MyWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Set platform-specific WebView
    late final PlatformWebViewControllerCreationParams params;
    if (Platform.isAndroid) {
      params = const PlatformWebViewControllerCreationParams();
    } else if (Platform.isIOS) {
      params = const PlatformWebViewControllerCreationParams();
    } else {
      throw UnsupportedError("Unsupported platform");
    }

    final controller = WebViewController.fromPlatformCreationParams(params);
    const String customAgent = ' WebView/1.0.0';
    // const String hostname = 'https://theme-3.cslvault.com';
    const String hostname = 'https://katom365.com';

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(customAgent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url;
            final uri = Uri.parse(url);

            // ✅ 1. Allow your main domain to load in WebView
            // const mainDomain = "th358888.vip";
            // const mainDomain = "cslvault.com";
            // const mainDomain = 'theme-3.cslvault.com';
            const mainDomain = 'katom365.com';
            if (uri.host.contains(mainDomain)) {
              return NavigationDecision.navigate;
            }
            // ✅ 3. Any other external link → open in external browser
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }

            return NavigationDecision.prevent;
          },
          onPageFinished: (String url) {
            // STEP 2: Call the function to disable the HTML class
            _disableHtmlClass();
          },
        ),
      )
      ..loadRequest(Uri.parse(hostname));
    // ..loadRequest(Uri.parse("https://th358888.vip"));

    _controller = controller;
  }

  // STEP 1: Define the JavaScript function
  void _disableHtmlClass() {
    Future.delayed(Duration(microseconds: 300), () {
      final String javascript = """
      (function() {
	  	var registerButton = document.getElementById('register-button');
		if (registerButton) {
			registerButton.style.display = 'none';
			console.log("Register button found and hidden");
		}
		var regBtn = document.getElementById('register-btn');
		if (regBtn) {
			regBtn.style.display = 'none';
			console.log("Register button found and hidden");
		}
		var showBanner = document.getElementById('show-download-banner');
		if (showBanner) {
			showBanner.style.display = 'none';
			console.log("Register button found and hidden");
		}
      })();
    """;
      _controller.runJavaScript(javascript);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(title: const Text("My WebView")),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
