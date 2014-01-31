//
//  ViewController.h
//  AirGuitar
//
//  Created by Alex Perez on 1/13/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FretHeaders.h"
#import "FretsView.h"
#import "PickView.h"
#import "AccessoryService.h"
#import "AsyncService.h"
#import "BonjourService.h"
#import "InstructionsView.h"
#import "SupportView.h"
#import "MailComposer.h"
#import <MessageUI/MessageUI.h>
#import "Reachability.h"
#import <CoreMotion/CoreMotion.h>


@interface ViewController : UIViewController <UIAlertViewDelegate,MFMailComposeViewControllerDelegate> {
    IBOutlet UIButton *toggleLogButton;
    IBOutlet UITextView *logTextView;
    IBOutlet UISegmentedControl *playerType;
    IBOutlet UISegmentedControl *componentType;
}

- (IBAction)showOverlay:(id)sender;
- (void)hideOverlay;
- (void)showMailView;

- (void)setConnectedViewVisible:(BOOL)visible;

- (IBAction)hideShowLog;
- (void)newLog:(NSString *)log;

- (AsyncService *)getSocketService;
- (int)getPlayerType;
- (int)getComponentType;
- (float)getStrumRepeatSensitivity;
- (float)getStrumThreshold;

@end
