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
#import "BOSUser.h"
#import "BOSTouchView.h"
#import "BOSSectorModel.h"



@interface BOSFighRoomViewController ()<BOSTouchViewDlegate>


@property (strong, nonatomic) IBOutlet UILabel *myLevel;
@property (strong, nonatomic) IBOutlet UILabel *myExperience;
@property (strong, nonatomic) IBOutlet UILabel *myHelth;
@property (strong, nonatomic) IBOutlet UIView *myScreen;

@property (strong, nonatomic) IBOutlet UIView *enemyScreen;
@property (strong, nonatomic) IBOutlet UILabel *enemyExperience;
@property (strong, nonatomic) IBOutlet UILabel *enemyLevel;
@property (strong, nonatomic) IBOutlet UILabel *enemyHelth;
@property (strong, nonatomic) IBOutlet BOSTouchView *userTouchScreen;
@property (strong, nonatomic) IBOutlet BOSTouchView *enemyTouchScreen;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UIImageView *enemyImage;

@property (nonatomic, strong) NSArray *userBody;
@property (nonatomic, strong) NSArray *enemyBody;

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
    self.userTouchScreen.delegate = self;
    self.userTouchScreen.image = _userImage;
    self.enemyTouchScreen.delegate = self;
    self.enemyTouchScreen.image = _enemyImage;
    
    DELEGATE.userObject = [[BOSUser alloc] init];
    DELEGATE.userObject.selectedImage = SHIELD_IMAGE;
    DELEGATE.enemyObject.selectedImage = SWORD_IMAGE;
    [self initSections];
    
    [self fillLabelsWithData];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyExperience:nil];
    [self setMyHelth:nil];
    [self setMyScreen:nil];
    [self setEnemyScreen:nil];
    [self setEnemyLevel:nil];
    [self setEnemyHelth:nil];
    [self setEnemyExperience:nil];
    [self setMyLevel:nil];
    [self setUserTouchScreen:nil];
    [self setEnemyTouchScreen:nil];
    [self setUserImage:nil];
    [self setEnemyImage:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
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
        [self parseRecivedData:data];
    }];
}


- (void)sendBumpData{
    NSDictionary *dictionary = @{@"os": @"ios",
                                 @"fight": @{
                                         @"attack":@"0",
                                         @"block":@[@"0", @"2"],
                                         @"power":@"50",
                                         },                                 
                                 @"enemy" :
                                     @{
                                         @"health":DELEGATE.userConfiguration[USER_HEALTH],
                                         @"experience":DELEGATE.userConfiguration[USER_EXPERIENCE],
                                         @"level":DELEGATE.userConfiguration[USER_LEVEL]
                                         }
                                 };
    
    
    
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

- (void)parseRecivedData:(NSData *)data{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *response = [jsonString JSONValue];
    NSDictionary *enemyDictionary = response[ENEMY_KEY];
}

- (void)parseEnemyUserConfiguration:(NSDictionary *)enemyDictionary{
    BOSUser *enemy = [[BOSUser alloc] init];
    enemy.health = enemyDictionary[HEALTH_KEY];
    enemy.experience = enemyDictionary[EXPERIENCE_KEY];
    enemy.level = enemyDictionary[LEVEL_KEY];
    [self fillEnemyConfigurationLabel:enemy];
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


#pragma mark UI methods
- (void)fillLabelsWithData{
    _myExperience.text = [NSString stringWithFormat:@"Experience: %@", DELEGATE.userConfiguration[USER_EXPERIENCE]];
    _myHelth.text = [NSString stringWithFormat:@"Health: %@", DELEGATE.userConfiguration[USER_HEALTH]];
    _myLevel.text = [NSString stringWithFormat:@"Level: %@", DELEGATE.userConfiguration[USER_LEVEL]];
}


- (void)fillEnemyConfigurationLabel:(BOSUser *)enemy{
    _enemyHelth.text = [NSString stringWithFormat:@"Health: %@", enemy.health];
    _enemyLevel.text = [NSString stringWithFormat:@"Level: %@", enemy.level];
    _enemyExperience.text = [NSString stringWithFormat:@"Experience: %@",enemy.experience];
}

- (void)initSections{
    _userBody = [self fillSectionFor:DELEGATE.userObject];
    _enemyBody = [self fillSectionFor:DELEGATE.enemyObject];    
    
}

- (NSArray *)fillSectionFor:(BOSUser *)someUser{
    NSMutableArray *sections = [NSMutableArray array];
    BOSSectorModel * model = nil;
    CGRect frameRect = CGRectZero;
    //Head
    model = [[BOSSectorModel alloc] init];
    model.position = 0;
    model.imagePath = someUser.selectedImage;
    model.isSelected = NO;
    frameRect = CGRectMake(46, 0, 71, 56);
    [sections addObject:model];
    
    //Body
    model = [[BOSSectorModel alloc] init];
    model.position = 1;
    model.imagePath = someUser.selectedImage;
    model.isSelected = NO;
    frameRect = CGRectMake(46, 58, 68, 75);
    [sections addObject:model];
    
    //Left Hand
    model = [[BOSSectorModel alloc] init];
    model.position = 2;
    model.imagePath = someUser.selectedImage;
    model.isSelected = NO;
    frameRect = CGRectMake(0, 60, 33, 87);
    [sections addObject:model];
    
    //Right Hand
    model = [[BOSSectorModel alloc] init];
    model.position = 3;
    model.imagePath = someUser.selectedImage;
    model.isSelected = NO;
    frameRect = CGRectMake(125, 60, 33, 87);
    [sections addObject:model];
    
    //Left Leg
    model = [[BOSSectorModel alloc] init];
    model.position = 4;
    model.imagePath = someUser.selectedImage;
    model.isSelected = NO;
    frameRect = CGRectMake(14, 170, 47, 88);
    [sections addObject:model];
    
    //Right Leg
    model = [[BOSSectorModel alloc] init];
    model.position = 5;
    model.imagePath = someUser.selectedImage;
    model.isSelected = NO;
    frameRect = CGRectMake(96, 170, 47, 88);
    [sections addObject:model];
    
    return sections;
    
}

#pragma mark - Touch Screen View Delegate Methods
- (void)screenView:(BOSTouchView *)view tappedPoint:(CGPoint)point{
    NSLog(@"Screen %@  at point %@", view, NSStringFromCGPoint(point));
}




@end
