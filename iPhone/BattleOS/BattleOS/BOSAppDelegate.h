//
//  BOSAppDelegate.h
//  BattleOS
//
//  Created by Max on 23.02.13.
//  Copyright (c) 2013 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOSUser.h"

@interface BOSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSDictionary *userConfiguration;
@property (nonatomic, strong) BOSUser *userObject;
@property (nonatomic, strong) BOSUser *enemyObject;


@end
