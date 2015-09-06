require 'spec_helper'

describe Logasm::Utils do
  describe '.build_event' do
    subject(:event) { described_class.build_event(metadata, level, service_name) }

    let(:service_name) { 'test_service' }
    let(:level)        { 'INFO' }
    let(:metadata)     { {x: 'y'} }

    context 'when service name is in correct format' do
      it 'includes it in the event as application' do
        expect(event[:application]).to eq('test_service')
      end
    end

    context 'when service name is in camelcase' do
      let(:service_name) { 'InformationService' }

      it 'includes it in the event as lower snake case' do
        expect(event[:application]).to eq('information_service')
      end
    end

    it 'includes level as a lower case string' do
      expect(event[:level]).to eq('info')
    end

    it 'includes timestamp' do
      expect(event[:@timestamp]).to match(/\d{4}.*/)
    end

    it 'includes the host' do
      expect(event[:host]).to be_a(String)
    end
  end
end