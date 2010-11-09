var gadgets={};;
var gadgets=gadgets||{};
gadgets.config=function(){var A={};
return{register:function(D,C,B){if(A[D]){throw new Error('Component "'+D+'" is already registered.')
}A[D]={validators:C||{},callback:B}
},get:function(B){if(B){if(!A[B]){throw new Error('Component "'+B+'" not registered.')
}return configuration[B]||{}
}return configuration
},init:function(H,G){configuration=H;
for(var F in A){if(A.hasOwnProperty(F)){var E=A[F],D=H[F],B=E.validators;
if(!G){for(var C in B){if(B.hasOwnProperty(C)){if(!B[C](D[C])){throw new Error('Invalid config value "'+D[C]+'" for parameter "'+C+'" in component "'+F+'"')
}}}}if(E.callback){E.callback(H)
}}}},EnumValidator:function(E){var D=[];
if(arguments.length>1){for(var C=0,B;
B=arguments[C];
++C){D.push(B)
}}else{D=E
}return function(G){for(var F=0,H;
H=D[F];
++F){if(G===D[F]){return true
}}}
},RegExValidator:function(B){return function(C){return B.test(C)
}
},ExistsValidator:function(B){return typeof B!=="undefined"
},NonEmptyStringValidator:function(B){return typeof B==="string"&&B.length>0
},BooleanValidator:function(B){return typeof B==="boolean"
},LikeValidator:function(B){return function(D){for(var E in B){if(B.hasOwnProperty(E)){var C=B[E];
if(!C(D[E])){return false
}}}return true
}
}}
}();;
null;
var gadgets=gadgets||{};
gadgets.util=function(){function F(){var K;
var J=document.location.href;
var H=J.indexOf("?");
var I=J.indexOf("#");
if(I===-1){K=J.substr(H+1)
}else{K=[J.substr(H+1,I-H-1),"&",J.substr(I+1)].join("")
}return K.split("&")
}var D=null;
var C={};
var E=[];
var A={0:false,10:true,13:true,34:true,39:true,60:true,62:true,92:true,8232:true,8233:true};
function B(H,I){return String.fromCharCode(I)
}function G(H){C=H["core.util"]||{}
}if(gadgets.config){gadgets.config.register("core.util",null,G)
}return{getUrlParameters:function(){if(D!==null){return D
}D={};
var K=F();
var N=window.decodeURIComponent?decodeURIComponent:unescape;
for(var I=0,H=K.length;
I<H;
++I){var M=K[I].indexOf("=");
if(M===-1){continue
}var L=K[I].substring(0,M);
var J=K[I].substring(M+1);
J=J.replace(/\+/g," ");
D[L]=N(J)
}return D
},makeClosure:function(K,M,L){var J=[];
for(var I=2,H=arguments.length;
I<H;
++I){J.push(arguments[I])
}return function(){var N=J.slice();
for(var P=0,O=arguments.length;
P<O;
++P){N.push(arguments[P])
}return M.apply(K,N)
}
},makeEnum:function(I){var K={};
for(var J=0,H;
H=I[J];
++J){K[H]=H
}return K
},getFeatureParameters:function(H){return typeof C[H]==="undefined"?null:C[H]
},hasFeature:function(H){return typeof C[H]!=="undefined"
},registerOnLoadHandler:function(H){E.push(H)
},runOnLoadHandlers:function(){for(var I=0,H=E.length;
I<H;
++I){E[I]()
}},escape:function(H,L){if(!H){return H
}else{if(typeof H==="string"){return gadgets.util.escapeString(H)
}else{if(typeof H==="array"){for(var K=0,I=H.length;
K<I;
++K){H[K]=gadgets.util.escape(H[K])
}}else{if(typeof H==="object"&&L){var J={};
for(var M in H){if(H.hasOwnProperty(M)){J[gadgets.util.escapeString(M)]=gadgets.util.escape(H[M],true)
}}return J
}}}}return H
},escapeString:function(L){var I=[],K,M;
for(var J=0,H=L.length;
J<H;
++J){K=L.charCodeAt(J);
M=A[K];
if(M===true){I.push("&#",K,";")
}else{if(M!==false){I.push(L.charAt(J))
}}}return I.join("")
},unescapeString:function(H){return H.replace(/&#([0-9]+);/g,B)
}}
}();
gadgets.util.getUrlParameters();;
var shindig=shindig||{};
shindig.Auth=function(){var authToken=null;
var trusted=null;
function init(configuration){var urlParams=gadgets.util.getUrlParameters();
var config=configuration["shindig.auth"]||{};
if(config.authToken){authToken=config.authToken
}else{if(urlParams.st){authToken=urlParams.st
}}if(authToken!=null){addParamsToToken(urlParams)
}if(config.trustedJson){trusted=eval("("+config.trustedJson+")")
}}function addParamsToToken(urlParams){var args=authToken.split("&");
for(var i=0;
i<args.length;
i++){var nameAndValue=args[i].split("=");
if(nameAndValue.length==2){var name=nameAndValue[0];
var value=nameAndValue[1];
if(value==="$"){value=encodeURIComponent(urlParams[name]);
args[i]=name+"="+value
}}}authToken=args.join("&")
}gadgets.config.register("shindig.auth",null,init);
return{getSecurityToken:function(){return authToken
},updateSecurityToken:function(newToken){authToken=newToken
},getTrustedData:function(){return trusted
}}
};;
var shindig=shindig||{};
shindig.auth=new shindig.Auth();;
var gadgets=gadgets||{};
(function(){var H=null;
var I={};
var D={};
var G={};
var E="en";
var B="US";
var A=0;
function C(){var K=gadgets.util.getUrlParameters();
for(var J in K){if(K.hasOwnProperty(J)){if(J.indexOf("up_")===0&&J.length>3){I[J.substr(3)]=String(K[J])
}else{if(J==="country"){B=K[J]
}else{if(J==="lang"){E=K[J]
}else{if(J==="mid"){A=K[J]
}}}}}}}function F(){for(var J in G){if(typeof I[J]==="undefined"){I[J]=G[J]
}}}gadgets.Prefs=function(){if(!H){C();
F();
H=this
}return H
};
gadgets.Prefs.setInternal_=function(K,L){if(typeof K==="string"){I[K]=L
}else{for(var J in K){if(K.hasOwnProperty(J)){I[J]=K[J]
}}}};
gadgets.Prefs.setMessages_=function(J){D=J
};
gadgets.Prefs.setDefaultPrefs_=function(J){G=J
};
gadgets.Prefs.prototype.getString=function(J){return I[J]?gadgets.util.escapeString(I[J]):""
};
gadgets.Prefs.prototype.getInt=function(J){var K=parseInt(I[J],10);
return isNaN(K)?0:K
};
gadgets.Prefs.prototype.getFloat=function(J){var K=parseFloat(I[J]);
return isNaN(K)?0:K
};
gadgets.Prefs.prototype.getBool=function(J){var K=I[J];
if(K){return K==="true"||K===true||!!parseInt(K,10)
}return false
};
gadgets.Prefs.prototype.set=function(J,K){throw new Error("setprefs feature required to make this call.")
};
gadgets.Prefs.prototype.getArray=function(N){var O=I[N];
if(O){var J=O.split("|");
var K=gadgets.util.escapeString;
for(var M=0,L=J.length;
M<L;
++M){J[M]=K(J[M].replace(/%7C/g,"|"))
}return J
}return[]
};
gadgets.Prefs.prototype.setArray=function(J,K){throw new Error("setprefs feature required to make this call.")
};
gadgets.Prefs.prototype.getMsg=function(J){return D[J]||""
};
gadgets.Prefs.prototype.getCountry=function(){return B
};
gadgets.Prefs.prototype.getLang=function(){return E
};
gadgets.Prefs.prototype.getModuleId=function(){return A
}
})();;
var gadgets=gadgets||{};
gadgets.json=function(){function f(n){return n<10?"0"+n:n
}Date.prototype.toJSON=function(){return[this.getUTCFullYear(),"-",f(this.getUTCMonth()+1),"-",f(this.getUTCDate()),"T",f(this.getUTCHours()),":",f(this.getUTCMinutes()),":",f(this.getUTCSeconds()),"Z"].join("")
};
var m={"\b":"\\b","\t":"\\t","\n":"\\n","\f":"\\f","\r":"\\r",'"':'\\"',"\\":"\\\\"};
function stringify(value){var a,i,k,l,r=/["\\\x00-\x1f\x7f-\x9f]/g,v;
switch(typeof value){case"string":return r.test(value)?'"'+value.replace(r,function(a){var c=m[a];
if(c){return c
}c=a.charCodeAt();
return"\\u00"+Math.floor(c/16).toString(16)+(c%16).toString(16)
})+'"':'"'+value+'"';
case"number":return isFinite(value)?String(value):"null";
case"boolean":case"null":return String(value);
case"object":if(!value){return"null"
}a=[];
if(typeof value.length==="number"&&!(value.propertyIsEnumerable("length"))){l=value.length;
for(i=0;
i<l;
i+=1){a.push(stringify(value[i])||"null")
}return"["+a.join(",")+"]"
}for(k in value){if(value.hasOwnProperty(k)){if(typeof k==="string"){v=stringify(value[k]);
if(v){a.push(stringify(k)+":"+v)
}}}}return"{"+a.join(",")+"}"
}}return{stringify:stringify,parse:function(text){if(/^[\],:{}\s]*$/.test(text.replace(/\\["\\\/b-u]/g,"@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,"]").replace(/(?:^|:|,)(?:\s*\[)+/g,""))){return eval("("+text+")")
}return false
}}
}();;
var JSON=gadgets.json;
var _IG_Prefs=gadgets.Prefs;
_IG_Prefs._parseURL=gadgets.Prefs.parseUrl;
function _IG_Fetch_wrapper(B,A){B(A.data)
}function _IG_FetchContent(B,E,C){var D=C||{};
if(D.refreshInterval){D.REFRESH_INTERVAL=D.refreshInterval
}else{D.REFRESH_INTERVAL=3600
}var A=gadgets.util.makeClosure(null,_IG_Fetch_wrapper,E);
gadgets.io.makeRequest(B,A,D)
}function _IG_FetchXmlContent(B,E,C){var D=C||{};
if(D.refreshInterval){D.REFRESH_INTERVAL=D.refreshInterval
}else{D.REFRESH_INTERVAL=3600
}D.CONTENT_TYPE="DOM";
var A=gadgets.util.makeClosure(null,_IG_Fetch_wrapper,E);
gadgets.io.makeRequest(B,A,D)
}function _IG_FetchFeedAsJSON(B,F,C,A,D){var E=D||{};
E.CONTENT_TYPE="FEED";
E.NUM_ENTRIES=C;
E.GET_SUMMARIES=A;
gadgets.io.makeRequest(B,function(I){I.data=I.data||{};
if(I.errors&&I.errors.length>0){I.data.ErrorMsg=I.errors[0]
}if(I.data.link){I.data.URL=B
}if(I.data.title){I.data.Title=I.data.title
}if(I.data.description){I.data.Description=I.data.description
}if(I.data.link){I.data.Link=I.data.link
}if(I.data.items&&I.data.items.length>0){I.data.Entry=I.data.items;
for(var G=0;
G<I.data.Entry.length;
++G){var H=I.data.Entry[G];
H.Title=H.title;
H.Link=H.link;
H.Summary=H.summary||H.description;
H.Date=H.pubDate
}}F(I.data)
},E)
}function _IG_GetCachedUrl(A,B){var C={REFRESH_INTERVAL:3600};
if(B&&B.refreshInterval){C.REFRESH_INTERVAL=B.refreshInterval
}return gadgets.io.getProxyUrl(A,C)
}function _IG_GetImageUrl(A,B){return _IG_GetCachedUrl(A,B)
}function _IG_GetImage(B){var A=document.createElement("img");
A.src=_IG_GetCachedUrl(B);
return A
}function _IG_RegisterOnloadHandler(A){gadgets.util.registerOnLoadHandler(A)
}function _IG_Callback(B,C){var A=arguments;
return function(){var D=Array.prototype.slice.call(arguments);
B.apply(null,D.concat(Array.prototype.slice.call(A,1)))
}
}var _args=gadgets.util.getUrlParameters;
function _gel(A){return document.getElementById?document.getElementById(A):null
}function _gelstn(A){if(A==="*"&&document.all){return document.all
}return document.getElementsByTagName?document.getElementsByTagName(A):[]
}function _gelsbyregex(D,F){var C=_gelstn(D);
var E=[];
for(var B=0,A=C.length;
B<A;
++B){if(F.test(C[B].id)){E.push(C[B])
}}return E
}function _esc(A){return window.encodeURIComponent?encodeURIComponent(A):escape(A)
}function _unesc(A){return window.decodeURIComponent?decodeURIComponent(A):unescape(A)
}function _hesc(A){return gadgets.util.escapeString(A)
}function _striptags(A){return A.replace(/<\/?[^>]+>/g,"")
}function _trim(A){return A.replace(/^\s+|\s+$/g,"")
}function _toggle(A){A=_gel(A);
if(A!==null){if(A.style.display.length===0||A.style.display==="block"){A.style.display="none"
}else{if(A.style.display==="none"){A.style.display="block"
}}}}var _global_legacy_uidCounter=0;
function _uid(){return _global_legacy_uidCounter++
}function _min(B,A){return(B<A?B:A)
}function _max(B,A){return(B>A?B:A)
}function _exportSymbols(A,B){var H={};
for(var I=0,F=B.length;
I<F;
I+=2){H[B[I]]=B[I+1]
}var E=A.split(".");
var J=window;
for(var D=0,C=E.length-1;
D<C;
++D){var G={};
J[E[D]]=G;
J=G
}J[E[E.length-1]]=H
};;
var gadgets=gadgets||{};
gadgets.io=function(){var config={};
var oauthState;
function makeXhr(){if(window.XMLHttpRequest){return new window.XMLHttpRequest()
}else{if(window.ActiveXObject){var x=new ActiveXObject("Msxml2.XMLHTTP");
if(!x){x=new ActiveXObject("Microsoft.XMLHTTP")
}return x
}}}function hadError(xobj,callback){if(xobj.readyState!==4){return true
}try{if(xobj.status!==200){callback({errors:["Error "+xobj.status]});
return true
}}catch(e){callback({errors:["Error not specified"]});
return true
}return false
}function processNonProxiedResponse(url,callback,params,xobj){if(hadError(xobj,callback)){return 
}var data={body:xobj.responseText};
callback(transformResponseData(params,data))
}var UNPARSEABLE_CRUFT="throw 1; < don't be evil' >";
function processResponse(url,callback,params,xobj){if(hadError(xobj,callback)){return 
}var txt=xobj.responseText;
txt=txt.substr(UNPARSEABLE_CRUFT.length);
var data=eval("("+txt+")");
data=data[url];
if(data.oauthState){oauthState=data.oauthState
}if(data.st){shindig.auth.updateSecurityToken(data.st)
}callback(transformResponseData(params,data))
}function transformResponseData(params,data){var resp={text:data.body,rc:data.rc,headers:data.headers,oauthApprovalUrl:data.oauthApprovalUrl,oauthError:data.oauthError,oauthErrorText:data.oauthErrorText,errors:[]};
if(resp.text){switch(params.CONTENT_TYPE){case"JSON":case"FEED":resp.data=gadgets.json.parse(resp.text);
if(!resp.data){resp.errors.push("failed to parse JSON");
resp.data=null
}break;
case"DOM":var dom;
if(window.ActiveXObject){dom=new ActiveXObject("Microsoft.XMLDOM");
dom.async=false;
dom.validateOnParse=false;
dom.resolveExternals=false;
if(!dom.loadXML(resp.text)){resp.errors.push("failed to parse XML")
}else{resp.data=dom
}}else{var parser=new DOMParser();
dom=parser.parseFromString(resp.text,"text/xml");
if("parsererror"===dom.documentElement.nodeName){resp.errors.push("failed to parse XML")
}else{resp.data=dom
}}break;
default:resp.data=resp.text;
break
}}return resp
}function makeXhrRequest(realUrl,proxyUrl,callback,paramData,method,params,processResponseFunction,opt_contentType){var xhr=makeXhr();
xhr.open(method,proxyUrl,true);
if(callback){xhr.onreadystatechange=gadgets.util.makeClosure(null,processResponseFunction,realUrl,callback,params,xhr)
}if(paramData!=null){xhr.setRequestHeader("Content-Type",opt_contentType||"application/x-www-form-urlencoded");
xhr.send(paramData)
}else{xhr.send(null)
}}function respondWithPreload(postData,params,callback){if(gadgets.io.preloaded_&&gadgets.io.preloaded_[postData.url]){var preload=gadgets.io.preloaded_[postData.url];
if(postData.httpMethod=="GET"){delete gadgets.io.preloaded_[postData.url];
if(preload.rc!==200){callback({errors:["Error "+preload.rc]})
}else{if(preload.oauthState){oauthState=preload.oauthState
}var resp={body:preload.body,rc:preload.rc,headers:preload.headers,oauthApprovalUrl:preload.oauthApprovalUrl,oauthError:preload.oauthError,oauthErrorText:preload.oauthErrorText,errors:[]};
callback(transformResponseData(params,resp))
}return true
}}return false
}function init(configuration){config=configuration["core.io"]
}var requiredConfig={proxyUrl:new gadgets.config.RegExValidator(/.*%(raw)?url%.*/),jsonProxyUrl:gadgets.config.NonEmptyStringValidator};
gadgets.config.register("core.io",requiredConfig,init);
return{makeRequest:function(url,callback,opt_params){var params=opt_params||{};
var httpMethod=params.METHOD||"GET";
var refreshInterval=params.REFRESH_INTERVAL;
var auth,st;
if(params.AUTHORIZATION&&params.AUTHORIZATION!=="NONE"){auth=params.AUTHORIZATION.toLowerCase();
st=shindig.auth.getSecurityToken()
}else{if(httpMethod==="GET"&&refreshInterval===undefined){refreshInterval=3600
}}var signOwner=true;
if(typeof params.OWNER_SIGNED!=="undefined"){signOwner=params.OWNER_SIGNED
}var signViewer=true;
if(typeof params.VIEWER_SIGNED!=="undefined"){signViewer=params.VIEWER_SIGNED
}var headers=params.HEADERS||{};
if(httpMethod==="POST"&&!headers["Content-Type"]){headers["Content-Type"]="application/x-www-form-urlencoded"
}var urlParams=gadgets.util.getUrlParameters();
var paramData={url:url,httpMethod:httpMethod,headers:gadgets.io.encodeValues(headers,false),postData:params.POST_DATA||"",authz:auth||"",st:st||"",contentType:params.CONTENT_TYPE||"TEXT",numEntries:params.NUM_ENTRIES||"3",getSummaries:!!params.GET_SUMMARIES,signOwner:signOwner,signViewer:signViewer,gadget:urlParams.url,container:urlParams.container||urlParams.synd||"default",bypassSpecCache:gadgets.util.getUrlParameters().nocache||""};
if(auth==="oauth"||auth==="signed"){if(gadgets.oauth&&gadgets.oauth.Popup&&gadgets.oauth.Popup.getReceivedCallbackUrl){var callbackResponse=gadgets.oauth.Popup.getReceivedCallbackUrl();
if(callbackResponse){paramData.OAUTH_RECEIVED_CALLBACK=callbackResponse;
gadgets.oauth.Popup.setReceivedCallbackUrl(null)
}}paramData.oauthState=oauthState||"";
for(opt in params){if(params.hasOwnProperty(opt)){if(opt.indexOf("OAUTH_")===0){paramData[opt]=params[opt]
}}}}var proxyUrl=config.jsonProxyUrl.replace("%host%",document.location.host);
if(!respondWithPreload(paramData,params,callback,processResponse)){if(httpMethod==="GET"&&refreshInterval>0){var extraparams="?refresh="+refreshInterval+"&"+gadgets.io.encodeValues(paramData);
makeXhrRequest(url,proxyUrl+extraparams,callback,null,"GET",params,processResponse)
}else{makeXhrRequest(url,proxyUrl,callback,gadgets.io.encodeValues(paramData),"POST",params,processResponse)
}}},makeNonProxiedRequest:function(relativeUrl,callback,opt_params,opt_contentType){var params=opt_params||{};
makeXhrRequest(relativeUrl,relativeUrl,callback,params.POST_DATA,params.METHOD,params,processNonProxiedResponse,opt_contentType)
},clearOAuthState:function(){oauthState=undefined
},encodeValues:function(fields,opt_noEscaping){var escape=!opt_noEscaping;
var buf=[];
var first=false;
for(var i in fields){if(fields.hasOwnProperty(i)){if(!first){first=true
}else{buf.push("&")
}buf.push(escape?encodeURIComponent(i):i);
buf.push("=");
buf.push(escape?encodeURIComponent(fields[i]):fields[i])
}}return buf.join("")
},getProxyUrl:function(url,opt_params){var params=opt_params||{};
var refresh=params.REFRESH_INTERVAL;
if(refresh===undefined){refresh="3600"
}var urlParams=gadgets.util.getUrlParameters();
return config.proxyUrl.replace("%url%",encodeURIComponent(url)).replace("%host%",document.location.host).replace("%rawurl%",url).replace("%refresh%",encodeURIComponent(refresh)).replace("%gadget%",encodeURIComponent(urlParams.url)).replace("%container%",encodeURIComponent(urlParams.container||urlParams.synd))
}}
}();
gadgets.io.RequestParameters=gadgets.util.makeEnum(["METHOD","CONTENT_TYPE","POST_DATA","HEADERS","AUTHORIZATION","NUM_ENTRIES","GET_SUMMARIES","REFRESH_INTERVAL","OAUTH_SERVICE_NAME","OAUTH_USE_TOKEN","OAUTH_TOKEN_NAME","OAUTH_REQUEST_TOKEN","OAUTH_REQUEST_TOKEN_SECRET","OAUTH_RECEIVED_CALLBACK"]);
gadgets.io.MethodType=gadgets.util.makeEnum(["GET","POST","PUT","DELETE","HEAD"]);
gadgets.io.ContentType=gadgets.util.makeEnum(["TEXT","DOM","JSON","FEED"]);
gadgets.io.AuthorizationType=gadgets.util.makeEnum(["NONE","SIGNED","OAUTH"]);;
var gadgets=gadgets||{};
gadgets.rpc=function(){var R="__cb";
var P="";
var d="__g2c_rpc";
var F="__c2g_rpc";
var H="GRPC____NIXVBS_wrapper";
var B="GRPC____NIXVBS_get_wrapper";
var Y="GRPC____NIXVBS_handle_message";
var O="GRPC____NIXVBS_create_channel";
var J={};
var C={};
var W=[];
var D={};
var U={};
var K={};
var M=0;
var e={};
var T={};
var E={};
var c={};
if(gadgets.util){c=gadgets.util.getUrlParameters()
}K[".."]=c.rpctoken||c.ifpctok||0;
function Z(){return typeof window.postMessage==="function"?"wpm":typeof document.postMessage==="function"?"dpm":window.ActiveXObject?"nix":navigator.product==="Gecko"?"fe":"ifpc"
}function b(){if(I==="dpm"||I==="wpm"){window.addEventListener("message",function(i){S(gadgets.json.parse(i.data))
},false)
}if(I==="nix"){if(typeof window[B]!=="unknown"){window[Y]=function(i){S(gadgets.json.parse(i))
};
window[O]=function(i,k,j){if(K[i]==j){J[i]=k
}};
var g="Class "+H+"\n Private m_Intended\nPrivate m_Auth\nPublic Sub SetIntendedName(name)\n If isEmpty(m_Intended) Then\nm_Intended = name\nEnd If\nEnd Sub\nPublic Sub SetAuth(auth)\n If isEmpty(m_Auth) Then\nm_Auth = auth\nEnd If\nEnd Sub\nPublic Sub SendMessage(data)\n "+Y+"(data)\nEnd Sub\nPublic Function GetAuthToken()\n GetAuthToken = m_Auth\nEnd Function\nPublic Sub CreateChannel(channel, auth)\n Call "+O+"(m_Intended, channel, auth)\nEnd Sub\nEnd Class\nFunction "+B+"(name, auth)\nDim wrap\nSet wrap = New "+H+"\nwrap.SetIntendedName name\nwrap.SetAuth auth\nSet "+B+" = wrap\nEnd Function";
try{window.execScript(g,"vbscript")
}catch(h){I="ifpc"
}}}}var I=Z();
b();
C[P]=function(){throw new Error("Unknown RPC service: "+this.s)
};
C[R]=function(h,g){var i=e[h];
if(i){delete e[h];
i(g)
}};
function N(h,g){if(T[h]){return 
}if(I==="fe"){try{var j=document.getElementById(h);
j[d]=function(l){S(gadgets.json.parse(l))
}
}catch(i){}}if(I==="nix"){try{var j=document.getElementById(h);
var k=window[B](h,g);
j.contentWindow.opener=k
}catch(i){}}T[h]=true
}function V(k){var m=gadgets.json.stringify;
var g=[];
for(var l=0,h=k.length;
l<h;
++l){g.push(encodeURIComponent(m(k[l])))
}return g.join("&")
}function S(h){if(h&&typeof h.s==="string"&&typeof h.f==="string"&&h.a instanceof Array){if(K[h.f]){if(K[h.f]!=h.t){throw new Error("Invalid auth token.")
}}if(h.c){h.callback=function(i){gadgets.rpc.call(h.f,R,null,h.c,i)
}
}var g=(C[h.s]||C[P]).apply(h,h.a);
if(h.c&&typeof g!="undefined"){gadgets.rpc.call(h.f,R,null,h.c,g)
}}}function f(g,j,m,k){try{if(m!=".."){var i=J[".."];
if(!i&&window.opener&&"GetAuthToken" in window.opener){i=window.opener;
if(i.GetAuthToken()==K[".."]){var h=K[".."];
i.CreateChannel(window[B]("..",h),h);
J[".."]=i;
window.opener=null
}}if(i){i.SendMessage(k);
return 
}}else{if(J[g]){J[g].SendMessage(k);
return 
}}}catch(l){}a(g,j,m,k)
}function A(h,i,n,j,l){try{if(n!=".."){var g=window.frameElement;
if(typeof g[d]==="function"){if(typeof g[d][F]!=="function"){g[d][F]=function(o){S(gadgets.json.parse(o))
}
}g[d](j);
return 
}}else{var m=document.getElementById(h);
if(typeof m[d]==="function"&&typeof m[d][F]==="function"){m[d][F](j);
return 
}}}catch(k){}a(h,i,n,j,l)
}function a(g,h,m,i,j){var l=gadgets.rpc.getRelayUrl(g);
if(!l){throw new Error("No relay file assigned for IFPC")
}var k=null;
if(U[g]){k=[l,"#",V([m,M,1,0,V([m,h,"","",m].concat(j))])].join("")
}else{k=[l,"#",g,"&",m,"@",M,"&1&0&",encodeURIComponent(i)].join("")
}L(k)
}function L(k){var h;
for(var g=W.length-1;
g>=0;
--g){var l=W[g];
try{if(l&&(l.recyclable||l.readyState==="complete")){l.parentNode.removeChild(l);
if(window.ActiveXObject){W[g]=l=null;
W.splice(g,1)
}else{l.recyclable=false;
h=l;
break
}}}catch(j){}}if(!h){h=document.createElement("iframe");
h.style.border=h.style.width=h.style.height="0px";
h.style.visibility="hidden";
h.style.position="absolute";
h.onload=function(){this.recyclable=true
};
W.push(h)
}h.src=k;
setTimeout(function(){document.body.appendChild(h)
},0)
}function G(h,j){if(typeof E[h]==="undefined"){E[h]=false;
var i=null;
if(h===".."){i=parent
}else{i=frames[h]
}try{E[h]=i.gadgets.rpc.receiveSameDomain
}catch(g){}}if(typeof E[h]==="function"){E[h](j);
return true
}return false
}if(gadgets.config){function X(g){if(g.rpc.parentRelayUrl.substring(0,7)==="http://"){D[".."]=g.rpc.parentRelayUrl
}else{var l=document.location.search.substring(0).split("&");
var k="";
for(var h=0,j;
j=l[h];
++h){if(j.indexOf("parent=")===0){k=decodeURIComponent(j.substring(7));
break
}}D[".."]=k+g.rpc.parentRelayUrl
}U[".."]=!!g.rpc.useLegacyProtocol
}var Q={parentRelayUrl:gadgets.config.NonEmptyStringValidator};
gadgets.config.register("rpc",Q,X)
}return{register:function(h,g){if(h==R){throw new Error("Cannot overwrite callback service")
}if(h==P){throw new Error("Cannot overwrite default service: use registerDefault")
}C[h]=g
},unregister:function(g){if(g==R){throw new Error("Cannot delete callback service")
}if(g==P){throw new Error("Cannot delete default service: use unregisterDefault")
}delete C[g]
},registerDefault:function(g){C[""]=g
},unregisterDefault:function(){delete C[""]
},call:function(n,j,o,m){++M;
n=n||"..";
if(o){e[M]=o
}var l="..";
if(n===".."){l=window.name
}var i={s:j,f:l,c:o?M:0,a:Array.prototype.slice.call(arguments,3),t:K[n]};
if(G(n,i)){return 
}var g=gadgets.json.stringify(i);
var h=I;
if(U[n]){h="ifpc"
}switch(h){case"dpm":var p=n===".."?parent.document:frames[n].document;
p.postMessage(g);
break;
case"wpm":var k=n===".."?parent:frames[n];
k.postMessage(g,D[n]);
break;
case"nix":f(n,j,l,g);
break;
case"fe":A(n,j,l,g,i.a);
break;
default:a(n,j,l,g,i.a);
break
}},getRelayUrl:function(g){return D[g]
},setRelayUrl:function(h,g,i){D[h]=g;
U[h]=!!i
},setAuthToken:function(g,h){K[g]=h;
N(g,h)
},getRelayChannel:function(){return I
},receive:function(g){if(g.length>4){S(gadgets.json.parse(decodeURIComponent(g[g.length-1])))
}},receiveSameDomain:function(g){g.a=Array.prototype.slice.call(g.a);
window.setTimeout(function(){S(g)
},0)
}}
}();;
gadgets.rpc.register("update_security_token",function(A){shindig.auth.updateSecurityToken(A)
});;
