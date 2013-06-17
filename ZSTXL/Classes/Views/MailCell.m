//
//  MailCell.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MailCell.h"

@implementation MailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.editing) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    else{
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [super setSelected:selected animated:animated];
}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    if (editing == YES) {
//        self.selectionStyle = UITableViewCellSelectionStyleBlue;
//    }
//    else{
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//}

- (void)dealloc {
    [_mailIcon release];
    [_titleLabel release];
    [_dateLabel release];
    [_detailLabel release];
    [super dealloc];
}
@end
