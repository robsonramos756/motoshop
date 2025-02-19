from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import mysql.connector


DB_CONFIG = {
    "host": "db",
    "user": "admin",
    "password": "admin",
    "database": "motoshop"
}

app = FastAPI()


class MotoSchema(BaseModel):
    nome: str
    marca: str
    cilindradas: str
    valor: str
    imagem: str


class ComentarioSchema(BaseModel):
    moto_id: int
    usuario: str
    comentario: str


def get_db_connection():
    return mysql.connector.connect(**DB_CONFIG)


@app.get("/motos")
def listar_motos():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM motos")
    motos = cursor.fetchall()
   
    for moto in motos:
        if not moto["imagem"].startswith("http"):
            moto["imagem"] = f"http://192.168.1.145:8080/images/{moto['imagem']}"  # Substitua pelo IP correto

    cursor.close()
    conn.close()
    return motos

@app.post("/motos")
def adicionar_moto(moto: MotoSchema):
    conn = get_db_connection()
    cursor = conn.cursor()
    sql = "INSERT INTO motos (nome, marca, cilindradas, valor, imagem) VALUES (%s, %s, %s, %s, %s)"
    valores = (moto.nome, moto.marca, moto.cilindradas, moto.valor, moto.imagem)
    cursor.execute(sql, valores)
    conn.commit()
    moto_id = cursor.lastrowid
    cursor.close()
    conn.close()
    return {"id": moto_id, **moto.dict()}

@app.get("/motos/{moto_id}/comentarios")
def listar_comentarios(moto_id: int):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM comentarios WHERE moto_id = %s", (moto_id,))
    comentarios = cursor.fetchall()
    cursor.close()
    conn.close()
    return comentarios


@app.post("/comentarios")
def adicionar_comentario(comentario: ComentarioSchema):
    conn = get_db_connection()
    cursor = conn.cursor()
    sql = "INSERT INTO comentarios (moto_id, usuario, comentario) VALUES (%s, %s, %s)"
    valores = (comentario.moto_id, comentario.usuario, comentario.comentario)
    cursor.execute(sql, valores)
    conn.commit()
    comentario_id = cursor.lastrowid
    cursor.close()
    conn.close()
    return {"id": comentario_id, **comentario.dict()}
