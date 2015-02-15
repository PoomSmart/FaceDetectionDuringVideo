#import "../PS.h"

%group preiOS8

%hook PLCameraController

- (void)startVideoCapture
{
	%orig;
	[self setFaceDetectionEnabled:YES];
}

%end

%end

%group iOS8

%hook CAMCaptureController

- (void)_updateFocusAndExposureForVideoRecording
{
	%orig;
	[self setFaceDetectionEnabled:YES forceDisableImageProcessing:NO];
}

%end

%end

%hook AVCaptureFigVideoDevice

- (BOOL)isFaceDetectionDuringVideoPreviewSupported
{
	return YES;
}

%end

%ctor
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	dlopen("/System/Library/PrivateFrameworks/PhotoLibrary.framework/PhotoLibrary", RTLD_LAZY);
	dlopen("/System/Library/PrivateFrameworks/CameraKit.framework/CameraKit", RTLD_LAZY);
	%init();
	if (isiOS8) {
		%init(iOS8);
	} else {
		%init(preiOS8);
	}
	[pool drain];
}
