class MasterController < ApplicationController
  def index
    gon.do_path = master_do_path
  end

  def do
    if [params[:track], params[:cmdname]].all?(&:present?)
      client = OSC::Client.new 9951
      client.send OSC::Message.new("/sl/#{params[:track]}/hit", params[:cmdname])
    end
    render json: {:status => "OK"}
  end
end