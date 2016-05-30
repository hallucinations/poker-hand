class Array
  def number_sequence?
    sorted = sort
    last = sorted[0]
    sorted[1, sorted.count].each do |n|
      if last + 1 != n
        return false
      end
      last = n
    end
    true
  end
end
