from sqlalchemy import create_engine, Column, String, Integer, Float, Date, ForeignKey
from sqlalchemy.orm import declarative_base, relationship, sessionmaker
from datetime import date

Base = declarative_base()


# --- MAPEAMENTO DAS TABELAS (Parte 2 do seu trabalho) ---

class Pessoa(Base):
    __tablename__ = 'pessoa'
    cpf = Column(String(100), primary_key=True)
    nome = Column(String(100))
    telefone = Column(String(100))
    endereco = Column(String(100))
    email = Column(String(100))

    # Relacionamento 1:1 com Motorista
    motorista = relationship("Motorista", back_populates="pessoa", uselist=False)


class Motorista(Base):
    __tablename__ = 'motorista'
    cpf = Column(String(100), ForeignKey('pessoa.cpf', ondelete="CASCADE"), primary_key=True)
    cat_cnh = Column(String(100))
    tempo_experiencia = Column(String(100))
    disponibilidade = Column(String(100))

    pessoa = relationship("Pessoa", back_populates="motorista")


class Veiculo(Base):
    __tablename__ = 'veiculo'
    placa = Column(String(100), primary_key=True)
    marca = Column(String(100))
    modelo = Column(String(100))
    ano = Column(Date)
    consumo_medio = Column(Integer)


# --- CONFIGURAÇÃO DA CONEXÃO (Parte 1 do seu trabalho) ---

# AJUSTE AQUI: 'postgresql://usuario:senha@localhost:porta/nome_do_banco'
USER = 'postgres'
PASSWORD = '1234'
DB_NAME = 'Gerenciamento_de_frotas'

engine = create_engine(f'postgresql://{USER}:{PASSWORD}@localhost:5432/{DB_NAME}')
Session = sessionmaker(bind=engine)
session = Session()


# --- TESTE DE OPERAÇÕES (Parte 3 e 4) ---

def executar_testes():
    try:
        # 1. CREATE: Inserindo um novo veículo
        print("Inserindo novo veículo...")
        novo_v = Veiculo(placa='TESTE123', marca='Fiat', modelo='Uno', ano=date(2022, 1, 1), consumo_medio=15)
        session.add(novo_v)
        session.commit()

        # 2. READ: Listagem com Ordenação
        print("\nLista de Veículos (Ordenado por Modelo):")
        veiculos = session.query(Veiculo).order_by(Veiculo.modelo).all()
        for v in veiculos:
            print(f"- {v.modelo} ({v.placa})")

        # 3. CONSULTA COM RELACIONAMENTO (JOIN)
        print("\nMotoristas e seus nomes:")
        motoristas = session.query(Motorista).join(Pessoa).all()
        for m in motoristas:
            print(f"Motorista: {m.pessoa.nome} | CNH: {m.cat_cnh}")

    except Exception as e:
        print(f"Erro: {e}")
        session.rollback()


if __name__ == "__main__":
    def executar_testes():
        try:
            # 1. CREATE: Inserindo novos veículos (Já fizemos, vamos adicionar mais um para garantir os "3 registros")
            print("\n--- [CREATE] Inserindo veículos ---")
            v2 = Veiculo(placa='SQL9999', marca='Ford', modelo='Fiesta', ano=date(2015, 1, 1), consumo_medio=12)
            session.add(v2)
            session.commit()
            print("Veículo Fiesta inserido!")

            # 2. UPDATE: Atualizar o nome de uma pessoa (Ex: Junior Mota para caixa alta)
            print("\n--- [UPDATE] Atualizando registro ---")
            pessoa = session.query(Pessoa).filter_by(cpf='11122233325').first()
            if pessoa:
                pessoa.nome = "JUNIOR MOTA SILVA"  # Alterando o nome
                session.commit()
                print(f"Nome atualizado para: {pessoa.nome}")

            # 3. DELETE: Remover o veículo de teste que criamos (Uno)
            print("\n--- [DELETE] Removendo registro ---")
            veiculo_velho = session.query(Veiculo).filter_by(placa='TESTE123').first()
            if veiculo_velho:
                session.delete(veiculo_velho)
                session.commit()
                print("Veículo de teste removido com sucesso!")

            # 4. READ & JOIN: Consulta complexa (Join + Filtro + Ordenação)
            print("\n--- [READ/JOIN] Consulta Final ---")
            # Listar motoristas da categoria 'b' ordenados por nome
            motoristas = session.query(Motorista).join(Pessoa).filter(Motorista.cat_cnh == 'b').order_by(
                Pessoa.nome).all()
            for m in motoristas:
                print(f"Motorista Categ. B: {m.pessoa.nome}")

        except Exception as e:
            print(f"Erro: {e}")
            session.rollback()