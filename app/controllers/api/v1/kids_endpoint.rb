class Api::V1::KidsEndpoint < Api::V1::Root
  helpers do
    params :team_id do
      requires :team_id, type: Integer, allow_blank: false, desc: "Team ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Kid ID"
    end

    params :kid do
      optional :name, type: String, desc: Api.heading(:name)
      optional :sex, type: String, desc: Api.heading(:sex)
      optional :phone, type: String, desc: Api.heading(:phone)
      optional :grade, type: String, desc: Api.heading(:grade)
      optional :attendance_status, type: String, desc: Api.heading(:attendance_status)
      optional :attendance_note, type: String, desc: Api.heading(:attendance_note)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "teams", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Kid
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
    get "/:team_id/kids" do
      @paginated_kids = paginate @kids
      render @paginated_kids, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :team_id
      use :kid
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:team_id/kids" do
      if @kid.save
        render @kid, serializer: Api.serializer
      else
        record_not_saved @kid
      end
    end
  end

  resource "kids", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Kid
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
        render @kid, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :kid
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @kid.update(declared(params, include_missing: false))
          render @kid, serializer: Api.serializer
        else
          record_not_saved @kid
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
        render @kid.destroy, serializer: Api.serializer
      end
    end
  end
end
