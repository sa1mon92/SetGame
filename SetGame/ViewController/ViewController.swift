//
//  ViewController.swift
//  SetGame
//
//  Created by Дмитрий Садырев on 03.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var deckButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    private var game: SetGameInput = SetGame()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupCollectionView()
        game.output = self
        setupDeckButton()
    }
    
    // MARK: - IBActions
    
    @IBAction private func newGameButtonTap(_ sender: UIButton) {
        game = SetGame()
        game.output = self
        setupDeckButton()
        collectionView.reloadData()
    }
    
    @IBAction private func dealButtonTap(_ sender: UIButton) {
        game.dealThreeCards()
    }
    
    // MARK: - Private methods
    
    private func setupBackgroundView() {
        let backgroundView = UIView(frame: collectionView.bounds)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        backgroundView.addGestureRecognizer(tapGesture)
        collectionView.backgroundView = backgroundView
        collectionView.backgroundView?.isUserInteractionEnabled = true
    }
    
    @objc private func backgroundTap() {
        game.backgroundTap()
    }
    
    private func setupDeckButton() {
        deckButton.setTitle("Deck: \(game.getDeckCount())", for: .normal)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
    }
}

extension ViewController: SetGameOutput {
    func update() {
        setupDeckButton()
        scoreLabel.text = "Score: \(game.score)"
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.setup(game.cards[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        game.selectCard(game.cards[indexPath.row].card)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 4 - 3
        let height = collectionView.frame.size.height / 6 - 5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

