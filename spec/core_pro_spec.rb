# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CorePro::Resource do
  describe '#all', vcr: 'core_pro' do
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

  describe '#onboard', vcr: 'core_pro' do
    let(:customer) do
      CorePro::Customer.find(12_345)
    end

    it do
      expect(customer).not_to be_nil

      updated_customer = customer.onboard(:socure)

      expect(updated_customer.customerId).to eq(12_345)
      expect(updated_customer.kyc['status']).to eq('Verified')
      expect(updated_customer.ofac['status']).to eq('Verified')
    end
  end

  describe '#create for a new customer', vcr: 'core_pro' do
    let(:new_customer) do
      CorePro::Customer.create(
        firstName: 'James',
        lastName: 'Bond',
        isSubjectToBackupWithholding: false,
        isOptedInToBankCommunication: false,
        isDocumentsAccepted: true,
        birthDate: '1987-07-27',
        taxId: '498931947',
        emailAddress: 'stas@startuplandia.io',
        phones: [
          {
            number: '+16502530000',
            phoneType: 'Mobile'
          }
        ],
        addresses: [
          addressLine1: '4017 Buffalo Ave',
          addressType: 'Residence',
          city: 'Buffalo',
          country: 'US',
          postalCode: '94043',
          state: 'NY'
        ]
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

  describe '#update for customer', vcr: 'core_pro' do
    it do
      customer = CorePro::Customer.update(
        customerId: 12_345,
        firstName: 'James',
        lastName: 'Bond',
        isSubjectToBackupWithholding: false,
        isOptedInToBankCommunication: false,
        birthDate: '1987-07-27',
        taxId: '498931947',
        emailAddress: 'stas@startuplandia.io',
        phones: [
          {
            number: '+16502530000',
            phoneType: 'Mobile'
          }
        ],
        addresses: [
          addressLine1: '4017 Buffalo Ave',
          addressType: 'Residence',
          city: 'Buffalo',
          country: 'US',
          postalCode: '94043',
          state: 'NY'
        ]
      )

      expect(customer.firstName).to eq('James')
      expect(customer.lastName).to eq('Bond')
      expect(customer.customerId).to eq(12_345)
    end
  end

  describe '#update with errors for customer', vcr: 'core_pro_errors' do
    it do
      expect do
        CorePro::Customer.update(
          customerId: 12_345,
          firstName: 'James'
        )
      end.to raise_error(
        HTTP::RestClient::ResponseError,
        /used during the ID Verification process is not allowed/
      )
    end
  end

  describe '#create with errors', vcr: 'core_pro_errors' do
    let(:new_customer) do
      CorePro::Customer.create(
        lastName: 'Bond',
        isSubjectToBackupWithholding: false,
        isOptedInToBankCommunication: false,
        isDocumentsAccepted: true
      ).reload
    end

    it do
      expect { new_customer }.to raise_error(
        HTTP::RestClient::ResponseError,
        /First Name is a required field/
      )
    end
  end

  describe '#all for accounts', vcr: 'core_pro' do
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

  describe '#create for a new account', vcr: 'core_pro' do
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
      expect(new_account.accountId).not_to be_nil

      expect(new_account).to be_a(CorePro::Account)
    end
  end

  describe '#error_response?', vcr: 'core_pro_errors' do
    it do
      expect { CorePro::Account.all }
        .to raise_error(HTTP::RestClient::ResponseError, '502 Bad Gateway')
    end
  end
end
