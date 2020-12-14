//
//  BCOMapAnnotation.m
//  LeChateau
//
//  Created by Bogdan Coticopol on 01.03.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import "BCOMapAnnotation.h"

@implementation BCOMapAnnotation

-(instancetype)initWithCoordinates: (CLLocationCoordinate2D)paramCoordinates title:(NSString *)title subtitle:(NSString *)subtitle;
{
    self = [super init];
    if(self) {
        _coordinate = paramCoordinates;
        _title = title;
        _subtitle = subtitle;
        
    }
    return self;
}


@end
