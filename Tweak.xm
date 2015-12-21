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

%group iOS9

BOOL override = NO;

%hook CAMPreviewViewController

- (BOOL)_shouldSuppressNewFaces
{
	override = YES;
	BOOL r = %orig;
	override = NO;
	return r;
}

%end

%hook CUCaptureController

- (BOOL)isCapturingVideo
{
	return override ? NO : %orig;
}

- (BOOL)_useSmoothFocus
{
	return YES;
}

- (id)_faceDetectionCommandForMode:(int)mode capturing:(BOOL)capturing
{
	return %orig(mode, NO);
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
	dlopen("/System/Library/Frameworks/AVFoundation.framework/AVFoundation", RTLD_LAZY);
	%init;
	if (isiOS9Up) {
		dlopen("/System/Library/PrivateFrameworks/CameraUI.framework/CameraUI", RTLD_LAZY);
		%init(iOS9);
	} else if (isiOS8) {
		dlopen("/System/Library/PrivateFrameworks/CameraKit.framework/CameraKit", RTLD_LAZY);
		%init(iOS8);
	} else {
		dlopen("/System/Library/PrivateFrameworks/PhotoLibrary.framework/PhotoLibrary", RTLD_LAZY);
		%init(preiOS8);
	}
}