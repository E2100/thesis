module AR
  
  # Standard library error
  class Error < StandardError; end

  # Error when no prediction can be made
  class PredictionError < Error; end
  
  # Error when nesting meta recommenders
  class NestingError < Error; end

end
