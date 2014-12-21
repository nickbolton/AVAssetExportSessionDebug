//
//  NSDate+Bedrock.m
//  Bedrock
//
//  Created by Nick Bolton on 2/10/11.
//  Copyright 2011 Pixelbleed LLC. All rights reserved.
//

#import "NSDate+Bedrock.h"

static NSString * const kPBMidnightObjectKey = @"midnight";
static NSString * const kPBEndOfDayObjectKey = @"end-of-day";
static NSString * const kPBFirstDayOfMonthObjectKey = @"first-day";
static NSString * const kPBLastDayOfMonthObjectKey = @"last-day";
static NSString * const kPBWeekdayObjectKey = @"weekday";

static NSMutableDictionary * PBDateValueCache = nil;

@interface NSDate()

@end

@implementation NSDate(Utilities)

//- (void)dealloc {
//    [self pb_setCacheValue:nil forKey:kPBMidnightObjectKey];
//    [self pb_setCacheValue:nil forKey:kPBEndOfDayObjectKey];
//    [self pb_setCacheValue:nil forKey:kPBFirstDayOfMonthObjectKey];
//    [self pb_setCacheValue:nil forKey:kPBLastDayOfMonthObjectKey];
//    [self pb_setCacheValue:nil forKey:kPBWeekdayObjectKey];
//}

- (void)pb_setCacheValue:(id)value forKey:(NSString *)key {

//    NSMutableDictionary *cache = [self pb_valueCache];
//
//    @synchronized (cache) {
//
//        if (key != nil) {
//
//            if (value != nil) {
//                cache[key] = value;
//            } else {
//                [cache removeObjectForKey:key];
//
//                if (cache.count == 0) {
//                    [PBDateValueCache removeObjectForKey:self.description];
//                }
//            }
//        }
//    }
}

- (id)pb_cacheValueForKey:(NSString *)key {

//    NSMutableDictionary *cache = [self pb_valueCache];

    id result = nil;

//    @synchronized (cache) {
//
//        if (key != nil) {
//            result = cache[key];
//        }
//    }

    return result;
}

- (NSMutableDictionary *)pb_dateValuesCache {

//    if (PBDateValueCache == nil) {
//        PBDateValueCache = [NSMutableDictionary dictionary];
//    }

    return PBDateValueCache;
}

- (NSMutableDictionary *)pb_valueCache {

    NSMutableDictionary *dateValuesCache = [self pb_dateValuesCache];

    NSDictionary *valuesCache = dateValuesCache[self.description];

    if (valuesCache == nil) {
        valuesCache = [NSMutableDictionary dictionary];
        dateValuesCache[self.description] = valuesCache;
    }

    return valuesCache;
}

- (NSDate *)pb_midnightObject {
    return [self pb_cacheValueForKey:kPBMidnightObjectKey];
}

- (void)pb_setMidnightObject:(NSDate *)midnight {
    [self pb_setCacheValue:midnight forKey:kPBMidnightObjectKey];
}

- (NSDate *)pb_endOfDayObject {
    return [self pb_cacheValueForKey:kPBEndOfDayObjectKey];
}

- (void)pb_setEndOfDayObject:(NSDate *)date {
    [self pb_setCacheValue:date forKey:kPBEndOfDayObjectKey];
}

#if TARGET_OS_IPHONE
- (BOOL)isGreaterThan:(id)object {
    NSComparisonResult result = [self compare:object];
    return result == NSOrderedDescending;
}

- (BOOL)isLessThan:(id)object {
    NSComparisonResult result = [self compare:object];
    return result == NSOrderedAscending;
}

- (BOOL)isGreaterThanOrEqualTo:(id)object {
    NSComparisonResult result = [self compare:object];
    return result == NSOrderedDescending || result == NSOrderedSame;
}

- (BOOL)isLessThanOrEqualTo:(id)object {
    NSComparisonResult result = [self compare:object];
    return result == NSOrderedAscending || result == NSOrderedSame;
}
#endif

+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day {

    return [self dateWithYear:year
                        month:month
                          day:day
                        hours:0
                      minutes:0];
}

