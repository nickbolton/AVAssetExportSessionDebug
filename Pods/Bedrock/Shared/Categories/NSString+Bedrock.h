//
//  NSString+Bedrock.h
//  Bedrock
//
//  Created by Nick Bolton on 1/1/13.
//  Copyright (c) 2013 Pixelbleed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Bedrock)

+ (NSString *)applicationDocumentsDirectory;
+ (NSString *)uuidString;
+ (NSString *)deviceIdentifier;
+ (NSString *)timestampedGuid;
+ (NSString *)applicationInstanceId;
+ (NSString *)machineName;
+ (NSString *)safeString:(NSString *)value;
- (NSString *)trimmedValue;
- (NSString *)md5Digest;

@end
