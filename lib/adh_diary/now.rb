module AdhDiary
  class Now
    def self.instance
      @instance ||= Now.new
    end

    def self.override!(fake_start_time, &block)
      raise "Overriding time is not allowed in production!" if Hanami.env == :production

      @instance = Now.new(fake_start_time)
      if block_given?
        result = block.call
        reset!
        result
      end
    end

    def self.reset!
      @instance = Now.new
    end

    def self.time
      instance.time
    end

    def self.date
      instance.date
    end

    def initialize(fake_start_time = nil)
      @fake_start_time = fake_start_time
      @actual_start_time = Time.now.utc
    end

    def time
      if @fake_start_time.nil?
        Time.now.utc
      else
        elapsed_time = Time.now.utc - @actual_start_time
        @fake_start_time + elapsed_time
      end
    end

    def date
      time.to_date
    end
  end
end
