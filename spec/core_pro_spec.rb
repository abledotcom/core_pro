# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CorePro::Resource do
  describe '#all', vcr: VCR_OPTS do
    let(:customers) do
      CorePro::Customer.all({})
    end

    it do
      expect(customers).not_to be_empty
      expect(customers.size).to eq(2)

      customer = customers.first

      expect(customer.firstName).to eq('Stas')
      expect(customer.customerId).to eq(12_345)

      expect(customer).to be_a(CorePro::Customer)
    end
  end

  describe '#all for accounts', vcr: VCR_OPTS do
    let(:accounts) do
      CorePro::Account.all([6_795_910], {})
    end

    it do
      expect(accounts).not_to be_empty
      expect(accounts.size).to eq(2)

      account = accounts.first

      expect(account.name).to eq('Stas')
      expect(account.customerId).to eq(12_345)

      expect(account).to be_a(CorePro::Account)
    end
  end

  describe '#create', vcr: VCR_OPTS do
    let(:new_account) do
      CorePro::Account.create(
        name: 'Test',
        customerId: 12_345,
        productId: 98_765
      )
    end

    it do
      expect(new_account).not_to be_empty

      expect(new_account.name).to eq('Test')
      expect(new_account.customerId).to eq(12_345)

      expect(new_account).to be_a(CorePro::Account)
    end
  end
end
