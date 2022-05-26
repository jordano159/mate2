class Account::OrganizationalUnitsController < Account::ApplicationController
  account_load_and_authorize_resource :organizational_unit, through: :team, through_association: :organizational_units

  # GET /account/teams/:team_id/organizational_units
  # GET /account/teams/:team_id/organizational_units.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    # redirect_to [:account, @team]
  end

  # GET /account/organizational_units/:id
  # GET /account/organizational_units/:id.json
  def show
  end

  # GET /account/teams/:team_id/organizational_units/new
  def new
  end

  # GET /account/organizational_units/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/organizational_units
  # POST /account/teams/:team_id/organizational_units.json
  def create
    respond_to do |format|
      if @organizational_unit.save
        format.html { redirect_to [:account, @team, :organizational_units], notice: I18n.t("organizational_units.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @organizational_unit] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @organizational_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/organizational_units/:id
  # PATCH/PUT /account/organizational_units/:id.json
  def update
    respond_to do |format|
      if @organizational_unit.update(organizational_unit_params)
        format.html { redirect_to [:account, @organizational_unit], notice: I18n.t("organizational_units.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @organizational_unit] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @organizational_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/organizational_units/:id
  # DELETE /account/organizational_units/:id.json
  def destroy
    @organizational_unit.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :organizational_units], notice: I18n.t("organizational_units.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def organizational_unit_params
    strong_params = params.require(:organizational_unit).permit(
      :name,
      :level_name,
      :level_index,
      # 🚅 super scaffolding will insert new fields above this line.
      kid_ids: [],
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    assign_select_options(strong_params, :kid_ids)
    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
