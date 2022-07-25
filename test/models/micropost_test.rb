require "test_helper"
include ActionDispatch::TestProcess

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:isaac)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "  "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

  test "can have multiple images" do
    @micropost.images.attach(io: File.open('test/fixtures/files/coolpic.jpg'),
                                           filename: 'coolpic.jpg',
                                           content_type: 'image/jpeg')
    @micropost.images.attach(io: File.open('test/fixtures/files/android-flat.png'),
                                           filename: 'android-flat.png',
                                           content_type: 'image/png')
    assert @micropost.valid?
  end

  test "does not save duplicates" do
    @micropost.images.attach(io: File.open('test/fixtures/files/android-flat.png'),
                                           filename: 'android-flat.png',
                                           content_type: 'image/png')
    @micropost.save
    post = Micropost.find("#{@micropost.id}")                                      
    assert_equal 1, post.images.count
  end
end
