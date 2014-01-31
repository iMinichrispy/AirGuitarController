//
//  AvenirLabel.h
//  AirGuitar
//
//  Created by Alex Perez on 1/13/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Colors.h"

@interface AvenirLabel : UILabel
@end

@interface AvenirSegment : UISegmentedControl
- (id)initWithItems:(NSArray *)items identifier:(NSString *)identity y:(int)y;
@property (nonatomic, strong) NSString *identifier;
@end

@interface AvenirTextView : UITextView
@end

@interface AvenirButton : UIButton
@end

@interface AvenirView : UIView
- (void)newLabel:(NSString *)labelText point:(CGPoint)point subview:(UIView *)view;
@end

@interface AvenirSlider : UISlider
@end
