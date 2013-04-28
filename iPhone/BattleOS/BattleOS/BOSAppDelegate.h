//
//  BOSAppDelegate.h
//  BattleOS
//
//  Created by Max on 23.02.13.
//  Copyright (c) 2013 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerModel.h"
#import <RestKit/CoreData/RKManagedObjectStore.h>

@interface BOSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSDictionary *userConfiguration;
@property (nonatomic, strong) PlayerModel *userObject;
@property (nonatomic, strong) PlayerModel *enemyObject;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) RKManagedObjectStore *managedObjectStore;

@end
