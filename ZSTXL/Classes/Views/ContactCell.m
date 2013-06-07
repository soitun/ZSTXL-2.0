//
//  ContactCell.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell

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
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar)] autorelease];
    [self.headIcon addGestureRecognizer:tap];
}

- (void)dealloc {
    [_headIcon release];
    [_nameLabel release];
    [_xun_VImage release];
    [_ZDLabel release];
    [_preferLabel release];
    [super dealloc];
}

#pragma mark - tap avatar

- (void)tapAvatar
{
    if ([self.delegate respondsToSelector:@selector(contactCellTapAvatarOfContact:)]) {
        [self.delegate performSelector:@selector(contactCellTapAvatarOfContact:) withObject:self.contact];
    }
}

- (void)refresh
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.contact) {
        
        switch (self.contact.invagency.intValue) {
            case 1:
                self.ZDLabel.text = @"招商";
                break;
            case 2:
                self.ZDLabel.text = @"代理";
                break;
            case 3:
                self.ZDLabel.text = @"招商/代理";
                break;
            default:
                break;
        }
        
        self.headIcon.layer.cornerRadius = 4;
        self.headIcon.layer.masksToBounds = YES;
        [self.headIcon setImageWithURL:[NSURL URLWithString:self.contact.picturelinkurl]
                      placeholderImage:[UIImage imageByName:@"avatar"]];
        
        
        if ([self.contact.remark isValid]) {
            NSMutableString *userName = [NSMutableString stringWithFormat:@"%@(%@)", self.contact.username, self.contact.remark];
            self.nameLabel.text = userName;
        }
        else{
            self.nameLabel.text = self.contact.username;
        }
        
        self.preferLabel.text = self.contact.prefercontent;
    }
}

@end
