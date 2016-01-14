//
//  BMPuzzleViewController.m
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 28/07/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import "BMPuzzleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BMImageView.h"
#import "NSMutableArray+Shuffling.h"
#import "BMImageWithIndex.h"
#import "BMPopUpMenuView.h"
#import "BMStartViewController.h"
#import "BMFloatingMenuPopperView.h"
#import <QuartzCore/CATransform3D.h>
#import <QuartzCore/CALayer.h>
#import "BMAboutViewController.h"



@interface BMPuzzleViewController () <UIScrollViewDelegate, BMImageViewDelegate, BMPopUpMenuViewDelegate, BMFloatingMenuPopperViewDelegate, BMAboutViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) BMPopUpMenuView *popUpMenuCongratulation;
@property (nonatomic, strong) BMPopUpMenuView *popUpMenuRegular;
@property (nonatomic, strong) BMFloatingMenuPopperView *menuPopperView;

@property BOOL statusBarHidden;
@property BOOL cellIsSelected;
@property BOOL correctPatternFound;
@property NSInteger selectedCell;
@property (nonatomic, assign) CGFloat statusBarHeight;
@property (nonatomic, assign) CGFloat puzzleImageAspectRatio;
@property (nonatomic, assign) CGFloat containerViewAspectRatio;

@property (nonatomic, strong) NSMutableArray *croppedImages;
@property (nonatomic, strong) NSMutableArray *cellImageViews;

@property (nonatomic, strong) UIImage *shareImage;


- (BOOL)isPortrait:(UIImage*)image;
- (void)prepareForOrientation:(UIInterfaceOrientation)orientation;
- (UIImage*)croppedImage:(UIImage*)image cropRect:(CGRect)rect;
- (void)createGridInSuperview:(UIView*)view;
- (void)updateGridWithRect:(CGRect)rect;
- (void)reshuffleGridAnimated:(id)animated;
- (void)finishPuzzle;
- (void)animateView:(UIView*)view fromScale:(CGFloat)from toScale:(CGFloat)to bounce:(CGFloat)bounce;
- (void)menuPopperViewMoved:(id)sender withEvent:(UIEvent *)event;
- (void)setShareImageWithView:(UIView *)view;

@end

