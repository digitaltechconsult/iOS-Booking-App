//
//  ServiciiViewController.h
//  Chateau
//
//  Created by Bogdan Coticopol on 10.08.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationViewController.h"
#import "Order.h"
#import "AppDelegate.h"
#import "Cell.h"
#import "ContactInformationViewController.h"

@interface ServiciiViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate,NSURLConnectionDataDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property BOOL isNewOrder; //make the distinction if we only need to display or we need to make a new booking
@property (weak, nonatomic) AppDelegate *appDelegate;
- (IBAction)dismissView:(id)sender;
- (IBAction)send:(id)sender;
@end
