//
//  Const.h
//  DreamFactory
//
//  Created by  on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define kDatasourceClassTwo     [[[[kAppDelegate helper] arrayForDrugListClassOne] objectAtIndex:self.mIndex] objForKey:@"listtwo"]

#define kAppDelegate ((ZXCXBlytAppDelegate *)[[UIApplication sharedApplication] delegate])
// Client Version
#define kClientVersion  [[[NSBundle mainBundle] infoDictionary] objForKey:@"CFBundleVersion"]
#define kDeviceUuid     [[UIDevice currentDevice] uniqueIdentifier]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define kEventShakeHand @"kEventShakeHand"
#define kNetworkError  @"网络不给力啊"
#define kErrorIcon     @"ico_error_info"

#define kReivewedNews  @"reviewednews"

#define kDefaultBeginWork @"08:00"
#define kDefaultEndWork @"18:00"

#define kThirdPartEventJavaScriptRequest    @"kThirdPartEventJavaScriptRequest"
#define kEventProductionCategorySelected  @"kEventProductionCategorySelected"
#define kEventBackToZhaoshangMainPage     @"kEventBackToZhaoshangMainPage"
#define bgSkyBlueColor  RGBCOLOR(0,184,238)
#define bgGreyColor     RGBCOLOR(231,234,239)
#define kContentColor   RGBCOLOR(70, 70, 70)
#define kSubContentColor RGBCOLOR(90, 90, 90)
#define kDefaultIamgeScale             640
#define kDefaultPageSizeString         @"40"
#define kDefaultPageSizeLessString     @"20"

#define kEventNewMessage @"kEventNewMessage"
#define kEventInsideMessage @"kEventInsideMessage"
typedef struct
{
	double lat;
	double lon;
} GPoint;

#define GET_RETURNCODE(xx_json) \
[[xx_json objForKey:@"returnCode"] stringValue]

#define GET_RETURNMESSAGE(xx_json) \
[[xx_json objForKey:@"returnMess"] stringValue]
