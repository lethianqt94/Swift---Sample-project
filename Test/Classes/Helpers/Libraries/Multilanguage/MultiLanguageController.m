//
//  MultiLanguageController.m
//  MultiLanguageDemo
//
//  Created by Thien pd on 6/19/15.
//  Copyright (c) 2015 GG. All rights reserved.
//

#import "MultiLanguageController.h"


@interface MultiLanguageController ()


@end

@implementation MultiLanguageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventListenerDidReceiveNotification:)
                                                 name:_FMLDidChangeLanguage
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_FMLDidChangeLanguage object:nil];
}

#pragma mark - Notification
- (void)eventListenerDidReceiveNotification:(NSNotification *)notification
{
}

@end
