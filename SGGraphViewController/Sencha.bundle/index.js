Ext.setup({onReady:function(){


var store = new Ext.data.JsonStore({
    fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5'],
    data: [
        {'name':'metric one', 'data1':10, 'data2':12, 'data3':14, 'data4':8, 'data5':13},
        {'name':'metric two', 'data1':7, 'data2':8, 'data3':16, 'data4':10, 'data5':3},
        {'name':'metric three', 'data1':5, 'data2':2, 'data3':14, 'data4':12, 'data5':7},
        {'name':'metric four', 'data1':2, 'data2':14, 'data3':6, 'data4':1, 'data5':23},
        {'name':'metric five', 'data1':27, 'data2':38, 'data3':36, 'data4':13, 'data5':33}
    ]
});

new Ext.chart.Chart({
    renderTo: Ext.getBody(),
    width: 500,
    height: 300,
    animate: true,
    store: store,
    series: [{
        type: 'pie',
        angleField: 'data1',
        showInLegend: true,
        tips: {
          trackMouse: true,
          width: 140,
          height: 28,
          renderer: function(storeItem, item) {
            //calculate and display percentage on hover
            var total = 0;
            store.each(function(rec) {
                total += rec.get('data1');
            });
            this.setTitle(storeItem.get('name') + ': ' + Math.round(storeItem.get('data1') / total * 100) + '%');
          }
        },
        highlight: {
          segment: {
            margin: 20
          }
        },
        label: {
            field: 'name',
            display: 'rotate',
            contrast: true,
            font: '18px Arial'
        }
    }]
});


}});