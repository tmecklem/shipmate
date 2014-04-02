class String
  def to_version_string
    if !self.nil? 
      self.split('.').map do |version_part|
        if version_part.to_i.to_s == version_part
          version_part.to_i.to_s.rjust(10,'0')
        else
          version_part
        end
      end
    end
  end
end