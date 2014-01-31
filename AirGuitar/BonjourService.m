//
//  BonjourService.m
//  AirGuitar
//
//  Created by Alex Perez on 9/27/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import "BonjourService.h"
#import "ViewController.h"
#import <netinet/in.h>
#import <arpa/inet.h>

@interface BonjourService () {
    id bonjourDelegate;
    NSString *serviceType;
}
@end

@implementation BonjourService
@synthesize serviceIP;
@synthesize browser;
@synthesize services;

- (id)initWithService:(NSString *)service delegate:(id)newDelegate
{
    if (self) {
        serviceType = service;
        bonjourDelegate = newDelegate;
    }
    return self;
}

- (void)browseServices {
    [bonjourDelegate newLog:@"Browsing for Server..."];
	services = [NSMutableArray new];
    self.browser = [NSNetServiceBrowser new];
    self.browser.delegate = self;
    [self.browser searchForServicesOfType:serviceType inDomain:@""];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didFindService:(NSNetService *)aService moreComing:(BOOL)more {
    [services addObject:aService];
    [bonjourDelegate newLog:@"Found Server. Resolving Address..."];
    [self resolveIPAddress:aService];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didRemoveService:(NSNetService *)aService moreComing:(BOOL)more {
    [services removeObject:aService];
    [bonjourDelegate newLog:[NSString stringWithFormat:@"Removed: %@",[aService name]]];
}

- (void)resolveIPAddress:(NSNetService *)service {
    NSNetService *remoteService = service;
    remoteService.delegate = self;
    [remoteService resolveWithTimeout:0];
}

- (void)netServiceDidResolveAddress:(NSNetService *)service {
    NSData *address = [[service addresses] objectAtIndex:0];
    struct sockaddr_in *socketAddress = (struct sockaddr_in *)[address bytes];
    self.serviceIP = [NSString stringWithFormat: @"%s", inet_ntoa(socketAddress->sin_addr)];
    int port = socketAddress->sin_port;
    [bonjourDelegate newLog:[NSString stringWithFormat:@"Resolved: %@ (%@:%i)", [service hostName], self.serviceIP, port]];
    [[bonjourDelegate getSocketService] connectToServer:self.serviceIP];
}

-(void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict {
    [bonjourDelegate newLog:[NSString stringWithFormat:@"Error Resolving: %@", errorDict]];
}

- (void)stop {
    [browser stop];
}

@end
