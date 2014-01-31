//
//  SupportView.h
//  AirGuitar
//
//  Created by Alex Perez on 1/16/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import "AvenirUI.h"

@interface SupportView : AvenirView <UIAlertViewDelegate>

@property (nonatomic,strong) id supportDelegate;

- (id)initWithDelegate:(id)delegate;

@end
