def test(&block)
 block.call('mike')
end

test {|a| p "Hi #{a}"}
