# Hareru — 앱 아이콘 + 스플래시 화면 적용 프롬프트

아래 작업을 순서대로 진행해줘.

## 1. 앱 아이콘 적용

`assets/icon/` 폴더에 있는 PNG 파일들을 iOS 앱 아이콘으로 적용해줘.

### flutter_launcher_icons 사용:

1. `pubspec.yaml`에 추가:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.3

flutter_launcher_icons:
  ios: true
  android: false
  image_path: "assets/icon/appicon-1024.png"
  remove_alpha_ios: true
```

2. 실행:
```bash
dart run flutter_launcher_icons
```

## 2. 스플래시 화면 구현

`flutter_native_splash` 패키지를 사용해서 네이티브 스플래시 화면을 만들어줘.

### 설정:

1. `pubspec.yaml`에 추가:
```yaml
dev_dependencies:
  flutter_native_splash: ^2.4.4

flutter_native_splash:
  color: "#FFFFFF"
  color_dark: "#0F172A"
  image: "assets/icon/symbol-color-512.png"
  image_dark: "assets/icon/symbol-white-512.png"
  ios: true
  android: false
```

2. 실행:
```bash
dart run flutter_native_splash:create
```

## 3. 커스텀 스플래시 → 온보딩 전환 화면

네이티브 스플래시가 끝난 후, 앱 내에서 로고 + "Hareru" 텍스트를 1.5초 보여주고 
온보딩(또는 홈)으로 페이드 전환하는 화면을 만들어줘.

### `lib/screens/splash_screen.dart` 생성:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();

    // 1.5초 후 다음 화면으로 이동
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        // TODO: 첫 실행이면 온보딩, 아니면 홈으로 분기
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 다이아몬드 심볼
              SvgPicture.asset(
                isDark
                    ? 'assets/icon/hareru-symbol-white.svg'
                    : 'assets/icon/hareru-symbol-color.svg',
                width: 72,
                height: 72,
              ),
              const SizedBox(height: 16),
              // 워드마크
              Text(
                'Hareru',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF4A90D9),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 라우터에 스플래시 추가:

`go_router` 설정에서 초기 라우트를 `/splash`로 지정:

```dart
GoRoute(
  path: '/splash',
  builder: (context, state) => const SplashScreen(),
),
```

## 4. 필요한 패키지 확인

```bash
flutter pub add flutter_svg
```

## 5. assets 등록 확인

`pubspec.yaml`의 assets 섹션에 아이콘 경로가 포함되어 있는지 확인:

```yaml
flutter:
  assets:
    - assets/icon/
```

## 브랜드 컬러 참고

- Primary: #4A90D9
- Primary Light: #7CB3E8
- Primary Dark: #2D6BB0
- Accent: #FFD54F
- Background Light: #FFFFFF
- Background Dark: #0F172A
