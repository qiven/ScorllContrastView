//
//  CircleProgressView.h
//  CircleProgressView
//
//  Created by More Mocha on 16/10/23.
//  Copyright © 2016年 QivenDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView

- (void)drawCircleWithPercent:(CGFloat)percent
                     duration:(CGFloat)duration
                    lineWidth:(CGFloat)lineWidth
                    clockwise:(BOOL)clockwise
                      lineCap:(NSString *)lineCap
                    fillColor:(UIColor *)fillColor
                  strokeColor:(UIColor *)strokeColor
               animatedColors:(NSArray *)colors;

- (void)startAnimation;

@end
