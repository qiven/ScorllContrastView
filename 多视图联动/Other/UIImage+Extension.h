//
//  UIImage+Extension.h
//  TableView+Collection
//
//  Created by More Mocha on 16/10/21.
//  Copyright © 2016年 QW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

- (void)qi_cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *))completion;

@end
