//
//  EPCoreDataManager.m
//  Northrend
//
//  Created by ddong on 14-9-25.
//  Copyright (c) 2014年 ddong. All rights reserved.
//

#import "EPNewsDataManager.h"
#import "EPNewsManagedObject.h"
@implementation EPNewsDataManager
#pragma mark - Some Fucking URL
-(NSURL *) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark - Some Fucking Dustin Method
-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext)
    {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}
-(NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    if (_persistentStoreCoordinator)
    {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EPDataModel.xcdatamodeld.sqlite"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    return _persistentStoreCoordinator;
}
-(NSManagedObjectModel*)managedObjectModel
{
    if (_managedObjectModel)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EPDataModel.xcdatamodeld" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
-(void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error FUCK DUSTIN");
            abort();
        }
    }
}
#pragma mark - Some strange method about find alter update
-(NSMutableArray*) getAllObjectFromDatabase
{
    NSManagedObjectContext *selfContext = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"sEPNews" inManagedObjectContext:selfContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    NSError *error = nil;
    NSMutableArray *listData = [[selfContext executeFetchRequest:request error:&error] mutableCopy];
    return listData;
}

-(int)insertObjectIntoDatabase:(EPNewsManagedObject*) sourceEntity
{
    NSManagedObjectContext *selfContext = [self managedObjectContext];
    EPUserManagedObject *targetObject = [NSEntityDescription insertNewObjectForEntityForName:@"EPNews" inManagedObjectContext:selfContext];
    [targetObject setValue:[sourceEntity imageURL] forKey:@"imageURL"];
    [targetObject setValue:[sourceEntity title] forKey:@"title"];
    [targetObject setValue:[sourceEntity subtitle] forKey:@"subtitle"];
    [targetObject setValue:[sourceEntity writer] forKey:@"writer"];
    [targetObject setValue:[sourceEntity content] forKey:@"content"];
    [targetObject setValue:[sourceEntity address] forKey:@"address"];
    return 0;
}
@end
