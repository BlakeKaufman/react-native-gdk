#import <React/RCTBridge+Private.h>
#import <React/RCTUtils.h>
#import <jsi/jsi.h>
#import <jsi/threadsafe.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSFileManager.h>
#include <ReactCommon/CallInvoker.h>
#import <React/RCTUtils.h>
#import <ReactCommon/RCTTurboModule.h>
#include <hermes/hermes.h>
#import "NativeGdk.h"
#import <gdk.h>
#import "GdkHostObject.hpp"
#import "utils.hpp"

@implementation NativeGdk

@synthesize bridge = _bridge;
@synthesize methodQueue = _methodQueue;
RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(install)
{
    RCTBridge* bridge = [RCTBridge currentBridge];
    RCTCxxBridge* cxxBridge = (RCTCxxBridge*)bridge;

    if (cxxBridge == nil) {
        return @false;
    }

    using namespace facebook;

    auto jsiRuntime = (jsi::Runtime*) cxxBridge.runtime;
    if (jsiRuntime == nil) {
        return @false;
    }
    auto& runtime = *jsiRuntime;
    auto callInvoker = bridge.jsCallInvoker;

    NSError *error = nil;
    NSURL *appSupportDirURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                                     inDomain:NSUserDomainMask
                                                                    appropriateForURL:nil
                                                                         create:YES
                                                                          error:&error];
    if (error) {
        throw jsi::JSError(runtime, "Error while getting support directory");
    }

        // Append the bundle identifier to the URL
     NSString *uniqueNamespace = @"com.yourcompany.blitzliquidWalletKit";
    NSURL *finalURL = [appSupportDirURL URLByAppendingPathComponent:uniqueNamespace isDirectory:YES];


    // Create the directory
    if (![[NSFileManager defaultManager] createDirectoryAtURL:finalURL
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:&error]) {
        throw jsi::JSError(runtime, "Error creating session directory");
    }
    NSString* path = [finalURL path];
    const char* cString = [path UTF8String];


    auto instance = std::make_shared<GdkHostObject>(std::string(cString), runtime, callInvoker);
    jsi::Object GDK = jsi::Object::createFromHostObject(runtime, instance);

    runtime.global().setProperty(runtime, "GDK", std::move(GDK));

    return @true;
}

@end
