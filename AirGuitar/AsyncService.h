//
//  AsyncService.h
//  AirGuitar
//
//  Created by Alex Perez on 9/28/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

@interface AsyncService : NSObject 

@property (nonatomic, retain) AsyncSocket *clientSocket;

- (id)initWithDelegate:(id)newDelegate;

- (void)sendString:(NSString *)jsonString;
- (void)sendKeyPress:(int)key type:(NSString *)type;
- (void)sendKeyUp:(int)keyUp sendKeyDown:(int)keyDown;
- (void)connectToServer:(NSString *)server;
- (void)setKeyNumbersForArray:(char[6])letters;
- (void)disconnect;

@end
