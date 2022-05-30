//
//  EditViewBinary.swift
//  
//
//  Created by Braden Ackerman on 2022-06-05.
//

import SwiftUI

struct EditViewBinary: View {
    
    @ObservedObject var viewModel : ViewModel
    @State var currentEditingMode : BinaryEditMode = BinaryEditMode.hex //open to hex represenetation in case the
    @State var previousEditingMode : BinaryEditMode = BinaryEditMode.hex //track last editing mode to revert the switch after being warned unicode isn't appropriate for the data
    @State var currentseperatorPerBytePreference : String = BinaryEditseperatorPerByte.separatorBetweenBytes.rawValue
    
    //these two should always equate
    @State var stringValue : String = ""
    @State var expectseparatedBytes : Bool = true //relates to both hex and binary (obviously not unicode)
    @State var hexAutoformatMode : Bool = true //hex or binary texteditor extension mode, does not apply to binary
    
    @State var nonValidUnicodeWarningShown : Bool = false //state toggel for popup warning the user that the data isn't able to represented as unicode. They'll be asked to choose a) stay in current editing mode b) filter data for only unicode characters (destructive) c) clear data completely.

    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    EditViewBinaryRadioButtons (selectedEditMode: $currentEditingMode, { selected in

                        hexAutoformatMode = (currentEditingMode == BinaryEditMode.hex) ? true : false
                        
                        populateStringValueAppropriatelyPerEditingMode()
                        
                    }).padding(.bottom)
                    
