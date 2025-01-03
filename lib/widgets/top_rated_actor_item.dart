import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:movies/api/api.dart';
import 'package:movies/models/actor.dart';

class TopRatedActorItem extends StatelessWidget {
  // Constructor de TopRatedActorItem que recibe un actor y su índice
  const TopRatedActorItem({
    super.key,
    required this.actor,
    required this.index,
  });

  final Actor actor; // Actor que se va a mostrar
  final int index; // Índice del actor en la lista

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // Acción al hacer clic en el actor
            print('Actor seleccionado: ${actor.name}');
          },
          child: Container(
            margin: const EdgeInsets.only(left: 12),
            child: ClipRRect(
              // Se recorta la imagen con bordes redondeados
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                // Cargar imagen del actor desde la URL proporcionada
                Api.imageBaseUrl + (actor.profilePath ?? ''),
                fit: BoxFit.cover, // Ajustar la imagen para cubrir el contenedor
                height: 250,
                width: 180,
                errorBuilder: (_, __, ___) => const Icon(
                  // Si hay un error al cargar la imagen, mostrar un icono de imagen rota
                  Icons.broken_image,
                  size: 180,
                ),
                loadingBuilder: (_, __, ___) {
                  // Mientras la imagen se carga, mostrar una animación de carga
                  if (___ == null) return __;
                  return const FadeShimmer(
                    width: 180,
                    height: 250,
                    highlightColor: Color(0xff22272f),
                    baseColor: Color(0xff20252d),
                  );
                },
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: const EdgeInsets.all(6.0),
            margin: const EdgeInsets.only(bottom: 12, left: 12),
            decoration: BoxDecoration(
              // Fondo con opacidad para el texto
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              // Mostrar el índice y nombre del actor
              '$index. ${actor.name}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis, // Cortar el texto si es demasiado largo
            ),
          ),
        ),
      ],
    );
  }
}
