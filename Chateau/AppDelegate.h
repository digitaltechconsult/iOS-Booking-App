//
//  AppDelegate.h
//  Chateau
//
//  Created by Bogdan Coticopol on 01.08.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,NSURLConnectionDataDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Order *currentOrder;
@property BOOL isOrderDone;

@end

