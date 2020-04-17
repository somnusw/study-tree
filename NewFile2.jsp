<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">

    <title>Somnus 魏博硕</title>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <script src="WeContent/bootstrap/jquery-3.4.1.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
 <style>

    .node {
        cursor: pointer;
    }
   .node circle {
      fill: #357CAE;
      stroke: steelblue;
      stroke-width: 1.0px;
    }
    .node rect {
      fill: #2990ca;
      stroke: steelblue;
      stroke-width: 1.0px;
    }

    .node text {
      font: 12px Helvetica;
      font-size: 78%;
    }

    .link {
      fill: none;
      stroke: #ccc;
      stroke-width: 2px;
    }
  .fill_normal {
    fill: green;
  }
  .bling{ animation: alarm 0.4s  ease-in  infinite ; fill:yellow; font-weight: bold;}
  @keyframes alarm {
      0%{ fill:#FF9966;}
      50%{ fill:#FF3333;}
      100%{ fill:#FF9966;}
  }

    </style>

  </head>

  <body>
  <!-- load the d3.js library -->
    <script src="http://d3js.org/d3.v3.min.js"></script>
	    <script>
        //json接口
        var treeData = [{
            "name": "",
            "parent": "",
            "children": [{
                "name": "",
                "parent": "",
                "children": [{
                    "name": "",
                    "parent": ""
                }, {
                    "name": "",
                    "parent": "",
                    "children": [{
                        "name": "",
                        parent: ""
                    }]
                }, {
                    "name": "",
                    "parent": ""
                }, {
                    "name": "",
                    "parent": ""
                }]
            }, {
                "name": "",
                "parent": "",
                "children": [{
                    "name": "",
                    "parent": ""
                }, {
                    "name": "",
                    "parent": ""
                }, ]

            }, {
                "name": "",
                "parent": ""
            }, ]
        }];



        // ************** Generate the tree diagram  *****************
       
        /*------------------初始化函数开始--------------------*/
        function treeInit(tree_num) { //画第tree_num棵树
            //定义树图的全局属性（宽高）
            var margin = {
                    top: 20,
                    right: 120,
                    bottom: 20,
                    left: 120
                },
                width = 960 - margin.right - margin.left,
                height = 1000 - margin.top - margin.bottom;

            var i = 0,
                duration = 750, //过渡延迟时间
                root;

            var tree = d3.layout.tree() //创建一个树布局
                .size([height, width]);

            var diagonal = d3.svg.diagonal()
                .projection(function(d) {
                    return [d.y, d.x];
                }); //创建新的斜线生成器

            //声明与定义画布属性
            var svg = d3.select("body").append("svg")
                .attr("width", width + margin.right + margin.left)
                .attr("height", height + margin.top + margin.bottom)
                .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

            root = treeData[tree_num]; //treeData为上边定义的第tree_num棵树节点属性
            root.x0 = height / 2;
            root.y0 = 0;

            update(root);

            d3.select(self.frameElement).style("height", "500px");

            function update(source) {
                // Compute the new tree layout.计算新树图的布局
                var nodes = tree.nodes(root).reverse(),
                    links = tree.links(nodes);

                // Normalize for fixed-depth.设置y坐标点，每层占180px
                nodes.forEach(function(d) {
                    d.y = d.depth * 180;
                });

                // Update the nodes…每个node对应一个group
                var node = svg.selectAll("g.node")
                    .data(nodes, function(d) {
                        return d.id || (d.id = ++i);
                    }); //data()：绑定一个数组到选择集上，数组的各项值分别与选择集的各元素绑定

                // Enter any new nodes at the parent's previous position.新增节点数据集，设置位置
                var nodeEnter = node.enter().append("g") //在 svg 中添加一个g，g是 svg 中的一个属性，是 group 的意思，它表示一组什么东西，如一组 lines ， rects ，circles 其实坐标轴就是由这些东西构成的。
                    .attr("class", "node") //attr设置html属性，style设置css属性
                    .attr("transform", function(d) {
                        return "translate(" + source.y0 + "," + source.x0 + ")";
                    })
                    .on("click", click);

                //添加连接点---此处设置的是圆圈过渡时候的效果（颜色）
                // nodeEnter.append("circle")
                //   .attr("r", 1e-6)
                //   .style("fill", function(d) { return d._children ? "lightsteelblue" : "#357CAE"; });//d 代表数据，也就是与某元素绑定的数据。
                nodeEnter.append("rect")
                    .attr("x", -23)
                    .attr("y", -10)
                    .attr("width", 75)
                    .attr("height", 30)
                    .attr("rx", 10)
                    .style("fill", "#C0FFC6"); //d 代表数据，也就是与某元素绑定的数据。

                //添加标签
                nodeEnter.append("text")
                    .attr("x", function(d) {
                        return d.children || d._children ? 13 : 13;
                    })
                    .attr("dy", "10")
                    .attr("text-anchor", "middle")
                    .text(function(d) {
                        return d.name;
                    })
                    .style("fill", "#92129E")
                    .style("fill-opacity", 1);

              

               
                // Transition nodes to their new position.将节点过渡到一个新的位置-----主要是针对节点过渡过程中的过渡效果
                //node就是保留的数据集，为原来数据的图形添加过渡动画。首先是整个组的位置
                var nodeUpdate = node.transition() //开始一个动画过渡
                    .duration(duration) //过渡延迟时间,此处主要设置的是圆圈节点随斜线的过渡延迟
                    .attr("transform", function(d) {
                        return "translate(" + d.y + "," + d.x + ")";
                    });

                nodeUpdate.select("circle")
                    .attr("x", -23)
                    .attr("y", -10)
                    .attr("width", 70)
                    .attr("height", 22)
                    .attr("rx", 10)
                    .style("fill", "#357CAE");

                nodeUpdate.select("text")
                    .attr("text-anchor", "middle")
                    .style("fill-opacity", 1);

                // Transition exiting nodes to the parent's new position.过渡现有的节点到父母的新位置。
                //最后处理消失的数据，添加消失动画
                var nodeExit = node.exit().transition()
                    .duration(duration)
                    .attr("transform", function(d) {
                        return "translate(" + source.y + "," + source.x + ")";
                    })
                    .remove();

                // nodeExit.select("circle")
                //   .attr("r", 1e-6);
                nodeExit.select("circle")
                    .attr("x", -23)
                    .attr("y", -10)
                    .attr("width", 70)
                    .attr("height", 22)
                    .attr("rx", 10)
                    .style("fill", "#357CAE");

                nodeExit.select("text")
                    .attr("text-anchor", "middle")
                    .style("fill-opacity", 1e-6);

                // Update the links…线操作相关
                //再处理连线集合
                var link = svg.selectAll("path.link")
                    .data(links, function(d) {
                        return d.target.id;
                    });



                // Enter any new links at the parent's previous position.
                //添加新的连线
                link.enter().insert("path", "g")
                    .attr("class", "link")
                    .attr("d", function(d) {
                        var o = {
                            x: source.x0,
                            y: source.y0
                        };
                        return diagonal({
                            source: o,
                            target: o
                        }); //diagonal - 生成一个二维贝塞尔连接器, 用于节点连接图.
                    })
                    .attr('marker-end', 'url(#arrow)');

                // Transition links to their new position.将斜线过渡到新的位置
                //保留的连线添加过渡动画
                link.transition()
                    .duration(duration)
                    .attr("d", diagonal);

                // Transition exiting nodes to the parent's new position.过渡现有的斜线到父母的新位置。
                //消失的连线添加过渡动画
                link.exit().transition()
                    .duration(duration)
                    .attr("d", function(d) {
                        var o = {
                            x: source.x,
                            y: source.y
                        };
                        return diagonal({
                            source: o,
                            target: o
                        });
                    })
                    .remove();

                // Stash the old positions for transition.将旧的斜线过渡效果隐藏
                nodes.forEach(function(d) {
                    d.x0 = d.x;
                    d.y0 = d.y;
                });
            }
            //折叠函数
            function click(d) {
                if (d.children) {
                    d._children = d.children;
                    d.children = null;
                } else {
                    d.children = d._children;
                    d._children = null;
                }
                update(d);
            }

        }

     
	    
        /*-----------------------初始化函数结束*------------------------*/

        
	     //自定义json长度查找函数 也就是找到除了导师那一行一共有几行的总长，就拿例子中的说除了导师张三那一行还剩四行所以为4 
	     function getJsonDataLength(jsonData) {
	         var jsonDataLength = 0;
	         for (var item in jsonData) {
	    //alert("Son is " + item);
	             jsonDataLength++;
	         }
	       
	         return jsonDataLength;
	     }
	
	     /*
	     检查函数，遍历之前所有树的所有子节点，查找是否有导师的学生也是导师的情况
	     
	     */
	     //@nodes 源json树
	     //@find_name 要找的导师名
	     //@may_need 可能需要添加的json树 
	     function check_son_tree(nodes, find_name, may_need) {
	         var no = 0;
	        //document.write(fanhui1);
	         var yes = 1;
	         var length_now = getJsonDataLength(nodes.children);
	         //System.out.println("chang = " + length_now)
	         for (var first = 0; first < length_now; first++) {
	       //alert(nodes.children[ll].name);导师的学生的名字
	             if (nodes.children[first].name == find_name) {//如果导师的学生也为导师
	               
	
	                
	             	
	                 nodes.children[first] = may_need;//这是该导师的学生为导师的那棵树的根节点
	                 //alert("add success");
	                 return yes;
	
	             } else {
	            	 check_son_tree(nodes.children[first], find_name, may_need);
	                 //return;
	             }
	         }
	
	         return no;
	     }
	
	
	
	     //追逐函数
	     /*
	     分割传输过来的数据并构造json树结构
	     */
	       function build() {
			alert("欢迎使用(●'◡'●)");
			    var count = 0; //定义儿子节点的编号
		        var flag = 0; //定义标志是否为关联树值为1
	            var text_data = document.getElementById("user").value;
	            var sclice_data = [];
	            var treecount = [];
	            //有几棵树
	            treecount = text_data.split("\n\n");
	             
	            //document.write(treecount);
	            //document.write(model.lenth);
	            
	            //生成树型结构数据
	            for (var j = 0; j < treecount.length; ++j) {
	                count = 0;
	                flag = 0;
	                count_shu = 0;
	                sclice_data = treecount[j].split("\n");
	                //document.write(sclice_data.length);
	                for (var i = 0; i < sclice_data.length; ++i) {
	                	 var before_tmp = "";
	                     var back_tmp = "";
	                     var colon = sclice_data[i].split("："); //从冒号分割一层字符串
	                     before_tmp = colon[0];//冒号前的内容
	              //document.write(head_tmp);
	                     back_tmp = colon[1];//冒号后的内容
	              //document.write(body_tmp);
	              //alert(head_tmp == "导师");
	              //alert(i);
	                     
	                     //处理冒号前的部分
	                     if (before_tmp == "导师")
	                     {
	                    	 
	                         var daoshi2 =
	                         {	 
	                             "name": back_tmp,
	                             "parent": "null",
	                             "children": [{}]
	                         }
	                    
	                         //alert(daoshi2.name)//弹出导师名
	                         treeData[j] = daoshi2; //将导师嵌入节点
	                         //alert(treeData[j]);
	                       
	                        
	                     }else {
	                    	 var children = 
	                    	 {
	                                 "name": before_tmp,
	                                 "parent": "null",
	                                 "children": [{}]
	                         }
	                    	 treeData[j].children[count] = children; //将导师的学生的年级及职业嵌入节点
	                         //处理冒号后的部分
	                         var bodies = back_tmp.split("、");
	                         for (var k = 0; k < bodies.length; ++k) {
	                        	 var children = {
	                                     "name": bodies[k],
	                                     "parent": "null"
	                                 }
	                                 //treeData.push(children);
	                             treeData[j].children[count].children[k] = children; //将导师的学生的姓名嵌入节点
	                         }
	                         count++; //第二子节点编号加一，生成下一个第二子节点
	                     }  	                     
	                }
	                //和前面所有的树比较，判断是否为关联树
	                var tree_temp = treeData[j];
	                var name_temp = treeData[j].name;
	                for (num_temp = 0; num_temp < j; num_temp++) {
	                    
	                    //alert("flag = " + flag);
	                	flag = check_son_tree(treeData[num_temp], name_temp, tree_temp);
	                }
	                if (!flag) count_shu++;
	            
	            }
	            for (var i = 0; i <= count_shu; i++) {
	            	
	                treeInit(i)
	            }
	         
                
		}
	</script>
		<div>   
		    <span>
		    	<textarea id="user" rows="10" cols="80"></textarea> 
		    	<button type="button" class="btn btn-info" onClick="build()">提交</button>
		    	<img src="G:/timg.gif" width="40%" height="300px" class="img-circle" />
		    	
		    </span>
   			
		    
   		</div>
</body>
</html>