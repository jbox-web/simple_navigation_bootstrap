require 'spec_helper'

describe SimpleNavigationBootstrap::Error::InvalidHash do
  it 'has specific default message' do
    expect(subject.message).to eq "Hash does not contain any of parameters: 'text', 'icon'"
  end
end
