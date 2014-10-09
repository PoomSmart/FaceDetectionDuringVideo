#import "../PS.h"

@interface PLCameraController
- (void)setFaceDetectionEnabled:(BOOL)enabled;
@end

@interface CAMCaptureController
- (void)setFaceDetectionEnabled:(BOOL)enabled forceDisableImageProcessing:(BOOL)disableIP;
@end

%group preiOS8

%hook AVCaptureFigVideoDevice

- (BOOL)isFaceDetectionDuringVideoPreviewSupported
{
	return YES;
}

%end

%hook PLCameraController

- (void)startVideoCapture
{
	%orig;
	[self setFaceDetectionEnabled:YES];
}

%end

%end

%group iOS8

%hook AVCaptureFigVideoDevice_FigRecorder

- (BOOL)isFaceDetectionDuringVideoPreviewSupported
{
	return YES;
}

%end

%hook CAMCaptureController

- (void)startVideoCapture
{
	%orig;
	[self setFaceDetectionEnabled:YES forceDisableImageProcessing:NO];
}

%end

%end

%ctor
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	dlopen("/System/Library/PrivateFrameworks/PhotoLibrary.framework/PhotoLibrary", RTLD_LAZY);
	dlopen("/System/Library/PrivateFrameworks/CameraKit.framework/CameraKit", RTLD_LAZY);
	if (isiOS8) {
		%init(iOS8);
	} else {
		%init(preiOS8);
	}
	[pool drain];
}
