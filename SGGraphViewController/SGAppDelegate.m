//
//  SGAppDelegate.m
//  SGGraphViewController
//
//  Created by Michele Amati on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGAppDelegate.h"
#import "SGGraphBaseViewController.h"

@implementation SGAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
        
    
    //>>>>>>>>>>>>>>>>>>>>
    NSDictionary *data_1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"metric one",@"name",
                            [[NSNumber alloc]initWithInt:1],@"data1",
                            [[NSNumber alloc]initWithInt:1],@"data2",
                            nil];
    NSDictionary *data_2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"metric two",@"name",
                            [[NSNumber alloc]initWithInt:4],@"data1",
                            [[NSNumber alloc]initWithInt:1],@"data2",
                            nil];
    NSDictionary *data_3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"metric three",@"name",
                            [[NSNumber alloc]initWithInt:8],@"data1",
                            [[NSNumber alloc]initWithInt:1],@"data2",
                            nil];
    
    NSArray *data = [[NSArray alloc] initWithObjects:data_1,data_2,data_3, nil];
    //<<<<<<<<<<<<<<<<<<<<<<

    
    
    SGGraphBaseViewController *base = [[SGGraphBaseViewController alloc]initWithSize:CGSizeMake(320, 480) andData:data];
    self.window.rootViewController = base;
    [base showChart];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
