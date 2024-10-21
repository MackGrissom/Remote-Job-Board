class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create
    package = params[:package]
    amount = calculate_amount(package)

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: {
            name: package_name(package),
          },
          unit_amount: amount,
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url: success_payments_url(package: package),
      cancel_url: cancel_payments_url
    )

    redirect_to session.url, allow_other_host: true
  end

  def success
    package = params[:package]
    if current_user.update_subscription(package)
      redirect_to root_path, notice: "Payment successful! You can now post a job."
    else
      redirect_to new_payment_path, alert: "There was an error updating your subscription. Please try again."
    end
  end

  def cancel
    redirect_to jobs_path, alert: "Payment canceled."
  end

  private

  def calculate_amount(package)
    case package
    when 'single'
      10000 # $100
    when 'monthly'
      50000 # $500
    when 'featured'
      20000 # $200
    else
      raise "Invalid package"
    end
  end

  def package_name(package)
    case package
    when 'single'
      'Single Job Posting (60 days)'
    when 'monthly'
      'Monthly Subscription (20 postings)'
    when 'featured'
      'Featured Job Posting (7 days)'
    else
      raise "Invalid package"
    end
  end
end
