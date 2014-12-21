//
//  NSCalendar+Bedrock.m
//  Calendar
//
//  Created by Nick Bolton on 1/20/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "NSCalendar+Bedrock.h"

@implementation NSCalendar (Bedrock)

+ (NSCalendar *)calendarForCurrentThread {
    return [self calendarForThread:[NSThread currentThread]];
}

+ (NSCalendar *)calendarForThread:(NSThread *)thread {

    static NSString * const threadDictionaryKey = @"NSDateAGCategoryGregorianCalendar";

    NSMutableDictionary *threadDictionary = [thread threadDictionary];

	NSCalendar *gregorianCalendar = [threadDictionary objectForKey:threadDictionaryKey];
    if (gregorianCalendar == nil) {
		gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		[threadDictionary setObject:gregorianCalendar forKey:threadDictionaryKey];
	}

    if (thread.isMainThread == NO) {

        NSCalendar *mainCalendar = [self calendarForThread:[NSThread mainThread]];
        gregorianCalendar.firstWeekday = mainCalendar.firstWeekday;
    }

    return gregorianCalendar;
}

- (NSInteger)daysWithinEraFromDate:(NSDate *)startDate
                            toDate:(NSDate *)endDate {

    NSInteger startDay =
    [self
     ordinalityOfUnit:NSDayCalendarUnit
     inUnit: NSEraCalendarUnit
     forDate:startDate];

    NSInteger endDay =
    [self
     ordinalityOfUnit:NSDayCalendarUnit
     inUnit:NSEraCalendarUnit
     forDate:endDate];

    return endDay-startDay;
}

+ (NSInteger)numberOfDaysInWeek {

    NSCalendar *calendar = [NSCalendar calendarForCurrentThread];

	return
    [calendar
     rangeOfUnit:NSWeekdayCalendarUnit
     inUnit:NSWeekCalendarUnit
     forDate:[NSDate date]].length;
}

+ (NSInteger)firstWeekday {
    NSCalendar *mainCalendar =
    [NSCalendar calendarForThread:[NSThread mainThread]];
    return mainCalendar.firstWeekday;
}

+ (void)setFirstWeekday:(NSInteger)weekday {
    NSCalendar *mainCalendar =
    [NSCalendar calendarForThread:[NSThread mainThread]];
    mainCalendar.firstWeekday = weekday;
}

@end
