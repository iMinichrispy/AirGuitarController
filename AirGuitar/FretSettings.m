//
//  ConnectedSettings.m
//  AirGuitar
//
//  Created by Alex Perez on 10/12/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import "FretSettings.h"
#import "FretsView.h"
#import "PickView.h"

#define SLIDER_WIDTH            216
#define SLIDER_SPACE            6
#define SLIDER_SPACE_5          12

@implementation FretSettings
@synthesize connectedView;

- (id)initWithView:(id)view type:(NSString *)type {
    if ([super initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 150)]) {
        self.connectedView = view;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
        
        float repeatX = self.bounds.size.width/2-(SLIDER_WIDTH+((IS_IPHONE_5) ? SLIDER_SPACE_5 : SLIDER_SPACE));
        strumRepeatSensitivity = [[AvenirSlider alloc] initWithFrame:CGRectMake(repeatX, 38, SLIDER_WIDTH, 29)];
        float strumX = self.bounds.size.width/2+((IS_IPHONE_5) ? SLIDER_SPACE_5 : SLIDER_SPACE);
        strumThreshold = [[AvenirSlider alloc] initWithFrame:CGRectMake(strumX, 38, SLIDER_WIDTH, 29)];
        [self setupSlider:strumRepeatSensitivity max:.2 min:.1 title:@"Strum Repeat Sensitivity"];
        [self setupSlider:strumThreshold max:.8 min:0 title:@"Strum Threshold Sensitivity"];
        [strumRepeatSensitivity setValue:.15];
        [strumThreshold setValue:.4];
        
        if ([type isEqualToString:@"Fret"]) {
            if (!IS_IPHONE_5) {
                numButtonsSelected = [[AvenirSegment alloc] initWithItems:[NSArray arrayWithObjects:@"Four",@"Five", nil]];
                [numButtonsSelected setFrame:CGRectMake(0,83,190,45)];
                [numButtonsSelected setCenter:CGPointMake(strumRepeatSensitivity.center.x, numButtonsSelected.center.y)];
                [numButtonsSelected setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"numButtonsSelected"]];
                numButtonsSelected.segmentedControlStyle = UISegmentedControlStyleBar;
                [numButtonsSelected addTarget:self action:@selector(didChangeNumButtonsSelected) forControlEvents:UIControlEventValueChanged];
                [numButtonsSelected setTintColor:[UIColor lightGrayColor]];
                [self addSubview:numButtonsSelected];
            }
        }
        else {
            pickInput = [[AvenirSegment alloc] initWithItems:[NSArray arrayWithObjects:@"Button",@"Accel", nil]];
            [pickInput setFrame:CGRectMake(0,83,190,45)];
            [pickInput setCenter:CGPointMake(strumRepeatSensitivity.center.x, pickInput.center.y)];
            [pickInput setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"pickButtonSelected"]];
            [pickInput addTarget:self action:@selector(didChangePickInputSelected) forControlEvents:UIControlEventValueChanged];
            [pickInput setTintColor:[UIColor lightGrayColor]];
            [self addSubview:pickInput];
        }
        
        float openAppY;
        if ([type isEqualToString:@"Fret"])
            openAppY = (IS_IPHONE_5) ? 189 : 260;
        else
            openAppY = strumThreshold.center.x-95;
        
        AvenirButton *openAppButton = [[AvenirButton alloc] initWithFrame:CGRectMake(openAppY, 83, 190, 45)];
        [openAppButton setTitle:@"Open App" forState:UIControlStateNormal];
        [openAppButton addTarget:self action:@selector(openApp) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:openAppButton];
    }
    return self;
}

- (void)setupSlider:(UISlider *)slider max:(float)max min:(float)min title:(NSString *)title {
    [self newLabelWithText:title atX:slider.center.x];
    [slider setMaximumValue:max];
    [slider setMinimumValue:min];
    [slider setValue:(max+min)/2.0];
    [self addSubview:slider];
}

- (void)newLabelWithText:(NSString *)title atX:(float)x {
    AvenirLabel *label = [[AvenirLabel alloc] initWithFrame:CGRectMake(0, 9, 212, 21)];
    [label setCenter:CGPointMake(x, label.center.y)];
    [label setText:title];
    [self addSubview:label];
}

- (void)didChangeNumButtonsSelected {
    [[NSUserDefaults standardUserDefaults] setInteger:numButtonsSelected.selectedSegmentIndex forKey:@"numButtonsSelected"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.connectedView setNumFrets:(numButtonsSelected.selectedSegmentIndex==0) ? 4 : 5];
}

- (void)didChangePickInputSelected {
    [[NSUserDefaults standardUserDefaults] setInteger:pickInput.selectedSegmentIndex forKey:@"pickButtonSelected"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.connectedView setPickButtonInput:pickInput.selectedSegmentIndex];
}

- (void)openApp {
    [self.connectedView sendOpenAppCommand];
}

#pragma mark Getters

- (float)getStrumRepeatSensitivity {
    return strumRepeatSensitivity.value;
}

- (float)getStrumThreshold {
    return strumThreshold.value;
}

- (int)getNumButtonsSelected {
    return numButtonsSelected.selectedSegmentIndex;
}

- (BOOL)pickAccelerometerEnabled {
    return pickInput.selectedSegmentIndex == 1;
}

@end
