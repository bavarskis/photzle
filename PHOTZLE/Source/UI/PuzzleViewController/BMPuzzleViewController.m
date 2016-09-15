//
//  BMPuzzleViewController.m
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 28/07/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import "BMPuzzleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSMutableArray+Shuffling.h"
#import "BMPopUpMenuView.h"
#import "BMStartViewController.h"
#import "BMFloatingMenuPopperView.h"
#import <QuartzCore/CATransform3D.h>
#import <QuartzCore/CALayer.h>
#import "BMAboutViewController.h"
#import "BMPuzzleCollectionViewCell.h"
#import "BMPuzzleCollectionViewLayout.h"

NSString *const BMPuzzleViewControllerCellIdentifier = @"BMPuzzleViewControllerCellIdentifier";

@interface BMPuzzleViewController () <UIScrollViewDelegate, UICollectionViewDelegate, BMPopUpMenuViewDelegate, BMFloatingMenuPopperViewDelegate, BMAboutViewControllerDelegate, BMPuzzleCollectionViewCellDelegate>

@property (nonatomic, strong) UIImage *puzzleImage;
@property (nonatomic, strong) BMDifficultyLevel *level;
@property (nonatomic, assign) NSUInteger numberOfRows;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) BMPopUpMenuView *popUpMenuCongratulation;
@property (nonatomic, strong) BMPopUpMenuView *popUpMenuRegular;
@property (nonatomic, strong) BMFloatingMenuPopperView *menuPopperView;

@property BOOL cellIsSelected;
@property BOOL correctPatternFound;
@property NSInteger selectedCell;

@property (nonatomic, strong) NSMutableArray *croppedImages;
@property (nonatomic, strong) UIImage *shareImage;


- (void)updateUI;
- (UIImage*)croppedImage:(UIImage*)image cropRect:(CGRect)rect;
- (void)reshuffleGridAnimated:(BOOL)animated;
- (void)finishPuzzle;
- (void)menuPopperViewMoved:(id)sender withEvent:(UIEvent *)event;
- (void)setShareImageWithView:(UIView *)view;

- (void)animateView:(UIView*)view fromScale:(CGFloat)from toScale:(CGFloat)to bounce:(CGFloat)bounce;

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

- (id)initWithImage:(UIImage *)image difficultyLevel:(BMDifficultyLevel *)level {
    
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.level = level;
        self.puzzleImage = image;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // Level
    {
        NSNumber *numHorCellsObject = [_level.difficultyLevel objectForKey:BMDifficultyLevelCellHorizontalKey];
        NSNumber *numVerCellsObject = [_level.difficultyLevel objectForKey:BMDifficultyLevelCellVerticalKey];
        _numberOfRows = MIN([numHorCellsObject integerValue], [numVerCellsObject integerValue]);
    }
    
    self.croppedImages = [[NSMutableArray alloc] init];
    [self createCroppedImages];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BMPuzzleCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:BMPuzzleViewControllerCellIdentifier];
    
    BMPuzzleCollectionViewLayout *layout = (BMPuzzleCollectionViewLayout *)self.collectionView.collectionViewLayout;
    layout.numberOfRows = _numberOfRows;
    self.collectionView.collectionViewLayout = layout;

    
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
    [self.collectionView addSubview:_menuPopperView];
    
    
    // Shuffle the grid
    [self performSelector:@selector(reshuffleGridAnimated:) withObject:nil afterDelay:1];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateUI];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    // Return YES for supported orientations
    return YES;
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


#pragma mark
#pragma mark private methods

- (void)updateUI {
    if (_popUpMenuCongratulation) {
        _popUpMenuCongratulation.center = _collectionView.center;
    }
    
    if (_popUpMenuRegular) {
        _popUpMenuRegular.center = _collectionView.center;
    }
    
    if (_menuPopperView) {
        _menuPopperView.frame = CGRectMake(20, 20, _menuPopperView.frame.size.width, _menuPopperView.frame.size.height);
    }
}


- (UIImage*)croppedImage:(UIImage *)image cropRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return newImage;
}

- (void)createCroppedImages {
    NSInteger totalTiles = 0;
    NSInteger verticalRow = 0;
    while (verticalRow < _numberOfRows) {
        NSInteger horizontalRow = 0;
        while (horizontalRow < _numberOfRows) {
            
            CGFloat width = _puzzleImage.size.width / _numberOfRows;
            CGFloat height = _puzzleImage.size.height / _numberOfRows;
            
            CGRect imageRect = CGRectMake(width * horizontalRow, height * verticalRow, width, height);
            _croppedImages[totalTiles] = [self croppedImage:_puzzleImage cropRect:imageRect];
            
            totalTiles++;
            horizontalRow++;
        }
        verticalRow++;
    }
}

