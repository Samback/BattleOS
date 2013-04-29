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
#import "PlayerModel.h"
#import "BOSTouchView.h"
#import "BOSSectorModel.h"
#import "BOSHelperClass.h"

@interface BOSFighRoomViewController ()<BOSTouchViewDlegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statusButton;
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
@property (nonatomic) NSInteger *atackPosition;

@property (nonatomic, strong) NSArray *userBody;
@property (nonatomic, strong) NSArray *enemyBody;

@property (nonatomic, strong) NSMutableArray *protection;
@property (nonatomic, strong) NSMutableArray *attack;
@property (strong, nonatomic) IBOutlet UIImageView *splashView;

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
    self.userTouchScreen.delegate = self;
    self.userTouchScreen.image = _userImage;
    self.enemyTouchScreen.delegate = self;
    self.enemyTouchScreen.image = _enemyImage;
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
    [self setSplashView:nil];
    [self setStatusButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


- (void)fillLabelsWithData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.myExperience.text = [NSString stringWithFormat:@"Experience: %@", DELEGATE.userObject.experience];
        self.myHelth.text = [NSString stringWithFormat:@"Health: %@", DELEGATE.userObject.health];
        self.myLevel.text = [NSString stringWithFormat:@"Level: %@", DELEGATE.userObject.level];
        PlayerModel *enemy = DELEGATE.enemyObject;
        self.enemyExperience.text = [NSString stringWithFormat:@"Experience: %@", enemy.experience];
        self.enemyHelth.text = [NSString stringWithFormat:@"Health: %@", enemy.health];
        self.enemyLevel.text = [NSString stringWithFormat:@"Level: %@", enemy.level];
    });
}


#pragma mark - Init data

- (NSDictionary *)updateJSON
{
    NSLog(@"Delegate user %@", DELEGATE.userObject);
    NSDictionary *json = @{
                           OS_KEY : IOS_KEY,
                           UDID_KEY : DELEGATE.userObject.udid,
                           NAME_KEY : DELEGATE.userObject.name,
                           DEF0_KEY : (@(DELEGATE.userObject.defend0Value)).stringValue,
                           DEF1_KEY : (@(DELEGATE.userObject.defend1Value)).stringValue,
                           ATTACK_KEY : (@(DELEGATE.userObject.attackValue)).stringValue,
                           HEALTH_KEY : (@(DELEGATE.userObject.healthValue)).stringValue,
                           EXPERIENCE_KEY: (@(DELEGATE.userObject.experienceValue)).stringValue,
                           LEVEL_KEY : (@(DELEGATE.userObject.levelValue)).stringValue
                           };
    NSLog(@"Will send  %@", json);
    return json;
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
        
        //        [self parseRecivedData:data];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *response = [jsonString JSONValue];
        NSLog(@"Parsewd answer %@  %@", response, jsonString);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self parseResult:response];
        });
        NSLog(@"Data received from %@: %@",
              [[BumpClient sharedClient] userIDForChannel:channel], response
              );
    }];
}

- (void)sendBumpData{
   
    [[BumpClient sharedClient] setChannelConfirmedBlock:^(BumpChannelID channel) {
        NSLog(@"Channel with %@ confirmed.", [[BumpClient sharedClient] userIDForChannel:channel]);
        NSError *error ;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self updateJSON] options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            [[BumpClient sharedClient] sendData:jsonData
                                      toChannel:channel];
            
        }
    }];
}


//- (void)parseRecivedData:(NSData *)data{
//    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSDictionary *response = [jsonString JSONValue];
//    [self parseEnemyUserConfiguration:response[ENEMY_KEY]];
//  //  NSDictionary *fight =  response[FIGHT_KEY];
//   // self.atackPosition = [fight[POWER_KEY] int];

//
//    });
//}

//- (void)parseEnemyUserConfiguration:(NSDictionary *)enemyDictionary{
//    BOSUser *enemy = [[BOSUser alloc] init];
//    enemy.health = [enemyDictionary[HEALTH_KEY] integerValue];
//    enemy.experience = [enemyDictionary[EXPERIENCE_KEY] integerValue];
//    enemy.level = [enemyDictionary[LEVEL_KEY] integerValue];
//    [self fillEnemyConfigurationLabel:enemy];
//}

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


- (void)setStatus:(BOOL)status
{
        __weak BOSFighRoomViewController *selfWeak = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            selfWeak.statusButton.enabled = status;
        });
}

#pragma mark UI method


