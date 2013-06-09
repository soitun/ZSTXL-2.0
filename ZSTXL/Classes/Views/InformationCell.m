//
//  InformationCell.m
//  ZXCXBlyt
//
//  Created by zly on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InformationCell.h"

@implementation InformationCell


@synthesize labSubTitle;
@synthesize labTitle;
@synthesize avatar;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}


- (void)dealloc {
    [avatar release];
    [labTitle release];
    [labSubTitle release];
    [labTip release];
    [super dealloc];
}
@end
