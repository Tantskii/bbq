class SubscriptionsController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_subscription, only: [:destroy]

  before_action :redirect_if_user_is_creater, only: [:create]

  def create
    @new_subscription      = @event.subscriptions.build(subscription_params)
    @new_subscription.user = current_user

    if @new_subscription.save
      EventMailer.subscription(@event, @new_subscription).deliver_now
      redirect_to @event, notice: I18n.t('controllers.subscriptions.created')
    else
      render 'events/show', alert: I18n.t('controllers.subscriptions.error')
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

  def redirect_if_user_is_creater
    redirect_to :back, alert: I18n.t('controllers.subscriptions.error') if @event.user == current_user
  end
end
