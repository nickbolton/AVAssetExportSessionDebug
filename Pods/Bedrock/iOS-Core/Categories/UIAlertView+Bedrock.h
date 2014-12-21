//
//  UIAlertView+Bedrock.h
//  Bedrock
//
//  Created by Nick Bolton on 7/20/12.
//  Copyright (c) 2012 Pixelbleed LLC. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIAlertView (Bedrock)

+ (void)presentOKAlertWithTitle:(NSString *)title 
                     andMessage:(NSString *)message;

+ (BOOL)showHint:(NSString *)hintKey
           title:(NSString *)title
         message:(NSString *)message;

@end
