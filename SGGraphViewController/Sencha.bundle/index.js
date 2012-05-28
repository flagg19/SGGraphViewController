Ext.setup({onReady:function(){

	var store=new Ext.data.JsonStore({fields:["x_1","y_1","x_0","y_0"],data:[{"x_1":0,"y_1":1,"x_0":0,"y_0":0},{"x_1":1,"y_1":2,"x_0":1,"y_0":1},{"x_1":2,"y_1":3,"x_0":2,"y_0":2},{"x_1":3,"y_1":4,"x_0":3,"y_0":3},{"x_1":4,"y_1":5,"x_0":4,"y_0":4},{"x_1":5,"y_1":6,"x_0":5,"y_0":5},{"x_1":6,"y_1":7,"x_0":6,"y_0":6},{"x_1":7,"y_1":8,"x_0":7,"y_0":7},{"x_1":8,"y_1":9,"x_0":8,"y_0":8},{"x_1":9,"y_1":10,"x_0":9,"y_0":9},{"x_1":10,"y_1":11,"x_0":10,"y_0":10},{"x_1":11,"y_1":12,"x_0":11,"y_0":11},{"x_1":12,"y_1":13,"x_0":12,"y_0":12},{"x_1":13,"y_1":14,"x_0":13,"y_0":13},{"x_1":14,"y_1":15,"x_0":14,"y_0":14},{"x_1":15,"y_1":16,"x_0":15,"y_0":15},{"x_1":16,"y_1":17,"x_0":16,"y_0":16},{"x_1":17,"y_1":18,"x_0":17,"y_0":17},{"x_1":18,"y_1":19,"x_0":18,"y_0":18},{"x_1":19,"y_1":20,"x_0":19,"y_0":19},{"x_1":20,"y_1":21,"x_0":20,"y_0":20},{"x_1":21,"y_1":22,"x_0":21,"y_0":21},{"x_1":22,"y_1":23,"x_0":22,"y_0":22},{"x_1":23,"y_1":24,"x_0":23,"y_0":23},{"x_1":24,"y_1":25,"x_0":24,"y_0":24},{"x_1":25,"y_1":26,"x_0":25,"y_0":25},{"x_1":26,"y_1":27,"x_0":26,"y_0":26},{"x_1":27,"y_1":28,"x_0":27,"y_0":27},{"x_1":28,"y_1":29,"x_0":28,"y_0":28},{"x_1":29,"y_1":30,"x_0":29,"y_0":29},{"x_1":30,"y_1":31,"x_0":30,"y_0":30},{"x_1":31,"y_1":32,"x_0":31,"y_0":31},{"x_1":32,"y_1":33,"x_0":32,"y_0":32},{"x_1":33,"y_1":34,"x_0":33,"y_0":33},{"x_1":34,"y_1":35,"x_0":34,"y_0":34},{"x_1":35,"y_1":36,"x_0":35,"y_0":35},{"x_1":36,"y_1":37,"x_0":36,"y_0":36}]});
	
	var height = 600;
	var width = 320;
	
	
	var my_chart = new Ext.chart.Chart({width: width,height:height,
	store: store,
	axes:[{
	type:"Numeric",
	position:"left",
	fields:["y_0","y_1"],
	title:"test",grid:1
	},
	{
	type:"Numeric",
	position:"bottom",
	fields:["x_0","x_1"],
	title:"test",grid:1
	}],
	series:[
	{type:"line",axis:"left",xField:"x_0",yField:"y_0"},
	{type:"line",axis:"left",xField:"x_1",yField:"y_1"}
	],
	interactions: [
	{
    	type: 'iteminfo',
        listeners: {
        	show: function(interaction, item, panel) {
        		panel.update('Stock Price: $' + item.storeItem.get('x_0'));
        	}
    	}
    }],
	});
	
	my_chart.render(Ext.getBody())
	
	var my_container = new Ext.Panel({
		renderTo:Ext.getBody(),
		fullscreen: true,
    	items: [my_chart],
    	centered: true,
    	scroll: 'horizontal',
    	layout: {
    		type: 'auto'
    	},
    	style: 'background-color: #AEAEAE; overflow: hidden;'
    });
    
    
}});