@implementation BMPuzzleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.level = [[BMDifficultyLevel alloc] init];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _statusBarHidden = YES;
    if (_statusBarHidden) {
        self.view.bounds = [[UIScreen mainScreen] bounds];
    }
    
    _puzzleImageAspectRatio = _puzzleImage.size.width / _puzzleImage.size.height;
    self.croppedImages = [[NSMutableArray alloc] init];
    self.cellImageViews = [[NSMutableArray alloc] init];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    self.popUpMenuCongratulation = [[BMPopUpMenuView alloc] initWithFrame:CGRectMake(0, 0, BMPopUpMenuViewWidth, BMPopUpMenuViewHeight) menuType:BMPopUpMenuTypeCongratulation];
    _popUpMenuCongratulation.delegate = self;
    _popUpMenuCongratulation.hidden = YES;
    [self.view addSubview:_popUpMenuCongratulation];
    
    self.popUpMenuRegular = [[BMPopUpMenuView alloc] initWithFrame:CGRectMake(0, 0, BMPopUpMenuViewWidth, BMPopUpMenuViewHeight) menuType:BMPopUpMenuTypeRegular];
    _popUpMenuRegular.delegate = self;
    _popUpMenuRegular.hidden = YES;
    [self.view addSubview:_popUpMenuRegular];
    
    
    // this view is inserted after the grid is created
    self.menuPopperView = [[BMFloatingMenuPopperView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    _menuPopperView.delegate = self;
    [_menuPopperView addTarget:self action:@selector(menuPopperViewMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    CGRect containerViewRect = _scrollView.frame;
    _containerViewAspectRatio = containerViewRect.size.width / containerViewRect.size.height;
    
    // aspect fit
    if (_containerViewAspectRatio > _puzzleImageAspectRatio) {
        containerViewRect = CGRectMake(0, 0, _puzzleImage.size.width * containerViewRect.size.height / _puzzleImage.size.height, containerViewRect.size.height);
    }
    else {
        containerViewRect = CGRectMake(0, 0, containerViewRect.size.width, _puzzleImage.size.height * containerViewRect.size.width / _puzzleImage.size.width);
    }
    
    containerViewRect.origin.y = (self.scrollView.bounds.size.height - containerViewRect.size.height) / 2;
    
    self.containerView  = [[UIView alloc] initWithFrame:containerViewRect];
    _containerView.backgroundColor = [UIColor whiteColor];
    //_containerView.layer.borderColor = [UIColor blackColor].CGColor;
    //_containerView.layer.borderWidth = 1;
    _containerView.clipsToBounds = NO;
    
    [_scrollView addSubview:_containerView];
    
    [self createGridInSuperview:_containerView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self prepareForOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    // Return YES for supported orientations
    return YES;
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


#pragma mark
#pragma mark private methods


- (BOOL)isPortrait:(UIImage *)image
{
    if (image.size.width > image.size.height) {
        return NO;
    }
    else {
        return YES;
    }
    
}

- (void)prepareForOrientation:(UIInterfaceOrientation)orientation
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    //screen.size.height = screen.size.height - _statusBarHeight;
    CGRect portraitRect = screen;
    CGRect landscapeRect = CGRectMake(portraitRect.origin.x, portraitRect.origin.y, portraitRect.size.height + _statusBarHeight, portraitRect.size.width - _statusBarHeight);
    
    _scrollView.frame = UIDeviceOrientationIsLandscape(orientation) ? landscapeRect : portraitRect;
    
    CGRect containerViewRect = _scrollView.frame;
    _containerViewAspectRatio = containerViewRect.size.width / containerViewRect.size.height;
    
    // aspect fit
    // rs > ri ? (wi * hs/hi, hs) : (ws, hi * ws/wi)
    if (_containerViewAspectRatio > _puzzleImageAspectRatio) {
        containerViewRect = CGRectMake(0, 0, _puzzleImage.size.width * containerViewRect.size.height / _puzzleImage.size.height, containerViewRect.size.height);
    }
    else {
        containerViewRect = CGRectMake(0, 0, containerViewRect.size.width, _puzzleImage.size.height * containerViewRect.size.width / _puzzleImage.size.width);
    }
    
    _containerView.frame = containerViewRect;
    _containerView.center = _scrollView.center;
    _scrollView.contentSize = _containerView.frame.size;
    
    
    if (_popUpMenuCongratulation) {
        _popUpMenuCongratulation.center = _scrollView.center;
    }
    
    if (_popUpMenuRegular) {
        _popUpMenuRegular.center = _scrollView.center;
    }
    
    if (_menuPopperView) {
        _menuPopperView.frame = CGRectMake(20, 20, _menuPopperView.frame.size.width, _menuPopperView.frame.size.height);
    }
    
    [self updateGridWithRect:_containerView.frame];
}


- (UIImage*)croppedImage:(UIImage *)image cropRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return newImage;
}

- (void)createGridInSuperview:(UIView *)view
{
    NSNumber *numHorCellsObject = [_level.difficultyLevel objectForKey:BMDifficultyLevelCellHorizontalKey];
    NSNumber *numVerCellsObject = [_level.difficultyLevel objectForKey:BMDifficultyLevelCellVerticalKey];
    
    NSUInteger numHorCells = [self isPortrait:_puzzleImage] ? [numHorCellsObject integerValue] : [numVerCellsObject integerValue];
    NSUInteger numVerCells = [self isPortrait:_puzzleImage] ? [numVerCellsObject integerValue] : [numHorCellsObject integerValue];
    
    NSUInteger cellNum = 0;
    for (int i = 0; i < numVerCells; i++) {
        for (int j = 0; j < numHorCells; j++) {
            CGRect cellRect = CGRectMake(j * (view.frame.size.width / numHorCells), i * (view.frame.size.height / numVerCells), view.frame.size.width / numHorCells, view.frame.size.height / numVerCells);
            BMImageView *imageView = [[BMImageView alloc] initWithFrame:cellRect];
            imageView.delegate = self;
            [imageView setIndex:cellNum];
            imageView.userInteractionEnabled = NO;
            imageView.layer.borderWidth = 1;
            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            
            CGRect cellImageRect = CGRectMake(j * (_puzzleImage.size.width / numHorCells), i * (_puzzleImage.size.height / numVerCells), _puzzleImage.size.width / numHorCells, _puzzleImage.size.height / numVerCells);
            
            BMImageWithIndex *imageWithIndex = [[BMImageWithIndex alloc] init];
            imageWithIndex.image = [self croppedImage:_puzzleImage cropRect:cellImageRect];
            imageWithIndex.index = cellNum;
            [_croppedImages addObject:imageWithIndex];
            
            imageView.image = (UIImage*)[[_croppedImages objectAtIndex:cellNum] image];
            [_cellImageViews addObject:imageView];
            
            
            [_containerView addSubview:[_cellImageViews objectAtIndex:cellNum]];
            cellNum++;
        }
    }
    
    [_scrollView insertSubview:_menuPopperView aboveSubview:_scrollView];
    
    BOOL animated = YES;
    NSNumber *passedValue = [NSNumber numberWithBool:animated];
    [self performSelector:@selector(reshuffleGridAnimated:) withObject:passedValue afterDelay:2.5];
}


- (void)updateGridWithRect:(CGRect)rect
{
    NSNumber *numHorCellsObject = [_level.difficultyLevel objectForKey:BMDifficultyLevelCellHorizontalKey];
    NSNumber *numVerCellsObject = [_level.difficultyLevel objectForKey:BMDifficultyLevelCellVerticalKey];
    
    NSUInteger numHorCells = [self isPortrait:_puzzleImage] ? [numHorCellsObject integerValue] : [numVerCellsObject integerValue];
    NSUInteger numVerCells = [self isPortrait:_puzzleImage] ? [numVerCellsObject integerValue] : [numHorCellsObject integerValue];
    
    
    NSUInteger numCells = 0;
    for (int i = 0; i < numVerCells; i++) {
        for (int j = 0; j < numHorCells; j++) {
            CGRect cellRect = CGRectMake(j * (rect.size.width / numHorCells), i * (rect.size.height / numVerCells), rect.size.width / numHorCells, rect.size.height / numVerCells);
            ((BMImageView*)[_cellImageViews objectAtIndex:numCells]).frame = cellRect;
            numCells++;
        }
    }
}

- (void)reshuffleGridAnimated:(id)animated
{
    [_croppedImages shuffle];
    
    if ([animated integerValue]==1) {
        [_cellImageViews enumerateObjectsUsingBlock:^(BMImageView *imageView, NSUInteger idx, BOOL *stop) {
            
            imageView.userInteractionEnabled = YES;
            [UIView transitionWithView:imageView
                              duration:0.5f
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^{
                                imageView.image = (UIImage*)[[_croppedImages objectAtIndex:idx] image];
                            } completion:NULL];
        }];
    }
    else {
        [_cellImageViews enumerateObjectsUsingBlock:^(BMImageView *imageView, NSUInteger idx, BOOL *stop) {
            imageView.image = (UIImage*)[[_croppedImages objectAtIndex:idx] image];
        }];
    }
    _correctPatternFound = NO;
    [NSThread detachNewThreadSelector:@selector(setShareImageWithView:) toTarget:self withObject:_containerView];
}


- (void)finishPuzzle
{
    _popUpMenuCongratulation.center = _scrollView.center;
    _popUpMenuCongratulation.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        _menuPopperView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        _menuPopperView.hidden = YES;
    }];
    
    [_cellImageViews enumerateObjectsUsingBlock:^(BMImageView *imageView, NSUInteger idx, BOOL *stop) {
        imageView.userInteractionEnabled = NO;
    }];
    
    _correctPatternFound = YES;
    [self animateView:_popUpMenuCongratulation fromScale:0.8 toScale:1.0 bounce:1.1];
    
}


- (void)animateView:(UIView*)view fromScale:(CGFloat)from toScale:(CGFloat)to bounce:(CGFloat)bounce
{
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.duration = 0.2;
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(from, from, 1.0)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(bounce, bounce, 1.0)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(to, to, 1.0)]];
    scaleAnimation.keyTimes = @[@0.0, @0.7, @1.0];
    scaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [view.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
}

