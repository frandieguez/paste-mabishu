class String

  def modelize
    self.singularize.camelize.constantize
  end

end