//
//  FXMultiLanguage.m
//  FXMultiLanguage
//
//  Created by Tien Le Phuong on 7/17/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "FXMultiLanguage.h"

@implementation FXMultiLanguage

#pragma mark - instance

- (id)init
{
    self = [super init];
    if (self) {
        
        [self listSupport];
        [self listLanguageName];
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:_FMLListSupport]) {
            [self addNewLanguage:@"" type:@""];
        }
    }
    return self;
}

- (void)dealloc
{
    
}

+ (FXMultiLanguage*)sharedFXMultiLanguage
{
    static FXMultiLanguage *sharedFXMultiLanguage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFXMultiLanguage = [[self alloc] init];
    });
    return sharedFXMultiLanguage;
}

#pragma mark - Getter
- (NSMutableArray*) listSupport
{
    if (!_listSupport) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:_FMLListSupport]) {
            NSArray *tempArray = [[[NSUserDefaults standardUserDefaults] objectForKey:_FMLListSupport] componentsSeparatedByString:@"~"];
            
            _listSupport = [[NSMutableArray alloc] initWithArray:tempArray];
            
        } else {
            _listSupport = [[NSMutableArray alloc] initWithArray:@[@"en",
                                                                   @"cn",
                                                                   ]];
        }
        
        
        
    }
    
    return _listSupport;
}

- (NSMutableArray*) listLanguageName
{
    if (!_listLanguageName) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:_FMLListLanguageName]) {
            NSArray *tempArray = [[[NSUserDefaults standardUserDefaults] objectForKey:_FMLListLanguageName] componentsSeparatedByString:@"~"];
            
            _listLanguageName = [[NSMutableArray alloc] initWithArray:tempArray];
            
        } else {
            _listLanguageName = [[NSMutableArray alloc] initWithArray:@[@"English",
                                                                        @"Chinese",
                                                                        ]];
        }
    }
    
    return _listLanguageName;
}

#pragma mark - Private Method
- (BOOL) isSupportWithLanguageType:(NSString*)language
{
    for (NSString *str in self.listSupport) {
        if ([str isEqualToString:language]) {
            return YES;
        }
    }
    
    return NO;
}



- (void) saveSettingLanguageWithLanguage:(NSString*)language
{
    self.languageType = language;
    self.languageName = [self getLanguageWithType:language];
    
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:_FMLUserSetting];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)documentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    return documentsDirectoryPath;
}

- (void) loadDataWithType:(NSString*)type
{
    //set file name
    self.languageFile = [NSString stringWithFormat:@"locale.%@",type];
    
    //set file path in Bundle
    self.languageFilePath   = [[NSBundle mainBundle] pathForResource:@"locale" ofType:self.languageType];
    
    NSData *data            = [NSData dataWithContentsOfFile:self.languageFilePath];
    if (data) {
        self.languageDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //NSLog(@"self.languageDic: %@",self.languageDic);
    } else {
        //get file in document
        self.languageFilePath = [NSString stringWithFormat:@"%@/locale.%@",[self documentsDirectoryPath], self.languageType];
        
        NSData *data            = [NSData dataWithContentsOfFile:self.languageFilePath];
        
        if (data) {
            self.languageDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        } else {
            //error
            [self loadLanguageWithLanguage:_FMLDefaultLanguage];
            return;
        }
    }
    
    self.isLanguageLoaded = YES;
    
    // post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:_FMLDidChangeLanguage object:nil userInfo:nil];
}


#pragma mark - Public Method
- (void) loadLanguageWithLanguage:(NSString*)language
{
    
    if ([self isSupportWithLanguageType:language]) {
        [self saveSettingLanguageWithLanguage:language];
    } else {
        [self saveSettingLanguageWithLanguage:_FMLDefaultLanguage];
    }
    
    //load data
    [self loadDataWithType:language];
    
}

- (NSString*) getLanguageWithType:(NSString*)type
{
    NSString *name = @"";
    
    for (int i = 0; i < [self.listSupport count]; i++) {
        if ([type isEqualToString:self.listSupport[i]]) {
            return self.listLanguageName[i];
        }
    }
    
    return  name;
}

