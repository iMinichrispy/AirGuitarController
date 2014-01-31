//
//  FretsView.h
//  AirGuitar
//
//  Created by Alex Perez on 9/27/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FretHeaders.h"
#import "FretSettings.h"

@interface FretsView : UIView {
    UIButton *gear;
}

@property (nonatomic, strong) id fretsDelegate;
@property (nonatomic, strong) FretSettings *settingsOverlay;;
@property (nonatomic,readwrite) int numButtons;

- (id)initWithDelegate:(id)newDelegate;
- (void)setNumFrets:(int)num;
- (void)sendOpenAppCommand;

@end
