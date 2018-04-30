require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users' do
    context 'Happy Happy' do
      before do
        get users_path
      end

      it 'Return status code 200 success' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST /users' do
    context 'Happy Happy' do
      before do
        @params = { user: FactoryBot.attributes_for(:user) }
      end

      it 'Return status code 201 created' do
        post users_path, params: @params
        expect(response).to have_http_status(:created)
      end

      it 'Increment users record count' do
        expect { post users_path, params: @params }.to change(User, :count).by(1)
      end
    end
  end

  describe "Whether access is ocurring properly", type: :request do
    before(:each) do
      @current_user = FactoryBot.create(:user)
      # @client = FactoryBot.create(:client)
    end

    context "context: general authentication via API, " do
        # it "doesn't give you anything if you don't log in" do
        #    get api_client_path(@client)
        #    expect(response.status).to eq(401)
        # end

        it "gives you an authentication code if you are an existing user and you satisfy the password" do
          login
          expect(response.has_header?('access-token')).to eq(true)
        end

        it "gives you a status 200 on signing in " do
          login
          expect(response.status).to eq(200)
        end

        # it "first get a token, then access a restricted page" do
        #     login
        #     auth_params = get_auth_params_from_login_response_headers(response)
        #     new_client = FactoryBot.create(:client)
        #     get api_find_client_by_name_path(new_client.first_name), headers: auth_params
        #     expect(response).to have_http_status(:success)
        # end

        # it "deny access to a restricted page with an incorrect token" do
        #   login
        #   auth_params = get_auth_params_from_login_response_headers(response).tap { |h|
        #     h.each{|k,v|
        #       if k == 'access-token'
        #         h[k] = '123'
        #       end
        #     }
        #   }
        #   new_client = FactoryBot.create(:client)
        #   get api_find_client_by_name_path(new_client.name), headers: auth_params
        #   expect(response).not_to have_http_status(:success)
        # end
    end

    RSpec.shared_examples "use authentication tokens of different ages" do |token_age, http_status|
      let(:vary_authentication_age) { token_age }

      it "uses the given parameter" do
        expect(vary_authentication_age(token_age)).to have_http_status(http_status)
      end

      def vary_authentication_age(token_age)
          login
          auth_params = get_auth_params_from_login_response_headers(response)
          new_client = FactoryBot.create(:client)
          get api_find_client_by_name_path(new_client.first_name), headers: auth_params
          expect(response).to have_http_status(:success)

          allow(Time).to receive(:now).and_return(Time.now + token_age)

          get api_find_client_by_name_path(new_client.name), headers: auth_params
          return response
      end
    end

    context "test access tokens of varying ages" do
      # include_examples "use authentication tokens of different ages", 2.days, :success
      # include_examples "use authentication tokens of different ages", 5.years, :unauthorized
    end

    def login
      post user_session_path, params:  { email: @current_user.email, password: "password"}.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    end

    def get_auth_params_from_login_response_headers(response)
      client = response.headers['client']
        token = response.headers['access-token']
        expiry = response.headers['expiry']
        token_type = response.headers['token-type']
        uid =   response.headers['uid']

        auth_params = {
                        'access-token' => token,
                        'client' => client,
                        'uid' => uid,
                        'expiry' => expiry,
                        'token_type' => token_type
                      }
        auth_params
    end
  end
end