- (void)initSections{
    _userBody = [self fillSectionFor:DELEGATE.userObject];
    _enemyBody = [self fillSectionFor:DELEGATE.enemyObject];
    _protection = [@[@0, @1] mutableCopy];
    _attack = [@[@0] mutableCopy];
    BOSSectorModel *atack = [_enemyBody objectAtIndex:[[_attack lastObject] integerValue]];
    atack.isSelected = YES;
    BOSSectorModel *protect1 = [_userBody objectAtIndex:[[_protection objectAtIndex:0] integerValue]];
    protect1.isSelected = YES;
    BOSSectorModel *protect2 = [_userBody objectAtIndex:[[_protection objectAtIndex:1] integerValue]];
    protect2.isSelected = YES;
    _userTouchScreen.sections = _userBody;
    _enemyTouchScreen.sections = _enemyBody;
    [_userTouchScreen setNeedsDisplay];
    [_enemyTouchScreen setNeedsDisplay];
    
}

- (NSArray *)fillSectionFor:(PlayerModel *)someUser
{
    NSMutableArray *sections = [NSMutableArray array];
    BOSSectorModel * model = nil;
    CGRect frameRect = CGRectZero;
    //Head
    model = [[BOSSectorModel alloc] init];
    model.position = 0;
    model.imagePath = someUser.selectedImage;
    model.isSelected = NO;
    frameRect = CGRectMake(46, 0, 71, 56);
    model.sectorFrame = frameRect;
    [sections addObject:model];
    
    //Body
    model = [[BOSSectorModel alloc] init];
    model.position = 1;
    model.imagePath = someUser.selectedImage;
    model.isSelected = NO;
    frameRect = CGRectMake(46, 58, 68, 75);
    model.sectorFrame = frameRect;
    [sections addObject:model];
    
    //Left Hand
    model = [[BOSSectorModel alloc] init];
    model.position = 2;
    model.imagePath = someUser.selectedImage;
    model.isSelected = NO;
    frameRect = CGRectMake(0, 60, 33, 87);
    model.sectorFrame = frameRect;
    [sections addObject:model];
    
    //Right Hand
    model = [[BOSSectorModel alloc] init];
    model.position = 3;
    model.imagePath = someUser.selectedImage;
    model.isSelected = NO;
    frameRect = CGRectMake(125, 60, 33, 87);
    model.sectorFrame = frameRect;
    [sections addObject:model];
    
    //Left Leg
    model = [[BOSSectorModel alloc] init];
    model.position = 4;
    model.imagePath = someUser.selectedImage;
    model.isSelected = NO;
    frameRect = CGRectMake(14, 170, 47, 88);
    model.sectorFrame = frameRect;
    [sections addObject:model];
    
    //Right Leg
    model = [[BOSSectorModel alloc] init];
    model.position = 5;
    model.imagePath = someUser.selectedImage;
    model.isSelected = NO;
    frameRect = CGRectMake(96, 170, 47, 88);
    model.sectorFrame = frameRect;
    [sections addObject:model];
    
    return sections;
    
}

#pragma mark - Touch Screen View Delegate Methods
- (void)screenView:(BOSTouchView *)view tappedPoint:(CGPoint)point{
    if ([view isEqual:_userTouchScreen]) {
        NSLog(@"Screen %@  at point %@", view, NSStringFromCGPoint(point));
        [self highliteSectionAtUser:point];
        
    }
    else if ([view isEqual:_enemyTouchScreen]){
        [self highliteSectionAtEnemy:point];
    }
    // NSLog(@"Screen %@  at point %@", view, NSStringFromCGPoint(point));
}

- (void)highliteSectionAtUser:(CGPoint)point{
    for (BOSSectorModel *section in _userBody) {
        NSLog(@"Section frame %@ with point %@", NSStringFromCGRect(section.sectorFrame), NSStringFromCGPoint(point));
        if (CGRectContainsPoint(section.sectorFrame, point)) {
            //            if (!section.isSelected) {
            //                BOSSectorModel *notSelected = _userBody[[_protection[1] integerValue]];
            //                notSelected.isSelected = NO;
            //            }
            int previousPosition = [_protection[0] integerValue];
            [_protection insertObject:@(previousPosition) atIndex:1];
            [_protection insertObject:@(section.position) atIndex:0];
            section.isSelected = YES;
            [self clearArray:_userBody];
            BOSSectorModel *selectFirst = _userBody[[_protection[0] integerValue]];
            BOSSectorModel *selectSecond = _userBody[[_protection[1] integerValue]];
            DELEGATE.userObject.defend0 = @([_protection[0] integerValue]);
            DELEGATE.userObject.defend1 = @([_protection[1] integerValue]);
            selectFirst.isSelected = YES;
            selectSecond.isSelected = YES;
            [_userTouchScreen setNeedsDisplay];
            return;
        }
    }
}

