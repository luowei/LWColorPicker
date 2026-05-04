# Graph Report - /Users/luowei/projects/libs/LWColorPicker  (2026-05-04)

## Corpus Check
- Corpus is ~23,009 words - fits in a single context window. You may not need a graph.

## Summary
- 306 nodes · 303 edges · 29 communities detected
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 7 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]

## God Nodes (most connected - your core abstractions)
1. `RSColorPickerView` - 38 edges
2. `RSColorPickerState()` - 17 edges
3. `BitmapContextRep()` - 14 edges
4. `BGRSLoupeLayer()` - 13 edges
5. `ANImageBitmapRep` - 13 edges
6. `ColorPickerView` - 13 edges
7. `ColorPickerState` - 13 edges
8. `RSGenerateOperation` - 8 edges
9. `LWColorPicker` - 8 edges
10. `OpacitySlider` - 8 edges

## Surprising Connections (you probably didn't know these)
- `ColorPickerView` --inherits--> `View`  [EXTRACTED]
  LWColorPicker_swift/Swift/ColorPickerView.swift →   _Bridges community 6 → community 9_
- `BrightnessSlider` --inherits--> `View`  [EXTRACTED]
  LWColorPicker_swift/Swift/BrightnessSlider.swift →   _Bridges community 6 → community 8_
- `LWColorPicker` --inherits--> `View`  [EXTRACTED]
  LWColorPicker_swift/Swift/LWColorPicker.swift →   _Bridges community 6 → community 10_
- `OpacitySlider` --inherits--> `View`  [EXTRACTED]
  LWColorPicker_swift/Swift/OpacitySlider.swift →   _Bridges community 6 → community 3_
- `BrightnessSliderDelegate` --inherits--> `AnyObject`  [EXTRACTED]
  LWColorPicker_swift/Swift/BrightnessSlider.swift →   _Bridges community 3 → community 8_

## Communities (47 total, 4 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.05
Nodes (38): RSColorPickerView, -bitmapForSizescalepaddingshouldCache, -brightness, -colorAtPoint, -didMoveToWindow, -genBitmap, -generateBezierPaths, -handleStateChanged (+30 more)

### Community 1 - "Community 1"
Cohesion: 0.11
Nodes (16): RSColorPickerState(), -calculateHue, -calculatePointWithHuesaturation, -calculateSaturation, -color, -description, -hue, -initWithColorsize (+8 more)

### Community 2 - "Community 2"
Cohesion: 0.13
Nodes (13): BitmapContextRep(), -bitmapData, -bitmapSize, -CGImage, -context, -dealloc, -getRawPixelatPoint, -initWithCGImage (+5 more)

### Community 3 - "Community 3"
Cohesion: 0.16
Nodes (6): AnyObject, ColorPickerViewDelegate, OpacitySlider, OpacitySliderDelegate, OpacitySliderView, UIView

### Community 4 - "Community 4"
Cohesion: 0.14
Nodes (12): BGRSLoupeLayer(), -animationDidStopfinished, -appearInColorPicker, -dealloc, -disappear, -disappearAnimated, -drawGlintInContext, -drawGridInContext (+4 more)

### Community 5 - "Community 5"
Cohesion: 0.14
Nodes (13): ANImageBitmapRep, -copyWithZone, -dealloc, -forwardInvocation, -generateBaseClasses, -getPixelAtPoint, -image, -imageBitmapRepWithCGSize (+5 more)

### Community 6 - "Community 6"
Cohesion: 0.21
Nodes (12): PreviewProvider, ColorPickerView_Previews, LoupeView, SelectionIndicator, BrightnessSliderExample, ColorPickerExampleView, ColorPickerExampleView_Previews, ColorPickerViewExample (+4 more)

### Community 7 - "Community 7"
Cohesion: 0.2
Nodes (3): ObservableObject, getComponentsForColor(), ColorPickerState

### Community 8 - "Community 8"
Cohesion: 0.24
Nodes (4): BrightnessSlider, BrightnessSlider_Previews, BrightnessSliderDelegate, BrightnessSliderView

