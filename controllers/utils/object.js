(function() {
  /* Generic extensible Game Object */  var EventEmitter, Obj;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  EventEmitter = (require('events')).EventEmitter;
  exports.Obj = Obj = (function() {
    __extends(Obj, EventEmitter);
    function Obj() {
      Obj.__super__.constructor.apply(this, arguments);
    }
    return Obj;
  })();
}).call(this);
