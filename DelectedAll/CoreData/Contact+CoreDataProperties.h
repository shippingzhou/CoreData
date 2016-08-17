//
//  Contact+CoreDataProperties.h
//  通讯录
//

//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Contact.h"

NS_ASSUME_NONNULL_BEGIN

@interface Contact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *phoneNum;
@property (nullable, nonatomic, retain) NSString *sectionName;
@property (nullable, nonatomic, retain) NSString *namePinYin;

@end

NS_ASSUME_NONNULL_END
