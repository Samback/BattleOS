//
//  BOSSectorModel.h
//  BattleOS
//
//  Created by Max on 23.02.13.
//  Copyright (c) 2013 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOSSectorModel : NSObject

@property (nonatomic) CGRect sectorFrame;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic) NSInteger position;

@end
