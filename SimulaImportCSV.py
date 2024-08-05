import csv
import random
from datetime import datetime, timedelta

# Função para gerar endereços IP aleatórios
def gerar_ip():
    return '.'.join(str(random.randint(0, 255)) for _ in range(4))

# Função para gerar datas aleatórias
def gerar_data(inicio, fim):
    return inicio + timedelta(days=random.randint(0, (fim - inicio).days))

# Função para gerar logs de API
def gerar_logs_api(qtd, inicio, fim):
    logs = []
    for _ in range(qtd):
        log = {
            'ip_origem': gerar_ip(),
            'porta_origem': random.randint(1024, 65535),
            'data_hora': gerar_data(inicio, fim).strftime('%Y-%m-%dT%H:%M:%S'),  # Formato ISO 8601
            'sistema': 'Sistema_' + str(random.randint(1, 5)),
            'usuario': 'Usuario_' + str(random.randint(1, 100)),
            'objeto': 'Objeto_' + str(random.randint(1, 50)),
            'resultado_login': random.choice(['sucesso', 'falha']),
            'status_http': random.choice([200, 400, 500])
        }
        logs.append(log)
    return logs

# Função para gerar eventos do MISP
def gerar_eventos_misp(qtd, inicio, fim):
    tipos_evento = ['PHISHING', 'CERTIFICADO', 'RANSOMWARE']
    estagios = ['Inicial', 'Em andamento', 'Concluído']
    eventos = []
    for _ in range(qtd):
        evento = {
            'data_ocorrencia': gerar_data(inicio, fim).strftime('%Y-%m-%d'),
            'grupo_compartilhamento': 'Open Finance Brasil',
            'nivel_ameaca': random.choice(['Baixo', 'Médio', 'Alto']),
            'estagio': random.choice(estagios),
            'tipo_incidente': random.choice(tipos_evento),
            'instituicao_alvo': 'Instituicao_' + str(random.randint(1, 20)),
            'referencia': 'http://example.com/evento_' + str(random.randint(1, 100)),
            'categoria': random.choice(['Targeting data', 'Network activity']),
            'tipo': random.choice(['target-org', 'url', 'others']),
            'detalhe': 'Detalhe_' + str(random.randint(1, 1000))
        }
        eventos.append(evento)
    return eventos

# Geração de dados sintéticos
inicio_periodo = datetime(2023, 1, 1)
fim_periodo = datetime(2024, 1, 1)
logs_api = gerar_logs_api(1001001, inicio_periodo, fim_periodo)
eventos_misp = gerar_eventos_misp(200201, inicio_periodo, fim_periodo)

# Escrita dos dados em arquivos CSV
with open('logs_api.csv', 'w', newline='', encoding='utf-8') as csvfile:
    fieldnames = ['ip_origem', 'porta_origem', 'data_hora', 'sistema', 'usuario', 'objeto', 'resultado_login', 'status_http']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    for log in logs_api:
        writer.writerow(log)

with open('eventos_misp.csv', 'w', newline='', encoding='utf-8') as csvfile:
    fieldnames = ['data_ocorrencia', 'grupo_compartilhamento', 'nivel_ameaca', 'estagio', 'tipo_incidente', 'instituicao_alvo', 'referencia', 'categoria', 'tipo', 'detalhe']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    for evento in eventos_misp:
        writer.writerow(evento)

print("Arquivos logs_api.csv e eventos_misp.csv gerados com sucesso!")