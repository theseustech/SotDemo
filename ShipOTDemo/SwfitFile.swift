import Foundation
import SwiftTest

public class TestSwift: NSObject
{
    @objc
    public func test(_ input:String)->String
    {
        let i = SwiftTestInframework()
        return i.test(input)
    }
}
