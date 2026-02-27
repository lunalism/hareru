import 'package:flutter/material.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _faqUrl = 'https://hareru.notion.site/FAQ';
const _cacheKey = 'faq_cache';

const _hideNotionUiJs = '''
(function() {
  var style = document.createElement('style');
  style.textContent = [
    '.notion-topbar { display: none !important; }',
    '.super-navbar { display: none !important; }',
    '[class*="topbar"] { display: none !important; }',
    '.notion-footer { display: none !important; }',
    '[class*="footer"] { display: none !important; }',
    '.notion-frame > .notion-scroller > nav { display: none !important; }',
    'nav { display: none !important; }',
  ].join('\\n');
  document.head.appendChild(style);
})();
''';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => _onPageLoaded(),
          onWebResourceError: (_) => _onLoadError(),
          onNavigationRequest: (_) => NavigationDecision.navigate,
        ),
      )
      ..loadRequest(Uri.parse(_faqUrl));
  }

  Future<void> _onPageLoaded() async {
    await _controller.runJavaScript(_hideNotionUiJs);

    // Cache HTML
    try {
      final html = await _controller.runJavaScriptReturningResult(
        'document.documentElement.outerHTML',
      );
      if (html is String && html.length > 100) {
        final box = Hive.box('settings');
        await box.put(_cacheKey, html);
      }
    } catch (_) {}

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _onLoadError() async {
    final box = Hive.box('settings');
    final cached = box.get(_cacheKey) as String?;
    if (cached != null && cached.isNotEmpty) {
      await _controller.loadHtmlString(cached);
      if (mounted) setState(() => _isLoading = false);
    } else {
      if (mounted) setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _onBackPressed() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    } else {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _onBackPressed();
      },
      child: Scaffold(
        backgroundColor: isDark ? HareruColors.darkBg : HareruColors.lightBg,
        appBar: AppBar(
          backgroundColor:
              isDark ? HareruColors.darkBg : HareruColors.lightBg,
          surfaceTintColor: Colors.transparent,
          title: Text(
            l10n.faq,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.lightTextPrimary,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.lightTextPrimary,
            ),
            onPressed: _onBackPressed,
          ),
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
                      color: isDark
                          ? HareruColors.darkTextTertiary
                          : HareruColors.lightTextTertiary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.noInternet,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark
                            ? HareruColors.darkTextSecondary
                            : HareruColors.lightTextSecondary,
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
                  color: Color(0xFFE8453C),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
