class SubscriptionsController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_subscription, only: [:destroy]

  def create
    if @event.user != current_user
      email = subscription_params[:user_email]

      if current_user == nil && email_exist_in_db?(email)
        redirect_to :back, alert: I18n.t('controllers.subscriptions.error')
      else
        @new_subscription = @event.subscriptions.build(subscription_params)
        @new_subscription.user = current_user

        if @new_subscription.save
          redirect_to @event, notice: I18n.t('controllers.subscriptions.created')
        else
          render 'events/show', alert: I18n.t('controllers.subscriptions.error')
        end
      end
    else
      redirect_to :back, alert: I18n.t('controllers.subscriptions.error')
    end
  end

  def destroy
    message = {notice: I18n.t('controllers.subscriptions.destroyed')}

    if current_user_can_edit?(@subscription)
      @subscription.destroy
    else
      message = {alert: I18n.t('controllers.subscriptions.error')}
    end

    redirect_to @event, message
  end

  private
  def set_event
    @event = Event.find(params[:event_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_subscription
    @subscription = @event.subscriptions.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def subscription_params
    params.fetch(:subscription, {}).permit(:user_email, :user_name)
  end

  def email_exist_in_db?(email)
    User.all.map {|em| em[:email]}.include?(email)
  end
end
