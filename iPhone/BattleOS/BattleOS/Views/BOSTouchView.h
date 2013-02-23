//
//  BOSTouchView.h
//  BattleOS
//
//  Created by Max on 23.02.13.
//  Copyright (c) 2013 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BOSTouchView;
@protocol BOSTouchViewDlegate
- (void)screenView:(BOSTouchView *)view tappedPoint:(CGPoint)point;
@end

@interface BOSTouchView : UIView
@property (nonatomic, assign) id <BOSTouchViewDlegate> delegate;
@property(nonatomic, retain) UIImageView *image;
@end
