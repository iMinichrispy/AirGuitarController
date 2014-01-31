//
//  PickView.m
//  AirGuitar
//
//  Created by Alex Perez on 10/10/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import "PickView.h"
#import "ViewController.h"

#define REPEAT_LABEL_Y      55
#define THRESHOLD_LABEL_Y   120

@implementation PickView
@synthesize pickDelegate;
@synthesize settingsOverlay;

- (id)initWithDelegate:(id)newDelegate {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        self.pickDelegate = newDelegate;
        self.backgroundColor = BG_COLOR;
        
        pick = [UIButton buttonWithType:UIButtonTypeCustom];
        pick.frame = CGRectMake(35, 200, 250, 250);
        pick.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [pick addTarget:self action:@selector(strum) forControlEvents:UIControlEventTouchDown];
        [pick setImage:[UIImage imageNamed:@"Pick.png"] forState:UIControlStateNormal];
        [self addSubview:pick];
        
        UIButton *gear = [[UIButton alloc] initWithFrame:CGRectMake(16, 16, 28, 28)];
        [gear setImage:[UIImage imageNamed:@"SettingsGear.png"] forState:UIControlStateNormal];
        [gear addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:gear];
        
        settingsOverlay = [[FretSettings alloc] initWithView:self type:@"Pick"];
        settingsOverlay.transform = CGAffineTransformMakeRotation(-M_PI/2);
        settingsOverlay.center = CGPointMake(-settingsOverlay.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:settingsOverlay];
        
        shakeToStrum = [[AvenirLabel alloc] init];
        shakeToStrum.text = @"Shake to\nStrum";
        shakeToStrum.numberOfLines = 0;
        [shakeToStrum sizeToFit];
        shakeToStrum.textColor = BG_COLOR;
        shakeToStrum.center = CGPointMake(pick.center.x, pick.center.y+15);
        [self addSubview:shakeToStrum];
        
        [self setPickButtonInput:[[NSUserDefaults standardUserDefaults] integerForKey:@"pickButtonSelected"]];
    }
    return self;
}

- (void)setPickButtonInput:(int)input {
    if (input == 0) {
        shakeToStrum.hidden = YES;
        [pick setImage:[UIImage imageNamed:@"Pick-Pressed.png"] forState:UIControlStateHighlighted];
        [pick addTarget:self action:@selector(strum) forControlEvents:UIControlEventTouchDown];
    }
    else {
        shakeToStrum.hidden = NO;
        [pick setImage:[UIImage imageNamed:@"Pick.png"] forState:UIControlStateHighlighted];
        [pick removeTarget:self action:@selector(strum) forControlEvents:UIControlEventTouchDown];
    }
}

- (void)showSettings {
    pick.userInteractionEnabled = NO;
    [self bringSubviewToFront:settingsOverlay];
    [UIView animateWithDuration:.2 animations:^{
        settingsOverlay.center = CGPointMake(settingsOverlay.frame.size.width/2, settingsOverlay.center.y);
    }];
}

- (void)hideSettings {
    pick.userInteractionEnabled = YES;
    if (settingsOverlay.center.x == settingsOverlay.frame.size.width/2) {
        [UIView animateWithDuration:.2 animations:^{
            settingsOverlay.center = CGPointMake(-settingsOverlay.frame.size.width/2, settingsOverlay.center.y);
        }];
    }
}

- (BOOL)settingsVisible {
    return (settingsOverlay.center.x>70);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self settingsVisible]) {
        for (UITouch *touch in touches) {
            if (CGRectContainsPoint(CGRectMake(settingsOverlay.frame.size.width, 0, SCREEN_WIDTH-settingsOverlay.frame.size.width, SCREEN_HEIGHT), [touch locationInView:self]))
                [self hideSettings];
        }
    }
}

- (void)strum {
    [[pickDelegate getSocketService] sendKeyPress:PICK_1 type:@"keyDownUp"];
    [pick setImage:[UIImage imageNamed:@"Pick-Pressed.png"] forState:UIControlStateHighlighted];
    [self performSelector:@selector(resetPick) withObject:nil afterDelay:.1];
}

- (void)resetPick {
    [pick setImage:[UIImage imageNamed:@"Pick.png"] forState:UIControlStateHighlighted];
}

@end
