Ext.setup({onReady:function(){

var store=new Ext.data.JsonStore({
fields:["key","value"],
data:[
{"key":"slice_0","value":5},
{"key":"slice_1","value":1},
{"key":"slice_2","value":2}]});

var my_chart=new Ext.chart.Chart({
renderTo:Ext.getBody(),
width:300.000000,
height:300.000000,
store:store,
animate: true,
legend: {position: 'top'},
interactions: [{type: 'rotate'}],
series:[{
showInLegend:true,
type:'pie',
angleField:'value',
label:{
	field:'key',
	contrast:true,
	font:'16px Arial',
	display: 'middle',
    renderer: function(value) {
        var index = store.find('key', value);
        var record = store.getAt(index);
        return record.get('key') + ' : ' + record.get('value');
    }
}
}]});

var my_container = new Ext.Panel({
renderTo:Ext.getBody(),
fullscreen: true,
items: [my_chart],
centered: true,
scroll: 'horizontal',
layout: {type: 'fit',align: 'center',pack: 'center'}});}});