/**
 * @file listens for USB device connections matching a PID and VID
 * @author Oliver Kuckertz <oliver.kuckertz@mologie.de>
 */

#pragma once

#import <Foundation/Foundation.h>
#import "NXUSBDevice.h"

NS_ASSUME_NONNULL_BEGIN

@class NXUSBDeviceEnumerator;

@protocol NXUSBDeviceEnumeratorDelegate
- (BOOL)usbDeviceEnumerator:(NXUSBDeviceEnumerator *)deviceEnum deviceConnected:(NXUSBDevice *)device;
- (void)usbDeviceEnumerator:(NXUSBDeviceEnumerator *)deviceEnum deviceDisconnected:(NXUSBDevice *)device;
- (void)usbDeviceEnumerator:(NXUSBDeviceEnumerator *)deviceEnum deviceError:(NSString *)err;
@end

@interface NXUSBDeviceEnumerator : NSObject
@property (weak, nonatomic) id<NXUSBDeviceEnumeratorDelegate> delegate;
- (void)addFilterForVendorID:(UInt16)vendorID productID:(UInt16)productID;
- (kern_return_t)start;
- (BOOL)handleDevicesAdded:(io_iterator_t)iterator;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
