//
//  AsyncService.m
//  AirGuitar
//
//  Created by Alex Perez on 9/28/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import "AsyncService.h"
#import "ViewController.h"

@interface AsyncService () {
    id socketDelegate;
    NSMutableArray *connectedSockets;
    int keynumbers[6];
}

@end

@implementation AsyncService
@synthesize clientSocket;

- (id)initWithDelegate:(id)newDelegate {
    if (self) {
        socketDelegate = newDelegate;
        connectedSockets = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

#pragma mark Socket Delegate Methods

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket {
	[connectedSockets addObject:newSocket];
    [socketDelegate newLog:@"Accepted New Socket"];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    [socketDelegate newLog:@"Connected to Host"];
	self.clientSocket = sock;
	[sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:1];
    [socketDelegate setConnectedViewVisible:YES];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	// For receiving data from server. Currently, this should never happen
	
	NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
	NSString *msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
	if (msg)
        [socketDelegate newLog:[NSString stringWithFormat:@"Did Read Data: %@",msg]];
	else
        [socketDelegate newLog:@"Error converting received data into UTF-8 String"];
	[sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:1];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)error {
    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
    [socketDelegate newLog:[NSString stringWithFormat:@"Connection Lost"]];
	[connectedSockets removeObject:sock];
    [socketDelegate setConnectedViewVisible:NO];
}

- (void)connectToServer:(NSString *)server {
    NSError *error;
    [socketDelegate newLog:@"Attempting to Connect..."];
	
    AsyncSocket	*socket = [[AsyncSocket alloc] initWithDelegate:self];
    if(![socket connectToHost:server onPort:12345 error:&error]) {
        [socketDelegate newLog:[NSString stringWithFormat:@"Error Connecting: %@",[error localizedDescription]]];
	}
	else {
        //this is already in didconnecttohost
		self.clientSocket = socket;
        
        NSString *player = ([socketDelegate getPlayerType]==0) ? @"1" : @"2";
        NSString *component = ([socketDelegate getComponentType]==0) ? @"fret" : @"pick";
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"deviceInfo",@"type",[[UIDevice currentDevice] name],@"name",player,@"player",component,@"component", nil];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
        if (jsonData) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [self sendString:jsonString];
        }
	}
}

- (void)disconnect {
    [self.clientSocket disconnect];
}

#pragma mark Action Methods

- (void)sendKeyPress:(int)key type:(NSString *)type {
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",[NSNumber numberWithInt:keynumbers[key]],@"key", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sendString:jsonString];
}

- (void)sendKeyUp:(int)keyUp sendKeyDown:(int)keyDown {
    [self sendKeyPress:keyUp type:@"keyUp"];
    [self sendKeyPress:keyDown type:@"keyDown"];
}

- (void)sendString:(NSString *)jsonString {
    NSString *formattedString = [NSString stringWithFormat:@"%@\r\n",jsonString];
    NSData *data = [formattedString dataUsingEncoding:NSUTF8StringEncoding];
	[self.clientSocket writeData:data withTimeout:-1 tag:1];
}

- (void)setKeyNumbersForArray:(char[6])letters {
    for (int x = 0; x<6; x++)
        keynumbers[x] = [self keyCodeForKeyString:letters[x]];
}

- (int)keyCodeForKeyString:(char)key {
    switch (key) {
        case 'a': return 0;
        case 's': return 1;
        case 'd': return 2;
        case 'f': return 3;
        case 'h': return 4;
        case 'g': return 5;
        case 'z': return 6;
        case 'x': return 7;
        case 'c': return 8;
        case 'v': return 9;
        case 'b': return 11;
        case 'q': return 12;
        case 'w': return 13;
        case 'e': return 14;
        case 'r': return 15;
        case 'y': return 16;
        case 't': return 17;
        case '1': return 18;
        case '2': return 19;
        case '3': return 20;
        case '4': return 21;
        case '6': return 22;
        case '5': return 23;
        case '9': return 25;
        case '7': return 26;
        case '8': return 28;
        case '0': return 29;
        case 'o': return 31;
        case 'u': return 32;
        case 'i': return 34;
        case 'p': return 35;
        case 'l': return 37;
        case 'j': return 38;
        case 'k': return 40;
        case 'n': return 45;
        case 'm': return 46;
        default: return 999; // Invalid character
    }
    /*
     "LEFT" - 123
     "RIGHT" - 124
     "DOWN" - 125
     "UP" - 126
     */
}


@end
