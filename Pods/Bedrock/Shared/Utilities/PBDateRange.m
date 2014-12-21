//
//  PBDateRange.m
//  Bedrock
//
//  Created by Nick Bolton on 3/24/12.
//  Copyright (c) 2012 Pixelbleed LLC. All rights reserved.
//

#import "PBDateRange.h"
#import "NSDate+Bedrock.h"

@interface PBDateRange()

@property (nonatomic) NSUInteger hashValue;
@property (nonatomic) BOOL alignToDayBoundaries;
@property (nonatomic, readwrite) NSArray *dateArray;

@end

@implementation PBDateRange

+ (id)dateRangeWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {    
    return
    [self
     dateRangeWithStartDate:startDate
     endDate:endDate
     alignToDayBoundaries:YES];
}

+ (instancetype)dateRangeWithStartDate:(NSDate *)startDate
                               endDate:(NSDate *)endDate
                  alignToDayBoundaries:(BOOL)alignToDayBoundaries {
    return
    [[PBDateRange alloc]
     initWithStartDate:startDate
     endDate:endDate
     alignToDayBoundaries:alignToDayBoundaries];
}

- (id)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    return
    [self
     initWithStartDate:startDate
     endDate:endDate
     alignToDayBoundaries:YES];
}

- (instancetype)initWithStartDate:(NSDate *)startDate
                          endDate:(NSDate *)endDate
             alignToDayBoundaries:(BOOL)alignToDayBoundaries {


    self = [super init];
    
    if (self != nil) {

        self.alignToDayBoundaries = alignToDayBoundaries;

        if (alignToDayBoundaries) {
            self.startDate = [startDate midnight];
            self.endDate = [endDate endOfDay];
        } else {
            self.startDate = startDate;
            self.endDate = endDate;
        }
        _hashValue = [self description].hash;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return
    [[PBDateRange alloc]
     initWithStartDate:self.startDate
     endDate:self.endDate
     alignToDayBoundaries:NO];
}

- (NSUInteger)hash {
    return _hashValue;
}

- (BOOL)isEqual:(id)object {
    PBDateRange *that = object;
    
    if ([that isKindOfClass:[PBDateRange class]] == YES) {
        return [self.startDate isEqualToDate:that.startDate] && [self.endDate isEqualToDate:that.endDate];
    }
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@", _startDate, _endDate];
}

- (void)setStartDate:(NSDate *)startDate {
    _startDate = startDate;
    _dateArray = nil;
}

- (void)setEndDate:(NSDate *)endDate {
    _endDate = endDate;
    _dateArray = nil;
}

- (NSArray *)dateArray {

    if (_dateArray == nil) {
        
        NSMutableArray *dates = [NSMutableArray array];
        
        NSInteger days = [self daysInRange];
        NSDate *date;
        
        for (NSInteger i = 0; i < days; i++) {
            
            date = [[self.startDate dateByAddingDays:i] midnight];
            [dates addObject:date];
        }
        
        _dateArray = dates;
    }
    
    return _dateArray;
}

- (BOOL)dateWithinRange:(NSDate *)date {
    return
    [date isGreaterThanOrEqualTo:_startDate] &&
    [date isLessThanOrEqualTo:_endDate];
}

- (BOOL)componentsWithinRange:(NSDateComponents *)components {

    NSDateComponents *startDateComponents =
    [self.startDate
     components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay];

    NSDateComponents *endDateComponents =
    [self.endDate
     components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay];

    return
    [components
     dateFromComponentsBoundByComponents:startDateComponents
     otherComponents:endDateComponents];
}

- (NSInteger)daysInRange {

    NSDateComponents *components =
    [self.startDate
     components:NSCalendarUnitDay
     toDate:self.endDate];

    return components.day + 1;
}

- (void)adjustDateRangeToDate:(NSDate *)date {

    NSTimeInterval duration =
    self.endDate.timeIntervalSinceReferenceDate -
    self.startDate.timeIntervalSinceReferenceDate;

    if (self.alignToDayBoundaries) {
        self.endDate = [date endOfDay];
    } else {
        self.endDate = date;
    }
    self.startDate = [self.endDate dateByAddingTimeInterval:-duration];
}

- (NSTimeInterval)durationInRangeWithStartTime:(NSDate *)startTime
                                       endTime:(NSDate *)endTime
                                           now:(NSDate *)now {

    NSDate *start = startTime;
    NSDate *end = endTime;
    NSDate *dateRangeEnd = self.endDate;

    NSDate *midnight = self.startDate.midnight;
    NSDate *nextMidnight = [midnight dateByAddingDays:1];
    NSDate *endOfDay = [self.startDate endOfDay];

    if (now == nil) {
        now = [NSDate date];
    }

    if ([midnight isEqualToDate:self.startDate] &&
        [endOfDay isEqualToDate:self.endDate]) {

        dateRangeEnd = nextMidnight;
    }

    if (end == nil) {
        end = now;
    }

    if ([start isLessThan:self.startDate]) {
        start = self.startDate;
    }

    if ([end isGreaterThan:dateRangeEnd]) {
        end = dateRangeEnd;
    }

    if ([end isLessThan:start]) {
        return 0.0f;
    }

    NSTimeInterval result = [end timeIntervalSinceDate:start];
    return result;
}

@end
