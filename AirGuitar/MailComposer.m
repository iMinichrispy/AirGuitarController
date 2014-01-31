//
//  MailComposer.m
//  AirGuitar
//
//  Created by Alex Perez on 1/15/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import "MailComposer.h"

@implementation MailComposer
@synthesize mailDelegate;
@synthesize log;

- (id)initWithDelegate:(id)delegate log:(NSString *)logs {
    self = [super init];
    if (self) {
        self.mailDelegate = delegate;
        self.log = logs;
    }
    return self;
}

- (void)showMailPicker
{
    if ([MFMailComposeViewController canSendMail]) {
        [self displayMailComposerSheet];
    }
    else {
        NSString *recipients = [NSString stringWithFormat:@"mailto:%@",[Email recipients]];
        NSString *subject = [NSString stringWithFormat:@"?subject=%@",[Email subject]];
        NSString *body = [NSString stringWithFormat:@"&body=%@%@",[Email body],self.log];
        NSString *email = [NSString stringWithFormat:@"%@%@%@", recipients, subject, body];
        email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    }
}

- (void)displayMailComposerSheet {
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = mailDelegate;
	
	[picker setSubject:[Email subject]];
	[picker setToRecipients:[NSArray arrayWithObject:[Email recipients]]];
	[picker setMessageBody:[NSString stringWithFormat:@"%@%@",[Email body],self.log] isHTML:NO];
	
	[mailDelegate presentViewController:picker animated:YES completion:NULL];
}

@end
