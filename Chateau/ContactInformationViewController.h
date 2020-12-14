//
//  ContactInformationViewController.h
//  Chateau
//
//  Created by Bogdan Coticopol on 01.08.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//


#import "ViewController.h"
#import "CustomViewController.h"
#import "AppDelegate.h"

@interface ContactInformationViewController : CustomViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *bookingDate;
@property (weak, nonatomic) IBOutlet UIImageView *nameLine;
@property (weak, nonatomic) IBOutlet UIImageView *phoneLine;
@property (weak, nonatomic) IBOutlet UIImageView *emailLine;
@property (weak, nonatomic) IBOutlet UIImageView *bookingDateLine;

@property (weak, nonatomic) AppDelegate *appDelegate;

- (IBAction)goBack:(id)sender;


@end
