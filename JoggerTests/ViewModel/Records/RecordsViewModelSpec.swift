import Quick
import Nimble
import ReactiveSwift
import SwiftDate
@testable import Jogger

struct RecordServiceStub: RecordsService {
    
    let records: [Record]
    
    func records(forUserId userId: UserId) -> SignalProducer<[Record], NSError> {
        return .init(value: records)
    }
    
    func add(record: Record, forUserId userId: UserId) -> SignalProducer<Record, NSError> {
        return .empty
    }
    
    func delete(recordID: RecordID, forUserId userId: UserId) -> SignalProducer<(), NSError> {
        return .empty
    }
    
    func update(record: Record, forUserId userId: UserId) -> SignalProducer<Record, NSError> {
        return .empty
    }
}

class RecordsViewModelSpec: QuickSpec {
    override func spec() {
        var recordVM: RecordsViewModel!
        var records: [Record]!
        beforeEach {
            records = (0...7).map { Record(date: $0.days.fromNow()!, distance: Float(arc4random()), time: TimeInterval(arc4random())) }
            let recordService = RecordServiceStub(records: records)
            recordVM = RecordsViewModel(recordsService: recordService)
        }
        
        describe("records") { 
            it("should return records from service", closure: {
                recordVM.userId(uid: "123")
                expect(recordVM.records.value).to(haveCount(records.count))
            })
            
        }
        
        describe("dates") { 
            it("should return all dates from records", closure: { 
                recordVM.userId(uid: "123")
                expect(recordVM.datesFilterValues.value).to(haveCount(records.count))
                expect(recordVM.datesFilterValues.value).to(equal(records.map { $0.date }))
            })
        }
        
        describe("resource data") {
            context("date range is nil", {
                it("should return all records from service", closure: {
                    recordVM.userId(uid: "123")
                    expect(recordVM.resourceData.value).to(haveCount(records.count))
                })
            })
            
            context("date range is today -> tomorrow", {
                it("should return 1 record", closure: {
                    recordVM.userId(uid: "123")
                    recordVM.dateRange.value = Date()...1.day.fromNow()!
                    expect(recordVM.resourceData.value).to(haveCount(1))
                })
                
            })
        }

    }
}
