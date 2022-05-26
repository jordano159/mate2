require "test_helper"
require "controllers/api/test"

class Api::V1::OrganizationalUnitsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @organizational_unit = create(:organizational_unit, team: @team)
      @other_organizational_units = create_list(:organizational_unit, 3)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(organizational_unit_data)
      # Fetch the organizational_unit in question and prepare to compare it's attributes.
      organizational_unit = OrganizationalUnit.find(organizational_unit_data["id"])

      assert_equal organizational_unit_data['name'], organizational_unit.name
      assert_equal organizational_unit_data['level_name'], organizational_unit.level_name
      assert_equal organizational_unit_data['level_index'], organizational_unit.level_index
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal organizational_unit_data["team_id"], organizational_unit.team_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/teams/#{@team.id}/organizational_units", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      organizational_unit_ids_returned = response.parsed_body.dig("data").map { |organizational_unit| organizational_unit.dig("attributes", "id") }
      assert_includes(organizational_unit_ids_returned, @organizational_unit.id)

      # But not returning other people's resources.
      assert_not_includes(organizational_unit_ids_returned, @other_organizational_units[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/organizational_units/#{@organizational_unit.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      get "/api/v1/organizational_units/#{@organizational_unit.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      organizational_unit_data = Api::V1::OrganizationalUnitSerializer.new(build(:organizational_unit, team: nil)).serializable_hash.dig(:data, :attributes)
      organizational_unit_data.except!(:id, :team_id, :created_at, :updated_at)

      post "/api/v1/teams/#{@team.id}/organizational_units",
        params: organizational_unit_data.merge({access_token: access_token})

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      post "/api/v1/teams/#{@team.id}/organizational_units",
        params: organizational_unit_data.merge({access_token: another_access_token})
      # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
      assert_response :forbidden
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/organizational_units/#{@organizational_unit.id}", params: {
        access_token: access_token,
        name: 'Alternative String Value',
        level_name: 'Alternative String Value',
        level_index: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # But we have to manually assert the value was properly updated.
      @organizational_unit.reload
      assert_equal @organizational_unit.name, 'Alternative String Value'
      assert_equal @organizational_unit.level_name, 'Alternative String Value'
      assert_equal @organizational_unit.level_index, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/organizational_units/#{@organizational_unit.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("OrganizationalUnit.count", -1) do
        delete "/api/v1/organizational_units/#{@organizational_unit.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/organizational_units/#{@organizational_unit.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end
end
