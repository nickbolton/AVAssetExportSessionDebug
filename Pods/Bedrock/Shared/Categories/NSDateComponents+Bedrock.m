//
//  NSDateComponents+Bedrock.m
//  Calendar
//
//  Created by Nick Bolton on 2/2/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "NSDateComponents+Bedrock.h"

@implementation NSDateComponents (Bedrock)

+ (NSDateComponents *)components:(NSCalendarUnit)components
                        fromDate:(NSDate *)date {

    NSCalendar *calendar = [NSCalendar calendarForCurrentThread];

    return
    [calendar
     components:components
     fromDate:date];
}

- (BOOL)dateFromComponentsBoundByComponents:(NSDateComponents *)components
                            otherComponents:(NSDateComponents *)otherComponents {

    NSInteger value = [self dateValue];
    NSInteger componentsValue = [components dateValue];
    NSInteger otherValue = [otherComponents dateValue];

    return
    (componentsValue <= value && value <= otherValue) ||
    (otherValue <= value && value <= componentsValue);
}

- (NSInteger)dateValue {

    NSInteger result = self.day;
    result += self.month * 100;
    result += self.year * 10000;
    return  result;
}

@end
