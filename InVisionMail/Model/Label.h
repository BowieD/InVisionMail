//
//  Label.h
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "JSONLoadable.h"

static NSString* const _Nonnull MAILBOXES_CATEGORY = @"mailboxes";
static NSString* const _Nonnull GROUPS_CATEGORY = @"groups";

@interface Label : NSManagedObject <JSONLoadable>

@property (nullable, nonatomic, copy) NSString *customId;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *category;

@property (nonatomic) int16_t order;

@end
