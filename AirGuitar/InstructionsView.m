//
//  InstructionsView.m
//  AirGuitar
//
//  Created by Alex Perez on 11/11/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#import "InstructionsView.h"

#define FRAME_WIDTH     250
#define FRAME_HEIGHT    270

@interface InstructionsView () {
    UIScrollView *pageScrollView;
    UIPageControl *pageControl;
}

@end

@implementation InstructionsView

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT)];
    if (self) {
        self.alpha = 0.0;
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-40);
        
        pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT)];
        pageScrollView.contentSize = CGSizeMake(FRAME_WIDTH*3, FRAME_HEIGHT);
        pageScrollView.pagingEnabled = YES;
        pageScrollView.delegate = self;
        pageScrollView.showsHorizontalScrollIndicator = NO;
        pageScrollView.bounces = NO;
        [self addSubview:pageScrollView];
        
        UIButton *macButton = [UIButton buttonWithType:UIButtonTypeCustom];
        macButton.frame = CGRectMake(0, 0, 75, 75);
        [macButton setImage:[UIImage imageNamed:@"Mac.png"] forState:UIControlStateNormal];
        macButton.contentMode = UIViewContentModeScaleToFill;
        macButton.center = CGPointMake(FRAME_WIDTH/2, FRAME_HEIGHT/2+43);
        [macButton addTarget:self action:@selector(redirectSafari) forControlEvents:UIControlEventTouchUpInside];
        [pageScrollView addSubview:macButton];
        
        [self newImage:@"WiFi.png" frame:CGRectMake(0, 0, 139, 40) center:CGPointMake(FRAME_WIDTH/2+FRAME_WIDTH, FRAME_HEIGHT/2+47)];
        [self newImage:@"Guitar.png" frame:CGRectMake(0, 0, 75, 75) center:CGPointMake(FRAME_WIDTH/2+2*FRAME_WIDTH, FRAME_HEIGHT/2+43)];
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(FRAME_WIDTH/2-25, FRAME_HEIGHT-50, 50, 50)];
        pageControl.numberOfPages = 3;
        [pageControl addTarget:self action:@selector(pageControlValueChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:pageControl];
        
        [self newLabel:@"Getting Started" point:CGPointMake(FRAME_WIDTH/2, 30) subview:self];
        [self newLabel:@"Download\nAirGuitarServer\nfor Mac from:" point:CGPointMake(FRAME_WIDTH/2, FRAME_HEIGHT/2-45) subview:pageScrollView];
        [self newLabel:@"Ensure both devices\nare connected to same\nWiFi network." point:CGPointMake(FRAME_WIDTH/2+FRAME_WIDTH, FRAME_HEIGHT/2-45) subview:pageScrollView];
        [self newLabel:@"Start both\napps and enjoy\nrocking out!" point:CGPointMake(FRAME_WIDTH/2+2*FRAME_WIDTH, FRAME_HEIGHT/2-45) subview:pageScrollView];
    }
    return self;
}

- (void)newImage:(NSString *)path frame:(CGRect)frame center:(CGPoint)center {
    UIImageView *image = [[UIImageView alloc] initWithFrame:frame];
    image.image = [UIImage imageNamed:path];
    image.contentMode = UIViewContentModeScaleToFill;
    image.center = center;
    [pageScrollView addSubview:image];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.bounds.size.width;
    NSInteger pageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = pageNumber;
}

- (void)pageControlValueChanged {
    int whichPage = pageControl.currentPage;
    [UIView animateWithDuration:0.3f animations:^{
        pageScrollView.contentOffset = CGPointMake(FRAME_WIDTH * whichPage, 0.0f);
    }];
}

- (void)redirectSafari {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Redirect to Safari?" message:@"You will be redirected to the Safari app. Are you sure you want to continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://airguitar.iminichrispy.com/"]];
}

@end
