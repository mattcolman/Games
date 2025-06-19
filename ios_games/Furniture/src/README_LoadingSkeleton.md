# LoadingSkeleton Component

A reusable loading skeleton component for ActionScript/Flash applications that provides animated placeholder content while data is loading.

## Features

- **Animated Placeholders**: Smooth pulsing animation that mimics content loading
- **Customizable Size**: Configurable width and height to fit different UI areas
- **Sidebar Optimized**: Designed specifically for sidebar layouts but adaptable to other areas
- **Smooth Transitions**: Fade in/out animations for showing and hiding
- **Memory Efficient**: Proper cleanup and disposal methods
- **Staggered Animation**: Multiple skeleton items animate with slight delays for visual appeal

## Usage

### Basic Implementation

```actionscript
// Create a loading skeleton for sidebar (250px wide, 400px tall)
var loadingSkeleton:LoadingSkeleton = new LoadingSkeleton(250, 400);
loadingSkeleton.x = 50;
loadingSkeleton.y = 100;
addChild(loadingSkeleton);
```

### Integration in Furniture Game

The LoadingSkeleton has been integrated into the main Furniture game to show loading state when the furniture browser is being initialized:

```actionscript
// Show loading skeleton while browser loads
private function showLoadingSkeleton():void {
    _loadingSkeleton = new LoadingSkeleton(250, 400);
    _loadingSkeleton.x = stage.stageWidth - 270; // Right sidebar position
    _loadingSkeleton.y = 50;
    stage.addChild(_loadingSkeleton);
    _loadingSkeleton.show();
}

// Hide when content is ready
private function hideLoadingSkeleton():void {
    if (_loadingSkeleton) {
        _loadingSkeleton.hide();
        _loadingSkeleton = null;
    }
}
```

### Available Methods

#### Constructor
- `LoadingSkeleton(width:Number = 200, height:Number = 300)` - Creates a new loading skeleton with specified dimensions

#### Animation Control
- `startAnimation():void` - Starts the pulsing animation
- `stopAnimation():void` - Stops the animation and resets opacity
- `show():void` - Shows the skeleton with fade-in animation
- `hide():void` - Hides the skeleton with fade-out animation and removes from parent

#### Cleanup
- `dispose():void` - Properly cleans up all resources and removes from parent

## Design

The LoadingSkeleton creates several placeholder rectangles of different sizes to simulate typical sidebar content:

- **Title placeholder** (80% width, 20px height)
- **Subtitle placeholder** (60% width, 15px height)  
- **Large content block** (90% width, 60px height)
- **Text lines** (varying widths, 15px height each)
- **Button placeholder** (90% width, 40px height)

All placeholders have rounded corners and use a subtle gray color scheme with pulsing animation.

## Demo

See `LoadingSkeletonDemo.as` for a comprehensive demonstration of different skeleton configurations and usage patterns.

## Dependencies

- **GreenSock TweenMax**: Used for smooth animations
- **Flash Display Objects**: Standard Flash/ActionScript display list components

## Browser Integration

The component is specifically designed to work with the furniture browser loading process, providing visual feedback while:
- Assets are being loaded
- Browser UI is being initialized
- Network requests are in progress
- Content is being processed

This improves user experience by providing immediate visual feedback instead of a blank or frozen interface during loading states.

