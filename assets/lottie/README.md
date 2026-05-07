# Lottie Animations Placeholder

Place your Lottie .json animation files here.

## Optional files
- `loading.json` — Can replace the loading dots in intro_screen.dart

## Free Lottie sources
- https://lottiefiles.com (search "logo reveal", "loading", "particles")

## How to use Lottie in Flutter
```dart
import 'package:lottie/lottie.dart';

Lottie.asset(
  'assets/lottie/loading.json',
  width: 200,
  height: 200,
  fit: BoxFit.contain,
  repeat: true,
)
```
