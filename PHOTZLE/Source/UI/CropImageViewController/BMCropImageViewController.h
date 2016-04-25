//
//  BMCropImageViewController.h
//  PHOTZLE
//
//  Created by Aurimas Bavarskis on 24/04/16.
//  Copyright © 2016 Bavarskis Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMCropImageViewController;

@protocol BMCropImageViewControllerDelegate <NSObject>

- (void)cropImageViewController:(BMCropImageViewController *)viewController didCropImage:(UIImage *)image;

@end

@interface BMCropImageViewController : UIViewController

@property (nonatomic, readonly) UIImage *croppedImage;
@property (nonatomic, weak) id <BMCropImageViewControllerDelegate> delegate;

- (id)initWithImage:(UIImage *)image;

@end
