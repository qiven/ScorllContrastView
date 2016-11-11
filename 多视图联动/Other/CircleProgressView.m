//
//  CircleProgressView.m
//  CircleProgressView
//
//  Created by More Mocha on 16/10/23.
//  Copyright © 2016年 QivenDev. All rights reserved.
//  

#import "CircleProgressView.h"

#define kStartAngle -M_PI_2

@interface CircleProgressView () {
    CAShapeLayer *_backgroundLayer;
    CAShapeLayer *_circle;
    CGPoint _centerPoint;
    CGFloat _duration;
    CGFloat _percent;
    CGFloat _radius;
    CGFloat _lineWidth;
    NSString *_lineCap;
    BOOL _clockwise;
}

//@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
//@property (nonatomic, strong) CAShapeLayer *circle;
//@property (nonatomic) CGPoint centerPoint;
//@property (nonatomic) CGFloat duration;
//@property (nonatomic) CGFloat percent;
//@property (nonatomic) CGFloat radius;
//@property (nonatomic) CGFloat lineWidth;
//@property (nonatomic) NSString *lineCap;
//@property (nonatomic) BOOL clockwise;

@end

@implementation CircleProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    _backgroundLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_backgroundLayer];
    
    _circle = [CAShapeLayer layer];
    [self.layer addSublayer:_circle];
    
}

- (void)drawCircleWithPercent:(CGFloat)percent
                     duration:(CGFloat)duration
                    lineWidth:(CGFloat)lineWidth
                    clockwise:(BOOL)clockwise
                      lineCap:(NSString *)lineCap
                    fillColor:(UIColor *)fillColor
                  strokeColor:(UIColor *)strokeColor
               animatedColors:(NSArray *)colors {
    
    _duration = duration;
    _percent = percent;
    _lineWidth = lineWidth;
    _clockwise = clockwise;
    
    CGFloat min = MIN(self.frame.size.width, self.frame.size.height);
    _radius = (min - lineWidth)  / 2;
    _centerPoint = CGPointMake(self.frame.size.width / 2 - _radius, self.frame.size.height / 2 - _radius);
    _lineCap = lineCap;
    
    [self setupBackgroundLayerWithFillColor:fillColor];
    [self setupCircleLayerWithStrokeColor:strokeColor];
}

- (void)setupBackgroundLayerWithFillColor:(UIColor *)fillColor {
    
    _backgroundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_radius, _radius) radius:_radius startAngle:kStartAngle endAngle:2*M_PI clockwise:_clockwise].CGPath;
    
    // Center the shape in self.view
    _backgroundLayer.position = _centerPoint;
    
    // Configure the apperence of the circle
    _backgroundLayer.fillColor = fillColor.CGColor;
    _backgroundLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    _backgroundLayer.lineWidth = _lineWidth;
    _backgroundLayer.lineCap = _lineCap;
    _backgroundLayer.rasterizationScale = 2 * [UIScreen mainScreen].scale;
    _backgroundLayer.shouldRasterize = YES;
    
}

- (void)setupCircleLayerWithStrokeColor:(UIColor *)strokeColor {
    // Set up the shape of the circle
    
    CGFloat endAngle = [self calculateToValueWithPercent:_percent];
    
    // Make a circular shape
    _circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_radius, _radius) radius:_radius startAngle:kStartAngle endAngle:endAngle clockwise:_clockwise].CGPath;
    
    // Center the shape in self.view
    
    _circle.position = _centerPoint;
    
    // Configure the apperence of the circle
    _circle.fillColor = [UIColor clearColor].CGColor;
    _circle.strokeColor = strokeColor.CGColor;
    _circle.lineWidth = _lineWidth;
    _circle.lineCap = _lineCap;
    _circle.shouldRasterize = YES;
    _circle.rasterizationScale = 2 * [UIScreen mainScreen].scale;
    
}

- (void)drawCircle {
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = _duration; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    // kCAMediaTimingFunctionLinear         匀速
    // kCAMediaTimingFunctionEaseIn         慢进快出
    // kCAMediaTimingFunctionEaseOut        快进慢出
    // kCAMediaTimingFunctionEaseInEaseOut  两头慢中间快
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // Add the animation to the circle
    [_circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    
    CAKeyframeAnimation *colorsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
    colorsAnimation.calculationMode = kCAAnimationPaced;
    colorsAnimation.removedOnCompletion = NO;
    colorsAnimation.fillMode = kCAFillModeForwards;
    colorsAnimation.duration = _duration;
    
    [_circle addAnimation:colorsAnimation forKey:@"strokeColor"];
}

- (CGFloat)calculateToValueWithPercent:(CGFloat)percent {
    return (kStartAngle + (percent * 2 * M_PI) / 100);
}

- (void)startAnimation {
    [self drawCircle];
}

@end
