class HashMap
  attr_accessor :capacity, :size, :buckets

  def initialize(capacity = 17)
    @capacity = capacity
    @size = 0
    @buckets = Array.new(capacity) { [] }
    @load_factor = 0
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
    hash_code
  end


  def set(key, value)
    index = hash(key) % @capacity
    raise IndexError if index.negative? || index >= @buckets.length

    bucket = @buckets[index]

    existing_pair = bucket.find { |pair| pair[0] == key }

    if existing_pair
      existing_pair[1] = value
    else
      bucket << [key, value]
      @size += 1
      @load_factor = @size.to_f / @capacity
      resize if @load_factor > 0.75
    end
  end

  def get(key)
    index = hash(key) % @capacity
    raise IndexError if index.negative? || index >= @buckets.length

    bucket = @buckets[index]
    pair = bucket.find { |pair| pair[0] == key }
    pair ? pair[1] : nil
  end

  def has?(key)
    index = hash(key) % @capacity
    raise IndexError if index.negative? || index >= @buckets.length

    bucket = @buckets[index]
    bucket.any? { |pair| pair[0] == key }
  end

  def resize
    old_buckets = @buckets
    @capacity *= 2
    @buckets = Array.new(@capacity) { [] }
    @size = 0

    old_buckets.each do |bucket|
      bucket.each do |key, value|
        set(key, value)
      end
    end
  end

  def remove(key)
    index = hash(key) % @capacity
    raise IndexError if index.negative? || index >= @buckets.length

    bucket = @buckets[index]

    old_size = bucket.size
    bucket.reject! { |pair| pair[0] == key }
    if bucket.size < old_size
      @size -= 1 
      @load_factor = @size / @capacity
    end

    nil
  end

  def length
    @size
  end

  def clear
    @buckets = @buckets.map { |_| [] }
    @size = 0
    @load_factor = 0
  end

  def keys
    @buckets.flat_map { |bucket| bucket.map { |pair| pair[0] } }
  end

  def values
    @buckets.flat_map { |bucket| bucket.map { |pair| pair[1] } }
  end

  def entries
    @buckets.flatten(1)
  end
end