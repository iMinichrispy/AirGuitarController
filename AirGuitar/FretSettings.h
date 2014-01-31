//
//  ConnectedSettings.h
//  AirGuitar
//
//  Created by Alex Perez on 10/12/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FretHeaders.h"
#import "AvenirUI.h"

@interface FretSettings : UIView {
    UISlider *strumRepeatSensitivity;
    UISlider *strumThreshold;
    UISegmentedControl *numButtonsSelected;
    UISegmentedControl *pickInput;
}

@property (nonatomic, strong) id connectedView;

- (id)initWithView:(id)view type:(NSString *)type;
- (void)didChangeNumButtonsSelected;
- (float)getStrumRepeatSensitivity;
- (float)getStrumThreshold;
- (int)getNumButtonsSelected;
- (BOOL)pickAccelerometerEnabled;

@end
