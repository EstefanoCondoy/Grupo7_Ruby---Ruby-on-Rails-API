require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validaciones' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:stock) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should validate_numericality_of(:stock).is_greater_than_or_equal_to(0) }
  end

  describe 'asociaciones' do
    it { should have_many(:receipt_items) }
  end

  describe '#sufficient_stock?' do
    let(:product) { create(:product, stock: 10) }

    it 'retorna true cuando hay stock suficiente' do
      expect(product.sufficient_stock?(5)).to be true
    end

    it 'retorna false cuando no hay stock suficiente' do
      expect(product.sufficient_stock?(15)).to be false
    end
  end

  describe '#deduct_stock!' do
    let(:product) { create(:product, stock: 10) }

    it 'descuenta el stock correctamente' do
      product.deduct_stock!(3)
      expect(product.reload.stock).to eq(7)
    end

    it 'lanza error si no hay stock suficiente' do
      expect { product.deduct_stock!(15) }.to raise_error(StandardError, /Stock insuficiente/)
    end
  end
end
