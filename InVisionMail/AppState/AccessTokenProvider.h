//
//  AccessTokenProvider.h
//  InVisionMail
//
//  Created by Vojta Stavik on 14/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <Foundation/Foundation.h>

// Access provider is a box object, which encapsulates access to user managment logic.
// We use Google SDK to provide us with access token.
// You can use your own AccessTokenProvider if needed (i.e. for testing)

@protocol AccessTokenProvider <NSObject>
- (NSString* _Nullable) accessToken;
@end

@interface GoogleAccessTokenProvider : NSObject <AccessTokenProvider>
- (NSString* _Nullable) accessToken;
@end

