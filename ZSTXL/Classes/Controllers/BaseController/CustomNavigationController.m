//
//  CustomNavigationController.m
//  LeheV2
//
//  Created by  on 11-10-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        if([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
            //fix for iOS 5
            [self.navigationBar setBackgroundImage:[UIImage imageByName:@"nav_bar.png"] forBarMetrics:0];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect { 
    UIImage *stretchImage = [UIImage stretchableImage:@"nav_bar.png" leftCap:8 topCap:0];
    [stretchImage drawInRect:rect];
}

@end
