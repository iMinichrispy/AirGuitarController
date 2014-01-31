//
//  Colors.m
//  AirGuitar
//
//  Created by Alex Perez on 1/17/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import "Colors.h"

@implementation Colors

+ (UIColor *)colorWithGray:(float)gray {
    return [UIColor colorWithRed:(gray/255.0) green:(gray/255.0) blue:(gray/255.0) alpha:1.0];
}

@end
