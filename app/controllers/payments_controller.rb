class PaymentsController < ApplicationController
    def create
      # Set up Stripe Checkout session
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'usd',
            product_data: {
              name: 'Job Posting Fee',
            },
            unit_amount: 5000, # $50
          },
          quantity: 1,
        }],
        mode: 'payment',
        success_url: success_payments_url,
        cancel_url: cancel_payments_url
      )
  
      redirect_to session.url, allow_other_host: true
    end
  
    def success
      # Allow the user to post a job after successful payment
      redirect_to new_job_path, notice: "Payment successful! You can now post your job."
    end
  
    def cancel
      redirect_to jobs_path, alert: "Payment canceled."
    end
  end
  