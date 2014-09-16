module Kernel
  alias gem_original_require require

  def require(path)
    gem_original_require path
  rescue
    if load_error.message.end_with? path
      if Gem.try_activite path
        return gem_original_require path
      end
    end

    raise load_error
  end
end
