//
//  AppDelegate.m
//  AirGuitar
//
//  Created by Alex Perez on 1/13/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (CMMotionManager *)motionManager
{
    if (!motionManager) motionManager = [[CMMotionManager alloc] init];
    
    return motionManager;
}

@end
