//
//  Acceleration.m
//  AirGuitar
//
//  Created by Alex Perez on 9/22/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import "Acceleration.h"

@implementation Acceleration

@synthesize x,y,z;

- (id)initWithX:(double)newX y:(double)newY z:(double)newZ
{
    self = [super init];
    if(nil != self) {
        self.x = newX;
        self.y = newY;
        self.z = newZ;
    }
    return self;
}

@end
