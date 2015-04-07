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


#import "AccelerometerViewController.h"

@implementation AccelerometerViewController

- (id)initWithNibName:(NSString* )nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect r = [[UIScreen mainScreen] bounds];
        CGFloat w = r.size.width;
        CGFloat h = r.size.height;
        
        background = [[UIView alloc] initWithFrame: CGRectMake(0, 0, w, h)];
        background.backgroundColor = [UIColor whiteColor];
        [self.view addSubview: background];
        
        [self setLabel:&axLabel title:@"xxxxxxx" withX:20 withY:50 withW:200 withH:30];
        
        [background addSubview:axLabel];
        
        [self setLabel:&ayLabel title:@"yyyyyyy" withX:20 withY:90 withW:200 withH:30];
        
        [background addSubview:ayLabel];
        
        [self setLabel:&azLabel title:@"zzzzzzz" withX:20 withY:130 withW:200 withH:30];
        
        [background addSubview:azLabel];
        
        [self setLabel:&gxLabel title:@"xxxxxxx" withX:20 withY:170 withW:200 withH:30];
        
        [background addSubview:gxLabel];
        
        [self setLabel:&gyLabel title:@"yyyyyyy" withX:20 withY:210 withW:200 withH:30];
        
        [background addSubview:gyLabel];
        
        [self setLabel:&gzLabel title:@"zzzzzzz" withX:20 withY:250 withW:200 withH:30];
        
        [background addSubview:gzLabel];
        
        SEL selFunction = @selector(calibration1Start);
        [self setButton:&calibration1Button title:@"calibration1" withX:20 withY:300 withW:100 withH:40 function:selFunction];
        
        [background addSubview:calibration1Button];
        
        selFunction = @selector(calibration2Start);
        [self setButton:&calibration2Button title:@"calibration2" withX:130 withY:300 withW:100 withH:40 function:selFunction];
        calibration2Button.enabled = NO; // calibration1 が終わるまでアクティブにしない
        [background addSubview:calibration2Button];
        
        selFunction = @selector(recording);
        [self setButton:&writeButton title:@"start" withX:240 withY:300 withW:100 withH:40 function:selFunction];
        
        [background addSubview:writeButton];
        
        [self setText:&text withX:20 withY:360 withW:200 withH:40];
        
        [background addSubview:text];
        
        
        
        buttonFlag1 = BUTTON_RECORD_STOP;
        buttonFlagCalibration = BUTTON_RECORD_STOP;
        
        calibration1Result = NO;
        
        paramCal = [[ParamCalculator alloc] init];
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // インスタンスの生成
    _motionManager = [[CMMotionManager alloc] init];
    
    if (_motionManager.accelerometerAvailable)
    {
        // センサーの更新間隔の指定
        _motionManager.accelerometerUpdateInterval = 1 / 100;  // 10Hz
        
        // ハンドラを指定
        CMAccelerometerHandler handler = ^(CMAccelerometerData *data, NSError *error)
        {
            double ax = data.acceleration.x;
            double ay = data.acceleration.y;
            double az = data.acceleration.z;
            
            // 画面に表示
            axLabel.text = [NSString stringWithFormat:@"ax %f", ax];
            ayLabel.text = [NSString stringWithFormat:@"ay %f", ay];
            azLabel.text = [NSString stringWithFormat:@"az %f", az];
            
            if(buttonFlag1 == BUTTON_RECORDING)
            {
                [paramCal accAddObject:ax y:ay z:az];
            }
        };
        
        // 加速度の取得開始
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
    }
    
    if (_motionManager.deviceMotionAvailable) {
        _motionManager.gyroUpdateInterval = 1 / 100; // 10Hz
        // 向きの更新通知を開始する
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler:^(CMDeviceMotion *motion, NSError *error)
         {
             double gx = motion.attitude.pitch * 180 / M_PI;
             double gy = motion.attitude.roll * 180 / M_PI;
             double gz = motion.attitude.yaw * 180 / M_PI;
             
             // 画面に表示
             gxLabel.text = [NSString stringWithFormat:@"gx %f", gx];
             gyLabel.text = [NSString stringWithFormat:@"gy %f", gy];
             gzLabel.text = [NSString stringWithFormat:@"gz %f", gz];
             
             if(buttonFlag1 == BUTTON_RECORDING)
             {
                 [paramCal gyroAddObject:gx y:gy z:gz];
             }
         }];
    }
}

