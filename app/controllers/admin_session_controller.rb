class AdminSessionController < AdminController
  def get
    render "admin/login"
  end

  def post
    @user = User.find_by_email params[:email]
    return render("admin/login") if @user.blank? || @user.role.blank?
    return render("admin/login") unless @user.valid_password?(params[:password])
    sign_in(:user, @user)
    redirect_to rails_admin_path
  end
end