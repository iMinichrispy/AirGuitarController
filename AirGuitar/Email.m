//
//  Email.m
//  AirGuitar
//
//  Created by Alex Perez on 1/16/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import "Email.h"
#import <sys/utsname.h>
#define FORMAT(format,...) [NSString stringWithFormat:(format), ##__VA_ARGS__]

@implementation Email

+ (NSString *)subject {
    return @"AirGuitarController Support";
}

+ (NSString *)recipients {
    return @"support@iminichrispy.com";
}

+ (NSString *)body {
    NSMutableString *body = [NSMutableString stringWithString:@"\n\n\n"];
    [body appendString:FORMAT(@"%@\n",[Email deviceInfo])];
    [body appendString:@"<------- [Log] ------->\n"];
    return [body copy];
}

+ (NSString *)deviceInfo {
    NSMutableString *deviceInfo = [NSMutableString stringWithString:@"<------- [Info] ------->\n"];
    [deviceInfo appendString:@"Report Type: Support\n"];
    [deviceInfo appendString:@"Product: Air Guitar Controller\n"];
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    [deviceInfo appendString:FORMAT(@"Version: %@\n",[infoDict objectForKey:@"CFBundleShortVersionString"])];
    [deviceInfo appendString:FORMAT(@"Build: %@\n",[infoDict objectForKey:@"CFBundleVersion"])];
    [deviceInfo appendString:FORMAT(@"Model: %@\n",[[UIDevice currentDevice] model])];
    [deviceInfo appendString:FORMAT(@"Model Identifier: %@\n",machineName())];
    [deviceInfo appendString:FORMAT(@"System: %@ %@\n",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion])];
    [deviceInfo appendString:FORMAT(@"Player Type: %i\n",[[NSUserDefaults standardUserDefaults] integerForKey:@"playerTypeSelected"])];
    [deviceInfo appendString:FORMAT(@"Component Type: %i\n",[[NSUserDefaults standardUserDefaults] integerForKey:@"componentTypeSelected"])];
    [deviceInfo appendString:FORMAT(@"Buttons Selected: %i\n",[[NSUserDefaults standardUserDefaults] integerForKey:@"numButtonsSelected"])];
    return deviceInfo;
}

NSString *machineName() {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

@end
