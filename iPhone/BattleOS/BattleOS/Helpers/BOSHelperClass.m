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

//+ (NSDictionary *)getInitialUserValues{
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    int initialValue = 0;
//    int money = [user integerForKey: USER_MONEY] ? [user integerForKey: USER_MONEY] : initialValue;
//    int experience = [user integerForKey:USER_EXPERIENCE] ? [user integerForKey:USER_EXPERIENCE] : initialValue;
//    int level = [user integerForKey:USER_LEVEL] ? [user integerForKey:USER_LEVEL] : initialValue;
//    int force = [user integerForKey:USER_ATTACK_FORCE] ? [user integerForKey:USER_ATTACK_FORCE] : 10;
//    int health = [user integerForKey:USER_HEALTH] ?  [user integerForKey:USER_HEALTH] : 1000;
//    NSDictionary *results = @{USER_MONEY : @(money) ,
//                              USER_EXPERIENCE : @(experience),
//                              USER_LEVEL : @(level),
//                              USER_ATTACK_FORCE : @(force),
//                              USER_HEALTH : @(health)};
//    return results;
//}

+ (void)saveUserResults:(NSDictionary *)results{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *value = nil;
    for (NSString *key in [results allKeys]) {
        value = results[key];
        [user setObject:value forKey:key];
    }
    [user synchronize];
}

+ (NSString *)getUUID
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *uuid = [prefs stringForKey:UUID];
    if (!uuid) {
        // Create universally unique identifier (object)
        uuid =  [[UIDevice currentDevice].identifierForVendor UUIDString];
        [prefs setObject:uuid forKey:UUID];
        [prefs synchronize];
    }
    return uuid;
}


@end
