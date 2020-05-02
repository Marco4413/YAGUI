local a=settings.get("YAGUI_PATH")if not(type(a)=="string")then printError("YAGUI is not installed, please install it by opening it with argument \"setup\".")return end;if not fs.exists(a)then printError("Couldn't find YAGUI in path: \""..a.."\", Please reinstall it by opening it with argument \"setup\".")return end;local b=dofile(a)local c="new"local d=".txt"local e=1;local f=20;local g=6;local h=true;local i=0.5;local j=0.5;local k=string.char(149)local l=0.5;local m=colors.white;local n=nil;local o=colors.white;local p=colors.black;local q=colors.gray;local r=colors.lightGray;local s=colors.green;local t=colors.red;local u=colors.yellow;local v=colors.blue;local w=colors.orange;local x=colors.green;local y=colors.red;local z=true;local A=true;local B=c..d;local C=shell.resolve(B)local D={"1","2","3","4","5","6","7","8","9","0"}local E={...}b.screen_buffer.buffer.background=q;local F={}local G={}local function H(I,J)for K,L in next,I do G[L]=J end end;H({"and","break","do","else","elseif","end","false","for","function","if","in","local","nil","not","or","repeat","return","then","true","until","while"},u)H({"bit","colors","colours","commands","coroutine","disk","fs","gps","help","http","io","keys","math","multishell","os","paintutils","parallel","peripheral","rednet","redstone","rs","settings","shell","string","table","term","textutils","turtle","pocket","vector","window","YAGUI"},v)H({"info","generic_utils","string_utils","math_utils","table_utils","color_utils","event_utils","setting_utils","monitor_utils","screen_buffer","input","gui_elements","WSS","wireless_screen_share","FT","file_transfer","Loop","self"},w)local M=b.Loop(f,g)local N=b.Loop(f,g)local O=b.Loop(f,g)local P={["main"]=M,["input"]=N,["overwrite"]=O}local Q=b.WSS(e)local R=b.gui_elements.Label(0,0,"Lines: 0",o)local S=b.gui_elements.Label(0,0,"Cursor: (1; 1)",o)local T=b.gui_elements.Button(0,0,0,0,"C",o,s,t)local U=b.gui_elements.Memo(0,0,0,0,o,p)local V=b.gui_elements.Label(0,0,"/path/",o)local W=b.gui_elements.Clock(j)T.timed.enabled=true;T.timed.clock.interval=i;T.shortcut={b.KEY_LEFTCTRL,b.KEY_LEFTSHIFT,b.KEY_C}U.cursor.text=k;U.cursor.blink.interval=l;U.colors.cursor=n;U.colors.cursor_text=m;U.border=true;U.colors.border_color=q;W.oneshot=true;local X=b.gui_elements.Button(0,0,0,0,"File",o,r,q)local Y=b.gui_elements.Window(0,0,0,0,q,z)local Z=b.gui_elements.Button(0,0,0,0,"New/Open",o,r,q)local _=b.gui_elements.Button(0,0,0,0,"Save",o,r,q)local a0=b.gui_elements.Button(0,0,0,0,"SaveAs",o,r,q)local a1=b.gui_elements.Button(0,0,0,0,"Delete",o,r,q)local a2=b.gui_elements.Button(0,0,0,0,"Goto",o,r,q)local a3=b.gui_elements.Button(0,0,0,0,"Run",o,r,q)local a4=b.gui_elements.Button(0,0,0,0,"SyntaxHL",o,r,q)local a5=b.gui_elements.Button(0,0,0,0,"Exit",o,s,t)Y.draw_priority=b.LOW_PRIORITY;Y.hidden=true;Y.dragging.enabled=false;Y.resizing.enabled=false;Y:set_elements({Z,_,a0,a1,a2,a3,a4,a5})Z.timed.enabled=true;Z.timed.clock.interval=i/2;_.timed.enabled=true;_.timed.clock.interval=i;a0.timed.enabled=true;a0.timed.clock.interval=i/2;a1.timed.enabled=true;a1.timed.clock.interval=i;a2.timed.enabled=true;a2.timed.clock.interval=i/2;a3.timed.enabled=true;a3.timed.clock.interval=i;a5.timed.enabled=true;a5.timed.clock.interval=i;X.shortcut={b.KEY_LEFTCTRL,b.KEY_TAB}a4.active=A;local a6=b.gui_elements.Label(0,0,"",o)local a7=b.gui_elements.Memo(0,0,0,0,o,r)local a8=b.gui_elements.Label(0,0,"You can press CONTROL to cancel.",o)a7.limits=b.math_utils.Vector2(0,1)a7.cursor.text=k;a7.cursor.blink.interval=l;a7.colors.cursor=n;a7.colors.cursor_text=m;a7.border=true;a7.colors.border_color=q;local a9=b.gui_elements.Window(0,0,0,0,r,z)local aa=b.gui_elements.Label(0,0,"Do you want\nto overwrite?",o)local ab=b.gui_elements.Button(0,0,0,0,"Yes",o,q,r)local ac=b.gui_elements.Button(0,0,0,0,"No",o,q,r)a9:set_elements({aa,ab,ac})ab.timed.enabled=true;ab.timed.clock.interval=i;ac.timed.enabled=true;ac.timed.clock.interval=i;ab.shortcut={b.KEY_Y}ac.shortcut={b.KEY_N}aa.text_alignment=b.ALIGN_CENTER;local function ad()local ae,af=term.getSize()local ag={["all"]={lLines=function()return 9,1 end,lCursor=function()return ae-5,1,b.ALIGN_RIGHT end,bCompact=function()return ae,1,1,1 end,mEditor=function()return 1,2,ae,af-2 end,lPath=function()return 1,af end,bFile=function()return 1,1,4,1 end,wFileMenu=function()return 1,2,10,8 end,bNewOpen=function()return 1,1,10,1 end,bSave=function()return 1,2,10,1 end,bSaveAs=function()return 1,3,10,1 end,bDelete=function()return 1,4,10,1 end,bGoto=function()return 1,5,10,1 end,bRun=function()return 1,6,10,1 end,bSHL=function()return 1,7,10,1 end,bQuit=function()return 1,8,10,1 end,lInputTitle=function()return 3,math.floor(af/2-1)end,mInput=function()return 1,math.floor(af/2)-1,ae,3 end,lInputTip=function()return 3,math.floor(af/2+2),"You can press CONTROL to cancel."end,wOverWrite=function()return math.floor(ae/2-7),math.floor(af/2-3),15,6 end,lOW=function()return 8,2 end,bOWAccept=function()return 2,5,3,1 end,bOWReject=function()return 13,5,2,1 end,stats=function()return ae-1,af-1 end},[b.COMPUTER]={},[b.TURTLE]={},[b.POCKET]={lCursor=function()return 1,af-1,b.ALIGN_LEFT end,mEditor=function()return 1,2,ae,af-3 end,lPath=function()return 1,af end,lInputTip=function()return 3,math.floor(af/2+2),"You can press\nCONTROL to cancel."end},["this_layout"]={}}local ah,ai=b.generic_utils.get_computer_type()ag.this_layout=ag.all;for K,aj in next,ag[ah]do ag.this_layout[K]=aj end;F=ag.this_layout end;local function ak()R.pos.x,R.pos.y=F.lLines()S.pos.x,S.pos.y,S.text_alignment=F.lCursor()T.pos.x,T.pos.y,T.size.x,T.size.y=F.bCompact()U.pos.x,U.pos.y,U.size.x,U.size.y=F.mEditor()V.pos.x,V.pos.y=F.lPath()X.pos.x,X.pos.y,X.size.x,X.size.y=F.bFile()Y.pos.x,Y.pos.y,Y.size.x,Y.size.y=F.wFileMenu()Z.pos.x,Z.pos.y,Z.size.x,Z.size.y=F.bNewOpen()_.pos.x,_.pos.y,_.size.x,_.size.y=F.bSave()a0.pos.x,a0.pos.y,a0.size.x,a0.size.y=F.bSaveAs()a1.pos.x,a1.pos.y,a1.size.x,a1.size.y=F.bDelete()a2.pos.x,a2.pos.y,a2.size.x,a2.size.y=F.bGoto()a3.pos.x,a3.pos.y,a3.size.x,a3.size.y=F.bRun()a4.pos.x,a4.pos.y,a4.size.x,a4.size.y=F.bSHL()a5.pos.x,a5.pos.y,a5.size.x,a5.size.y=F.bQuit()a6.pos.x,a6.pos.y=F.lInputTitle()a7.pos.x,a7.pos.y,a7.size.x,a7.size.y=F.mInput()a8.pos.x,a8.pos.y,a8.text=F.lInputTip()a9.pos.x,a9.pos.y,a9.size.x,a9.size.y=F.wOverWrite()a9.resizing.min_size=a9.size:duplicate()a9.resizing.max_size=a9.size:duplicate()*2;aa.pos.x,aa.pos.y=F.lOW()ab.pos.x,ab.pos.y,ab.size.x,ab.size.y=F.bOWAccept()ac.pos.x,ac.pos.y,ac.size.x,ac.size.y=F.bOWReject()aa.offset=b.math_utils.Vector2.new(0,b.math_utils.round(a9.size.y/2)-aa.pos.y)for K,al in next,P do al.stats.pos=b.math_utils.Vector2(F.stats())al.stats:update_pos()end end;local function am()for K,an in next,M.monitors do b.monitor_utils.better_clear(an)end end;local function ao()U.rich_text={}if U.focussed then U.rich_text[U.cursor.pos.y]={["background"]=q}end end;local ap={}local function aq(I,ar)for as=ar+1,#I do I[as]=nil end end;local function at(I,au,av)local aw=#I;for as=aw+1,av+aw do I[as]=au end end;local function ax(ar,ay)local az=b.color_utils.colors[o]local aA=b.color_utils.colors[x]local aB=b.color_utils.colors[y]ar=ar or U.first_visible_line;ay=ay or U.first_visible_line+U.size.y-1;local aC="code"local aD="none"local aE=false;local aF=""local aG=ap[ar-1]if aG then aC=aG.state;aD=aG.nested_state;aE=aG.quote_ignore;aF=aG.current_quote end;for aH=ar,ay do if not U.rich_text[aH]then U.rich_text[aH]={}end;local aI=U.lines[aH]if not aI then break end;local aJ={}local aK=b.string_utils.split(aI,"[^%w_]")local aL=0;for K,L in next,aK do local aM=G[L]if aM then at(aJ,b.color_utils.colors[o],aL-#aJ)at(aJ,b.color_utils.colors[aM],#L)end;aL=aL+#L+1 end;aJ[#aJ+1]=az;for aN=1,#aI do if not aJ[aN]then aJ[aN]=az end;local au=aI:sub(aN,aN)if aC=="code"then if au=="\""then aJ[aN]=aB;if aN~=#aI then aC="string"aF="\""end elseif au=="'"then aJ[aN]=aB;if aN~=#aI then aC="string"aF="'"end elseif aI:sub(aN,aN+1)=="[["then aC="long-string"aJ[aN]=aB elseif aI:sub(aN,aN+1)=="--"then if aI:sub(aN,aN+3)=="--[["then aC="closed-comment"aJ[aN]=aA else aC="comment"aJ[aN]=aA end elseif aN>#aJ then aJ[aN]=az end elseif aC=="string"then aJ[aN]=aB;if au=="\\"then if aN==#aI then aD="multi-line"else local aO=aI:sub(aN+1,aN+1)if aO==aF then aE=true end end elseif aD=="none"and aN==#aI then aE=false;aF=""aC="code"elseif au==aF then if aE then aE=false else aF=""aC="code"aD="none"end else aD="none"end elseif aC=="long-string"then aJ[aN]=aB;if aI:sub(aN,aN+1)=="]]"then aJ[aN+1]=aB;aC="code"end elseif aC=="comment"then aq(aJ,aN-1)aC="code"break elseif aC=="closed-comment"then aJ[aN]=aA;if aI:sub(aN,aN+1)=="]]"then aJ[aN+1]=aA;aC="code"end end end;ap[aH]={["state"]=aC,["nested_state"]=aD,["quote_ignore"]=aE,["current_quote"]=aF}U.rich_text[aH].foreground=table.concat(aJ)end end;local function aP(aQ)aQ=shell.resolve(aQ)if#aQ:gsub(" ","")==0 then aQ=B end;if b.string_utils.get_extension(aQ)==""then aQ=aQ..d end;if fs.isDir(aQ)then return end;U:clear()C=aQ;if fs.exists(aQ)then local aR=fs.open(aQ,"r")local aS=pcall(U.write,U,aR.readAll())if not aS then am()Q:close()error("It took too long to open the file")end;aR.close()end;U:set_cursor(1,1)if A then ax(1)end end;local function aT(aQ)aQ=shell.resolve(aQ)if#aQ:gsub(" ","")==0 then aQ=C end;if fs.isDir(aQ)then return end;if fs.isReadOnly(aQ)then return end;C=aQ;local aR=fs.open(aQ,"w")aR.write(table.concat(U.lines,"\n"))aR.close()end;W:set_callback(b.ONCLOCK,function(self)ax(self.starting_line,#U.lines)self.starting_line=nil end)X:set_callback(b.ONPRESS,function(self)Y.hidden=not self.active end)Y:set_callback(b.ONFAILEDPRESS,function(self)if X.active then self.hidden=true;X.active=false end end)Z:set_callback(b.ONTIMEOUT,function(self)a6.text=" New File / Open File "a7.bound=self;N:start()end)Z.callbacks.onActionComplete=function(aQ)if aQ then aQ=shell.resolve(aQ)aP(aQ)else aP(B)end end;_:set_callback(b.ONTIMEOUT,function(self)aT(C)end)a0:set_callback(b.ONTIMEOUT,function(self)a6.text=" Save File As "a7.bound=self;N:start()end)a0.callbacks.onActionComplete=function(aQ)if not aQ then aQ=C end;aQ=shell.resolve(aQ)if fs.exists(aQ)then ab.bound=a0;a0.path=aQ;O:start()else aT(aQ)end end;a0.callbacks.onOverWrite=function()aT(a0.path)a0.path=nil end;a1:set_callback(b.ONTIMEOUT,function(self)if fs.isReadOnly(C)then return end;fs.delete(C)end)a2:set_callback(b.ONTIMEOUT,function(self)a6.text=" Go to Line "a7.bound=self;a7.whitelist=D;N:start()end)a2.callbacks.onActionComplete=function(aI)U:set_cursor(1,tonumber(aI)or U.cursor.pos.y)end;a3:set_callback(b.ONTIMEOUT,function(self)aT(C)local aU=shell.openTab(C)shell.switchTab(aU)end)a4:set_callback(b.ONPRESS,function(self)A=self.active;if A then ax(1)else ao()end end)a5:set_callback(b.ONTIMEOUT,function(self)M:stop()end)T:set_callback(b.ONTIMEOUT,function(self)local aV={}for as=1,#U.lines do local aI=U.lines[as]if not aI then break end;local aW=aI:gsub(" ","")if#aW==0 then table.insert(aV,1,as)end end;for K,aX in next,aV do table.remove(U.lines,aX)end;U:set_cursor(1,1)if A then ax(1)end end)U:set_callback(b.ONFOCUS,function(self)if not self.focussed then local aY=self.rich_text[self.cursor.pos.y]if aY and aY.foreground then aY.background=nil else self.rich_text[self.cursor.pos.y]=nil end end end)U:set_callback(b.ONMOUSESCROLL,function(self)return true end)U:set_callback(b.ONCURSORCHANGE,function(self,aZ,a_)local b0=self.rich_text[self.cursor.pos.y]if b0 and b0["foreground"]then b0["background"]=nil else self.rich_text[self.cursor.pos.y]=nil end;if self.focussed then local b1=self.rich_text[a_]if b1 and b1["foreground"]then b1["background"]=q else self.rich_text[a_]={["background"]=q}end end end)U:set_callback(b.ONWRITE,function(self,b2,b3)if A then if W.starting_line then W.starting_line=math.min(W.starting_line,math.max(1,self.cursor.pos.y-#b3+1))else W.starting_line=math.max(1,self.cursor.pos.y-#b3+1)end;W:start()end end)M:set_callback(b.ONCLOCK,function(self)R.text=string.format("Lines: %d",#U.lines)S.text=table.concat({"Cursor: ",tostring(U.cursor.pos)})V.text=table.concat({"/",C})end)M:set_callback(b.ONEVENT,function(self,b4)if b.input:are_keys_pressed(true,b.KEY_LEFTCTRL,b.KEY_LEFTALT,b.KEY_S)then a0.callbacks.onPress(a0,b4)elseif b.input:are_keys_pressed(true,b.KEY_LEFTCTRL,b.KEY_N)then Z.callbacks.onPress(Z,b4)elseif b.input:are_keys_pressed(true,b.KEY_LEFTCTRL,b.KEY_S)then _.callbacks.onTimeout(_,b4)elseif b.input:are_keys_pressed(true,b.KEY_LEFTCTRL,b.KEY_G)then a2.callbacks.onPress(a2,b4)elseif b.input:are_keys_pressed(true,b.KEY_LEFTALT,b.KEY_R)then a3.callbacks.onTimeout(a3,b4)elseif not U.focussed then if b.input:are_keys_pressed(false,b.KEY_LEFTCTRL,b.KEY_LEFT)then U.first_visible_char=math.max(1,U.first_visible_char-1)elseif b.input:are_keys_pressed(false,b.KEY_LEFTCTRL,b.KEY_RIGHT)then U.first_visible_char=U.first_visible_char+1 end;if b.input:are_keys_pressed(false,b.KEY_LEFTCTRL,b.KEY_UP)then U.first_visible_line=math.max(1,U.first_visible_line-1)elseif b.input:are_keys_pressed(false,b.KEY_LEFTCTRL,b.KEY_DOWN)then U.first_visible_line=math.min(#U.lines,U.first_visible_line+1)end end;if b4.name==b.MOUSESCROLL then U.first_visible_line=b.math_utils.constrain(U.first_visible_line+b4.direction,1,#U.lines)elseif b4.name==b.TERMRESIZE then ad()ak()end;if A and U.first_visible_line+U.size.y-1>#ap then ax(#ap)end end)a7:set_callback(b.ONKEY,function(self,b4)if b4.key==b.KEY_ENTER then self.bound.callbacks.onActionComplete(self.lines[1])N:stop()return true end end)N:set_callback(b.ONSTART,function(self)a7:focus(true)end)N:set_callback(b.ONEVENT,function(self,b4)if b4.name==b.KEY then if b4.key==b.KEY_LEFTCTRL or b4.key==b.KEY_RIGHTCTRL then N:stop()return true end elseif b4.name==b.TERMRESIZE then ad()ak()end end)N:set_callback(b.ONSTOP,function(self)a7.bound=nil;a7.whitelist={}a7:clear()a7:focus(false)end)a9:set_callback(b.ONRESIZE,function(self,b5,b6,b7,b8)aa.pos=b.math_utils.Vector2(self.size.x/2,self.size.y/2)-aa.offset;ab.pos.y=self.size.y-1;ac.pos.x=self.size.x-2;ac.pos.y=self.size.y-1 end)ab:set_callback(b.ONTIMEOUT,function(self)self.bound.callbacks.onOverWrite()self.bound=nil;O:stop()end)ac:set_callback(b.ONTIMEOUT,function(self)O:stop()end)O:set_callback(b.ONEVENT,function(self,b4)if b4.name==b.TERMRESIZE then ad()ak()end end)ad()ak()if#E>0 then if E[1]:lower()=="help"then local b3={{text="Note <COMMAND>",foreground=colors.green,background=nil},{text=" - help (shows this list of commands)",foreground=colors.blue,background=nil},{text=" - open <PATH> (opens file at PATH)",foreground=colors.yellow,background=nil},{text=" - multi <MONITORS> (sets MONITORS\n   as io for the app)",foreground=colors.green,background=nil},{text=" - wss <MODEM_SIDE> [BROADCAST_INTERVAL]\n   (hosts a WSS server using the modem\n   on MODEM_SIDE and updates connected users\n   every BROADCAST_INTERVAL seconds)",foreground=colors.blue,background=nil}}for K,aI in next,b3 do b.monitor_utils.better_print(term,aI.foreground,aI.background,aI.text)end;return end;local b9={open={},multi={},wss={}}local ba;for K,bb in next,E do if ba then table.insert(b9[ba],bb)end;local bc=bb:lower()if bc~=ba and b9[bc]then ba=bc end end;if#b9.open>0 then C=b9.open[1]end;if#b9.multi>0 then table.insert(b9.multi,1,"terminal")for K,al in next,P do al:set_monitors(b9.multi)end end;if#b9.wss>0 then if b9.wss[1]then local bd=b9.wss[1]if peripheral.getType(bd)~="modem"then b.monitor_utils.better_print(term,colors.red,nil,"Modem: ",bd," wasn't found.")return end;Q:use_side(bd)Q:host()Q.broadcast_clock.interval=tonumber(b9.wss[2])or Q.broadcast_clock.interval end end end;aP(C)M:set_elements({X,Y,R,S,T,U,V,W,Q})N:set_elements({a6,a7,a8,Q})O:set_elements({a9,Q})for K,al in next,P do al.stats.elements.FPS_label.text_alignment=b.ALIGN_RIGHT;al.stats.elements.EPS_label.text_alignment=b.ALIGN_RIGHT;al.stats:show(h)al.options.raw_mode=true;al.options.stop_on_terminate=false end;M.options.stop_on_terminate=true;M:start()am()Q:close()