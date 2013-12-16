// converte nome do município da versão da lista para a do mapa, o mapa da Paraíba tem nomes de município como ids :(
function municipio2mapa(municipio){
	var cidade_no_mapa = municipio.replace(/ /g, "_");
	if(cidade_no_mapa == "Mãe_d'Água" || cidade_no_mapa == "Olho_d'Água") {
		cidade_no_mapa = cidade_no_mapa.replace(/'/, "_");
	}
	return cidade_no_mapa;
}

// converte nome do município da versão do mapa para a da lista, o mapa da Paraíba tem nomes de município como ids :(
function mapa2municipio(mapa){
	var municipio = mapa.replace(/_/g, " ");
	if(municipio == "Mãe d Água" || municipio == "Olho d Água") {
		municipio = municipio.replace(/d Água/, "d'Água");
	}
	return municipio;
}

// mapa vazio
function resetMap(dataset) {

	$("#map_title").text("Escolha uma Cidade ou um Indicador para mais detalhes.");
	
	var div_municipios = d3.select("#Municípios");

	//laço que itera em todas as cidades do mapa
	for (var i = 0; i < cidades.length; i++) {

		var cidade_no_mapa = municipio2mapa(cidades[i].NOME_MUNICIPIO);


		var cidadeID = div_municipios.select("#" + cidade_no_mapa);
		cidadeID.style("fill", "#FFFFFF");
		cidadeID.style("stroke", "#838281");
		cidadeID.style("stroke-width",76);

		//mouse over
		cidadeID.on("mouseover", function(d) {
			var cidadeID = $(this);
			cidadeID.css("fill", "#bfffc6");

			var xPosition = cidadeID.offset().left + 100;
			var yPosition = cidadeID.offset().top;

			var cidade_na_lista = mapa2municipio(cidadeID.attr("id"));
						
			d3.select("#tooltip").style("left", xPosition + "px")
				.style("top", yPosition + "px")
				.select("#value").text(cidade_na_lista);

			d3.select("#tooltip").classed("hidden", false);
		});
		
		//mouse out
		cidadeID.on("mouseout", function(d) {
			var cidadeID = $(this);

			cidadeID.css("fill", "#FFFFFF");

			d3.select("#tooltip").classed("hidden", true);
		});


		cidadeID.on("click", function(d){
			var cidadeID = $(this);
			var cidade_na_lista = mapa2municipio(cidadeID.attr("id"));
						
			cidade = cidades.filter(function(d){return d.NOME_MUNICIPIO == cidade_na_lista})[0].COD_MUNICIPIO;

			var selection = $("#myList").val(cidade);
			selection.change();
		});
	};
}

// preenche mapa de acordo com indicador selecionado
function plotColorMap(indicador_nome) {
	
	var div_municipios = d3.select("#Municípios");
	var lastYear = getlastYear(indicador_nome);
	
	//laço que itera em todas as cidades do mapa
	for (var i = 1; i < cidades.length; i++) {

		var result = calcValorEDesvio(indicador_nome, cidades[i].COD_MUNICIPIO, lastYear);
		var cidade_no_mapa = municipio2mapa(cidades[i].NOME_MUNICIPIO);
		var cidadeID = div_municipios.select("#" + cidade_no_mapa);
		
		cidadeID
			.transition()
			.duration(Math.floor((Math.random()*1000)+1))
			.style("fill", result[1]);

		cidadeID.on("mouseover", function(d) {
			
			var cidadeID = $(this);
			
			cidadeID.css("fill", "#bfffc6");

			var xPosition = cidadeID.offset().left + 100;
			var yPosition = cidadeID.offset().top;

			var cidade_na_lista = mapa_to_municipio(cidadeID.attr("id"));
			var cidade_selecionada = cidades.filter(function(d){return d.NOME_MUNICIPIO == cidade_na_lista})[0];
			var result = calcValorEDesvio(indicador_nome, cidade_selecionada.COD_MUNICIPIO, lastYear);

			if(result[0] == "NA") {
				d3.select("#tooltip").style("left", xPosition + "px")
				.style("top", yPosition + "px")
				.select("#value").text(cidade_selecionada.NOME_MUNICIPIO + " não possui dados para este indicador.");
			}
			else {
				d3.select("#tooltip").style("left", xPosition + "px")
						.style("top", yPosition + "px")
						.select("#value").text(cidade_selecionada.NOME_MUNICIPIO + ": " + d3.format(".2f")(result[0]));		
			}
			d3.select("#tooltip").classed("hidden", false);
		});
	
		//mouse out
		cidadeID.on("mouseout", function(d) {
			var cidadeID = $(this);
			var cidade_no_mapa = mapa_to_municipio(cidadeID.attr("id"));
			var cidade_selecionada = cidades.filter(function(d){return d.NOME_MUNICIPIO == cidade_no_mapa})[0];
			var result = calcValorEDesvio(indicador_nome, cidade_selecionada.COD_MUNICIPIO, lastYear);

			cidadeID.css("fill", result[1]);
			d3.select("#tooltip").classed("hidden", true);
		});

		cidadeID.on("click", function(d){
			var cidadeID = $(this);

			var cidade_no_mapa = cidadeID.attr("id").replace(/_/g, " ");

			if(cidade_no_mapa == "Mãe d Água" || cidade_no_mapa == "Olho d Água") {
				cidade_no_mapa = cidade_no_mapa.replace(/d Água/, "d'Água");
			}
			
			cidade = cidades.filter(function(d){return d.NOME_MUNICIPIO == cidade_no_mapa})[0].COD_MUNICIPIO;

			var indicador_result = calcValorEDesvio(indicador_nome, cidade, lastYear);

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

// Retorna o ultimo ano com pelo menos um valor diferente de "NA", ou seja, um ano com dados válidos para povoar o mapa
function getlastYear(indicador) {
	var maxYear = dataset.filter(function(d){return d[indicador] != "NA";}).map(function(d){return parseInt(d.ANO);});
	return d3.max(maxYear);
}

//Retorna o desvio padrão do ultimo ano disponível para um indicador e uma cidade
function calcValorEDesvio(indicador, cod_cidade, lastYear) {

	var currentYearData = dataset.filter(function(i){return i.COD_MUNICIPIO == cod_cidade && i.ANO == lastYear;})[0];
	
	if (currentYearData[indicador] == "NA") {
		return ["NA",cinza.faixa];
	}
	else {
		color = get_color_scale_buttons(indicador)[
			calc_index_cor_indicador(indicador, currentYearData[indicador], desvios.filter(function(d){return d.indicador == indicador && d.ano == lastYear})[0].bounds)
		]
		return [currentYearData[indicador], color.faixa];
	}
}

