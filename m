Return-Path: <ceph-devel+bounces-3279-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 298D9AFC190
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Jul 2025 05:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 734C14A417B
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Jul 2025 03:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC7219D065;
	Tue,  8 Jul 2025 03:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b="HdiePvLL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11022103.outbound.protection.outlook.com [40.107.75.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5315DA94F
	for <ceph-devel@vger.kernel.org>; Tue,  8 Jul 2025 03:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751946612; cv=fail; b=SjxCOY83ypNyUlweb96950W6DUep2u5TEKZ044J8scAIjgXUtrlNyjtag1kDhYh7gCOM+kNFfToTP5NEJ1A142rTe7xrNgiqwll9qxRq8Ekm4iBB11OvwTBmUXL7JE88hxX1DZ+9Zs8S69xlJwm3I7V275Ek+LQ0/L1Atyl2/QY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751946612; c=relaxed/simple;
	bh=+kr8fNd/05NNdwV/j2VuH/njzt//1gLQizBlAau9+mU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BtbDM8SDXxNAiJRJyvhyqOrsvk75A7r2u21BRTq+Uwt26dFvauq2siZk7TXiEAGURsKSCxctSI57p1oeTe9+dqYTtveloPcnXthIkifr5tcPbl2NAGbuBSgyVLWjQ1UI6EgdcPjF2JcXCL7pWQm2XOMbc56opP2eh+RSgav5Yr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com; spf=pass smtp.mailfrom=qnap.com; dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b=HdiePvLL; arc=fail smtp.client-ip=40.107.75.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qnap.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cu1PFbbdF4VZoD+XvO3VAFa0NpymLtuGo6GcqUkfQmNoW3klfNL1zxWCauSyrZKUdQKtnCiDrJqaa90UB7Qbkkq48MX2G8AM6Hv2SOglZAiyPwydomsg5GvP4L6g4tc0ak50YY9LGEXtYGCy8uCtZWV5zDqm58edE/msyL6chf7CdVoBeeyw9xGrlQYE4EQJXZ0UhUYXH6TLi9hu+aAk9IRf1UZUjAXv0oxrM3ssFDZGCeWCN1u57X5ZYLkTrZSkHNOEGDVsknk7YAWNd86CzKVNFttVBEeQPjKteb9nwF77lXVkIW7zThgkc5VyRRnWDWcQtKzraqbq8hJqOKl9Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+kr8fNd/05NNdwV/j2VuH/njzt//1gLQizBlAau9+mU=;
 b=ettjt9wKdgUtrO/3K3qdZY8P/P50BjMQxUcbmVTYWEZojOpTL4zrMSfogZroh6geF6e7HAppjG4sLC8qpLAqG3XEkCEbp6DQABrjz6tA/7PkRaBwmFGnNmF0E3kafg2aLGDhy7SUO/EHPTHz0t7+SgE7+BM/+Dolnw0p0VXcXJ7l3SWmJGGuYSO8JXKc7SOOcaMkQAQ64kZ7xjJqJHBNKXdtFolZbwEp9Yeaf28Y4Zl6EEz2XyO0GDvOgMWO+ggcrlHFqXH56+wGvjbMpFNENOQIUVNn+t0X8WdSPdA+sdeE9aFFyHriqeWwtLFyI6yGuCmuxiV7Aq8jm8diXdcCpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qnap.com; dmarc=pass action=none header.from=qnap.com;
 dkim=pass header.d=qnap.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qnap.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+kr8fNd/05NNdwV/j2VuH/njzt//1gLQizBlAau9+mU=;
 b=HdiePvLLUyySLS6p2TPei9Jtn0kyxZtqQb+bypE8nQmKmjVW/XmbRNDnJ3RH4nO2yDuQLZLoglI4tA2yX24Ft55i3viMmX7+zKsk9Kk8s3JrUH3/WEQjgK92xmcWk02mXJj43xUZA5fVrmNvTaoUAK/l6Vdi34d5jaQkaWqDfGebyTun1x28SbxvIn/gtpPE4iyyUOlEdydUoQZ/wB/dmgxMz9qSsIdQ6Jfqg351fhiCSFGD7sFIng26nK3UkhqXn9PGHznPTbjOt3iVke610jE/c/vWms9QFs2NDZb/csDrZeco3R84B0hYuYbdVGPafoTnF4oEngRujfy+UQ9mew==
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com (2603:1096:101:ef::7)
 by PUZPR04MB6960.apcprd04.prod.outlook.com (2603:1096:301:113::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Tue, 8 Jul
 2025 03:50:01 +0000
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::8cc1:55c0:addb:f440]) by SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::8cc1:55c0:addb:f440%5]) with mapi id 15.20.8901.024; Tue, 8 Jul 2025
 03:50:01 +0000
