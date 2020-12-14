//
//  ViewController.m
//  Chateau
//
//  Created by Bogdan Coticopol on 01.08.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    ModelHome *_homeModel;
}


@end

@implementation ViewController

#pragma mark - ViewController Methods (init & view customization)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //segue transition type
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    //model for handling this view
    _homeModel = [[ModelHome alloc]init];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    //get next view controller
    ViewController *vc = segue.destinationViewController;
    
    //flag to know if we call the view from home view; if is from home view then the displayed list is readonly
    if([vc isMemberOfClass:[NavigationViewController class]]) {
        NavigationViewController *nc = (NavigationViewController *)vc;
        nc.isCalledFromHomePage = YES;
    }
}

#pragma mark - GUI Interaction

- (IBAction)callChateau:(id)sender
{
    if(![_homeModel callChateau]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Nu se poate apela numărul de telefon" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)mailChateau:(id)sender
{
    if(![_homeModel emailChateau]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Nu se poate trimite email de pe acest dispozitiv" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

@end
