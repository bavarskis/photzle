//
//  BMDifficultyLevel.h
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 18/08/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BMDifficultyLevelType) {
    BMDifficultyLevelTypeBeginner = 0,
    BMDifficultyLevelTypeMedior = 1,
    BMDifficultyLevelTypeSenior = 2,
    BMDifficultyLevelNumberOfTypes = 3
};

extern NSString *const BMDifficultyLevelCellHorizontalKey;
extern NSString *const BMDifficultyLevelCellVerticalKey;

// It's a legacy class from release 1.0 when horizontal and vertical num of cells was different
// and a custom object for users defaults was necessary
@interface BMDifficultyLevel : NSObject <NSCoding>

@property (nonatomic, readonly) NSDictionary *difficultyLevel;
@property (nonatomic, readonly) BMDifficultyLevelType difficultyLevelType;

- (void)setLevelWithType:(BMDifficultyLevelType)type;

@end