From: =?utf-8?B?RnJhbmsgSHNpYW8g6JWt5rOV5a6j?= <frankhsiao@qnap.com>
To: Alex Markuze <amarkuze@redhat.com>
CC: Ceph Development <ceph-devel@vger.kernel.org>
Subject:
 =?utf-8?B?5Zue6KaGOiBbUkZDXSBEaWZmZXJlbnQgZmxvY2svZmNudGwgbG9ja2luZyBi?=
 =?utf-8?Q?ehaviors_via_libcephfs_and_cephfs_kernel_client?=
Thread-Topic: [RFC] Different flock/fcntl locking behaviors via libcephfs and
 cephfs kernel client
Thread-Index: AQHb5z8sUQOBykmKmEixSISAUEbQMrQmmc4AgAEN2ds=
Date: Tue, 8 Jul 2025 03:50:01 +0000
Message-ID:
 <SEZPR04MB6972B4482065C457DEDD4976B74EA@SEZPR04MB6972.apcprd04.prod.outlook.com>
References:
 <SEZPR04MB69722E22D60977F94BD6E875B745A@SEZPR04MB6972.apcprd04.prod.outlook.com>
 <CAO8a2SjYNTd1v=rGtSpeRcqUyuAJj1adjKy98Q8mGkaGtgRJrw@mail.gmail.com>
In-Reply-To:
 <CAO8a2SjYNTd1v=rGtSpeRcqUyuAJj1adjKy98Q8mGkaGtgRJrw@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=qnap.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR04MB6972:EE_|PUZPR04MB6960:EE_
