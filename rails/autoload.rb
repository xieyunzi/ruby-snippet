def eager_autoload
  old_eager, @_eager_autoload = @_eager_autoload, true
  yield
ensure
  @_eager_autoload = old_eager
end
