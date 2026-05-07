# 3D Model Placeholders

Place your .glb 3D model files here.

## Required files
| File | Used in | Purpose |
|------|---------|---------|
| `logo.glb` | intro_screen.dart | Rotating logo on splash |
| `phone.glb` | landing_screen.dart | Floating phone hero |

## Where to get free .glb models
1. **Sketchfab** → https://sketchfab.com/3d-models?features=downloadable&sort_by=-likeCount
   - Filter by "Downloadable" + "glTF" format
2. **Google Model Viewer examples** → https://modelviewer.dev/
3. **Poly Pizza** → https://poly.pizza  (CC0 free models)
4. **Quaternius** → https://quaternius.com (game assets, free)

## How to enable ModelViewer (already added to pubspec)
In `landing_screen.dart`, replace `_buildPhoneShape()` call with:
```dart
import 'package:model_viewer_plus/model_viewer_plus.dart';

// Inside _buildPhoneModel() widget:
SizedBox(
  height: phoneH,
  child: ModelViewer(
    src: 'assets/models/phone.glb',
    autoRotate: true,
    cameraControls: true,
    backgroundColor: Colors.transparent,
    autoPlay: true,
  ),
)
```

Same pattern for `intro_screen.dart` with `logo.glb`.
