//
//  BMCropImageViewController.m
//  PHOTZLE
//
//  Created by Aurimas Bavarskis on 24/04/16.
//  Copyright © 2016 Bavarskis Media. All rights reserved.
//

#import "BMCropImageViewController.h"
#import "UIImage+Resize.h"

@interface BMCropImageViewController () {
    UIImage *_selectedImage;
    UIImage *_croppedImage;
    CGSize _imageSize;
    BOOL _isImagePortrait;
}
@property (weak, nonatomic) IBOutlet UIView *topMaskView;
@property (weak, nonatomic) IBOutlet UIView *bottomMaskView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic, assign) BOOL viewsDidLayout;

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
    
    _imageView.translatesAutoresizingMaskIntoConstraints = YES;
    _imageView.image = _selectedImage;
}

- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (!self.viewsDidLayout) {
        CGRect scrollViewRect = (CGRect)[_scrollView bounds];
        _imageSize = (CGSize)[_selectedImage size];
        _isImagePortrait = _imageSize.width <= _imageSize.height;
        CGFloat aspecRatio = _imageSize.width / _imageSize.height;
        
        CGSize imageViewSize;
        if (_isImagePortrait) {
            imageViewSize = CGSizeMake(scrollViewRect.size.width, scrollViewRect.size.height / aspecRatio);
        }
        else {
            imageViewSize = CGSizeMake(scrollViewRect.size.width * aspecRatio, scrollViewRect.size.height);
        }
        
        _imageView.frame = CGRectMake(0, 0, imageViewSize.width, imageViewSize.height);
        _scrollView.contentSize = _imageView.frame.size;
    }
    
    self.viewsDidLayout = YES;
}

- (IBAction)didTapSaveButton:(id)sender {
    
    CGFloat mappedOffset;
    CGRect cropRect;
    if (_isImagePortrait) {
        mappedOffset = (_imageSize.height / _scrollView.contentSize.height) * _scrollView.contentOffset.y;
        cropRect = CGRectMake(0, mappedOffset, _imageSize.width, _imageSize.width);
    }
    else {
        mappedOffset = (_imageSize.width / _scrollView.contentSize.width) * _scrollView.contentOffset.x;
        cropRect = CGRectMake(mappedOffset, 0, _imageSize.height, _imageSize.height);
    }
    
    _croppedImage = [_selectedImage croppedImageWithRect:cropRect];
    
    if ([_delegate respondsToSelector:@selector(cropImageViewController:didCropImage:)]) {
        [_delegate cropImageViewController:self didCropImage:_croppedImage];
    }
}

@end
