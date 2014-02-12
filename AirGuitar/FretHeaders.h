//
//  FretHeaders.h
//  AirGuitar
//
//  Created by Alex Perez on 10/10/13.
//  Copyright (c) 2013 Alex Perez. All rights reserved.
//

#define FRET_1 0
#define FRET_2 1
#define FRET_3 2
#define FRET_4 3
#define FRET_5 4
#define PICK_1 5
#define PICK_2 5 // Yet to be implemented
#define STAR_POWER 6
#define PLAYER1_KEYS {'c','d','e','f','g','h','i'}
#define PLAYER2_KEYS {'m','n','o','p','q','r','s'}

#define IS_IPHONE ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"])
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen] bounds].size.height >= 568.0f
#define IS_IPHONE_5 (IS_IPHONE && IS_HEIGHT_GTE_568)

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height