- (void)menuPopperViewMoved:(id)sender withEvent:(UIEvent *)event
{
    UIControl *control = sender;
    
    UITouch *t = [[event allTouches] anyObject];
    CGPoint pPrev = [t previousLocationInView:control];
    CGPoint p = [t locationInView:control];
    
    CGPoint center = control.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    
    if (center.x > _scrollView.frame.origin.x + _menuPopperView.frame.size.width/2 &&
        center.x < _scrollView.frame.size.width - _menuPopperView.frame.size.width/2 &&
        center.y>_scrollView.frame.origin.y + _menuPopperView.frame.size.height/2 &&
        center.y < _scrollView.frame.size.height - _menuPopperView.frame.size.height/2) {
        control.center = center;
    }
    
    
}


- (void)setShareImageWithView:(UIView *)view
{
    @autoreleasepool {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        self.shareImage = img;
        
    }
}


#pragma mark
#pragma mark BMImageViewDelegate methods

- (void)imageViewWasTapped:(BMImageView *)imageView
{
    //        [self finishPuzzle];
    //        return;
    
    if (_cellIsSelected) {
        if (_selectedCell != imageView.index) {
            
            UIImage *tempImage = imageView.image;
            imageView.image = ((BMImageWithIndex*)[_croppedImages objectAtIndex:_selectedCell]).image;
            //            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            //            imageView.layer.borderWidth = 1;
            
            ((BMImageView*)[_cellImageViews objectAtIndex:_selectedCell]).image = tempImage;
            ((BMImageView*)[_cellImageViews objectAtIndex:_selectedCell]).layer.borderColor = [UIColor whiteColor].CGColor;
            ((BMImageView*)[_cellImageViews objectAtIndex:_selectedCell]).layer.borderWidth = 1;
            
            [_croppedImages exchangeObjectAtIndex:imageView.index withObjectAtIndex:_selectedCell];
            
            imageView.layer.opacity = 0.6;
            [UIView animateWithDuration:0.2 animations:^{
                imageView.layer.opacity = 1;
            }];
            
        }
        else {
            // deselect the same cell
            imageView.layer.borderWidth = 1;
            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            
        }
        
        _cellIsSelected = NO;
    }
    else {
        _cellIsSelected = YES;
        imageView.layer.borderWidth = 4;
        imageView.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bluepixels.png"]].CGColor;
        
    }
    _selectedCell = imageView.index;
    
    NSUInteger index = 0;
    
    NSNumber *numHorCellsObject = [_level.difficultyLevel objectForKey:BMDifficultyLevelCellHorizontalKey];
    NSNumber *numVerCellsObject = [_level.difficultyLevel objectForKey:BMDifficultyLevelCellVerticalKey];
    
    NSUInteger numHorCells = [self isPortrait:_puzzleImage] ? [numHorCellsObject integerValue] : [numVerCellsObject integerValue];
    NSUInteger numVerCells = [self isPortrait:_puzzleImage] ? [numVerCellsObject integerValue] : [numHorCellsObject integerValue];
    
    NSUInteger numCells = numVerCells * numHorCells;
    for (BMImageWithIndex *imageWithIndex in _croppedImages) {
        if (imageWithIndex.index != index ) {
            return;
        }
        else if (index == numCells - 1) {
            [self finishPuzzle];
            return;
        }
        
        index++;
    }
}


