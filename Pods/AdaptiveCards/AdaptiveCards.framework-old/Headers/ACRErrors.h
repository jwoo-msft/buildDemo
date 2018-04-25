//
//  ACRErrors
//  ACRErrors.h
//
//  Copyright © 2017 Microsoft. All rights reserved.
//

extern NSString *const ACRInputErrorDomain;
extern NSString *const ACRParseErrorDomain;

typedef NS_ENUM(NSUInteger, ACRInputError)
{
    ACRInputErrorValueMissing,
    ACRInputErrorLessThanMin,
    ACRInputErrorGreaterThanMax,
    ACRInputErrorLessThanMinDate,
    ACRInputErrorGreaterThanMaxDate,
};
