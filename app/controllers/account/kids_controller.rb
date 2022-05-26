class Account::KidsController < Account::ApplicationController
  account_load_and_authorize_resource :kid, through: :team, through_association: :kids

  # GET /account/teams/:team_id/kids
  # GET /account/teams/:team_id/kids.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    # redirect_to [:account, @team]
  end

  # GET /account/kids/:id
  # GET /account/kids/:id.json
  def show
  end

  # GET /account/teams/:team_id/kids/new
  def new
  end

  # GET /account/kids/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/kids
  # POST /account/teams/:team_id/kids.json
  def create
    respond_to do |format|
      if @kid.save
        format.html { redirect_to [:account, @team, :kids], notice: I18n.t("kids.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @kid] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @kid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/kids/:id
  # PATCH/PUT /account/kids/:id.json
  def update
    respond_to do |format|
      if @kid.update(kid_params)
        format.html { redirect_to [:account, @kid], notice: I18n.t("kids.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @kid] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/kids/:id
  # DELETE /account/kids/:id.json
  def destroy
    @kid.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :kids], notice: I18n.t("kids.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def kid_params
    strong_params = params.require(:kid).permit(
      :name,
      :sex,
      :phone,
      :grade,
      :attendance_status,
      :attendance_note,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
