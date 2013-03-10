# encoding: UTF-8
post '/captcha' do
  captcha_input = params[:input]
  session_id    = params[:sessionId]

  url = "http://captchator.com/captcha/check_answer/#{session_id}/#{captcha_input}"
  body = Nestful.get(url)

  success = body.to_i == 1 ? true : false

  return { :success => success }.to_json
end
