//
//  GestureImageView.m
//  GestureZoomAndPan
//
//  Created by achellies on 14-8-26.
//  Copyright (c) 2014年 Paul Solt. All rights reserved.
//

#import "GestureImageView.h"
@interface GestureImageView() <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIGestureRecognizer *panGesture;
@property (nonatomic, strong) UIGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGesture;
@end

@implementation GestureImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initMovementGestures];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        // Initialization code
        [self initMovementGestures];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initMovementGestures];
}

-(void)removeFromSuperview
{
    [self removeGestureRecognizer:self.panGesture];
    [self removeGestureRecognizer:self.pinchGesture];
    [self removeGestureRecognizer:self.rotationGesture];
}

#pragma mark - Private Methods

-(void)initMovementGestures
{
    self.userInteractionEnabled = YES;
    self.zoomSpeed = .5;
    self.minZoom = .5;
    self.maxZoom = 5;

    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGesture.delegate = self;
    [self addGestureRecognizer:self.panGesture];

    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    self.pinchGesture.delegate = self;
    [self addGestureRecognizer:self.pinchGesture];

    self.rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
    self.rotationGesture.delegate = self;
    [self addGestureRecognizer:self.rotationGesture];
}

-(void)handlePanGesture:(UIPanGestureRecognizer *) panGesture
{
    if ([self.panGesture isEqual:panGesture]) {
        CGPoint translation = [panGesture translationInView:panGesture.view.superview];

        if (UIGestureRecognizerStateBegan == panGesture.state || UIGestureRecognizerStateChanged == panGesture.state) {
            panGesture.view.center = CGPointMake(panGesture.view.center.x + translation.x, panGesture.view.center.y + translation.y);
            [panGesture setTranslation:CGPointZero inView:panGesture.view.superview];
        }
    }
}

-(void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture
{
    if ([self.pinchGesture isEqual:pinchGesture]) {
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
    if ([self.rotationGesture isEqual:rotateGesture]) {
        if (UIGestureRecognizerStateBegan == rotateGesture.state || UIGestureRecognizerStateChanged == rotateGesture.state) {
            CGFloat rotate = rotateGesture.rotation;
            
            CGAffineTransform transform = CGAffineTransformRotate(rotateGesture.view.transform, rotate);
            rotateGesture.view.transform = transform;

            [rotateGesture setRotation:0];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        return NO;
    }
    if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

@end
