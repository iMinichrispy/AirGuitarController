//
//  MailComposer.h
//  AirGuitar
//
//  Created by Alex Perez on 1/15/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "Email.h"

@interface MailComposer : NSObject

@property (nonatomic,strong) id mailDelegate;
@property (nonatomic,strong) NSString *log;

- (id)initWithDelegate:(id)delegate log:(NSString *)logs;
- (void)showMailPicker;

@end
