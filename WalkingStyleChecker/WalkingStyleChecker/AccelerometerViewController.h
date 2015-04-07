/**
 * The MIT License (MIT)
 * Copyright (c) 2015 DeNA Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 **/

//  AccelerometerViewController.m
//  WalkingStyleChecker


#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

#import "ParamCalculator.h"

#define BUTTON_RECORD_STOP      0
#define BUTTON_RECORDING        1


@interface AccelerometerViewController : UIViewController
{
    CMMotionManager *_motionManager;
    UIView* background;
    UILabel* axLabel;
    UILabel* ayLabel;
    UILabel* azLabel;
    
    UILabel* gxLabel;
    UILabel* gyLabel;
    UILabel* gzLabel;
    
    UIButton* calibration1Button;
    UIButton* calibration2Button;
    UIButton* writeButton;
    
    UITextField* text;
    
    int buttonFlag1;
    int buttonFlagCalibration;
    
    NSTimer *tm;
    
    ParamCalculator* paramCal;
    
    BOOL calibration1Result;
}


- (void)setLabel: (UILabel * __strong *)label
           title:(NSString*)title
           withX: (int)X
           withY: (int)Y
           withW: (int)W
           withH: (int)H;

- (void)setText: (UITextField * __strong *)textField
          withX: (int)X
          withY: (int)Y
          withW: (int)W
          withH: (int)H;

- (void)setButton: (UIButton * __strong *)button
            title: (NSString*)label
            withX: (int)X
            withY: (int)Y
            withW: (int)W
            withH: (int)H
         function: (SEL)selFunction;


- (void)calibration1Start;
- (void)calibration1Run;

- (void)calibration2Start;
- (void)calibration2Run;



@end
