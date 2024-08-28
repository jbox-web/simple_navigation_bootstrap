# frozen_string_literal: true

require 'spec_helper'

describe SimpleNavigationBootstrap::Error::InvalidHash do
  subject(:exception) { described_class.new }

  it 'has specific default message' do
    expect(exception.message).to eq "Hash does not contain any of parameters: 'text', 'icon'"
  end
end
