import UIKit
import RxSwift
import ObjectMapper

class SomeRouterModel: RouterModel {
    
    private lazy var viewModel: ExampleViewModel = {
        return WXProvider.shared.mProvider.viewModel
    }()
    
    public init(with data: Info) {
        super.init()
        info = data
        startSettings()
    }
    
    private func startSettings() {
        tableSettings = { table in
            table.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        }
        navigationSettings = { nvc in
            nvc?.navigationBar.backgroundColor = .red
            nvc?.navigationItem.title = "SomeRouterModel"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadData()
        }
    }
    
    private func loadData() {
        let object = MapExampleObject()
        viewModel.sendRequest(type: object, request: object.request)
            .applyIOSchedulers()
            .subscribe(onNext: { [weak self] response in
                self?.onDataUpdate(ResponseClass(with: response))
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
}

class SomeDataClass: Info {

    override init(with object: Any) {
        super.init()
        sectionInfo.append(instantiateFirstSection(with: object))
        sectionInfo.append(instantiateSecondSection(with: object))
    }

    init(sectionsVs: Bool) {
        super.init()
        sectionInfo.append(instantiateSecondSection(with: []))
        sectionInfo.append(instantiateFirstSection(with: []))
    }

    private func instantiateFirstSection(with: Any) -> HFSuperClass {

        class FirstSectionHeader: HeaderFooter {

            public override init() {
                super.init()
                height = 40
                backgroundColor = .lightGray
                text = "first section header"
            }

        }

        class FirstSectionFooter: HeaderFooter {

            public override init() {
                super.init()
                height = 40
                backgroundColor = .yellow
                text = "first section footer"
            }

        }

        class FirstSectionCell: CellSuperClass {

            public init(with: Any) {
                super.init()
                info = DefaultObject()
                info?.title = "title"
                info?.details = "details"
            }

        }

        var section = HFSuperClass()
        section.header = FirstSectionHeader()
        section.footer = FirstSectionFooter()
        for _ in 0..<9 {
            section.data.append(FirstSectionCell(with: with))
        }
        return section
    }

    private func instantiateSecondSection(with: Any) -> HFSuperClass {

        class SecondSectionCell: CellSuperClass {

            public init(with: Any) {
                super.init()
                info = DefaultObject()
                info?.title = "title"
                cellSettings = [.titleTextColor: UIColor.red, .titleFont: UIFont.systemFont(ofSize: 18, weight: .bold)]
            }

        }

        var section = HFSuperClass()
        for _ in 0..<3 {
            section.data.append(SecondSectionCell(with: with))
        }
        return section
    }

}

class ResponseClass: Info {

    public init(with: MapExampleObject) {
        super.init()
        for obj in with.list {
            sectionInfo.append(instantiateSection(with: obj))
        }
    }

    private func instantiateSection(with: Forecast) -> HFSuperClass {

        class SectionHeader: HeaderFooter {

            public init(with: Forecast) {
                super.init()
                height = 40
                backgroundColor = UIColor.rgb(240, 240, 240)
                text = with.day
            }

        }

        class SectionCell: CellSuperClass {

            public init(with: Forecast) {
                super.init()
                info = DefaultObject()
                info?.title = with.conditions
                info?.details = "\(with.temperature) C"
            }

        }

        var section = HFSuperClass()
        section.header = SectionHeader(with: with)
        section.data.append(SectionCell(with: with))
        return section

    }

}

class XmplViewController: DarkViewController {

    @IBOutlet weak var tableView: UITableView!

    private var constructor: WXTableConstructor? = nil
    private var constructorRx: WXTableConstructorRx? = nil
    private var disposeBag: DisposeBag = DisposeBag()

    private lazy var viewModel: ExampleViewModel = {
        return WXProvider.shared.mProvider.viewModel
    }()

    private let generator: WXKeyGenerator = WXKeyGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // you can use any implementation you want
        // Rx - initRxTable
        // iOs natural - initTable
        initTable()
        generator.generate()
        generator.post()
    }
    
    // MARK: - Actions

    @IBAction func sendRequest(_ sender: UIBarButtonItem) {
        let object = MapExampleObject()

        // seperated object and object.request, because object with request can differs from object response

        viewModel.sendRequest(type: object, request: object.request)
            .applyIOSchedulers()
            .subscribe(onNext: { response in
                self.navigationItem.title = response.location
                // simple table
                self.constructor?.info = ResponseClass(with: response)
                // rx table
                // self.constructorRx?.updateSectionsTo(info: ResponseClass(with: response))
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Helper methods

    private func initRxTable() {
        let some = SomeDataClass(with: [])
        constructorRx = WXTableConstructorRx(tableView: tableView, info: some)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.viewModel.getObjects()
            .applyIOSchedulers()
            .subscribe(onNext: { object in
                self.constructorRx?.updateSectionsTo(info: object.first!)
            }, onError: { error in
                print(error)
            })
            .disposed(by: self.disposeBag)
        }
        constructorRx?.handler = { path, object in
            self.performSegue(withIdentifier: path.section == 0 ? "push" : "present", sender: nil)
        }
    }

    private func initTable() {
        constructor = WXConstructor(with: tableView, object: SomeDataClass(with: []), refreshable: true).tableConstructor
        constructor?.handler = { path, object in
            // use router to travel about the screens
            WXProvider.shared.router.showModel(model: SomeRouterModel(with: self.constructor!.info as! Info))
            // or use system navigation pattern
//            self.performSegue(withIdentifier: path.section == 0 ? "push" : "present", sender: nil)
        }
    }

    override func refreshData(_ block: @escaping SuccessHandler) {

        // handling refresh control panned
        // refresh your data
        // call block to end refreshing table

        self.viewModel.getObjects()
            .applyIOSchedulers()
            .subscribe(onNext: { object in
                self.navigationItem.title = "EXAMPLE"
                self.constructor?.info = object.first!
                block(true)
            }, onError: { error in
                print(error)
                block(false)
            })
            .disposed(by: self.disposeBag)

    }

    // MARK: - Navigation

    @IBAction func backXmpl(_ sender: UIStoryboardSegue) {
        
    }

}
