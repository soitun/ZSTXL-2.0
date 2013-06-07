//
//  SendMessageViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-10.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import <MessageUI/MessageUI.h>
#import "GroupSendViewController.h"

@interface SendMessageViewController : UIViewController <UITextViewDelegate, GroupSendVCDelegate>

- (IBAction)addContact:(UIButton *)sender;


@property (nonatomic, retain) UIButton *backBarButton;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) IBOutlet UIImageView *textBgImageView;

@property (nonatomic, retain) Contact *currentContact;
@property (nonatomic, retain) NSMutableArray *contactArray;

@property (nonatomic, copy) NSString *content;


@end