- (void)calibration1Start
{
    if(buttonFlagCalibration == BUTTON_RECORD_STOP)
    {
        calibration1Button.enabled = NO;
        calibration2Button.enabled = NO;
        writeButton.enabled = NO;
        [paramCal resetArray];
        
        buttonFlagCalibration = BUTTON_RECORDING;
        buttonFlag1 = BUTTON_RECORDING;
        
        // 3 秒間計測する
        tm = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                              target:self
                                            selector:@selector(calibration1Run)
                                            userInfo:nil
                                             repeats:YES
              ];
    }
}

- (void)calibration1Run
{
    buttonFlagCalibration = BUTTON_RECORD_STOP;
    buttonFlag1 = BUTTON_RECORD_STOP;
    [tm invalidate];

    calibration1Result = [paramCal calibration1];

    calibration1Button.enabled = YES;
    
    // Calibration 1 が完了したら Calibration 2 を有効にする
    if(calibration1Result)
    {
        calibration2Button.enabled = YES;
    }
    writeButton.enabled = YES;
}

- (void)calibration2Start
{
    if(buttonFlagCalibration == BUTTON_RECORD_STOP)
    {
        calibration1Button.enabled = NO;
        calibration2Button.enabled = NO;
        writeButton.enabled = NO;
        [paramCal resetArray];
        
        buttonFlagCalibration = BUTTON_RECORDING;
        buttonFlag1 = BUTTON_RECORDING;
        
        // 2 秒間計測する
        tm = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                              target:self
                                            selector:@selector(calibration2Run)
                                            userInfo:nil
                                             repeats:YES
              ];
    }
}

- (void)calibration2Run
{
    buttonFlagCalibration = BUTTON_RECORD_STOP;
    buttonFlag1 = BUTTON_RECORD_STOP;
    [tm invalidate];
    
    BOOL result = [paramCal calibration2];
    
    if(result == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Walking Checker" message:@"『お辞儀キャリブレーション』に失敗しました"
                                                       delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil];
        [alert show];

    }
    
    calibration1Button.enabled = YES;
    calibration2Button.enabled = YES;
    writeButton.enabled = YES;
}


