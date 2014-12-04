require 'word_check'
include WordCheck

class Post < ActiveRecord::Base

  #Association
  belongs_to :user
  belongs_to :last_reply_user, :class_name => "User", :foreign_key => 'last_reply_user_id'
  belongs_to :point
  belongs_to :category
  has_many :replies, dependent: :destroy

  #Validate
  validates :user_id, presence: true
  validates :point_id, presence: true
  validates :category_id, presence: true
  validates :source, presence: true
  validates :title, presence: true, allow_blank: false
  validates :content, presence: true, allow_blank: false

  #Constants
  SOURCES = %W(原创或翻译 转载或分享)

  #Callback
  before_save :validate_tags, :validate_sensitive?

  #Scope
  default_scope -> { order('created_at desc') }

  def published_time
    self.created_at.strftime('%Y-%m-%d %H:%M')
  end

  private
  def validate_tags
    tags_str = self.tags.gsub(/，/, ',')

    if tags_str.split(',').size > 5
      errors.add(:tags, '关键词超过5个了')
      false
    else
      self.tags = tags_str
      true
    end
  end

  def validate_sensitive?
    word = WordCheck.first_sensitive(self.inspect)
    if word.present?
      errors.add(:base, "文章内容包含敏感词汇: #{word}")
      false
    end
  end
end
