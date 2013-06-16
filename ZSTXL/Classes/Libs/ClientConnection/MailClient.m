//
//  MailClient.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-12.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MailClient.h"
#import "AFJSONRequestOperation.h"

NSString * const kMailBaseURLString = @"http://192.168.1.199:8080/BLZTWeb/mail/";
//NSString * const kMailBaseURLString = @"http://www.boracloud.com:9101/BLZTCloud";


@implementation MailClient

+ (MailClient *)sharedClient {
    static MailClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kMailBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    return self;
}

+ (void)getWithURLParameters:(NSDictionary *)parameters
                     success:(void (^)(NSDictionary *json))successBlock
                     failure:(void (^)(NSError *error))failureBlock {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];

    NSString *username = [parameters objForKey:@"username"];
    NSString *password = [parameters objForKey:@"password"];
    if (![username isValid] ) {
        [kAppDelegate showWithCustomAlertViewWithText:@"邮件用户名为空" andImageName:kErrorIcon];
    }
    else{
        [mutableParameters removeObjectForKey:@"username"];
    }
    
    if (![password isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"密码为空" andImageName:kErrorIcon];
    }else{
        [mutableParameters removeObjectForKey:@"password"];
    }
    
    [[MailClient sharedClient] clearAuthorizationHeader];
    [[MailClient sharedClient] setAuthorizationHeaderWithUsername:username password:password];
    
    
    NSString *path = [mutableParameters objForKey:@"path"];
    if ([path isValid]) {
        [mutableParameters removeObjectForKey:@"path"];
    }
    [[MailClient sharedClient] getPath:path parameters:mutableParameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        if (successBlock) {
            if ([JSON isKindOfClass:[NSDictionary class]]) {
                successBlock((NSDictionary *)JSON);
            }
            if ([JSON isKindOfClass:[NSString class]]) {
                successBlock((NSDictionary *)[JSON objectFromJSONString]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (void)postWithParameters:(NSDictionary *)parameters
              successBlock:(void (^)(id))successBlock
                   failure:(void (^)(void))failureBlock
{
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    NSString *username = [parameters objForKey:@"username"];
    NSString *password = [parameters objForKey:@"password"];
    if (![username isValid] ) {
        [kAppDelegate showWithCustomAlertViewWithText:@"邮件用户名为空" andImageName:kErrorIcon];
    }
    else{
        [mutableParameters removeObjectForKey:@"username"];
    }
    
    if (![password isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"密码为空" andImageName:kErrorIcon];
    }else{
        [mutableParameters removeObjectForKey:@"password"];
    }
    
    [[MailClient sharedClient] clearAuthorizationHeader];
    [[MailClient sharedClient] setAuthorizationHeaderWithUsername:username password:password];
    
    
    NSString *path = [mutableParameters objForKey:@"path"];
    if ([path isValid]) {
        [mutableParameters removeObjectForKey:@"path"];
    }
    
    [[MailClient sharedClient] postPath:path parameters:mutableParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock();
    }];
}

@end
