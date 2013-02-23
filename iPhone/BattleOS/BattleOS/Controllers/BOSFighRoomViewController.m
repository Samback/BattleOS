//
//  BOSFighRoomViewController.m
//  BattleOS
//
//  Created by Max on 23.02.13.
//  Copyright (c) 2013 Max. All rights reserved.
//

#import "BOSFighRoomViewController.h"
#import "BumpClient.h"

@interface BOSFighRoomViewController ()

@property (strong, nonatomic) IBOutlet UILabel *myScore;
@property (strong, nonatomic) IBOutlet UILabel *myExperience;
@property (strong, nonatomic) IBOutlet UILabel *myHelth;
@property (strong, nonatomic) IBOutlet UIView *myScreen;

@property (strong, nonatomic) IBOutlet UIView *enemyScreen;
@property (strong, nonatomic) IBOutlet UILabel *enemyScore;
@property (strong, nonatomic) IBOutlet UILabel *enemyLevel;
@property (strong, nonatomic) IBOutlet UILabel *enemyHelth;


@end

@implementation BOSFighRoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureBump];
    NSLog(@"Initial dict %@", [BOSHelperClass getInitialUserValues]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyScore:nil];
    [self setMyExperience:nil];
    [self setMyHelth:nil];
    [self setMyScreen:nil];
    [self setEnemyScreen:nil];
    [self setEnemyScore:nil];
    [self setEnemyLevel:nil];
    [self setEnemyHelth:nil];
    [super viewDidUnload];
}

- (void) configureBump {
    NSDictionary *dictionary = @{@"os": @"iOS",
                                 @"attack":@"0",
                                 @"block":@[@"0", @"2"]};
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    [[BumpClient sharedClient] setMatchBlock:^(BumpChannelID channel) {
        NSLog(@"Matched with user: %@", [[BumpClient sharedClient] userIDForChannel:channel]);
        [[BumpClient sharedClient] confirmMatch:YES onChannel:channel];
    }];
    
//    [[BumpClient sharedClient] setChannelConfirmedBlock:^(BumpChannelID channel) {
//        NSLog(@"Channel with %@ confirmed.", [[BumpClient sharedClient] userIDForChannel:channel]);
//        [[BumpClient sharedClient] sendData:[[NSString stringWithFormat:@"Hello, world!"] dataUsingEncoding:NSUTF8StringEncoding]
//                                  toChannel:channel];
//    }];
    
    [[BumpClient sharedClient] setChannelConfirmedBlock:^(BumpChannelID channel) {
        NSLog(@"Channel with %@ confirmed.", [[BumpClient sharedClient] userIDForChannel:channel]);
        [[BumpClient sharedClient] sendData:myData
                                  toChannel:channel];
    }];

    
    [[BumpClient sharedClient] setDataReceivedBlock:^(BumpChannelID channel, NSData *data) {
        NSDictionary *dict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"Data received from %@: %@",
              [[BumpClient sharedClient] userIDForChannel:channel],
             dict);
    }];
    
   // [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding]);
   
    // optional callback
    [[BumpClient sharedClient] setConnectionStateChangedBlock:^(BOOL connected) {
        if (connected) {
            NSLog(@"Bump connected...");
        } else {
            NSLog(@"Bump disconnected...");
        }
    }];
    
    // optional callback
    [[BumpClient sharedClient] setBumpEventBlock:^(bump_event event) {
        switch(event) {
            case BUMP_EVENT_BUMP:
                NSLog(@"Bump detected.");
                break;
            case BUMP_EVENT_NO_MATCH:
                NSLog(@"No match.");
                break;
        }
    }];
}
@end
