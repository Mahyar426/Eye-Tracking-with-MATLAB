# 👁️ Gaze Estimation via Iris Detection — Camera-Only Eye Tracking in MATLAB

> **No eye-tracking hardware. No depth sensor. No IR emitter.**
> Just a standard webcam, a custom vision pipeline, and geometry — and it works.

This is my Bachelor's thesis project at Isfahan University of Technology: a **fully software-driven, real-time gaze estimation system** built from scratch in MATLAB. Given only a regular photograph of a person's face, the system detects the iris, localizes it with sub-pixel precision, and maps its position to exact screen coordinates — no calibration rig, no specialized equipment required.

---

## 🔍 What This System Does

The core problem: **where on a screen is a person looking?** This system answers that using pure computer vision — no wearables, no hardware trackers.

**Full pipeline, end to end:**

1. **Face & eye region detection** — Viola-Jones cascade classifier isolates the face, then a second cascade finds both eye regions with geometric validation (filters false positives by checking relative eye positions)
2. **Iris localization** — Custom Laplacian-sharpened, Canny-edge-detected pipeline feeds into `imfindcircles` (Hough circle transform) with adaptive polarity selection (dark or bright iris detection, winner chosen by confidence metric)
3. **Pupil detection** — Separate concentric-circle search with radius constraints calibrated to the iris boundary
4. **Gaze coordinate prediction** — A calibration-frame geometric model maps iris displacement across 4 reference gaze directions (Up-Right, Up-Left, Down-Right, Down-Left) to absolute screen pixel coordinates
5. **Multi-hypothesis averaging** — 17 gaze estimates are computed across all combinations of calibration reference points; their mean suppresses noise and improves robustness

---

## 🧠 Technical Highlights

| Capability | Implementation |
|---|---|
| Face detection | `vision.CascadeObjectDetector` (Viola-Jones) |
| Eye region validation | Geometric constraint: Δy < 68px, Δx > 40px between detected regions |
| Edge enhancement | Custom Laplacian kernel `[1,1,1; 1,-8,1; 1,1,1]` sharpening + Canny edge detection |
| Iris detection | Hough circle transform (`imfindcircles`) on Laplacian-enhanced Canny edges |
| Polarity selection | Confidence-metric comparison between dark and bright iris candidates |
| Pupil detection | Constrained Hough search at ≈1/3 iris radius |
| Gaze mapping | Linear proportional mapping: `screen_x = 100 + (screen_width × Δx_eye) / eye_span_x` |
| Noise reduction | 17-hypothesis ensemble averaging across all calibration reference combinations |
| Dataset support | Custom dataset + CASIA iris database (switchable via parameter tuning) |

---

## 🏗️ System Architecture

```
Input: Face Photo(s)
        │
        ▼
┌─────────────────────┐
│  Sep.m              │  ← Face crop → Eye ROI extraction (Cascade + geometry)
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  irisfinder1.m      │  ← Full iris detection on first calibration frame
│  irisfinder2.m      │  ← Locked-ROI iris detection for subsequent frames
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  pupiliris.m        │  ← Concurrent pupil + iris detection (CASIA mode)
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  Predictor.m        │  ← 4-point calibration → gaze coordinate mapping
│                     │    17-hypothesis ensemble → mean (x, y) on screen
└────────┬────────────┘
         │
         ▼
Output: Screen gaze point marked on display board
```

---

## 📁 Repository Structure

```
eye-tracking-matlab/
├── Sep.m               # Face & eye ROI detection (Cascade + geometric filter)
├── irisfinder1.m       # Primary iris detector (Laplacian + Canny + Hough)
├── irisfinder2.m       # Locked-ROI iris detector for calibration frames
├── pupiliris.m         # Joint pupil + iris detection module
├── Predictor.m         # Gaze estimation engine (calibration + coordinate mapping)
├── Comparison.m        # Multi-frame iris center comparison
├── TestIrisFinder.m    # Iris detection test harness
├── TestIrisPupil.m     # Pupil detection test harness
├── TestPhase2.m        # Full gaze prediction test script
└── TestPredictor.m     # Predictor function test harness
```

---

## 🚀 Running the System

**Requirements:** MATLAB with Computer Vision Toolbox and Image Processing Toolbox

**Calibration + Gaze Prediction:**
```matlab
% Load 4 calibration images (gaze at screen corners) + 1 target image
ImUR = imread('UpRight.png');
ImUL = imread('UpLeft.png');
ImDR = imread('DownRight.png');
ImDL = imread('DownLeft.png');
Desired = imread('Target.png');

% Run gaze prediction
[gaze_x, gaze_y] = Predictor(ImUR, ImUL, ImDL, ImDR, Desired);
% Output: pixel coordinates on screen where user was looking
```

**Iris-only detection:**
```matlab
Im = imread('face.jpg');
[radius, center, X, Y, W, H] = irisfinder1(Im);
```

**Dataset toggle** — Switch between custom and CASIA parameters in `irisfinder1.m`:
```matlab
Min_Radii = 10;  Sensitivity = 0.96;  % Custom dataset
% Min_Radii = 90; Sensitivity = 0.98; % CASIA dataset
```

---

## 💡 Key Design Decisions

**Why Laplacian pre-sharpening?** Raw images have soft iris boundaries. The custom Laplacian kernel amplifies the circular iris edge before Canny detection, dramatically improving `imfindcircles` reliability on low-contrast eye photos.

**Why 17 hypotheses?** Single-point calibration is brittle under lighting variation or micro-movement during capture. By computing gaze estimates across all combinations of the 4 reference corner positions and averaging, the system becomes significantly more robust to per-frame noise.

**Why locked ROI in `irisfinder2`?** Once the eye region is located from the first (Up-Right) calibration frame, all subsequent frames use the same crop coordinates. This eliminates re-detection jitter and ensures consistent iris tracking across all calibration images.

---

## 📊 Results

The system successfully localizes the iris and maps gaze to screen coordinates using only standard RGB webcam images. Validated on both a custom-captured personal dataset and the CASIA iris benchmark database with separate parameter profiles for each.

---

## 🛠️ Skills Demonstrated

`Computer Vision` · `Image Processing` · `MATLAB` · `Hough Transform` · `Cascade Classifiers` · `Edge Detection (Canny)` · `Laplacian Filtering` · `Geometric Calibration` · `Gaze Estimation` · `Iris/Pupil Segmentation`

---

*Bachelor's Thesis — Isfahan University of Technology, Electrical Engineering Department*
