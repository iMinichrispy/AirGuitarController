//
//  Email.h
//  AirGuitar
//
//  Created by Alex Perez on 1/16/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Email : NSString

+ (NSString *)subject;
+ (NSString *)recipients;
+ (NSString *)body;

@end
