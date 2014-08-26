//
//  ViewController.m
//  GestureStackOverflow
//
//  Created by Paul on 6/14/14.
//  Copyright (c) 2014 Paul Solt. All rights reserved.
//

#import "ViewController.h"
#import "GestureImageView.h"
#import "GestureSupported.h"

@interface ViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) GestureSupported *gestureSupported;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UIImageView's and UILabel's don't have userInteractionEnabled by default!
    GestureImageView *imageView = [[GestureImageView alloc] initWithImage:[UIImage imageNamed:@"BombDodge.png"]]; // Any image in Xcode project
    imageView.center = CGPointMake(160, 250);
    [imageView sizeToFit];
    imageView.maxZoom = 2;
    [self.view addSubview:imageView];

    UIImage *image = [UIImage imageNamed:@"BombDodge.png"];
    GestureImageView *imageView2 = [[GestureImageView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    imageView2.image = image;
    imageView2.frame = CGRectMake(100, 100, image.size.width, image.size.height);
    [self.view addSubview:imageView2];

    // Note: Changing the font size would be crisper than zooming a font!
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Hello Gestures!";
    label.font = [UIFont systemFontOfSize:30];
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    label.center = CGPointMake(160, 400);
    [self.view addSubview:label];
    self.gestureSupported = [[GestureSupported alloc] init];
    [self.gestureSupported  gestureSupported:label minZoom:1 maxZoom:10];
}

@end
