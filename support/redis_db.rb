### Singleton Class
### RedisDb.
class RedisDb

	def initialize
		@connection = Redis.new
	end

	@@instance = RedisDb.new

	def self.instance
		@@instance
	end

	def respond_to?(method_name)
		super(method_name) || connection.respond_to?(method_name)
	end

	def method_missing(method_name, *args, &block)
		if connection.respond_to?(method_name)
			connection.send(method_name, *args, &block)
		end
	end

	private_class_method :new

	private

	attr_reader :connection

end

