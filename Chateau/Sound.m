//
//  Sound.m
//  Chateau
//
//  Created by Bogdan Coticopol on 13.09.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import "Sound.h"

@interface Sound() {
    AVAudioPlayer *_musicPlayer;
}

@end

@implementation Sound

+(instancetype)sharedInstance
{
    static Sound *singleton = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        singleton = [[Sound alloc]init];
    });
    return singleton;
}

-(id)init
{
    if(self = [super init]) {
        NSURL *musicURL = [[NSBundle mainBundle] URLForResource:@"scissor" withExtension:@"aiff"];
        _musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:musicURL error:nil];
        _musicPlayer.numberOfLoops = 1;
        _musicPlayer.volume = 0.88f;
    }
    
    return self;
}

-(void)playSound
{
    [_musicPlayer prepareToPlay];
    [_musicPlayer play];
}


@end
