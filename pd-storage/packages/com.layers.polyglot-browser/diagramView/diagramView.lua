local view = {
    Library = "com.layers.polyglot-visualnode.lib",
    Template = "diagramView",
}


views[view["Library"] .. "." .. view["Template"] .. ".onShow"] = function (status, result, active)

    local dm = getDatamodel( )
    local tNodeDmView = dm["editor.diagram.view"]
    local sInstanceDmView = result.instance
    local hComp = gui.getComponent( sInstanceDmView )
    local view =  gui.getComponentFromInstance( hComp,  "diagramView.content" )
    local lActive = false

    --if(active)then lActive = active end

    if(status)
    then
        local tNode = CLP_Node:getNode(  result.data["item-id-node"] , result.data["item-file-path"] )
        local dialog = tNode["dialog"]
        if(dialog)
        then

            gui.setNavigatorHTML ( view, ""
            .. '<html>'
            .. '<head>'
            .. '<style>'

            .. '* { margin:0; padding:0; }'
            .. 'canvas { display:block; }'

            .. 'html, body {width:100%; height:100%;}'

            .. 'div {'
            .. '}'

            .. 'div.node {'
            .. 'text-transform: uppercase;'
            .. 'text-align: left;'
            .. '}'

            .. '</style>'
            .. '</head>'
            .. '<body>'
            .. '<canvas id="myCanvas">'
            .. 'Your browser does not support the HTML5 canvas tag.</canvas>'

            .. '<script>'

            .. '(function() {'
                .. "var canvas = document.getElementById('myCanvas'),"
                .. "ctx = canvas.getContext('2d');"
                .. 'var mouseIsDown = false;'
                .. 'var resizeTimer;'
                --.. "window.addEventListener('resize', resizeCanvas, false);"
                .. 'function resizeCanvas() {'
                        .. 'canvas.width = window.innerWidth;'
                        .. 'canvas.height = window.innerHeight;'
                        .. 'draw();'
                .. '}'
                .. 'window.onresize = function() {clearScreen();clearTimeout(resizeTimer);resizeTimer = setTimeout(function() {resizeCanvas();}, 100);};'
                .. 'resizeCanvas();'
                .. "function clearScreen() {var ctx = canvas.getContext('2d');ctx.fillStyle = '#383838';ctx.fillRect(0,0,canvas.width,canvas.height);};"
                .. 'function draw() {'
                    .. 'var gridOptions = {'
                        .. "minorLines: {separation: 20,color: '#303030'},"
                        .. "majorLines: {separation: 200,color: '#252525'}"
                    .. '};'
                    .. "var ctx = canvas.getContext('2d');"

                    .. "ctx.save();"
                    .. "ctx.setTransform(1,0,0,1,0,0);"

                    --.. "ctx.fillStyle = '#555555';"
                    --.. "ctx.fillStyle = '#434343';"
                    .. "ctx.fillStyle = '#383838';"
                    --.. 'ctx.strokeWidth = 1;'
                    .. 'ctx.lineWidth = 1;'
                    .. "ctx.fillRect(0,0,canvas.width,canvas.height);"
                    .. "ctx.shadowBlur = 0;"
                    .. 'if(!mouseIsDown){drawGridLines(canvas, gridOptions.minorLines);drawGridLines(canvas, gridOptions.majorLines);}'
                    --.. 'drawGridLines(canvas, gridOptions.minorLines);drawGridLines(canvas, gridOptions.majorLines);'

                    .. "ctx.restore();"

                    .. 'drawNode(canvas, 70, 250 );'
                    .. 'drawNode(canvas, 320, 120 );'
                    .. 'drawNode(canvas, 320, 250 );'
                    .. 'drawNode(canvas, 320, 370 );'
                    .. 'drawCurve(canvas, 193, 285, 15, 80, 318, 153);'
                    .. 'drawCurve(canvas, 193, 285, -20, 80, 318, 403);'
                    .. 'drawLine(canvas, 193, 285, 320, 285 );'

                .. '}'

                .. 'function drawLine( cnv, x1, y1, x2, y2) {'
                        .. "var ctx = cnv.getContext('2d');"
                        .. 'ctx.beginPath();'
                        .. 'ctx.moveTo( x1, y1 );'
                        .. 'ctx.lineTo( x2, y2 );'
                        .. 'ctx.lineWidth = 1.5;'
                        .. "ctx.lineCap = 'round';"
                        .. "ctx.strokeStyle = 'yellow';"
                        .. 'ctx.stroke();'
                .. '}'

                .. 'function drawCurve( cnv, x1, y1, ox1, oy1, x2, y2) {'
                        .. "var ctx = cnv.getContext('2d');"
                        .. 'ctx.beginPath();'
                        .. 'ctx.moveTo(x1, y1);'
                        --.. 'ctx.quadraticCurveTo(x1 + 90, y1 + 110, 320, 150);'
                        .. 'ctx.bezierCurveTo(x1 + 90, y1 - ox1, 320 -oy1, y2, x2, y2);'
                        .. 'ctx.lineWidth = 1.5;'
                        .. "ctx.lineCap = 'round';"
                        .. "ctx.strokeStyle = 'yellow';"
                        .. 'ctx.stroke();'
                .. '}'

                .. 'function drawNode( cnv, x1, y1 ) {'
                    .. "var ctx = cnv.getContext('2d');"

                    .. 'var x = x1;'
                    .. 'var y = y1;'
                    .. 'var w = 120;'
                    .. 'var h = 70;'
                    .. 'var r = 15;'

                    .. "ctx.beginPath();"
                    .. "ctx.fillStyle = '#555555';"
                    .. "ctx.shadowBlur = 10;"
                    .. "ctx.shadowColor = '#050505';" --#28d1fa
                    .. "ctx.moveTo(x+r, y);"
                    .. "ctx.lineTo(x+w-r, y);"
                    .. "ctx.quadraticCurveTo(x+w, y, x+w, y+r);"
                    .. "ctx.lineTo(x+w, y+h-r);"
                    .. "ctx.quadraticCurveTo(x+w, y+h, x+w-r, y+h);"
                    .. "ctx.lineTo(x+r, y+h);"
                    .. "ctx.quadraticCurveTo(x, y+h, x, y+h-r);"
                    .. "ctx.lineTo(x, y+r);"
                    .. "ctx.quadraticCurveTo(x, y, x+r, y);"
                    .. "ctx.fill();"

                    .. 'h = 40;'
                    .. "ctx.beginPath();"
                    .. "ctx.fillStyle = '#454545';"
                    .. "ctx.shadowBlur = 10;"
                    .. "ctx.shadowColor = '#28d1fa';" --#28d1fa
                    .. "ctx.moveTo(x, y+h-r);"
                    .. "ctx.quadraticCurveTo(x, y, x+r, y);"
                    .. "ctx.lineTo(x+w-r, y);"
                    .. "ctx.quadraticCurveTo(x+w, y, x+w, y+r);"
                    .. "ctx.lineTo(x+w, y+h-r);"
                    .. "ctx.fill();"

                    .. "ctx.shadowBlur = 0;"
                    .. "ctx.shadowColor = '#000000';" --#28d1fa
                    .. "ctx.strokeStyle = '#FFFFFF';"
                    .. 'ctx.lineWidth = 1;'
                    .. "ctx.fillStyle = '#FFF';"
                    .. "ctx.color = '#000000';"
                    .. 'ctx.font = "12px Courier New";'
                    .. 'ctx.fillText("' .. dialog.ACTOR_TAG .. '",x+ 10,y + 18);'

                    .. 'ctx.font = "9px Courier New";'
                    ..    "ctx.fillStyle = '#FFF';"
                    .. 'ctx.fillText("' .. string.getSubString ( dialog.TEXT, 1, 21)  .. '",x+ 8,y + 43);'
                    .. 'ctx.fillText("' .. string.getSubString ( dialog.TEXT, 21, 21)  .. '",x+ 8,y + 53);'

                    .. 'ctx.beginPath();'
                    .. "ctx.shadowBlur = 10;"
                    .. "ctx.shadowColor = '#050505';" --#28d1fa
                    .. 'ctx.arc(x + w,y + 35,4,1.5 * Math.PI, 0.5* Math.PI,false);'
                    .. "ctx.fillStyle = 'yellow';"
                    .. "ctx.fill();"
                    .. 'ctx.closePath();'

                    .. 'ctx.beginPath();'
                    .. "ctx.shadowBlur = 10;"
                    .. "ctx.shadowColor = '#050505';" --#28d1fa
                    .. 'ctx.arc(x ,y + 35,4,1.5 * Math.PI, 0.5* Math.PI,true);'
                    .. "ctx.fillStyle = 'yellow';"
                    .. "ctx.fill();"
                    .. 'ctx.closePath();'

                .. '}'

                .. 'function drawGridLines(cnv, lineOptions) {'
                    .. 'var iWidth = cnv.width;'
                    .. 'var iHeight = cnv.height;'
                    .. "var ctx = cnv.getContext('2d');"
                    .. 'ctx.beginPath();'
                    .. 'ctx.strokeStyle = lineOptions.color;'
                    .. 'ctx.strokeWidth = 1;'
                    .. 'ctx.lineWidth = 1;'
                    .. 'var iCount = null;'
                    .. 'var i = null;'
                    .. 'var x = null;'
                    .. 'var y = null;'
                    .. 'iCount = Math.floor(iWidth / lineOptions.separation);'
                    .. 'for (i = 1; i <= iCount; i++) {'
                    .. '    x = (i * lineOptions.separation);'
                    .. '    ctx.moveTo(x, 0);'
                    .. '    ctx.lineTo(x, iHeight);'
                    .. '    ctx.stroke();'
                    .. '}'
                    .. 'iCount = Math.floor(iHeight / lineOptions.separation);'
                    .. 'for (i = 1; i <= iCount; i++) {'
                    .. '    y = (i * lineOptions.separation);'
                    .. '    ctx.moveTo(0, y);'
                    .. '    ctx.lineTo(iWidth, y);'
                    .. '    ctx.stroke();'
                    .. '}'
                    .. 'ctx.closePath();'
                    .. 'return;'
                .. '}'

            .. 'var startCoords = {x: 0, y: 0};'
            .. 'var last = {x: 0, y: 0};'

            .. 'canvas.onmousedown = function(e){'
                .. 'startCoords.x = e.x - last.x;startCoords.y = e.y - last.y;mouseIsDown = true;'
            .. '};'

            .. 'canvas.onmouseup = function(e){'
                .. 'if(mouseIsDown) mouseClick(e);mouseIsDown = false;last.x = e.x - startCoords.x;last.y = e.y - startCoords.y;'
                .. 'draw();'
            .. '};'

            .. 'canvas.onmousemove = function(e){'
                .. 'if(!mouseIsDown) return;'
                .. "ctx = canvas.getContext('2d');"
                .. 'ctx.setTransform(1, 0, 0, 1, e.x - startCoords.x, e.y - startCoords.y);'
                ..'draw();'
                .. 'return false;'
            .. '};'

            .. 'function mouseClick(e){'
                    --.."alert('hoi');"

            .. '}'

            .. '})();'
            .. '</script>'

            .. '</body>'
            .. '</html>'
            )
        end
    else
        gui.setNavigatorHTML ( view, "")
    end

end