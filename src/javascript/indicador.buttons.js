
// cria botões dos indicadores
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
				.attr("value", function (d){return d.name;})
				.attr("id", function (d, i){return d.id;})
		        .attr("class", "indicador indicador_map")
		        .on("click", function(d) {
					if(cidade == 0){
						$("#map_title").text(d.name + " em " + getlastYear(d.id));
						plotColorMap(d.id);
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

// recebe uma cidade e pinta os botoes de acordo com a faixa
function getMenuOption(selection) {
	//limpa containers
	cleanContainers();
	
    cidade = selection.options[selection.selectedIndex].value;

	if(cidade == 0) {
		$("#map_area").show();
		resetMap(dataset);
		dicionario.sort(function (a, b) {
				return a.name.localeCompare(b.name);
		});
	}
	else {
		$("#map_area").hide();

		dataset_cidade = dataset.filter(function(d){return d.COD_MUNICIPIO == cidade;});
		
		cidade_ano_nao_na = dicionario.map(function(d){
			return {'ANO':getCurrentYearNotNA(cidade, d.id), 'INDICADOR': d.id};
	});
	
	
	dicionario.sort(function (a, b) {
		
		var year_a = cidade_ano_nao_na.filter(function(d){return d.INDICADOR == a.id;})[0].ANO;
		var year_b = cidade_ano_nao_na.filter(function(d){return d.INDICADOR == b.id;})[0].ANO;

		var valor_a = dataset_cidade.filter( function(d){return d.ANO == year_a;} )[0][a.id];
		var valor_b = dataset_cidade.filter( function(d){return d.ANO == year_b;} )[0][b.id];
		
		var bounds_a = desvios.filter(function(d){return d.indicador == a.id && d.ano == year_a})[0]
						.bounds;
		
		var bounds_b = desvios.filter(function(d){return d.indicador == b.id && d.ano == year_b})[0]
						.bounds;
		
		
		var color_a = get_color_scale_buttons(a.id)[calc_index_cor_indicador(a.id, valor_a, bounds_a)];
		var color_b = get_color_scale_buttons(b.id)[calc_index_cor_indicador(b.id, valor_b, bounds_b)];
		
		return color_b.valor-color_a.valor;
	});
	}
	
	d3.selectAll(".indicador")
		.data(dicionario)
		.attr("class", function(d) {
			return "indicador " + getButtonColor_new(d.id);
	    })
		.attr("value", function (d){return d.name;}) 
		.attr("id", function (d, i){return d.id;});

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

// remove gráficos plotados
function cleanContainers(){
	d3.select("#div_indicador").select("svg").remove();
	d3.select("#div_series").select("svg").remove();
	d3.select("#plot_area").selectAll("h1").remove();
}


// retorna a cor para o botão com base na faixa do indicador
function getButtonColor_new(indicador) {
	
	if (cidade == 0) {
	        return cor_do_mapa.botao;
	}

	var current_year = cidade_ano_nao_na.filter(function(d){return d.INDICADOR == indicador;})[0].ANO;
	
	var valor = dataset_cidade.filter( function(d){return d.ANO == current_year;} )[0][indicador];

	if (valor == "NA") {
        	return cinza.botao;
	}
	
 	var faixa = desvios.filter(function(d){return d.indicador == indicador && d.ano == current_year})[0]
                                        .bounds;
					
	return get_color_scale_buttons(indicador)[calc_index_cor_indicador(indicador, valor, faixa)].botao;

}
