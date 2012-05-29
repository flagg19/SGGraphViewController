Ext.setup({onReady:function(){

var store=new Ext.data.JsonStore({fields:["x_0","y_0","desc_0"],data:[{"x_0":"2012-05-29 14:29:23 +0000","y_0":26,"desc_0":"test1_0"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":23,"desc_0":"test1_1"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":22,"desc_0":"test1_2"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":11,"desc_0":"test1_3"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":10,"desc_0":"test1_4"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":4,"desc_0":"test1_5"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":15,"desc_0":"test1_6"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":28,"desc_0":"test1_7"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":16,"desc_0":"test1_8"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":10,"desc_0":"test1_9"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":8,"desc_0":"test1_10"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":17,"desc_0":"test1_11"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":9,"desc_0":"test1_12"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":26,"desc_0":"test1_13"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":10,"desc_0":"test1_14"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":3,"desc_0":"test1_15"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":10,"desc_0":"test1_16"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":3,"desc_0":"test1_17"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":14,"desc_0":"test1_18"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":24,"desc_0":"test1_19"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":25,"desc_0":"test1_20"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":1,"desc_0":"test1_21"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":21,"desc_0":"test1_22"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":10,"desc_0":"test1_23"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":3,"desc_0":"test1_24"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":22,"desc_0":"test1_25"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":6,"desc_0":"test1_26"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":8,"desc_0":"test1_27"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":5,"desc_0":"test1_28"},{"x_0":"2012-05-29 14:29:23 +0000","y_0":18,"desc_0":"test1_29"}]});var my_chart=new Ext.chart.Chart({renderTo:Ext.getBody(),width:800.000000,height:300.000000,store:store,axes:[{type:"Numeric",position:"left",fields:["y_0"],title:"test",grid:1},{type:"Category",position:"bottom",fields:["x_0"],title:"test",grid:1}],interactions:[{type:'iteminfo',listeners: {show: function(interaction, item, panel) {panel.update(['<ul><li><b>x: </b>' + item.storeItem.get('desc_0') + '</li>', '<li><b>y: </b> ' + item.value[1]+ '</li></ul>'].join(''));}}}],series:[{type:"line",axis:"left",xField:"x_0",yField:"y_0"}]});
	
	var my_container = new Ext.Panel({
		renderTo:Ext.getBody(),
		fullscreen: true,
    	items: [my_chart],
    	centered: true,
    	scroll: 'horizontal',
    	layout: {
    		type: 'hbox',
    		align: 'center',
    		pack: 'center'
    	},
    });
    
    
}});
