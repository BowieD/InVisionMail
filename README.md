# InVision Mail

#### General project info
- BundleID: com.vojtastavik.InVisionMail
- Language: Objective-C
- Deployment target: iOS 8
- Devices: Universal (iPhone + iPad)

---

![iPad screenshot](/ipad-screenshot.png)

---

### Current state
#### Implemented features:
- [x] Support for all device orientations
- [x] Support for **iPhone** and **iPad**
- [x] Sign in with a real Gmail account,
- [x] Data persistence,
- [x] Fetch newest messages from Inbox (max. 100 messages),
- [x] Fetch mailboxes and groups from the Gmail account, show them in the drawer,
- [x] Show messages in threads (only for already fetched messages)
- [x] Support for text/plain messages only

#### Known issues:
- **Read-Only access.** You can't create/reply or even change read/unread state of the message
- Messages without text/plain format cause activity indicator spinning for ever in the message detail view
- Message detail view activity indicator keeps spinning when network request fails


#### Next steps:
- [ ] Remember user between app starts
- [ ] Filter messages in the main feed by the selected Label
- [ ] Implement HTML format for messages
- [ ] Pull to refresh
- [ ] Better message detail fetching

---

#### Project structure

#### Dependency management
We use [Carthage](https://github.com/Carthage/Carthage) for dependency management. You can install Carthage with Homebrew using the following command:
```
$ brew update
$ brew install carthage
```
Then you should run:
```
carthage update --platform iOS
```


##### Tests
- We use [Kiwi](https://github.com/kiwi-bdd/Kiwi) for testing.
- Use principles of Behaviour Driven Development, when possible.

##### Model
- Use CoreData for the model layer.
- Entities have primary identifier 'customId'. This identifier is unique within the entities of the same type:
```
if: 
	(entityA.type == entityB.type) && 
	(entityA.customId == entityB.customID) 
then: 
	entityA == entityB
```
- Use helper functions for creating new entities:
```
+ (nullable instancetype) findOrCreateElementWithId: (NSString* _Nonnull) customId context: (NSManagedObjectContext* _Nonnull)context;

+ (void) loadFromJSON: (NSDictionary* _Nullable)JSONData customId:(NSString* _Nonnull) objectId
                                                  context: (NSManagedObjectContext* _Nonnull)context
                                          completionBlock: (nullable void (^)(NSManagedObject * _Nullable element))completion;
```

##### Controllers
- All view controllers should be in the **Controllers** group.
- Try to keep controllers short, lightweight and well structured.
- Use generic ```TableViewDataSource``` where possible.
- Use Storyboards for managing segues and app flow if possible.
 

##### Views
- Views are usually created using combination of XIB files and code. 
- If possible, autolayout and basic structure is set up solely using IB.
- Appearance details (i.e. font, colors) are set in code because of better reusability and maintainability.

##### Networking
- If possible, no direct data transfers should be done from Networking layer to controllers.
- Networking layer should save changes to CoreData stack and controllers will be notified about the change from the Model layer.

##### AppState
- Try to keep all user state related data in the AppState class  (except CoreData).


##### Appearance
- All fonts and colors used within the app should be listed in
```UIFont+AppFonts.h``` and ```UIColor+AppColors.h```.
- If you want reuse some custom UIView behaviour (i.e. circle view), create subclass of UIView with this behaviour. Set this subclass in IB to related views.


---

### Author
**Vojta Stavik** </br>
[vojtastavik.com](http://vojtastavik.com) </br>
[@vojtastavik](https://twitter.com/vojtastavik) </br>
[stavik@outlook.com](mailto:stavik@outlook.com)

