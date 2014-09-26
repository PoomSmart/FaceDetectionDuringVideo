#import "../PS.h"

@interface PLCameraController
- (void)setFaceDetectionEnabled:(BOOL)enabled;
@end

@interface CAMCaptureController
- (void)setFaceDetectionEnabled:(BOOL)enabled forceDisableImageProcessing:(BOOL)disableIP;
@end

%group Common

%hook AVCaptureFigVideoDevice

- (BOOL)isFaceDetectionDuringVideoPreviewSupported
{
	return YES;
}

%end

%end

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

- (void)startVideoCapture
{
	%orig;
	[self setFaceDetectionEnabled:YES forceDisableImageProcessing:NO];
}

%end

%end

%ctor
{
	%init(Common);
	if (isiOS8) {
		%init(iOS8);
	} else {
		%init(preiOS8);
	}
}
