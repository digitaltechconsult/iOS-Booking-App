//
//  AppDelegate.m
//  Chateau
//
//  Created by Bogdan Coticopol on 01.08.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () {
    NSMutableData *_responseData;
    NSURLConnection *_menuConnection;
}
            
@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //get the updated version of service list
    NSURLRequest *menuRequest = [Order getServices];
    _menuConnection = [[NSURLConnection alloc]initWithRequest:menuRequest delegate:self startImmediately:YES];
    [_menuConnection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark NSURLConnection Delegate Mehods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //handle multiple connection, we talk about AppDelegate
    //if we need to get menu
    if(connection == _menuConnection) {
        _responseData = [[NSMutableData alloc]init];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection == _menuConnection) {
        [_responseData appendData:data];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    //try to handle the response
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:NULL];
    
    //check if we have data
    if(response && [[response objectForKey:@"Status"]isEqualToString:@"OK"]) {
        if(connection == _menuConnection) {
            //if we have services list, save it for later use
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[response objectForKey:@"Response"] forKey:@"Services"];
        }
    }
}

@end
