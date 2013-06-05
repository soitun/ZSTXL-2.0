//
//  PublishSellToViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-2.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PublishBaseViewController.h"

@protocol PublishSellToViewControllerDelegate <NSObject>

- (void)publishSellToSelectFinish:(NSArray *)array;

@end

@interface PublishSellToViewController : PublishBaseViewController


@end
