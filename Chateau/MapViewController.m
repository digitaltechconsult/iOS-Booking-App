//
//  MapViewController.m
//  Chateau
//
//  Created by Bogdan Coticopol on 01.09.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import "MapViewController.h"

float _latitude = 44.513367;
float _longitude = 26.105422;
float _delta = 0.2f;

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //custom font for bar buttons
    [self.backButton setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]} forState:UIControlStateNormal];
    
    //create region for Chateau position
    MKCoordinateRegion regionChateau;
    regionChateau.center = CLLocationCoordinate2DMake(_latitude, _longitude);
    regionChateau.span.latitudeDelta = _delta;
    regionChateau.span.longitudeDelta = _delta;
    
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.showsUserLocation = YES;
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.region = regionChateau;

    //add annotation for POI
    BCOMapAnnotation *annotation = [[BCOMapAnnotation alloc]initWithCoordinates:CLLocationCoordinate2DMake(_latitude, _longitude) title:@"Le Chateau" subtitle:@"Maison de beaute"];
    [self.mapView addAnnotation:annotation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GUI
-(IBAction)dismissView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Class Methods

-(void)openWith:(NSInteger)application
{
    NSString *applicationHandler;
    NSString *testAppHandler;
    switch (application) {
        case 0:
            testAppHandler = @"http://maps.apple.com/?q";
            applicationHandler =[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f",_latitude,_longitude];
            break;
        case 1:
            testAppHandler = @"comgooglemaps://";
            applicationHandler = [NSString stringWithFormat:@"comgooglemaps://?daddr=%f,%f",_latitude,_longitude];
            break;
        case 2:
            testAppHandler = @"waze://";
            applicationHandler = [NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes",_latitude,_longitude];
            break;
        default:
            return;
            break;
    }
    
    NSURL *testURL = [NSURL URLWithString:testAppHandler];
    if([[UIApplication sharedApplication]canOpenURL:testURL]) {
        NSURL *directionURL = [NSURL URLWithString:applicationHandler];
        [[UIApplication sharedApplication]openURL:directionURL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Nu se poate deschide aplicatia aleasa, verifica daca este deja instalata"
                                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)mapsGoogle:(id)sender
{
    [self openWith:1];
}

- (IBAction)mapsApple:(id)sender
{
    [self openWith:0];
}

- (IBAction)mapsWaze:(id)sender
{
    [self openWith:2];
}
@end