### Community 10 - "Community 10"
Cohesion: 0.27
Nodes (3): LWColorPicker, LWColorPicker_Previews, LWColorPickerView

### Community 11 - "Community 11"
Cohesion: 0.22
Nodes (8): RSGenerateOperation, -colorRectangleBitMapWithWidthheight, -colorWheelBitMap, -initWithSizeandPadding, -isConcurrent, -isExecuting, -isFinished, -main

### Community 13 - "Community 13"
Cohesion: 0.22
Nodes (8): LWViewController, -brightnessSlideChanged, -colorPickerDidChangeSelection, -colorPickertouchesBeganwithEvent, -colorPickertouchesEndedwithEvent, -opacitySliderChanged, -viewDidLoad, -whiteColorBtnAction

### Community 14 - "Community 14"
Cohesion: 0.25
Nodes (7): RSOpacitySlider, -didMoveToWindow, -drawRect, -initRoutine, -initWithCoder, -initWithFrame, -myValueChanged

### Community 15 - "Community 15"
Cohesion: 0.25
Nodes (7): RSBrightnessSlider, -circleWithColor, -drawRect, -initRoutine, -initWithCoder, -initWithFrame, -myValueChanged

### Community 16 - "Community 16"
Cohesion: 0.25
Nodes (7): LWAppDelegate, -applicationDidBecomeActive, -applicationDidEnterBackground, -applicationdidFinishLaunchingWithOptions, -applicationWillEnterForeground, -applicationWillResignActive, -applicationWillTerminate

### Community 17 - "Community 17"
Cohesion: 0.29
Nodes (6): UIImage, -imageBitmapRep, -imageByScalingToSize, -imageFillingFrame, -imageFittingFrame, -imageFromImageBitmapRep

### Community 18 - "Community 18"
Cohesion: 0.29
Nodes (6): NSImage, -imageBitmapRep, -imageByScalingToSize, -imageFillingFrame, -imageFittingFrame, -imageFromImageBitmapRep

### Community 19 - "Community 19"
Cohesion: 0.29
Nodes (5): CGContextCreator, -dealloc, -init, -newARGBBitmapContextWithImage, -newARGBBitmapContextWithSize

### Community 20 - "Community 20"
Cohesion: 0.33
Nodes (4): BitmapContextManipulator, -dealloc, -forwardInvocation, -initWithContext

### Community 21 - "Community 21"
Cohesion: 0.33
Nodes (5): BitmapCropManipulator, -cropFrame, -croppedImageWithFrame, -cropTopEllipse, -cropTopFrame

### Community 22 - "Community 22"
Cohesion: 0.33
Nodes (4): CGImageContainer(), -dealloc, -imageContainerWithImage, -initWithImage

### Community 23 - "Community 23"
Cohesion: 0.4
Nodes (4): BitmapScaleManipulator, -setSize, -setSizeFillingFrame, -setSizeFittingFrame

### Community 24 - "Community 24"
Cohesion: 0.4
Nodes (4): Tests, -setUp, -tearDown, -testExample

### Community 25 - "Community 25"
Cohesion: 0.5
Nodes (3): BitmapDrawManipulator, -drawEllipseInFramecolor, -drawImageinRect

### Community 26 - "Community 26"
Cohesion: 0.5
Nodes (3): BitmapRotationManipulator, -imageByRotating, -rotate

## Knowledge Gaps
- **155 isolated node(s):** `-circleWithColorsize`, `-initWithSizeandPadding`, `-main`, `-colorRectangleBitMapWithWidthheight`, `-colorWheelBitMap` (+150 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ColorPickerView` connect `Community 9` to `Community 12`, `Community 6`, `Community 7`?**
  _High betweenness centrality (0.033) - this node is a cross-community bridge._
- **Why does `ColorPickerState` connect `Community 7` to `Community 9`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **What connects `-circleWithColorsize`, `-initWithSizeandPadding`, `-main` to the rest of the system?**
  _155 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.11 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.13 - nodes in this community are weakly interconnected._
- **Should `Community 4` be split into smaller, more focused modules?**
  _Cohesion score 0.14 - nodes in this community are weakly interconnected._