//
//  GestureImageView.h
//  GestureZoomAndPan
//
//  Created by achellies on 14-8-26.
//  Copyright (c) 2014年 Paul Solt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GestureImageView : UIImageView
@property (nonatomic, assign) double minZoom;
@property (nonatomic, assign) double maxZoom;
@property (nonatomic, assign) double zoomSpeed;
@end
