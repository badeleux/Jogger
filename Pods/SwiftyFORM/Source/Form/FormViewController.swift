// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

open class FormViewController: UIViewController {
	public var dataSource: TableViewSectionArray?
	public var keyboardHandler: KeyboardHandler?
	
	public init() {
		SwiftyFormLog("super init")
		super.init(nibName: nil, bundle: nil)
	}
	
	required public init(coder aDecoder: NSCoder) {
		SwiftyFormLog("super init")
		super.init(nibName: nil, bundle: nil)
	}

	override open func loadView() {
		SwiftyFormLog("super loadview")
		view = tableView
		
		keyboardHandler = KeyboardHandler(tableView: tableView)
		
		populate(formBuilder)
		title = formBuilder.navigationTitle
		
		dataSource = formBuilder.result(self)
		self.tableView.dataSource = dataSource
		self.tableView.delegate = dataSource
		
		//debugPrint(dataSource!)
	}

	open func populate(_ builder: FormBuilder) {
		SwiftyFormLog("subclass must implement populate()")
	}

	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		keyboardHandler?.addObservers()

		// Fade out, so that the user can see what row has been updated
		if let indexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}
	
	override open func viewDidDisappear(_ animated: Bool) {
		self.keyboardHandler?.removeObservers()
		super.viewDidDisappear(animated)
	}

	public lazy var formBuilder: FormBuilder = {
		return FormBuilder()
		}()
	
	public lazy var tableView: FormTableView = {
		return FormTableView()
		}()
}
