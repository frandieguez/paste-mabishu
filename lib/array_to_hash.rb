class Hash
  def create(keys, values)
    self[*keys.zip(values).flatten]
  end
end
