//
//  BCOMapAnnotation.h
//  LeChateau
//
//  Created by Bogdan Coticopol on 01.03.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BCOMapAnnotation : MKAnnotationView <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;

-(instancetype)initWithCoordinates: (CLLocationCoordinate2D)paramCoordinates title:(NSString *)title subtitle:(NSString *)subtitle;

@end
