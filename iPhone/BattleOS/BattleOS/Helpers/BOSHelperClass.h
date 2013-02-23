//
//  BOSHelperClass.h
//  BattleOS
//
//  Created by Max on 23.02.13.
//  Copyright (c) 2013 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOSHelperClass : NSObject
+ (NSDictionary *)getInitialUserValues;
+ (void)saveUserResults:(NSDictionary *)results;
@end
