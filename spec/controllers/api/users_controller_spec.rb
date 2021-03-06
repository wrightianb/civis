require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do

  describe 'GET #logged_in_user' do
    context 'logged in' do
      login_user
      it 'allows authenticated access' do
        get :logged_in_user
        user = JSON.parse(response.body)
        expect(user['id']).to eq(@user.id)
      end

      it 'returns http succes' do
        get :logged_in_user
        expect(response).to have_http_status(:success)
      end
    end

    context 'logged out' do
      it 'blocks unauthenticated access' do
        get :logged_in_user
        user = JSON.parse(response.body)
        expect(user).to eq({})
      end
    end
  end

  describe 'PUT #show' do
    context 'logged in user' do
      login_user

      it 'render the show json' do
        get :show
        user = JSON.parse(response.body)
        expect(user['id']).to eq(@user.id)
        expect(user['full_name']).to eq(@user.full_name)
      end
    end
  end

  describe 'PUT #update' do
    context 'logged in user' do
      login_user

      it 'updates user with valid params' do
        put :update, {user: {first_name: 'Jeremy', last_name: 'Cram' } }
        current_user = JSON.parse(response.body)
        @user.reload
        expect(current_user['first_name']).to eq(@user.first_name)
        expect(current_user['last_name']).to eq(@user.last_name)
      end

      it 'fails to update user with invalid params' do
        put :update, { user: {first_name: '', last_name: 'Cram' } }
        current_user = JSON.parse(response.body)
        expect(current_user.keys).to eq(['errors'])
        expect(current_user['errors']).to include("Could Not Save Updates")
        expect(current_user['first_name']).to_not eq(@user.first_name)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'logged in user' do
      login_user

      it 'destroys the user' do
        delete :destroy, params: {id: @user.id}
        @user.destroy
        expect(User.count).to eq(0)
      end
    end
  end
end
