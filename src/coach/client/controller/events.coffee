Coach.Controller.Events =
  ClassMethods:
    DOM_EVENTS: [
      "click", 
      "dblclick", 
      "blur", 
      "error", 
      "focus", 
      "focusIn", 
      "focusOut", 
      "hover", 
      "keydown", 
      "keypress", 
      "keyup", 
      "load",
      "mousedown", 
      "mouseenter",
      "mouseleave",
      "mousemove",
      "mouseout",
      "mouseover",
      "mouseup", 
      "mousewheel",
      "ready",
      "resize",
      "scroll",
      "select",
      "submit",
      "tap",
      "taphold",
      "swipe",
      "swipeleft",
      "swiperight"
    ]
    
    DOM_EVENT_PATTERN: new RegExp("^(#{@DOM_EVENTS.join("|")})")
    
    dispatcher: global
        
    addEventHandler: (name, handler, options) ->
      if options.type == "socket" || !eventType.match(@DOM_EVENT_PATTERN)
        @addSocketEventHandler(name, handler, options)
      else
        @addDomEventHandler(name, handler, options)
        
    socketNamespace: ->
      Coach.Support.String.pluralize(Coach.Support.String.camelize(@name.replace(/(Controller)$/, ""), false))
      
    addSocketEventHandler: (name, handler, options) ->
      @io ||= Coach.Application.instance().io.connect(@socketNamespace())
      
      @io.on name, (data) =>
        @_dispatch undefined, handler, data 
      
    addDomEventHandler: (name, handler, options) ->
      parts             = name.split(/\ +/)
      name              = parts.shift()
      selector          = parts.join(" ")
      options.target    = selector if selector && selector != ""
      options.target  ||= "body"
      eventType         = name.split(/[\.:]/)[0]
      method            = @["#{eventType}Handler"]
      if method
        method.call @, name, handler, options
      else
        $(@dispatcher).on name, options.target, (event) => @_dispatch handler, options
      @
      
    _dispatch: (handler, options = {}) ->
      controller = @instance()
      
      controller.elements ||= {}
      controller.params   ||= {}
      
      _.extend controller.params, options.params if options.params
      _.extend controller.elements, options.elements if options.elements
      
      if typeof handler == "string"
        controller[handler].call controller, event
      else
        handler.call controller, event
        