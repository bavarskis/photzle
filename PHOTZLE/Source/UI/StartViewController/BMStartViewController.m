//
//  BMStartViewController.m
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 28/07/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import "BMStartViewController.h"
#import "BMPuzzleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BMDifficultyLevel.h"
#import "UIImage+Resize.h"
#import "UIFont+defaultFonts.h"
#import "BMCropImageViewController.h"

#define BMStartScreenMenuButtonsHorizontalSpacing 45.0

NSString *const BMDifficultyLevelDefaultsKey = @"difficulty";

NSString *const BMChoosePicutreButtonLabelText = @"Library";
NSString *const BMTakePicureButtonLabelText = @"Camera";
NSString *const BMLevelButtonLabelText = @"Level";


@interface BMStartViewController () <BMPuzzleViewControllerDelegate, BMCropImageViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *choosePictureButton;
@property (nonatomic, weak) IBOutlet UIButton *takePictureButton;
@property (nonatomic, weak) IBOutlet UIButton *levelButton;

@property (nonatomic, weak) IBOutlet UILabel *choosePictureLabel;
@property (nonatomic, weak) IBOutlet UILabel *takePictureLabel;
@property (nonatomic, weak) IBOutlet UILabel *levelLabel;


@property (nonatomic, strong) BMDifficultyLevel *difficultyLevel;
@property (nonatomic, strong) NSData *defaultsDataWithLevelObject;
@property (nonatomic, strong) UIImage *level1ButtonImageNormal;
@property (nonatomic, strong) UIImage *level2ButtonImageNormal;
@property (nonatomic, strong) UIImage *level3ButtonImageNormal;

- (void)showCamera;
- (void)showImagePicker;
- (void)changeLevel;

@end

