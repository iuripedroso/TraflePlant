<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Busca de Plantas</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"> 
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <i class="fas fa-arrow-left header-icon"></i>
            <h1>Busca de Plantas</h1>
        </header>

        <main class="content-body">
            
            <div class="search-input-group">
                <input type="text" id="search-query" placeholder="Nome da Planta (ex: Rose, Oak)">
            </div>
            
            <button class="search-button">
                <i class="fas fa-search"></i>
                Buscar Planta
            </button>

            <div id="results-area" class="results-container">
                <p class="initial-message">Digite o nome de uma planta para começar a busca.</p>

                <ul class="plant-list">
                    <li class="plant-item">
                        <img src="url_da_imagem.jpg" alt="Imagem da Planta" class="plant-image">
                        <div class="plant-info">
                            <span class="common-name">Nome Comum (Ex: Rosa)</span>
                            <span class="scientific-name">Científico: Rosa canina</span>
                        </div>
                    </li>
                </ul>

            </div>
        </main>
    </div>
</body>
</html>
