//
//  BOSFighRoomViewController.m
//  BattleOS
//
//  Created by Max on 23.02.13.
//  Copyright (c) 2013 Max. All rights reserved.
//

#import "BOSFighRoomViewController.h"
#import "BumpClient.h"
#import "SBJson.h"



@interface BOSFighRoomViewController ()
{
    int attack, def0, def1, health, level, exp;
    int attackE, def0E, def1E, healthE, levelE, expE;
    int bonus;
    NSString  *udid, *enemyUDID;
}

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

#pragma mark - Life cycle

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
    [self fillLabelsWithData];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)fillLabelsWithData{
    _myExperience.text = [NSString stringWithFormat:@"Experience: %@", DELEGATE.userConfiguration[USER_EXPERIENCE]];
    _myHelth.text = [NSString stringWithFormat:@"Health: %@", DELEGATE.userConfiguration[USER_HEALTH]];
    _myScore.text = [NSString stringWithFormat:@"Level: %@", DELEGATE.userConfiguration[USER_LEVEL]];
}


#pragma mark - Init data

- (void)initData
{
    udid = [BOSHelperClass getUUID];
    enemyUDID = nil;
    attack    = 0;
    def0      = 0;
    def1      = 1;
    bonus     = 0;
    health    = 1000;
    level     = 0;
    exp       = 0;
    
    if (exp > 1200000){
        level = 7;
    }
    else if (exp > 600000) {
        level = 6;
    }
    else if (exp > 300000) {
        level = 5;
    }
    else if (exp > 150000) {
        level = 4;
    }
    else if (exp > 70000) {
        level = 3;
    }
    else if (exp > 30000) {
        level = 2;
    }
    else if (exp > 10000) {
        level = 1;
    }
    
    name = [[UIDevice currentDevice] name];
    updateJSON();
}


#pragma mark - BUMP methods
- (void) configureBump {
    [self getEnemyInfo];
    [self bumpStatus];
    [self getBumpInfo];
    [self sendBumpData];
    [self catchBumpDetection];
}

- (void)getEnemyInfo{
    [[BumpClient sharedClient] setMatchBlock:^(BumpChannelID channel) {
        NSLog(@"Matched with user: %@", [[BumpClient sharedClient] userIDForChannel:channel]);
        [[BumpClient sharedClient] confirmMatch:YES onChannel:channel];
    }];
}

- (void)bumpStatus {
    [[BumpClient sharedClient] setConnectionStateChangedBlock:^(BOOL connected) {
        if (connected) {
            NSLog(@"Bump connected...");
        } else {
            NSLog(@"Bump disconnected...");
        }
    }];
}
- (void)getBumpInfo{
    [[BumpClient sharedClient] setDataReceivedBlock:^(BumpChannelID channel, NSData *data) {
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *response = [jsonString JSONValue];
        NSLog(@"Parsewd answer %@  %@", response, jsonString);
        
        NSLog(@"Data received from %@: %@",
              [[BumpClient sharedClient] userIDForChannel:channel], response
              );
    }];
}


- (void)sendBumpData{
    NSDictionary *dictionary = @{@"os": @"iOS",
                                 @"attack":@"0",
                                 @"block":@[@"0", @"2"]};
    
    
    
    [[BumpClient sharedClient] setChannelConfirmedBlock:^(BumpChannelID channel) {
        NSLog(@"Channel with %@ confirmed.", [[BumpClient sharedClient] userIDForChannel:channel]);
        NSError *error ;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            [[BumpClient sharedClient] sendData:jsonData
                                      toChannel:channel];
            
        }
    }];
    
}

- (void)catchBumpDetection{
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
