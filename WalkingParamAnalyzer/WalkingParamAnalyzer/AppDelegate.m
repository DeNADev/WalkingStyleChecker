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

//  AppDelegate.m
//  WalkingParamAnalyzer


#import "AppDelegate.h"
#import "XYZObject.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSArrayController *arrayController;
@property (assign) IBOutlet NSTableView* tableView;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    _tableView.delegate = self;
    
    paramCal = [[ParamCalculator alloc] init];
}

- (IBAction)buttonAddFilePushed:(id)sender
{
    NSLog(@"Pushed buttonAddFile");
    
    NSOpenPanel *openPanel	= [NSOpenPanel openPanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"txt",@"csv", nil];
    // NSSavePanel interface has changed since Mac OSX v10.6.
    [openPanel setAllowedFileTypes:allowedFileTypes];
    [openPanel setAllowsMultipleSelection:YES];
    NSInteger pressedButton = [openPanel runModal];
    NSMutableArray* array = [_arrayController content];
    if (pressedButton == NSModalResponseOK) {
        
        NSArray *filesToOpen = [openPanel URLs];
        int i;
        long count = [filesToOpen count];
        for (i = 0; i < count; i++) {
            NSURL *fileURL = [filesToOpen objectAtIndex:i];
            ViewDataModel *model = [[ViewDataModel alloc] init];
            model.path = [fileURL path];
            [array addObject:model];
        }
        [_arrayController setContent:array];
        
    } else if (pressedButton == NSModalResponseCancel){
        NSLog(@"Cancel button was pressed.");
    } else {
        // error
    }
}


- (IBAction)buttonAnalyzePushed:(id)sender
{
    NSString* params = [NSString stringWithFormat:@""];
    // Table の読込
    NSMutableArray* array = [_arrayController content];
    for(int i = 0; i < [array count]; i++)
    {
        // ファイルごとに初期化
        [paramCal resetArray];
        
        NSString *path = [NSString stringWithContentsOfFile:[[array objectAtIndex:i] getPath]  encoding:NSUTF8StringEncoding error:nil];
        NSRange range = NSMakeRange(0, path.length);
        NSRange subRange;
        int count = 0;
        NSString *line;
        while (range.length > 0) {
            subRange = [path lineRangeForRange:NSMakeRange(range.location, 0)];
            line = [path substringWithRange:subRange];
            NSLog(@"line = %@", line);
            NSLog(@"line no = %d", count);
            count++;
            NSArray *param = [line componentsSeparatedByString:@","];
            if(![[param objectAtIndex:0] isEqualToString:@"acc.x"])
            {
                double ax = [[param objectAtIndex:0] doubleValue];
                double ay = [[param objectAtIndex:1] doubleValue];
                double az = [[param objectAtIndex:2] doubleValue];
                [paramCal.accelerometerArray addObject:[[XYZObject alloc] initWithName:ax y:ay z:az]];
            }
            
            range.location = NSMaxRange(subRange);
            range.length -= subRange.length;
        }
  
        [paramCal calculationParamArray:NO
                            gyroEnabled:NO];
        
        // 算出したパラメータ
        params = [NSString stringWithFormat:@"%@%@,%ld,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,\n", params,
                  [[[array objectAtIndex:i] getPath] lastPathComponent],
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
    }
    
    NSSavePanel *savePanel	= [NSSavePanel savePanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"csv",@"'TEXT'",nil];
    [savePanel setAllowedFileTypes:allowedFileTypes];
    NSInteger pressedButton = [savePanel runModal];
    NSError* error = nil;
    if( pressedButton == NSModalResponseOK ){
        // get file path (use NSURL)
        NSURL * filePath = [savePanel URL];
        NSString* file = [filePath path];
        // save file here
        NSLog(@"file saved '%@'", file);
        [params writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
    }else if( pressedButton == NSModalResponseCancel ){
        NSLog(@"Cancel button was pressed.");
    }else{
        // error
    }
    
}

@end
