//
//  JSONLoadable.h
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol JSONLoadable <NSObject>

- (NSString *) objectId;
- (void) loadData: (NSDictionary*)jsonData;

@end
