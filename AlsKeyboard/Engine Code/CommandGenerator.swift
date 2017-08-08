//
//  RecognationEngine.swift
//  ExpressionRecognition
//
//  Created by MacbookPro on 7.04.2017.
//
//

import Foundation
import UIKit

class CommandGenerator: NSObject {
    
    var allFaceRecognitionInputs: [FaceRecognitionInput] = []
    var allComparisonCoordinates: [String: Any] = [:]
    
    func process(input: FaceRecognitionInput) -> Command? {
        guard self.allFaceRecognitionInputs.count < MAXIMUM_FACE_RECOGNITION_INPUT else {
            self.allFaceRecognitionInputs.removeAll()
            return nil
        }
        
        self.allFaceRecognitionInputs.append(input)
        let currentInputCount = self.allFaceRecognitionInputs.count
        
        guard currentInputCount > MINIMUM_FACE_RECOGNITION_INPUT else {
            return nil
        }
        
        let previousInput = self.allFaceRecognitionInputs[currentInputCount - 2]
        
        let difference = previousInput.timeDifference(fromInput:input)
        
        if difference > MAXIMUM_TIME_REQUIREMENT_BETWEEN_INPUTS {
            return nil
        }
        
        let comparisonCoordinates = previousInput.comparisonCoordinates(withOtherInput: input)
        
        let rightEyebrowX = rightEyebrow(comparisonCoordinates: comparisonCoordinates).xCoordinates
        let rightEyebrowY = rightEyebrow(comparisonCoordinates: comparisonCoordinates).yCoordinates
        let leftEyebrowX = leftEyebrow(comparisonCoordinates: comparisonCoordinates).xCoordinates
        let leftEyebrowY = leftEyebrow(comparisonCoordinates: comparisonCoordinates).yCoordinates
        let rightEyeX = rightEye(comparisonCoordinates: comparisonCoordinates).xCoordinates
        let rightEyeY = rightEye(comparisonCoordinates: comparisonCoordinates).yCoordinates
        let leftEyeX = leftEye(comparisonCoordinates: comparisonCoordinates).xCoordinates
        let leftEyeY = leftEye(comparisonCoordinates: comparisonCoordinates).yCoordinates
        let noseX = nose(comparisonCoordinates: comparisonCoordinates).xCoordinates
        let noseY = nose(comparisonCoordinates: comparisonCoordinates).yCoordinates
        let mouthX = mouth(comparisonCoordinates: comparisonCoordinates).xCoordinates
        let mouthY = mouth(comparisonCoordinates: comparisonCoordinates).yCoordinates
        
        allComparisonCoordinates = [
            "rightEyebrowX": rightEyebrowX,
            "rightEyebrowY": rightEyebrowY,
            "leftEyebrowX": leftEyebrowX,
            "leftEyebrowY": leftEyebrowY,
            "rightEyeX": rightEyeX,
            "rightEyeY": rightEyeY,
            "leftEyeX": leftEyeX,
            "leftEyeY": leftEyeY,
            "noseX": noseX,
            "noseY": noseY,
            "mouthX": mouthX,
            "mouthY": mouthY
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: allComparisonCoordinates, options: JSONSerialization.WritingOptions()) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            let fileURL = saveToFile(text: jsonString).urlPath
            print(readFromFile(fileURL: fileURL).readText)
        } catch {
            print("Cannot serialization")
        }
        
        return nil
    }
    
    func rightEyebrow(comparisonCoordinates: [CGPoint]) -> (xCoordinates: CGFloat, yCoordinates: CGFloat) {
        let xCoordinates = comparisonCoordinates[18].x + comparisonCoordinates[19].x + comparisonCoordinates[20].x + comparisonCoordinates[21].x + comparisonCoordinates[22].x
        let yCoordinates = comparisonCoordinates[18].y + comparisonCoordinates[19].y + comparisonCoordinates[20].y + comparisonCoordinates[21].y + comparisonCoordinates[22].y
        
        return (xCoordinates, yCoordinates)
    }
    
    func leftEyebrow(comparisonCoordinates: [CGPoint]) -> (xCoordinates: CGFloat, yCoordinates: CGFloat) {
        let xCoordinates = comparisonCoordinates[23].x + comparisonCoordinates[24].x + comparisonCoordinates[25].x + comparisonCoordinates[26].x + comparisonCoordinates[27].x
        let yCoordinates = comparisonCoordinates[23].y + comparisonCoordinates[24].y + comparisonCoordinates[25].y + comparisonCoordinates[26].y + comparisonCoordinates[27].y
        
        return (xCoordinates, yCoordinates)
    }
    
    func rightEye(comparisonCoordinates: [CGPoint]) -> (xCoordinates: CGFloat, yCoordinates: CGFloat) {
        let xCoordinates = comparisonCoordinates[37].x + comparisonCoordinates[38].x + comparisonCoordinates[39].x + comparisonCoordinates[40].x + comparisonCoordinates[41].x + comparisonCoordinates[42].x
        let yCoordinates = comparisonCoordinates[37].y + comparisonCoordinates[38].y + comparisonCoordinates[39].y + comparisonCoordinates[40].y + comparisonCoordinates[41].y + comparisonCoordinates[42].y
        
        return (xCoordinates, yCoordinates)
    }
    
    func leftEye(comparisonCoordinates: [CGPoint]) -> (xCoordinates: CGFloat, yCoordinates: CGFloat) {
        let xCoordinates = comparisonCoordinates[43].x + comparisonCoordinates[44].x + comparisonCoordinates[45].x + comparisonCoordinates[46].x + comparisonCoordinates[47].x + comparisonCoordinates[48].x
        let yCoordinates = comparisonCoordinates[43].y + comparisonCoordinates[44].y + comparisonCoordinates[45].y + comparisonCoordinates[46].y + comparisonCoordinates[47].y + comparisonCoordinates[48].y
        
        return (xCoordinates, yCoordinates)
    }
    
    func nose(comparisonCoordinates: [CGPoint]) -> (xCoordinates: CGFloat, yCoordinates: CGFloat) {
        let xCoordinates = comparisonCoordinates[28].x + comparisonCoordinates[29].x + comparisonCoordinates[30].x + comparisonCoordinates[31].x
        let yCoordinates = comparisonCoordinates[28].y + comparisonCoordinates[29].y + comparisonCoordinates[30].y + comparisonCoordinates[31].y
        
        return (xCoordinates, yCoordinates)
    }
    
    func mouth(comparisonCoordinates: [CGPoint]) -> (xCoordinates: CGFloat, yCoordinates: CGFloat) {
        let xCoordinates = comparisonCoordinates[49].x + comparisonCoordinates[55].x
        let yCoordinates = comparisonCoordinates[63].y + comparisonCoordinates[67].y
        
        return (xCoordinates, yCoordinates)
    }
    
    func saveToFile(text: String) -> (urlPath: URL, result: Bool) {
        let dir = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
        let fileURL = dir.appendingPathComponent("coordinates.txt")
        let text = "\(text)"
        let data = text.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
                return (fileURL, true)
            } catch {
                return (fileURL, false)
            }
        } else {
            do {
                try data.write(to: fileURL, options: .atomic)
                return (fileURL, true)
            } catch {
                return (fileURL, false)
            }
        }
    }
    
    func readFromFile(fileURL: URL) -> (readText: String, result: Bool) {
        do {
            let mytext = try String(contentsOf: fileURL)
            return (mytext, true)
        } catch {
            return ("Error Occured", false)
        }
    }
}
