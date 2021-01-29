class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save && is_admin?
      flash[:user_created] = "Usuario creado"
      redirect_to user_path(@user.id)
    else
      flash[:user_not_created] = "El usuario no pudo crearse"
      redirect_to new_user_path
    end
  end

  def index
    @users = User.all.order(created_at: :desc)
  end

  def destroy
    @user = User.find params[:id]
    @actived = !@user.active
    if @actived
      message = "Activado"
    else
      message = "Desactivado"
    end
    if @user.update_attribute(:active, @actived)
      flash[:success_actived] = "Usuario #{@user.userid} #{message}"
      redirect_to users_path
    else
      flash[:error_delete] = "Usuario no se pudo desactivar"
    end
  end

  private

  def user_params
    params.require(:user).permit(:userid, :password)
  end
end
