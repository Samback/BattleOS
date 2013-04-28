//
//  BOSAppDelegate.m
//  BattleOS
//
//  Created by Max on 23.02.13.
//  Copyright (c) 2013 Max. All rights reserved.
//

#import "BOSAppDelegate.h"
#import "BumpClient.h"
#import "PlayerModel.h"

@implementation BOSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    8cdf424bb78349c6bfafb9f22f2788a4
//    de703e6680454adbbf3d1ac99727c9b0
    [BumpClient configureWithAPIKey:BUMP_API_KEY andUserID:[[UIDevice currentDevice] name]];
    
    [self initRestKitWithCoreDataIntegration];
    [self initSourceInCoreData];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (void)initRestKitWithCoreDataIntegration{
    //Activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:BASE_URL]];
    [objectManager.HTTPClient setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    [objectManager.HTTPClient setParameterEncoding:AFJSONParameterEncoding];
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"DataBase" ofType:@"momd"]];
    // NOTE: Due to an iOS 5 bug, the managed object model returned is immutable.
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    [managedObjectStore createPersistentStoreCoordinator];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"DataBase.sqlite"];
    
    NSError *error;
    
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error];
    
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    self.managedObjectModel = managedObjectModel;
    objectManager.managedObjectStore = managedObjectStore;
}

- (void)initSourceInCoreData
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[PlayerModel entityName]];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"udid" ascending:YES]];
    
    NSError *error;
    NSArray *results = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSAssert(!error, @"Error performing fetch request: %@", error);
    if (!error) {
        if (results.count == 0) {
            [self createPlayer];
        }
        else {
            DELEGATE.userObject = results[0];
        }
    }
}


-(void)createPlayer
{
     NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    DELEGATE.userObject = [PlayerModel initPlayerWithName:[[UIDevice currentDevice] name] health:@1000 experience:@0 level:@0 attack:@0 def0:@0 def1:@1 udid:[BOSHelperClass getUUID] selectedImage:SHIELD_IMAGE andContext:context];
}


@end
