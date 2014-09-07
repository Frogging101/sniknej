class Cache
  class Entry < Struct.new(:value, :expires_at); end

  class << self
    def entries
      @entries ||= {}
    end

    def fetch(key, expires_in)
      mutex.synchronize do
        expires_at = Time.now + expires_in

        entry = entries[key]
        if entry.nil? or entry.expires_at < expires_at
          entry = entries[key] = Entry.new(yield, expires_at)
        end

        entry.value
      end
    end

    def mutex
      @mutex ||= Mutex.new
    end
  end
end
