//
//  ViewController.m
//  AirGuitar
//
//  Created by Alex Perez on 1/13/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import "ViewController.h"
#define INSTRUCTIONS_SENDER_TAG     101
#define SUPPORT_SENDER_TAG          102

@interface ViewController () {
    BonjourService *bonjour;
    AccessoryService *accessory;
    AsyncService *socket;
    Reachability *reachability;
    
    NSString *log;
    UIButton *hideButton;
    CMAcceleration lastAcceleration;
    BOOL accelDataExcited;
    
    FretsView *guitarFretsView;
    PickView *guitarPickView;
    InstructionsView *instructionsView;
    SupportView *supportView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_COLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
        [self firstLaunch];
    
    playerType = [[AvenirSegment alloc] initWithItems:[NSArray arrayWithObjects:@"Player 1",@"Player 2", nil] identifier:@"playerTypeSelected" y:75];
    [playerType addTarget:self action:@selector(didChangePlayerType) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:playerType];
    
    componentType = [[AvenirSegment alloc] initWithItems:[NSArray arrayWithObjects:@"Fret",@"Pick", nil] identifier:@"componentTypeSelected" y:132];
    [self.view addSubview:componentType];
    
    hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hideButton.backgroundColor = [UIColor blackColor];
    hideButton.userInteractionEnabled = NO;
    hideButton.frame = self.view.frame;
    hideButton.alpha = 0.0;
    [hideButton addTarget:self action:@selector(hideOverlay) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:hideButton];
    
    instructionsView = [[InstructionsView alloc] init];
    [self.view addSubview:instructionsView];
    
    supportView = [[SupportView alloc] initWithDelegate:self];
    [self.view addSubview:supportView];
    
    guitarFretsView = [[FretsView alloc] initWithDelegate:self];
    guitarPickView = [[PickView alloc] initWithDelegate:self];
    
    socket = [[AsyncService alloc] initWithDelegate:self];
    bonjour = [[BonjourService alloc] initWithService:@"_airguitar-fret._tcp." delegate:self];
    accessory = [[AccessoryService alloc] initWithDelegate:self];
    
    [self didChangePlayerType];
    
    float logY = SCREEN_HEIGHT + logTextView.bounds.size.height/2;
    logTextView.center = CGPointMake(logTextView.center.x, logY);
}

#pragma mark Setup

- (void)reachabilityChanged:(NSNotification *)note {
    [self newLog:@"Reachability changed, resetting..."];
    [self setConnectedViewVisible:NO];
    [bonjour stop];
    [socket disconnect];
    [bonjour browseServices];
}

- (void)firstLaunch {
    [self showOverlay:[self.view viewWithTag:INSTRUCTIONS_SENDER_TAG]];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"playerTypeSelected"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"componentTypeSelected"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"numButtonsSelected"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"pickButtonSelected"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Overlay

- (IBAction)showOverlay:(id)sender {
    hideButton.userInteractionEnabled = YES;
    UIView *overLayView = ([sender tag] == INSTRUCTIONS_SENDER_TAG) ? instructionsView : supportView;
    [self.view bringSubviewToFront:overLayView];
    [UIView animateWithDuration:.2 animations:^{
        hideButton.alpha = 0.7;
        overLayView.alpha = 1.0;
    }];
}

- (void)hideOverlay {
    hideButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:.2 animations:^{
        hideButton.alpha = 0.0;
        instructionsView.alpha = 0.0;
        supportView.alpha = 0.0;
    }];
}

#pragma mark Application State

- (void)viewWillAppear:(BOOL)animated {
    [accessory viewWillAppear];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [accessory viewWillDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self setConnectedViewVisible:NO];
    [bonjour stop];
    [socket disconnect];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [bonjour browseServices];
}

#pragma mark Accelerometer

- (CMMotionManager *)motionManager {
    CMMotionManager *motionManager = nil;
    id appDelegate = [UIApplication sharedApplication].delegate;
    if ([appDelegate respondsToSelector:@selector(motionManager)]) {
        motionManager = [appDelegate motionManager];
    }
    return motionManager;
}

