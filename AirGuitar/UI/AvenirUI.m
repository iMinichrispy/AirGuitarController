//
//  AvenirLabel.m
//  AirGuitar
//
//  Created by Alex Perez on 1/13/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import "AvenirUI.h"
#import <CoreText/CoreText.h>
#define FONT_NAME   @"AvenirLT-Medium"

@implementation AvenirLabel

-  (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    self.textColor = TEXT_COLOR;
    self.font = [UIFont fontWithName:FONT_NAME size:17.0];
    self.textAlignment = NSTextAlignmentCenter;
}

@end


@implementation AvenirSegment
@synthesize identifier;

- (id)initWithItems:(NSArray *)items identifier:(NSString *)identity y:(int)y; {
    self = [super initWithItems:items];
    if (self) {
        self.identifier = identity;
        self.frame = CGRectMake(40, y, 240, 30);
        self.tintColor = [Colors colorWithGray:201.0];
        self.segmentedControlStyle = UISegmentedControlStyleBar;
        self.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:self.identifier];
        [self addTarget:self action:@selector(selectedSegmentChanged) forControlEvents:UIControlEventValueChanged];
        
        UIFont *font = [UIFont fontWithName:@"Avenir-Medium" size:15.0];
        [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, UITextAttributeFont, nil] forState:UIControlStateNormal];
//        [self setImage:[UIImage imageNamed:@"Left.png"] forSegmentAtIndex:0];
//        [self setImage:[UIImage imageNamed:@"Right.png"] forSegmentAtIndex:1];
    }
    return self;
}

- (void)selectedSegmentChanged {
    [[NSUserDefaults standardUserDefaults] setInteger:self.selectedSegmentIndex forKey:self.identifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end


@implementation AvenirTextView

- (void)awakeFromNib {
    self.textColor = TEXT_COLOR;
    self.font = [UIFont fontWithName:FONT_NAME size:17.0];
    self.backgroundColor = [UIColor colorWithRed:(51/255.0) green:(51/255.0) blue:(51/255.0) alpha:1.0];
    self.editable = NO;
    self.bounces = NO;
}

@end


@implementation AvenirButton

-  (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [self setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [self setTitleColor:TEXT_COLOR forState:UIControlStateHighlighted];
    self.titleLabel.font = [UIFont fontWithName:FONT_NAME size:16.0];
    self.backgroundColor = BUTTON_BG_COLOR;
    [self addTarget:self action:@selector(buttonHighlighted) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(buttonNormal) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(buttonNormal) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(buttonNormal) forControlEvents:UIControlEventTouchDragOutside];
}

- (void)buttonHighlighted {
    self.backgroundColor = [Colors colorWithGray:61.0];
}

- (void)buttonNormal {
    self.backgroundColor = BUTTON_BG_COLOR;
}

@end


@implementation AvenirView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds=YES;
        self.layer.borderColor=[TEXT_COLOR CGColor];
        self.layer.borderWidth = 5;
        self.backgroundColor = [Colors colorWithGray:41.0];
    }
    return self;
}

- (void)newLabel:(NSString *)labelText point:(CGPoint)point subview:(UIView *)view {
    CGRect frame = CGRectMake(0, 0, 180, (labelText.length>15) ? 62 : 20);
    AvenirLabel *label = [[AvenirLabel alloc] initWithFrame:frame];
    label.text = labelText;
    label.numberOfLines = 0;
    label.center = point;
    [view addSubview:label];
}

@end


@implementation AvenirSlider

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setMinimumTrackTintColor:[Colors colorWithGray:91.0]];
        [self setThumbTintColor:[Colors colorWithGray:150.0]];
    }
    return self;
}

@end
