class TesteController < ApplicationController
  def index
    render json: { message: "A API está funcionando!" }
  end
end
