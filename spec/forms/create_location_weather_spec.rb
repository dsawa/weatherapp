require 'rails_helper'

RSpec.describe CreateLocationWeather do
  let(:latitude) { 54.5074 }
  let(:longitude) { -18.1278 }
  subject(:form) { described_class.new(latitude, longitude) }

  describe "#valid?" do
    context 'when valid coordinates' do
      it "is valid with numerical latitude and longitude" do
        expect(form).to be_valid
      end
    end

    context 'when invalid coordinates' do
      context 'when latitude is out of range' do
        let(:latitude) { 91 }

        it "is invalid with latitude > 90" do
          expect(form).not_to be_valid
          expect(form.errors[:latitude]).to include("must be less than or equal to 90")
        end
      end

      context 'when longitude is nil' do
        let(:longitude) { nil }

        it "is invalid without longitude" do
          expect(form).not_to be_valid
          expect(form.errors[:longitude]).to include("can't be blank")
        end
      end

      context 'when latitude is nil' do
        let(:latitude) { nil }

        it "is invalid without latitude" do
          expect(form).not_to be_valid
          expect(form.errors[:latitude]).to include("can't be blank")
        end
      end

      context 'when latitude is non-numerical' do
        let(:latitude) { "north" }

        it "is invalid with non-numerical latitude" do
          expect(form).not_to be_valid
          expect(form.errors[:latitude]).to include("is not a number")
        end
      end
    end
  end

  describe "#latitude" do
    it "returns the latitude value" do
      expect(form.latitude).to eq(latitude)
    end
  end

  describe "#longitude" do
    it "returns the longitude value" do
      expect(form.longitude).to eq(longitude)
    end
  end
end
