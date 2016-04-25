//
//  BMCropImageViewController.m
//  PHOTZLE
//
//  Created by Aurimas Bavarskis on 24/04/16.
//  Copyright © 2016 Bavarskis Media. All rights reserved.
//

#import "BMCropImageViewController.h"

@interface BMCropImageViewController () {
    UIImage *_selectedImage;
    UIImage *_croppedImage;
    
}
@property (weak, nonatomic) IBOutlet UIView *topMaskView;
@property (weak, nonatomic) IBOutlet UIView *bottomMaskView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation BMCropImageViewController


- (id)initWithImage:(UIImage *)image {
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        _selectedImage = image;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _topMaskView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    _bottomMaskView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    
    _imageView.image = _selectedImage;
    
    CGRect scrollViewRect = (CGRect)[_scrollView bounds];
    CGSize imageSize = (CGSize)[_selectedImage size];
    _imageView.bounds = CGRectMake(0, 0, MAX(scrollViewRect.size.width, imageSize.width), MAX(scrollViewRect.size.height, imageSize.height));
    _scrollView.contentSize = _selectedImage.size;
    [self.view layoutIfNeeded];
}
- (IBAction)didTapSaveButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(cropImageViewController:didCropImage:)]) {
        [_delegate cropImageViewController:self didCropImage:_selectedImage];
    }
}

@end