#pragma mark
#pragma mark BMPopUpMenuDelegate

- (void)shareButtonWasTapped:(BMPopUpMenuView *)popUpMenu
{
    NSString *shareText;
    
    if (_correctPatternFound) {
        shareText = @"Yey, I solved a Photzle! Wanna try yourself?";
    }
    else {
        shareText = @"I am solving a Photzle...";
    }
    
    NSURL *shareURL = [NSURL URLWithString:@"https://itunes.apple.com/app/id695501133"];
    
    
    NSArray *items   = [NSArray arrayWithObjects:
                        shareText,
                        _shareImage,
                        shareURL, nil];
    
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [activityViewController setValue:shareText forKey:@"subject"];
    
    activityViewController.excludedActivityTypes =   @[UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypePostToWeibo,
                                                       UIActivityTypeSaveToCameraRoll,
                                                       UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypeMessage,
                                                       UIActivityTypeAssignToContact,
                                                       UIActivityTypePrint];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)makeNewPuzzleButtonWasTapped:(BMPopUpMenuView *)popUpMenu
{
    if ([_delegate respondsToSelector:@selector(puzzleViewControllerAttemptedNewPuzzle:)]) {
        _popUpMenuCongratulation.hidden = YES;
        _popUpMenuRegular.hidden = YES;
        _menuPopperView.hidden = YES;
        [_delegate puzzleViewControllerAttemptedNewPuzzle:self];
    }
}

- (void)OKButtonWasTapped:(BMPopUpMenuView *)popUpMenu
{
    _popUpMenuCongratulation.hidden = YES;
    _popUpMenuRegular.hidden = YES;
    _containerView.userInteractionEnabled = YES;
    
    _menuPopperView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        _menuPopperView.layer.opacity = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)aboutButtonWasTapped:(BMPopUpMenuView *)popUpView
{
    BMAboutViewController *aboutViewController = [[BMAboutViewController alloc] init];
    aboutViewController.delegate = self;
    aboutViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:aboutViewController animated:YES completion:nil];
    
}


#pragma mark
#pragma mark BMFloatingMenuPopperViewDelegate

- (void)menuPopperWasTapped:(BMFloatingMenuPopperView *)popperView
{
    if (_popUpMenuRegular.hidden && _popUpMenuCongratulation.hidden) {
        _popUpMenuRegular.center = _scrollView.center;
        _popUpMenuRegular.hidden = NO;
        
        [UIView animateWithDuration:0.2 animations:^{
            _menuPopperView.layer.opacity = 0;
        } completion:^(BOOL finished) {
            _menuPopperView.hidden = YES;
        }];
        
        _containerView.userInteractionEnabled = NO;
        [self animateView:_popUpMenuRegular fromScale:0.8 toScale:1.0 bounce:1.1];
    }
    else {
        _popUpMenuRegular.hidden = YES;
    }
    
}

#pragma mark
#pragma mark BMAboutViewControllerDelegate methods

- (void)aboutViewControllerBackButtonWasTapped:(BMAboutViewController *)aboutViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self prepareForOrientation:orientation];
}

@end
