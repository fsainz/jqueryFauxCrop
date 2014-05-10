#
# Name    : Jquery Faux Crop
# Author  : Fernando Sainz, fsainz.com, @fsainz
# Version : 0.01
# Repo    : https://github.com/fsainz/jqueryFauxCrop


jQuery ->
  $.faux_crop = ( element, options ) ->
    # plugin settings
    @settings = {}

    # jQuery version of DOM element attached to the plugin
    @$element = $ element

    @init = ->
      @settings = $.extend( {}, @defaults, options )
      @settings.coordinates_for_cropping = true if @settings.original_crop_x?
      @$element.html @output()

    @output = ->
      """
      <div class='faux_crop' style='#{@css_style_for_container()}'>
        <img src='#{@settings.image_path}' style='#{@css_style_for_image()}'>
      </div>
      """          

    @css_style_for_container = ->  "position: relative; overflow:hidden; width:#{@settings.target_size}px; height:#{@settings.target_size}px"
    
    @css_style_for_image = -> 
      if @settings.coordinates_for_cropping
        css_style = @css_style_for_cropped_image()
      else
        css_style = @css_style_for_gravity_crop()
      css_style

    @css_style_for_cropped_image = ->
      frame_multiplier = @settings.width / @settings.original_crop_size  # how larger was the image compared to the crop
      offset_multiplier = @settings.target_size/@settings.original_crop_size
      new_width = @settings.target_size * frame_multiplier   # new_height: auto
      x_offset = - @settings.original_crop_x * offset_multiplier
      y_offset = - @settings.original_crop_y * offset_multiplier
      css_style= "width:#{new_width}px; max-width:none;height:auto; margin-left:#{x_offset}px; margin-top:#{y_offset}px; display:block;" 


    @css_style_for_gravity_crop = -> 
      ratio = @settings.width / @settings.height
      if ratio > 1
        normalized_width = (@settings.target_size * ratio)
        offset = (@settings.target_size - normalized_width)/2
        css_style = "height:#{@settings.target_size}px; width:auto; max-width:none;margin-left:#{offset}px;display:block;"
      else
        normalized_height = (@settings.target_size / ratio)
        offset= (@settings.target_size - normalized_height)/2      
        css_style = "width:#{@settings.target_size}px; height:auto;margin-top:#{offset}px;display:block;"    
      css_style

    # initialise the plugin
    @init()

    # make the plugin chainable
    this

  # default plugin settings
  $.faux_crop::defaults = {}

  $.fn.faux_crop = ( options ) ->
    this.each ->
      $this = $(this)
      data_options =
        image_path          : $this.data("image-path")
        width               : $this.data("width")
        height              : $this.data("height")
        target_size         : $this.data("target-size")
        original_crop_x     : $this.data("original-crop-x")
        original_crop_y     : $this.data("original-crop-y")
        original_crop_size  : $this.data("original-crop-size")
      options = $.extend( {}, data_options, options )   
      new $.faux_crop( this, options )

      