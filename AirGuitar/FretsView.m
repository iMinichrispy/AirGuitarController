//
//  FretsView.m
//  AirGuitar
//
//  Created by Alex Perez on 9/27/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import "FretsView.h"
#import "ViewController.h"

#define COLORS [NSArray arrayWithObjects:@"Green",@"Red",@"Yellow",@"Blue",@"Orange", nil]
#define SETTINGS_BUTTON_TAG         199
#define SETTINGS_OVERLAY_TAG        198
#define GREEN_FRET_TAG              300
#define RED_FRET_TAG                301
#define YELLOW_FRET_TAG             302
#define BLUE_FRET_TAG               303
#define ORANGE_FRET_TAG             304

@implementation FretsView
@synthesize fretsDelegate;
@synthesize settingsOverlay;
@synthesize numButtons;

- (id)initWithDelegate:(id)newDelegate {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        self.fretsDelegate = newDelegate;
        [self setNumFrets:([[NSUserDefaults standardUserDefaults] integerForKey:@"numButtonsSelected"]==0) ? 4 : 5];
        
        self.multipleTouchEnabled = YES;
        
        gear = [[UIButton alloc] initWithFrame:CGRectMake(16, 16, 28, 28)];
        gear.tag = SETTINGS_BUTTON_TAG;
        [gear setImage:[UIImage imageNamed:@"SettingsGear.png"] forState:UIControlStateNormal];
        [gear addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:gear];
        
        settingsOverlay = [[FretSettings alloc] initWithView:self type:@"Fret"];
        settingsOverlay.tag = SETTINGS_OVERLAY_TAG;
        settingsOverlay.transform = CGAffineTransformMakeRotation(-M_PI/2);
        settingsOverlay.center = CGPointMake(-settingsOverlay.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:settingsOverlay];
    }
    return self;
}

- (void)setNumFrets:(int)num {
    self.numButtons = (IS_IPHONE_5) ? 5 : num;
    
    float fretY = SCREEN_HEIGHT/self.numButtons;
    
    for (UIView *view in self.subviews) {
        if (view.tag >= 300)
            [view removeFromSuperview];
    }
    
    for (int x = 0; x < self.numButtons; x++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, x*fretY, SCREEN_WIDTH, fretY)];
        image.tag = [[NSString stringWithFormat:@"30%i",x] intValue];
        NSString *color = [COLORS objectAtIndex:x];
        [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",color]]];
        [self addSubview:image];
    }
    
    [self bringSubviewToFront:[self viewWithTag:SETTINGS_BUTTON_TAG]];
    [self bringSubviewToFront:[self viewWithTag:SETTINGS_OVERLAY_TAG]];
}

#pragma Touches Methods

- (void)setKey:(int)tag down:(BOOL)down {
    [[fretsDelegate getSocketService] sendKeyPress:tag type:(down) ? @"keyDown" : @"keyUp"];
    UIImageView *fret = (UIImageView *)[self viewWithTag:[[NSString stringWithFormat:@"30%i",tag] intValue]];
    NSString *color = [COLORS objectAtIndex:tag];
    NSString *imagePath = [NSString stringWithFormat:(down) ? @"%@-Pressed.png" : @"%@.png",color];
    [fret setImage:[UIImage imageNamed:imagePath]];
}

