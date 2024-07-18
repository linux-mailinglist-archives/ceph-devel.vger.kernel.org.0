Return-Path: <ceph-devel+bounces-1538-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C96E934A45
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jul 2024 10:47:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3EC91C2278F
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jul 2024 08:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B6712FB37;
	Thu, 18 Jul 2024 08:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="fJvfwWUa"
X-Original-To: ceph-devel@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11022116.outbound.protection.outlook.com [52.101.66.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ABB12DD90;
	Thu, 18 Jul 2024 08:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721292334; cv=fail; b=qtcDp3mxnc0XGVKcGBJOh/pax6guPLa4x4zu2/j2TCI7FXFvt2AKuD/AJD9yeHoQqR7d8R1gw9WAZK+id8hyD+LB1pVonHYfgf3TLmEHbTBROCJH5/8/ic6o7uUiuDSPskzDF6TAQzgTe3sPl9EVgh3VLIrSSbTavosbSFxp8PQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721292334; c=relaxed/simple;
	bh=d8/7VPD9Uje8UO+P8LZRe+KqKIkoEZ6YXRkBUcLWC6U=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=tQe3m7BO2lw0rkYecwQ82r+ssnVRlkTewtqVL0Z+3GlzNimEu81EBZR8DlKmAiiMc30Bom2o7E0LJDLOkKYntPI2SDVlote1v3phJbq4eBACQwvDWeZXt2BODMg7gQmsPvCTVQAQOF8BBgZbXES9jKNDLj5BYEog2NZcZipCCNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=fJvfwWUa; arc=fail smtp.client-ip=52.101.66.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uXduwTDUfCvg6RKbgz4DS+fJ6X4mLYwIsqiKM7fBdJwOaw2tx239HtfW3z/Kz/WWCMDemyXDs1cMnkYkC3O0xOgzZj3YPz8D6wt3gZcxdmhT8a9Wc9ZbxB2tf20dfOapIjcxCYhon9f4V/rq18/blGWMZ8Xu4+HEWqiWZOBmsvWrmgE6/38d79+5iBRB5QZMj0aHUnT0m5ZP4tlKspgJzK5kvTCFIlclS6EvRC96qEo67m2LnE0EquhuD12cW9aV5JjlLEmbErvKCRmKBcRAgvV1KVs5/03yYyM2Qq7l5ZJAUj1yK6P1pdv9FYndVNkMq0PMqlzzTVQbGZYgjaoI3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=thX/hIPBbq9Dop7ooUlbEo+vRH353mCOFs7ehP9bt4A=;
 b=ig9F2UL0uCOeSWgBSvfgLC1RssRBDNlhKP9nB+ZxpOs9QQ6hyQ0835kuKt4Jk6kSfwZ8aPq+nS91Wl3KSBC/gDsfBYh22pnF8x9/KTsbWQWD8YZKJj1+bje7Svr4hhZamamGNDakGExtxMOs8kCBLxs8c0Zc85qzMvHDfTlFfRxtdARBIat4A4J8OEkBU+SlFkDMVAqEktG/fz0uwroVs/BTkkv4XIM4y3ziWSbL+U2oug3ZqZ5pj7aUl59ZoW6VRg1hSANAq2H/dxLRFSr33hdfaqEsJeUOKlnPJcE9JHHogKe5yAgBQNBQ1lQWVAUhKFpoOcfEuAzFkQo9KgRO4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thX/hIPBbq9Dop7ooUlbEo+vRH353mCOFs7ehP9bt4A=;
 b=fJvfwWUaY5APp8LKufPTB6cCaUmtpRFJXqZPMeqnKGvJSsS+Z3+qXEc4nhJETRlYizZOCGf+fmE1d82JnQCR+FglxUkqHa6tSsikwjLjdcdm0K2hS1RHgPQH4W4KIwtdSRx2cB3LLzSOBU6L9lBR/EHjlekY+ZKdU4hDwotI+ZoBT8EMAmDaRYsNgiB7NY+1tn/wEixfp9wwdbQPqalBgqmxj2d+vyBB7XHXqrJJWniMiUL6TpOvTPWBPK4NiagNXobRMwHMoO+Jci16DcApxQ4+7ZmMySIWj4FVmOlMEaQEvExmuoogHSF9uSeSidjSR+E+2V9x90Vj5bvFmYOx/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::20)
 by PAXPR04MB9005.eurprd04.prod.outlook.com (2603:10a6:102:210::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.19; Thu, 18 Jul
 2024 08:45:26 +0000
Received: from AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7]) by AS8PR04MB8344.eurprd04.prod.outlook.com
 ([fe80::d3e7:36d9:18b3:3bc7%5]) with mapi id 15.20.7784.016; Thu, 18 Jul 2024
 08:45:25 +0000
