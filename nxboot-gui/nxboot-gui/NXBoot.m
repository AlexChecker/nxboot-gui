#import <Foundation/Foundation.h>
#import <mach-o/getsect.h>
#import <mach-o/ldsyms.h>
#import <signal.h>
#import "NXBootKit/NXBootKit.h"
#import "NXBootKit/NXExec.h"
#import "NXBootKit/NXHekateCustomizer.h"
#import "NXBootKit/NXUSBDevice.h"
#import "NXBootKit/NXUSBDeviceEnumerator.h"
#include "NXBoot.h"

#define ESC_RED   "\033[1;31m"
#define ESC_GREEN "\033[1;32m"
#define ESC       "\033[0m"
#define ESC_LN    ESC "\n"

#define COPYRIGHT_STR "Copyright 2018-2020 Oliver Kuckertz <o.kuckertz@mologie.de>"
#define LICENSE_STR   "Licensed under the GPLv3. https://github.com/mologie/nxboot#license"

static volatile sig_atomic_t gTerm = 0;

@interface NXBoot : NSObject <NXUSBDeviceEnumeratorDelegate>
    
    @property (strong, nonatomic) NSData *relocator;
    @property (strong, nonatomic) NSData *image;
    @property (strong, nonatomic) NXUSBDeviceEnumerator *usbEnum;
    @property (assign, nonatomic) BOOL daemon; // keep running after handling a device
    @property (assign, nonatomic) BOOL keepReading;
    @property (assign, nonatomic) BOOL lastBootFailed;
    
    @end

@implementation NXBoot
    
- (BOOL)start {
    self.usbEnum = [[NXUSBDeviceEnumerator alloc] init];
    self.usbEnum.delegate = self;
    [self.usbEnum addFilterForVendorID:kTegraNintendoSwitchVendorID productID:kTegraNintendoSwitchProductID];
    kern_return_t kr = [self.usbEnum start];
    return [self.usbEnum handleDevicesAdded:kr];
}
    
- (BOOL)usbDeviceEnumerator:(NXUSBDeviceEnumerator *)deviceEnum deviceConnected:(NXUSBDevice *)device {
    //kern_return_t kr;
    NSString *err = nil;
    
    struct NXExecDesc desc = NXExecAcquireDeviceInterface(device->_intf, &err);
    
    if (desc.intf) {
        if (NXExecDesc(&desc, self.relocator, self.image, &err)) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return NO;
}
    
- (void)usbDeviceEnumerator:(NXUSBDeviceEnumerator *)deviceEnum deviceDisconnected:(NXUSBDevice *)device {
    // unused
}
    
- (void)usbDeviceEnumerator:(NXUSBDeviceEnumerator *)deviceEnum deviceError:(NSString *)err {
    // error was already printed by implementation
}
    
    @end

static void onSignal(int sig) {
    gTerm = 1;
    dispatch_async(dispatch_get_main_queue(), ^{
        NXLog(@"CMD: Got signal %d, stopping main run loop", sig);
        CFRunLoopStop(CFRunLoopGetMain());
    });
}

BOOL execute(NSString* path)
{
    @autoreleasepool {
        
        NXBootKitDebugEnabled = NO;
        NXBoot *cmdTool = [[NXBoot alloc] init];
        NXHekateCustomizer *hekate = [[NXHekateCustomizer alloc] init];
        cmdTool.image = [NSData dataWithContentsOfFile: path];
        
        size_t n;
        void *p = getsectiondata(&_mh_execute_header, "__TEXT", "__intermezzo", &n);
        if (!p) {
            fprintf(stderr, ESC_RED "error: getsectiondata failed; your nxboot build is broken" ESC_LN);
            return NO;
        }
        cmdTool.relocator = [NSData dataWithBytesNoCopy:p length:n freeWhenDone:NO];
        
        BOOL result = [cmdTool start];

    return result;
    }
}
