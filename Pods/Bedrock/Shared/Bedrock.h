//
//  Bedrock.h
//  Bedrock
//
//  Created by Nick Bolton on 1/1/13.
//  Copyright (c) 2013 Pixelbleed. All rights reserved.
//

#ifndef Bedrock_Bedrock_h
#define Bedrock_Bedrock_h

# define PBDebugLog(...) if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"debugMode"] boolValue] == YES) { NSLog(@"[%@:%d (%p)]: %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, self, [NSString stringWithFormat:__VA_ARGS__]); }

#if DEBUG
#define PBLog(...) NSLog(__VA_ARGS__)
#else
#define PBLog(...) do { } while (0)
#endif

// add -DTCDEBUG to Other C Flags for Debug

#define PBLogOff(...) do { } while (0)
#define PBLogOn(...) NSLog(__VA_ARGS__)

#import "NSString+Bedrock.h"
#import "NSArray+Bedrock.h"
#import "NSObject+Bedrock.h"
#import "NSLayoutConstraint+Bedrock.h"
#import "NSNotification+Bedrock.h"
#import "PBDateRange.h"
#import "NSDate+Bedrock.h"
#import "NSCalendar+Bedrock.h"
#import "NSValue+Bedrock.h"
#import "NSDateComponents+Bedrock.h"
#import "PBSwizzler.h"

#if TARGET_OS_IPHONE
#import "PBActionDelegate.h"
#import "PBGradientView.h"
#import "UIAlertView+Bedrock.h"
#import "UIColor+Bedrock.h"
#import "UIImage+Bedrock.h"
#import "UIView+Bedrock.h"
#import "UIButton+Bedrock.h"
#import "UIBezierView.h"
#import "UIBezierButton.h"
#import "UINavigationController+Bedrock.h"
#import "UIViewController+Bedrock.h"
#else

#define PB_WINDOW_ANIMATION_DURATION 0.25f
#define PB_EASE_IN ([CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn])
#define PB_EASE_OUT ([CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut])
#define PB_EASE_INOUT ([CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut])

#import "NSAlert+Bedrock.h"
#import "NSAppleScript+Bedrock.h"
#import "NSAttributedString+Bedrock.h"
#import "NSButton+Bedrock.h"
#import "NSColor+Bedrock.h"
#import "NSEvent+Bedrock.h"
#import "NSFileManager+Bedrock.h"
#import "NSImage+Bedrock.h"
#import "NSTask+Bedrock.h"
#import "NSTextField+Bedrock.h"
#import "NSUserNotification+Bedrock.h"
#import "NSView+Bedrock.h"
#import "NSWindow+Bedrock.h"
#import "PBAnimator.h"

#import "PBClickableLabel.h"
#import "PBMainWindow.h"
#import "PBMiddleAlignedTextField.h"
#import "PBMiddleAlignedTextFieldCell.h"
#import "PBNotifyingButton.h"
#import "PBShadowTextFieldCell.h"
#import "PBStretchableBackgroundView.h"
#import "PBStretchableImageView.h"
#import "PBToggleImageView.h"
#import "PPMainView.h"

#endif

#define PBLoc(key) NSLocalizedString(key, nil)
#define PBLocalizedString(key, comment) NSLocalizedStringFromTableInBundle(key, @"pixelbleed", [NSBundle bundleForClass: [PBDummyClass class]], comment)

#endif
