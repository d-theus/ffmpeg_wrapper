class Hash
  def to_shellflags
    line = ''
    each do |k, v|
      line << "-#{k} #{v}"
    end
    line
  end
end
