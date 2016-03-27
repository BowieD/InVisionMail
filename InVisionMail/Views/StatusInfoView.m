//
//  StatusInfoLabel.m
//  InVisionMail
//
//  Created by Vojta Stavik on 26/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "StatusInfoView.h"
#import "UIFont+AppFonts.h"
#import "UIColor+AppColors.h"

@interface StatusInfoView ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation StatusInfoView

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Preferences
static NSString* loadingString = @"Loading ...";
static NSString* errorString = @"Ups, something went wrong ...";


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadNib];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self loadNib];
    }
    return self;
}

- (void) loadNib {
    UIView* nibView = [[[NSBundle mainBundle] loadNibNamed:@"StatusInfoView" owner:self options:nil] firstObject];
    [nibView setTranslatesAutoresizingMaskIntoConstraints:NO];
    nibView.backgroundColor = [UIColor clearColor];
    [self addSubview:nibView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[nibView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(nibView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nibView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(nibView)]];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [[UIColor invision_darkGrayColor] colorWithAlphaComponent:0.8];
    
    self.titleLabel.font = [UIFont regularTextFont_Bold];
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.descriptionLabel.font = [UIFont regularTextFont_Regular];
    self.descriptionLabel.textColor = [UIColor whiteColor];
    
    self.activityIndicator.hidesWhenStopped = YES;
    
    // Default state is hidden
    self.hidden = YES;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Actions

- (void) loading {
    [self show];
    self.titleLabel.text = loadingString;
    self.descriptionLabel.text = nil;
    [self.activityIndicator startAnimating];
}

- (void) success {
    [self.activityIndicator stopAnimating];
    [self hide];
}

- (void) error: ( NSError* _Nullable ) error {
    [self show];
    [self.activityIndicator stopAnimating];
    
    self.titleLabel.text = errorString;
    self.descriptionLabel.text = error.localizedDescription;
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:3];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Animations

- (void) show {
    if (self.hidden) {
        self.alpha = 0;
        self.hidden = NO;
    }
    
    [UIView animateWithDuration:0.33 animations:^{
        self.alpha = 1;
    } completion:nil];
}

- (void) hide {
    if (self.hidden) {
        return;
    }
    
    [UIView animateWithDuration:0.33 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}


@end
