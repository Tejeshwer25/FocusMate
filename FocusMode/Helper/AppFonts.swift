//
//  AppFonts.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 13/09/25.
//

import UIKit

enum AppFonts {
    case mainHeading          // Main Screen title or section headers
    case subSectionHeading    // Inside expanded charts or sections
    case normalText           // Any normal text
    case secondaryText        // Dates, supporting label or helper text
    case chartAxisLabel
    case popoverMainInfo      // Values in a popover
    case popoverSecondaryInfo // Labels in a popover
    case formFieldLabel
    case formFieldValue
    case primryButton
    case secondryButton
    case highlightedStatsText
    case microLabel
    
    var font: UIFont? {
        switch self {
        case .mainHeading:
            return UIFont.preferredFont(forTextStyle: .title2)
        case .subSectionHeading:
            return UIFont.preferredFont(forTextStyle: .headline)
        case .chartAxisLabel:
            return UIFont.preferredFont(forTextStyle: .caption1)
        case .popoverMainInfo:
            return UIFont.preferredFont(forTextStyle: .headline)
        case .highlightedStatsText:
            return UIFont.preferredFont(forTextStyle: .title3)
        case .microLabel:
            return UIFont.preferredFont(forTextStyle: .caption2)
        case .secondaryText, .secondryButton:
            return UIFont.preferredFont(forTextStyle: .callout)
        case .popoverSecondaryInfo, .formFieldLabel:
            return UIFont.preferredFont(forTextStyle: .subheadline)
        case .normalText, .formFieldValue, .primryButton:
            return UIFont.preferredFont(forTextStyle: .body)
        }
    }
    
    var fontWeight: UIFont.Weight {
        switch self {
        case .mainHeading,
                .subSectionHeading,
                .popoverMainInfo,
                .primryButton:
            return .semibold
        case .normalText,
                .secondaryText,
                .chartAxisLabel,
                .popoverSecondaryInfo,
                .formFieldLabel,
                .formFieldValue,
                .secondryButton:
            return .regular
        case .highlightedStatsText:
            return .bold
        case .microLabel:
            return .medium
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .mainHeading,
                .highlightedStatsText:
            return 20
        case .subSectionHeading:
            return 17
        case .normalText,
                .popoverMainInfo,
                .formFieldValue,
                .primryButton:
            return 16
        case .secondaryText,
                .popoverSecondaryInfo:
            return 14
        case .chartAxisLabel:
            return 12
        case .formFieldLabel,
                .secondryButton:
            return 15
        case .microLabel:
            return 11
        }
    }
}
