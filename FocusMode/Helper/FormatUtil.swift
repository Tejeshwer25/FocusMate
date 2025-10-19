//
//  FormatUtil.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 11/10/25.
//

class FormatUtil {
    typealias Time = (hour: Int, minutes: Int, second: Int)
    
    /// Method to convert seconds to respective time format
    /// - Parameter seconds: seconds completed
    /// - Returns: time completed
    class func convertSecondsToRequiredTime(seconds: Double) -> Time {
        let hours = Int(seconds) / 3600
        let minutes = Int((seconds.truncatingRemainder(dividingBy: 3600))) / 60
        let seconds = Int((seconds.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))
        
        return Time(hour: hours, minutes: minutes, second: seconds)
    }
    
    /// Method to get readable string from time format
    /// - Parameter time: Time data tuple
    /// - Returns: readable string
    class func getReadableStringFromTime(time: Time) -> String {
        var result = ""
        if time.hour > 0 {
            result += "\(time.hour)h "
        }
        
        if time.minutes > 0 {
            result += "\(time.minutes)m "
        }
        
        if time.second > 0 {
            result += "\(time.second)s "
        }
        
        if result.isEmpty {
            return "0s"
        }
        return result
    }
}
