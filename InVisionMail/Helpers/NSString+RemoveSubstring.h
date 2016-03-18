//
//  NSString+RemoveSubstring.h
//  InVisionMail
//
//  Created by Vojta Stavik on 18/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RemoveSubstring)

- (nullable NSString*) removeSubstringBetweenStartString: (NSString* _Nonnull)startString
                                            andEndString: (NSString* _Nonnull) endString
                                       includeBoundaries: (BOOL) includeBoundaries;

@end