- (void)recording
{
    if(buttonFlag1 == BUTTON_RECORD_STOP)
    {
        [paramCal resetArray];
        buttonFlag1 = BUTTON_RECORDING;
        calibration1Button.enabled = NO;
        calibration2Button.enabled = NO;
        [writeButton setTitle: @"Stop"
                     forState: UIControlStateNormal];
    }
    else if(buttonFlag1 == BUTTON_RECORDING)
    {
        buttonFlag1 = BUTTON_RECORD_STOP;
        
        // パラメータ配列出力用のファイルを準備
        NSDate* now = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSUInteger flags;
        NSDateComponents* comps;
        flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        comps = [calendar components:flags fromDate:now];
        
        NSInteger year = comps.year;
        NSInteger month = comps.month;
        NSInteger day = comps.day;
        NSLog(@"%ld年 %ld月 %ld日", year, month, day);
        
        // 時・分・秒を取得
        flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        comps = [calendar components:flags fromDate:now];
        NSInteger hour = comps.hour;
        NSInteger minute = comps.minute;
        NSInteger second = comps.second;
        
        NSString* logFile = [NSString stringWithFormat:@"%@_%04ld%02ld%02ld_%02ld%02ld%02ld.csv", text.text,year, month, day, hour, minute, second];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* logPathString = [paths objectAtIndex:0];
        logPathString = [NSString stringWithFormat:@"%@/%@", logPathString, logFile];
        
        NSString* writeLine = [NSString stringWithFormat:@"acc.x,acc.y,acc.z,lowpass.acc.x,lowpass.acc.y,lowpass.acc.z,gyro.x,gyro.y,gyro.z,radianXY,radianXZ,radianXYLpf,radianXZLpf\n"];
        
        NSString* paramFile = [NSString stringWithFormat:@"%@%04ld%02ld%02ld_%02ld%02ld%02ld_param.csv", text.text,year, month, day, hour, minute, second];
        NSString* paramPathString = [paths objectAtIndex:0];
        paramPathString = [NSString stringWithFormat:@"%@/%@", paramPathString, paramFile];
        
        NSString* paramString = [NSString stringWithFormat:@""];
        
        [paramCal calculationParamArray:YES
                            gyroEnabled:YES];
        
        for(long i = 0; i < paramCal.accArrayCount; i++)
        {
            if(i < [paramCal.accelerometerLpfArray count])
            {
                writeLine = [NSString stringWithFormat:@"%@%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf\n",
                             writeLine,
                             [[paramCal.accelerometerArray objectAtIndex:i] x],
                             [[paramCal.accelerometerArray objectAtIndex:i] y],
                             [[paramCal.accelerometerArray objectAtIndex:i] z],
                             [[paramCal.accelerometerLpfArray objectAtIndex:i] x],
                             [[paramCal.accelerometerLpfArray objectAtIndex:i] y],
                             [[paramCal.accelerometerLpfArray objectAtIndex:i] z],
                             [[paramCal.gyroArray objectAtIndex:i] x],
                             [[paramCal.gyroArray objectAtIndex:i] y],
                             [[paramCal.gyroArray objectAtIndex:i] z],
                             [[paramCal.radianXYArray objectAtIndex:i] doubleValue],
                             [[paramCal.radianXZArray objectAtIndex:i] doubleValue],
                             [[paramCal.radianLpfXYArray objectAtIndex:i] doubleValue],
                             [[paramCal.radianLpfXZArray objectAtIndex:i] doubleValue]];
            }
            else
            {
                writeLine = [NSString stringWithFormat:@"%@%lf,%lf,%lf,,,,%lf,%lf,%lf,%lf,%lf,,\n",
                             writeLine,
                             [[paramCal.accelerometerArray objectAtIndex:i] x],
                             [[paramCal.accelerometerArray objectAtIndex:i] y],
                             [[paramCal.accelerometerArray objectAtIndex:i] z],
                             [[paramCal.gyroArray objectAtIndex:i] x],
                             [[paramCal.gyroArray objectAtIndex:i] y],
                             [[paramCal.gyroArray objectAtIndex:i] z],
                             [[paramCal.radianXYArray objectAtIndex:i] doubleValue],
                             [[paramCal.radianXZArray objectAtIndex:i] doubleValue]];
            }
            
            
        }
        
        NSError* error = nil;
        [writeLine writeToFile:logPathString atomically:YES encoding:NSUTF8StringEncoding error:&error];

        
        
        
        // 算出したパラメータ
        paramString = [NSString stringWithFormat:@"%@%@,%ld,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,\n",
                       paramString,
                       text.text,
                       paramCal.stepValleyCount,
                       paramCal.averageX,
                       paramCal.stddevX,
                       paramCal.averageZ,
                       paramCal.stddevZ,
                       paramCal.mountValleyY,
                       paramCal.averageLpfDeltaY,
                       paramCal.slopeZ,
                       paramCal.averageLpfAbsX,
                       paramCal.stddevRadianXY,
                       paramCal.stddevRadianXZ,
                       paramCal.stddevRadianLpfXY,
                       paramCal.stddevRadianLpfXZ,
                       paramCal.averageXStepAve,
                       paramCal.averageZStepAve,
                       paramCal.stddevXStepAve,
                       paramCal.stddevZStepAve,
                       paramCal.averageDeltaYStepAve,
                       paramCal.mountValleyYStepAve,
                       paramCal.averageLpfDeltaYStepAve,
                       paramCal.mountValleyLpfYStepAve,
                       paramCal.averageLpfAbsXStepAve,
                       paramCal.slopeZStepAve,
                       paramCal.averageRadianXYStepAve,
                       paramCal.averageRadianXZStepAve,
                       paramCal.stddevRadianXYStepAve,
                       paramCal.stddevRadianXZStepAve,
                       paramCal.averageRadianLpfXYStepAve,
                       paramCal.averageRadianLpfXZStepAve,
                       paramCal.stddevRadianLpfXYStepAve,
                       paramCal.stddevRadianLpfXZStepAve,
                       paramCal.averageXStepDev,
                       paramCal.averageZStepDev,
                       paramCal.stddevXStepDev,
                       paramCal.stddevZStepDev,
                       paramCal.averageDeltaYStepDev,
                       paramCal.mountValleyYStepDev,
                       paramCal.averageLpfDeltaYStepDev,
                       paramCal.mountValleyLpfYStepDev,
                       paramCal.averageLpfAbsXStepDev,
                       paramCal.slopeZStepDev,
                       paramCal.averageRadianXYStepDev,
                       paramCal.averageRadianXZStepDev,
                       paramCal.stddevRadianXYStepDev,
                       paramCal.stddevRadianXZStepDev,
                       paramCal.averageRadianLpfXYStepDev,
                       paramCal.averageRadianLpfXZStepDev,
                       paramCal.stddevRadianLpfXYStepDev,
                       paramCal.stddevRadianLpfXZStepDev];
        
        
//averageLpfAbsXStepAve <= 0.060591
//|   averageRadianXZStepDev <= 0.219804
//|   |   stddevRadianLpfXZStepAve <= 0.19851: neko (12.0)
//|   |   stddevRadianLpfXZStepAve > 0.19851
//|   |   |   averageXStepAve <= 0.006544: noke (7.0)
//|   |   |   averageXStepAve > 0.006544: futs (17.0)
//|   averageRadianXZStepDev > 0.219804: suri (14.0)
//averageLpfAbsXStepAve > 0.060591
//|   stddevRadianXZStepAve <= 0.691809
//|   |   averageXStepAve <= 0.027983: sayu (15.0/1.0)
//|   |   averageXStepAve > 0.027983: uchi (10.0)
//|   stddevRadianXZStepAve > 0.691809: gani (12.0)
        
        
        NSString *result = [NSString stringWithFormat:@""];

        if(paramCal.averageLpfAbsXStepAve <= 0.060591){
            if(paramCal.averageRadianXZStepDev <= 0.219804){
                if(paramCal.stddevRadianLpfXZStepAve <= 0.19851){
                    result = [NSString stringWithFormat:@"猫背"];
                }else{
                    if(paramCal.averageXStepAve <= 0.006544){
                        result = [NSString stringWithFormat:@"仰け反り"];
                    }else{
                        result = [NSString stringWithFormat:@"普通"];
                    }
                }
            }else{
                result = [NSString stringWithFormat:@"すり足"];
            }
        }else{
            if(paramCal.stddevRadianXZStepAve <= 0.691809){
                if(paramCal.averageXStepAve <= 0.027983){
                    result = [NSString stringWithFormat:@"左右ふらふら"];
                }else{
                    result = [NSString stringWithFormat:@"内股"];
                }
            }else{
                result = [NSString stringWithFormat:@"がに股"];
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Walking Checker" message:result
                                                       delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil];
        [alert show];
        
        
        [paramString writeToFile:paramPathString atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        [writeButton setTitle: @"Start"
                     forState: UIControlStateNormal];
        
        calibration1Button.enabled = YES;
        if(calibration1Result)
        {
            calibration2Button.enabled = YES;
        }
    }
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 加速度の取得停止
    if (_motionManager.accelerometerActive) {
        [_motionManager stopAccelerometerUpdates];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 初期画面に表示するLabelを作成するメソッド
- (void)setLabel: (UILabel * __strong *)label
           title:(NSString*)title
           withX: (int)X
           withY: (int)Y
           withW: (int)W
           withH: (int)H
{
    (*label) = [[UILabel alloc] init];
    (*label).frame = CGRectMake(X, Y, W, H);
    (*label).text = title;
    (*label).textColor = [UIColor blackColor];
    (*label).backgroundColor = [UIColor whiteColor];
    
    return;
}

// 初期画面に表示するLabelを作成するメソッド
- (void)setText: (UITextField * __strong *)textField
          withX: (int)X
          withY: (int)Y
          withW: (int)W
          withH: (int)H
{
    (*textField) = [[UITextField alloc] init];
    (*textField).frame = CGRectMake(X, Y, W, H);
    (*textField).textColor = [UIColor blackColor];
    (*textField).backgroundColor = [UIColor whiteColor];
    (*textField).layer.borderColor = [UIColor grayColor].CGColor;
    (*textField).layer.borderWidth = 1.0f;
    (*textField).layer.cornerRadius = 7.5f;
    
    return;
}

// 初期画面に表示するボタンを作成するメソッド
- (void)setButton: (UIButton * __strong *)button
            title: (NSString*)label
            withX: (int)X
            withY: (int)Y
            withW: (int)W
            withH: (int)H
         function: (SEL)selFunction
{
    (*button) = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    (*button).frame = CGRectMake(X, Y, W, H);
    (*button).titleLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    (*button).layer.borderColor = [UIColor grayColor].CGColor;
    (*button).layer.borderWidth = 1.0f;
    (*button).layer.cornerRadius = 7.5f;
    [(*button) setTitle: label
               forState: UIControlStateNormal];
    [(*button) addTarget: self
                  action: selFunction
        forControlEvents: UIControlEventTouchUpInside];
    return;
}







@end