//
//  RankInfo.m
//  vanke
//
//  Created by apple on 13-6-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RankInfo.h"

@implementation RankInfo

@synthesize totalID = _totalID;
@synthesize memberID = _memberID;
@synthesize mileage = _mileage;
@synthesize minute = _minute;
@synthesize speed = _speed;
@synthesize calorie = _calorie;
@synthesize energy = _energy;
@synthesize runTimes = _runTimes;
@synthesize beginTime = _beginTime;
@synthesize endTime = _endTime;
@synthesize rank = _rank;

+(RankInfo *)initWithNSDictionary:(NSDictionary *)dict{
    
    RankInfo *rankInfo = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            rankInfo = [[RankInfo alloc] init];
            rankInfo.totalID = [[dict objectForKey:@"totalID"] longValue];
            rankInfo.memberID = [[dict objectForKey:@"memberID"] longValue];
            rankInfo.mileage = [[dict objectForKey:@"mileage"] floatValue];
            rankInfo.minute = [[dict objectForKey:@"minute"] floatValue];
            rankInfo.speed = [[dict objectForKey:@"speed"] floatValue];
            rankInfo.calorie = [[dict objectForKey:@"calorie"] floatValue];
            rankInfo.energy = [[dict objectForKey:@"energy"] floatValue];
            rankInfo.runTimes = [[dict objectForKey:@"runTimes"] intValue];
            rankInfo.beginTime = [dict objectForKey:@"beginTime"];
            rankInfo.endTime = [dict objectForKey:@"endTime"];
            rankInfo.rank = [[dict objectForKey:@"rank"] floatValue];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser RankInfo failed...please check");
    }
    
    return rankInfo;
}

@end