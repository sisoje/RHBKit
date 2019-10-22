import UIKit

@IBDesignable public class FakeProgressView: UIView {

    var progressView: UIView!
    var startTime: Date = .distantFuture
    @IBInspectable public var animatioTime: Double = 0.2
    @IBInspectable public var progressSpeed: Double = 1.5
    @IBInspectable public var progressColor: UIColor = .blue {
        didSet {
            progressView.backgroundColor = progressColor
        }
    }

    var progressFrame: CGRect {
        assert(progressSpeed > 1)
        let elapsed = Date().timeIntervalSince(startTime)
        let progress = elapsed <= 0 ? 0 : 1 - pow(progressSpeed, -elapsed)
        return CGRect(origin: .zero, size: CGSize(width: frame.width * CGFloat(progress), height: frame.height))
    }

    override public func draw(_ rect: CGRect) {
        animateLoop()
    }

    func setupProgressView() {
        progressView = UIView(frame: progressFrame)
        progressView.backgroundColor = progressColor
        addSubview(progressView)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupProgressView()
    }

    func animateLoop() {
        assert(animatioTime > 0)
        let newFrame = progressFrame
        UIView.animate(withDuration: animatioTime,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak animatedView = progressView] in
                        animatedView?.frame = newFrame
        }, completion: { [weak self] _ in
            if self?.startTime != .distantPast && self?.startTime != .distantFuture {
                self?.animateLoop()
            }
        })
    }

    public func startProgress() {
        startTime = Date()
        progressView.frame = progressFrame
        animateLoop()
    }

    public func restartProgress() {
        startTime = Date()
        animateLoop()
    }

    public func endProgess(_ endedOk: Bool = true) {
        startTime = endedOk ? .distantPast : .distantFuture
        animateLoop()
    }
}
