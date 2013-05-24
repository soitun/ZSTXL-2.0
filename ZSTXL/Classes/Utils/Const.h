//
//  Const.h
//  DreamFactory
//
//  Created by  on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568 )
#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define NavigationBar_HEIGHT 44
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// Client Version
#define kClientVersion  [[[NSBundle mainBundle] infoDictionary] objForKey:@"CFBundleVersion"]
#define kDeviceUuid     [[UIDevice currentDevice] uniqueIdentifier]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#define bgSkyBlueColor  RGBCOLOR(0,184,238)
#define bgGreyColor     RGBCOLOR(231,234,239)
#define kContentColor   RGBCOLOR(70, 70, 70)
#define kSubContentColor RGBCOLOR(98, 98, 98)

#define kContentBlueColor RGBCOLOR(39,104,145)
#define kContentGrayColor RGBCOLOR(200,200,200)

#define kEventShakeHand @"kEventShakeHand"
#define kNetworkError  @"网络不给力啊"
#define kErrorIcon     @"ico_error_info"


#define kUserId @"userid"
#define KUserName @"KUserName"
#define KPassWord @"KPassWord"
#define kCityId @"kCityId"
#define kProvinceId @"kProvinceId"
#define kCityName @"kCityName"

#define kBaseKey @"A66C3EDD0A4A48EE85D389C316D18A60"
#define kLoginNotification @"kLoginNotification"

#define kBoraMailIMAPPort @"143"
#define KBoraMailSmtpPort @"25"
#define KBoraMailSmtpServer @"smtp.boramail.com"
#define KBoraMailIMAPServer @"imap.boramail.com"


typedef struct
{
	double lat;
	double lon;
} GPoint;

#define GET_RETURNCODE(xx_json) \
[[xx_json objForKey:@"returnCode"] stringValue]

#define GET_RETURNMESSAGE(xx_json) \
[[xx_json objForKey:@"returnMess"] stringValue]

#define DB_SAVE() ([[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait])


#define APP_DEBUG

//Debug
#ifdef APP_DEBUG
#  define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#  define DLog(...)
#endif
