import unittest
import requests

BASE_URL = "http://localhost:8000"

class TestMotosAPI(unittest.TestCase):
    
    def test_get_motos(self):
        """Teste: Listar todas as motos"""
        response = requests.get(f"{BASE_URL}/motos")
        self.assertEqual(response.status_code, 200)
        self.assertIsInstance(response.json(), list)
        print("✅ [GET /motos] Lista de motos recebida com sucesso.")

    def test_post_moto(self):
        """Teste: Adicionar uma nova moto"""
        new_moto = {
            "nome": "TesteMoto",
            "marca": "TesteMarca",
            "cilindradas": "500cc",
            "valor": "R$ 20.000",
            "imagem": "TesteMoto.jpeg"
        }
        response = requests.post(f"{BASE_URL}/motos", json=new_moto)
        self.assertEqual(response.status_code, 200)
        self.assertIn("id", response.json())
        print("✅ [POST /motos] Moto adicionada com sucesso.")

if __name__ == '__main__':
    unittest.main(verbosity=2)