+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                   hours:(NSInteger)hours
                 minutes:(NSInteger)minutes {

    NSCalendar *cal = [NSCalendar calendarForCurrentThread];

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:day];
    [dateComponents setHour:hours];
    [dateComponents setMinute:minutes];

    return [cal dateFromComponents:dateComponents];
}

+ (PBDateRange *)today {
    NSDate *now = [NSDate date];
    
    return [PBDateRange dateRangeWithStartDate:now
                                       endDate:now];
}

- (NSInteger)valueForCalendarUnit:(NSCalendarUnit)calendarUnit {
    NSCalendar *cal = [NSCalendar calendarForCurrentThread];
    NSDateComponents *dateComponents =
    [cal components:calendarUnit fromDate:self];

    NSInteger value = 0;

    switch (calendarUnit) {
        case NSYearCalendarUnit:
            value = dateComponents.year;
            break;

        case NSMonthCalendarUnit:
            value = dateComponents.month;
            break;

        case NSDayCalendarUnit:
            value = dateComponents.day;
            break;

        case NSHourCalendarUnit:
            value = dateComponents.hour;
            break;

        case NSMinuteCalendarUnit:
            value = dateComponents.minute;
            break;

        case NSSecondCalendarUnit:
            value = dateComponents.second;
            break;

        case NSWeekCalendarUnit:
            value = dateComponents.week;
            break;

        case NSWeekdayCalendarUnit:
            value = dateComponents.weekday;
            break;

        case NSWeekdayOrdinalCalendarUnit:
            value = dateComponents.weekdayOrdinal;
            break;

        case NSWeekOfMonthCalendarUnit:
            value = dateComponents.weekOfMonth;
            break;

        case NSWeekOfYearCalendarUnit:
            value = dateComponents.weekOfYear;
            break;
            
        default:
            break;
    }
    return value;
}

- (NSInteger)daysInBetweenDate:(NSDate *)date {
    
    NSTimeInterval lastDiff = [[date midnight] timeIntervalSinceNow];
    NSTimeInterval todaysDiff = [[self midnight] timeIntervalSinceNow];
    NSTimeInterval dateDiff = lastDiff - todaysDiff;
    return dateDiff / 86400;
}

- (NSDateComponents *)components:(NSCalendarUnit)components {

    NSCalendar *calendar = [NSCalendar calendarForCurrentThread];
    return [calendar components:components fromDate:self];
}

- (NSDateComponents *)components:(NSCalendarUnit)components
                          toDate:(NSDate *)date {

    NSCalendar *calendar = [NSCalendar calendarForCurrentThread];

    return
    [calendar
     components:components
     fromDate:self
     toDate:date
     options:0];
}

- (NSDate *)firstDayOfMonth {

	NSDate *firstDay = [self pb_cacheValueForKey:kPBFirstDayOfMonthObjectKey];

	if (firstDay == nil) {

        NSCalendar *calendar = [NSCalendar calendarForCurrentThread];

		NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
		firstDay = [calendar dateFromComponents:components];
        [self pb_setCacheValue:firstDay forKey:kPBFirstDayOfMonthObjectKey];
	}

	return firstDay;
}