- (void)reshuffleGridAnimated:(BOOL)animated {
    [(BMPuzzleCollectionViewLayout *)self.collectionView.collectionViewLayout shuffleCollectionViewCellsWithCompletion:^{
        
    }];
}


- (void)finishPuzzle
{
    _popUpMenuCongratulation.center = _collectionView.center;
    _popUpMenuCongratulation.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        _menuPopperView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        _menuPopperView.hidden = YES;
    }];
    
    _correctPatternFound = YES;
    [self animateView:_popUpMenuCongratulation fromScale:0.8 toScale:1.0 bounce:1.1];
    
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
    
    if (center.x > _collectionView.frame.origin.x + _menuPopperView.frame.size.width/2 &&
        center.x < _collectionView.frame.size.width - _menuPopperView.frame.size.width/2 &&
        center.y>_collectionView.frame.origin.y + _menuPopperView.frame.size.height/2 &&
        center.y < _collectionView.frame.size.height - _menuPopperView.frame.size.height/2) {
        
        control.center = center;
    }
    
    
}

- (void)setShareImageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.shareImage = img;
}

#pragma mark
#pragma mark BMPopUpMenuDelegate

- (void)didTapShareButton:(BMPopUpMenuView *)popUpMenu {
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

- (void)didTapMakeNewPuzzleButton:(BMPopUpMenuView *)popUpMenu {
    if ([_delegate respondsToSelector:@selector(puzzleViewControllerAttemptedNewPuzzle:)]) {
        _popUpMenuCongratulation.hidden = YES;
        _popUpMenuRegular.hidden = YES;
        _menuPopperView.hidden = YES;
        [_delegate puzzleViewControllerAttemptedNewPuzzle:self];
    }
}

- (void)didTapOKButton:(BMPopUpMenuView *)popUpMenu {
    _popUpMenuCongratulation.hidden = YES;
    _popUpMenuRegular.hidden = YES;
    
    _menuPopperView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        _menuPopperView.layer.opacity = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didTapAboutButton:(BMPopUpMenuView *)popUpView {
    BMAboutViewController *aboutViewController = [[BMAboutViewController alloc] init];
    aboutViewController.delegate = self;
    aboutViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:aboutViewController animated:YES completion:nil];
    
}


#pragma mark
#pragma mark BMFloatingMenuPopperViewDelegate

- (void)didTapMenuPopper:(BMFloatingMenuPopperView *)popperView {
    if (_popUpMenuRegular.hidden && _popUpMenuCongratulation.hidden) {
        _popUpMenuRegular.center = _collectionView.center;
        _popUpMenuRegular.hidden = NO;
        
        [UIView animateWithDuration:0.2 animations:^{
            _menuPopperView.layer.opacity = 0;
        } completion:^(BOOL finished) {
            _menuPopperView.hidden = YES;
        }];
        
        [self animateView:_popUpMenuRegular fromScale:0.8 toScale:1.0 bounce:1.1];
    }
    else {
        _popUpMenuRegular.hidden = YES;
    }
    
}

#pragma mark
#pragma mark BMAboutViewControllerDelegate methods

- (void)didTapAboutViewControllerBackButton:(BMAboutViewController *)aboutViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self updateUI];
}

#pragma mark
#pragma mark UICollectionViewDatasource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _numberOfRows * _numberOfRows;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BMPuzzleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BMPuzzleViewControllerCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.imageView.image = _croppedImages[indexPath.item];
    cell.index = indexPath.item;
    cell.delegate = self;
    
    return cell;
}

#pragma mark
#pragma mark UICollectionViewDatasource methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}



#pragma mark
#pragma mark Helpers

- (void)animateView:(UIView*)view fromScale:(CGFloat)from toScale:(CGFloat)to bounce:(CGFloat)bounce {
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


#pragma mark
#pragma BMPuzzleCollectionViewCellDelegate

- (void)didLongPressCollectionViewCell:(BMPuzzleCollectionViewCell *)cell sender:(UILongPressGestureRecognizer *)sender {
    [(BMPuzzleCollectionViewLayout *)self.collectionView.collectionViewLayout didLongPressCollectionViewCell:cell inView:self.view sender:sender completion:^{
        //
    }];
}


@end