- (void)highliteSectionAtEnemy:(CGPoint)point{
    for (BOSSectorModel *section in _enemyBody) {
        NSLog(@"Section frame %@ with point %@", NSStringFromCGRect(section.sectorFrame), NSStringFromCGPoint(point));
        if (CGRectContainsPoint(section.sectorFrame, point)) {
            [self clearArray:_enemyBody];
            [_attack insertObject:@(section.position) atIndex:0];
            DELEGATE.userObject.attack = @(section.position);
            section.isSelected = YES;
            [_enemyTouchScreen setNeedsDisplay];
            return;
        }
    }
}


- (void)clearArray:(NSArray *)arrayForClean{
    for (BOSSectorModel *model in arrayForClean) {
        model.isSelected = NO;
    }
}

//- (void)updateHealth:(NSInteger)power{
//    if (([_protection[0] == _atackPosition) || ([_protection[1] == _atackPosition)) {
//        int health =  [DELEGATE.userConfiguration[USER_HEALTH] integerValue ];
//        health -= power/2;
//        DELEGATE.userConfiguration[USER_HEALTH] = health;
//    }else{
//        int health =  [DELEGATE.userConfiguration[USER_HEALTH] integerValue ];
//        health -=power;
//        [DELEGATE.userConfiguration[USER_HEALTH] setVa]  = health;
//
//    }
//   }
- (void)parseResult:(NSDictionary *)res
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _splashView.hidden = NO;
        _splashView.alpha = 1.0;
        [UIView animateWithDuration:2.0 animations:^{
            _splashView.alpha = 0.0;
        }completion:^(BOOL finised){
            _splashView.hidden = YES;
        }];
    });
    int dmg = 0;
    int dmgE = 0;
    int bonus = 0;
    //    DELEGATE.enemyObject.experienceValue = [res[EXPERIENCE_KEY] description].intValue;
    //    DELEGATE.enemyObject.levelValue =
    //    DELEGATE.enemyObject.healthValue =
       
    PlayerModel *enemy = DELEGATE.enemyObject;
    PlayerModel *player = DELEGATE.userObject;
    if ([enemy.udid isEqualToString:res [UDID_KEY]]) {
        enemy.defend0Value = [res [DEF0_KEY] description].intValue;
        enemy.defend1Value = [res[DEF1_KEY] description].intValue;
        enemy.attackValue  = [res[ATTACK_KEY]description].intValue;
        if ((player.attackValue == enemy.defend0Value) || (player.attackValue == enemy.defend1Value)) {
            //you missed
            //	Toast.makeText(this, "You missed!", Toast.LENGTH_LONG).show();
            NSLog(@"You missed");
        }
        else {//you hit him
            dmgE = (int)lroundf( (player.levelValue + 1)*7 + 7 * 0.02 * player.healthValue);
            NSLog(@"dmgE %d level %d", dmgE, player.levelValue);
            bonus = bonus + (int)lroundf(dmgE / 3.0);
        }
        if ((enemy.attackValue == player.defend0Value) || (enemy.attackValue == player.defend0Value)) {//enemy missed
            //	Toast.makeText(this, "Enemy missed!", Toast.LENGTH_LONG).show();
            NSLog(@"Enemy missed");
            bonus = bonus + (int)lroundf(dmgE / 9.0);
        }
        else {//enemy hit you
            dmg = round((enemy.levelValue + 1) * 7 + 7 * 0.02 * enemy.healthValue);
            NSLog(@"dmg %d level enemy  %d", dmg, enemy.levelValue);
            
        }
        enemy.healthValue -= dmgE;
        player.healthValue -= dmg;
        //Set parameters
        //            fragMe.setHealth(health);
        //            fragEnemy.setHealth(healthE);
        if ((player.healthValue <= 0) && (enemy.healthValue <= 0)){
            //Toast.makeText(this, "Score is tied!", Toast.LENGTH_LONG).show();
            //                Intent intent = new Intent();
            //                intent.putExtra("result", FirstActivity.RES_TIDE);
            //                setResult(RESULT_OK, intent);
            //                finish();
            NSLog(@"Both lose");
        }
        else if (player.healthValue <= 0) {
            //Toast.makeText(this, "You lose!", Toast.LENGTH_LONG).show();
            player.experienceValue +=  bonus;
            NSLog(@"You lose");
        }
        else if (enemy.experienceValue <= 0 ) {
            //Toast.makeText(this, "You win!", Toast.LENGTH_LONG).show();
            player.experienceValue += bonus + 100;
            NSLog(@"You win");
            
        }
    }
    else {
        //Start to fight
        DELEGATE.enemyObject = [PlayerModel createEnemyPlayerWithInputData:res];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initSections];
        });
    }

    NSError * error;
    [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:&error];
    [self updateJSON];
    [self fillLabelsWithData];
}
    

@end
