# frozen_string_literal: true

require 'spec_helper'

shared_context 'Grape API App' do
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
end
