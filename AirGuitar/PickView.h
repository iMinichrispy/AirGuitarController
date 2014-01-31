//
//  PickView.h
//  AirGuitar
//
//  Created by Alex Perez on 10/10/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvenirUI.h"
#import "Colors.h"
#import "FretSettings.h"

@interface PickView : UIView {
    UIButton *pick;
    AvenirLabel *shakeToStrum;
}

@property (nonatomic, strong) id pickDelegate;
@property (nonatomic, strong) FretSettings *settingsOverlay;;

- (id)initWithDelegate:(id)newDelegate;
- (void)setPickButtonInput:(int)input;

@end
