import UIKit

// TODO: - generate stackView according to installed apps on device

enum SocialType: Int {

    case viber = 1
    case whatsapp = 2
    case sms = 3
    case facebook = 4
    case telegram = 5

    static let shortList: [SocialType] = [facebook, telegram]
    static let fullList: [SocialType] = [viber, whatsapp, sms, facebook, telegram]

    var placeholder: String {
        switch self {
        case .sms: return NSLocalizedString("enter_code_sms", comment: "")
        case .viber, .whatsapp, .facebook, .telegram: return NSLocalizedString("enter_code_messageя", comment: "")
        }
    }

    var actionTitle: String {
        switch self {
        case .viber: return NSLocalizedString("with_viber", comment: "")
        case .whatsapp: return NSLocalizedString("with_whatsapp", comment: "")
        case .sms: return NSLocalizedString("with_sms", comment: "")
        case .facebook: return NSLocalizedString("with_facebook", comment: "")
        case .telegram: return NSLocalizedString("with_telegram", comment: "")
        }
    }

    func action(block: CodeHandler) {
        Communicator.sendCode(type: self) { response, type in
            block?(response, type)
        }
    }

}

class CodePoster: NSObject {

    var message: String = NSLocalizedString("select_way", comment: "")

    public override init() {
        super.init()
    }

    func showActionSheet(repeated: Bool, block: CodeHandler) {
        repeated == true ? fullActionSheet(block: block) : cutedActionSheet(block: block)
    }

    private func cutedActionSheet(block: CodeHandler) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel_title", comment: ""), style: .cancel, handler: { _ in }))
        for object in SocialType.shortList {
            alert.addAction(UIAlertAction(title: object.actionTitle, style: .default, handler: { _ in
                object.action(block: block)
            }))
        }
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }

    private func fullActionSheet(block: CodeHandler) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel_title", comment: ""), style: .cancel, handler: { _ in }))
        for object in SocialType.fullList {
            alert.addAction(UIAlertAction(title: object.actionTitle, style: .default, handler: { _ in
                object.action(block: block)
            }))
        }
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }

    func sendCode(type: SocialType, block: CodeHandler) {
        Communicator.sendCode(type: type) { response, type in
            block?(response, type)
        }
    }

}
