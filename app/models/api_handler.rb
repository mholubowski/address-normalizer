class ApiHandler
  def initialize(api_type)
    @api_type = api_type
  end

  def normalize(tokenized_address)
    raise 'Can only normalize a tokenized_address' if tokenized_address.class != TokenizedAddress

    
  end 

end
