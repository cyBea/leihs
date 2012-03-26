(function(k){var o=String.prototype.trim,l=function(a,b){for(var c=[];b>0;c[--b]=a);return c.join("")},d=function(a){return function(){for(var b=Array.prototype.slice.call(arguments),c=0;c<b.length;c++)b[c]=b[c]==null?"":""+b[c];return a.apply(null,b)}},m=function(){function a(a){return Object.prototype.toString.call(a).slice(8,-1).toLowerCase()}var b=function(){b.cache.hasOwnProperty(arguments[0])||(b.cache[arguments[0]]=b.parse(arguments[0]));return b.format.call(null,b.cache[arguments[0]],arguments)};
b.format=function(b,n){var e=1,d=b.length,f="",j=[],h,i,g,k;for(h=0;h<d;h++)if(f=a(b[h]),f==="string")j.push(b[h]);else if(f==="array"){g=b[h];if(g[2]){f=n[e];for(i=0;i<g[2].length;i++){if(!f.hasOwnProperty(g[2][i]))throw m('[_.sprintf] property "%s" does not exist',g[2][i]);f=f[g[2][i]]}}else f=g[1]?n[g[1]]:n[e++];if(/[^s]/.test(g[8])&&a(f)!="number")throw m("[_.sprintf] expecting number but found %s",a(f));switch(g[8]){case "b":f=f.toString(2);break;case "c":f=String.fromCharCode(f);break;case "d":f=
parseInt(f,10);break;case "e":f=g[7]?f.toExponential(g[7]):f.toExponential();break;case "f":f=g[7]?parseFloat(f).toFixed(g[7]):parseFloat(f);break;case "o":f=f.toString(8);break;case "s":f=(f=String(f))&&g[7]?f.substring(0,g[7]):f;break;case "u":f=Math.abs(f);break;case "x":f=f.toString(16);break;case "X":f=f.toString(16).toUpperCase()}f=/[def]/.test(g[8])&&g[3]&&f>=0?"+"+f:f;i=g[4]?g[4]=="0"?"0":g[4].charAt(1):" ";k=g[6]-String(f).length;i=g[6]?l(i,k):"";j.push(g[5]?f+i:i+f)}return j.join("")};b.cache=
{};b.parse=function(a){for(var b=[],e=[],d=0;a;){if((b=/^[^\x25]+/.exec(a))!==null)e.push(b[0]);else if((b=/^\x25{2}/.exec(a))!==null)e.push("%");else if((b=/^\x25(?:([1-9]\d*)\$|\(([^\)]+)\))?(\+)?(0|'[^$])?(-)?(\d+)?(?:\.(\d+))?([b-fosuxX])/.exec(a))!==null){if(b[2]){d|=1;var f=[],j=b[2],h=[];if((h=/^([a-z_][a-z_\d]*)/i.exec(j))!==null)for(f.push(h[1]);(j=j.substring(h[0].length))!=="";)if((h=/^\.([a-z_][a-z_\d]*)/i.exec(j))!==null)f.push(h[1]);else if((h=/^\[(\d+)\]/.exec(j))!==null)f.push(h[1]);
else throw"[_.sprintf] huh?";else throw"[_.sprintf] huh?";b[2]=f}else d|=2;if(d===3)throw"[_.sprintf] mixing positional and named placeholders is not (yet) supported";e.push(b)}else throw"[_.sprintf] huh?";a=a.substring(b[0].length)}return e};return b}(),e={VERSION:"1.2.0",isBlank:d(function(a){return/^\s*$/.test(a)}),stripTags:d(function(a){return a.replace(/<\/?[^>]+>/ig,"")}),capitalize:d(function(a){return a.charAt(0).toUpperCase()+a.substring(1).toLowerCase()}),chop:d(function(a,b){for(var b=
b*1||0||a.length,c=[],e=0;e<a.length;)c.push(a.slice(e,e+b)),e+=b;return c}),clean:d(function(a){return e.strip(a.replace(/\s+/g," "))}),count:d(function(a,b){for(var c=0,e,d=0;d<a.length;)e=a.indexOf(b,d),e>=0&&c++,d=d+(e>=0?e:0)+b.length;return c}),chars:d(function(a){return a.split("")}),escapeHTML:d(function(a){return a.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;").replace(/'/g,"&apos;")}),unescapeHTML:d(function(a){return a.replace(/&lt;/g,"<").replace(/&gt;/g,
">").replace(/&quot;/g,'"').replace(/&apos;/g,"'").replace(/&amp;/g,"&")}),escapeRegExp:d(function(a){return a.replace(/([-.*+?^${}()|[\]\/\\])/g,"\\$1")}),insert:d(function(a,b,c){a=a.split("");a.splice(b*1||0,0,c);return a.join("")}),include:d(function(a,b){return a.indexOf(b)!==-1}),join:d(function(a){var b=Array.prototype.slice.call(arguments);return b.join(b.shift())}),lines:d(function(a){return a.split("\n")}),reverse:d(function(a){return Array.prototype.reverse.apply(String(a).split("")).join("")}),
splice:d(function(a,b,c,e){a=a.split("");a.splice(b*1||0,c*1||0,e);return a.join("")}),startsWith:d(function(a,b){return a.length>=b.length&&a.substring(0,b.length)===b}),endsWith:d(function(a,b){return a.length>=b.length&&a.substring(a.length-b.length)===b}),succ:d(function(a){var b=a.split("");b.splice(a.length-1,1,String.fromCharCode(a.charCodeAt(a.length-1)+1));return b.join("")}),titleize:d(function(a){for(var a=a.split(" "),b,c=0;c<a.length;c++)b=a[c].split(""),typeof b[0]!=="undefined"&&(b[0]=
b[0].toUpperCase()),c+1===a.length?a[c]=b.join(""):a[c]=b.join("")+" ";return a.join("")}),camelize:d(function(a){return e.trim(a).replace(/(\-|_|\s)+(.)?/g,function(a,c,e){return e?e.toUpperCase():""})}),underscored:function(a){return e.trim(a).replace(/([a-z\d])([A-Z]+)/g,"$1_$2").replace(/\-|\s+/g,"_").toLowerCase()},dasherize:function(a){return e.trim(a).replace(/([a-z\d])([A-Z]+)/g,"$1-$2").replace(/^([A-Z]+)/,"-$1").replace(/\_|\s+/g,"-").toLowerCase()},humanize:function(a){return e.capitalize(this.underscored(a).replace(/_id$/,
"").replace(/_/g," "))},trim:d(function(a,b){if(!b&&o)return o.call(a);b=b?e.escapeRegExp(b):"\\s";return a.replace(RegExp("^["+b+"]+|["+b+"]+$","g"),"")}),ltrim:d(function(a,b){b=b?e.escapeRegExp(b):"\\s";return a.replace(RegExp("^["+b+"]+","g"),"")}),rtrim:d(function(a,b){b=b?e.escapeRegExp(b):"\\s";return a.replace(RegExp("["+b+"]+$","g"),"")}),truncate:d(function(a,b,c){b=b*1||0;return a.length>b?a.slice(0,b)+(c||"..."):a}),prune:d(function(a,b,c){var c=c||"...",b=b*1||0,d="",d=a.substring(b-
1,b+1).search(/^\w\w$/)===0?e.rtrim(a.slice(0,b).replace(/([\W][\w]*)$/,"")):e.rtrim(a.slice(0,b)),d=d.replace(/\W+$/,"");return d.length+c.length>a.length?a:d+c}),words:function(a,b){return String(a).split(b||" ")},pad:d(function(a,b,c,e){var d="",d=0,b=b*1||0;c?c.length>1&&(c=c.charAt(0)):c=" ";switch(e){case "right":d=b-a.length;d=l(c,d);a+=d;break;case "both":d=b-a.length;d={left:l(c,Math.ceil(d/2)),right:l(c,Math.floor(d/2))};a=d.left+a+d.right;break;default:d=b-a.length,d=l(c,d),a=d+a}return a}),
lpad:function(a,b,c){return e.pad(a,b,c)},rpad:function(a,b,c){return e.pad(a,b,c,"right")},lrpad:function(a,b,c){return e.pad(a,b,c,"both")},sprintf:m,vsprintf:function(a,b){b.unshift(a);return m.apply(null,b)},toNumber:function(a,b){var c;c=(a*1||0).toFixed(b*1||0)*1||0;return!(c===0&&a!=="0"&&a!==0)?c:Number.NaN},strRight:d(function(a,b){var c=!b?-1:a.indexOf(b);return c!=-1?a.slice(c+b.length,a.length):a}),strRightBack:d(function(a,b){var c=!b?-1:a.lastIndexOf(b);return c!=-1?a.slice(c+b.length,
a.length):a}),strLeft:d(function(a,b){var c=!b?-1:a.indexOf(b);return c!=-1?a.slice(0,c):a}),strLeftBack:d(function(a,b){var c=a.lastIndexOf(b);return c!=-1?a.slice(0,c):a}),exports:function(){var a={},b;for(b in this)if(this.hasOwnProperty(b)&&!(b=="include"||b=="contains"||b=="reverse"))a[b]=this[b];return a}};e.strip=e.trim;e.lstrip=e.ltrim;e.rstrip=e.rtrim;e.center=e.lrpad;e.ljust=e.lpad;e.rjust=e.rpad;e.contains=e.include;if(typeof exports!=="undefined"){if(typeof module!=="undefined"&&module.exports)module.exports=
e;exports._s=e}else typeof k._!=="undefined"?(k._.string=e,k._.str=k._.string):k._={string:e,str:e}})(this||window);