//
//  ModelHome.m
//  chateau
//
//  Created by Bogdan Coticopol on 14.09.2014.
//  Copyright (c) 2014 ro.selrys. All rights reserved.
//

#import "ModelHome.h"

@interface ModelHome() {
    NSString *_phoneNumber;
    NSString *_emailAddress;
}

@end

@implementation ModelHome

-(id)init
{
    if(self = [super init]) {
        _phoneNumber = @"+40742428328";
        _emailAddress = @"programari@lechateau.ro";
    }
    return self;
}

-(BOOL)callChateau
{
    UIDevice *device = [UIDevice currentDevice];
    
    if([device.model isEqualToString:IPHONE]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_phoneNumber]]];
        return YES;
    }
    return NO;
}

-(BOOL)emailChateau
{
    UIDevice *device = [UIDevice currentDevice];
    if([device.model isEqualToString:IPHONE] || [device.model isEqualToString:IPAD]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@",_emailAddress]]];
        return YES;
    }
    return NO;
}

@end