- (NSDate *)lastDayOfMonth {

	NSDate *lastDay = [self pb_cacheValueForKey:kPBLastDayOfMonthObjectKey];

	if (lastDay == nil) {

        NSCalendar *calendar = [NSCalendar calendarForCurrentThread];

		NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
		[components setDay:[calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length];
		lastDay = [calendar dateFromComponents:components];
        [self pb_setCacheValue:lastDay forKey:kPBLastDayOfMonthObjectKey];
	}

	return lastDay;
}

- (NSInteger)weekday {

	NSNumber *weekday = [self pb_cacheValueForKey:kPBWeekdayObjectKey];

	if (weekday == nil) {

        NSCalendar *calendar = [NSCalendar calendarForCurrentThread];

		weekday = [NSNumber numberWithInteger:[calendar components:NSWeekdayCalendarUnit fromDate:self].weekday];
        [self pb_setCacheValue:weekday forKey:kPBWeekdayObjectKey];
	}

	return [weekday integerValue];
}

- (BOOL)isWithinRange:(PBDateRange *)dateRange {
    return
    [self isGreaterThanOrEqualTo:dateRange.startDate] &&
    [self isLessThanOrEqualTo:dateRange.endDate];
}

- (BOOL)isMidnight {
    NSDateComponents *dateComponents =
    [[NSCalendar calendarForCurrentThread]
     components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    
    return (dateComponents.hour + dateComponents.minute + dateComponents.second) == 0;
}

- (PBDateRange *)yesterday {
    NSDate *date = [self dateByAddingDays:-1];
    
    return [PBDateRange dateRangeWithStartDate:date
                                       endDate:date];    
}

- (PBDateRange *)tomorrow {
    NSDate *date = [self dateByAddingDays:1];
    
    return [PBDateRange dateRangeWithStartDate:date
                                       endDate:date];    
}

- (PBDateRange *)thisWeek {    
    return [self dateIntervalForTimePeriod:TimePeriod_ThisWeek];
}

- (PBDateRange *)lastWeek {
    return [self dateIntervalForTimePeriod:TimePeriod_LastWeek];
}

- (PBDateRange *)nextWeek {
    PBDateRange *nextWeek = [self thisWeek];
    nextWeek.startDate = [nextWeek.startDate dateByAddingDays:7];
    nextWeek.endDate = [nextWeek.endDate dateByAddingDays:7];
    return nextWeek;
}

- (PBDateRange *)thisMonth {
    return [self dateIntervalForTimePeriod:TimePeriod_ThisMonth];
}

- (PBDateRange *)lastMonth {
    return [self dateIntervalForTimePeriod:TimePeriod_LastMonth];
}

- (PBDateRange *)nextMonth {
    NSDateComponents *dateComponents;
    NSCalendar *cal = [NSCalendar calendarForCurrentThread];
    dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    
    NSDate *nextMonthDate = [cal dateByAddingComponents:dateComponents
                                                 toDate:self
                                                options:0];
    return [nextMonthDate thisMonth];
}

- (PBDateRange *)thisYear {
    return [self dateIntervalForTimePeriod:TimePeriod_ThisYear];
}

- (PBDateRange *)lastYear {
    return [self dateIntervalForTimePeriod:TimePeriod_LastYear];
}

- (NSDate *)endOfDay {
    return [self endOfDay:[NSCalendar calendarForCurrentThread]];
}

- (NSDate *)endOfDay:(NSCalendar *)cal {

    NSDate *result = [self pb_endOfDayObject];

    if (result == nil) {
        result = [[[self dateByAddingDays:1 withCal:cal] midnight:cal] dateByAddingTimeInterval:-1];
        [self pb_setEndOfDayObject:result];
    }

    return result;
}

- (NSInteger)dayOfTheWeek {
    return [self dayOfTheWeek:[NSCalendar calendarForCurrentThread]];
}

- (NSInteger)dayOfTheWeek:(NSCalendar *)cal {
    NSDateComponents *dateComponents = [cal components:NSWeekdayCalendarUnit fromDate:self];
    return [dateComponents weekday];
}

- (NSInteger)dayOfTheMonth {
    return [self dayOfTheMonth:[NSCalendar calendarForCurrentThread]];
}

- (NSInteger)dayOfTheMonth:(NSCalendar *)cal {
    NSDateComponents *dateComponents = [cal components:NSDayCalendarUnit fromDate:self];
    return [dateComponents day];
}

- (NSInteger)dayOfTheYear {
    return [self dayOfTheMonth:[NSCalendar calendarForCurrentThread]];
}

- (NSInteger)dayOfTheYear:(NSCalendar *)cal {
    return [cal ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:self];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks {
    return
    [self
     dateByAddingWeeks:weeks
     withCal:[NSCalendar calendarForCurrentThread]];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks withCal:(NSCalendar *)cal {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setWeek:weeks];
    NSDate *result = [cal dateByAddingComponents:dateComponents toDate:self options:0];
    return result;
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    return
    [self
     dateByAddingDays:days
     withCal:[NSCalendar calendarForCurrentThread]];
}

- (NSDate *)dateByAddingDays:(NSInteger)days withCal:(NSCalendar *)cal {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:days];
    NSDate *result = [cal dateByAddingComponents:dateComponents toDate:self options:0];
    return result;
}

- (NSDate *)dateByAddingSeconds:(NSTimeInterval)seconds {
    return
    [self
     dateByAddingSeconds:seconds
     withCal:[NSCalendar calendarForCurrentThread]];
}

- (NSDate *)dateByAddingSeconds:(NSTimeInterval)seconds withCal:(NSCalendar *)cal {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setSecond:seconds];
    NSDate *result = [cal dateByAddingComponents:dateComponents toDate:self options:0];
    return result;
}

- (NSDate *)dateByAddingComponents:(NSDateComponents *)components {

    NSCalendar *calendar = [NSCalendar calendarForCurrentThread];

    return
    [calendar
     dateByAddingComponents:components
     toDate:self
     options:0];
}

- (NSRange)rangeOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger {

    NSCalendar *calendar = [NSCalendar calendarForCurrentThread];

    return
    [calendar
     rangeOfUnit:smaller
     inUnit:larger
     forDate:self];
}

- (PBDateRange *)dateIntervalForTimePeriod:(TimePeriod)timePeriod {    
    return
    [self
     dateIntervalForTimePeriod:timePeriod
     withCal:[NSCalendar calendarForCurrentThread]];
}

- (NSDate *)midnight {
    return [self midnight:[NSCalendar calendarForCurrentThread]];
}

- (NSDate *)midnight:(NSCalendar *)cal {

    NSDate *result = [self pb_midnightObject];

    if (result == nil) {
        NSDateComponents *dateComponents =
        [cal components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:self];
        result = [cal dateFromComponents:dateComponents];

        [self pb_setMidnightObject:result];
    }

    return result;
}

- (PBDateRange *)dateIntervalForTimePeriod:(TimePeriod)timePeriod withCal:(NSCalendar *)cal {
    
    NSDate *fromDate, *toDate;
    NSDateComponents *dateComponents;
    NSInteger year;
    NSDate *now = [NSDate date];
    PBDateRange *dateRange;
    NSInteger firstDayOffset = 1-[NSCalendar firstWeekday];
    
    NSInteger dayOfTheWeek = [self dayOfTheWeek:cal] + firstDayOffset;
    
    if (dayOfTheWeek <= 0) {
        dayOfTheWeek += 7;
    }

    switch (timePeriod) {
        case TimePeriod_All:
            fromDate = [NSDate distantPast];
            toDate = [NSDate distantFuture];
            break;
        case TimePeriod_ThisWeek:
            fromDate = [self dateByAddingDays:(1-dayOfTheWeek) withCal:cal];
            toDate = [fromDate dateByAddingDays:6 withCal:cal];
            break;
        case TimePeriod_ThisMonth:
            fromDate = [self dateByAddingDays:(1-[self dayOfTheMonth:cal]) withCal:cal];
            dateComponents = [[NSDateComponents alloc] init];
            [dateComponents setMonth:1];
            [dateComponents setDay:-1];
            toDate = [cal dateByAddingComponents:dateComponents toDate:fromDate options:0];
            break;
        case TimePeriod_ThisYear:
            fromDate = [self dateByAddingDays:(1-[self dayOfTheYear:cal]) withCal:cal];
            dateComponents = [[NSDateComponents alloc] init];
            [dateComponents setYear:1];
            [dateComponents setDay:-1];
            toDate = [cal dateByAddingComponents:dateComponents toDate:fromDate options:0];
            break;            
        case TimePeriod_Yesterday:
            fromDate = toDate = [self dateByAddingDays:-1 withCal:cal];
            break;
        case TimePeriod_Tomorrow:
            fromDate = toDate = [self dateByAddingDays:1 withCal:cal];
            break;
        case TimePeriod_LastWeek:
            
            fromDate = [self dateByAddingDays:(1-dayOfTheWeek-7) withCal:cal];
            toDate = [fromDate dateByAddingDays:6 withCal:cal];
            break;
        case TimePeriod_LastMonth:
            toDate = [self dateByAddingDays:-[self dayOfTheMonth:cal] withCal:cal];
            dateComponents = [cal components:NSDayCalendarUnit fromDate:toDate];
            fromDate = [toDate dateByAddingDays:-([dateComponents day]-1) withCal:cal];
            break;            
        case TimePeriod_LastYear:
            dateComponents = [cal components:NSYearCalendarUnit fromDate:self];
            year = [dateComponents year] - 1;
            dateComponents = [[NSDateComponents alloc] init];
            [dateComponents setMonth:1];
            [dateComponents setDay:1];
            [dateComponents setYear:year];
            fromDate = [cal dateFromComponents:dateComponents];
            [dateComponents setMonth:12];
            [dateComponents setDay:31];
            toDate = [cal dateFromComponents:dateComponents];
            break;            
        case TimePeriod_PreviousWeek:
            toDate = [self yesterday].startDate;
            fromDate = [toDate dateByAddingDays:-6 withCal:cal];
            break;            
        case TimePeriod_PreviousMonth:
            /*
            toDate = self;
            dateComponents = [[[NSDateComponents alloc] init] autorelease];
            [dateComponents setMonth:-1];
            fromDate = [cal dateByAddingComponents:dateComponents toDate:toDate options:0];
            toDate = [self dateByAddingDays:-1 withCal:cal];
             */
            toDate = [self yesterday].startDate;
            fromDate = [toDate dateByAddingDays:-29 withCal:cal];
            break;            
        case TimePeriod_PreviousYear:
            /*
            toDate = self;
            dateComponents = [[[NSDateComponents alloc] init] autorelease];
            [dateComponents setYear:-1];
            fromDate = [cal dateByAddingComponents:dateComponents toDate:toDate options:0];
            toDate = [self dateByAddingDays:-1 withCal:cal];            
             */
            toDate = [self yesterday].startDate;
            fromDate = [toDate dateByAddingDays:-364 withCal:cal];
            break;
            
        case TimePeriod_Today:
            fromDate = toDate = now;
            break;
            
        default:
            
            if (timePeriod < 0) {
                toDate = now;
                fromDate = [toDate dateByAddingDays:timePeriod withCal:cal];
            }
            
            break;
    }
    
    if (toDate != nil && fromDate != nil) {
        return [PBDateRange dateRangeWithStartDate:fromDate endDate:toDate];
    }
    
    return nil;
}

+ (NSString *)labelForTimePeriod:(TimePeriod)timePeriod {
    
    NSString *label = nil;
    
    switch (timePeriod) {
//        case TimePeriod_All:
//            label = NSLocalizedString(@"all time", nil);
//            break;
        case TimePeriod_Today:
            label = NSLocalizedString(@"today", nil);
            break;
        case TimePeriod_ThisWeek:
            label = NSLocalizedString(@"this week", nil);
            break;
        case TimePeriod_ThisMonth:
            label = NSLocalizedString(@"this month", nil);
            break;            
//        case TimePeriod_ThisYear:
//            label = NSLocalizedString(@"this year", nil);
//            break;            
        case TimePeriod_Yesterday:
            label = NSLocalizedString(@"yesterday", nil);
            break;
        case TimePeriod_Tomorrow:
            label = NSLocalizedString(@"tomorrow", nil);
            break;
//        case TimePeriod_LastWeek:
//            label = NSLocalizedString(@"last week", nil);
//            break;            
//        case TimePeriod_LastMonth:
//            label = NSLocalizedString(@"last month", nil);
//            break;            
//        case TimePeriod_LastYear:
//            label = NSLocalizedString(@"last year", nil);
//            break;            
//        case TimePeriod_PreviousWeek:
//            label = NSLocalizedString(@"previous week", nil);
//            break;            
//        case TimePeriod_PreviousMonth:
//            label = NSLocalizedString(@"previous month", nil);
//            break;            
//        case TimePeriod_PreviousYear:
//            label = NSLocalizedString(@"previous year", nil);
//            break;
    }
    
    return label;
}

+ (NSString *)properLabelForTimePeriod:(TimePeriod)timePeriod {
    
    NSString *label = nil;
    
    switch (timePeriod) {
        case TimePeriod_All:
            label = PBLoc(@"All Time");
            break;
        case TimePeriod_Today:
            label = PBLoc(@"Today");
            break;
        case TimePeriod_ThisWeek:
            label = PBLoc(@"This Week");
            break;
        case TimePeriod_ThisMonth:
            label = PBLoc(@"This Month");
            break;
        case TimePeriod_ThisYear:
            label = PBLoc(@"This Year");
            break;
        case TimePeriod_Yesterday:
            label = PBLoc(@"Yesterday");
            break;
        case TimePeriod_Tomorrow:
            label = PBLoc(@"Tomorrow");
            break;
        case TimePeriod_LastWeek:
            label = PBLoc(@"Last Week");
            break;
        case TimePeriod_LastMonth:
            label = PBLoc(@"Last Month");
            break;
        case TimePeriod_LastYear:
            label = PBLoc(@"Last Year");
            break;
        case TimePeriod_PreviousWeek:
            label = PBLoc(@"Previous Week");
            break;
        case TimePeriod_PreviousMonth:
            label = PBLoc(@"Previous Month");
            break;
        case TimePeriod_PreviousYear:
            label = PBLoc(@"Previous Year");
            break;
        case TimePeriod_OtherDay:
            label = PBLoc(@"Other Day");
            break;
        case TimePeriod_OtherDateRange:
            label = PBLoc(@"Other Range");
            break;
        default:
            if (timePeriod == 0) {
                label = PBLoc(@"None");
            } else if (timePeriod < 0) {
                label = PBLoc(@"Days Back");
            } else {
                label = PBLoc(@"Unknown");
            }
            break;
    }
    
    return label;
}

+ (NSString *)properLabelForSingleDayTimePeriod:(TimePeriod)timePeriod {
    
    NSString *label = nil;
    
    switch (timePeriod) {
        case TimePeriod_All:
            label = PBLoc(@"First Time Entry");
            break;
        case TimePeriod_Today:
            label = PBLoc(@"Today");
            break;
        case TimePeriod_ThisWeek:
            label = PBLoc(@"Start of This Week");
            break;
        case TimePeriod_ThisMonth:
            label = PBLoc(@"Start of This Month");
            break;
        case TimePeriod_ThisYear:
            label = PBLoc(@"Start of This Year");
            break;
        case TimePeriod_Yesterday:
            label = PBLoc(@"Yesterday");
            break;
        case TimePeriod_Tomorrow:
            label = PBLoc(@"Tomorrow");
            break;
        case TimePeriod_LastWeek:
            label = PBLoc(@"Start of Last Week");
            break;
        case TimePeriod_LastMonth:
            label = PBLoc(@"Start of Last Month");
            break;
        case TimePeriod_LastYear:
            label = PBLoc(@"Start of Last Year");
            break;
        case TimePeriod_PreviousWeek:
            label = PBLoc(@"Start of Previous Week");
            break;
        case TimePeriod_PreviousMonth:
            label = PBLoc(@"Start of Previous Month");
            break;
        case TimePeriod_PreviousYear:
            label = PBLoc(@"Start of Previous Year");
            break;
        case TimePeriod_OtherDay:
            label = PBLoc(@"Other Day");
            break;
        case TimePeriod_OtherDateRange:
            label = PBLoc(@"Other Range");
            break;
        default:
            if (timePeriod == 0) {
                label = PBLoc(@"None");
            } else if (timePeriod < 0) {
                label = PBLoc(@"Days Back");
            } else {
                label = PBLoc(@"Unknown");
            }
            break;
    }

    return label;
}

+ (NSString *)labelForDayOfTheWeek:(NSCalendarUnit)dayOfTheWeek {
    
    if (dayOfTheWeek < 1 || dayOfTheWeek > 7) return nil;

    NSCalendar *calendar = [NSCalendar calendarForCurrentThread];

    NSDate *date = [NSDate dateWithYear:2014 month:6 day:1];
    date = [date dateByAddingDays:dayOfTheWeek-1];
        
    NSLocale *locale = [NSLocale currentLocale];
    
    NSString *dateFormat =
    [NSDateFormatter
     dateFormatFromTemplate:@"EEEE"
     options:0
     locale:locale];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = locale;
    dateFormatter.dateFormat = dateFormat;
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)labelForTime:(NSCalendarUnit)hour {
    
    if (hour < 0 || hour > 23) return nil;
    
    NSCalendar *calendar = [NSCalendar calendarForCurrentThread];
    
    NSDate *date =
    [NSDate dateWithYear:2014 month:6 day:1 hours:hour minutes:0];
    
    NSLocale *locale = [NSLocale currentLocale];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = locale;
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    return [dateFormatter stringFromDate:date];
}

- (NSString *)description {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss aaa";
    
    return [dateFormatter stringFromDate:self];
}

@end