                    EditViewBinaryseperatorPerByteRadioButtons { selected in
                        currentseperatorPerBytePreference = selected
                        logger.debug("separator per byte preference is now: \(selected)")
                    }.opacity(currentEditingMode == BinaryEditMode.unicode ? 0 : 1)
                }
                Spacer()
            }
            
            HexBinTextEditor("", stringValue: $stringValue, editMode: $currentEditingMode, seperatorsPerByte: $expectseparatedBytes)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.black)
            )
            .padding(.leading)
            .padding(.trailing)
            .onChange(of: stringValue, perform: { newValue in
                //handle different editing modes for retention of changed value
                switch (currentEditingMode) {
                    case BinaryEditMode.unicode:
                        viewModel.temporaryEditedBinaryDataValue = stringValue.data(using: .utf8)
                    case BinaryEditMode.hex:
                        viewModel.temporaryEditedBinaryDataValue = Data(hexString: stringValue, expectseparatedBytes: expectseparatedBytes)
                    case BinaryEditMode.binary:
                        viewModel.temporaryEditedBinaryDataValue = Data(binaryString: stringValue, expectseparatedBytes:expectseparatedBytes)
                }
            })
            .onChange(of: currentseperatorPerBytePreference, perform: { newValue in
                switch (newValue) {
                    case BinaryEditseperatorPerByte.separatorBetweenBytes.rawValue:
                        expectseparatedBytes = true
                    case BinaryEditseperatorPerByte.noseparatorBetweenBytes.rawValue:
                        expectseparatedBytes = false
                    default:
                        logger.critical("Encountered unknown BinaryEditMode in onChange of currentseperatorPerBytePreference")
                }
                
                if let strongData = viewModel.temporaryEditedBinaryDataValue {
                    switch (currentEditingMode) {
                        
                    case BinaryEditMode.unicode:
                            stringValue = String(data:strongData, encoding: String.Encoding.utf8) ?? ""
                        
                    case BinaryEditMode.hex:
                        if expectseparatedBytes {
                            stringValue = strongData.hexEncodedString(options: [.upperCase, .seperatorPerByte])
                        } else {
                            stringValue = strongData.hexEncodedString(options: [.upperCase])
                        }
                        
                    case BinaryEditMode.binary:
                        if expectseparatedBytes {
                            stringValue = strongData.binaryOnesAndZerosDescription(options: .seperatorPerByte)
                        } else {
                            stringValue = strongData.binaryOnesAndZerosDescription()
                        }
                    }
                    
                }
                
            })
            .onAppear {
                viewModel.temporaryEditedBinaryDataValue = (viewModel.selectedFieldForEditing as! FieldBinary).value
                populateStringValueAppropriatelyPerEditingMode()
            }
            .actionSheet(isPresented:$nonValidUnicodeWarningShown) {
                ActionSheet(title: Text("Data not unicode"),
                            message: Text("The data displayed in hexidecimal or binary can't be entirely represented by unicode characters. Please choose an option below"),
                            buttons: unicodeIssueButtons())
            }
        }
    }
    
    //assumed correct StashModel.stashMode
    func unicodeIssueButtons() -> [Alert.Button] {
        
        var asButtons = [Alert.Button]()
        
        asButtons.append(Alert.Button.default(Text("Return to previous editing mode (keep data)")){
            currentEditingMode = previousEditingMode
            nonValidUnicodeWarningShown = false
        })
        
        asButtons.append(Alert.Button.destructive(Text("Keep only unicode characters, destructive")){

            stringValue = filterTempDataForOnlyUTF8CharactersAsString()
            logger.debug("FILTERED: \(stringValue)")
            nonValidUnicodeWarningShown = false
            previousEditingMode = currentEditingMode
            
        })
        
        asButtons.append(Alert.Button.destructive(Text("Clear data, destructive")){
            stringValue = ""
            nonValidUnicodeWarningShown = false
            previousEditingMode = currentEditingMode
        })
        
        
        return asButtons
    }
    
    func populateStringValueAppropriatelyPerEditingMode() {
        if let strongData = viewModel.temporaryEditedBinaryDataValue {
            
            switch (currentEditingMode) {
                
                case BinaryEditMode.unicode:
                    willSwitchToUnicodeEditing()
                    
                case BinaryEditMode.hex:
                    if expectseparatedBytes {
                        stringValue = strongData.hexEncodedString(options: [.upperCase, .seperatorPerByte])
                    } else {
                        stringValue = strongData.hexEncodedString(options: [.upperCase])
                    }
                    previousEditingMode = currentEditingMode
                case BinaryEditMode.binary:
                    if expectseparatedBytes {
                        stringValue = strongData.binaryOnesAndZerosDescription(options: .seperatorPerByte)
                    } else {
                        stringValue = strongData.binaryOnesAndZerosDescription()
                    }
                    previousEditingMode = currentEditingMode
            }
            
        }
    }
    
    func willSwitchToUnicodeEditing() {
        if let strongData = viewModel.temporaryEditedBinaryDataValue {
            if String(data:strongData, encoding: String.Encoding.utf8) == nil {
                nonValidUnicodeWarningShown = true
            } else {
                stringValue = String(data:strongData, encoding: String.Encoding.utf8) ?? ""
                print("did make stringValue: \(stringValue)")
            }
        }
    }
    
    /*
     UTF8 uses one byte for standard English letters and symbols, two bytes for additional Latin and Middle Eastern characters, and three bytes for Asian characters. Additional characters can be represented using four bytes. UTF-8 is backwards compatible with ASCII, since the first 128 characters are mapped to the same values.
     */
    //^^ Sooo, we'll try 1 byte, 2 bytes, 3 bytes then 4 bytes. If none of that works, discard the leading byte. If it does work, accept that value.
    // test 4 byte char: xf0 x90 x84 x82  == tiny x // f0928183 = 𒁃  //𓅒 f0938592 //𓅢 f09385a2  //🧬  f09fa7ac
    // test 3 byte char: ৠ e0 a7 a0 // 猽 e7 8c bd // ﬗ ef ac 97
    // test 2 byte char: § c2 a7 // ʨ ca a8 //ݭ dd ad // ޭޭ  de ad
    // test 1 byte - any ASCII (a,b,c,?, " ", CR which is A0
    func filterTempDataForOnlyUTF8CharactersAsString() -> String {
        
        var validCharacters = Data()
        
        if let strongData = viewModel.temporaryEditedBinaryDataValue {
            
           var idx = 0
            while(idx < strongData.count - 1) { //zero indexed and checking
                
                var prevSubData : Data?
                
                for subIdx in stride(from: 3, to: 0, by: -1) {

                        //don't index out of bounds
                        if (idx + subIdx) > (strongData.count - 1) {
                            continue
                        }

                        let subData = strongData.subdata(in: Range(idx...idx + subIdx))
                    
                        //if we can't turn subData into a UTF8 string, it's not valid UTF8, so bail
                        if String(data:subData, encoding: String.Encoding.utf8) != nil {
                            prevSubData = subData
                        } else {
                            //if we can turn subData into a UTF8 string, subdata is valid, so keep it around in case we bail on the next byte (or to use if all 4 bytes in the sub range are valid)
                            continue
                        }
                }
                
                //if 1, 2, 3, or 4 bytes were successfully decoded (represented by prevSubData) tack those onto our result data and increment the parent (non sub) index by how ever many bytes were successfully decoded
                if let strongSubData = prevSubData {
                    validCharacters.append(strongSubData)
                    idx += strongSubData.count
                } else {
                    idx += 1
                }
                
                prevSubData = nil //prevent adding the same valid data twice if the first byte after first valid is noise/not UTF8
            }
        }
        return String(decoding: validCharacters, as: UTF8.self)
    }
}