- (void)setupAccelerometer {
    [self.motionManager setAccelerometerUpdateInterval:.08];
    
    if (self.motionManager.accelerometerAvailable) {
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            CMAcceleration acceleration = accelerometerData.acceleration;
            if (lastAcceleration.x && lastAcceleration.y && lastAcceleration.z) {
                if (!accelDataExcited && [self accelerationIsShaking:lastAcceleration currentAcceleration:acceleration threshold:[self getStrumThreshold]]) {
                    accelDataExcited = YES;
                    
                    if (componentType.selectedSegmentIndex==0)
                        [socket sendKeyPress:STAR_POWER type:@"keyDownUp"];
                    else if (componentType.selectedSegmentIndex==1 && [guitarPickView.settingsOverlay pickAccelerometerEnabled])
                        [socket sendKeyPress:PICK_1 type:@"keyDownUp"];
                    
                    [self.motionManager stopAccelerometerUpdates];
                    [self performSelector:@selector(setupAccelerometer) withObject:self afterDelay:[self getStrumRepeatSensitivity]];
                    
                }
                else if (accelDataExcited && ![self accelerationIsShaking:lastAcceleration currentAcceleration:acceleration threshold:[self getStrumThreshold]]) {
                    accelDataExcited = NO;
                }
            }
            lastAcceleration = acceleration;
        }];
    }
}

- (BOOL)accelerationIsShaking:(CMAcceleration)last currentAcceleration:(CMAcceleration)current threshold:(double)threshold {
    double deltaX = fabs(last.x - current.x);
    double deltaY = fabs(last.y - current.y);
    double deltaZ = fabs(last.z - current.z);
    
	return (deltaX > threshold && deltaY > threshold) || (deltaX > threshold && deltaZ > threshold) || (deltaY > threshold && deltaZ > threshold);
}

- (void)didChangePlayerType {
    if (playerType.selectedSegmentIndex == 0) {
        char letters[] = PLAYER1_KEYS;
        [socket setKeyNumbersForArray:letters];
    }
    else {
        char letters[] = PLAYER2_KEYS;
        [socket setKeyNumbersForArray:letters];
    }
}

- (void)setConnectedViewVisible:(BOOL)visible {
    if (visible) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        [self setupAccelerometer];
        ((componentType.selectedSegmentIndex==0) ? guitarFretsView : guitarPickView).hidden = NO;
        [self.view addSubview:(componentType.selectedSegmentIndex==0) ? guitarFretsView : guitarPickView];
    }
    else {
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        [self.motionManager stopAccelerometerUpdates];
        guitarFretsView.hidden = YES;
        guitarPickView.hidden = YES;
    }
}

#pragma mark Log

- (void)newLog:(NSString *)newLog {
    NSDate *epochNSDate = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *dateString = [dateFormatter stringFromDate:epochNSDate];
    
    log = (log) ? [NSString stringWithFormat:@"%@\n[%@] %@",log,dateString,newLog] : [NSString stringWithFormat:@"[%@] %@",dateString,newLog];
    
    logTextView.text = ([logTextView.text length]==0) ? newLog : [NSString stringWithFormat:@"%@\n%@",logTextView.text,newLog];
    [logTextView scrollRangeToVisible:NSMakeRange([logTextView.text length], 0)];
}

- (IBAction)hideShowLog {
    float logNewY;
    
    if (logTextView.frame.origin.y>479) {
        [toggleLogButton setTitle:@"Hide Log" forState:UIControlStateNormal];
        logNewY = SCREEN_HEIGHT - 74;
    }
    else {
        [toggleLogButton setTitle:@"View Log" forState:UIControlStateNormal];
        logNewY = SCREEN_HEIGHT + logTextView.bounds.size.height/2;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        logTextView.center = CGPointMake(logTextView.center.x, logNewY);
    }];
}

#pragma mark Getters

- (float)getStrumRepeatSensitivity {
    return (componentType==0) ? [guitarFretsView.settingsOverlay getStrumRepeatSensitivity] : [guitarPickView.settingsOverlay getStrumRepeatSensitivity];
}

- (float)getStrumThreshold {
    return (componentType==0) ? [guitarFretsView.settingsOverlay getStrumThreshold] : [guitarPickView.settingsOverlay getStrumThreshold];
}

- (int)getPlayerType {
    return (int)playerType.selectedSegmentIndex;
}

- (int)getComponentType {
    return (int)componentType.selectedSegmentIndex;
}

- (AsyncService *)getSocketService {
    return socket;
}

#pragma mark Mail View

- (void)showMailView {
    MailComposer *composer = [[MailComposer alloc] initWithDelegate:self log:log];
    [composer showMailPicker];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self hideOverlay];
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Failed" message:@"Your message has failed to send." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
