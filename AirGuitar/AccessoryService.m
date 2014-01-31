//
//  AccessoryService.m
//  AirGuitar
//
//  Created by Alex Perez on 9/27/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import "AccessoryService.h"
#import "ViewController.h"

@interface AccessoryService () {
    id accessoryDelegate;
    BOOL guitarDataExcited;
    Acceleration *lastGuitarAcceleration;
}
@end

@implementation AccessoryService
@synthesize airGuitarManager;

- (id)initWithDelegate:(id)newDelegate
{
    if (self) {
        accessoryDelegate = newDelegate;
        airGuitarManager = [AGAccessoryManager sharedAccessoryManager];
        airGuitarManager.shouldSendNotifications = YES;
    }
    return self;
}

- (void)accessoryDidConnect: (NSNotification *)notification {
    [accessoryDelegate newLog:@"Accessory Did Connect"];
    AGAccessory *connectedAccessory = (AGAccessory *) notification.object;
    connectedAccessory.delegate = self;
}

- (void)accessoryDidDisconnect: (NSNotification *)notification {
    [accessoryDelegate newLog:@"Accessory Did Disconnect"];
}

- (void)accessory:(AGAccessory *)accessory x:(double)x y:(double)y z:(double)z {
    Acceleration *currentAcceleration = [[Acceleration alloc] initWithX:x y:y z:z];
    if (lastGuitarAcceleration) {
		if (!guitarDataExcited && [self guitarAccelerationIsShaking:lastGuitarAcceleration currentAcceleration:currentAcceleration threshold:[accessoryDelegate getStrumThreshold]]) {
			guitarDataExcited = YES;
            [[accessoryDelegate getSocketService] sendKeyPress:PICK_1 type:@"keyDownUp"];
            
            NSArray *accessories = [airGuitarManager.connectedAGAccessories allValues];
            for (AGAccessory *accessory in accessories) accessory.delegate = nil;
            
            [self performSelector:@selector(fixAccessoryDelegate) withObject:self afterDelay:[accessoryDelegate getStrumRepeatSensitivity]];
		}
        else if (guitarDataExcited && ![self guitarAccelerationIsShaking:lastGuitarAcceleration currentAcceleration:currentAcceleration threshold:[accessoryDelegate getStrumThreshold]]) {
			guitarDataExcited = NO;
        }
	}
    lastGuitarAcceleration = currentAcceleration;
}

- (BOOL)guitarAccelerationIsShaking:(Acceleration *)last currentAcceleration:(Acceleration *)current threshold:(double)threshold {
    
    double deltaX = fabs(last.x - current.x);
    double deltaY = fabs(last.y - current.y);
    double deltaZ = fabs(last.z - current.z);
    
	return (deltaX > threshold && deltaY > threshold) || (deltaX > threshold && deltaZ > threshold) || (deltaY > threshold && deltaZ > threshold);
}

- (void)fixAccessoryDelegate {
    [self setAccessoryDelegate:self];
}

- (void)setAccessoryDelegate:(id)newDelegate {
    NSArray *accessories = [airGuitarManager.connectedAGAccessories allValues];
    for (AGAccessory *accessory in accessories) accessory.delegate = newDelegate;
}

- (void)viewWillAppear {
    if ([airGuitarManager.connectedAGAccessories count])
        [self setAccessoryDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidConnect:) name:@"AGAccessoryDidConnect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidDisconnect:) name:@"AGAccessoryDidDisconnect" object:nil];
}

- (void)viewWillDisappear {
    if ([airGuitarManager.connectedAGAccessories count])
        [self setAccessoryDelegate:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"AGAccessoryDidConnect" object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"AGAccessoryDidDisconnect" object:nil];
}

@end
