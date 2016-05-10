//
//  PGBarcodeScanView.m
//  libBarcode
//
//  Created by DCloud on 15/12/8.
//  Copyright © 2015年 DCloud. All rights reserved.
//

#import "PGBarcodeScanView.h"
#import "PGBarcodeOverlayView.h"
#import "ZXCaptureDelegate.h"
#import "ZXResult.h"

@interface PGBarcodeScanView () <ZXCaptureDelegate>{
      SystemSoundID beepSound;
}

@property(nonatomic, assign)BOOL useVibrate;
@end

@implementation PGBarcodeScanView

- (id) initWithFrame:(CGRect)theFrame {
    if ( self = [super initWithFrame:theFrame] ) {
        self.capture = [[PGBarcodeCapture alloc] init];
        self.capture.camera = self.capture.back;
        self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        //self.capture.focusRange = AVCaptureAutoFocusRangeRestrictionNear;
        self.capture.rotation = 90.0f;
        self.useVibrate = YES;
        self.capture.transform = CGAffineTransformMakeScale(5.0,5.0);
        
        self.capture.layer.frame = self.bounds;
        [self.layer addSublayer:self.capture.layer];
        [self orientationChange];
        
        self.overlayView = [[PGBarcodeOverlayView alloc] initWithFrame:self.bounds];
        [self addSubview:_overlayView];
    }
    
    return self;
}

-(void)setSoundToPlay:(NSURL *)soundToPlay {
    if ( soundToPlay ) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundToPlay, &beepSound);
        if (error == kAudioServicesNoError) {
            self.useVibrate = NO;
        }
    }
}

-(void)willMoveToSuperview:(nullable UIView *)newSuperview {
    if ( nil == newSuperview ) {
        [_overlayView stopScanline];
        self.capture.delegate = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    } else {
        [_overlayView startScanline];
        self.capture.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    [super willMoveToSuperview:newSuperview];
}

- (void) orientationChange {
    if ( UIDeviceOrientationPortrait == [UIDevice currentDevice].orientation ) {
        [self.capture setVideoOrientation:AVCaptureVideoOrientationPortrait];
        self.capture.rotation = 90.0f;
    } else if ( UIDeviceOrientationLandscapeLeft == [UIDevice currentDevice].orientation) {
        [self.capture setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
        self.capture.rotation = 0;
    } else if ( UIDeviceOrientationLandscapeRight == [UIDevice currentDevice].orientation ){
        [self.capture setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
        self.capture.rotation = 180;
    } else if ( UIDeviceOrientationPortraitUpsideDown == [UIDevice currentDevice].orientation ){
        [self.capture setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
        self.capture.rotation = 270.0f;
    } else {
        
    }
}

- (void)layoutSubviews {
    self.capture.layer.frame = self.bounds;
    self.overlayView.frame = self.bounds;
    CGRect humanRect = _overlayView.cropRect;
   // self.capture.scanRect = humanRect;//CGRectInset(humanRect, -5, -5);
    self.capture.scanRect = CGRectInset(humanRect, -5, -5);
}

- (void)captureResult:(PGBarcodeCapture *)capture result:(PGBarcodeResult *)result {
    if (!result) return;
    [self.capture stop];
    if ( self.useVibrate ) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    } else {
        if (beepSound != (SystemSoundID)-1) {
            AudioServicesPlaySystemSound(beepSound);
        }
    }
    [self.delegate captureResult:self result:result];
}

- (void)pauseScan {
    [self.overlayView stopScanline];
    [self.capture stop];
}

- (void)resumeScan {
    [self.overlayView startScanline];
    [self.capture start];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)dealloc {
    if (beepSound != (SystemSoundID)-1) {
        AudioServicesDisposeSystemSoundID(beepSound);
    }
    [self.capture stop];
    self.capture.delegate = nil;
}

@end
