//
//  AppState.h
//  InVisionMail
//
//  Created by Vojta Stavik on 14/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccessTokenProvider.h"

@interface AppState : NSObject

// Token provider for the sharedState instance is set only for the first time you call it. Other calls with different provider are ignored.
+ (_Nonnull instancetype) createSharedStateWithTokenProvider: (id<AccessTokenProvider> _Nonnull) provider;
+ (_Nonnull instancetype) sharedState;

- (_Nonnull instancetype) initWithTokenProvider: (NSObject<AccessTokenProvider> * _Nonnull) provider;

@property (nonatomic, readonly) NSString* _Nullable currentUserToken;
@property (nonatomic, readonly, strong) NSObject<AccessTokenProvider>* _Nonnull tokenProvider;

@end
