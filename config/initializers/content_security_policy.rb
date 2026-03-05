# Be sure to restart your server when you modify this file.

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data, "https://fonts.googleapis.com", "https://fonts.gstatic.com"
    policy.img_src     :self, :https, :data,
                       "https://maps.gstatic.com",
                       "https://maps.googleapis.com",
                       "https://*.googleapis.com"
    policy.object_src  :none
    policy.script_src  :self, :https,
                       "https://maps.googleapis.com",
                       "https://maps.gstatic.com",
                       :unsafe_inline  # importmapのインラインスクリプトに必要
    policy.style_src   :self, :https, :unsafe_inline,
                       "https://fonts.googleapis.com"
    policy.connect_src :self, :https,
                       "https://maps.googleapis.com",
                       "https://places.googleapis.com"
    policy.frame_src   :none
    policy.worker_src  :self, :blob
  end

  # importmapのインラインスクリプト用ノンス（script-srcのunsafe-inlineを削除できる）
  # config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  # config.content_security_policy_nonce_directives = %w(script-src)
end
