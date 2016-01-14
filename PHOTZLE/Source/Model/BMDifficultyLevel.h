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

@interface BMDifficultyLevel : NSObject <NSCoding>

@property (nonatomic, readonly) NSDictionary *difficultyLevel;
@property (nonatomic, readonly) BMDifficultyLevelType difficultyLevelType;

- (void)setLevelWithType:(BMDifficultyLevelType)type;

@end
