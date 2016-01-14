//
//  BMImageWithIndex.h
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 17/08/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BMImageWithIndex : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSUInteger index;

@end
