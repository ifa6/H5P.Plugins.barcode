//
//  PGBarcodeScanView.h
//  libBarcode
//
//  Created by DCloud on 15/12/8.
//  Copyright © 2015年 DCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGBarcodeCapture.h"
#import "PGBarcodeOverlayView.h"
@class PGBarcodeScanView;

@protocol PGBarcodeScanViewDelegate <NSObject>
- (void)captureResult:(PGBarcodeScanView *)capture result:(PGBarcodeResult*)result;
@end

@interface PGBarcodeScanView : UIView
@property (nonatomic, weak) id<PGBarcodeScanViewDelegate> delegate;
@property (nonatomic, retain) NSURL *soundToPlay;
@property (nonatomic, strong) PGBarcodeCapture *capture;
@property (nonatomic, strong) PGBarcodeOverlayView *overlayView;
- (void)pauseScan;
- (void)resumeScan;
@end
