import 'package:flutter/material.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LegalWebviewScreen extends StatefulWidget {
  const LegalWebviewScreen({
    super.key,
    required this.title,
    required this.path,
  });

  final String title;
  final String path;

  @override
  State<LegalWebviewScreen> createState() => _LegalWebviewScreenState();
}

class _LegalWebviewScreenState extends State<LegalWebviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  bool _didLoad = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (_) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
            }
          },
        ),
      );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoad) {
      _didLoad = true;
      _loadPage();
    }
  }

  void _loadPage() {
    final langCode = Localizations.localeOf(context).languageCode;
    final locale = const {'ja', 'ko', 'en'}.contains(langCode)
        ? langCode
        : 'ja';
    final url = 'https://lunalism.github.io/hareru/$locale/${widget.path}';
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    _controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: c.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (_hasError)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 48,
                    color: c.textTertiary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.webviewLoadError,
                    style: TextStyle(
                      fontSize: 15,
                      color: c.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _loadPage,
                    child: Text(
                      AppLocalizations.of(context)!.retry,
                      style: TextStyle(
                        color: HareruColors.primaryStart,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: HareruColors.primaryStart,
              ),
            ),
        ],
      ),
    );
  }
}
