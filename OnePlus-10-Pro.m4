# Copyright
# SPDX-License-Identifier: BSD-3-Clause

include(`audioreach/audioreach.m4')
include(`audioreach/stream-subgraph.m4')
include(`audioreach/device-subgraph.m4')
include(`util/route.m4')
include(`util/mixer.m4')
include(`audioreach/tokens.m4')

dnl ============================================================
dnl Stream SubGraphs
dnl ============================================================

dnl Playback MultiMedia1 (WCD RX + Speakers)
STREAM_SG_PCM_ADD(audioreach/subgraph-stream-vol-playback.m4,
	FRONTEND_DAI_MULTIMEDIA1,
	`S16_LE', 48000, 48000, 2, 2,
	0x00004001, 0x00004001, 0x00006001)

dnl Capture MultiMedia3 (WCD / VA)
STREAM_SG_PCM_ADD(audioreach/subgraph-stream-capture.m4,
	FRONTEND_DAI_MULTIMEDIA3,
	`S16_LE', 48000, 48000, 1, 2,
	0x00004002, 0x00004002, 0x00006010)

dnl ============================================================
dnl Device SubGraphs
dnl ============================================================

dnl WCD Playback (RX_CODEC_DMA_RX_0)
DEVICE_SG_ADD(audioreach/subgraph-device-codec-dma-playback.m4,
	`RX_CODEC_DMA_RX_0', RX_CODEC_DMA_RX_0,
	`S16_LE', 48000, 48000, 2, 2,
	LPAIF_INTF_TYPE_RXTX,
	CODEC_INTF_IDX_RX0,
	0,
	DATA_FORMAT_FIXED_POINT,
	0x00004010,
	0x00004010,
	0x00006020)

dnl Speaker Playback (TERTIARY_TDM_RX_0)
DEVICE_SG_ADD(audioreach/subgraph-device-tdm-playback.m4,
	`TERTIARY_TDM_RX_0', TERTIARY_TDM_RX_0,
	`S16_LE', 48000, 48000, 2, 2,
	LPAIF_INTF_TYPE_LPAIF,
	TDM_INTF_TYPE_TERTIARY,
	0,
	DATA_FORMAT_FIXED_POINT,
	0x00004011,
	0x00004011,
	0x00006030,
	`TERTIARY_TDM_RX_0')

dnl WCD Capture (TX_CODEC_DMA_TX_3)
DEVICE_SG_ADD(audioreach/subgraph-device-codec-dma-capture.m4,
	`TX_CODEC_DMA_TX_3', TX_CODEC_DMA_TX_3,
	`S16_LE', 48000, 48000, 1, 2,
	LPAIF_INTF_TYPE_RXTX,
	CODEC_INTF_IDX_TX3,
	0,
	DATA_FORMAT_FIXED_POINT,
	0x00004012,
	0x00004012,
	0x00006040)

dnl VA Capture
DEVICE_SG_ADD(audioreach/subgraph-device-codec-dma-capture.m4,
	`VA_CODEC_DMA_TX_0', VA_CODEC_DMA_TX_0,
	`S16_LE', 48000, 48000, 1, 2,
	LPAIF_INTF_TYPE_VA,
	CODEC_INTF_IDX_TX0,
	0,
	DATA_FORMAT_FIXED_POINT,
	0x00004013,
	0x00004013,
	0x00006050)

dnl ============================================================
dnl Playback Mixers
dnl ============================================================

STREAM_DEVICE_PLAYBACK_MIXER(
	RX_CODEC_DMA_RX_0,
	``RX_CODEC_DMA_RX_0'',
	``MultiMedia1'')

STREAM_DEVICE_PLAYBACK_MIXER(
	TERTIARY_TDM_RX_0,
	``TERTIARY_TDM_RX_0'',
	``MultiMedia1'')

STREAM_DEVICE_PLAYBACK_ROUTE(
	RX_CODEC_DMA_RX_0,
	``RX_CODEC_DMA_RX_0 Audio Mixer'',
	``MultiMedia1, stream0.logger1'')

STREAM_DEVICE_PLAYBACK_ROUTE(
	TERTIARY_TDM_RX_0,
	``TERTIARY_TDM_RX_0 Audio Mixer'',
	``MultiMedia1, stream0.logger1'')

dnl ============================================================
dnl Capture Mixers
dnl ============================================================

STREAM_DEVICE_CAPTURE_MIXER(
	FRONTEND_DAI_MULTIMEDIA3,
	``TX_CODEC_DMA_TX_3'',
	``VA_CODEC_DMA_TX_0'')

STREAM_DEVICE_CAPTURE_ROUTE(
	FRONTEND_DAI_MULTIMEDIA3,
	``MultiMedia3 Mixer'',
	``TX_CODEC_DMA_TX_3, device120.logger1'',
	``VA_CODEC_DMA_TX_0, device130.logger1'')
