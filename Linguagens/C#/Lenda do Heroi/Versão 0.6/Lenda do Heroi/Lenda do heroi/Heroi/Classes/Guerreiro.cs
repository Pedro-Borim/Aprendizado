﻿namespace Lenda_do_heroi
{
    internal class Guerreiro : Heroi
    {
        public Guerreiro(string nome, int idade)
        {
            this.setNome(nome);
            this.setIdade(idade);
            this.setLv(1);
            Corpo corpo1 = new Corpo("cabeca", "torso", false, "pernas", "pes");
            Status statusG = new Status(175, 0, 55, 40, 10, 20);
            this.setStatus(statusG);
            this.setCorpo(corpo1);

        }

    }
}
