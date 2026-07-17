require 'rails_helper'

RSpec.describe Receipt, type: :model do
  describe 'asociaciones' do
    it { should belong_to(:user) }
    it { should have_many(:receipt_items).dependent(:destroy) }
  end
end