extension Data {
 
    //hex extensions adapted from https://stackoverflow.com/questions/39075043/how-to-convert-data-to-hex-string-in-swift/40089462#40089462
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
        static let seperatorPerByte = HexEncodingOptions(rawValue: 1 << 1)
    }
    
    struct BinaryEncodingOptions: OptionSet {
        let rawValue: Int
        static let seperatorPerByte = BinaryEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        
        let format = options.contains(.upperCase) ? (options.contains(.seperatorPerByte) ? "%02hhX:" : "%02hhX") : (options.contains(.seperatorPerByte) ? "%02hhx:" : "%02hhx")
        return self.map { String(format: format, $0) }.joined()
    }
    

    func binaryOnesAndZerosDescription(options: BinaryEncodingOptions = []) -> String {
        
        var binaryString : String = ""
        
        for c in self {
            
            var byteString : String = ""
            
            for i in stride(from: 7, to: -1, by: -1)
            {
                if ((c & (1 << i)) != 0) {
                    byteString = byteString + "1"
                } else {
                    byteString = byteString + "0"
                }
            }
            binaryString = binaryString + byteString + (options.contains(.seperatorPerByte) ? " " : "")
        }
        
        return binaryString
    }
    
    
    init?(binaryString: String, expectSeparatedBytes: Bool) {
    
      let workingString = expectSeparatedBytes ? binaryString.replacingOccurrences(of: " ", with: "") : binaryString
        
      let len = workingString.count / 8
      var data = Data(capacity: len)
      var i = workingString.startIndex
      for _ in 0..<len {
          let j = workingString.index(i, offsetBy: 8)
          let c = strtol(workingString[i..<j].cString(using: String.Encoding.utf8)!, nil, 2);
          i = j
          data.append(contentsOf: [UInt8(c)])
      }
      self = data
    }
    
    init?(hexString: String, expectSeparatedBytes: Bool) {
        
      let workingString = expectSeparatedBytes ? hexString.replacingOccurrences(of: ":", with: "") : hexString
        
      let len = workingString.count / 2
      var data = Data(capacity: len)
      var i = workingString.startIndex
      for _ in 0..<len {
            let j = workingString.index(i, offsetBy: 2)
            let bytes = workingString[i..<j]
            if var num = UInt8(bytes, radix: 16) {
              data.append(&num, count: 1)
            } else {
              return nil
            }
            i = j
      }
      self = data
    }
}
