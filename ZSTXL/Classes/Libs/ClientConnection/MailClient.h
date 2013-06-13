//
//  MailClient.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-12.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "AFHTTPClient.h"

@interface MailClient : AFHTTPClient

+ (MailClient *)sharedClient;

+ (void)getWithURLParameters:(NSDictionary *)parameters
                     success:(void (^)(NSDictionary *json))successBlock
                     failure:(void (^)(NSError *error))failureBlock;

@end
