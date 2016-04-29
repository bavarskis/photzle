//
//  BMAboutViewController.m
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 18/09/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import "BMAboutViewController.h"
#import "UIFont+defaultFonts.h"
#import <MessageUI/MessageUI.h>

#define BMAboutTopInset 30
#define BMAboutLeftInset 30
#define BMAboutBottomInset 20
#define BMAboutRightInset 30
#define BMAboutExtraInset 10

NSString *const BMAboutViewControllerTitle = @"About";

NSString *const BMAboutAlertTitle = @"Whoops...";
NSString *const BMAboutAlertMessageBavarskis = @"Your device is not configured for sending emails. Send a message to info@bavarskismedia.com using another email client.";
NSString *const BMAboutAlertMessageGeritz = @"Your device is not configured for sending emails. Send a message to thijsgeritz@icloud.com using another email client.";

NSString *const BMAboutEmailBavarskis = @"info@bavarskismedia.com";
NSString *const BMAboutEmailGeritz = @"thijsgeritz@icloud.com";

NSString *const BMAboutWebBavarskis = @"http://bavarskismedia.com";
NSString *const BMAboutWebGeritz = @"http://www.thijsgeritz.nl";

NSString *const BMAboutTitleTextBavarskis = @"Development by Aurimas Bavarskis.";
NSString *const BMAboutDescriptionTextBavarskis = @"A developer working on various projects ranging from iOS apps to multi-platform applications, such as educational games and audio-visual installations.";
NSString *const BMAboutTitleTextGeritz = @"Graphic Design by Thijs Geritz.";
NSString *const BMAboutDescriptionTextGeritz = @"A Dutch designer who's work varies from graphic design and illustration to video-art and sound.";

NSString *const BMAboutEmailButtonTitle = @"Email";
NSString *const BMAboutWebButtonTitle = @"Website";
NSString *const BMAboutVersionText = @"Photzle v.1.0.1 - © 2013";
NSString *const BMAboutPhotographyContributionText = @"Original photo by Frédérique Voisin-Demery";



@interface BMAboutViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic,strong) UILabel *bavarskisTitleLabel;
@property (nonatomic,strong) UILabel *bavarskisDescriptionLabel;
@property (nonatomic,strong) UIButton *bavarskisEmailButton;
@property (nonatomic,strong) UIButton *bavarskisWebsiteButton;
@property (nonatomic,strong) UILabel *geritzTitleLabel;
@property (nonatomic,strong) UILabel *geritzDescriptionLabel;
@property (nonatomic,strong) UIButton *geritzEmailButton;
@property (nonatomic,strong) UIButton *geritzWebsiteButton;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *photographyContributionLabel;


- (void)backButtonWasTapped;
- (void)emailBavarskis;
- (void)goToBavarskisWeb;
- (void)emailGeritz;
- (void)goToGeritzWeb;

@end

