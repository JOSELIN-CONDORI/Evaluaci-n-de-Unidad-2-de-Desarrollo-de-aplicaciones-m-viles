package com.example.ventas.controller;

import com.example.ventas.entity.Categoria;
import com.example.ventas.service.CategoriaService;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/categoria")
public class CategoriaController {
    @Autowired
    private CategoriaService categoriaService;

    @GetMapping()
    public ResponseEntity<List<Categoria>> list() {
        return ResponseEntity.ok().body(categoriaService.listar());
    }

    @GetMapping("/buscar")
    public ResponseEntity<List<Categoria>> buscar(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) LocalDateTime createdAt,
            @RequestParam(required = false) LocalDateTime updatedAt,
            @RequestParam(required = false) String estado) {

        List<Categoria> categorias = categoriaService.buscar(nombre, createdAt, updatedAt, estado);
        return ResponseEntity.ok().body(categorias);
    }

    @PostMapping()
    public ResponseEntity<Categoria> save(@RequestBody Categoria categoria) {
        return ResponseEntity.ok(categoriaService.guardar(categoria));
    }

    @PutMapping()
    public ResponseEntity<Categoria> update(@RequestBody Categoria categoria) {
        return ResponseEntity.ok(categoriaService.actualizar(categoria));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Categoria> listById(@PathVariable(required = true) Integer id) {
        return ResponseEntity.ok().body(categoriaService.listarPorId(id).get());
    }

    @DeleteMapping("/{id}")
    public String deleteById(@PathVariable(required = true) Integer id) {
        categoriaService.eliminarPorId(id);
        return "Eliminacion Correcta";
    }
}