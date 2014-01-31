//
//  Colors.h
//  AirGuitar
//
//  Created by Alex Perez on 1/17/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BG_COLOR [UIColor colorWithRed:(26.0/255.0) green:(26.0/255.0) blue:(26.0/255.0) alpha:1]
#define TEXT_COLOR [UIColor colorWithRed:(201.0/255.0) green:(201.0/255.0) blue:(201.0/255.0) alpha:1]
#define BUTTON_BG_COLOR [UIColor colorWithRed:(71.0/255.0) green:(71.0/255.0) blue:(71.0/255.0) alpha:1]

@interface Colors : NSObject

+ (UIColor *)colorWithGray:(float)gray;

@end