@implementation BMAboutViewController

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
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton addTarget:self action:@selector(backButtonWasTapped) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"Back_.png"] forState:UIControlStateNormal];
    [_backButton sizeToFit];
    _backButton.frame = CGRectMake(BMAboutLeftInset, BMAboutTopInset, _backButton.frame.size.width, _backButton.frame.size.height);
    [self.view addSubview:_backButton];
    
    self.logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Photzle_logo.png"]];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    //_logoImageView.backgroundColor = [UIColor greenColor];
    [_logoImageView sizeToFit];
    _logoImageView.frame = CGRectMake(0, 0, self.view.frame.size.width - _backButton.frame.size.width - (BMAboutLeftInset + BMAboutRightInset), _logoImageView.frame.size.height);
    
    _logoImageView.center = _backButton.center;
    _logoImageView.frame = CGRectOffset(_logoImageView.frame, _backButton.frame.size.width/2 +_logoImageView.frame.size.width/2, 0);
    [self.view addSubview:_logoImageView];
    
    
    /// Bavarskis info
    
    self.bavarskisTitleLabel = [[UILabel alloc] init];
    _bavarskisTitleLabel.textAlignment = NSTextAlignmentLeft;
    _bavarskisTitleLabel.numberOfLines = 0;
    _bavarskisTitleLabel.text = BMAboutTitleTextBavarskis;
    _bavarskisTitleLabel.font = [UIFont defaultBoldFontWithSize:14];
    _bavarskisTitleLabel.textColor = [UIColor blackColor];
    _bavarskisTitleLabel.frame = CGRectMake(BMAboutLeftInset, _backButton.frame.origin.y + _backButton.frame.size.height + 40, self.view.frame.size.width - (BMAboutLeftInset + BMAboutRightInset + BMAboutExtraInset), 0);
    [_bavarskisTitleLabel sizeToFit];
    [self.view addSubview:_bavarskisTitleLabel];
    
    self.bavarskisDescriptionLabel = [[UILabel alloc] init];
    _bavarskisDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    _bavarskisDescriptionLabel.numberOfLines = 0;
    _bavarskisDescriptionLabel.text = BMAboutDescriptionTextBavarskis;
    _bavarskisDescriptionLabel.font = [UIFont defaultRegularFontWithSize:14];
    _bavarskisDescriptionLabel.textColor = [UIColor blackColor];
    _bavarskisDescriptionLabel.frame = CGRectMake(BMAboutLeftInset, _bavarskisTitleLabel.frame.origin.y + _bavarskisTitleLabel.frame.size.height, self.view.frame.size.width - (BMAboutLeftInset + BMAboutRightInset + BMAboutExtraInset), 0);
    [_bavarskisDescriptionLabel sizeToFit];
    [self.view addSubview:_bavarskisDescriptionLabel];
    
    self.bavarskisEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bavarskisEmailButton addTarget:self action:@selector(emailBavarskis) forControlEvents:UIControlEventTouchUpInside];
    _bavarskisEmailButton.titleLabel.font = [UIFont defaultBoldFontWithSize:14];
    [_bavarskisEmailButton setTitle:BMAboutEmailButtonTitle forState:UIControlStateNormal];
    [_bavarskisEmailButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_bavarskisEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bavarskisEmailButton setImage:[UIImage imageNamed:@"Small_email_icon_.png"] forState:UIControlStateNormal];
    [_bavarskisEmailButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [_bavarskisEmailButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [_bavarskisEmailButton setFrame:CGRectMake(BMAboutLeftInset, _bavarskisDescriptionLabel.frame.origin.y + _bavarskisDescriptionLabel.frame.size.height + 10, 80, 24)];
    [self.view addSubview:_bavarskisEmailButton];
    
    self.bavarskisWebsiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bavarskisWebsiteButton addTarget:self action:@selector(goToBavarskisWeb) forControlEvents:UIControlEventTouchUpInside];
    _bavarskisWebsiteButton.titleLabel.font = [UIFont defaultBoldFontWithSize:14];
    [_bavarskisWebsiteButton setTitle:BMAboutWebButtonTitle forState:UIControlStateNormal];
    [_bavarskisWebsiteButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_bavarskisWebsiteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bavarskisWebsiteButton setImage:[UIImage imageNamed:@"Small_website_icon_.png"] forState:UIControlStateNormal];
    [_bavarskisWebsiteButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [_bavarskisWebsiteButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [_bavarskisWebsiteButton setFrame:CGRectMake(_bavarskisEmailButton.frame.origin.x + _bavarskisEmailButton.frame.size.width + 10, _bavarskisEmailButton.frame.origin.y, 100, 24)];
    [self.view addSubview:_bavarskisWebsiteButton];
    
    
    /// Geritz info
    
    self.geritzTitleLabel = [[UILabel alloc] init];
    _geritzTitleLabel.textAlignment = NSTextAlignmentLeft;
    _geritzTitleLabel.numberOfLines = 0;
    _geritzTitleLabel.text = BMAboutTitleTextGeritz;
    _geritzTitleLabel.font = [UIFont defaultBoldFontWithSize:14];
    _geritzTitleLabel.textColor = [UIColor blackColor];
    _geritzTitleLabel.frame = CGRectMake(BMAboutLeftInset, _bavarskisEmailButton.frame.origin.y + _bavarskisEmailButton.frame.size.height + 30, self.view.frame.size.width - (BMAboutLeftInset + BMAboutRightInset + BMAboutExtraInset), 0);
    [_geritzTitleLabel sizeToFit];
    [self.view addSubview:_geritzTitleLabel];
    
    self.geritzDescriptionLabel = [[UILabel alloc] init];
    _geritzDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    _geritzDescriptionLabel.numberOfLines = 0;
    _geritzDescriptionLabel.text = BMAboutDescriptionTextGeritz;
    _geritzDescriptionLabel.font = [UIFont defaultRegularFontWithSize:14];
    _geritzDescriptionLabel.textColor = [UIColor blackColor];
    _geritzDescriptionLabel.frame = CGRectMake(BMAboutLeftInset, _geritzTitleLabel.frame.origin.y + _geritzTitleLabel.frame.size.height, self.view.frame.size.width - (BMAboutLeftInset + BMAboutRightInset + BMAboutExtraInset), 0);
    [_geritzDescriptionLabel sizeToFit];
    [self.view addSubview:_geritzDescriptionLabel];
    
    self.geritzEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_geritzEmailButton addTarget:self action:@selector(emailGeritz) forControlEvents:UIControlEventTouchUpInside];
    _geritzEmailButton.titleLabel.font = [UIFont defaultBoldFontWithSize:14];
    [_geritzEmailButton setTitle:BMAboutEmailButtonTitle forState:UIControlStateNormal];
    [_geritzEmailButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_geritzEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_geritzEmailButton setImage:[UIImage imageNamed:@"Small_email_icon_.png"] forState:UIControlStateNormal];
    [_geritzEmailButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [_geritzEmailButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [_geritzEmailButton setFrame:CGRectMake(BMAboutLeftInset, _geritzDescriptionLabel.frame.origin.y + _geritzDescriptionLabel.frame.size.height + 10, 80, 24)];
    [self.view addSubview:_geritzEmailButton];
    
    self.geritzWebsiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_geritzWebsiteButton addTarget:self action:@selector(goToGeritzWeb) forControlEvents:UIControlEventTouchUpInside];
    _geritzWebsiteButton.titleLabel.font = [UIFont defaultBoldFontWithSize:14];
    [_geritzWebsiteButton setTitle:BMAboutWebButtonTitle forState:UIControlStateNormal];
    [_geritzWebsiteButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_geritzWebsiteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_geritzWebsiteButton setImage:[UIImage imageNamed:@"Small_website_icon_.png"] forState:UIControlStateNormal];
    [_geritzWebsiteButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [_geritzWebsiteButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [_geritzWebsiteButton setFrame:CGRectMake(_geritzEmailButton.frame.origin.x + _geritzEmailButton.frame.size.width + 10, _geritzEmailButton.frame.origin.y, 100, 24)];
    [self.view addSubview:_geritzWebsiteButton];
    
    

    
    self.photographyContributionLabel = [[UILabel alloc] init];
    _photographyContributionLabel.textAlignment = NSTextAlignmentLeft;
    _photographyContributionLabel.numberOfLines = 1;
    _photographyContributionLabel.text = BMAboutPhotographyContributionText;
    _photographyContributionLabel.font = [UIFont defaultRegularFontWithSize:10];
    _photographyContributionLabel.textColor = [UIColor blackColor];
    [_photographyContributionLabel sizeToFit];
    _photographyContributionLabel.frame = CGRectMake(BMAboutLeftInset, self.view.bounds.size.height - BMAboutBottomInset - _photographyContributionLabel.frame.size.height, self.view.frame.size.width - (BMAboutLeftInset + BMAboutRightInset), _photographyContributionLabel.frame.size.height);
    [self.view addSubview:_photographyContributionLabel];
    
    // Version info
    
    self.versionLabel = [[UILabel alloc] init];
    _versionLabel.textAlignment = NSTextAlignmentLeft;
    _versionLabel.numberOfLines = 1;
    _versionLabel.text = BMAboutVersionText;
    _versionLabel.font = [UIFont defaultRegularFontWithSize:12];
    _versionLabel.textColor = [UIColor blackColor];
    [_versionLabel sizeToFit];
    _versionLabel.frame = CGRectMake(BMAboutLeftInset, self.view.bounds.size.height - BMAboutBottomInset - _versionLabel.frame.size.height - _photographyContributionLabel.frame.size.height, self.view.frame.size.width - (BMAboutLeftInset + BMAboutRightInset), _versionLabel.frame.size.height);
    [self.view addSubview:_versionLabel];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


#pragma mark -
#pragma mark - Private methods

- (void)backButtonWasTapped
{
    [_delegate didTapAboutViewControllerBackButton:self];

}

- (void)emailBavarskis
{
    if ([MFMailComposeViewController canSendMail])
    {

        NSString *emailTitle = @"Photzle user";
        // Email Content
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:BMAboutEmailBavarskis];
        
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setSubject:emailTitle];
        [mailComposer setToRecipients:toRecipents];
        [mailComposer setMessageBody:@"Hi Aurimas, " isHTML:NO];
        
        // Present mail view controller on screen
        [self presentViewController:mailComposer animated:YES completion:NULL];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:BMAboutAlertTitle message:BMAboutAlertMessageBavarskis preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}


- (void)goToBavarskisWeb
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:BMAboutWebBavarskis]];
}


- (void)emailGeritz
{
    if ([MFMailComposeViewController canSendMail])
    {
         
        NSString *emailTitle = @"Photzle user";
        // Email Content
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:BMAboutEmailGeritz];
        
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setSubject:emailTitle];
        [mailComposer setToRecipients:toRecipents];
        [mailComposer setMessageBody:@"Hello Thijs, " isHTML:NO];
        
        // Present mail view controller on screen
        [self presentViewController:mailComposer animated:YES completion:NULL];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:BMAboutAlertTitle message:BMAboutAlertMessageGeritz preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {}];
        
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)goToGeritzWeb
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:BMAboutWebGeritz]];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
