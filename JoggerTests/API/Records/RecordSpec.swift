import Quick
import Nimble
@testable import Jogger

class RecordSpec: QuickSpec {
    override func spec() {
        let zeroRecord = Record(date: Date(), distance: 0, time: 0)
        let randomRecord = Record(date: Date(), distance: Float(arc4random()), time: TimeInterval(arc4random()))
        
        describe("avg speed") {
            it("should be division of distance by time with correct unit", closure: {
                expect(randomRecord.avgSpeed().value).to(equal(Double(randomRecord.distance) / randomRecord.time))
                expect(randomRecord.avgSpeed().unit).to(equal(UnitSpeed.metersPerSecond))
            })
            
            context("time is zero", { 
                it("should equal zero", closure: {
                    expect(zeroRecord.avgSpeed().value).to(equal(0))
                })
            })
            
        }
    }
}
