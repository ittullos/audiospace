require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:isaac)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'

    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2'

    content = "This micropost really ties the room together"
    image = fixture_file_upload('coolpic.jpg', 'image/jpeg')
    audio = fixture_file_upload('bussin.mp3', 'audio/mp3')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, images: [image], audios: [audio] } }
    end
    assert assigns(:micropost).images.attached?
    assert assigns(:micropost).audios.attached?
    assert_equal 1, assigns(:micropost).images.count
    follow_redirect!
    assert_match content, response.body

    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    get user_path(users(:archer))
    assert_select 'a', { text: 'delete', count: 0 }
  end
end
