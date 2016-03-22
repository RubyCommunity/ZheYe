class QiniuWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3
  sidekiq_options queue: :qiniu

  def perform(type, params)
    self.send(type, params)
  end

  # def init_user_avatar(params)
  #    params["user"].update_attributes(remote_avatar_url: "#{user.gravatar_url}?s=512")
  # end
end