From: Ofir Gal <ofir.gal@volumez.com>
To: davem@davemloft.net,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	netdev@vger.kernel.org,
	ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kbusch@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	sagi@grimberg.me,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com,
	idryomov@gmail.com,
	xiubli@redhat.com
Subject: [PATCH v5 0/3] bugfix: Introduce sendpages_ok() to check sendpage_ok() on contiguous pages
Date: Thu, 18 Jul 2024 11:45:11 +0300
Message-ID: <20240718084515.3833733-1-ofir.gal@volumez.com>
X-Mailer: git-send-email 2.45.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0030.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::16) To AS8PR04MB8344.eurprd04.prod.outlook.com
 (2603:10a6:20b:3b3::20)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8344:EE_|PAXPR04MB9005:EE_
X-MS-Office365-Filtering-Correlation-Id: ca030147-1061-4271-6d8b-08dca705f7e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z1ZBRnZtUkNuTUpyaUJ5M0tBTVhQVE9uK3MzNG1PeTZpeU1KR2kwUVVrZzBP?=
 =?utf-8?B?UkhRazJLYUxybGZUVWFKVXY3b3BRR3haOEptSVJIZFJnUXNRZ3Y0UHh0OC9B?=
 =?utf-8?B?UXcxZmVPYTlrMFJEcUhOclo4R0dtV2RGZG50NjJKMGN4SXJmRUZINExCK1Fk?=
 =?utf-8?B?VGhVY1krWDJRR0MvakxzbVlTTEtQR0ZyMnF4QTFURnJVV0NRZXBFZmpxZHIw?=
 =?utf-8?B?b3VnRnJrMjE0bUM4bUxtTVJRbWV1M2FYRnhMSEVCT3o5LzFlWU5JMGJZOXYx?=
 =?utf-8?B?L3NWZTdxcVpOekRSbkJSVkFIWHJsM1ZudGF2bzhqb1RFazF3VjFwODB3K2dq?=
 =?utf-8?B?K25KSkRNV3RWRDdTbmtUYmxtcE14S3VPTlJTRldwRGZqaXoyU2dzdnNZUm1P?=
 =?utf-8?B?ZmVQWkhFUVJnTGdld3hZRG9SdHpieGJoT202b28vUzRhT1cxemJGdUZyYzN3?=
 =?utf-8?B?bjIwOHBDT3lzeDJDTG9qQlhzKzhDclNNRDhyOVdRc2FMOGRwTXlMeEl5anRV?=
 =?utf-8?B?Ui9IYUdzQkJQc1YrZGxJMytKdTAwQnBEWUxqakdFajAxUWVHYlZqSVorVTBh?=
 =?utf-8?B?aDZHM3V0SkxJVllaZkNwVGNGcWRGN2daUCtlZkNhN3VFL2dYeWJwRkdPcXN4?=
 =?utf-8?B?YkxYOXAyakhLbWtsZ1Z0MjlBVzA2ZTlJRDJLMUh5YnRTdU8zanhxQlVDd29B?=
 =?utf-8?B?UnRGYkZCbHJqb2hib1g5NmNINXl0NjlCS2dUa3lxZklBMUprQS9odFpIbFVI?=
 =?utf-8?B?bXpPc1VXSGY3VmdlSnFBMjRxUCtJYjhSVC9wOXdad2N2Yk5nL01BVWwvM0dP?=
 =?utf-8?B?WkI2dTlrSWhhRTRRdXZRSndWVVBFVlFWeEU1NXppRGFEMmlKeDB4SHYwek5n?=
 =?utf-8?B?VXV4ZDJUamZWbWVhR0VQS3htK2Y0K3dRdG44TzA0LzFzR2ljaUFXNFJQTHhW?=
 =?utf-8?B?aDVpRXltaDBJZHVHZ253TlpsODh2eThaOUxHSWxDaXlCUzZNelVzenlMcU0v?=
 =?utf-8?B?SkV6NVRuMW9pSzFvT0NoTWR3RExnWUlLVGVyaTJpa2pOaGVGcDFhMGtJQTR0?=
 =?utf-8?B?WUdjbmh6SG92S0IzdjNtT3JvL3NrTFFxUXVzbE1wNndHN3Y3amRWenFZR05x?=
 =?utf-8?B?TzdVZlAzRXkyVGEwV0hDeEExMGpMYzE1NEpwMDRweXFRcnJlMGhtamNLTVZk?=
 =?utf-8?B?NlIxU25XS3BGaVVDczVRdmRvNUUzNjd2NWQxY1crTXBaYmM4S0s5NStpQnc0?=
 =?utf-8?B?YStNNFh0ZVhoV3AvNmNFSlo3L2xVWGhMRnM4VUdzWGtMRWl2a1pReEpLRkZo?=
 =?utf-8?B?R2VvSS9Qdm8zQ1RPRnpPaE5pdzZVcG9qOGpQU3kyTHdPSlpkNXE1SHliV25y?=
 =?utf-8?B?dzJxK09HRVIxeU5qODAyMm9xWGJaYjdHanVGTXNpVm5nc1NldTgyUWc3ME50?=
 =?utf-8?B?K0Eyb1Mxa3JuNkdDNVZucWRBTlNuUzQxc05FSElzR3dQeHdOaFphUXdVeVNj?=
 =?utf-8?B?bTBLdzYyUGJma3NZR1pyRCs5WGJEZ2xhTlo2THJkMlEyaW1CLzVuTkRaL0N4?=
 =?utf-8?B?MDNXMEpSeFAwaWxhVHlrclFFN0F5eE1sNUlaUXkzMjFDcERtNk40bitlaWND?=
 =?utf-8?B?SExpVGRyNkxidEZnUUtLZ1pCSTB1RHFDWU00eklhMTloWUUzeE1nbGVWYTNP?=
 =?utf-8?B?M1pKQXh4WXg0RWh4bkRaeGlyWnhqYTBOUWo1WS9WNHhneVZySnZEcjVyU3hX?=
 =?utf-8?B?cG4zdWlmNm1EZUZjUFRMSHNaSWFsMzdtWkFRZEhsV1NqbG9lQ0tSTndvWWFv?=
 =?utf-8?B?eUFwdEpabENXei9wdkxCbGpSVGpiak4zaGxTMENJcFRCWjJoVzg0MzJ3VEps?=
 =?utf-8?B?NGpYVlNiUlM3M2l5K0NGd3lLa2YxdUlZWG54MDdhdkZuU0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8344.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(52116014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlRwUW1yNVBNOXZYZ1pab0pPQTNmT0k3aWlXQkY4L2d1R0g2Sit6UnFCQzFs?=
 =?utf-8?B?MjhmZFp3L0xWbTdrWWxSVlhWMHFhRUVLNWFIdVB3WG9saktzeThYYkU2ZUdz?=
 =?utf-8?B?cDdXTkxmUktSMHhKQ2lJTmhIZTRJeHFwd1pvMktnbmprcHJzT0JXblhweUN3?=
 =?utf-8?B?bG1ydVQ0QWtDMmwyc2ROcGk3RDZzWnZZaEdkTjFIYms4N2d2TWhvQjRwb0RZ?=
 =?utf-8?B?c0NzOGtTY0d0UzY5MFNxeXYvMzJzeU1vQ2c4YS96dVhkRmFrV1hlMm8zTmJY?=
 =?utf-8?B?ZkE4Q3RSNTVsM2RCRFE0TU5KM0txSXNXQURiUUZPbEpvY0NxN0ozMU1sd2or?=
 =?utf-8?B?elZCT09BbnNhbm1EUEc3Zm9pZnpVMzBKN3MyVmhVa1oybXJkTVhVMjVxWDZE?=
 =?utf-8?B?UnpxT2I5Q2Z2YjhLL0gySVViK3J6bldJK1pGYllVSjUxQ09pdFF1c2tyS0Qx?=
 =?utf-8?B?eGZZL3dlR1JlTUZYRzZXMElMRUdCYnJ0SjdobDAzRStFNDRCYkZTRi9nRTRw?=
 =?utf-8?B?V0NYQS9ISDB0V3Z3RVRvdXpJaitlVTVLNk05d2ZjSmgwdEVnam9HVXFqc1Fi?=
 =?utf-8?B?SENQY24ybnZPaGFYMGtFUlRQbmswV0Rlenp1OXAzWndZSUNKQjVHMTROdjBQ?=
 =?utf-8?B?UWp5VGNyS3RxV3lBVnBiSkxpZXV1ckRWSW56dW01ZndhY0Z1TGllejk1a3BJ?=
 =?utf-8?B?b1RlRm5lZ1RmcmRZY281bGxiVngxMThKL2l6NlJnUlRaQzVEVEs2ZnlPeHNj?=
 =?utf-8?B?TWVBdlRzQWJXbE1TaGQ1WkZsSFYxalBrTnVwQ1Fhckk0YUtrRXMwMkZoUVlu?=
 =?utf-8?B?dGlZV3d0SCs1VDNkcXZyZy9xRGpDK1I1bm9PQTdJZERBWko5Tmx0ZGlFdDVt?=
 =?utf-8?B?QmhjOU4zenp3UW9ZZXlyMmJvS0s0Tm8waWpFTEhYUGZya2dvOS9LN05sVnZL?=
 =?utf-8?B?bS9qT3dsMERXeHhZem9TMndIMW5UTEVkYUZyS2V0bHRJRGdvZHJjQXl4TEpB?=
 =?utf-8?B?ajlGYTlvVEIrTndyaE5RMm50UW16SExQVkl1aFNTMU0vNERRSlRHcGdEYW5E?=
 =?utf-8?B?TDhzaEpNelI0T0hySnYybmJxY3lBdjJWcTFsOU5Md2gzQkV3b1Q4MGtlOVNq?=
 =?utf-8?B?U29vYUNJZk5yRzlKTXg3QmJ3R1N3eGNLRFExZzlSSDlsTFVudGYzV2VuVldp?=
 =?utf-8?B?UHNlWW1FY01DQU4ybFpvd0JjdEtEY25Ba1U4bjJCM2k1VFR3SVNBdnlMOVlZ?=
 =?utf-8?B?VW1TM0FnaTNMM3hPTklqUDhkU25wQUtXOXVNWWp1cXdwakxVbE12eGpPNXdm?=
 =?utf-8?B?TkNnOVhmeEdVWDRnZnZZcDhxeGxaUjFnOEhNNDJBbHRZbHZzRWxCQlJwcEdL?=
 =?utf-8?B?a0wyUDEydVV4TUhGNVR3dlRzT01iMG50K2pDNDMyMkVqT3krYjRNakZkQWpL?=
 =?utf-8?B?bWlaaTZRSG1GMlVDOXVzTDYzQk00SVZBcjZRNHlyb0JzcDZQcUpZTGM4d1Zm?=
 =?utf-8?B?UHZDZVpjaVRXWkMrSldLaTBQdUVnd29zMGdXeWdIdU5hMmZCRktMYzFOM0xW?=
 =?utf-8?B?OWo3akVQdFo4TERpd2RpSVRjYVpyZG94NnlKTndaUG5LS1hreWJvZEE1UTln?=
 =?utf-8?B?Z1d6SzhGc3BVSjVpMmgvWTdkWVNyMlRKRVJ3WUo5amsxcTh6NHBUYkN4KzIr?=
 =?utf-8?B?cTVUNWI0NTJtRzRtRVdZdlRRdnBBNDRtSnhLOFRidVgzSGEwdThtcllKNTdr?=
 =?utf-8?B?QlRCL00vZDJacTBZSEdLanY0VmtkbkxhcExXTmEzK2pWUkFaT2xxUExOUzBX?=
 =?utf-8?B?SGorWi9wVVUwSS9sSGkzdkZoMi9Ea2t4UHROMk1UUE4yNU55dU1veENaN1NL?=
 =?utf-8?B?U1NjT2IwMGljZWN1RFZFZVhwd245Tk1CYjFmSlk1M3BOTjRmaXVIVThWWTJa?=
 =?utf-8?B?bjZiQUF4a3g1RElLS25qczJmTVhYL3RuNm9JTlNDT3ZRdDJpbzIxU1oyQzRY?=
 =?utf-8?B?ZW9vT1VNa0RTNStIL3JJcXhOWCtrVng4bk5uaEUvK040VjgzSVE5MlJKNVpF?=
 =?utf-8?B?SFRLTjVScDNwekJDQXg4K1NkVU5UVU1vZC9UN3graDRiM3ROUzBEV3JnM095?=
 =?utf-8?Q?OzvfAdMyR8ubvVCWJHrFvNnk3?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca030147-1061-4271-6d8b-08dca705f7e9
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8344.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 08:45:25.8323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6G2dfvnpms6F9Mfyvlr4bAcLT3HMuUfEqYX/hVw9Pxq3DZeYrBkJhMGz7fS3f1WmKi+Byrfi7nFL/fw5bHXwiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9005

skb_splice_from_iter() warns on !sendpage_ok() which results in nvme-tcp
data transfer failure. This warning leads to hanging IO.

nvme-tcp using sendpage_ok() to check the first page of an iterator in
order to disable MSG_SPLICE_PAGES. The iterator can represent a list of
contiguous pages.

When MSG_SPLICE_PAGES is enabled skb_splice_from_iter() is being used,
it requires all pages in the iterator to be sendable.
skb_splice_from_iter() checks each page with sendpage_ok().

nvme_tcp_try_send_data() might allow MSG_SPLICE_PAGES when the first
page is sendable, but the next one are not. skb_splice_from_iter() will
attempt to send all the pages in the iterator. When reaching an
unsendable page the IO will hang.

The patch introduces a helper sendpages_ok(), it returns true if all the
continuous pages are sendable.

Drivers who want to send contiguous pages with MSG_SPLICE_PAGES may use
this helper to check whether the page list is OK. If the helper does not
return true, the driver should remove MSG_SPLICE_PAGES flag.

The root cause of the bug is a bug in md-bitmap, it sends a pages that
wasn't allocated for the bitmap. This cause the IO to be a mixture of
slab and non slab pages.
As Christoph Hellwig said in the v2, the issue can occur in similar
cases due to IO merges.


The bug is reproducible, in order to reproduce we need nvme-over-tcp
controllers with optimal IO size bigger than PAGE_SIZE. Creating a raid
with bitmap over those devices reproduces the bug.

In order to simulate large optimal IO size you can use dm-stripe with a
single device.
Test to reproduce the issue on top of brd devices using dm-stripe is
being added to blktests ("md: add regression test for "md/md-bitmap: fix
writing non bitmap pages").

The bug won't reproduce once "md/md-bitmap: fix writing non bitmap
pages" is merged, becuase it solve the root cause issue. A different
test can be done to reproduce the bug.


I have added 3 prints to test my theory. One in nvme_tcp_try_send_data()
and two others in skb_splice_from_iter() the first before sendpage_ok()
and the second on !sendpage_ok(), after the warning.
...
nvme_tcp: sendpage_ok, page: 0x654eccd7 (pfn: 120755), len: 262144, offset: 0
skbuff: before sendpage_ok - i: 0. page: 0x654eccd7 (pfn: 120755)
skbuff: before sendpage_ok - i: 1. page: 0x1666a4da (pfn: 120756)
skbuff: before sendpage_ok - i: 2. page: 0x54f9f140 (pfn: 120757)
WARNING: at net/core/skbuff.c:6848 skb_splice_from_iter+0x142/0x450
skbuff: !sendpage_ok - page: 0x54f9f140 (pfn: 120757). is_slab: 1, page_count: 1
...


stack trace:
...
WARNING: at net/core/skbuff.c:6848 skb_splice_from_iter+0x141/0x450
Workqueue: nvme_tcp_wq nvme_tcp_io_work
Call Trace:
 ? show_regs+0x6a/0x80
 ? skb_splice_from_iter+0x141/0x450
 ? __warn+0x8d/0x130
 ? skb_splice_from_iter+0x141/0x450
 ? report_bug+0x18c/0x1a0
 ? handle_bug+0x40/0x70
 ? exc_invalid_op+0x19/0x70
 ? asm_exc_invalid_op+0x1b/0x20
 ? skb_splice_from_iter+0x141/0x450
 tcp_sendmsg_locked+0x39e/0xee0
 ? _prb_read_valid+0x216/0x290
 tcp_sendmsg+0x2d/0x50
 inet_sendmsg+0x43/0x80
 sock_sendmsg+0x102/0x130
 ? vprintk_default+0x1d/0x30
 ? vprintk+0x3c/0x70
 ? _printk+0x58/0x80
 nvme_tcp_try_send_data+0x17d/0x530
 nvme_tcp_try_send+0x1b7/0x300
 nvme_tcp_io_work+0x3c/0xc0
 process_one_work+0x22e/0x420
 worker_thread+0x50/0x3f0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xd6/0x100
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x3c/0x60
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
...

---
Changelog:
v5, removed libceph patch as it not necessary
v4, move assigment to declaration at sendpages_ok(), add review tags
    from Sagi Grimberg
v3, removed the ROUND_DIV_UP as sagi suggested. add reviewed tags from
    Christoph Hellwig, Hannes Reinecke and Christoph Böhmwalder.
    Add explanation to the root cause issue in the cover letter.
v2, fix typo in patch subject

Ofir Gal (3):
  net: introduce helper sendpages_ok()
  nvme-tcp: use sendpages_ok() instead of sendpage_ok()
  drbd: use sendpages_ok() instead of sendpage_ok()

 drivers/block/drbd/drbd_main.c |  2 +-
 drivers/nvme/host/tcp.c        |  2 +-
 include/linux/net.h            | 19 +++++++++++++++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

-- 
2.45.1


