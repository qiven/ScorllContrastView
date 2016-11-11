//
//  UIImage+Extension.m
//  TableView+Collection
//
//  Created by More Mocha on 16/10/21.
//  Copyright © 2016年 QW. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

- (void)qi_cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *))completion {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIGraphicsBeginImageContextWithOptions(size, true, 0);
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        [fillColor setFill];
        UIRectFill(rect);
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        [path addClip];
        [self drawInRect:rect];
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result != nil) {
                completion(result);
            }
        });
    });
}

@end


