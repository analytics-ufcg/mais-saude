var cidade = "Visão Geral";

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
			.attr("title", function (d){return d.big_description+".<a href='dicionario de dados.html?"+d.number+"' target='_blank'><img src='images/plus.png' onmouseover='this.src=&#39;images/plus2.png&#39;' onmouseout='this.src=&#39;images/plus.png&#39;' width='16' height='16'></a>";})
	
			.attr("id", function (d, i){return "span"+d.id;})
			.each(function(d) {
				d3.select(this).append("input")
				.attr("type","button")
				.attr("value", function (d){return d.name.replace("(%)","").replace("(em Reais)","");})
				.attr("id", function (d, i){return d.id;})
		        .attr("class", "indicador indicador_map")
		        .on("click", function(d) {
		        	
					if(cidade == "Visão Geral"){
						$("#map_title")
						.text(d.name.replace("(%)","").replace("(em Reais)",""));
						plotColorMap(d.id, d.desvio, dataset);
					}
					else{
						cleanContainers();
						plot_barra_indicador(cidade, d.id);
						plot_cidade_indicador(cidade, d.id);

					}
				
				});
			});
		// D3 code modification made ​​by Nailson ( add tooltip with jquery and the tooltipster's plugin)
		$('.tooltips').tooltipster({ 
			interactive: true,
			maxWidth: 300,
			offsetY: 2,
			position: 'right',
			theme: '.tooltipster-shadow'
			
		});

}


//Recebe uma cidade e pinta os botoes
function getMenuOption(selection) {
	//limpa containers
	cleanContainers();
	
    cidade = selection.options[selection.selectedIndex].value;

	if(cidade == "Visão Geral") {
		$("#map_area").show();
		resetMap(dataset);
		dicionario.sort(function (a, b) {
				return a.name.localeCompare(b.name);
		});
	}
	else {
		$("#map_area").hide();
	}

	rawdata = dataset.filter(function(i){return i.NOME_MUNICIPIO == cidade;});	
	
	dicionario.sort(function (a, b) {

		return getDesvio(a.desvio) - getDesvio(b.desvio);
			
	});
	
	d3.selectAll(".indicador")
		.data(dicionario)
		.attr("class", function(d) {

			return "indicador " + getButtonColor(d.desvio);        	
	    })
		.attr("value", function (d){return d.name.replace("(%)","").replace("(em Reais)","");}) 
		.attr("id", function (d, i){return d.id;})
	;

	$('.tooltips').tooltipster('destroy');	
	
	d3.selectAll(".tooltips")
		.data(dicionario)
		.attr("title", function (d){return d.big_description+".<a href='dicionario de dados.html?"+d.number+"' target='_blank'><img src='images/plus.png' onmouseover='this.src=&#39;images/plus2.png&#39;' onmouseout='this.src=&#39;images/plus.png&#39;' width='16' height='16'></a>";})
	;
	


	$('.tooltips').tooltipster({ 
			interactive: true,
			maxWidth: 300,
			offsetY: 2,
			position: 'right',
			theme: '.tooltipster-shadow'
			
	});



}

function cleanContainers(){
	
	d3.select("#div_indicador").select("svg")
    .remove();
	d3.select("#div_series").select("svg")
    .remove();
	d3.select("#plot_area").selectAll("h1").remove();
}

//Retorna a cor do Botao
function getButtonColor(colunaDesvio) {

	var valor = getRecentValueIndicadorColuna(colunaDesvio);

	if (valor == "NA" && cidade == "Visão Geral") {
        return "indicador_map";
	}

	if (valor == "NA") {
        return "indicador_cinza";
	}
	//console.log(valor);
	valor = parseFloat(valor);
	//console.log(valor);
	
	if (valor == -2) {
        return "indicador_amarelo";
	}
	else if (valor == -3) {
		return "indicador_laranja";
	}
	else if (valor <= -4) {
		return "indicador_vermelho";
	}
	else if (valor < 4 && valor >= 3) {
        return "indicador_verde";
	}
	else if (valor >= 4) {
        return "indicador_verde2";
	}
	else {
        return "indicador_branco";
	}
}

//Pode retornar NA se não houver nenhum ano disponivel para o Indicador
function getRecentValueIndicadorColuna(colunaDesvio) {
	var maxYear = rawdata.filter(function(d){return d[colunaDesvio] != "NA";}).map(function(d){return parseInt(d.ANO);});
	if (maxYear.length == 0) {
		return "NA";
	}
	else {
		maxYear = d3.max(maxYear);
		var currentYearData = rawdata.filter(function(d){return d.ANO == maxYear;})[0];
		return currentYearData[colunaDesvio];
	}
}

function getDesvio(colunaDesvio) {
	var valor = getRecentValueIndicadorColuna(colunaDesvio);

	if (valor == "NA" ) {
		return 10;
	}
	else {
		return parseFloat(valor);
	}

}