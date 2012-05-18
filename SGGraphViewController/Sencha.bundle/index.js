Ext.setup({onReady:function(){





var store=new Ext.data.JsonStore({fields:["data2","name","data1"],data:[{"data2":1,"name":"metric one","data1":1},{"data2":1,"name":"metric two","data1":4},{"data2":1,"name":"metric three","data1":8}]});

    
    new Ext.chart.Chart({
        renderTo: Ext.getBody(),
        width: 300,
        height: 300,
        store: store,        
      	
      	series: [{
        type: 'pie',
        angleField: 'data1',
        showInLegend: true,
        label: {
            field: 'name',
            display: 'rotate',
            contrast: true,
            font: '18px Arial'
        }
    }]
  
    });




}
});