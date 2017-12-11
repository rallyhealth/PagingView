// MIT License
//
// Copyright (c) 2017
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

protocol PagingViewDelegate: class {
    /// Called when an item in the `PagingView` is presented
    func pagingView(_ pagingView: PagingView, didPresentItemAtIndex index: Int)

    /// Called when an item in the `PagingView` is selected by the user
    func pagingView(_ pagingView: PagingView, didSelectItemAtIndex index: Int)
}

class PagingView: UIView {

    /// An object that implements the `PagingViewDelegate` protocol
    weak var delegate: PagingViewDelegate?

    var pagingSubviews: [UIView] {
        return self.stackView.arrangedSubviews
    }

    private var internalConstraints: [NSLayoutConstraint] = []

    fileprivate lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.hidesForSinglePage = true

        return control
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .top

        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self

        return view
    }()

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.addSubview(self.scrollView)
        self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        self.scrollView.addSubview(self.stackView)
        self.stackView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true

        self.addSubview(self.pageControl)
        self.pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.pageControl.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .vertical)
        self.scrollView.bottomAnchor.constraint(equalTo: self.pageControl.topAnchor).isActive = true
    }

    // MARK: Public API

    func addPagingSubview(_ view: UIView) {
        self.stackView.addArrangedSubview(view)

        // Add a tap gesture recognizer to the view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PagingView.handleTap(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)

        self.pageControl.numberOfPages = self.stackView.arrangedSubviews.count

        self.setNeedsUpdateConstraints()
    }

    func removePagingSubview(_ view: UIView) {
        view.removeFromSuperview()

        self.pageControl.numberOfPages = self.stackView.arrangedSubviews.count

        self.setNeedsUpdateConstraints()
    }

    func clearPagingSubviews() {
        self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        self.scrollView.contentOffset = CGPoint.zero
        self.setNeedsUpdateConstraints()
    }

    // MARK: Private API

    fileprivate func updateCurrentPageForOffset(_ offset: CGPoint) {
        let page = offset.x / scrollView.frame.width
        self.pageControl.currentPage = Int(page)
    }

    // MARK: Method override

    override func updateConstraints() {
        // update constraints based on subviews.
        // Note: NSLayoutConstraint.deactivate(self.internalConstraints) causes a crash on ios9 when
        // the constraints are not active (ie when view is in the background), so using a for loop instead.
        for constraint in self.internalConstraints {
            constraint.isActive = false
        }
        self.internalConstraints.removeAll()

        for view in self.pagingSubviews {
            let widthConstraint = view.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
            let heightConstraint = view.heightAnchor.constraint(lessThanOrEqualTo: self.scrollView.heightAnchor)
            self.internalConstraints.append(widthConstraint)
            self.internalConstraints.append(heightConstraint)
        }

        NSLayoutConstraint.activate(self.internalConstraints)

        super.updateConstraints()
    }

    // MARK: Target-action method

    @objc func handleTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.pagingView(self, didSelectItemAtIndex: self.pageControl.currentPage)
    }
}

extension PagingView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCurrentPageForOffset(scrollView.contentOffset)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = pageControl.currentPage
        delegate?.pagingView(self, didPresentItemAtIndex: index)
    }
}
