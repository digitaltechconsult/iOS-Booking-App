//
//  Order.h
//  Chateau
//
//  Created by Bogdan Coticopol on 28.08.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject <NSURLConnectionDataDelegate>

@property NSString *name;
@property NSString *phone;
@property NSString *email;
@property NSString *bookingDate;
@property NSSet *content;

- (NSURLRequest *)generateRequest;
+ (NSDictionary *)generateServicesMenu;
+ (NSURLRequest *)getServices;
@end
