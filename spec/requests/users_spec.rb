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
end
