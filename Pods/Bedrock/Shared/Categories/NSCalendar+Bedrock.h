//
//  NSCalendar+Bedrock.h
//  Calendar
//
//  Created by Nick Bolton on 1/20/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Bedrock)

+ (NSCalendar *)calendarForCurrentThread;
+ (NSCalendar *)calendarForThread:(NSThread *)thread;

- (NSInteger)daysWithinEraFromDate:(NSDate *)startDate
                            toDate:(NSDate *)endDate;

+ (NSInteger)numberOfDaysInWeek;
+ (NSInteger)firstWeekday;
+ (void)setFirstWeekday:(NSInteger)weekDay;

@end
