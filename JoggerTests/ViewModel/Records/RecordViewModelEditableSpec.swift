import Quick
import Nimble
import ReactiveSwift
@testable import Jogger

struct EditRecordViewModelStub: RecordViewModelEditable {
    var recordID = MutableProperty<RecordID?>(nil)
    let distance = MutableProperty<String?>(nil)
    let time = MutableProperty<String?>(nil)
    let date = MutableProperty<Date?>(nil)
    func save() -> SignalProducer<Bool, NSError> {
        return .empty
    }
}

class RecordViewModelEditableSpec: QuickSpec {
    override func spec() {
        var vm: EditRecordViewModelStub!
        
        beforeEach {
            vm = EditRecordViewModelStub()
        }
        
        describe("creating record") { 
            it("should create model with all values", closure: { 
                vm.date.value = Date()
                vm.distance.value = "123"
                vm.time.value = "234"
                vm.recordID.value = "test_id"
                let result = vm.createRecord()
                expect(result.error).to(beNil())
                expect(result.value).toNot(beNil())
                expect(result.value?.date).to(equal(vm.date.value))
                expect(result.value?.distance).to(equal(123))
                expect(result.value?.time).to(equal(234))
                expect(result.value?.recordID).to(equal("test_id"))
            })
            
            context("date is nil", {
                it("should return validation error", closure: { 
                    vm.distance.value = "123"
                    vm.time.value = "234"
                    vm.recordID.value = "test_id"
                    let result = vm.createRecord()
                    expect(result.error).toNot(beNil())
                    expect(result.error?.code).to(equal(JoggerErrorCode.validation.rawValue))
                })
            })
            
            context("recordID is nil", {
                it("should return record value", closure: {
                    vm.date.value = Date()
                    vm.distance.value = "123"
                    vm.time.value = "234"
                    let result = vm.createRecord()
                    expect(result.error).to(beNil())
                    expect(result.value).toNot(beNil())
                })
            })
            
            context("distance value is not parsable to float", {
                it("should return validation error", closure: {
                    vm.date.value = Date()
                    vm.distance.value = "strange value"
                    vm.time.value = "234"
                    let result = vm.createRecord()
                    expect(result.error).toNot(beNil())
                    expect(result.error?.code).to(equal(JoggerErrorCode.validation.rawValue))
                })
            })
        }
    }
}
