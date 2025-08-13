module Subscriptions
  class BillCustomer
    include Dry::Monads[:result]

    def initialize(params:)
      @params = params
      @contract = BillCustomerContract.new
    end

    def call
      validation = @contract.call(@params)
      return Failure(validation.errors.to_h) if validation.failure?

      subscription = @params[:subscription]

      booklet = Booklet.create!(subscription: subscription)

      ActiveRecord::Base.transaction do
        12.times do |i|
          due_date = subscription.created_at.next_month(i + 1).to_date
          invoice = booklet.invoices.create!(
            due_date: due_date,
            value: 0
          )

          accounts = build_accounts_for_month(subscription, due_date)
          total_value = accounts.sum(&:value)
          invoice.update!(value: total_value)
        end
      end

      Success(booklet)
    end

    private

    def build_accounts_for_month(subscription, due_date)
      items = []

      if subscription.plan.present?
        items << Account.create!(
          billable: subscription.plan,
          invoice: Invoice.last,
          due_date: due_date,
          value: subscription.plan.value
        )
      elsif subscription.package.present?
        items << Account.create!(
          billable: subscription.package,
          invoice: Invoice.last,
          due_date: due_date,
          value: subscription.package.value
        )
      end

      subscription.additional_services.each do |service|
        items << Account.create!(
          billable: service,
          invoice: Invoice.last,
          due_date: due_date,
          value: service.value
        )
      end

      items
    end
  end
end
