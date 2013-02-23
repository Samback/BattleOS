//
//  BOSUser.h
//  BattleOS
//
//  Created by Max on 23.02.13.
//  Copyright (c) 2013 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOSUser : NSObject

@property (nonatomic) int health;
@property (nonatomic) int experience;
@property (nonatomic) int level;
@property (nonatomic) int money;
@property (nonatomic) int force;
@property (nonatomic, strong) NSString *selectedImage;
@end
