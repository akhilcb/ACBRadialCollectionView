Pod::Spec.new do |s|
  s.name         = "ACBRadialCollectionView"
  s.version      = "2.0"
  s.summary      = "An extension on UICollectionView which automatically transforms collection view cells to a radial path."
  s.description  = <<-DESC
  This is an extension on UICollectionView which automatically transforms collection view cells to a radial path with minimal code. This is written in Swift language. No need to subclass UICollectionView for this. CollectionView will also display an arc shaped scroll bar next to the cells which acts similar to the normal scroll bar.
                   DESC
  s.homepage     = "https://github.com/akhilcb/ACBRadialCollectionView"
  s.license      = "MIT"
  s.author    	 = "Akhil"
  s.platform     = :ios
  s.source       = { :git => "https://github.com/akhilcb/ACBRadialCollectionView.git", :tag => "2.0" }
  s.source_files  = "ACBRadialCollectionView", "ACBRadialCollectionView/Classes/Source/**/*.{swift}"
end
