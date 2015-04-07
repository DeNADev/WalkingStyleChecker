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

//  ParamCalculator.m
//  WalkingStyleChecker


#import "ParamCalculator.h"

@implementation ParamCalculator

-(id)init
{
    self = [super init];
    if (self != nil) {
        // キャリブレーション変数の初期化
        calibrationSA = 0.0;
        calibrationCA = 0.0;
        calibrationSB = 0.0;
        calibrationCB = 0.0;
        calibrationSC = 0.0;
        calibrationCC = 0.0;
        
        // ジャイロ配列の初期化
        _gyroArray = [[NSMutableArray alloc] init];
        
        // 配列群の初期化
        _accelerometerArray = [[NSMutableArray alloc] init];
        _accelerometerLpfArray = [[NSMutableArray alloc] init];
        _accelerometerLpfDeltaXArray = [[NSMutableArray alloc] init];
        _radianXYArray = [[NSMutableArray alloc] init];
        _radianXZArray = [[NSMutableArray alloc] init];
        _radianLpfXYArray = [[NSMutableArray alloc] init];
        _radianLpfXZArray = [[NSMutableArray alloc] init];
        [self initFirLpfArray];
        
        
        stepCountArray = [[NSMutableArray alloc] init];
        
        averageXStepArray = [[NSMutableArray alloc] init];
        averageZStepArray = [[NSMutableArray alloc] init];
        stddevXStepArray = [[NSMutableArray alloc] init];
        stddevZStepArray = [[NSMutableArray alloc] init];
        averageDeltaYStepArray = [[NSMutableArray alloc] init];
        mountValleyYStepArray = [[NSMutableArray alloc] init];
        averageLpfDeltaYStepArray = [[NSMutableArray alloc] init];
        mountValleyLpfYStepArray = [[NSMutableArray alloc] init];
        averageLpfAbsXStepArray = [[NSMutableArray alloc] init];
        slopeZStepArray = [[NSMutableArray alloc] init];
        averageRadianXYStepArray = [[NSMutableArray alloc] init];
        averageRadianXZStepArray = [[NSMutableArray alloc] init];
        stddevRadianXYStepArray = [[NSMutableArray alloc] init];
        stddevRadianXZStepArray = [[NSMutableArray alloc] init];
        averageRadianLpfXYStepArray = [[NSMutableArray alloc] init];
        averageRadianLpfXZStepArray = [[NSMutableArray alloc] init];
        stddevRadianLpfXYStepArray = [[NSMutableArray alloc] init];
        stddevRadianLpfXZStepArray = [[NSMutableArray alloc] init];
        
        [self initFirLpfArray];
    }
    return self;
}

- (void)initFirLpfArray
{
    // FIR フィルタ係数係数を設定する。以下設定内容。
    // Sampling freq. 1000Hz
    // Cutoff freq.(Low) 40Hz
    // Window Type. Hamming
    // Gain(通過域). 0
    // Gain(阻止域). -40
    // TAP Number. 97
    firLpfArray = [NSArray arrayWithObjects:@-0.000000197644936151,
                   @-0.000001704540792238,
                   @-0.000004367456448155,
                   @-0.000007450603945173,
                   @-0.000009669794529556,
                   @-0.000009010766136535,
                   @-0.000002618876978447,
                   @0.000013148458872137,
                   @0.000042429646444907,
                   @0.000089282559176277,
                   @0.000156826367410030,
                   @0.000246159563843220,
                   @0.000355168888397540,
                   @0.000477393180162500,
                   @0.000601139942577890,
                   @0.000709063695677200,
                   @0.000778399377958200,
                   @0.000781999547186180,
                   @0.000690252762635420,
                   @0.000473867652465140,
                   @0.000107401247694900,
                   @-0.000426697955375630,
                   @-0.001133859902241900,
                   @-0.002003379564263300,
                   @-0.003005066900527800,
                   @-0.004087008625439500,
                   @-0.005174846118917200,
                   @-0.006172883798569100,
                   @-0.006967210979082800,
                   @-0.007430856912240200,
                   @-0.007430816503099300,
                   @-0.006836599142832300,
                   @-0.005529782592642100,
                   @-0.003413915049127700,
                   @-0.000424016618394510,
                   @0.003465101912836300,
                   @0.008232453068176600,
                   @0.013807070935084000,
                   @0.020067285072725000,
                   @0.026843350615638000,
                   @0.033923469398872000,
                   @0.041062976000091000,
                   @0.047996208187086000,
                   @0.054450355269849000,
                   @0.060160400343986000,
                   @0.064884159736253000,
                   @0.068416386224230000,
                   @0.070600946544632000,
                   @0.081340206185567000,
                   @0.070600946544632000,
                   @0.068416386224230000,
                   @0.064884159736253000,
                   @0.060160400343986000,
                   @0.054450355269849000,
                   @0.047996208187086000,
                   @0.041062976000091000,
                   @0.033923469398872000,
                   @0.026843350615638000,
                   @0.020067285072725000,
                   @0.013807070935084000,
                   @0.008232453068176600,
                   @0.003465101912836300,
                   @-0.000424016618394510,
                   @-0.003413915049127700,
                   @-0.005529782592642100,
                   @-0.006836599142832300,
                   @-0.007430816503099300,
                   @-0.007430856912240200,
                   @-0.006967210979082800,
                   @-0.006172883798569100,
                   @-0.005174846118917200,
                   @-0.004087008625439500,
                   @-0.003005066900527800,
                   @-0.002003379564263300,
                   @-0.001133859902241900,
                   @-0.000426697955375630,
                   @0.000107401247694900,
                   @0.000473867652465140,
                   @0.000690252762635430,
                   @0.000781999547186180,
                   @0.000778399377958200,
                   @0.000709063695677200,
                   @0.000601139942577890,
                   @0.000477393180162500,
                   @0.000355168888397540,
                   @0.000246159563843220,
                   @0.000156826367410030,
                   @0.000089282559176277,
                   @0.000042429646444907,
                   @0.000013148458872137,
                   @-0.000002618876978447,
                   @-0.000009010766136535,
                   @-0.000009669794529556,
                   @-0.000007450603945173,
                   @-0.000004367456448155,
                   @-0.000001704540792238,
                   @-0.000000197644936151,
                   nil];
}


-(void)accAddObject:(double)ax y:(double)ay z:(double)az
{
    [_accelerometerArray addObject:[[XYZObject alloc] initWithName:ax y:ay z:az]];
}

-(void)gyroAddObject:(double)gx y:(double)gy z:(double)gz
{
    [_gyroArray addObject:[[XYZObject alloc] initWithName:gx y:gy z:gz]];
}

-(void)resetArray
{
    [_accelerometerArray removeAllObjects];
    [_accelerometerLpfArray removeAllObjects];
    [_radianXYArray removeAllObjects];
    [_radianXZArray removeAllObjects];
    [_gyroArray removeAllObjects];
    
    _accArrayCount = 0;
}


