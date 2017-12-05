//
//  ViewController.h
//  VideoOpenCV
//
//  Created by Bill on 10/21/16.
//  Copyright © 2016 Server Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
#include "opencv2/contrib/retina.hpp" // retina based algorithms
#import <opencv2/highgui/cap_ios.h>

@interface ViewController : UIViewController <CvVideoCameraDelegate>
{
    IBOutlet UIImageView* imageView;
    IBOutlet UIButton* button;
    
    CvVideoCamera* videoCamera;
}

- (IBAction)actionStart:(id)sender;

@property (nonatomic, strong) CvVideoCamera* videoCamera;

@end
