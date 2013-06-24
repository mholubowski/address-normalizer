require 'benchmark'

require_relative 'address_tokenizer'
require_relative 'api_address_verifier'

at = AddressTokenizer.new
av = ApiAddressVerifier.new

addr = at.tokenize('6587 Del Playa Drive Unit 3 Los Angeles, CA 93117')
p addr

l = av.create_easypost_call(addr)
p l

response = l.call
p response

test1 = Benchmark.measure do 
	5.times {l.call}
end

test2 = Benchmark.measure do 
	responses = []

	thread1 = Thread.start do
		5.times {responses << l.call}
		puts "Thread 1 is done"
	end

	thread2 = Thread.start do
		5.times {responses << l.call}
		puts "Thread 2 is done"
	end

	thread3 = Thread.start do
		5.times {responses << l.call}
		puts "Thread 3 is done"
	end

	thread1.join
	thread2.join
	thread3.join
	puts "All threads done"
	p responses
end

test3 = Benchmark.measure do
	responses = []

	10.times do
		Thread.start do
			5.times { responses << l.call}
			puts "Thread Done"
		end
	end
end

p "One: #{test1}"
p "Two: #{test2}"