require 'set'

# Find all Swift files
swift_files = Dir.glob('ImageViewer/**/*.swift').reject { |f| f.include?('Pods') }

# The files we definitely want to keep
core_files = [
  'AppDelegate.swift', 'SceneDelegate.swift', 'AppCoordinator.swift',
  'HomeVC.swift', 'AnimatedLaunchVC.swift', 'ProfileVC.swift', 
  'ViewImageVC.swift', 'HomeViewModel.swift',
  'ReachabilityManager.swift', 'Reachability.swift', 'TTGSnackBar.swift',
  'UnsplashPhotoModel.swift', 'Alert.swift', 'AppMessages.swift', 
  'Localization.swift', 'NetworkLayerManager.swift', 'CoreDataManager.swift'
]

file_declarations = {}

# Regex to find class, struct, enum, protocol declarations
swift_files.each do |file|
  content = File.read(file)
  declarations = []
  
  # Match top-level declarations
  content.scan(/(?:class|struct|enum|protocol|extension)\s+([A-Z][A-Za-z0-9_]*)/).each do |match|
    declarations << match[0]
  end
  
  # For global functions/variables, it's harder, but we can look for specific keywords or just rely on the types
  file_declarations[file] = declarations.uniq
end

# Now for each file, let's see if ANY of its declarations are used outside of the file
unused_files = []

swift_files.each do |target_file|
  basename = File.basename(target_file)
  
  # Skip core files
  next if core_files.include?(basename)
  
  declarations = file_declarations[target_file]
  
  # If the file has no declarations, we'll mark it for review
  if declarations.empty?
    unused_files << target_file
    next
  end
  
  # Check if any declaration is used in other files
  is_used = false
  swift_files.each do |other_file|
    next if target_file == other_file
    other_content = File.read(other_file)
    
    declarations.each do |decl|
      # Look for the declaration word boundary in other files
      if other_content.match?(/\b#{decl}\b/)
        is_used = true
        break
      end
    end
    break if is_used
  end
  
  unused_files << target_file unless is_used
end

puts "Potentially Unused Files:"
unused_files.each { |f| puts f }

