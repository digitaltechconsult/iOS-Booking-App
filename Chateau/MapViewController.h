//
//  MapViewController.h
//  Chateau
//
//  Created by Bogdan Coticopol on 01.09.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCOMapAnnotation.h"
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

//back button from the view
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

//action for the back button
- (IBAction)dismissView:(id)sender;

//the map object
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)mapsGoogle:(id)sender;
- (IBAction)mapsApple:(id)sender;
- (IBAction)mapsWaze:(id)sender;



@end
