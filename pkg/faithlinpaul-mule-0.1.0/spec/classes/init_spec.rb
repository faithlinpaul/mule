require 'spec_helper'
describe 'mule' do

  context 'with defaults for all parameters' do
    it { should contain_class('mule') }
  end
end