@implementation BMStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.difficultyLevel = [[BMDifficultyLevel alloc] init];
    [_difficultyLevel setLevelWithType:BMDifficultyLevelTypeBeginner];
    
    UIImage *libraryButtonImageNormal = [UIImage imageNamed:@"Library_.png"];
    UIImage *cameraButtonImageNormal = [UIImage imageNamed:@"Camera_.png"];
    
    self.level1ButtonImageNormal = [UIImage imageNamed:@"Level-1_.png"];
    self.level2ButtonImageNormal = [UIImage imageNamed:@"Level-2_.png"];
    self.level3ButtonImageNormal = [UIImage imageNamed:@"Level-3_.png"];
    
    
    [_takePictureButton addTarget:self action:@selector(showCamera) forControlEvents:UIControlEventTouchUpInside];
    [_takePictureButton setBackgroundImage:cameraButtonImageNormal forState:UIControlStateNormal];

    
    _takePictureLabel.font = [UIFont defaultBoldFontWithSize:12];
    _takePictureLabel.textAlignment = NSTextAlignmentCenter;
    _takePictureLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bluepixels.png"]];
    _takePictureLabel.backgroundColor = [UIColor clearColor];
    _takePictureLabel.text = BMTakePicureButtonLabelText;
    
    
    [_choosePictureButton addTarget:self action:@selector(showImagePicker) forControlEvents:UIControlEventTouchUpInside];
    [_choosePictureButton setBackgroundImage:libraryButtonImageNormal forState:UIControlStateNormal];
    
    _choosePictureLabel.font = [UIFont defaultBoldFontWithSize:12];
    _choosePictureLabel.textAlignment = NSTextAlignmentCenter;
    _choosePictureLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bluepixels.png"]];
    _choosePictureLabel.backgroundColor = [UIColor clearColor];
    _choosePictureLabel.text = BMChoosePicutreButtonLabelText;
    
    
    [_levelButton addTarget:self action:@selector(changeLevel) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    if ([defaults objectForKey:BMDifficultyLevelDefaultsKey]) {
        _defaultsDataWithLevelObject = [[NSUserDefaults standardUserDefaults] objectForKey:BMDifficultyLevelDefaultsKey];
        _difficultyLevel = [NSKeyedUnarchiver unarchiveObjectWithData:_defaultsDataWithLevelObject];
        
        switch (_difficultyLevel.difficultyLevelType) {
            case BMDifficultyLevelTypeBeginner:
                [_levelButton setBackgroundImage:_level1ButtonImageNormal forState:UIControlStateNormal];
                break;
            case BMDifficultyLevelTypeMedior:
                [_levelButton setBackgroundImage:_level2ButtonImageNormal forState:UIControlStateNormal];
                break;
            case BMDifficultyLevelTypeSenior:
                [_levelButton setBackgroundImage:_level3ButtonImageNormal forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    }
    else {
        [_levelButton setBackgroundImage:_level1ButtonImageNormal forState:UIControlStateNormal];
    }
    
    
    _levelLabel.font = [UIFont defaultBoldFontWithSize:12];
    _levelLabel.textAlignment = NSTextAlignmentCenter;
    _levelLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bluepixels.png"]];
    _levelLabel.backgroundColor = [UIColor clearColor];
    _levelLabel.text = BMLevelButtonLabelText;
    
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


#pragma mark
#pragma mark private methods

- (void)showImagePicker
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}


- (void)showCamera
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)changeLevel
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    
    // set one level higher
    if ([defaults objectForKey:BMDifficultyLevelDefaultsKey]) {
        
        _defaultsDataWithLevelObject = [[NSUserDefaults standardUserDefaults] objectForKey:BMDifficultyLevelDefaultsKey];
        _difficultyLevel = [NSKeyedUnarchiver unarchiveObjectWithData:_defaultsDataWithLevelObject];
    }

    [_difficultyLevel setLevelWithType:((_difficultyLevel.difficultyLevelType + 1) % BMDifficultyLevelNumberOfTypes)];
    
    _defaultsDataWithLevelObject = [NSKeyedArchiver archivedDataWithRootObject:_difficultyLevel];
    [defaults setObject:_defaultsDataWithLevelObject forKey:BMDifficultyLevelDefaultsKey];

    switch (_difficultyLevel.difficultyLevelType) {
        case BMDifficultyLevelTypeBeginner:
            [_levelButton setBackgroundImage:_level1ButtonImageNormal forState:UIControlStateNormal];
            break;
        case BMDifficultyLevelTypeMedior:
            [_levelButton setBackgroundImage:_level2ButtonImageNormal forState:UIControlStateNormal];
            break;
        case BMDifficultyLevelTypeSenior:
            [_levelButton setBackgroundImage:_level3ButtonImageNormal forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }

}

#pragma mark
#pragma mark ImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (image.size.width > self.view.bounds.size.width * 2 && image.size.height >  self.view.bounds.size.height * 2) {
        image = [[info objectForKey:UIImagePickerControllerOriginalImage] resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(self.view.bounds.size.width*2, self.view.bounds.size.height*2) interpolationQuality:kCGInterpolationHigh];
    }
    
    
    BMCropImageViewController *viewController = [[BMCropImageViewController alloc] initWithImage:image];
    viewController.delegate = self;
    [picker presentViewController:viewController animated:YES completion:nil];
}

#pragma mark
#pragma mark BMPuzzleViewControllerDelegate methods

- (void)cropImageViewController:(BMCropImageViewController *)viewController didCropImage:(UIImage *)image {
        BMPuzzleViewController *puzzleViewController = [[BMPuzzleViewController alloc] initWithImage:(UIImage *)image difficultyLevel:_difficultyLevel];
        puzzleViewController.delegate = self;
    [viewController presentViewController:puzzleViewController animated:YES completion:NULL];
}

#pragma mark
#pragma mark BMPuzzleViewControllerDelegate methods

- (void)puzzleViewControllerAttemptedNewPuzzle:(BMPuzzleViewController *)puzzleViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
 

@end
