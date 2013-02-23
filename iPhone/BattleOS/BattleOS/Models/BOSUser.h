//
//  BOSUser.h
//  BattleOS
//
//  Created by Max on 23.02.13.
//  Copyright (c) 2013 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOSUser : NSObject

@property (nonatomic, copy) NSString *health;
@property (nonatomic, copy) NSString *experience;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *force;
@property (nonatomic, copy) NSString *selectedImage;
@end
