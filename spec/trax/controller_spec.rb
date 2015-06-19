require 'spec_helper'

describe ::Trax::Controller do
  subject { described_class }
  it { subject.mixin_registry.should be_a(Hash) }

  context "Including Controller" do
    subject{ ::PostsController }
    it { expect(subject.methods).to include(:defaults) }
    it {
      expect(subject.trax_controller_config.resource_serializer).to eq ::PostsSerializer
    }
  end

end
