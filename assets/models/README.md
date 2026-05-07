# 3D Model Assets

These `.glb` files are now used directly by the app:

## Active files
| File | Used in | Purpose |
|------|---------|---------|
| `logo.glb` | `intro_screen.dart` | Intro 3D logo model |
| `phone.glb` | `landing_screen.dart` | Primary hero model (tablet/desktop) |
| `phone_mobile.glb` | `landing_screen.dart` | Lightweight fallback model (mobile) |

## Current model sources
- `logo.glb`: Khronos `Duck` sample model
- `phone.glb`: Khronos `DamagedHelmet` sample model
- `phone_mobile.glb`: Khronos `Box` sample model (very small, mobile-friendly)

## Where to get free .glb models
1. **Sketchfab** → https://sketchfab.com/3d-models?features=downloadable&sort_by=-likeCount
   - Filter by "Downloadable" + "glTF" format
2. **Google Model Viewer examples** → https://modelviewer.dev/
3. **Poly Pizza** → https://poly.pizza  (CC0 free models)
4. **Quaternius** → https://quaternius.com (game assets, free)

## Real-device smoothness checks
1. Run on a physical Android/iOS device (`flutter run`).
2. Navigate Intro -> Landing and watch for dropped frames/stutter.
3. Confirm mobile loads `phone_mobile.glb` (not `phone.glb`) by logging `modelSrc` in debug if needed.
4. In Flutter DevTools, verify frame raster/build times stay below 16ms for most frames.
