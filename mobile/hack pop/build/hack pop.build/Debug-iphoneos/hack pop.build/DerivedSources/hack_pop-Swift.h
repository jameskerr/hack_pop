// Generated by Apple Swift version 3.0 (swiftlang-800.0.46.2 clang-800.0.38)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import Foundation;
@import ObjectiveC;
@import CoreGraphics;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIWindow;
@class UIApplication;
@class NSManagedObjectModel;
@class NSPersistentStoreCoordinator;
@class NSManagedObjectContext;

SWIFT_CLASS("_TtC8hack_pop11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow * _Nullable window;
- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> * _Nullable)launchOptions;
- (void)applicationWillResignActive:(UIApplication * _Nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * _Nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * _Nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;
- (void)applicationWillTerminate:(UIApplication * _Nonnull)application;
@property (nonatomic, copy) NSURL * _Nonnull applicationDocumentsDirectory;
@property (nonatomic, strong) NSManagedObjectModel * _Nonnull managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator * _Nonnull persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext * _Nonnull managedObjectContext;
- (void)saveContext;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class PointsRetainer;
@class NSAttributedString;
@class UITableViewCell;

SWIFT_CLASS("_TtC8hack_pop12HackPopStyle")
@interface HackPopStyle : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) PointsRetainer * _Nonnull pointRetainer;)
+ (PointsRetainer * _Nonnull)pointRetainer;
+ (NSAttributedString * _Nonnull)UnderlinedText:(NSString * _Nonnull)string fontSize:(CGFloat)fontSize;
+ (NSAttributedString * _Nonnull)NormalText:(NSString * _Nonnull)string fontSize:(CGFloat)fontSize;
+ (UITableViewCell * _Nonnull)GetStyledPointSelectionCell:(id _Nonnull)pointValue;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UIStoryboardSegue;
@class UIStackView;
@class UITableView;
@class UILabel;
@class UIButton;
@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC8hack_pop18HomeViewController")
@interface HomeViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIStackView * _Null_unspecified titleViewContainer;
@property (nonatomic, weak) IBOutlet UIStackView * _Null_unspecified notifyViewContainer;
@property (nonatomic, weak) IBOutlet UIStackView * _Null_unspecified topStoriesContainerView;
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified topStoriesTable;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified topStoriesLabel;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified storyThresholdButton;
@property (nonatomic, readonly, strong) PointsRetainer * _Nonnull pointRetainer;
- (void)viewDidLoad;
@property (nonatomic, readonly) UIInterfaceOrientationMask supportedInterfaceOrientations;
- (void)didReceiveMemoryWarning;
@property (nonatomic, readonly) UIStatusBarStyle preferredStatusBarStyle;
- (IBAction)revealPointSelectionVC:(id _Nonnull)sender;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC8hack_pop25PointSelectViewController")
@interface PointSelectViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tableView;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified pointSelectionCloseButton;
@property (nonatomic, readonly, strong) PointsRetainer * _Nonnull pointRetainer;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
@property (nonatomic, readonly) UIInterfaceOrientationMask supportedInterfaceOrientations;
@property (nonatomic, readonly) UIStatusBarStyle preferredStatusBarStyle;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (IBAction)closePointSelection:(id _Nonnull)sender;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC8hack_pop19PointSelectionSegue")
@interface PointSelectionSegue : UIStoryboardSegue
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull SegueId;)
+ (NSString * _Nonnull)SegueId;
@property (nonatomic, readonly) CGFloat yTitleTopOffset;
@property (nonatomic, readonly) NSTimeInterval animationDuration;
- (void)perform;
- (void)open;
- (void)close;
- (nonnull instancetype)initWithIdentifier:(NSString * _Nullable)identifier source:(UIViewController * _Nonnull)source destination:(UIViewController * _Nonnull)destination OBJC_DESIGNATED_INITIALIZER;
@end

@class NSArray;
@class NSUserDefaults;

SWIFT_CLASS("_TtC8hack_pop14PointsRetainer")
@interface PointsRetainer : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, strong) PointsRetainer * _Nullable _instance;)
+ (PointsRetainer * _Nullable)_instance;
+ (void)set_instance:(PointsRetainer * _Nullable)value;
+ (PointsRetainer * _Nonnull)instance;
@property (nonatomic, readonly, strong) NSArray * _Nonnull pointSelectionValues;
@property (nonatomic, readonly) NSInteger initialDefaultValue;
- (NSInteger)initialDefaultValue SWIFT_METHOD_FAMILY(none);
@property (nonatomic, readonly, strong) NSUserDefaults * _Nonnull defaults;
@property (nonatomic) NSInteger value;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop