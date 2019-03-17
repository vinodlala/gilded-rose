class GildedRose
  attr_reader :name, :days_remaining, :quality

  METHODS_HASH = {
    "Aged Brie": "tick_aged_brie",
    "Backstage passes to a TAFKAL80ETC concert": "tick_concert",
    "Conjured Mana Cake": "tick_cake",
    "Sulfuras, Hand of Ragnaros": "tick_sulfurus"
  }

  MIN_QUALITY = 0

  MAX_QUALITY = 50

  def initialize(name:, days_remaining:, quality:)
    @name = name
    @days_remaining = days_remaining
    @quality = quality
  end

  def tick_old
    if @name != "Aged Brie" and @name != "Backstage passes to a TAFKAL80ETC concert"
      if @quality > 0
        if @name != "Sulfuras, Hand of Ragnaros"
          @quality = @quality - 1
        end
      end
    else
      if @quality < 50
        @quality = @quality + 1
        if @name == "Backstage passes to a TAFKAL80ETC concert"
          if @days_remaining < 11
            if @quality < 50
              @quality = @quality + 1
            end
          end
          if @days_remaining < 6
            if @quality < 50
              @quality = @quality + 1
            end
          end
        end
      end
    end
    if @name != "Sulfuras, Hand of Ragnaros"
      @days_remaining = @days_remaining - 1
    end
    if @days_remaining < 0
      if @name != "Aged Brie"
        if @name != "Backstage passes to a TAFKAL80ETC concert"
          if @quality > 0
            if @name != "Sulfuras, Hand of Ragnaros"
              @quality = @quality - 1
            end
          end
        else
          @quality = @quality - @quality
        end
      else
        if @quality < 50
          @quality = @quality + 1
        end
      end
    end
  end

  def tick_not_as_old
    method_name = METHODS_HASH[@name.to_sym]
    if method_name
      send(method_name)
      puts "hi"
      return
    end

    # Aged Brie
    if is_aged_brie?
      tick_aged_brie
      return
    end

    # Sulfuras, Hand of Ragnaros
    if is_sulfurus?
      return
    end

    # Backstage passes to a TAFKAL80ETC concert
    if is_concert?
      tick_concert
      return
    end

    # Conjured Mana Cake
    if is_cake?
      # decrease_days_remaining
      #
      # if negative_days_remaining?
      #   decrease_quality(4)
      # else
      #   decrease_quality(2)
      # end
      tick_cake

      return
    end

    # Normal Item
    decrease_quality(1)
    decrease_days_remaining
    if negative_days_remaining?
      decrease_quality(1)
    end
  end

  def tick
    method_name = METHODS_HASH[@name.to_sym]

    if method_name
      send(method_name)
      return
    end

    tick_normal_item
    # decrease_quality(1)
    #
    # decrease_days_remaining
    #
    # if negative_days_remaining?
    #   decrease_quality(1)
    # end
  end

  def tick_aged_brie
    decrease_days_remaining

    if negative_days_remaining?
      increase_quality(2)
    else
      increase_quality(1)
    end
  end

  def tick_cake
    decrease_days_remaining

    if negative_days_remaining?
      decrease_quality(4)
    else
      decrease_quality(2)
    end
  end

  def tick_concert
    decrease_days_remaining

    case days_remaining
    when 10..999
      increase_quality(1)
    when 5..9
      increase_quality(2)
    when 0..4
      increase_quality(3)
    else
      decrease_quality(@quality)
    end
  end

  def tick_normal_item
    decrease_quality(1)

    decrease_days_remaining

    if negative_days_remaining?
      decrease_quality(1)
    end
  end

  def tick_sulfurus
  end

  def decrease_quality(change)
    changed_quality = @quality - change
    # @quality = [changed_quality, 0].max
    @quality = [changed_quality, MIN_QUALITY].max
  end

  def decrease_days_remaining
    @days_remaining = @days_remaining - 1
  end

  def increase_quality(change)
    changed_quality = @quality + change
    # @quality = [changed_quality, 50].min
    @quality = [changed_quality, MAX_QUALITY].min
  end

  def negative_days_remaining?
    @days_remaining < 0
  end

  def is_aged_brie?
    @name == "Aged Brie"
  end

  def is_concert?
    @name == "Backstage passes to a TAFKAL80ETC concert"
  end

  def is_cake?
    @name == "Conjured Mana Cake"
  end

  def is_sulfurus?
    @name == "Sulfuras, Hand of Ragnaros"
  end
end
