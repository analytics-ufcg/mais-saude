

//   valor_pessimo, valor_muito_ruim, valor_ruim, valor_bom, valor_muito_bom, neutro
var colors = [ "#FF0000", "#FF6600", "#FFCC00", "green", "#006400", "#F0F0F0", "#BFD8FF"]



//compara unicode characters
function sortComparer(a,b){
 return a.localeCompare(b);
};


function resetMap(dataset) {

	$("#map_title").text("Escolha uma Cidade ou um Indicador para mais detalhes.");
	var todas_cidades = dataset.map(function(d){return d.NOME_MUNICIPIO;}).unique().sort(sortComparer);
	var div_municipios = d3.select("#Municípios");


	//laço que itera em todas as cidades do mapa
	for (var i = 0; i < todas_cidades.length; i++) {

		var cidade = todas_cidades[i].replace(/ /g, "_");
		if(cidade == "Mãe_d'Água" || cidade == "Olho_d'Água") {
			cidade = cidade.replace(/'/, "_");
		}


		var cidadeID = div_municipios.select("#" + cidade);
		cidadeID.style("fill", "#FFFFFF");
		cidadeID.style("stroke", "#838281");
		cidadeID.style("stroke-width",76);

		//mouse over
		cidadeID.on("mouseover", function(d) {
			
		  	
			var cidadeID = $(this);
			cidadeID.css("fill", "#BFD8FF");
			

			var xPosition = cidadeID.offset().left + 100;
			var yPosition = cidadeID.offset().top;

			var cidade = cidadeID.attr("id").replace(/_/g, " ");

			if(cidade == "Mãe d Água" || cidade == "Olho d Água") {
				cidade = cidade.replace(/d Água/, "d'Água");
			}
			d3.select("#tooltip").style("left", xPosition + "px")
				.style("top", yPosition + "px")
				.select("#value").text(cidade);

			d3.select("#tooltip").classed("hidden", false);
		});
		
		//mouse out
		cidadeID.on("mouseout", function(d) {
			//mout(d);
			var cidadeID = $(this);

			var cidade = cidadeID.attr("id").replace(/_/g, " ");

			if(cidade == "Mãe d Água" || cidade == "Olho d Água") {
				cidade = cidade.replace(/d Água/, "d'Água");
			}

			cidadeID.css("fill", "#FFFFFF");

			d3.select("#tooltip").classed("hidden", true);
		});


		cidadeID.on("click", function(d){
			var cidadeID = $(this);

			var cidade = cidadeID.attr("id").replace(/_/g, " ");

			if(cidade == "Mãe d Água" || cidade == "Olho d Água") {
				cidade = cidade.replace(/d Água/, "d'Água");
			}

			var selection = $("#myList").val(cidade);

			selection.change();

		});
	};
}


function plotColorMap(indicador_nome) {
	
	var todas_cidades = dataset.map(function(d){return d.NOME_MUNICIPIO;}).unique().sort(sortComparer);
	var div_municipios = d3.select("#Municípios");
	var indicador_result;
	var indicador_valor;
	var indicador_desvio;
	var lastYear;


	//laço que itera em todas as cidades do mapa
	for (var i = 0; i < todas_cidades.length; i++) {

		indicador_result = getDesvioIndicador(indicador_nome, todas_cidades[i], dataset);
		lastYear = getlastYear(indicador_nome, todas_cidades[i], dataset);
		indicador_valor = indicador_result[0];

		var indicador_desvio = indicador_result[1];
		var cidade = todas_cidades[i].replace(/ /g, "_");
		//console.log(cidade);
		var cidade = todas_cidades[i].replace(/ /g, "_");
		if(cidade == "Mãe_d'Água" || cidade == "Olho_d'Água") {
			cidade = cidade.replace(/'/, "_");
		}
		var cidadeID = div_municipios.select("#" + cidade);
		
		cidadeID
			.transition()
			.duration(Math.floor((Math.random()*1000)+1))
			.style("fill", getClassColor( indicador_desvio))
			//.attr("class", "str2 " + getClassColor(indicador_valor, indicador_desvio, indicador_nome))
			;

		cidadeID.on("mouseover", function(d) {
			var cidadeID = $(this);
			cidadeID.css("fill", "#BFD8FF");
			//cidadeID.attr("class", "str2 " + "fil0");

			var xPosition = cidadeID.offset().left + 100;
			var yPosition = cidadeID.offset().top;

			var cidade = cidadeID.attr("id").replace(/_/g, " ");

			if(cidade == "Mãe d Água" || cidade == "Olho d Água") {
				cidade = cidade.replace(/d Água/, "d'Água");
			}

			var indicador_result = getDesvioIndicador(indicador_nome, cidade, dataset);
			var indicador_valor = indicador_result[0];
			var indicador_desvio = indicador_result[1];

			if(indicador_valor == "NA") {
				d3.select("#tooltip").style("left", xPosition + "px")
				.style("top", yPosition + "px")
				.select("#value").text(cidade + " não possui dados para este indicador.");
			}
			else {
				
				d3.select("#tooltip").style("left", xPosition + "px")
						.style("top", yPosition + "px")
						.select("#value").text(cidade + ": " + d3.format(".2f")(indicador_valor));		
			}
			d3.select("#tooltip").classed("hidden", false);
		});
	
		//mouse out
		cidadeID.on("mouseout", function(d) {
			var cidadeID = $(this);

			var cidade = cidadeID.attr("id").replace(/_/g, " ");

			if(cidade == "Mãe d Água" || cidade == "Olho d Água") {
				cidade = cidade.replace(/d Água/, "d'Água");
			}

			var indicador_result = getDesvioIndicador(indicador_nome, cidade, dataset);
			var indicador_desvio = indicador_result[1];

			cidadeID.css("fill", getClassColor( indicador_desvio));
			d3.select("#tooltip").classed("hidden", true);
		});

		cidadeID.on("click", function(d){
			var cidadeID = $(this);

			var cidade = cidadeID.attr("id").replace(/_/g, " ");

			if(cidade == "Mãe d Água" || cidade == "Olho d Água") {
				cidade = cidade.replace(/d Água/, "d'Água");
			}

			var indicador_result = getDesvioIndicador(indicador_nome, cidade, dataset);

			var selection = $("#myList").val(cidade);

			selection.change();

			if(indicador_result[0] != "NA") {
				cleanContainers();
				plot_barra_indicador(cidade, indicador_nome);
				plot_cidade_indicador(cidade, indicador_nome);

				
			}

			
		});

	}
}

// Retorna o ultimo ano de um dado indicador para uma cidade especifica
function getlastYear(indicador, cidade, dataset) {
	var rawdata = dataset.filter(function(i){return i.COD_MUNICIPIO == cidade;});	
	var maxYear = rawdata.filter(function(d){return d[indicador] != "NA";}).map(function(d){return parseInt(d.ANO);});
	return maxYear;

}

//Retorna o desvio padrão do ultimo ano disponível para um indicador e uma cidade
function getDesvioIndicador(indicador, cidade, dataset) {
	var rawdata = dataset.filter(function(i){return i.COD_MUNICIPIO == cidade;});	
	var maxYear = rawdata.filter(function(d){return d[indicador] != "NA";}).map(function(d){return parseInt(d.ANO);});
	if (maxYear.length == 0) {
		return ["NA","NA"];
	}
	else {
		maxYear = d3.max(maxYear);
		var currentYearData = rawdata.filter(function(d){return d.ANO == maxYear;})[0];
		
		color = get_color_scale_buttons(indicador)[
			calc_index_cor_indicador(indicador, currentYearData[indicador],desvios.filter(function(d){return d.indicador == a.id && d.ano == year_a})[0].bounds)
		]
		console.log(currentYearData[indicador]);
		return [currentYearData[indicador], 0];
	}
}

// Retorna a cor do desvio resultante
function getClassColor(desvioResult) {

	if (desvioResult == "NA" ) {
			return "#FFFFFF";
	}
	if(desvioResult == "-4"){
		return colors[0];
	}
	else if(desvioResult == "-3"){
		return colors[1];
	}
	else if(desvioResult == "-2"){
		return colors[2];
	}
	else if(desvioResult == "3") {
		return colors[3];
	}
	else if(desvioResult == "4") {
		return colors[4];
	}
	else{
		return colors[5];
		
	}
}