// 現在までに記録された accelerometerArray を元にキャリブレーションを行います
-(BOOL)calibration1
{
    // x, y, z の順でソート
    NSSortDescriptor *xSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self.x" ascending:YES];
    NSSortDescriptor *ySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self.y" ascending:YES];
    NSSortDescriptor *zSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self.z" ascending:YES];
    NSMutableArray* accelerometerTempArray = (NSMutableArray*)[_accelerometerArray sortedArrayUsingDescriptors:@[xSortDescriptor, ySortDescriptor, zSortDescriptor]];
    
    // 総数の 1/5 のみ計算対象にします。ちょうど中間点のデータのみ使用するためです。
    long count = [accelerometerTempArray count] / 5;
    
    NSMutableArray* accBuffer = [[NSMutableArray alloc] init];
    [accBuffer removeAllObjects];
    
    // 1/5 分の配列を作成します。
    for(long i = count * 2; i < count * 3; i++)
    {
        [accBuffer addObject:[accelerometerTempArray objectAtIndex:i]];
    }
    
    // 合計
    double aveX = 0.0;
    double aveY = 0.0;
    double aveZ = 0.0;
    for(long i = 0; i < [accBuffer count]; i++)
    {
        aveX += [[accBuffer objectAtIndex:i] x];
        aveY += [[accBuffer objectAtIndex:i] y];
        aveZ += [[accBuffer objectAtIndex:i] z];
        NSLog(@"%lf, %lf, %lf", [[accBuffer objectAtIndex:i] x], [[accBuffer objectAtIndex:i] y], [[accBuffer objectAtIndex:i] z]);
    }
    
    // 平均
    aveX /= [accBuffer count];
    aveY /= [accBuffer count];
    aveZ /= [accBuffer count];
    
    // x, y の z 面に対する回転角度（ラジアン）
    double alpha = 0.0;
    if(aveX > 0)
    {
        alpha = -1.0 * atan(aveY / aveX) - M_PI_2;
    }
    else
    {
        alpha = -1.0 * atan(aveY / aveX) + M_PI_2;
    }
    // キャリブレーション変数
    calibrationSA = sin(alpha);
    calibrationCA = cos(alpha);
    
    // alpha を用いて beta を出すために bufX と bufY を求める。
    double bufX = 0.0;
    double bufY = 0.0;
    bufX = aveX * calibrationCA - aveY * calibrationSA;
    bufY = aveX * calibrationSA + aveY * calibrationCA;
    
    NSLog(@"Y: %lf", bufY);
    
    // z, y の x 面に対する回転角度（ラジアン）
    double beta = 0.0;
    if(aveZ > 0)
    {
        beta = -1.0 * atan(bufY / aveZ) - M_PI_2;
    }
    else
    {
        beta = -1.0 * atan(bufY / aveZ) + M_PI_2;
    }
    // キャリブレーション変数
    calibrationSB = sin(beta);
    calibrationCB = cos(beta);
    
    NSLog(@" SA: %lf CA: %lf SB: %lf CB: %lf", calibrationSA, calibrationCA, calibrationSB, calibrationCB);
    
#ifdef DEBUG
    NSLog(@"X: %lf, Y: %lf, Z: %lf", bufX, aveZ * calibrationSB + bufY * calibrationCB, aveZ * calibrationCB - bufY * calibrationSB);
#endif
    
    if(calibrationSA == 0.0 && calibrationSB == 0.0 && calibrationCA == 0.0 && calibrationCB == 0.0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
}

-(BOOL)calibration2
{
    NSMutableArray* accelerometerTemp1Array = [[NSMutableArray alloc] init];
    
    // 絶対値に置き換え。y いらないな。
    for(long i = 0; i < [_accelerometerArray count]; i++)
    {
        double x = [[_accelerometerArray objectAtIndex:i] x];
        double y = [[_accelerometerArray objectAtIndex:i] y];
        double z = [[_accelerometerArray objectAtIndex:i] z];
        x = x * calibrationCA - y * calibrationSA;
        y = z * calibrationSB + (x * calibrationSA + y * calibrationCA) * calibrationCB;
        z = z * calibrationCB - (x * calibrationSA + y * calibrationCA) * calibrationSB;
        double ax = fabs(x);
        double ay = 0.0; // fabs([[accelerometerArray objectAtIndex:i] y]);
        double az = fabs(z);
        [accelerometerTemp1Array addObject:[[XYZObject alloc] initWithName:ax
                                                                         y:ay
                                                                         z:az
                                                                      orgX:x
                                                                      orgY:y
                                                                      orgZ:z]
         ];
    }
    
    // x と z でソート。降順。
    NSSortDescriptor *xSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self.x" ascending:NO];
    NSSortDescriptor *zSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self.z" ascending:NO];
    NSMutableArray* accelerometerTemp2Array = (NSMutableArray*)[accelerometerTemp1Array sortedArrayUsingDescriptors:@[xSortDescriptor, zSortDescriptor]];
    
    if([accelerometerTemp2Array count] < 10)
    {
        return NO;
    }
    // 最初から 10 個の x と z の平均。絶対値じゃない方。
    double aveX = 0.0;
    double aveZ = 0.0;
    for(long i = 0; i < 10; i++)
    {
        double ax = [[accelerometerTemp2Array objectAtIndex:i] orgX];
        double az = [[accelerometerTemp2Array objectAtIndex:i] orgZ];
        aveX += ax;
        aveZ += az;
    }
    aveX /= 10.0;
    aveZ /= 10.0;
    
    NSLog(@"aveX = %lf, aveZ = %lf", aveX, aveZ);
    
    // y に対する x, z 面の回転角度（ラジアン）
    double gamma = 0.0;
    if(aveX > 0)
    {
        gamma = -1.0 * atan(aveZ / aveX) - M_PI_2;
    }
    else
    {
        gamma = -1.0 * atan(aveZ / aveX) + M_PI_2;
    }
    
    // キャリブレーション変数
    calibrationSC = sin(gamma);
    calibrationCC = cos(gamma);
    
    NSLog(@" SA: %lf CA: %lf SB: %lf CB: %lf SC: %lf CC: %lf", calibrationSA, calibrationCA, calibrationSB, calibrationCB, calibrationSC, calibrationCC);
    
#ifdef DEBUG
    NSLog(@"X: %lf, Z: %lf", aveX * calibrationCC - aveZ * calibrationSC, aveX * calibrationSC + aveZ * calibrationCC);
#endif
    return YES;
}


-(BOOL)calculationParamArray:(BOOL)calibration
                 gyroEnabled:(BOOL)gyroEnabled
{
    // カウントを入れる
    if(gyroEnabled)
    {
        _accArrayCount = [_accelerometerArray count]<[_gyroArray count]?[_accelerometerArray count]:[_gyroArray count];
    }else{
        _accArrayCount = [_accelerometerArray count];
    }
    
    if(_accArrayCount < 300)
    {
        return NO;
    }
    
    if(calibration)
    {
        // まずはキャリブレーションデータを適用
        for(long i = 0; i < _accArrayCount; i++)
        {
            double x = [[_accelerometerArray objectAtIndex:i] x];
            double y = [[_accelerometerArray objectAtIndex:i] y];
            double z = [[_accelerometerArray objectAtIndex:i] z];
            double bufX = 0.0;
            double bufY = 0.0;
            double bufZ = 0.0;
            if(calibrationSA == 0.0 && calibrationCA == 0.0 && calibrationSB == 0.0 && calibrationCB == 0.0)
            {
            }
            else
            {
                bufX = (x * calibrationCA - y * calibrationSA) * calibrationCC - (z * calibrationCB - (x * calibrationSA + y * calibrationCA) * calibrationSB) * calibrationSC;
                bufY = z * calibrationSB + (x * calibrationSA + y * calibrationCA) * calibrationCB;
                bufZ = (x * calibrationCA - y * calibrationSA) * calibrationSC + (z * calibrationCB - (x * calibrationSA + y * calibrationCA) * calibrationSB) * calibrationCC;
                
                [_accelerometerArray replaceObjectAtIndex:i withObject:[[XYZObject alloc] initWithName:bufX y:bufY z:bufZ]];
                
            }
        }
    }
    
    // 角度の記録
    for(long i = 0; i < _accArrayCount; i++)
    {
        double x = [[_accelerometerArray objectAtIndex:i] x];
        double y = [[_accelerometerArray objectAtIndex:i] y];
        double z = [[_accelerometerArray objectAtIndex:i] z];
        double radianXY = acos(x / sqrt(pow(x, 2.0) + pow(y, 2.0)));
        double radianXZ = acos(x / sqrt(pow(x, 2.0) + pow(z, 2.0)));
        
        [_radianXYArray addObject:[[NSNumber alloc] initWithDouble:radianXY]];
        [_radianXZArray addObject:[[NSNumber alloc] initWithDouble:radianXZ]];
    }
    
    // Low Pass Filter をかける
    for(long i = 0; i < _accArrayCount - [firLpfArray count]; i++)
    {
        double x = 0.0;
        double y = 0.0;
        double z = 0.0;
        
        double radianXY = 0.0;
        double radianXZ = 0.0;
        
        for(long j = 0; j < [firLpfArray count]; j++)
        {
            // 加速度センサの xyz
            x += [[firLpfArray objectAtIndex:j] doubleValue] * [[_accelerometerArray objectAtIndex:i+j] x];
            y += [[firLpfArray objectAtIndex:j] doubleValue] * [[_accelerometerArray objectAtIndex:i+j] y];
            z += [[firLpfArray objectAtIndex:j] doubleValue] * [[_accelerometerArray objectAtIndex:i+j] z];
            
            // 角度
            radianXY += [[firLpfArray objectAtIndex:j] doubleValue] * [[_radianXYArray objectAtIndex:i+j] doubleValue];
            radianXZ += [[firLpfArray objectAtIndex:j] doubleValue] * [[_radianXZArray objectAtIndex:i+j] doubleValue];
        }
        [_accelerometerLpfArray addObject:[[XYZObject alloc] initWithName:x y:y z:z]];
        [_radianLpfXYArray addObject:[[NSNumber alloc] initWithDouble: radianXY]];
        [_radianLpfXZArray addObject:[[NSNumber alloc] initWithDouble: radianXZ]];
    }
    
    // パラメータの計算
    [self initParameter];
    [self calculationParameters];
    [self calculationStepParameters];
    
    return YES;
}

-(void)initParameter
{
    _averageX = 0.0;
    _averageZ = 0.0;
    _stddevX = 0.0;
    _stddevZ = 0.0;
    _averageLpfDeltaY = 0.0;
    _mountValleyY = 0.0;
    _averageLpfAbsX = 0.0;
    _slopeZ = 0.0;
    _averageRadianXY = 0.0;
    _averageRadianXZ = 0.0;
    _stddevRadianXY = 0.0;
    _stddevRadianXZ = 0.0;
    _averageRadianLpfXY = 0.0;
    _averageRadianLpfXZ = 0.0;
    _stddevRadianLpfXY = 0.0;
    _stddevRadianLpfXZ = 0.0;
    
    _stepValleyCount = 0;
    
    _averageXStep = 0.0;
    _averageZStep = 0.0;
    _stddevXStep = 0.0;
    _stddevZStep = 0.0;
    _averageDeltaYStep = 0.0;
    _mountValleyYStep = 0.0;
    _averageLpfDeltaYStep = 0.0;
    _mountValleyLpfYStep = 0.0;
    _averageLpfAbsXStep = 0.0;
    _slopeZStep = 0.0;
    _averageRadianXYStep = 0.0;
    _averageRadianXZStep = 0.0;
    _stddevRadianXYStep = 0.0;
    _stddevRadianXZStep = 0.0;
    _averageRadianLpfXYStep = 0.0;
    _averageRadianLpfXZStep = 0.0;
    _stddevRadianLpfXYStep = 0.0;
    _stddevRadianLpfXZStep = 0.0;
    
    _averageXStepAve = 0.0;
    _averageZStepAve = 0.0;
    _stddevXStepAve = 0.0;
    _stddevZStepAve = 0.0;
    _averageDeltaYStepAve = 0.0;
    _mountValleyYStepAve = 0.0;
    _averageLpfDeltaYStepAve = 0.0;
    _mountValleyLpfYStepAve = 0.0;
    _averageLpfAbsXStepAve = 0.0;
    _slopeZStepAve = 0.0;
    _averageRadianXYStepAve = 0.0;
    _averageRadianXZStepAve = 0.0;
    _stddevRadianXYStepAve = 0.0;
    _stddevRadianXZStepAve = 0.0;
    _averageRadianLpfXYStepAve = 0.0;
    _averageRadianLpfXZStepAve = 0.0;
    _stddevRadianLpfXYStepAve = 0.0;
    _stddevRadianLpfXZStepAve = 0.0;
    
    _averageXStepDev = 0.0;
    _averageZStepDev = 0.0;
    _stddevXStepDev = 0.0;
    _stddevZStepDev = 0.0;
    _averageDeltaYStepDev = 0.0;
    _mountValleyYStepDev = 0.0;
    _averageLpfDeltaYStepDev = 0.0;
    _mountValleyLpfYStepDev = 0.0;
    _averageLpfAbsXStepDev = 0.0;
    _slopeZStepDev = 0.0;
    _averageRadianXYStepDev = 0.0;
    _averageRadianXZStepDev = 0.0;
    _stddevRadianXYStepDev = 0.0;
    _stddevRadianXZStepDev = 0.0;
    _averageRadianLpfXYStepDev = 0.0;
    _averageRadianLpfXZStepDev = 0.0;
    _stddevRadianLpfXYStepDev = 0.0;
    _stddevRadianLpfXZStepDev = 0.0;
    
    _averageXStepDeltaAve = 0.0;
    _averageZStepDeltaAve = 0.0;
    _stddevXStepDeltaAve = 0.0;
    _stddevZStepDeltaAve = 0.0;
    _averageDeltaYStepDeltaAve = 0.0;
    _mountValleyYStepDeltaAve = 0.0;
    _averageLpfDeltaYStepDeltaAve = 0.0;
    _mountValleyLpfYStepDeltaAve = 0.0;
    _averageLpfAbsXStepDeltaAve = 0.0;
    _slopeZStepDeltaAve = 0.0;
    _averageRadianXYStepDeltaAve = 0.0;
    _averageRadianXZStepDeltaAve = 0.0;
    _stddevRadianXYStepDeltaAve = 0.0;
    _stddevRadianXZStepDeltaAve = 0.0;
    _averageRadianLpfXYStepDeltaAve = 0.0;
    _averageRadianLpfXZStepDeltaAve = 0.0;
    _stddevRadianLpfXYStepDeltaAve = 0.0;
    _stddevRadianLpfXZStepDeltaAve = 0.0;
    
    _averageXStepDeltaDev = 0.0;
    _averageZStepDeltaDev = 0.0;
    _stddevXStepDeltaDev = 0.0;
    _stddevZStepDeltaDev = 0.0;
    _averageDeltaYStepDeltaDev = 0.0;
    _mountValleyYStepDeltaDev = 0.0;
    _averageLpfDeltaYStepDeltaDev = 0.0;
    _mountValleyLpfYStepDeltaDev = 0.0;
    _averageLpfAbsXStepDeltaDev = 0.0;
    _slopeZStepDeltaDev = 0.0;
    _averageRadianXYStepDeltaDev = 0.0;
    _averageRadianXZStepDeltaDev = 0.0;
    _stddevRadianXYStepDeltaDev = 0.0;
    _stddevRadianXZStepDeltaDev = 0.0;
    _averageRadianLpfXYStepDeltaDev = 0.0;
    _averageRadianLpfXZStepDeltaDev = 0.0;
    _stddevRadianLpfXYStepDeltaDev = 0.0;
    _stddevRadianLpfXZStepDeltaDev = 0.0;
}

// パラメータ計算
- (void)calculationParameters
{
    // 平均値算出
    _averageX = 0.0;
    _averageZ = 0.0;
    _averageRadianXY = 0.0;
    _averageRadianXZ = 0.0;
    for(long i = 0; i < _accArrayCount; i++)
    {
        _averageX += [[_accelerometerArray objectAtIndex:i] x];
        _averageZ += [[_accelerometerArray objectAtIndex:i] z];
        _averageRadianXY += [[_radianXYArray objectAtIndex:i] doubleValue];
        _averageRadianXZ += [[_radianXZArray objectAtIndex:i] doubleValue];
    }
    _averageX /= (double)_accArrayCount;
    _averageZ /= (double)_accArrayCount;
    
    _averageRadianXY /= (double)_accArrayCount;
    _averageRadianXZ /= (double)_accArrayCount;
    
    // 標準偏差算出
    _stddevX = 0.0;
    _stddevZ = 0.0;
    _stddevRadianXY = 0.0;
    _stddevRadianXZ = 0.0;
    for(long i = 0; i < _accArrayCount; i++)
    {
        _stddevX += pow([[_accelerometerArray objectAtIndex:i] x] - _averageX, 2);
        _stddevZ += pow([[_accelerometerArray objectAtIndex:i] z] - _averageZ, 2);
        _stddevRadianXY += pow([[_radianXYArray objectAtIndex:i] doubleValue] - _averageRadianXY, 2);
        _stddevRadianXZ += pow([[_radianXZArray objectAtIndex:i] doubleValue] - _averageRadianXZ, 2);
    }
    _stddevX = sqrt(_stddevX / _accArrayCount);
    _stddevZ = sqrt(_stddevZ / _accArrayCount);
    _stddevRadianXY = sqrt(_stddevRadianXY / _accArrayCount);
    _stddevRadianXZ = sqrt(_stddevRadianXZ / _accArrayCount);
    
    _mountValleyY = 0;
    double delta1 = 0.0;
    double delta2 = 0.0;
    int mountY = 0;
    int valleyY = 0;
    _averageLpfDeltaY = 0.0;
    long count = 0;
    _averageLpfAbsX = 0.0;
    [_accelerometerLpfDeltaXArray removeAllObjects];
    
    // 一旦平均値を算出
    double aveAbsY = 0.0;
    for(long i = 0; i < [_accelerometerLpfArray count]; i++)
    {
        aveAbsY += fabs([[_accelerometerLpfArray objectAtIndex:i] y] + 1.0);
        
    }
    aveAbsY /= [_accelerometerLpfArray count];
    
    _averageRadianLpfXY = 0.0;
    _averageRadianLpfXZ = 0.0;
    // 山谷算出 ＆ X軸のLPF後の絶対値平均値算出 & X軸の⊿の値の取得（ベスト10の平均算出のため）
    bool startFlag = NO;
    for(long i = 0; i < [_accelerometerLpfArray count] - 2; i++)
    {
        // 値 + 1.0 の絶対値が平均を超えたら計測を開始する。※歩き始めと定義
        if(startFlag == NO){
            if(fabs([[_accelerometerLpfArray objectAtIndex:i] y] + 1.0) < aveAbsY){
                continue;
            }else{
                startFlag = YES;
                count = i;
            }
        }
        // 手前の ⊿
        delta1 = [[_accelerometerLpfArray objectAtIndex:i+1] y] - [[_accelerometerLpfArray objectAtIndex:i] y];
        // 奥の ⊿
        delta2 = [[_accelerometerLpfArray objectAtIndex:i+2] y] - [[_accelerometerLpfArray objectAtIndex:i+1] y];
        // ⊿ の合計
        _averageLpfDeltaY += delta1;
        // ローパス後の X の絶対値合計
        _averageLpfAbsX += fabs([[_accelerometerLpfArray objectAtIndex:i] x]);
        // ローパス後の radianXY の合計
        _averageRadianLpfXY += [[_radianLpfXYArray objectAtIndex:i] doubleValue];
        // ローパス後の radianXZ の合計
        _averageRadianLpfXZ += [[_radianLpfXZArray objectAtIndex:i] doubleValue];
        
        if(delta1 > 0.0 && delta2 < 0.0)
        {
            mountY++;
        }
        if(delta1 < 0.0 && delta2 > 0.0)
        {
            valleyY++;
        }
    }
    
    NSLog(@"countStart:%ld", count);
    if([_accelerometerLpfArray count] - count - 2 > 0)
    {
        // ⊿ 平均
        _averageLpfDeltaY /= (double)([_accelerometerLpfArray count] - count);
        // mount と valley の合計
        _mountValleyY = (mountY + valleyY) / (double)([_accelerometerLpfArray count] - count);
        // ローパスフィルタ後の X の値の絶対値平均
        _averageLpfAbsX /= (double)([_accelerometerLpfArray count] - count);
        // ローパスフィルタ後の radianXY の平均
        _averageRadianLpfXY /= (double)([_radianLpfXYArray count] - count);
        // ローパスフィルタ後の radianXZ の平均
        _averageRadianLpfXZ /= (double)([_radianLpfXZArray count] - count);
    }
    
    // radian 標準偏差算出
    for(long i = count; i < [_radianLpfXYArray count] - 2; i++)
    {
        _stddevRadianLpfXY += pow([[_radianLpfXYArray objectAtIndex:i] doubleValue] - _averageRadianLpfXY, 2);
        _stddevRadianLpfXZ += pow([[_radianLpfXZArray objectAtIndex:i] doubleValue] - _averageRadianLpfXZ, 2);
    }
    if([_radianLpfXYArray count] - count - 2 > 0)
    {
        _stddevRadianLpfXY = sqrt(_stddevRadianLpfXY / [_radianLpfXYArray count]);
        _stddevRadianLpfXZ = sqrt(_stddevRadianLpfXZ / [_radianLpfXZArray count]);
    }
    
    // 回帰直線の準備
    NSMutableArray* weightArray = [[NSMutableArray alloc] init];
    NSMutableArray* answerArray = [[NSMutableArray alloc] init];
    // 重み配列の設定。重みなし。
    for(long i = count; i < [_accelerometerLpfArray count]; i++)
    {
        [weightArray addObject: [[NSNumber alloc] initWithDouble:10.0]];
    }
    // 1 次元なので答えは 2 個。y = ax + b
    [answerArray addObject:[[NSNumber alloc] initWithDouble:0.0]];
    [answerArray addObject:[[NSNumber alloc] initWithDouble:0.0]];
    // 最小二乗法関数が C 言語でできているため、計算する配列を double 配列で用意する
    double dataX[[_accelerometerLpfArray count]];
    double dataZ[[_accelerometerLpfArray count]];
    for(long i = count; i < [_accelerometerLpfArray count]; i++)
    {
        long temp = i - count;
        dataX[temp] = (double)temp;
        dataZ[temp] = [[_accelerometerLpfArray objectAtIndex:i] z];
    }
    // 最小二乗法を実行する
    [self leastSquares:1
                 dataX:dataX
                 dataY:dataZ
             dataCount:[_accelerometerLpfArray count] - count
           weightArray:weightArray
            anserArray:&answerArray];
    NSLog(@"Answer:%@", [answerArray description]);
    
    // 傾きだけ記録
    _slopeZ = [[answerArray objectAtIndex:1] doubleValue];
    NSLog(@"\naverageX = %lf,\naverageZ = %lf,\nstddevX = %lf,\nstddevZ = %lf,\naverageLpfDeltaY = %lf,\nmountValleyY = %lf,\nslopeZ = %lf,\nstddevRadianXY = %lf,\nstddevRadianXZ = %lf,\nstddevRadianLpfXY = %lf,\nstddevRadianLpfXZ = %lf\n",
          _averageX,
          _averageZ,
          _stddevX,
          _stddevZ,
          _averageLpfDeltaY,
          _mountValleyY,
          _slopeZ,
          _stddevRadianXY,
          _stddevRadianXZ,
          _stddevRadianLpfXY,
          _stddevRadianLpfXZ);
    
}

// パラメータ計算
- (void)calculationStepParameters
{
    [stepCountArray removeAllObjects];
    
    [averageXStepArray removeAllObjects];
    [averageZStepArray removeAllObjects];
    [stddevXStepArray removeAllObjects];
    [stddevZStepArray removeAllObjects];
    [averageDeltaYStepArray removeAllObjects];
    [mountValleyYStepArray removeAllObjects];
    [averageLpfDeltaYStepArray removeAllObjects];
    [mountValleyLpfYStepArray removeAllObjects];
    [averageLpfAbsXStepArray removeAllObjects];
    [slopeZStepArray removeAllObjects];
    [averageRadianXYStepArray removeAllObjects];
    [averageRadianXZStepArray removeAllObjects];
    [stddevRadianXYStepArray removeAllObjects];
    [stddevRadianXZStepArray removeAllObjects];
    [averageRadianLpfXYStepArray removeAllObjects];
    [averageRadianLpfXZStepArray removeAllObjects];
    [stddevRadianLpfXYStepArray removeAllObjects];
    [stddevRadianLpfXZStepArray removeAllObjects];
    
    _stepValleyCount = 0;
    
    // ステップごとの平均値
    _averageXStepAve = 0.0;
    _averageZStepAve = 0.0;
    _stddevXStepAve = 0.0;
    _stddevZStepAve = 0.0;
    _averageDeltaYStepAve = 0.0;
    _mountValleyYStepAve = 0.0;
    _averageLpfDeltaYStepAve = 0.0;
    _mountValleyLpfYStepAve = 0.0;
    _averageLpfAbsXStepAve = 0.0;
    _slopeZStepAve = 0.0;
    _averageRadianXYStepAve = 0.0;
    _averageRadianXZStepAve = 0.0;
    _stddevRadianXYStepAve = 0.0;
    _stddevRadianXZStepAve = 0.0;
    _averageRadianLpfXYStepAve = 0.0;
    _averageRadianLpfXZStepAve = 0.0;
    _stddevRadianLpfXYStepAve = 0.0;
    _stddevRadianLpfXZStepAve = 0.0;
    
    // ステップごとの標準偏差
    _averageXStepDev = 0.0;
    _averageZStepDev = 0.0;
    _stddevXStepDev = 0.0;
    _stddevZStepDev = 0.0;
    _averageDeltaYStepDev = 0.0;
    _mountValleyYStepDev = 0.0;
    _averageLpfDeltaYStepDev = 0.0;
    _mountValleyLpfYStepDev = 0.0;
    _averageLpfAbsXStepDev = 0.0;
    _slopeZStepDev = 0.0;
    _averageRadianXYStepDev = 0.0;
    _averageRadianXZStepDev = 0.0;
    _stddevRadianXYStepDev = 0.0;
    _stddevRadianXZStepDev = 0.0;
    _averageRadianLpfXYStepDev = 0.0;
    _averageRadianLpfXZStepDev = 0.0;
    _stddevRadianLpfXYStepDev = 0.0;
    _stddevRadianLpfXZStepDev = 0.0;
    
    // まずはローパスフィルタ後の Y 軸に回帰直線（なるべく正確なステップ数の算出のため）
    // 回帰直線の準備
    NSMutableArray* weightArray = [[NSMutableArray alloc] init];
    NSMutableArray* answerArray = [[NSMutableArray alloc] init];
    // 重み配列の設定。重みなし。
    for(long i = 0; i < [_accelerometerLpfArray count]; i++)
    {
        [weightArray addObject: [[NSNumber alloc] initWithDouble:10.0]];
    }
    // 1 次元なので答えは 2 個。y = ax + b
    [answerArray addObject:[[NSNumber alloc] initWithDouble:0.0]];
    [answerArray addObject:[[NSNumber alloc] initWithDouble:0.0]];
    // C 言語でできているため、計算する配列を double 配列で用意する
    double dataX[[_accelerometerLpfArray count]];
    double dataY[[_accelerometerLpfArray count]];
    for(long i = 0; i < [_accelerometerLpfArray count]; i++)
    {
        dataX[i] = i;
        dataY[i] = [[_accelerometerLpfArray objectAtIndex:i] y];
    }
    // 最小二乗法を実行する
    [self leastSquares:1
                 dataX:dataX
                 dataY:dataY
             dataCount:[_accelerometerLpfArray count]
           weightArray:weightArray
            anserArray:&answerArray];
    NSLog(@"Answer:%@", [answerArray description]);
    
    // 係数に -0.05 する
    double adjust = [[answerArray objectAtIndex:0] doubleValue] - 0.06;
    
    // ステップの検出（谷のポイントを記録）
    for(long i = 0; i < _accArrayCount - [firLpfArray count] - 2; i++)
    {
        if([[answerArray objectAtIndex:1] doubleValue] * (double)i + adjust > [[_accelerometerLpfArray objectAtIndex:i] y])
        {
            // 手前の ⊿
            double delta1 = [[_accelerometerLpfArray objectAtIndex:i+1] y] - [[_accelerometerLpfArray objectAtIndex:i] y];
            // 奥の ⊿
            double delta2 = [[_accelerometerLpfArray objectAtIndex:i+2] y] - [[_accelerometerLpfArray objectAtIndex:i+1] y];
            
            if(delta1 < 0.0 && delta2 > 0.0)
            {
                [stepCountArray addObject:[[NSNumber alloc] initWithLong:i+1]];
            }
        }
    }
    
    _stepValleyCount = [stepCountArray count];
    
    for(long index = 0; index < [stepCountArray count]-1; index++)
    {
        // 平均値算出
        _averageXStep = 0.0;
        _averageZStep = 0.0;
        _averageRadianXYStep = 0.0;
        _averageRadianXZStep = 0.0;
        long count = 0;
        for(long i = [[stepCountArray objectAtIndex:index] intValue] + [firLpfArray count]/2; i < [[stepCountArray objectAtIndex:index+1] intValue] + [firLpfArray count]/2; i++)
        {
            _averageXStep += [[_accelerometerArray objectAtIndex:i] x];
            _averageZStep += [[_accelerometerArray objectAtIndex:i] z];
            _averageRadianXYStep += [[_radianXYArray objectAtIndex:i] doubleValue];
            _averageRadianXZStep += [[_radianXZArray objectAtIndex:i] doubleValue];
            count++;
        }
        _averageXStep /= (double)count;
        _averageZStep /= (double)count;
        _averageRadianXYStep /= (double)count;
        _averageRadianXZStep /= (double)count;
        [averageXStepArray addObject:[[NSNumber alloc] initWithDouble:_averageXStep]];
        [averageZStepArray addObject:[[NSNumber alloc] initWithDouble:_averageZStep]];
        [averageRadianXYStepArray addObject:[[NSNumber alloc] initWithDouble:_averageRadianXYStep]];
        [averageRadianXZStepArray addObject:[[NSNumber alloc] initWithDouble:_averageRadianXZStep]];
        
        // 標準偏差算出
        _stddevXStep = 0.0;
        _stddevZStep = 0.0;
        _stddevRadianXYStep = 0.0;
        _stddevRadianXZStep = 0.0;
        count = 0;
        for(long i = [[stepCountArray objectAtIndex:index] intValue] + [firLpfArray count]/2; i < [[stepCountArray objectAtIndex:index+1] intValue] + [firLpfArray count]/2; i++)
        {
            _stddevXStep += pow([[_accelerometerArray objectAtIndex:i] x] - _averageX, 2);
            _stddevZStep += pow([[_accelerometerArray objectAtIndex:i] z] - _averageZ, 2);
            _stddevRadianXYStep += pow([[_radianXYArray objectAtIndex:i] doubleValue] - _averageRadianXY, 2);
            _stddevRadianXZStep += pow([[_radianXZArray objectAtIndex:i] doubleValue] - _averageRadianXZ, 2);
            count++;
        }
        _stddevXStep = sqrt(_stddevXStep / (double)count);
        _stddevZStep = sqrt(_stddevZStep / (double)count);
        _stddevRadianXYStep = sqrt(_stddevRadianXYStep / (double)count);
        _stddevRadianXZStep = sqrt(_stddevRadianXZStep / (double)count);
        [stddevXStepArray addObject:[[NSNumber alloc] initWithDouble:_stddevXStep]];
        [stddevZStepArray addObject:[[NSNumber alloc] initWithDouble:_stddevZStep]];
        [stddevRadianXYStepArray addObject:[[NSNumber alloc] initWithDouble:_stddevRadianXYStep]];
        [stddevRadianXZStepArray addObject:[[NSNumber alloc] initWithDouble:_stddevRadianXZStep]];
        
        int mountY = 0;
        int valleyY = 0;
        for(long i = [[stepCountArray objectAtIndex:index] intValue] + [firLpfArray count]/2; i < [[stepCountArray objectAtIndex:index+1] intValue] + [firLpfArray count]/2 - 2; i++)
        {
            // 手前の ⊿
            double delta1 = [[_accelerometerArray objectAtIndex:i+1] y] - [[_accelerometerArray objectAtIndex:i] y];
            // 奥の ⊿
            double delta2 = [[_accelerometerArray objectAtIndex:i+2] y] - [[_accelerometerArray objectAtIndex:i+1] y];
            // ⊿ の合計
            _averageDeltaYStep += delta1;
            if(delta1 > 0.0 && delta2 < 0.0)
            {
                mountY++;
            }
            if(delta1 < 0.0 && delta2 > 0.0)
            {
                valleyY++;
            }
            count++;
        }
        if(count - 2 > 0)
        {
            // ⊿ 平均
            _averageDeltaYStep /= (double)count;
            // mount と valley の合計
            _mountValleyYStep = (double)(mountY + valleyY) / (double)count;
        }
        [averageDeltaYStepArray addObject:[[NSNumber alloc] initWithDouble:_averageDeltaYStep]];
        [mountValleyYStepArray addObject:[[NSNumber alloc] initWithDouble:_mountValleyYStep]];
        
        mountY = 0;
        valleyY = 0;
        count = 0;
        // 山谷算出 ＆ X軸のLPF後の絶対値平均値算出 & X軸の⊿の値の取得（ベスト10の平均算出のため）
        for(long i = [[stepCountArray objectAtIndex:index] intValue]; i < [[stepCountArray objectAtIndex:index+1] intValue] - 2; i++)
        {
            // 手前の ⊿
            double delta1 = [[_accelerometerLpfArray objectAtIndex:i+1] y] - [[_accelerometerLpfArray objectAtIndex:i] y];
            // 奥の ⊿
            double delta2 = [[_accelerometerLpfArray objectAtIndex:i+2] y] - [[_accelerometerLpfArray objectAtIndex:i+1] y];
            // ⊿ の合計
            _averageLpfDeltaYStep += delta1;
            // ローパス後の X の絶対値合計
            _averageLpfAbsXStep += fabs([[_accelerometerLpfArray objectAtIndex:i] x]);
            // ローパス後の radianXY の合計
            _averageRadianLpfXYStep += [[_radianLpfXYArray objectAtIndex:i] doubleValue];
            // ローパス後の radianXZ の合計
            _averageRadianLpfXZStep += [[_radianLpfXZArray objectAtIndex:i] doubleValue];
            
            if(delta1 > 0.0 && delta2 < 0.0)
            {
                mountY++;
            }
            if(delta1 < 0.0 && delta2 > 0.0)
            {
                valleyY++;
            }
            count++;
        }
        if(count - 2 > 0)
        {
            // ⊿ 平均
            _averageLpfDeltaYStep /= (double)count;
            // mount と valley の合計
            _mountValleyLpfYStep = (double)(mountY + valleyY) / (double)count;
            // ローパスフィルタ後の X の値の絶対値平均
            _averageLpfAbsXStep /= (double)count;
            // ローパスフィルタ後の radianXY の平均
            _averageRadianLpfXYStep /= (double)count;
            // ローパスフィルタ後の radianXZ の平均
            _averageRadianLpfXZStep /= (double)count;
        }
        [averageLpfDeltaYStepArray addObject:[[NSNumber alloc] initWithDouble:_averageLpfDeltaYStep]];
        [mountValleyLpfYStepArray addObject:[[NSNumber alloc] initWithDouble:_mountValleyLpfYStep]];
        [averageLpfAbsXStepArray addObject:[[NSNumber alloc] initWithDouble:_averageLpfAbsXStep]];
        [averageRadianLpfXYStepArray addObject:[[NSNumber alloc] initWithDouble:_averageRadianLpfXYStep]];
        [averageRadianLpfXZStepArray addObject:[[NSNumber alloc] initWithDouble:_averageRadianLpfXZStep]];
        
        // radian 標準偏差算出
        count = 0;
        for(long i = [[stepCountArray objectAtIndex:index] intValue]; i < [[stepCountArray objectAtIndex:index+1] intValue]; i++)
        {
            _stddevRadianLpfXYStep += pow([[_radianLpfXYArray objectAtIndex:i] doubleValue] - _averageRadianLpfXYStep, 2);
            _stddevRadianLpfXZStep += pow([[_radianLpfXZArray objectAtIndex:i] doubleValue] - _averageRadianLpfXZStep, 2);
            count++;
        }
        if(count - 2 > 0)
        {
            _stddevRadianLpfXYStep = sqrt(_stddevRadianLpfXYStep / (double)count);
            _stddevRadianLpfXZStep = sqrt(_stddevRadianLpfXZStep / (double)count);
        }
        [stddevRadianLpfXYStepArray addObject:[[NSNumber alloc] initWithDouble:_stddevRadianLpfXYStep]];
        [stddevRadianLpfXZStepArray addObject:[[NSNumber alloc] initWithDouble:_stddevRadianLpfXZStep]];
        
        // 回帰直線の準備
        NSMutableArray* weightArray = [[NSMutableArray alloc] init];
        NSMutableArray* answerArray = [[NSMutableArray alloc] init];
        count = 0;
        // 重み配列の設定。重みなし。
        for(long i = [[stepCountArray objectAtIndex:index] intValue]; i < [[stepCountArray objectAtIndex:index+1] intValue]; i++)
        {
            [weightArray addObject: [[NSNumber alloc] initWithDouble:10.0]];
            count++;
        }
        // 1 次元なので答えは 2 個。y = ax + b
        [answerArray addObject:[[NSNumber alloc] initWithDouble:0.0]];
        [answerArray addObject:[[NSNumber alloc] initWithDouble:0.0]];
        // C 言語でできているため、計算する配列を double 配列で用意する
        double dataX[count];
        double dataZ[count];
        long count2 = 0;
        for(long i = [[stepCountArray objectAtIndex:index] intValue]; i < [[stepCountArray objectAtIndex:index+1] intValue]; i++)
        {
            dataX[count2] = count2;
            dataZ[count2] = [[_accelerometerLpfArray objectAtIndex:i] z];
            count2++;
        }
        // 最小二乗法を実行する
        [self leastSquares:1
                     dataX:dataX
                     dataY:dataZ
                 dataCount:count2
               weightArray:weightArray
                anserArray:&answerArray];
        NSLog(@"Answer:%@", [answerArray description]);
        
        // 傾きだけ記録
        _slopeZStep = [[answerArray objectAtIndex:1] doubleValue];
        [slopeZStepArray addObject:[[NSNumber alloc] initWithDouble:_slopeZStep]];
        
        NSLog(@"averageXStep=%lf, averageZStep=%lf, stddevXStep=%lf, stddevZStep=%lf, averageDeltaYStep=%lf, mountValleyYStep=%lf, averageLpfAbsXStep=%lf,  slopeZStep=%lf, averageRadianXYStep=%lf, averageRadianXZStep=%lf, stddevRadianXYStep=%lf, stddevRadianXZStep=%lf, averageRadianLpfXYStep=%lf, averageRadianLpfXZStep = %lf, stddevRadianLpfXYStep=%lf, stddevRadianLpfXZStep=%lf",
              _averageXStep,
              _averageZStep,
              _stddevXStep,
              _stddevZStep,
              _averageLpfDeltaYStep,
              _mountValleyYStep,
              _averageLpfAbsXStep,
              _slopeZStep,
              _averageRadianXYStep,
              _averageRadianXZStep,
              _stddevRadianXYStep,
              _stddevRadianXZStep,
              _averageRadianLpfXYStep,
              _averageRadianLpfXZStep,
              _stddevRadianLpfXYStep,
              _stddevRadianLpfXZStep);
    }
    
    // ステップごとの平均値
    long count = 0;
    for(long i = 0; i < [averageXStepArray count] - 1; i++)
    {
        _averageXStepAve += [[averageXStepArray objectAtIndex:i] doubleValue];
        _averageZStepAve += [[averageZStepArray objectAtIndex:i] doubleValue];
        _stddevXStepAve += [[stddevXStepArray objectAtIndex:i] doubleValue];
        _stddevZStepAve += [[stddevZStepArray objectAtIndex:i] doubleValue];
        _averageDeltaYStepAve += [[averageDeltaYStepArray objectAtIndex:i] doubleValue];
        _mountValleyYStepAve += [[mountValleyYStepArray objectAtIndex:i] doubleValue];
        _averageLpfDeltaYStepAve += [[averageLpfDeltaYStepArray objectAtIndex:i] doubleValue];
        _mountValleyLpfYStepAve += [[mountValleyLpfYStepArray objectAtIndex:i] doubleValue];
        _averageLpfAbsXStepAve += [[averageLpfAbsXStepArray objectAtIndex:i] doubleValue];
        _slopeZStepAve += [[slopeZStepArray objectAtIndex:i] doubleValue];
        _averageRadianXYStepAve += [[averageRadianXYStepArray objectAtIndex:i] doubleValue];
        _averageRadianXZStepAve += [[averageRadianXZStepArray objectAtIndex:i] doubleValue];
        _stddevRadianXYStepAve += [[stddevRadianXYStepArray objectAtIndex:i] doubleValue];
        _stddevRadianXZStepAve += [[stddevRadianXZStepArray objectAtIndex:i] doubleValue];
        _averageRadianLpfXYStepAve += [[averageRadianLpfXYStepArray objectAtIndex:i] doubleValue];
        _averageRadianLpfXZStepAve += [[averageRadianLpfXZStepArray objectAtIndex:i] doubleValue];
        _stddevRadianLpfXYStepAve += [[stddevRadianLpfXYStepArray objectAtIndex:i] doubleValue];
        _stddevRadianLpfXZStepAve += [[stddevRadianLpfXZStepArray objectAtIndex:i] doubleValue];
        count++;
    }
    _averageXStepAve /= (double)count;
    _averageZStepAve /= (double)count;
    _stddevXStepAve /= (double)count;
    _stddevZStepAve /= (double)count;
    _averageDeltaYStepAve /= (double)count;
    _mountValleyYStepAve /= (double)count;
    _averageLpfDeltaYStepAve /= (double)count;
    _mountValleyLpfYStepAve /= (double)count;
    _averageLpfAbsXStepAve /= (double)count;
    _slopeZStepAve /= (double)count;
    _averageRadianXYStepAve /= (double)count;
    _averageRadianXZStepAve /= (double)count;
    _stddevRadianXYStepAve /= (double)count;
    _stddevRadianXZStepAve /= (double)count;
    _averageRadianLpfXYStepAve /= (double)count;
    _averageRadianLpfXZStepAve /= (double)count;
    _stddevRadianLpfXYStepAve /= (double)count;
    _stddevRadianLpfXZStepAve /= (double)count;
    
    // ステップごとの標準偏差
    for(long i = 0; i < [averageXStepArray count] - 1 ; i++)
    {
        _averageXStepDev += pow([[averageXStepArray objectAtIndex:i] doubleValue] - _averageXStepAve, 2);
        _averageZStepDev += pow([[averageZStepArray objectAtIndex:i] doubleValue] - _averageZStepDev, 2);
        _stddevXStepDev += pow([[stddevXStepArray objectAtIndex:i] doubleValue] - _stddevXStepAve, 2);
        _stddevZStepDev += pow([[stddevZStepArray objectAtIndex:i] doubleValue] - _stddevZStepAve, 2);
        _averageDeltaYStepDev += pow([[averageDeltaYStepArray objectAtIndex:i] doubleValue] - _averageDeltaYStepAve, 2);
        _mountValleyYStepDev += pow([[mountValleyYStepArray objectAtIndex:i] doubleValue] - _mountValleyYStepAve, 2);
        _averageLpfDeltaYStepDev += pow([[averageLpfDeltaYStepArray objectAtIndex:i] doubleValue] - _averageLpfDeltaYStepAve, 2);
        _mountValleyLpfYStepDev += pow([[mountValleyLpfYStepArray objectAtIndex:i] doubleValue] - _mountValleyLpfYStepAve, 2);
        _averageLpfAbsXStepDev += pow([[averageLpfAbsXStepArray objectAtIndex:i] doubleValue] - _averageLpfAbsXStepAve, 2);
        _slopeZStepDev += pow([[slopeZStepArray objectAtIndex:i] doubleValue] - _slopeZStepAve, 2);
        _averageRadianXYStepDev += pow([[averageRadianXYStepArray objectAtIndex:i] doubleValue] - _averageRadianXYStepAve, 2);
        _averageRadianXZStepDev += pow([[averageRadianXZStepArray objectAtIndex:i] doubleValue] - _averageRadianXZStepAve, 2);
        _stddevRadianXYStepDev += pow([[stddevRadianXYStepArray objectAtIndex:i] doubleValue] - _stddevRadianXYStepAve, 2);
        _stddevRadianXZStepDev += pow([[stddevRadianXZStepArray objectAtIndex:i] doubleValue] - _stddevRadianXZStepAve, 2);
        _averageRadianLpfXYStepDev += pow([[averageRadianLpfXYStepArray objectAtIndex:i] doubleValue] - _averageRadianLpfXYStepAve, 2);
        _averageRadianLpfXZStepDev += pow([[averageRadianLpfXZStepArray objectAtIndex:i] doubleValue] - _averageRadianLpfXZStepAve, 2);
        _stddevRadianLpfXYStepDev += pow([[stddevRadianLpfXYStepArray objectAtIndex:i] doubleValue] - _stddevRadianLpfXYStepAve, 2);
        _stddevRadianLpfXZStepDev += pow([[stddevRadianLpfXZStepArray objectAtIndex:i] doubleValue] - _stddevRadianLpfXZStepAve, 2);
    }
    
    if(count > 0){
        _averageXStepDev = sqrt( _averageXStepDev / (double)count);
        _averageZStepDev = sqrt( _averageZStepDev / (double)count);
        _stddevXStepDev = sqrt( _stddevXStepDev / (double)count);
        _stddevZStepDev = sqrt( _stddevZStepDev / (double)count);
        _averageDeltaYStepDev = sqrt( _averageLpfDeltaYStepDev / (double)count);
        _mountValleyYStepDev = sqrt( _mountValleyYStepDev / (double)count);
        _averageLpfDeltaYStepDev = sqrt( _averageLpfDeltaYStepDev / (double)count);
        _mountValleyLpfYStepDev = sqrt( _mountValleyYStepDev / (double)count);
        _averageLpfAbsXStepDev = sqrt( _averageLpfAbsXStepDev / (double)count);
        _slopeZStepDev = sqrt( _slopeZStepDev / (double)count);
        _averageRadianXYStepDev = sqrt( _averageRadianXYStepDev / (double)count);
        _averageRadianXZStepDev = sqrt( _averageRadianXZStepDev / (double)count);
        _stddevRadianXYStepDev = sqrt( _stddevRadianXYStepDev / (double)count);
        _stddevRadianXZStepDev = sqrt( _stddevRadianXZStepDev / (double)count);
        _averageRadianLpfXYStepDev = sqrt( _averageRadianLpfXYStepDev / (double)count);
        _averageRadianLpfXZStepDev = sqrt( _averageRadianLpfXZStepDev / (double)count);
        _stddevRadianLpfXYStepDev = sqrt( _stddevRadianLpfXYStepDev / (double)count);
        _stddevRadianLpfXZStepDev = sqrt( _stddevRadianLpfXZStepDev / (double)count);
    }
    
    
}


// 回帰分析（とりあえず 10 次まで対応）
// dimension: 次数
// dataX: X 軸の配列
// dataY: Y 軸の配列
// dataCount: X, Y の配列数
// weightArray: 重み配列
// answerArray: 結果
- (int)leastSquares:(int)dimension
              dataX:(double*)dataX
              dataY:(double*)dataY
          dataCount:(long)dataCount
        weightArray:(NSMutableArray*)weightArray
         anserArray:(NSMutableArray**)answerArray
{
    
    // 初期化
    long indexA = 0;
    long indexB = 0;
    long indexC = 0;
    double temp1 = 0.0;
    double temp2 = 0.0;
    double temp3 = 0.0;
    double temp4 = 0.0;
    double dataSize = dataCount;
    double xArray[DIM*2+1];
    double yArray[DIM+1];
    double matrixArray[DIM+1][DIM+2];
    
    double answerTempArray[[*answerArray count]];
    
    // 固定配列の初期化
    memset(matrixArray, 0, ((DIM+1)*(DIM+2))*sizeof(double));
    
    for(indexA = 0; indexA <= dimension*2; indexA++)
    {
        xArray[indexA] = 0;
    }
    for(indexA = 0; indexA <= dimension; indexA++)
    {
        yArray[indexA] = 0;
    }
    
    // データ数がDIM+1に満たない場合
    if(((long)dataSize <= (dimension+1) && dimension == 1) || ((long)dataSize <= dimension))
    {
        // 一次回帰直線で、要素数が二つしかなく、X 軸のデータが 1 と 2 の場合
        if((long)dataSize == dimension+1 && dimension == 1 && dataX[0] == 1 && dataX[1] == 2)
        {
            answerTempArray[1] = dataY[1] - dataY[0];
            answerTempArray[0] = dataY[0] - answerTempArray[1];
            return 1;
        }
        return 0;
    }
    if(dimension >= (long)dataSize)
    {
        dimension = (short)(dataSize - 1);
    }
    
    temp4 = 0;
    for(indexA = 0; indexA < (long)dataSize; indexA++)
    {
        temp2 = dataX[indexA];
        temp3 = dataY[indexA];
        for(indexB = 0, temp1 = 1; indexB <= dimension; indexB++, temp1 *= temp2)
        {
            xArray[indexB] += temp1 * [[weightArray objectAtIndex:indexA] doubleValue];
            yArray[indexB] += temp1 * temp3 * [[weightArray objectAtIndex:indexA] doubleValue];
        }
        for(; indexB <= dimension * 2; indexB++, temp1 *= temp2)
        {
            xArray[indexB] += temp1 * [[weightArray objectAtIndex:indexA] doubleValue];
        }
        temp4 += temp3;
    }
    
    for(indexA = 0; indexA <= dimension; indexA++)
    {
        for(indexB = 0; indexB <= dimension; indexB++)
        {
            matrixArray[indexA][indexB] = xArray[indexA+indexB];
        }
        matrixArray[indexA][indexB] = yArray[indexA];
    }
    for(indexA = 0; indexA < dimension; indexA++)
    {
        if(matrixArray[indexA][indexA] == 0)
        {
            return 1;
        }
        for(indexC = indexA + 1; indexC <= dimension; indexC++)
        {
            temp1 = matrixArray[indexC][indexA] / matrixArray[indexA][indexA];
            for(indexB = indexA + 1; indexB <= dimension + 1; indexB++)
            {
                matrixArray[indexC][indexB] -= matrixArray[indexA][indexB] * temp1;
            }
        }
    }
    for(indexA = dimension; indexA >= 0; indexA--)
    {
        indexC = indexA + 1;
        while(indexC <= dimension)
        {
            matrixArray[indexA][dimension+1] -= matrixArray[indexA][indexC] * matrixArray[indexC][dimension+1];
            indexC++;
        }
        answerTempArray[indexA] = matrixArray[indexA][dimension+1] /= matrixArray[indexA][indexA];
    }
    
    for(indexA = 0; indexA < [*answerArray count]; indexA++)
    {
        [*answerArray replaceObjectAtIndex:indexA withObject:[[NSNumber alloc] initWithDouble:answerTempArray[indexA]]];
    }
    
    return 1;
}



@end