x-ms-office365-filtering-correlation-id: 1cf2c336-e4af-4342-8281-08ddbdd2840e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?b1ltLzhnL0p5Zi9iOGtwL1RDUVc4bmJndWg4UWhXRGIwRWp0dlg1Y244aE1Z?=
 =?utf-8?B?bkpDemNrYnB5NGxlVmxGcFdzb21YRFZNM084RVgzWE1Yc1Z3dnpYSGJEb0c0?=
 =?utf-8?B?NmhVL1Q4UTU1L1JGZkVlSlRoSWFOdUxzN2VQdThNMWJlVDg0d2dSSEtEcFlo?=
 =?utf-8?B?NW52bmtaazBxb05wS1NMQ2xkK0hVQy9sSXYyS01nUUFtajQ3M3JpeklQZ2tl?=
 =?utf-8?B?V2RtRkVIejVxemxwSEdtYzBSWnN3REhTQWc0eUtERFZJc3pWcXhpOVJ4eVNy?=
 =?utf-8?B?YmRLSmI5cWR5TmROYWtYV255T0NzV2xZbkVNTnFuYlJ4VkFDRHJtVHNlaXBU?=
 =?utf-8?B?WFk2SGR1VkNHUTNaMkRtbkswYXJrUG9LMjlZeWsvVlRyREc5K3AxQmhjc1Rh?=
 =?utf-8?B?d3o4ektaeDhybzM2bVNzcXR2WDEvR1JDNlFYTk0vWHIyTDJJaVFVOGNmWFRy?=
 =?utf-8?B?b0ZSaFdENHdCZlVIYjlVZWI5SW1mMDRxb1JDbVZueXRtM3pjc3NRN3E5SEZx?=
 =?utf-8?B?dG82b1BGVHRGNFR2WGhuOFVQQ1A5ekV6bzVQMklKbDVwRkFId2J3LytPNWZi?=
 =?utf-8?B?SEU2dkppdlVFZG9SWDg5QVJtbHdXeHNTYUlCUGdNNmFmOUZITEZtemVSWGEw?=
 =?utf-8?B?Wm9ZNVZ3MTlzbG5vQ1diTVZNb0FiS1dpeGJJVjROMW85TUFxL21LKytYdTE2?=
 =?utf-8?B?TFJNT3BlbDRVYXdRT1VlREpJRnpYZTJlYUQvcW5sNEx3UEUyY2hNZEFZMlUw?=
 =?utf-8?B?dWVTNVhKV3pYY05VSGtFYk1KbU1pZDBLc0RUTVkrS3NoV2FQeTJ5VEIvaGxp?=
 =?utf-8?B?T2MzRzlGYXMvQ0VtdS9QOUMvZGRQaFBNUFNyY1BOS2FtNU9EWTVhbUJYM09h?=
 =?utf-8?B?b295Z2owT1RlZGNKVWdFTFhwNDA3NnpITzA1cTFCQUF0blkrQ0poS01zQS9J?=
 =?utf-8?B?UjJ4Q1Zad2pNQk05c1o2emV6ZkFCcDhQVGE1SjVjNjZRd0FzSUpPaTk4dEhl?=
 =?utf-8?B?eEdiOVJ6cWlsRU1TNFFyemkrYXdUOGFxaHRhaHMyZlZRbWEyVFJKNmk1eHhT?=
 =?utf-8?B?bWJ2bXF1bFo2RWE5MGRwS0xqNnVSSFRXTWhOeU5NamVlVjQrRS9HMlVoR3lX?=
 =?utf-8?B?SzkwL0lyUllIVHpnL3JrODJwT3JnNUZLaVZCQWxoRmNEcnhYOVRNZC9WQWFS?=
 =?utf-8?B?dFhUeTQ1aC9PbXVPOXI2VjlYK3FhczVJcSt1T3Y4ZEdzdXc2ZU1GNDRVdUtJ?=
 =?utf-8?B?dmp0aTlmeHFueXd6c1k2WUlqMjVFa0pFWDN2bXpEZ1BlOHByU0JlWE9jb2Rt?=
 =?utf-8?B?Y3Q3WVVUYm9LS05nVUlzQ0hGcUo4R1hheGJmand3M0J4NE02NnNFaDBaV2Nk?=
 =?utf-8?B?MVdNTjEyQm1GQW83UUtTYll2aGppU3VkWFUzWFVGc2lYT09XSVlLRUJZTVpm?=
 =?utf-8?B?eE1nZk05b2Z6cDhNUE9Sb0hGdUZBWDFSV3FXZFpQSGovaG9MVkZrd0xaT2Nk?=
 =?utf-8?B?VUxMaW9WeW9xaUZaS09EL0ExUTczWC9jRmFPYnoyY0ptU09ESG9YR21oak10?=
 =?utf-8?B?KzhyTWh3bHFHNkFySVFodWs3MEFpYXlVYnJqSzl6eFoyMDRMcTVKWFBHNXhN?=
 =?utf-8?B?TjZtbEtKZlJwMlVZZEJjTDcxWWdNKzY4Y3FnTnFCOW9mSWRCaHJSbkdnY2dy?=
 =?utf-8?B?cytIRW9VcTJRWVBnelp0VEdxWkVka0kzVThKaHhmcEhiV1Nrd3R0NGhVOFk1?=
 =?utf-8?B?em5FcnNZOGVVTlVwN3JnQjFQK0hhd3ozSUFMMG8ySkQrU1VDSWZ0RXp6T28r?=
 =?utf-8?B?RVRIYjBWNzg2R29DcnhDdERabTR3bERTYVZKUFNUSmZNZGFXUUJHa3ZkZjlY?=
 =?utf-8?B?NnFNWUxXTzk2QmZzdXNtZzdqbWo5Um9RNjBKZHlndHBneFpGa2JBSVVQeWpB?=
 =?utf-8?B?M3N0ZS82UVJMcFY2STVmZkNzcHB3Yk84dEkrSFpjMC9qY2ZrenZzZFUzL1Vx?=
 =?utf-8?B?RS9TWFRyTC9nPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-tw;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR04MB6972.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TGxTQlhKTlFjOEFOdTZqM1R3Z1N5WTVJdU01c3VqRHFNVlFIc0hqNXczRDBv?=
 =?utf-8?B?eXM4Y2JoUG9PckpCOUhEUnBWVHdXYk4zV1FUMmVxUUpJdVlGM2hYbTZES2d5?=
 =?utf-8?B?N01mR2RBVVU4SmZ0S1ZyRFpkZmt2L0EzaFRFTzh2ZDVOT21QaDhYbjZBei96?=
 =?utf-8?B?eXhTdVFLaFE4ZmQyTTNTSXhCUWZiWExJWTk0THYzOWt0aERDLytWem5FVDd5?=
 =?utf-8?B?QncrV210ZXNmMUEycWZ6RmV6a0RoNjhEVmU5dGtaRlluNXcxaXBneUdvU2Zp?=
 =?utf-8?B?QTdhWVYvUng2T1RncE5qc2xrc2RCN2pYNXlIbC9yY0FuZDI5OGR6TTRtcFA0?=
 =?utf-8?B?dFFzOWFuNzJDd0pBZVIyYkcvZG44UGVPZklHQWxEcFU1bHZzV2hZNW50bWxN?=
 =?utf-8?B?NnMwNE9FVUh5NmhWQW90Q0dCRWk0ZnM1QXpKRVhVMXE1OUJpTlBINUIxNG14?=
 =?utf-8?B?K0NRSkpDbmkwTDJ5RjIzSUR5V1NPS2Y2WUhKNWErZHdQUmhFdEVZczNwMUR1?=
 =?utf-8?B?YjEwYUxVZ01YWnBPQUkvZ3owSytDcEQ5b2dwbXhVMTU0VDREdk1UMFRRdjg0?=
 =?utf-8?B?NlBVUDg3eG1rTi9TK3VVWk1XSUtrckQwcjFCVURWQVN4c2cwQXBPeFlobGpV?=
 =?utf-8?B?RG12b3M2OVArelRQbHdrNmp1SHVnWU5UZEdVb1dMOVdOTFFOQXlNemsyMzd1?=
 =?utf-8?B?UEFxUTRpRVp3Q2xGWXNNRUhrNXk4cXA2eFU2R3VtQmI0WFI3emc4dDQ3RktF?=
 =?utf-8?B?M205V1Y2RlZwQ1M4ZVI2UVYrbFhIaTZWVWQ3UW5wM3FrUG5ualhaS2lLeUZM?=
 =?utf-8?B?dnE3U3JaYTF2bDVKY2c0WUZ1U3dkM3dTTjFHb0hTVlVXWGUrMGk5K1Zielo0?=
 =?utf-8?B?VGhORlVrRkZzaVFrcnNXdXF5VFBXWjhmUVF1WE5oVGJhc0xaNnhydHo1bVJk?=
 =?utf-8?B?M2ptQ2ZpSis4NkI3U0F2SmhLYjRSRlpjelJuWjRUdE40MHltN1RpaDJuYk9R?=
 =?utf-8?B?dDg2T3o1S1RqbDBxOFVyWnhHekpvVUZ2QTIrRWxjTjIwYVlZc1ZPc1hOcTMv?=
 =?utf-8?B?L2tkRFl1bGdwYVJnMi9JQVFlR0laek5vMy9zWURNbFVNbHdHK3pZYU5CWVBr?=
 =?utf-8?B?cGNmYnZlUk9wNHhhQncydVhqNFdLeGpieDZDMFRrL1BUSHVTalNqUENWYnJO?=
 =?utf-8?B?VGcxbXE3aURxM1RtVmt2NnoxcWI3MFZJOEJGS0pvZTh2SW9lcW5WbFZsOFFx?=
 =?utf-8?B?K0dGK1ZYRDdhV040ZXBiWlFnamt6SG9EeS9LMCtSTnFOVm5xSGVmVDMySENp?=
 =?utf-8?B?bmJWQkdLSS9rbnEzRjJvYkVvVDYzeFdMN2ZsVkptWHRUSjRuRGw5azcwTEh5?=
 =?utf-8?B?bEtFdm1YR1YrUUxVMElaZEVOcXBNU01MN053RFd0Ui9HNGo4Q2lnVFJvODRJ?=
 =?utf-8?B?Ni8wSTNsSFFKdFlLd3dnZGFHRllYWFJUaTZWUWhscEZuVFd3eVZNaC80YWVZ?=
 =?utf-8?B?cVI2NVdaRm5DNXVXcDEvb3ptU0w5dThZYTZuOEhpNnZnWGs5cXFoVTdQZVR3?=
 =?utf-8?B?ZGpuelhzS01zRkM2eGx5MytjK1dvTTFaMTdpc1NkUm41QUVwcklURDJyUXJs?=
 =?utf-8?B?NGJoZVUyOTVYRmNtaVdWYUZ5VXVuQ2FQVGlUU2JaVTdkUlQ5WGpTS0hxVGl5?=
 =?utf-8?B?eFFpc2N2WklzckQxbGQvNTdMNHYyT2VmK0w0NlQxaWlNdVozVXNGNVFsLytS?=
 =?utf-8?B?bHVvUDd3VnM0ZlBEejBpRlFGSG1zVnp5bkxGNGdYZEgyZHc5K1U0ZXROQjF0?=
 =?utf-8?B?UW1lVGxuTklGOUVRQjdYVmVjRjBUeFZWUmNUbGhIT3poVENLWFNHcTFRRWFC?=
 =?utf-8?B?ZHZNQ2hJMFJITnJURVFOcnJxMHB1emRHR3VmWlZMc1JSZDNuQkV1RUJuVzN3?=
 =?utf-8?B?Y3Rsc0JVeTZUQnB1OHYrMVNEdDh0SzJ0TkFBQyt4VVhJZkl0dGxhbWdtS1BM?=
 =?utf-8?B?MTVpY3E0TEZvUHM1UjNyM3Q5bW9KekpwSXc1N1lML2RqaVZRM0lmNEpHcHZa?=
 =?utf-8?B?OUNVb04ySVVlSjRjSVZ6MERGT0dTaTFvQnl5ajdVN3BWeWtidERoZm5nMmJr?=
 =?utf-8?Q?xIWU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: qnap.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SEZPR04MB6972.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cf2c336-e4af-4342-8281-08ddbdd2840e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2025 03:50:01.2547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6eba8807-6ef0-4e31-890c-a6ecfbb98568
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: evT4A8TwNY7kqGY8K3t3dAJrP4wifJ/SsSpUn0FhLY7ddEwqVPqES/kOEwMgqynG2M5xNRE3EScvZ5pK9FhI8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR04MB6960

