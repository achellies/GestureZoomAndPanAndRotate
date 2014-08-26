//
//  GestureSupported.m
//  GestureZoomAndPan
//
//  Created by achellies on 14-8-26.
//  Copyright (c) 2014年 Paul Solt. All rights reserved.
//

#import "GestureSupported.h"
@interface GestureSupported () <UIGestureRecognizerDelegate>
@property (nonatomic, assign) double minZoom;
@property (nonatomic, assign) double maxZoom;
@property (nonatomic, assign) double zoomSpeed;
@end

@implementation GestureSupported

-(void)gestureSupported:(UIView *)view minZoom:(CGFloat)minZoom maxZoom:(CGFloat)maxZoom {
    self.maxZoom = maxZoom;
    self.minZoom = minZoom;
    self.zoomSpeed = .5;
    [self addMovementGesturesToView:view];
}

- (void)addMovementGesturesToView:(UIView *)view {
    view.userInteractionEnabled = YES;  // Enable user interaction

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture.delegate = self;
    [view addGestureRecognizer:panGesture];

    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchGesture.delegate = self;
    [view addGestureRecognizer:pinchGesture];

    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
    rotationGesture.delegate = self;
    [view addGestureRecognizer:rotationGesture];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:panGesture.view.superview];

    if (UIGestureRecognizerStateBegan == panGesture.state ||UIGestureRecognizerStateChanged == panGesture.state) {
        panGesture.view.center = CGPointMake(panGesture.view.center.x + translation.x,
                                             panGesture.view.center.y + translation.y);
        [panGesture setTranslation:CGPointZero inView:panGesture.view.superview];
    }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture {

    if (UIGestureRecognizerStateBegan == pinchGesture.state ||
        UIGestureRecognizerStateChanged == pinchGesture.state) {

        if (UIGestureRecognizerStateBegan == pinchGesture.state || UIGestureRecognizerStateChanged == pinchGesture.state) {
            float currentScale = pinchGesture.view.layer.contentsScale;
            float deltaScale = pinchGesture.scale;

            deltaScale = ((deltaScale - 1) * self.zoomSpeed) + 1;
            deltaScale = MIN(deltaScale, self.maxZoom / currentScale);
            deltaScale = MAX(deltaScale, self.minZoom / currentScale);

            CGAffineTransform zoomTransform = CGAffineTransformScale(pinchGesture.view.transform, deltaScale, deltaScale);
            pinchGesture.view.transform = zoomTransform;
            
            pinchGesture.scale = 1;
        }
    }
}

-(void)handleRotateGesture:(UIRotationGestureRecognizer *)rotateGesture
{
    if (UIGestureRecognizerStateBegan == rotateGesture.state || UIGestureRecognizerStateChanged == rotateGesture.state) {
        CGFloat rotate = rotateGesture.rotation;

        CGAffineTransform transform = CGAffineTransformRotate(rotateGesture.view.transform, rotate);
        rotateGesture.view.transform = transform;

        [rotateGesture setRotation:0];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES; // Works for most use cases of pinch + zoom + pan
}
@end
