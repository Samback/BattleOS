//
//  BOSTouchView.m
//  BattleOS
//
//  Created by Max on 23.02.13.
//  Copyright (c) 2013 Max. All rights reserved.
//

#import "BOSTouchView.h"
#import "BOSSectorModel.h"
#define IMAGE_SIZE 33
@implementation BOSTouchView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Position of touch in view
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.image];
    [self.delegate screenView:self tappedPoint:touchPoint];    
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (BOSSectorModel *sector in self.sections) {
        if (sector.isSelected) {
            [self drawRect:sector.sectorFrame withContext:context andModel:sector];
        }
    }
    
    //CGContextFillPath(context);
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context andModel:(BOSSectorModel *)model{
    UIImage *image = [UIImage imageNamed:model.imagePath];
    CGRect imageFrame = CGRectMake((rect.size.width - IMAGE_SIZE) / 2, (rect.size.height - IMAGE_SIZE) / 2, IMAGE_SIZE, IMAGE_SIZE);
    CGContextDrawImage(context, imageFrame, image.CGImage);    
}


@end
