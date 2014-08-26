//
//  GestureSupported.h
//  GestureZoomAndPan
//
//  Created by achellies on 14-8-26.
//  Copyright (c) 2014年 Paul Solt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GestureSupported : NSObject

-(void)gestureSupported:(UIView *)view minZoom:(CGFloat)minZoom maxZoom:(CGFloat)maxZoom;

@end
