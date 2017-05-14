//
//  FXMultiLanguage.h
//  FXMultiLanguage
//
//  Created by Tien Le Phuong on 7/17/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _FMLUserSetting                 @"_FMLUserSetting"
#define _FMLDefaultLanguage             @"en"

#define _FMLListSupport                 @"_FMLListSupport"
#define _FMLListLanguageName            @"_FMLListLanguageName"

#define _FMLDidChangeLanguage           @"_FMLDidChangeLanguage"

@interface FXMultiLanguage : NSObject

//property

@property (nonatomic) BOOL isLanguageLoaded;

@property (nonatomic, strong) NSString          *languageName;
@property (nonatomic, strong) NSString          *languageType;
@property (nonatomic, strong) NSString          *languageFile;
@property (nonatomic, strong) NSString          *languageFilePath;

@property (nonatomic, strong) NSMutableArray    *listSupport;
@property (nonatomic, strong) NSMutableArray    *listLanguageName;

@property (nonatomic, strong) NSDictionary      *languageDic;

//method
- (void) loadLanguageWithLanguage:(NSString*)language;

- (NSString*) getLanguageWithType:(NSString*)type;
- (NSString*) getTypeWithLanguage:(NSString*)language;

- (NSString*) stringLocaleWithString:(NSString*)string;

- (BOOL) isSupportWithLanguageType:(NSString*)language;

- (void) addNewLanguage:(NSString*)name type:(NSString*)type;
- (void) addNewLanguage:(NSString*)name type:(NSString*)type data:(NSData*)data;

//funtion
NSString* FMLStringLocale(NSString *string);

// instance
+ (FXMultiLanguage*)sharedFXMultiLanguage;

//class method
+ (void) loadLanguage;
+ (NSString*) stringLocaleWithString:(NSString*)string;
+ (void) changeLanguageWithType:(NSString*)type;
+ (void) changeLanguageWithLanguage:(NSString*)language;
+ (void) changeLanguageWithContryCode:(NSString *)countryCode;

+ (NSString *)deviceUUID;

@end
