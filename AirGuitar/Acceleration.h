//
//  Acceleration.h
//  AirGuitar
//
//  Created by Alex Perez on 9/22/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

// UIAcceleration doesn't let you assign x,y,z values, so I made this object to do it for me
@interface Acceleration : NSObject

@property (readwrite, assign) double x,y,z;

- (id)initWithX:(double)newX y:(double)newY z:(double)newZ;

@end
