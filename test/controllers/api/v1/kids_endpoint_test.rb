require "test_helper"
require "controllers/api/test"

class Api::V1::KidsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @kid = create(:kid, team: @team)
      @other_kids = create_list(:kid, 3)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(kid_data)
      # Fetch the kid in question and prepare to compare it's attributes.
      kid = Kid.find(kid_data["id"])

      assert_equal kid_data['name'], kid.name
      assert_equal kid_data['sex'], kid.sex
      assert_equal kid_data['phone'], kid.phone
      assert_equal kid_data['grade'], kid.grade
      assert_equal kid_data['attendance_status'], kid.attendance_status
      assert_equal kid_data['attendance_note'], kid.attendance_note
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal kid_data["team_id"], kid.team_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/teams/#{@team.id}/kids", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      kid_ids_returned = response.parsed_body.dig("data").map { |kid| kid.dig("attributes", "id") }
      assert_includes(kid_ids_returned, @kid.id)

      # But not returning other people's resources.
      assert_not_includes(kid_ids_returned, @other_kids[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/kids/#{@kid.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      get "/api/v1/kids/#{@kid.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      kid_data = Api::V1::KidSerializer.new(build(:kid, team: nil)).serializable_hash.dig(:data, :attributes)
      kid_data.except!(:id, :team_id, :created_at, :updated_at)

      post "/api/v1/teams/#{@team.id}/kids",
        params: kid_data.merge({access_token: access_token})

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      post "/api/v1/teams/#{@team.id}/kids",
        params: kid_data.merge({access_token: another_access_token})
      # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
      assert_response :forbidden
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/kids/#{@kid.id}", params: {
        access_token: access_token,
        name: 'Alternative String Value',
        phone: '+19053871234',
        attendance_note: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # But we have to manually assert the value was properly updated.
      @kid.reload
      assert_equal @kid.name, 'Alternative String Value'
      assert_equal @kid.phone, '+19053871234'
      assert_equal @kid.attendance_note, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/kids/#{@kid.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Kid.count", -1) do
        delete "/api/v1/kids/#{@kid.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/kids/#{@kid.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end
end
