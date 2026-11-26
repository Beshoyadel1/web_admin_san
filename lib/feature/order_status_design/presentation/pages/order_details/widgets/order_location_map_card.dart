import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../core/services/geocoding_service.dart';
import '../../../../../../core/services/web_interop/web_interop.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';
import 'on_site_badge_widget.dart';

class OrderLocationMapCard extends StatelessWidget {
  final OrderDetailsModel? orderDetails;

  const OrderLocationMapCard({
    super.key,
    required this.orderDetails,
  });

  void _openInGoogleMaps(double lat, double long) {
    openExternalUrl(
        'https://www.google.com/maps/search/?api=1&query=$lat,$long');
  }

  @override
  Widget build(BuildContext context) {
    final double? lat = orderDetails?.lat;
    final double? long = orderDetails?.long;
    final bool hasCoordinates =
        lat != null && long != null && lat != 0.0 && long != 0.0;
    final bool isAr =
        Localizations.maybeLocaleOf(context)?.languageCode != 'en';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.veryLightGreyColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.orangeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.orangeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const TextInAppWidget(
                    text: LocaleKeys.serviceLocation,
                    textSize: 15,
                    textColor: AppColors.darkColor,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                  ),
                  if (orderDetails?.isOnSite != null) ...[
                    const SizedBox(width: 8),
                    OnSiteBadgeWidget(isOnSite: orderDetails!.isOnSite!),
                  ],
                ],
              ),
              if (hasCoordinates)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: () => _openInGoogleMaps(lat, long),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.orangeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.orangeColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 14,
                            color: AppColors.orangeColor,
                          ),
                          SizedBox(width: 6),
                          TextInAppWidget(
                            text: LocaleKeys.openInGoogleMaps,
                            textSize: 11,
                            textColor: AppColors.orangeColor,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.scaffoldColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.veryLightGreyColor.withValues(alpha: 0.7),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderNationalAddressRow(
                  nationalAddress: orderDetails?.nationaladdress,
                ),
                const SizedBox(height: 8),
                OrderGeocodedAddressRow(
                  lat: lat,
                  long: long,
                  isArabic: isAr,
                ),
                if (hasCoordinates) ...[
                  const SizedBox(height: 8),
                  OrderCoordinatesRow(
                    lat: lat,
                    long: long,
                  ),
                ],
              ],
            ),
          ),
          if (hasCoordinates) ...[
            const SizedBox(height: 12),
            OrderMapPreview(lat: lat, long: long),
          ],
        ],
      ),
    );
  }
}

class OrderNationalAddressRow extends StatelessWidget {
  final String? nationalAddress;

  const OrderNationalAddressRow({
    super.key,
    required this.nationalAddress,
  });

  @override
  Widget build(BuildContext context) {
    final hasAddress =
        nationalAddress != null && nationalAddress!.trim().isNotEmpty;
    final displayAddress =
        hasAddress ? nationalAddress! : LocaleKeys.addressNotSpecified.tr();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.pin_drop_rounded,
          color: AppColors.orangeColor,
          size: 18,
        ),
        const SizedBox(width: 8),
        TextInAppWidget(
          text: LocaleKeys.nationalAddressLabel.tr(),
          textSize: 13,
          textColor: AppColors.darkColor,
          fontWeightIndex: FontSelectionData.boldFontFamily,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextInAppWidget(
            text: displayAddress,
            textSize: 13,
            textColor: AppColors.darkColor,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
          ),
        ),
      ],
    );
  }
}

class OrderGeocodedAddressRow extends StatefulWidget {
  final double? lat;
  final double? long;
  final bool isArabic;

  const OrderGeocodedAddressRow({
    super.key,
    required this.lat,
    required this.long,
    required this.isArabic,
  });

  @override
  State<OrderGeocodedAddressRow> createState() =>
      _OrderGeocodedAddressRowState();
}

