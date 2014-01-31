//
//  BonjourService.h
//  AirGuitar
//
//  Created by Alex Perez on 9/27/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BonjourService : NSObject <NSNetServiceBrowserDelegate,NSNetServiceDelegate> {
    NSNetServiceBrowser *browser;
    NSString *serviceIP;
    NSMutableArray *services;
}

@property (nonatomic, retain) NSString *serviceIP;
@property (readwrite, retain) NSNetServiceBrowser *browser;
@property (readwrite, retain) NSMutableArray *services;

- (id)initWithService:(NSString *)service delegate:(id)newDelegate;
- (void)browseServices;
- (void)stop;

@end
