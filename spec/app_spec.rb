require_relative 'spec_helper'

feature 'Base application' do
    scenario 'Page should say hello to the world' do
        visit '/'
        page.should have_content 'Hello, World'
    end
end