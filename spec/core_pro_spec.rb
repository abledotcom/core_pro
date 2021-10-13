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

      expect(customer.firstName).to eq('James')
      expect(customer.customerId).to eq(12_345)

      expect(customer).to be_a(CorePro::Customer)
    end
  end

  describe '#onboard', vcr: VCR_OPTS do
    let(:customer) do
      CorePro::Customer.find(12_345)
    end

    it do
      expect(customer).not_to be_nil

      updated_customer = customer.onboard(:socure)

      expect(updated_customer.customerId).to eq(12_345)
      expect(updated_customer.status).to eq('Verified')
    end
  end

  describe '#create for a new customer', vcr: VCR_OPTS do
    let(:new_customer) do
      CorePro::Customer.create(
        firstName: 'James',
        lastName: 'Bond',
        isSubjectToBackupWithholding: false,
        isOptedInToBankCommunication: false,
        isDocumentsAccepted: true
      ).reload
    end

    it do
      expect(new_customer).not_to be_nil
      expect(new_customer.firstName).to eq('James')
      expect(new_customer.lastName).to eq('Bond')
      expect(new_customer.customerId).not_to be_nil

      expect(new_customer).to be_a(CorePro::Customer)
    end
  end

  describe '#all for accounts', vcr: VCR_OPTS do
    let(:accounts) do
      CorePro::Account.all([12_345], {})
    end

    it do
      expect(accounts).not_to be_empty
      expect(accounts.size).to eq(1)

      account = accounts.first

      expect(account.name).to eq('Test')
      expect(account.customerId).to eq(12_345)
      expect(account.externalAccountId).to eq(9_876)

      expect(account).to be_a(CorePro::Account)
    end
  end

  describe '#create for a new account', vcr: VCR_OPTS do
    let(:new_account) do
      CorePro::Account.create(
        name: 'Test',
        customerId: 12_345,
        productId: 98_765
      )
    end

    it do
      expect(new_account).not_to be_nil

      expect(new_account.name).to eq('Test')
      expect(new_account.customerId).to eq(12_345)
      expect(new_account.externalAccountId).not_to be_nil

      expect(new_account).to be_a(CorePro::Account)
    end
  end
end
