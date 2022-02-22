//
//  NJOutputKeyPress.h
//  Enjoy
//
//  Created by Sam McCall on 5/05/09.
//  Copyright 2009 University of Otago. All rights reserved.
//

#import "NJOutput.h"
#import <CoreGraphics/CoreGraphics.h>

@interface NJOutputKeyPress : NJOutput

@property (nonatomic, assign) CGKeyCode firstKeyCode;
@property (nonatomic, assign) CGKeyCode secondKeyCode;
@property (nonatomic, assign) CGKeyCode thirdKeyCode;
@property (nonatomic, assign) CGKeyCode fourthKeyCode;
@property CGEventFlags flags;

@end
