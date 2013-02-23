//
//  BOSHelperClass.m
//  BattleOS
//
//  Created by Max on 23.02.13.
//  Copyright (c) 2013 Max. All rights reserved.
//

#import "BOSHelperClass.h"
#import "BOSConstants.h"

@implementation BOSHelperClass

+ (NSDictionary *)getInitialUserValues{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *initialValue = @"0";
    NSString *money = [user stringForKey: USER_MONEY] ? [user stringForKey: USER_MONEY] : initialValue;
    NSString *experience = [user stringForKey:USER_EXPERIENCE] ? [user stringForKey:USER_EXPERIENCE] : initialValue;
    NSString *level = [user stringForKey:USER_LEVEL] ? [user stringForKey:USER_LEVEL] : initialValue;
    NSString *force = [user stringForKey:USER_ATTACK_FORCE] ? [user stringForKey:USER_ATTACK_FORCE] : @"10";
    NSString *health = [user stringForKey:USER_HEALTH] ?  [user stringForKey:USER_HEALTH] : @"1000";
    NSDictionary *results = @{USER_MONEY : money ,
                              USER_EXPERIENCE : experience,
                              USER_LEVEL : level,
                              USER_ATTACK_FORCE : force,
                              USER_HEALTH : health};
    return results;
}

+ (void)saveUserResults:(NSDictionary *)results{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *value = nil;
    for (NSString *key in [results allKeys]) {
        value = results[key];
        [user setObject:value forKey:key];
    }
    [user synchronize];
}

@end