class _OrderGeocodedAddressRowState extends State<OrderGeocodedAddressRow> {
  String? _resolvedAddress;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fetchAddress();
    });
  }

  @override
  void didUpdateWidget(covariant OrderGeocodedAddressRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lat != widget.lat ||
        oldWidget.long != widget.long ||
        oldWidget.isArabic != widget.isArabic) {
      _fetchAddress();
    }
  }

  Future<void> _fetchAddress() async {
    if (widget.lat == null ||
        widget.long == null ||
        widget.lat == 0.0 ||
        widget.long == 0.0) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final address = await GeocodingService.instance.reverseGeocode(
      latitude: widget.lat!,
      longitude: widget.long!,
      isArabic: widget.isArabic,
    );

    if (!mounted) return;
    setState(() {
      _resolvedAddress = address;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasCoords = widget.lat != null &&
        widget.long != null &&
        widget.lat != 0.0 &&
        widget.long != 0.0;

    final String displayText;
    if (!hasCoords) {
      displayText = LocaleKeys.addressNotSpecified.tr();
    } else if (_isLoading && _resolvedAddress == null) {
      displayText = LocaleKeys.fetchingAddress.tr();
    } else {
      displayText = _resolvedAddress ?? LocaleKeys.addressNotSpecified.tr();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.place_rounded,
          color: AppColors.orangeColor,
          size: 18,
        ),
        const SizedBox(width: 8),
        TextInAppWidget(
          text: LocaleKeys.resolvedAddressLabel.tr(),
          textSize: 13,
          textColor: AppColors.darkColor,
          fontWeightIndex: FontSelectionData.boldFontFamily,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextInAppWidget(
            text: displayText,
            textSize: 13,
            textColor: AppColors.darkColor,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
          ),
        ),
      ],
    );
  }
}

class OrderCoordinatesRow extends StatelessWidget {
  final double lat;
  final double long;

  const OrderCoordinatesRow({
    super.key,
    required this.lat,
    required this.long,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.gps_fixed_rounded,
          color: AppColors.darkGreyColor,
          size: 14,
        ),
        const SizedBox(width: 8),
        TextInAppWidget(
          text:
              '${LocaleKeys.coordinatesLabel.tr()}${lat.toStringAsFixed(5)}, ${long.toStringAsFixed(5)}',
          textSize: 11,
          textColor: AppColors.darkGreyColor,
        ),
      ],
    );
  }
}

class OrderMapPreview extends StatefulWidget {
  final double lat;
  final double long;

  const OrderMapPreview({
    super.key,
    required this.lat,
    required this.long,
  });

  @override
  State<OrderMapPreview> createState() => _OrderMapPreviewState();
}

class _OrderMapPreviewState extends State<OrderMapPreview> {
  late final MapController _mapController;
  double _currentZoom = 14.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    final newZoom = (_currentZoom + 1.0).clamp(3.0, 18.0);
    setState(() {
      _currentZoom = newZoom;
    });
    _mapController.move(LatLng(widget.lat, widget.long), newZoom);
  }

  void _zoomOut() {
    final newZoom = (_currentZoom - 1.0).clamp(3.0, 18.0);
    setState(() {
      _currentZoom = newZoom;
    });
    _mapController.move(LatLng(widget.lat, widget.long), newZoom);
  }

  @override
  Widget build(BuildContext context) {
    final center = LatLng(widget.lat, widget.long);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: center,
                zoom: _currentZoom,
                interactiveFlags: InteractiveFlag.drag,
                onPositionChanged: (position, hasGesture) {
                  if (position.zoom != null) {
                    _currentZoom = position.zoom!;
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.smat_admin',
                ),
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: center,
                      color: AppColors.orangeColor.withValues(alpha: 0.18),
                      borderColor: AppColors.orangeColor,
                      borderStrokeWidth: 2,
                      useRadiusInMeter: true,
                      radius: 200,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: center,
                      width: 40,
                      height: 40,
                      builder: (ctx) => const Icon(
                        Icons.location_on,
                        color: AppColors.orangeColor,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              bottom: 10,
              end: 10,
              child: MapZoomControls(
                onZoomIn: _zoomIn,
                onZoomOut: _zoomOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapZoomControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const MapZoomControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.veryLightGreyColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              onTap: onZoomIn,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.add, size: 18, color: AppColors.darkColor),
              ),
            ),
          ),
          Container(
            width: 24,
            height: 1,
            color: AppColors.veryLightGreyColor,
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(8)),
              onTap: onZoomOut,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.remove, size: 18, color: AppColors.darkColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
