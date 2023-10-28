import UIKit
import Nuke

class DetailViewController: UIViewController {
    
    var post: Post?
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 24) 
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Post Detail"
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(textView)
        
        setupConstraints()
        configurePost()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),

            textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10), // Add a gap between imageView and textView
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),  // Add some padding
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10), // Add some padding
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

//    func convertHTMLToAttributedString(html: String) -> NSAttributedString? {
//        guard let data = html.data(using: .utf8) else { return nil }
//        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
//            .documentType: NSAttributedString.DocumentType.html,
//            .characterEncoding: String.Encoding.utf8.rawValue
//        ]
//
//        do {
//            return try NSAttributedString(data: data, options: options, documentAttributes: nil)
//        } catch {
//            print("Error converting HTML to NSAttributedString: \(error.localizedDescription)")
//            return nil
//        }
//    }
    
    func convertHTMLToAttributedString(html: String) -> NSAttributedString? {
        guard let data = html.data(using: .utf8) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        do {
            let originalAttributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return originalAttributedString.withAdjustedFontSize(to: 18.0)  // Adjust the font size here
        } catch {
            print("Error converting HTML to NSAttributedString: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    private func configurePost() {
        if let post = post {
            if let attributedCaption = convertHTMLToAttributedString(html: post.caption) {
                textView.attributedText = attributedCaption
            }
            if let photo = post.photos.first {
                Nuke.loadImage(with: photo.originalSize.url, into: imageView)
            }
        }
    }
   
}

extension NSAttributedString {
    func withAdjustedFontSize(to newSize: CGFloat) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: self)
        mutableString.enumerateAttribute(.font, in: NSRange(location: 0, length: length), options: []) { value, range, stop in
            if let font = value as? UIFont {
                let newFont = font.withSize(newSize)
                mutableString.addAttributes([.font: newFont], range: range)
            }
        }
        return NSAttributedString(attributedString: mutableString)
    }
}
