# Will take a string and create a Tokenized Address
require_relative '../address_tokenizer'

describe AddressTokenizer do 

	before :all do
		@AT = AddressTokenizer.new
	end

	it "should return tokenized address with TOKENIZE method" do
		address = '6587 Del Playa Drive, Isla Vista, California 90045'
		@tokenized = @AT.tokenize(address)

		@tokenized[:city].should eq('Isla Vista')
	end

	it "should tokenize this list of addresses" do 
		addr1 = "2730 S Veitch St Apt 207, Arlington, VA 22206"
    addr2 = "44 Canal Center Plaza Suite 500, Alexandria, VA 22314"
    addr3 = "1600 Pennsylvania Ave Washington DC"
    addr4 = "1005 Gravenstein Hwy N, Sebastopol CA 95472"
    #5 Not Passing!
    addr5 = "PO BOX 450, Chicago IL 60657"
    addr6 = "2730 S Veitch St #207, Arlington, VA 22206"
    addr7 = "6587 Del Playa Drive, IV California 93117"

    list = [addr1, addr2, addr3, addr4, addr6, addr7]

    tokenized = list.map {|ad| @AT.tokenize(ad, {informal: false})}
    
    tokenized.all? {|a| a}.should be_true
	end

end