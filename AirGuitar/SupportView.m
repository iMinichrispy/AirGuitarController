//
//  SupportView.m
//  AirGuitar
//
//  Created by Alex Perez on 1/16/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import "SupportView.h"
#import "ViewController.h"

#define FRAME_WIDTH     250
#define FRAME_HEIGHT    235

@implementation SupportView
@synthesize supportDelegate;

- (id)initWithDelegate:(id)delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT)];
    if (self) {
        self.alpha = 0.0;
        self.supportDelegate = delegate;
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-50);
        
        [self newLabel:@"Support" point:CGPointMake(FRAME_WIDTH/2, 30) subview:self];
        
        AvenirButton *troubleshooting = [[AvenirButton alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH-40, 40)];
        [troubleshooting setTitle:@"Troubleshooting" forState:UIControlStateNormal];
        [troubleshooting addTarget:self action:@selector(showTroubleshooting) forControlEvents:UIControlEventTouchUpInside];
        troubleshooting.center = CGPointMake(FRAME_WIDTH/2, 75);
        [self addSubview:troubleshooting];
        
        AvenirButton *email = [[AvenirButton alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH-40, 40)];
        [email setTitle:@"Email" forState:UIControlStateNormal];
        [email addTarget:self action:@selector(showEmail) forControlEvents:UIControlEventTouchUpInside];
        email.center = CGPointMake(FRAME_WIDTH/2, 125);
        [self addSubview:email];
        
        AvenirButton *dismiss = [[AvenirButton alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH-40, 40)];
        [dismiss setTitle:@"Cancel" forState:UIControlStateNormal];
        [dismiss addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        dismiss.center = CGPointMake(FRAME_WIDTH/2, FRAME_HEIGHT-40);
        [self addSubview:dismiss];
    }
    return self;
}

- (void)showTroubleshooting {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Redirect to Safari?" message:@"You will be redirected to the Safari app. Are you sure you want to continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)showEmail {
    [supportDelegate showMailView];
}

- (void)dismissView {
    [supportDelegate hideOverlay];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [supportDelegate newLog:@"Troubleshooting ->"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://airguitar.iminichrispy.com/#troubleshooting"]];
    }
}


@end
