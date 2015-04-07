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

//  ParamCalculator.h
//  WalkingStyleChecker


#import <Foundation/Foundation.h>
#import "XYZObject.h"


#define DIM                     10 // 最小二乗法の最大次数

@interface ParamCalculator : NSObject
{
    
    NSArray* firLpfArray;
    
    double calibrationSA;
    double calibrationCA;
    double calibrationSB;
    double calibrationCB;
    double calibrationSC;
    double calibrationCC;
    
    NSMutableArray* stepArray;
    
    // ステップごとに保存する
    NSMutableArray* stepCountArray;
    
    NSMutableArray* averageXStepArray;
    NSMutableArray* averageZStepArray;
    NSMutableArray* stddevXStepArray;
    NSMutableArray* stddevZStepArray;
    NSMutableArray* averageDeltaYStepArray;
    NSMutableArray* mountValleyYStepArray;
    NSMutableArray* averageLpfDeltaYStepArray;
    NSMutableArray* mountValleyLpfYStepArray;
    NSMutableArray* averageLpfAbsXStepArray;
    NSMutableArray* slopeZStepArray;
    NSMutableArray* averageRadianXYStepArray;
    NSMutableArray* averageRadianXZStepArray;
    NSMutableArray* stddevRadianXYStepArray;
    NSMutableArray* stddevRadianXZStepArray;
    NSMutableArray* averageRadianLpfXYStepArray;
    NSMutableArray* averageRadianLpfXZStepArray;
    NSMutableArray* stddevRadianLpfXYStepArray;
    NSMutableArray* stddevRadianLpfXZStepArray;
    
    
}
@property long accArrayCount;
@property (strong, nonatomic) NSMutableArray* accelerometerArray;
@property (strong, nonatomic) NSMutableArray* accelerometerLpfArray;
@property (strong, nonatomic) NSMutableArray* gyroArray;
@property (strong, nonatomic) NSMutableArray* radianXYArray;
@property (strong, nonatomic) NSMutableArray* radianXZArray;
@property (strong, nonatomic) NSMutableArray* radianLpfXYArray;
@property (strong, nonatomic) NSMutableArray* radianLpfXZArray;
@property (strong, nonatomic) NSMutableArray* accelerometerLpfDeltaXArray;


@property double averageX;
@property double averageZ;
@property double stddevX;
@property double stddevZ;
@property double averageLpfDeltaY;
@property double mountValleyY;
@property double averageLpfAbsX;
@property double slopeZ;
@property double averageRadianXY;
@property double averageRadianXZ;
@property double stddevRadianXY;
@property double stddevRadianXZ;
@property double averageRadianLpfXY;
@property double averageRadianLpfXZ;
@property double stddevRadianLpfXY;
@property double stddevRadianLpfXZ;

@property long stepValleyCount;

@property double averageXStep;
@property double averageZStep;
@property double stddevXStep;
@property double stddevZStep;
@property double averageDeltaYStep;
@property double mountValleyYStep;
@property double averageLpfDeltaYStep;
@property double mountValleyLpfYStep;
@property double averageLpfAbsXStep;
@property double slopeZStep;
@property double averageRadianXYStep;
@property double averageRadianXZStep;
@property double stddevRadianXYStep;
@property double stddevRadianXZStep;
@property double averageRadianLpfXYStep;
@property double averageRadianLpfXZStep;
@property double stddevRadianLpfXYStep;
@property double stddevRadianLpfXZStep;

@property double averageXStepAve;
@property double averageZStepAve;
@property double stddevXStepAve;
@property double stddevZStepAve;
@property double averageDeltaYStepAve;
@property double mountValleyYStepAve;
@property double averageLpfDeltaYStepAve;
@property double mountValleyLpfYStepAve;
@property double averageLpfAbsXStepAve;
@property double slopeZStepAve;
@property double averageRadianXYStepAve;
@property double averageRadianXZStepAve;
@property double stddevRadianXYStepAve;
@property double stddevRadianXZStepAve;
@property double averageRadianLpfXYStepAve;
@property double averageRadianLpfXZStepAve;
@property double stddevRadianLpfXYStepAve;
@property double stddevRadianLpfXZStepAve;

@property double averageXStepDev;
@property double averageZStepDev;
@property double stddevXStepDev;
@property double stddevZStepDev;
@property double averageDeltaYStepDev;
@property double mountValleyYStepDev;
@property double averageLpfDeltaYStepDev;
@property double mountValleyLpfYStepDev;
@property double averageLpfAbsXStepDev;
@property double slopeZStepDev;
@property double averageRadianXYStepDev;
@property double averageRadianXZStepDev;
@property double stddevRadianXYStepDev;
@property double stddevRadianXZStepDev;
@property double averageRadianLpfXYStepDev;
@property double averageRadianLpfXZStepDev;
@property double stddevRadianLpfXYStepDev;
@property double stddevRadianLpfXZStepDev;

@property double averageXStepDeltaAve;
@property double averageZStepDeltaAve;
@property double stddevXStepDeltaAve;
@property double stddevZStepDeltaAve;
@property double averageDeltaYStepDeltaAve;
@property double mountValleyYStepDeltaAve;
@property double averageLpfDeltaYStepDeltaAve;
@property double mountValleyLpfYStepDeltaAve;
@property double averageLpfAbsXStepDeltaAve;
@property double slopeZStepDeltaAve;
@property double averageRadianXYStepDeltaAve;
@property double averageRadianXZStepDeltaAve;
@property double stddevRadianXYStepDeltaAve;
@property double stddevRadianXZStepDeltaAve;
@property double averageRadianLpfXYStepDeltaAve;
@property double averageRadianLpfXZStepDeltaAve;
@property double stddevRadianLpfXYStepDeltaAve;
@property double stddevRadianLpfXZStepDeltaAve;

@property double averageXStepDeltaDev;
@property double averageZStepDeltaDev;
@property double stddevXStepDeltaDev;
@property double stddevZStepDeltaDev;
@property double averageDeltaYStepDeltaDev;
@property double mountValleyYStepDeltaDev;
@property double averageLpfDeltaYStepDeltaDev;
@property double mountValleyLpfYStepDeltaDev;
@property double averageLpfAbsXStepDeltaDev;
@property double slopeZStepDeltaDev;
@property double averageRadianXYStepDeltaDev;
@property double averageRadianXZStepDeltaDev;
@property double stddevRadianXYStepDeltaDev;
@property double stddevRadianXZStepDeltaDev;
@property double averageRadianLpfXYStepDeltaDev;
@property double averageRadianLpfXZStepDeltaDev;
@property double stddevRadianLpfXYStepDeltaDev;
@property double stddevRadianLpfXZStepDeltaDev;

- (id)init;

- (void)initFirLpfArray;

- (BOOL)calibration1;
- (BOOL)calibration2;
-(BOOL)calculationParamArray:(BOOL)calibration
                 gyroEnabled:(BOOL)gyroEnabled;

- (void)calculationParameters;
- (void)calculationStepParameters;

- (int)leastSquares:(int)dimension
              dataX:(double*)dataX
              dataY:(double*)dataY
          dataCount:(long)dataCount
        weightArray:(NSMutableArray*)weightArray
         anserArray:(NSMutableArray**)answerArray;

- (void)accAddObject:(double)ax
                   y:(double)ay
                   z:(double)az;

- (void)gyroAddObject:(double)gx
                    y:(double)gy
                    z:(double)gz;

-(void)resetArray;


@end
