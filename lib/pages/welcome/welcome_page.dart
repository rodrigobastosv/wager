import 'package:flutter/material.dart';
import 'package:wager/pages/register/register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 48),
          width: 800,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Seja bem-vindo(a) à Pesquisa Salarial Serh Consultoria 2022',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                './assets/images/logo.png',
                width: 400,
                filterQuality: FilterQuality.high,
              ),
              const Text(
                '''
      Nesses últimos anos temos presenciado transformações que tem impactado em nossas organizações. Dessa forma, é de fundamental importância que termos o controle de nossos negócios, para nos desenvolver com consistência e o item Remuneração requer um acompanhamento permanente, uma vez que ele tem grande participação na composição de custos e preços de nossos produtos/serviços.
      Procurando suprir a essa demanda, a SERH CONSULTORIA, uma empresa especializada em Recursos Humanos que atua há 32 anos no mercado, está desenvolvendo uma Pesquisa de Salários e Benefícios, e ficamos felizes de ter sua empresa como participante. 
      Vale salientar que cada empresa participante receberá um relatório com o resultado geral da pesquisa (salários e benefícios). Asseguramos total sigilo em todas as informações levantadas
      Para participar da pesquisa, faça o cadastro com seus dados para contato e os dados de sua empresa nas próximas telas. 
      ''',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Importante: tenha os dados que você vai inserir ao seu alcance na hora de preencher a pesquisa, pois depois você não poderá retornar para alterar as informações.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                  'Você tem até o dia 5 de setembro de 2022 para participar. '),
              const SizedBox(height: 12),
              const SelectableText(
                'Para mais informações, entre em contato: (85) 3257-4400/ evinlysousa@serh.net',
              ),
              const SizedBox(height: 36),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RegisterPage(),
                    ),
                  ),
                  child: const Text('INICIAR PESQUISA'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
