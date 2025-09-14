//
//  AppFonts.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 13/09/25.
//

import SwiftUI

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
    
    var font: Font? {
        switch self {
        case .mainHeading:
            return .init(.title2)
        case .subSectionHeading:
            return .init(.headline)
        case .chartAxisLabel:
            return .init(.caption)
        case .popoverMainInfo:
            return .init(.headline)
        case .highlightedStatsText:
            return .init(.title) // .init(.title3)
        case .microLabel:
            return .init(.caption2)
        case .secondaryText, .secondryButton:
            return .init(.callout)
        case .popoverSecondaryInfo, .formFieldLabel:
            return .init(.subheadline)
        case .normalText, .formFieldValue, .primryButton:
            return .init(.body)
        }
    }
    
    var fontWeight: Font.Weight {
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
