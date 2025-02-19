import unittest
import requests

BASE_URL = "http://localhost:8000"

class TestComentariosAPI(unittest.TestCase):

    def test_get_comentarios(self):
        """Teste: Listar comentários de uma moto (moto_id = 1)"""
        response = requests.get(f"{BASE_URL}/motos/1/comentarios")
        self.assertEqual(response.status_code, 200)
        self.assertIsInstance(response.json(), list)
        print("✅ [GET /motos/{id}/comentarios] Comentários listados com sucesso.")

    def test_post_comentario(self):
        """Teste: Adicionar um novo comentário"""
        new_comment = {
            "moto_id": 1,
            "usuario": "TesteUsuario",
            "comentario": "Excelente moto!"
        }
        response = requests.post(f"{BASE_URL}/comentarios", json=new_comment)
        self.assertEqual(response.status_code, 200)
        self.assertIn("id", response.json())
        print("✅ [POST /comentarios] Comentário adicionado com sucesso.")

if __name__ == '__main__':
    unittest.main(verbosity=2)
