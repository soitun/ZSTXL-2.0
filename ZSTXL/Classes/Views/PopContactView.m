//
//  ContactView.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PopContactView.h"

@implementation PopContactView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    if (self.contact) {
        self.nameLabel.text = self.contact.username;
        self.useridLabel.text = self.contact.userid;
        [self.avatar setImageWithURL:[NSURL URLWithString:self.contact.picturelinkurl] placeholderImage:[UIImage imageByName:@"pop_avatar.png"]];
        
        self.xunImage.hidden = self.contact.ismember.intValue ? YES : NO;
        self.xunVImage.hidden = self.contact.col2.intValue ? YES : NO;
        
        [Utility addRoundCornerToView:self.avatar];
    }
    
}

- (id)initWithNib:(NSString *)nib
{
    self = [[[NSBundle mainBundle] loadNibNamed:nib owner:nil options:nil] lastObject];
    if (self) {
        self.bgControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
        self.bgControl.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
        [self.bgControl addTarget:self action:@selector(tapBg) forControlEvents:UIControlEventTouchUpInside];
        
        self.frame = CGRectMake(34, 150, 252, 170);
        [self.bgControl addSubview:self];
    }
    return self;
}

- (void)dealloc {
    [_avatar release];
    [_nameLabel release];
    [_useridLabel release];
    [_xunImage release];
    [_xunVImage release];
    [_xunBImage release];
    [super dealloc];
}
- (IBAction)closeAction:(UIButton *)sender
{
    if (self.bgControl) {
        [self.bgControl removeFromSuperview];
        self.bgControl = nil;
    }
}

- (IBAction)telAction:(UIButton *)sender {
    
    NSDictionary *para = @{@"path": @"getAllowtelStatus.json",
                           @"userid": kAppDelegate.userId,
                           @"peopleid": self.contact.userid};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        DLog(@"json %@", json);
        if (RETURNCODE_ISVALID(json)) {
            
            //returnCode 为0时可以打电话
            
            NSString *userTel = [json objForKey:@"userTel"];
            if (![userTel isEqual:[NSNull null]]) {
                self.contact.tel = userTel;
            }
            
            
            [self.bgControl removeFromSuperview];
            if ([self.delegate respondsToSelector:@selector(popContactViewTel:)]) {
                [self.delegate performSelector:@selector(popContactViewTel:) withObject:self.contact];
            }
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
    
    

}

- (IBAction)chatAction:(UIButton *)sender {
    [self.bgControl removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(popContactViewChat:)]) {
        [self.delegate performSelector:@selector(popContactViewChat:) withObject:self.contact];
    }
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self.bgControl];
}

- (void)tapBg
{
    [self.bgControl removeFromSuperview];
}

@end
