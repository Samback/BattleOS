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
#import "BOSHelperClass.h"



@interface BOSFighRoomViewController ()
{
    int attack, def0, def1, health, level, exp;
    int attackE, def0E, def1E, healthE, levelE, expE;
    int bonus;
    NSString  *udid, *enemyUDID;
    NSString *name;
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
    [self initData];
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

- (void)fillLabelsWithData
{
    self.myScore.text = [NSString stringWithFormat:@"Experience: %d", exp];
    self.myHelth.text = [NSString stringWithFormat:@"Health: %d", health];
    self.myExperience.text = [NSString stringWithFormat:@"Level: %d", level];
    
    
    self.enemyScore.text = [NSString stringWithFormat:@"Experience: %d", expE];
    self.enemyHelth.text = [NSString stringWithFormat:@"Health: %d", healthE];
    self.enemyLevel.text = [NSString stringWithFormat:@"Level: %d", levelE];
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
    [self updateJSON];
}

- (NSDictionary *)updateJSON
{
    NSDictionary *json = @{
                           JOS : @"ios",
                           JUDID : udid,
                           JNAME : name,
                           JDEF0 : (@(def0)).stringValue,
                           JDEF1 : (@(def1)).stringValue,
                           JATTACK : (@(attack)).stringValue,
                           JHEALTH : (@(health)).stringValue,
                           JEXP: (@(exp)).stringValue,
                           JLEVEL : (@(level)).stringValue
                           };
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
    NSDictionary *dictionary = [self updateJSON];
    
    
    
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


- (void)parseResult:(NSDictionary *)res
{

    int dmg = 0;
    int dmgE = 0;
    expE = [res[JEXP] description].intValue;
    levelE = [res[JLEVEL]description].intValue;
    healthE = [res[JHEALTH]description].intValue;
//    fragEnemy.setHealth(healthE);
//    fragEnemy.setLevel(levelE);
//    fragEnemy.setExp(expE);
    if (enemyUDID == nil){
        enemyUDID = res[JUDID];
        //Start to fight
        NSLog(@"Start to fight");
    }
    else {
        if ([enemyUDID isEqualToString:res [JUDID]]){
            def0E = [res [JDEF0] description].intValue;
            def1E = [res[JDEF1] description].intValue;
            attackE = [res[JATTACK]description].intValue;
            if ((attack == def0E)||(attack == def1E)){//you missed
				//	Toast.makeText(this, "You missed!", Toast.LENGTH_LONG).show();
            }else{//you hit him
                dmgE = (int)round((level+1)*7 + 7 * 0.02*health);
                NSLog(@"dmgE %d level %d", dmgE, level);
                bonus = bonus + (int)round(dmgE/3);
            }
            if ((attackE == def0)||(attackE == def1)){//enemy missed
				//	Toast.makeText(this, "Enemy missed!", Toast.LENGTH_LONG).show();
                bonus = bonus + round(dmgE/9);
            }else{//enemy hit you
                dmg = round((levelE+1)*7 + 7 * 0.02*healthE);
                
                NSLog(@"dmgE %d level enemy  %d", dmgE, levelE);
                
            }
            healthE = healthE - dmgE;
            health = health - dmg;
            //Set parameters
//            fragMe.setHealth(health);
//            fragEnemy.setHealth(healthE);
            if ((health <= 0) &&(healthE <= 0)){
                //Toast.makeText(this, "Score is tied!", Toast.LENGTH_LONG).show();
//                Intent intent = new Intent();
//                intent.putExtra("result", FirstActivity.RES_TIDE);
//                setResult(RESULT_OK, intent);
//                finish();
            }else if (health <= 0){
                //Toast.makeText(this, "You lose!", Toast.LENGTH_LONG).show();
                exp = exp + bonus;
//                mSharedPreferences.edit().putInt(TAG_EXP, exp).commit();
//                Intent intent = new Intent();
//                intent.putExtra("result", FirstActivity.RES_LOSE);
//                setResult(RESULT_OK, intent);
//                finish();
            }else if (healthE <= 0 ){
                //Toast.makeText(this, "You win!", Toast.LENGTH_LONG).show();
                exp = exp + bonus + 100;
//                mSharedPreferences.edit().putInt(TAG_EXP, exp).commit();
//                Intent intent = new Intent();
//                intent.putExtra("result", FirstActivity.RES_WIN);
//                setResult(RESULT_OK, intent);
//                finish();
            }else{
				//	Toast.makeText(this, "Show must go on!", Toast.LENGTH_LONG).show();
                
            }
        }else{
            //Toast.makeText(this, "You win", Toast.LENGTH_LONG).show();
            exp = exp + bonus + 100;
//            mSharedPreferences.edit().putInt(TAG_EXP, exp).commit();
//            Intent intent = new Intent();
//            intent.putExtra("result", FirstActivity.RES_WIN);
//            setResult(RESULT_OK, intent);
//            finish();
        }
    }
    [self updateJSON];
    [self fillLabelsWithData];
}


@end
