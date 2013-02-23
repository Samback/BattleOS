//
//  BOSTouchView.m
//  BattleOS
//
//  Created by Max on 23.02.13.
//  Copyright (c) 2013 Max. All rights reserved.
//

#import "BOSTouchView.h"

@implementation BOSTouchView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Position of touch in view
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.image];
    [self.delegate screenView:self tappedPoint:touchPoint];    
}


@end
