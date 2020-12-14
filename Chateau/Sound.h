//
//  Sound.h
//  Chateau
//
//  Created by Bogdan Coticopol on 13.09.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@interface Sound : NSObject
-(void)playSound;
+(instancetype)sharedInstance;
@end
