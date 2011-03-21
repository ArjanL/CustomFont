# CustomFont
# by Joern Akkermann
# joern@worldlancers.info

class CustomFont
  attr_reader :filename

  PT_H1 = 45
  PT_H2 = 35
  PT_H3 = 25
  PT_P = 14

  def self.pt_h1
    PT_H1
  end

  def self.pt_h2
    PT_H2
  end

  def self.pt_h3
    PT_H3
  end

  def self.pt_p
    PT_P
  end

  def self.pt_to_px(pt)
    (Float(96 * pt / 72)).round
  end

  def initialize(text="CustomFont", font="Verdana-Bold", pt=PT_H1, tag="h1", kill=false, root_dir="public/images/custom_font/", url="/images/custom_font/")
    @text = text
    @font = font
    @pt = pt
    @tag = tag
    @kill = kill
    @root_dir = root_dir
    @url = url
    @filename = (@font + "_" + @text[0,30].scan(/[0-9A-Za-z]+/).join + "_" + @pt.to_s.gsub(".","-") + "_" + @tag + ".jpg").gsub(/[\s]+/, "_")
  end

  def url
    @url + self.filename
  end

  def location
    @root_dir + self.filename
  end

  def exists?
    File.exists?(self.location)
  end

  def width
    CustomFont.pt_to_px(@pt) * @text.length / 2
  end

  def height
    CustomFont.pt_to_px(@pt)
  end

  def generate_image
    if !self.exists?

      if !File.directory?(@root_dir)
        Dir.mkdir(@root_dir)
      end

      require "RMagick"

      image = Magick::ImageList.new
      image.new_image(self.width, self.height)

      text = Magick::Draw.new
      text.font = @font
      text.pointsize = @pt
      text.gravity = Magick::WestGravity

      text.annotate(image, 0, 0, 0, 0, @text) {
        self.fill = "black"
      }

      image.write(@root_dir + self.filename)
    end

    self
  end

  def to_html
    "<#{@tag} style=\"background: url('#{self.url}') no-repeat; width: #{self.width.to_s}px; height: #{self.height.to_s}px; text-indent: -9999px; overflow: hidden;\">#{@text}</#{@tag}>"
  end

  def to_s
    self.generate_image.to_html
  end

  def __destroy
    if @kill
      File.delete(self.location)
    end
  end
end
