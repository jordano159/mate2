class Api::V1::OrganizationalUnitsEndpoint < Api::V1::Root
  helpers do
    params :team_id do
      requires :team_id, type: Integer, allow_blank: false, desc: "Team ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Organizational Unit ID"
    end

    params :organizational_unit do
      optional :name, type: String, desc: Api.heading(:name)
      optional :level_name, type: String, desc: Api.heading(:level_name)
      optional :level_index, type: String, desc: Api.heading(:level_index)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "teams", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource OrganizationalUnit
    end

    #
    # INDEX
    #

    desc Api.title(:index), &Api.index_desc
    params do
      use :team_id
    end
    oauth2
    paginate per_page: 100
    get "/:team_id/organizational_units" do
      @paginated_organizational_units = paginate @organizational_units
      render @paginated_organizational_units, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :team_id
      use :organizational_unit
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:team_id/organizational_units" do
      if @organizational_unit.save
        render @organizational_unit, serializer: Api.serializer
      else
        record_not_saved @organizational_unit
      end
    end
  end

  resource "organizational_units", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource OrganizationalUnit
    end

    #
    # SHOW
    #

    desc Api.title(:show), &Api.show_desc
    params do
      use :id
    end
    oauth2
    route_param :id do
      get do
        render @organizational_unit, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :organizational_unit
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @organizational_unit.update(declared(params, include_missing: false))
          render @organizational_unit, serializer: Api.serializer
        else
          record_not_saved @organizational_unit
        end
      end
    end

    #
    # DESTROY
    #

    desc Api.title(:destroy), &Api.destroy_desc
    params do
      use :id
    end
    route_setting :api_resource_options, permission: :destroy
    oauth2 "delete"
    route_param :id do
      delete do
        render @organizational_unit.destroy, serializer: Api.serializer
      end
    end
  end
end
