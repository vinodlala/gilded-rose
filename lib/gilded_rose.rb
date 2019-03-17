class GildedRose
  attr_reader :name, :days_remaining, :quality

  SPECIAL_ITEM_METHODS = {
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

  def tick
    method_name = SPECIAL_ITEM_METHODS[@name.to_sym]

    if method_name
      send(method_name)
    else
      tick_normal_item
    end
  end

  def tick_aged_brie
    decrease_days_remaining

    if negative_days_remaining?
      increase_or_maximize_quality(2)
    else
      increase_or_maximize_quality(1)
    end
  end

  def tick_cake
    decrease_days_remaining

    if negative_days_remaining?
      decrease_or_minimize_quality(4)
    else
      decrease_or_minimize_quality(2)
    end
  end

  def tick_concert
    decrease_days_remaining

    case days_remaining
    when 10..Float::INFINITY
      increase_or_maximize_quality(1)
    when 5..9
      increase_or_maximize_quality(2)
    when 0..4
      increase_or_maximize_quality(3)
    else
      make_quality_zero
    end
  end

  def tick_normal_item
    decrease_days_remaining

    if negative_days_remaining?
      decrease_or_minimize_quality(2)
    else
      decrease_or_minimize_quality(1)
    end
  end

  def tick_sulfurus
  end

  def decrease_days_remaining
    @days_remaining = @days_remaining - 1
  end

  def decrease_or_minimize_quality(change)
    changed_quality = @quality - change

    # Prevent quality from going below MIN_QUALITY of 0
    @quality = [changed_quality, MIN_QUALITY].max
  end

  def increase_or_maximize_quality(change)
    changed_quality = @quality + change

    # Prevent quality from going above MAX_QUALITY of 50
    @quality = [changed_quality, MAX_QUALITY].min
  end

  def make_quality_zero
    @quality = 0
  end

  def negative_days_remaining?
    @days_remaining < 0
  end
end
