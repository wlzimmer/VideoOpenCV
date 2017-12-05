//
//  ViewController.m
//  VideoOpenCV
//
//  Created by Bill on 10/21/16.
//  Copyright © 2016 Server Technology. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize videoCamera;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    self.videoCamera.delegate = self;
    
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetiFrame960x540;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
    
    [self.videoCamera start];
}

#pragma mark - UI Actions

- (IBAction)actionStart:(id)sender;
{
//    [self.videoCamera start];
    NSLog(@"video camera running: %d", [self.videoCamera running]);
    NSLog(@"capture session loaded: %d", [self.videoCamera captureSessionLoaded]);
}

#pragma mark - Protocol CvVideoCameraDelegate

- (void)processImage:(cv::Mat&)image
{
    cv::Mat input;
    cvtColor(image, input, CV_BGR2GRAY);
//    input = input(cv::Rect(40, 30, input.cols- 80, input.rows- 60));
    image = sobel(input, 30.);
}

cv::Mat negative(cv::Mat image, double threshold) {
    bitwise_not(image, image);
    return image;
}

cv::Mat hdr(cv::Mat image, double threshold) {
    cv::Mat hdrImage;
    cv::Ptr<cv::Retina> retina;
//    retina->applyFastToneMapping(image, hdrImage);
    return hdrImage;
}

cv::Mat fixExposure(cv::Mat image, double threshold) {
    double minVal; double maxVal; cv::Point minLoc; cv::Point maxLoc;
    cv::minMaxLoc( image, &minVal, &maxVal, &minLoc, &maxLoc, cv::Mat() );
    minVal = minVal + threshold;
    NSLog (@"minVal = %0f, maxVal = %0f", minVal, maxVal);

    for( int y = 0; y < image.rows; y++ ) {
        for( int x = 0; x < image.cols; x++ ) {
            image.at<uchar>(y,x) = (int) fmax(255*(double(image.at<uchar>(y,x)) - minVal) / (maxVal - minVal), 0) ;
        }
    }
    return image;
}

cv::Mat blur(cv::Mat image, double threshold) {
cv::Size size(3,3);
    cv::GaussianBlur(image,image,size,0);
    return image;
}

cv::Mat sobel(cv::Mat image, double threshold) {

cv::Mat grad_x, grad_y;
cv::Mat abs_grad_x, abs_grad_y;

/// Gradient X
int scale = 1;
int delta = 0;
int ddepth = CV_16S;
    cv::Sobel( image, grad_x, ddepth, 1, 0, 3, scale, delta, cv::BORDER_DEFAULT );
    convertScaleAbs( grad_x, abs_grad_x );

/// Gradient Y
    cv::Sobel( image, grad_y, ddepth, 0, 1, 3, scale, delta, cv::BORDER_DEFAULT );
    convertScaleAbs( grad_y, abs_grad_y );

/// Total Gradient (approximate)
    addWeighted( abs_grad_x, 0.5, abs_grad_y, 0.5, 0, image );
    return image;
}

cv::Mat scharr(cv::Mat image, double threshold) {
    
    cv::Mat grad_x, grad_y;
    cv::Mat abs_grad_x, abs_grad_y;
    int scale = 1;
    int delta = 0;
    int ddepth = CV_16S;
    
    /// Gradient X
    cv::Scharr( image, grad_x, ddepth, 1, 0, scale, delta, cv::BORDER_DEFAULT );
    convertScaleAbs( grad_x, abs_grad_x );
    
    /// Gradient Y
    Scharr( image, grad_y, ddepth, 0, 1, scale, delta, cv::BORDER_DEFAULT );
    convertScaleAbs( grad_y, abs_grad_y );
    
    /// Total Gradient (approximate)
    addWeighted( abs_grad_x, 0.5, abs_grad_y, 0.5, 0, image );
    return image;
}

cv::Mat adaptiveThreshold(cv::Mat image, double threshold) {
    adaptiveThreshold(image, image,255,CV_ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY,75,10);
    return image;
}

cv::Mat threshold(cv::Mat image, double threshold) {
    cv::threshold (image, image, 64, 255, cv::THRESH_BINARY);
    return image;
}


cv::Mat canny(cv::Mat image, double threshold) {

    cv::Canny( image, image, 100, 300, 3);
//    cv::dilate(image, image, cv::Mat(), window_corners[0].x);
    return image;
}

// void convertScaleAbs(InputArray src, OutputArray dst, double alpha=1, double beta=0)



@end
