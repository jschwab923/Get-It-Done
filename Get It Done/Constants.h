//
//  Constants.h
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#ifndef Get_It_Done_Constants_h
#define Get_It_Done_Constants_h

#define REUSE_DESCRIPTION @"DescriptionCell"
#define REUSE_TASK_INFO_HEADER @"TaskInfoHeader"
#define REUSE_ADD_SUBTASK_FOOTER @"AddSubTaskFooter"
#define REUSE_TITLE_POINTS @"TitlePointsCell"
#define REUSE_PROOF @"ProofCell"
#define REUSE_PARTNER_FOOTER @"PartnerFooter"
#define REUSE_PROOF_HEADER @"ProofHeader"
#define REUSE_FOOTER_LABEL @"FooterLabel"

#define DEFAULT_FONT [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];

#define TAG_TITLE_TEXTVIEW 122
#define TAG_POINTS_TEXTVIEW 123
#define TAG_DESCRIPTION_TEXTFIELD 124
#define TAG_PROOF_PICKER 125

#define PROOF_TYPE_QUESTIONS @"Answer questions"
#define PROOF_TYPE_PICTURE @"Take a picture"
#define PROOF_TYPE_DESCRIBE @"Describe Finished Task"

#define SEGUE_PROOF_DESCRIBE @"ProofDescribeSegue"
#define SEGUE_PROOF_QUESTIONS @"ProofQuestionsSegue"
#define SEGUE_PROOF_PICTURE @"ProofPictureSegue"

#define PORTRAIT_IMAGE @"iPhone5_5"
#define NAVBAR_IMAGE @"iPhone5_5"
#define LANDSCAPE_IMAGE @"iPhone5_5landscape"

#define PORTRAIT_IMAGE4 @"iPhone4S_6Blurred"
#define NAVBAR_IMAGE4 @"iPhone4S_6Blurred"
#define LANDSCAPE_IMAGE4 @"iPhone4S_5landscape"

#define DEFAULT_PIE_TITLE_COLOR [UIColor lightBluePurpleColor]
#define DEFAULT_TEXT_COLOR [UIColor colorWithRed:0.832 green:0.856 blue:0.885 alpha:1.000]
#define DEFAULT_BACKGROUND_COLOR [UIColor blueGrayColor]
//#define DEFAULT_BACKGROUND_COLOR [UIColor colorWithPatternImage:[UIImage imageNamed:@"denim.jpg"]]
#define DEFAULT_FOREGROUND_COLOR [UIColor darkBlueGrayColor]
#define DEFAULT_TITLE_COLOR [UIColor blueGreenColor]


#define NOTIFICATION_SUBTASK_DONE @"SubtaskDone"

#endif 

