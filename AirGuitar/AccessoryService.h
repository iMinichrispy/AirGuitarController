//
//  AccessoryService.h
//  AirGuitar
//
//  Created by Alex Perez on 9/27/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AirGuitarSDK.h"
#import "Acceleration.h"
#import "FretHeaders.h"

@interface AccessoryService : NSObject <AGAccessoryProtocol>

@property (nonatomic, strong) AGAccessoryManager *airGuitarManager;

- (id)initWithDelegate:(id)newDelegate;
- (void)viewWillAppear;
- (void)viewWillDisappear;

@end