- (void)setKeyUp:(int)up keyDown:(int)down {
    [self setKey:up down:NO];
    [self setKey:down down:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    float fretY = SCREEN_HEIGHT/self.numButtons;
    
    for (UITouch *touch in touches) {
        if (CGRectContainsPoint(CGRectMake(settingsOverlay.frame.size.width, 0, SCREEN_WIDTH-settingsOverlay.frame.size.width, SCREEN_HEIGHT), [touch locationInView:self]) && [self settingsVisible])
            [self hideSettings];
        else if (![self settingsVisible]) {
            if (CGRectContainsPoint(CGRectMake(0, 0, SCREEN_WIDTH, fretY), [touch locationInView:self]) && !CGRectContainsPoint(CGRectMake(gear.frame.origin.x-2, gear.frame.origin.y-2, gear.frame.size.width+4, gear.frame.size.height+4), [touch locationInView:self]))
                [self setKey:FRET_1 down:YES];
            if (CGRectContainsPoint(CGRectMake(0, fretY*1, SCREEN_WIDTH, fretY), [touch locationInView:self]))
                [self setKey:FRET_2 down:YES];
            if (CGRectContainsPoint(CGRectMake(0, fretY*2, SCREEN_WIDTH, fretY), [touch locationInView:self]))
                [self setKey:FRET_3 down:YES];
            if (CGRectContainsPoint(CGRectMake(0, fretY*3, SCREEN_WIDTH, fretY), [touch locationInView:self]))
                [self setKey:FRET_4 down:YES];
            if (CGRectContainsPoint(CGRectMake(0, fretY*4, SCREEN_WIDTH, fretY), [touch locationInView:self]))
                [self setKey:FRET_5 down:YES];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        float currentY = [touch locationInView:self].y;
        float previousY = [touch previousLocationInView:self].y;
        float fretY = SCREEN_HEIGHT/self.numButtons;
        
        if (currentY>previousY) {
            if (currentY>fretY*1 && previousY<fretY*1)
                [self setKeyUp:FRET_1 keyDown:FRET_2];
            else if (currentY>fretY*2 && previousY<fretY*2)
                [self setKeyUp:FRET_2 keyDown:FRET_3];
            else if (currentY>fretY*3 && previousY<fretY*3)
                [self setKeyUp:FRET_3 keyDown:FRET_4];
            else if (currentY>fretY*4 && previousY<fretY*4)
                [self setKeyUp:FRET_4 keyDown:FRET_5];
        }
        else if (currentY<previousY) {
            if (currentY<fretY*1 && previousY>fretY*1)
                [self setKeyUp:FRET_2 keyDown:FRET_1];
            else if (currentY<fretY*2 && previousY>fretY*2)
                [self setKeyUp:FRET_3 keyDown:FRET_2];
            else if (currentY<fretY*3 && previousY>fretY*3)
                [self setKeyUp:FRET_4 keyDown:FRET_3];
            else if (currentY<fretY*4 && previousY>fretY*4)
                [self setKeyUp:FRET_5 keyDown:FRET_4];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    float fretY = SCREEN_HEIGHT/self.numButtons;
    
    for (UITouch *touch in touches) {
        if (CGRectContainsPoint(CGRectMake(0, 0, SCREEN_WIDTH, fretY), [touch locationInView:self]))
            [self setKey:FRET_1 down:NO];
        if (CGRectContainsPoint(CGRectMake(0, fretY*1, SCREEN_WIDTH, fretY), [touch locationInView:self]))
            [self setKey:FRET_2 down:NO];
        if (CGRectContainsPoint(CGRectMake(0, fretY*2, SCREEN_WIDTH, fretY), [touch locationInView:self]))
            [self setKey:FRET_3 down:NO];
        if (CGRectContainsPoint(CGRectMake(0, fretY*3, SCREEN_WIDTH, fretY), [touch locationInView:self]))
            [self setKey:FRET_4 down:NO];
        if (CGRectContainsPoint(CGRectMake(0, fretY*4, SCREEN_WIDTH, fretY), [touch locationInView:self]))
            [self setKey:FRET_5 down:NO];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setKey:FRET_1 down:NO];
    [self setKey:FRET_2 down:NO];
    [self setKey:FRET_3 down:NO];
    [self setKey:FRET_4 down:NO];
    [self setKey:FRET_5 down:NO];
}

#pragma Frets Settings Methods

- (void)showSettings {
    [self bringSubviewToFront:settingsOverlay];
    [UIView animateWithDuration:.2 animations:^{
        settingsOverlay.center = CGPointMake(settingsOverlay.frame.size.width/2, settingsOverlay.center.y);
    }];
}

- (void)hideSettings {
    if (settingsOverlay.center.x==settingsOverlay.frame.size.width/2) {
        [UIView animateWithDuration:.2 animations:^{
            settingsOverlay.center = CGPointMake(-settingsOverlay.frame.size.width/2, settingsOverlay.center.y);
        }];
    }
}

- (BOOL)settingsVisible {
    return (settingsOverlay.center.x>70);
}

- (void)sendOpenAppCommand {
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"openApp",@"type",@"Rock Band",@"name", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[fretsDelegate getSocketService] sendString:jsonString];
}


@end
