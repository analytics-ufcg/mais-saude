
var dataset = [];
var dicionario = [];

//Carrega arquivo inicial e os botoes
function loadData() {
	d3.csv("data/tabela_com_todos_os_indicadores_selecionados_e_desvios.csv" , function (data){		
		dataset = data;
		loadUpCities(dataset);
		resetMap(dataset);
	});
	d3.csv("data/dicionario.csv" , function (data){
		dicionario = data;
		loadUpButtons(dicionario)
	});

	$("#button_back_map").click(function() { 
			
			var selection = $("#myList").val("Visão Geral");
			selection.change();
	});



};

function loadUpCities(data) {
		
		//compara unicode characters
		function sortComparer(a,b){
			return a.localeCompare(b);
		};
		
		var cities = data.map(function(d){return d.NOME_MUNICIPIO;}).unique().sort(sortComparer);
		//adiciona um vazio dentro do array
		cities.unshift("Visão Geral");
		
		var myList = d3.selectAll("#myList");
		
		myList.selectAll("option").data(cities).enter().append("option")
		.attr("value",function(d){return d;})
		.attr("label",function(d){return d;})
		.attr("data-icon", "icon-map-marker")
		.text(function(d){return d;});
}

//Carrega os botoes da parte de cima
function loadUpButtons(data) {
	
		data.sort(function (a, b) {
				return a.name.localeCompare(b.name);
		});

		var div_buttons = d3.select("#div_indicador_options");

		div_buttons.selectAll("input")
		.data(data)
		.enter()
		.insert("span")
		.attr("class", "tooltips")
		.attr("title", function (d){return d.big_description;})
		.attr("id", function (d, i){return "span"+d.id;})

		.each(function(d) {
			d3.select(this).append("input")
			.attr("type","button")
			.attr("value", function (d){return d.name.replace("(%)","").replace("(em Reais)","");}) /*27/09/2013 - removeendo unidades*/
			.attr("id", function (d, i){return d.id;})
	        .attr("class", "indicador indicador_map")
			
			});	
}

function getMenuOption(selection) {

}

Array.prototype.unique = function() {
    var o = {}, i, l = this.length, r = [];
    for(i=0; i<l;i+=1) o[this[i]] = this[i];
    for(i in o) r.push(o[i]);
    return r;
};
