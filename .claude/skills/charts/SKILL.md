---
name: charts
description: Crear o modificar gráficas (charts) en la app Baby Tracker con fl_chart, siguiendo el patrón de lib/features/stats/. Úsala cuando se pida añadir una gráfica nueva, una tarjeta de estadística, o cambiar las existentes (sueño, tomas, peso).
---

# Gráficas (fl_chart) en Baby Tracker

Esta skill genera gráficas coherentes con el resto de la app. La referencia
canónica de estilo y estructura es `lib/features/stats/screens/stats_screen.dart`.
**Léela siempre antes de empezar** para reutilizar sus helpers y patrones en vez
de reinventarlos.

## Dependencia

`fl_chart` ya está en `pubspec.yaml`. No añadas otros paquetes de gráficas.

```dart
import 'package:fl_chart/fl_chart.dart';
```

## Reglas no negociables

1. **Reutiliza los helpers compartidos** de `stats_screen.dart` antes de crear
   estilos nuevos: `_barData`, `_gridData`, `_titlesData`, `_touchData`,
   `_dayKey`, `_lastDays`. Si una gráfica nueva vive en el mismo archivo, úsalos
   directamente; si vive en otro feature, extrae los helpers a un archivo
   compartido (p. ej. `lib/core/widgets/chart_helpers.dart`) en vez de copiarlos.
2. **Envuelve cada gráfica en `_ChartCard`** (icono + título + subtítulo + altura
   fija de 180). No pongas un `LineChart`/`BarChart` "desnudo" en una pantalla.
3. **Colores por dominio** (constantes ya usadas en el proyecto):
   - Sueño: `Color(0xFF7C83FD)`
   - Tomas: `Color(0xFF89CFF0)`
   - Peso: `Color(0xFF6BC5A0)`
   Para un dominio nuevo, elige un pastel del `AppTheme` y declara la constante
   junto a las demás.
4. **i18n obligatorio**: ningún texto visible hardcodeado. Toda cadena (título,
   subtítulo, "sin datos", tooltips) va en `lib/l10n/app_en.arb` (plantilla) y
   `lib/l10n/app_es.arb`, y se accede con `context.l10n.<clave>`. Tras editar los
   `.arb`, regenera con `flutter gen-l10n` (o compilando). Sigue el prefijo de
   claves `stats*` para estadísticas.
5. **Sin datos**: si la serie está vacía o tiene puntos insuficientes, muestra
   `_NoData(message: l10n.statsNoData)` en lugar de un gráfico vacío.
6. **Localización de fechas/valores**: usa `DateFormat(..., locale)` con
   `Localizations.localeOf(context)` para ejes de fecha y `DateFormatter`
   (`formatWeight`, `formatDuration`, etc.) para tooltips. Nunca formatees a mano.
7. **Animación de entrada**: en listas de tarjetas aplica `.entrance(order: n)`
   (de `core/utils/animations.dart`) como en `StatsScreen`.
8. **Estado y datos**: la pantalla es un `ConsumerWidget` que hace `ref.watch`
   de los `StreamProvider` del feature (`feedingsProvider`, `sleepEntriesProvider`,
   `weightEntriesProvider`), todos dependientes de `selectedBabyProvider`. Maneja
   `isLoading` con `LoadingWidget` y el caso `baby == null`.
9. **`withValues(alpha:)`**, nunca `withOpacity` (deprecado). Código y comentarios
   en inglés.

## Receta para una gráfica nueva

1. Lee `stats_screen.dart` y localiza el helper/serie más parecido a lo pedido.
2. Decide el tipo de serie:
   - **Agregado diario** (cuenta/suma por día en una ventana de N días) → patrón
     `_DailyLineChart`: construye `{día: valor}` con `_lastDays` + `_dayKey`,
     genera `List<FlSpot>` por índice.
   - **Serie temporal irregular** (un punto por registro, fechas no uniformes) →
     patrón `_WeightLineChart`: ordena cronológicamente, indexa por posición,
     calcula `minY/maxY` con padding.
3. Calcula `maxY`/intervalos como en la referencia (clamp para evitar 0 e
   intervalos negativos).
4. Compón: `_ChartCard(icon, color, title, subtitle, child: <gráfico o _NoData>)`.
5. Añade las claves i18n a **ambos** `.arb` y úsalas con `context.l10n`.
6. Inserta la tarjeta en la pantalla con `.entrance(order: n)` y `SizedBox(height: 16)`
   entre tarjetas.

## Después de generar

- `flutter analyze` debe pasar limpio.
- Si tocaste tablas/DAO (no debería para una gráfica), recuerda `build_runner`.
- No edites archivos generados (`*.g.dart`, `app_localizations*.dart`) a mano.

## Antipatrones a evitar

- Copiar los helpers de estilo en cada archivo en vez de compartirlos.
- Tooltips o ejes con strings/fechas formateadas a mano (rompe i18n y locale).
- `LineChart` sin `_ChartCard`, sin estado de "sin datos", o con altura variable.
- Colores ad-hoc en vez de las constantes por dominio.
