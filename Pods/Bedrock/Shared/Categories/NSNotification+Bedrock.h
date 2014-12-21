//
//  NSNotification+Bedrock.h
//  timecop
//
//  Created by Nick Bolton on 6/24/12.
//  Copyright (c) 2012 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotification (Bedrock)

- (NSArray *)allManagedObjectUpdates;
- (NSSet *)insertedManagedObjects;
- (NSSet *)updatedManagedObjects;
- (NSSet *)refreshedManagedObjects;
- (NSSet *)deletedManagedObjects;

- (NSArray *)allManagedObjectsOfType:(Class)type;
- (NSArray *)insertedManagedObjectsOfType:(Class)type;
- (NSArray *)updatedManagedObjectsOfType:(Class)type;
- (NSArray *)refreshedManagedObjectsOfType:(Class)type;
- (NSArray *)deletedManagedObjectsOfType:(Class)type;

- (BOOL)insertedManagedObjectsContainsType:(Class)type;
- (BOOL)updatedManagedObjectsContainsType:(Class)type;
- (BOOL)refreshedManagedObjectsContainsType:(Class)type;
- (BOOL)deletedManagedObjectsContainsType:(Class)type;
- (BOOL)allManagedObjectsContainsType:(Class)type;

@end