- (NSString*) getTypeWithLanguage:(NSString*)language
{
    NSString *name = _FMLDefaultLanguage;
    
    for (int i = 0; i < [self.listLanguageName count]; i++) {
        if ([language isEqualToString:self.listLanguageName[i]]) {
            return self.listSupport[i];
        }
    }
    return  name;
}

- (NSString*) stringLocaleWithString:(NSString*)string
{
    NSString *value = [self.languageDic objectForKey:string];
    
//    if (!value || [value isEqualToString:@""]) {
    if (!value) {
        return string;
    }
    
    return value;
}

- (void) addNewLanguage:(NSString*)name type:(NSString*)type
{
    if (![name isEqualToString:@""] && ![type isEqualToString:@""]) {
        [self.listLanguageName addObject:name];
        [self.listSupport addObject:type];
    }
    
    //save NSUserDefault
    NSString *temp = @"";
    
    for (int i = 0; i < [_listSupport count]; i++) {
        if (i==0) {
            temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%@",_listSupport[i]]];
        } else {
            temp = [temp stringByAppendingString:[NSString stringWithFormat:@"~%@",_listSupport[i]]];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:temp forKey:_FMLListSupport];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    temp = @"";
    
    for (int i = 0; i < [_listLanguageName count]; i++) {
        if (i==0) {
            temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%@",_listLanguageName[i]]];
        } else {
            temp = [temp stringByAppendingString:[NSString stringWithFormat:@"~%@",_listLanguageName[i]]];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:temp forKey:_FMLListLanguageName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

- (void) addNewLanguage:(NSString*)name type:(NSString*)type data:(NSData*)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSString *fileName = [NSString stringWithFormat:@"locale.%@",type];
        
        // Generate the file path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *dataPath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
                
        // Save it into file system
        [data writeToFile:dataPath atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addNewLanguage:name type:type];
            [self loadLanguageWithLanguage:type];
        });

        
    });
    
}

#pragma mark - Function
NSString* FMLStringLocale(NSString *string)
{
    return [FXMultiLanguage stringLocaleWithString:string];
}


#pragma mark - Class method
+ (void) loadLanguage
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:_FMLUserSetting]) {
        [[FXMultiLanguage sharedFXMultiLanguage] loadLanguageWithLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:_FMLUserSetting]];
    } else {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        [[FXMultiLanguage sharedFXMultiLanguage] loadLanguageWithLanguage:language];
    }
}

+ (NSString*) stringLocaleWithString:(NSString*)string
{
    if (![FXMultiLanguage sharedFXMultiLanguage].isLanguageLoaded) {
        [FXMultiLanguage loadLanguage];
    }
    
    return [[FXMultiLanguage sharedFXMultiLanguage] stringLocaleWithString:string];
}

+ (void) changeLanguageWithType:(NSString*)type
{
    
    [[FXMultiLanguage sharedFXMultiLanguage] loadLanguageWithLanguage:type];
}

+ (void) changeLanguageWithLanguage:(NSString*)language
{
   [[FXMultiLanguage sharedFXMultiLanguage] loadLanguageWithLanguage:[[FXMultiLanguage sharedFXMultiLanguage] getTypeWithLanguage:language]];
}


+ (void) changeLanguageWithContryCode:(NSString *)countryCode{
    if ([countryCode isEqualToString:@"cn"]) { // Chinese
        [self changeLanguageWithLanguage:@"Chinese"];
    }else{
        [self changeLanguageWithLanguage:@"English"];
    }
}


+ (NSString *)deviceUUID
{
  if([[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] bundleIdentifier]])
    return [[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] bundleIdentifier]];
  
  @autoreleasepool {
    
    CFUUIDRef uuidReference = CFUUIDCreate(nil);
    CFStringRef stringReference = CFUUIDCreateString(nil, uuidReference);
    NSString *uuidString = (__bridge NSString *)(stringReference);
    [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:[[NSBundle mainBundle] bundleIdentifier]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    CFRelease(uuidReference);
    CFRelease(stringReference);
    return uuidString;
  }
}

@end
