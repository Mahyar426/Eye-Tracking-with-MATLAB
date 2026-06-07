<div align="center">

![header](https://readme-typing-svg.demolab.com?font=Fira+Code&size=26&pause=1000&color=00FF88&center=true&vCenter=true&width=800&lines=👁️+Gaze+Estimation+via+Iris+Detection;No+eye-tracking+hardware.+No+depth+sensor.+No+IR.;Just+a+webcam%2C+a+vision+pipeline%2C+and+geometry.)

```
███████╗██╗   ██╗███████╗
██╔════╝╚██╗ ██╔╝██╔════╝
█████╗   ╚████╔╝ █████╗
██╔══╝    ╚██╔╝  ██╔══╝
███████╗   ██║   ███████╗
╚══════╝   ╚═╝   ╚══════╝
  camera-only gaze estimation — ~98% accuracy
```

[![MATLAB](https://img.shields.io/badge/MATLAB-Computer_Vision_Toolbox-orange?style=flat-square&logo=mathworks)](https://www.mathworks.com/)
[![Domain](https://img.shields.io/badge/Domain-Computer_Vision_%7C_Gaze_Estimation-00FF88?style=flat-square)](#)
[![Techniques](https://img.shields.io/badge/Techniques-Hough_%7C_Canny_%7C_Viola--Jones_%7C_Calibration-blue?style=flat-square)](#)

</div>

---

> **No eye-tracking hardware. No depth sensor. No IR emitter.**  
> Just a standard webcam, a custom vision pipeline, and geometry — and it works.

A **fully software-driven, real-time gaze estimation system** built from scratch in MATLAB. Given only a regular photograph of a person's face, the system detects the iris, localizes it with sub-pixel precision, and maps its position to exact screen coordinates — no calibration rig, no specialized equipment required.

*B.Sc. Thesis project — Electrical Engineering.*

---

## 🔍 What This System Does

**Full pipeline, end to end:**

1. **Face & eye region detection** — Viola-Jones cascade classifier isolates the face, then a second cascade finds both eye regions with geometric validation (filters false positives by checking relative eye positions)
2. **Iris localization** — Custom Laplacian-sharpened, Canny-edge-detected pipeline feeds into `imfindcircles` (Hough circle transform) with adaptive polarity selection
3. **Pupil detection** — Separate concentric-circle search with radius constraints calibrated to the iris boundary
4. **Gaze coordinate prediction** — Calibration-frame geometric model maps iris displacement across 4 reference gaze directions to absolute screen pixel coordinates
5. **Multi-hypothesis averaging** — 17 gaze estimates computed across all combinations of calibration reference points; their mean suppresses noise

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
| Gaze mapping | `screen_x = 100 + (screen_width × Δx_eye) / eye_span_x` |
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

## 🚀 Running the System

**Requirements:** MATLAB with Computer Vision Toolbox and Image Processing Toolbox

```matlab
% Load 4 calibration images (gaze at screen corners) + 1 target image
ImUR = imread('UpRight.png');
ImUL = imread('UpLeft.png');
ImDR = imread('DownRight.png');
ImDL = imread('DownLeft.png');
Desired = imread('Target.png');

% Run gaze prediction
[gaze_x, gaze_y] = Predictor(ImUR, ImUL, ImDL, ImDR, Desired);
```

**Dataset toggle** — Switch between custom and CASIA parameters in `irisfinder1.m`:
```matlab
Min_Radii = 10;  Sensitivity = 0.96;  % Custom dataset
% Min_Radii = 90; Sensitivity = 0.98; % CASIA dataset
```

---

## 💡 Key Design Decisions

**Why Laplacian pre-sharpening?** Raw images have soft iris boundaries. The custom Laplacian kernel amplifies the circular iris edge before Canny detection, dramatically improving `imfindcircles` reliability on low-contrast eye photos.

**Why 17 hypotheses?** Single-point calibration is brittle under lighting variation or micro-movement. Computing gaze estimates across all combinations of the 4 reference corner positions and averaging makes the system significantly more robust to per-frame noise.

**Why locked ROI in `irisfinder2`?** Once the eye region is located from the first calibration frame, all subsequent frames use the same crop coordinates — eliminating re-detection jitter across all calibration images.

---

## 🛠️ Skills Demonstrated

`Computer Vision` · `Image Processing` · `MATLAB` · `Hough Transform` · `Cascade Classifiers` · `Canny Edge Detection` · `Laplacian Filtering` · `Geometric Calibration` · `Gaze Estimation` · `Iris/Pupil Segmentation`