SGkgQWxleCwKClRoYW5rIHlvdSBmb3IgZGV0YWlsZWQgZXhwbGFuYXRpb24gcmVnYXJkaW5nIHRo
ZSBsb2NrIGlzb2xhdGlvbiBiZXR3ZWVuIG11bHRpcGxlCmxpYmNlcGhmcyBjbGllbnRzLiBJIHdv
dWxkIGxpa2UgdG8gZm9sbG93IHVwIHdpdGggYSBmZXcgcXVlc3Rpb25zOgoKMS4gV291bGQgaXQg
YmUgYWR2aXNhYmxlIHRvIHN3aXRjaCB0byBrZXJuZWwgbW91bnQgaW4gb3JkZXIgdG8gZW5zdXJl
IGNvbnNpc3RlbnQKbG9jayBjb29yZGluYXRpb24gYmV0d2VlbiBtdWx0aXBsZSBjbGllbnRzPwoy
LiBBcmUgdGhlcmUgbG9jay9jYWNoZSBpc3N1ZXMgaWYgSSB1c2UgYSBoeWJyaWQgc2V0dXAoU2Ft
YmEgdXNlcyBrZXJuZWwgY2xpZW50CmFuZCBORlMgdXNlcyBsaWJjZXBoZnMsIGZvciBleGFtcGxl
KT8gT3IgbW9yZSBnZW5lcmFsbHksIHdoZW4gcnVubmluZyBtdWx0aXBsZQpwcm90b2NvbHMgb3Zl
ciB0aGUgc2FtZSBDZXBoRlMgYmFja2VuZCwgaXMgdGhlcmUgYSByZWNvbW1lbmRlZCBhcHByb2Fj
aApyZWdhcmRpbmcgbGliY2VwaGZzIHZzLiBrZXJuZWwgY2xpZW50IHVzYWdlPwoKVGhhbmtzLApG
cmFuawoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K5a+E5Lu26ICF
OiBBbGV4IE1hcmt1emUgPGFtYXJrdXplQHJlZGhhdC5jb20+CuWvhOS7tuaXpeacnzogMjAyNeW5
tDfmnIg35pelIOS4i+WNiCAwNzo0MgrmlLbku7bogIU6IEZyYW5rIEhzaWFvIOiVreazleWuowrl
ia/mnKw6IENlcGggRGV2ZWxvcG1lbnQK5Li75peoOiBSZTogW1JGQ10gRGlmZmVyZW50IGZsb2Nr
L2ZjbnRsIGxvY2tpbmcgYmVoYXZpb3JzIHZpYSBsaWJjZXBoZnMgYW5kIGNlcGhmcyBrZXJuZWwg
Y2xpZW50CgpTdWJqZWN0OiBSZTogRmlsZSBsb2NraW5nIHNlbWFudGljcyB3aXRoIENlcGhGUyB2
aWEgU2FtYmEgYW5kIE5GUyAobGliY2VwaGZzKQoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KCkhpIEZyYW5rLAoKClRvIHlvdXIgY29yZSBxdWVzdGlvbnM6CgpZZXMsIHRoZSBvYnNl
cnZlZCBiZWhhdmlvciBpcyBleHBlY3RlZCB3aGVuIHVzaW5nIGxpYmNlcGhmcy4gVW5saWtlCnRo
ZSBrZXJuZWwgQ2VwaEZTIGNsaWVudCwgbGliY2VwaGZzIGRvZXMgbm90IHByb3ZpZGUgZnVsbCBQ
T1NJWCBsb2NrCmNvb3JkaW5hdGlvbiBhY3Jvc3MgbXVsdGlwbGUgY2xpZW50IGluc3RhbmNlcy4g
U2FtYmEgYW5kIE5GUy1HYW5lc2hhCmFyZSBlYWNoIHVzaW5nIHRoZWlyIG93biBsaWJjZXBoZnMg
Y29udGV4dCBhbmQgdGh1cyBtYWludGFpbiBzZXBhcmF0ZQpsb2NrIHN0YXRlcywgYW5kIGxvY2tz
IGFjcXVpcmVkIG9uIG9uZSBzaWRlIGFyZSBub3QgdmlzaWJsZSBvcgplbmZvcmNlZCBvbiB0aGUg
b3RoZXIuCgpUaGVyZSBhcmUgaW5kZWVkIGtub3duIGxpbWl0YXRpb25zIHdoZW4gbWl4aW5nIHBy
b3RvY29scyBvdmVyCmxpYmNlcGhmcy4gSW4gcGFydGljdWxhciwgZmlsZSBsb2NraW5nLCBkZWxl
Z2F0aW9uLCBhbmQgY2FjaGluZwpzZW1hbnRpY3MgYXJlIG5vdCBzaGFyZWQgYWNyb3NzIGxpYmNl
cGhmcyBjb25zdW1lcnMsIGFuZCB0aGUgQ2VwaCBNRFMKZG9lc24ndCBjdXJyZW50bHkgbWVyZ2Ug
bG9jayBzdGF0ZXMgYWNyb3NzIGluZGVwZW5kZW50IHVzZXItc3BhY2UKY2xpZW50cyB1bmxlc3Mg
bWVkaWF0ZWQgdGhyb3VnaCB0aGUga2VybmVsIGNsaWVudCBvciBjb29yZGluYXRlZApleHBsaWNp
dGx5LgoKCgpPbiBNb24sIEp1bCA3LCAyMDI1IGF0IDEyOjU54oCvUE0gRnJhbmsgSHNpYW8g6JWt
5rOV5a6jIDxmcmFua2hzaWFvQHFuYXAuY29tPiB3cm90ZToKPgo+IEhpIGFsbCwKPgo+IEnigJlt
IGVuY291bnRlcmluZyB1bmV4cGVjdGVkIGJlaGF2aW9yIHdoZW4gdGVzdGluZyBmaWxlIGxvY2tp
bmcgc2VtYW50aWNzIG9uCj4gQ2VwaEZTIGFjY2Vzc2VkIGNvbmN1cnJlbnRseSB2aWEgU2FtYmEg
YW5kIE5GUywgYm90aCBiYWNrZWQgYnkgbGliY2VwaGZzLgo+Cj4gSeKAmW0gcnVubmluZyBhIENl
cGhGUyBjbHVzdGVyIHdpdGggYm90aCBTYW1iYSBhbmQgTkZTLUdhbmVzaGEgc2VydmljZXMuCj4g
QWxsIGNsaWVudHMgKFNhbWJhIGFuZCBORlMpIHVzZSBsaWJjZXBoZnMgYXMgdGhlIHVuZGVybHlp
bmcgQ2VwaEZTIG1vdW50Cj4gbWVjaGFuaXNtLiBNeSBnb2FsIGlzIHRvIHZlcmlmeSBob3cgZmls
ZSBsb2NraW5nIGJlaGF2ZXMgYWNyb3NzIHByb3RvY29scwo+IChTTUIgYW5kIE5GUykgYW5kIHdo
ZXRoZXIgUE9TSVggbG9jayBpbnRlcm9wZXJhYmlsaXR5IGlzIG1haW50YWluZWQuCj4KPiBDZXBo
IHZlcnNpb246IDE5LjIuMgo+IFNhbWJhIHZlcnNpb246IDQuMjAuNwo+IEdhbmVzaGEgdmVyc2lv
bjogVjUuNQo+ICJwb3NpeCBsb2NraW5nID0geWVzIiBpcyB0b2dnbGVkIGluIFNhbWJhCj4KPiBG
b3IgZWFjaCBjb21iaW5hdGlvbiBvZiBtb3VudCB0eXBlIGFuZCBwb3NpeCBsb2NraW5nIHNldHRp
bmcgaW4gU2FtYmEsIHdlIHRlc3Q6Cj4gMS4gZmxvY2soKS9mY250bCgpIGZyb20gTkZTIGFuZCBT
YW1iYSBjbGllbnRzLgo+IDIuIFdyaXRlIGF0dGVtcHRzIGZyb20gdGhlIG90aGVyIHNpZGUgKGUu
Zy4sIE5GUyBmbG9jaywgdGhlbiBTYW1iYSB3cml0ZSkuCj4KPiBBLiBTYW1iYSB3aXRoIGxpYmNl
cGhmcyArIHBvc2l4IGxvY2tpbmcgPSB5ZXMKPiAtIHNhbWJhIGZsb2NrKCkvZmNudGwoKSwgc2Ft
YmEgd3JpdGUoKSAtPiBwZXJtaXNzaW9uIGRlbmllZCAoZXhwZWN0ZWQpCj4gLSBuZnMgZmxvY2so
KS9mY250bCgpLCAgc2FtYmEgd3JpdGUoKSAtPiB3cml0ZSBzdWNjZWVkcyAodW5leHBlY3RlZCkK
PiAtIHNhbWJhIGZsb2NrKCkvZmNudGwoKSwgbmZzIHdyaXRlKCkgLT4gd3JpdGUgc3VjY2VlZHMg
KGV4cGVjdGVkKQo+IC0gbmZzIGZsb2NrKCkvZmNudGwoKSwgbmZzIHdyaXRlKCkgLT4gd3JpdGUg
c3VjY2VlZHMgKGV4cGVjdGVkKQo+Cj4gQi4gU2FtYmEgd2l0aCBsaWJjZXBoZnMgKyBwb3NpeCBs
b2NraW5nID0gbm8KPiAtIHNhbWJhIGZsb2NrKCkvZmNudGwoKSwgc2FtYmEgd3JpdGUoKSAtPiBw
ZXJtaXNzaW9uIGRlbmllZCAoZXhwZWN0ZWQpCj4gLSBuZnMgZmxvY2soKS9mY250bCgpLCAgc2Ft
YmEgd3JpdGUoKSAtPiB3cml0ZSBzdWNjZWVkcyAoZXhwZWN0ZWQpCj4gLSBzYW1iYSBmbG9jaygp
L2ZjbnRsKCksIG5mcyB3cml0ZSgpIC0+IHdyaXRlIHN1Y2NlZWRzIChleHBlY3RlZCkKPiAtIG5m
cyBmbG9jaygpL2ZjbnRsKCksIG5mcyB3cml0ZSgpIC0+IHdyaXRlIHN1Y2NlZWRzIChleHBlY3Rl
ZCkKPgo+IFdlIGV4cGVjdGVkIHRoYXQgaWYgInBvc2l4IGxvY2tpbmcgPSB5ZXMiLCBsb2NrcyBv
YnRhaW5lZCB2aWEgTkZTICh2aWEgZmNudGwKPiBvciBmbG9jaykgd291bGQgYmUgcmVzcGVjdGVk
IGJ5IFNhbWJhIGFzIFBPU0lYIGxvY2tzLCBidXQgaW4gY2FzZSBBLCB0aGV5IGFyZQo+IHNlZW1p
bmdseSBpZ25vcmVkLgo+Cj4gT24gdGhlIG90aGVyIGhhbmQsIHVzaW5nIGNlcGgga2VybmVsIG1v
dW50IGZvciBTYW1iYSAoaW5zdGVhZCBvZiBsaWJjZXBoZnMpCj4gcmVzcGVjdCBORlMtc2lkZSBs
b2NrcyB3aGVuICJwb3NpeCBsb2NraW5nID0geWVzIi4gKGRlbnkgd3JpdGUgd2hlbiBORlMgb2J0
YWluCj4gZmxvY2svZmNudGwgbG9ja3MpCj4KPiBNeSBxdWVzdGlvbnMgYXJlOgo+Cj4gMS4gSXMg
dGhpcyBiZWhhdmlvciBleHBlY3RlZCB3aXRoIGxpYmNlcGhmcz8KPiAyLiBBcmUgdGhlcmUga25v
d24gbGltaXRhdGlvbnMgd2hlbiBtaXhpbmcgY2VwaGZzIHVzZSBhY3Jvc3MgcHJvdG9jb2xzPwo+
IDMuIElzIHRoZXJlIGEgcmVjb21tZW5kZWQgcHJhY3RpY2UgZm9yIGV4cG9ydGluZyBjZXBoZnMg
dm9sdW1lcyBieSBTYW1iYSBhbmQKPiBORlMgc2ltdWx0YW5lb3VzbHk/Cj4KPiBBbnkgY29tbWVu
dHMgd291bGQgYmUgZ3JlYXRseSBhcHByZWNpYXRlZCwgYW5kIHBsZWFzZSBsZXQgbWUga25vdyBp
ZiBhbnkKPiBhZGRpdGlvbmFsIGxvZ3Mgb3IgdGVzdCBjb2RlIHdvdWxkIGJlIGhlbHBmdWwuCj4K
PiBUaGFua3MsCj4gRnJhbmsKCg==

