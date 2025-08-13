class BookletsController < ApplicationController
  def show
    @booklet = Booklet.includes(invoices: :accounts).find(params[:id])
  end
end
