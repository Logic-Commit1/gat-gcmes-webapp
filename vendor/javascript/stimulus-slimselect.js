import{Controller as t}from"@hotwired/stimulus";import e from"slim-select";function o(){return(o=Object.assign||function(t){for(var e=1;e<arguments.length;e++){var r=arguments[e];for(var n in r)Object.prototype.hasOwnProperty.call(r,n)&&(t[n]=r[n])}return t}).apply(this,arguments)}var r=function(t){var r,n;function i(){return t.apply(this,arguments)||this}n=t,(r=i).prototype=Object.create(n.prototype),r.prototype.constructor=r,r.__proto__=n;var s=i.prototype;return s.connect=function(){this.slimselect=new e(o({select:this.element},this.optionsValue))},s.disconnect=function(){this.slimselect.destroy()},i}(t);r.values={options:Object};export{r as default};
