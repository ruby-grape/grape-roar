require 'spec_helper'

describe Grape::Roar do
  subject do
    Class.new(Grape::API)
  end

  before do
    subject.format :json
    subject.formatter :json, Grape::Formatter::Roar
  end

  def app
    subject
  end

  context "article" do
  
    before do
      subject.get("/article/:id") {
        Article.new({ 
          :title => "Lonestar", 
          :id => params[:id] 
        }).to_json
      }
    end

    it 'returns a hypermedia representation' do
      get "/article/666"
      last_response.body.should == '{"title":"Lonestar","id":"666","links":[{"rel":"self","href":"/article/666"}]}'
    end

  end
end
