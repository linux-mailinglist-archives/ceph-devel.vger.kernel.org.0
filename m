Return-Path: <ceph-devel+bounces-3270-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7FCAAFB092
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Jul 2025 11:59:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A775188CA0D
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Jul 2025 10:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05F36289358;
	Mon,  7 Jul 2025 09:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b="LKf4oECG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11023118.outbound.protection.outlook.com [52.101.127.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A104288CBE
	for <ceph-devel@vger.kernel.org>; Mon,  7 Jul 2025 09:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751882382; cv=fail; b=hxLN+JImFTc2dC1k3o7EebUWPUkCQN9T/Om+baqgTqmimEFJb3AKaJSijKavlsEeG5mfDe1RKMlSpUyUIHNNsa38svZoYg0T7pM7FR9KUFxR+D8UL1h+JuhqQCCQUmSxD7/CWneuyHPdhHThDRjwlCUqTzauiVnEuKBsu4B4mD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751882382; c=relaxed/simple;
	bh=FbTrfiS5zC5Nf+WXxGFyTXWqvPL1Jn0rEXO2mdz+QII=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=S4OUL5QZMv1ESgCDWTt6+C7hWQR8jQBJb4fwFkA4qCR3jX6wH8/3ZXjabdM0kfKJ8xP50VbvuWGItXPdbxpziS9HElLPRHYuueSbVdRG+DGV7gyJRWLq4OuZvAM/9DRFSkAtEEIvRa1Yr7IHbMyfA49JtKjNkhFqpgcT/7lVTk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com; spf=pass smtp.mailfrom=qnap.com; dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b=LKf4oECG; arc=fail smtp.client-ip=52.101.127.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qnap.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XHuOGhsc6tIf3nK0Yu4rvSkWn5xA7/ffjGzepImoZVWn5EMte1k4fgK/6Yg1mamHJ8x5PjLMLAXsdqutVysbPHIA6fMMm9RuXSYU+iw3ulCKC2Hc+dFc0leIpO9OxMy1qqYLFYSFTz+vyNdk3WjRNN7MRi03MmLyidPJdn28N1hWgVnB+uocLq7v6uW1obRNTVSd7OoKb8OnyLX70FGqdTSrOBV9mgh4Y20Nc1WzmDHuYJv8E2GUiTqjHZZBb0cPORYv7Ha6mbQT9Lti+fpyELymgJV0BFrD12X8MORjy7gYEwbRgNwUGqk6UyoflR7hcHxvLN2Z9mmjeRub4a58iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FbTrfiS5zC5Nf+WXxGFyTXWqvPL1Jn0rEXO2mdz+QII=;
 b=P3q2Wg75tlloZWSurOzTE+wPvLKUMYU8kbuN0swLerERn2pqwTvo5br8WkgB+D5pH9ntzvE32AlGyZRHo02tdrtqC+fDjWKjrzp6XPMSv+INKZFhk+9CqHDcmw7pjutOw+htaj9keb4+uu18EW7QHpXUIu0bzlXnqHAISfHlTZw0TLrdHvE6nMjn5nYXE4NFXRbWa85/liPi23pQzREiQmd3u0Em714LZ6pxGGWU3BB3bCqqBtY69TaVVhIvQlsvQr/QjW4yxdT9RWaChyW6wPcQp1/k4I1k1ut3jrcloVGgANtPsI0D3RgvJVYJhSoVbaq0V7KWmCSl3nxrlperSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qnap.com; dmarc=pass action=none header.from=qnap.com;
 dkim=pass header.d=qnap.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qnap.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbTrfiS5zC5Nf+WXxGFyTXWqvPL1Jn0rEXO2mdz+QII=;
 b=LKf4oECGXu4SEFweMoqWnyQ21iPNwxGJDL7veTAy+pn4BXxY1j6uQxlrCrjDNTWsZBHw2asLGfndfutBN2fnT28na213zDJP4WRRD+05gKgcTqfv7WWMR6lZTna4ykLwPunDZprlkdvb5iCJ3Z1SWwSa3JLTk9Z8MaXRhs69QtsrjCAx0UIYRSE4EPw8aQKi4sisSaCraIpveMsYCF1N6saM4qH5E2n3y2oi1vu3mTE2jQyExO31vSTgii+8aaLVBnhFjk1OwInlwEAm2Kt1Zb9ZxVduPYSv5WZ850BziRS2W6VUKmSJ+vHd+USo+ymHqr4pzQjq+3XTvUhuZDhVvg==
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com (2603:1096:101:ef::7)
 by SI6PR04MB8222.apcprd04.prod.outlook.com (2603:1096:4:240::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Mon, 7 Jul
 2025 09:59:32 +0000
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::8cc1:55c0:addb:f440]) by SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::8cc1:55c0:addb:f440%5]) with mapi id 15.20.8901.021; Mon, 7 Jul 2025
 09:59:32 +0000
From: =?big5?B?RnJhbmsgSHNpYW8gv72qa6vF?= <frankhsiao@qnap.com>
To: Ceph Development <ceph-devel@vger.kernel.org>
Subject: [RFC] Different flock/fcntl locking behaviors via libcephfs and
 cephfs kernel client
Thread-Topic: [RFC] Different flock/fcntl locking behaviors via libcephfs and
 cephfs kernel client
Thread-Index: AQHb5z8sUQOBykmKmEixSISAUEbQMg==
Date: Mon, 7 Jul 2025 09:59:32 +0000
Message-ID:
 <SEZPR04MB69722E22D60977F94BD6E875B745A@SEZPR04MB6972.apcprd04.prod.outlook.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=qnap.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR04MB6972:EE_|SI6PR04MB8222:EE_
x-ms-office365-filtering-correlation-id: dcda77c0-bce8-4bea-8602-08ddbd3cf8bc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?big5?B?NjdTbFMvQjZNRnBMZjFoM3ovNTRtdkl0S21KeHFlV3VPOE1NQmp6WnpuenhrdG4v?=
 =?big5?B?ZTRMTnFxYUxEeU1ITUQzTjFSNEY3d2UxcGNCNmMvRElqVHlHaUFiMDF3Slo2dCtt?=
 =?big5?B?Z3c0RU1EUk5rbzdlSS9EWjAwQlB2amRvM3N2dzdXcVdDRnduVlZBVng3NFdhaGZ6?=
 =?big5?B?Q3UrYXNZZXNyS2VieFpSRWtsRUpMK3FtNG44RGx5SnM5c1U5c1FIZDQvUmo0c2tL?=
 =?big5?B?Z0JoOGVCbjJxVTF0Y2ptTXo4QlNBb25jSXZhSDMvMWtJeUhOSFVaZTlpZC9kQ21n?=
 =?big5?B?UFVaQnJ1ZGhLRnNsb1VxQ241aVFkMWJUSFNnYnRiUFJTOGJGTlp1K3JxbjVhOUJR?=
 =?big5?B?L25kZkRlaVFqcFBXamlEZTdEK0JMMDlEalBMTjNmMlB2STlLMHhBNVd5VHRHS1ZX?=
 =?big5?B?S08zaGFNSFpVUWJ5NEtGYndvWlQzOFZDUGhDUllBMjlvY0ZNRlh4VHY5MzZ6VmtW?=
 =?big5?B?UExRYUIwU09sdHV2bEI2QXZ4aldWOEJSeVdBNEd5b2ErMzZFT0pWT2hmZGQ2VnJ0?=
 =?big5?B?VXN3U3ZjOFcxNC9PQ3MrOE9rQmF4RGM0b09nMlNzRkdhRTNUZm5UMkpyY05iTEtN?=
 =?big5?B?cFhWQ2ZCZUVDYlVrOUZnQVRJdXFUVVdMME1HZ3kxSGlVZGtQcGFORDFYZys1dTFF?=
 =?big5?B?U1RMSzdFclVsUE51RFVoR3JGN3dNNmlkVC80WTZsYkFTUnEvQkM0eXNJZFJzTUV4?=
 =?big5?B?UVZMamhtOWN5RjU1dlFyQlptRDk1djhVTXMweTlWTndTcEViTnZoTmMrWlR3Q08y?=
 =?big5?B?MTc1QVUwRDNXRmk1NG0yNmdseXgrTVZjTXMvcXZ6RjVtMkRyc3RRUWdvNk5KQUx1?=
 =?big5?B?OVEwRktzTnZTLzNjVkhVRllXTnBINStqRE5xNi9jdWJsSmdJdkFRZnNubG44ZUlW?=
 =?big5?B?YnRxSklJWEJ4cG9OUE4vTDk3M0hwd1FzRlI2aGNYZTdjSkdjM2k1eWRQMURZR1Yz?=
 =?big5?B?Ulg3TjY3L1MzQU9aT0x0SVFqSGZlY1pXdTVLeHVaUlZ5ZXZJK1NNa3VNaHBkYnBo?=
 =?big5?B?a0xWelgxOTRGRnVEVGEzMTVkc3RkR1VybGtjL1UyQnBDUzdtaVdNK1VnaC9jT1VS?=
 =?big5?B?SERoUkE3UjB1MWJGaS9aRGdiODFFYmlzNVM5SVIwL0c2T3hyL0xrcmVJMUlZd2Nu?=
 =?big5?B?QzFIWTh3WEluL1d4Uzd0dkp0VnBlSGppN2ZNTWhyMmlSUzBZb0RrWmxCeVF5bHFl?=
 =?big5?B?aHM1OUZETk54TXJMTm1kSlU5bmYrK1JVdlJQRzBCSXo2SXltZk9hRk83azFvdURK?=
 =?big5?B?RE9ZanZ0eWEvTCt2VnRJNmVVcDU1Mi94QlYrYmNHYWg2QTMwckdORmhxY0V5c2R6?=
 =?big5?B?bk55S25WamVhTUh6REFWOHlrdVEwNGdPd3dPV2dwWXdERy9vYThOYWdhVEhZczBC?=
 =?big5?B?VVU0NW8wQlNJb2dhS1RISlRCZzdQL1luSHVISEhzTXVIT1ljMTV5QVZleExaakoy?=
 =?big5?B?NERBQUdPS0NRckJoUnJFeTdhMXRzOWFtaFVFZFRyNG5Ma0J6OE5pK01hVGxZZmRr?=
 =?big5?B?M2lXd0F3SXRGU3IxTnZFVjlPQWY5QXBFRkQwOVk4UHo1UzhzbTJGbWorMTRWS0FM?=
 =?big5?B?OEdBSGJyYVF6THJkVWZGaWZjUHFJdjJCVkgycmZkYmtSZmtuSVZ1UHJGRkFURkN2?=
 =?big5?B?b2c1MGZYR0FMSXliSFgzZTVXNzNWMzhwNHZINFNsd3Exd0laVk1BNDI2Q2NuQkR3?=
 =?big5?B?K0N1WWpOUG05S2p0MlpTM2MyV3RPQ3BsYjVMM0pWcjEzb3NhTEEzNXcwU1ZzYXR5?=
 =?big5?B?OHFFZklteW1WeHhZUEliOHFsNDBEdzdCNjRaOTRtOGdyU2hSUi9FbmFGSGVXV0c3?=
 =?big5?B?dGgxSy91MHRuZnJwM1V3OU5HRGRkUG1FRytTSjVEWThMT0dkNmMycVJvTkJzOVBE?=
 =?big5?B?L3ZKY0NRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-tw;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR04MB6972.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?big5?B?aTFuY1FRWnF3aUM2SFphbUtIVTV0OUQrcFpKb2l6c1NmaFJjVXUwOWlMVEtOUmI3?=
 =?big5?B?L1JicytPU1VMb210TG9MM1QyYmVwU1FrWDl3b0F4aml6ZHNDd1dTNzdGcjNnK0NS?=
 =?big5?B?bjBkT2RCam5JRmpNY1lxN21FUktRVXRBNCtFL0V5Q1hvcE9UcHlZVndZWmVYak1t?=
 =?big5?B?L0hLL0Y5T2FPU2NnMVFkNnNPNzg1Y1NlVG1JZytaWGZzU2hwWUdsKzBIc0ZocC9s?=
 =?big5?B?cVpHNDNjakRCWllTVlJwM2s3dGRJbWFnSk50SDc1OXVCNSt2UXpuaTUxUEtPQjhV?=
 =?big5?B?d1NzRXpxR1B4eCtOWVpwRjZOUTFPdTNUQURZR2VYVWhTdUVOMUt2bjlWME8rQWsy?=
 =?big5?B?L2ZKVFFlQllNNkpPNUdGa1hDTERrR2tQU1BEdVJVNmtXOFFRN2ZjYTg4eTNaZWVq?=
 =?big5?B?WWFKZTRDd21HWE5GWmRBQjEweFMxdEZZOWl2K3JydFZWSGgzcXdZTEg5eVU3UXdG?=
 =?big5?B?M3V1dGpCOXZ3Zk40MkVsNWE5eWduMWx6ZEs2ZGdITm9wbDZwWndKQnJacWsyZzhZ?=
 =?big5?B?OTFxekQvbGVUSmw5bklWYzI5TVVhU2EwdlZ6Vy9HMENCckN2SnQ0NTJCbmVqSld5?=
 =?big5?B?S3MzRUdtYXY1Mnc3ZWhnNHlJSWdQd1ZsU1pSR052OWxmZlluUGhqWDVRYVViejhL?=
 =?big5?B?VFRBd0hKZWlUcjJVWWpaYkVLMitQL3pFNmV5czN3dlNSalFpRXAvM3I3bHQ1eEJ1?=
 =?big5?B?V0F6N2NUNzVBTlN3ZGNxdlZTK0ZEV1U0Y3JLK0VUZDZWYTdtWGp1KzNvRjZkNVZZ?=
 =?big5?B?OE1LWnkzUmdqbUdwV2VMNmpLR3JEUlJBUHJPSmVsTDJNUmU2VGN0bUh3OWZiSDYv?=
 =?big5?B?VkRrNHBOSmdtems5cGNmMTVXYnkrSFBPQTBkMU1xakRKU2JXeWpacXVBemR6d0xx?=
 =?big5?B?VmEvRGlMeitWbmd6OW9DS3ZqeTM1SUFGTHhPTjRPeXliWEZaMWRxTzhzS1JqVStj?=
 =?big5?B?d3dtMVFaV25KV3M0WTlvVE9yUVFsVi93VG42R1UyN3BtaCtFWm1iR0Vxd0lGdFFH?=
 =?big5?B?cVI0SXpJRWRTL3dhTHVHRUZuRlpqdmJTNFBnZFkyelcyT3pIWTRUa21QcHBXaWd4?=
 =?big5?B?ZC84M2ZyMHJudnh2OG5rT1pMR3VSd0g4TlV0TU9ySXBqdlQ2d2tFeE1wMXNLS21w?=
 =?big5?B?eXVWUSswdlJrOE9pbDBMQ1ZkOTBTWjQwRURTclQ0RzdXSmxmL1cvLzlyWlJ3dXlB?=
 =?big5?B?MnFWMDhaUC9sYks1RmE4VTl3MlNHOTNlaDNrV1A2eFZGQm8wQlk4Z2lUSmxNL0g0?=
 =?big5?B?MEErQ2F2MHhNMng1M0tVRzdMVi9VVGVydjNVZXkrSi90UXhCcDduSXlDRTl6Mm1G?=
 =?big5?B?NSt0aGxpSEZuRlM2N3JwMTIwelFpeFQraWxNR3d2MngxWW5GR1JoaVg2dzUxQXlD?=
 =?big5?B?RWxicWZRWC90WTJmQ0VFNGZRaWZSNFhrNnorRWJKcFl6K2M0MDU5L3ZGZ0ZUY0hB?=
 =?big5?B?Wm40TzhHV3ExS2hHbDRnT0pSczlVV1N4dyt6K3ZQakp0TXZEZ0pLbGgxYUg2akRh?=
 =?big5?B?Z1RWU0lJSlRFYTMyUWlBQjBRTVdSa2xaUE41MjRTZ3ZDc3RINFZjd2ExYWxKUTdt?=
 =?big5?B?UG14M2JJajVEU1gxMEhOSWRFYU5Nd1RhQ3NVTFNHNHZNVmRRMWc4S3pZM2JxRDls?=
 =?big5?B?OG1mWlVLMzZXMU03VnBCbFJ1d0VUZnIzRWh1ZWJWVDkvZjlOeVhTV09QL0liZDhu?=
 =?big5?B?STZBWTIwQS9nelppb3FOckRUOG5tQkwyQUR4YVZOa2l5MU8vTHBTK1F4VXBRcGVQ?=
 =?big5?B?ZDcrMDdGMmUrWmdlbm9Ya25MQmlDUVIyY0xDMFQ2Q0JydmMzZ212OW9DQWNSRXZh?=
 =?big5?B?WElRVGhzbW5iTFBxWXhnY1V4aXR3QzJGdmVVV1VCYzdiMlZDSy8xZ0c0YjBGQVB1?=
 =?big5?B?RllLTytKZ2NyVVY4VGdQRXpDZ2huc1UyY1NHU0wxNEpkc1J3U3dQbnFaK25KVmMx?=
 =?big5?Q?qAdS1Cg2HEKPkWJRXr+X+8mp5U7htwPwnQwasHh9YbU=3D?=
Content-Type: text/plain; charset="big5"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: dcda77c0-bce8-4bea-8602-08ddbd3cf8bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2025 09:59:32.4919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6eba8807-6ef0-4e31-890c-a6ecfbb98568
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a8b2FhajpBLvgXZJtumhMRf1iwlDehSCBWWpputjqUIbnRnI8yri+NqLvBAMmz43PWTQPRPuei907URLgE3VBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI6PR04MB8222

SGkgYWxsLAoKSaGmbSBlbmNvdW50ZXJpbmcgdW5leHBlY3RlZCBiZWhhdmlvciB3aGVuIHRlc3Rp
bmcgZmlsZSBsb2NraW5nIHNlbWFudGljcyBvbgpDZXBoRlMgYWNjZXNzZWQgY29uY3VycmVudGx5
IHZpYSBTYW1iYSBhbmQgTkZTLCBib3RoIGJhY2tlZCBieSBsaWJjZXBoZnMuCgpJoaZtIHJ1bm5p
bmcgYSBDZXBoRlMgY2x1c3RlciB3aXRoIGJvdGggU2FtYmEgYW5kIE5GUy1HYW5lc2hhIHNlcnZp
Y2VzLgpBbGwgY2xpZW50cyAoU2FtYmEgYW5kIE5GUykgdXNlIGxpYmNlcGhmcyBhcyB0aGUgdW5k
ZXJseWluZyBDZXBoRlMgbW91bnQKbWVjaGFuaXNtLiBNeSBnb2FsIGlzIHRvIHZlcmlmeSBob3cg
ZmlsZSBsb2NraW5nIGJlaGF2ZXMgYWNyb3NzIHByb3RvY29scwooU01CIGFuZCBORlMpIGFuZCB3
aGV0aGVyIFBPU0lYIGxvY2sgaW50ZXJvcGVyYWJpbGl0eSBpcyBtYWludGFpbmVkLgoKQ2VwaCB2
ZXJzaW9uOiAxOS4yLjIKU2FtYmEgdmVyc2lvbjogNC4yMC43CkdhbmVzaGEgdmVyc2lvbjogVjUu
NQoicG9zaXggbG9ja2luZyA9IHllcyIgaXMgdG9nZ2xlZCBpbiBTYW1iYQoKRm9yIGVhY2ggY29t
YmluYXRpb24gb2YgbW91bnQgdHlwZSBhbmQgcG9zaXggbG9ja2luZyBzZXR0aW5nIGluIFNhbWJh
LCB3ZSB0ZXN0OgoxLiBmbG9jaygpL2ZjbnRsKCkgZnJvbSBORlMgYW5kIFNhbWJhIGNsaWVudHMu
CjIuIFdyaXRlIGF0dGVtcHRzIGZyb20gdGhlIG90aGVyIHNpZGUgKGUuZy4sIE5GUyBmbG9jaywg
dGhlbiBTYW1iYSB3cml0ZSkuCgpBLiBTYW1iYSB3aXRoIGxpYmNlcGhmcyArIHBvc2l4IGxvY2tp
bmcgPSB5ZXMKLSBzYW1iYSBmbG9jaygpL2ZjbnRsKCksIHNhbWJhIHdyaXRlKCkgLT4gcGVybWlz
c2lvbiBkZW5pZWQgKGV4cGVjdGVkKQotIG5mcyBmbG9jaygpL2ZjbnRsKCksICBzYW1iYSB3cml0
ZSgpIC0+IHdyaXRlIHN1Y2NlZWRzICh1bmV4cGVjdGVkKQotIHNhbWJhIGZsb2NrKCkvZmNudGwo
KSwgbmZzIHdyaXRlKCkgLT4gd3JpdGUgc3VjY2VlZHMgKGV4cGVjdGVkKQotIG5mcyBmbG9jaygp
L2ZjbnRsKCksIG5mcyB3cml0ZSgpIC0+IHdyaXRlIHN1Y2NlZWRzIChleHBlY3RlZCkKCkIuIFNh
bWJhIHdpdGggbGliY2VwaGZzICsgcG9zaXggbG9ja2luZyA9IG5vCi0gc2FtYmEgZmxvY2soKS9m
Y250bCgpLCBzYW1iYSB3cml0ZSgpIC0+IHBlcm1pc3Npb24gZGVuaWVkIChleHBlY3RlZCkKLSBu
ZnMgZmxvY2soKS9mY250bCgpLCAgc2FtYmEgd3JpdGUoKSAtPiB3cml0ZSBzdWNjZWVkcyAoZXhw
ZWN0ZWQpCi0gc2FtYmEgZmxvY2soKS9mY250bCgpLCBuZnMgd3JpdGUoKSAtPiB3cml0ZSBzdWNj
ZWVkcyAoZXhwZWN0ZWQpCi0gbmZzIGZsb2NrKCkvZmNudGwoKSwgbmZzIHdyaXRlKCkgLT4gd3Jp
dGUgc3VjY2VlZHMgKGV4cGVjdGVkKQoKV2UgZXhwZWN0ZWQgdGhhdCBpZiAicG9zaXggbG9ja2lu
ZyA9IHllcyIsIGxvY2tzIG9idGFpbmVkIHZpYSBORlMgKHZpYSBmY250bApvciBmbG9jaykgd291
bGQgYmUgcmVzcGVjdGVkIGJ5IFNhbWJhIGFzIFBPU0lYIGxvY2tzLCBidXQgaW4gY2FzZSBBLCB0
aGV5IGFyZQpzZWVtaW5nbHkgaWdub3JlZC4KCk9uIHRoZSBvdGhlciBoYW5kLCB1c2luZyBjZXBo
IGtlcm5lbCBtb3VudCBmb3IgU2FtYmEgKGluc3RlYWQgb2YgbGliY2VwaGZzKQpyZXNwZWN0IE5G
Uy1zaWRlIGxvY2tzIHdoZW4gInBvc2l4IGxvY2tpbmcgPSB5ZXMiLiAoZGVueSB3cml0ZSB3aGVu
IE5GUyBvYnRhaW4KZmxvY2svZmNudGwgbG9ja3MpCgpNeSBxdWVzdGlvbnMgYXJlOgoKMS4gSXMg
dGhpcyBiZWhhdmlvciBleHBlY3RlZCB3aXRoIGxpYmNlcGhmcz8KMi4gQXJlIHRoZXJlIGtub3du
IGxpbWl0YXRpb25zIHdoZW4gbWl4aW5nIGNlcGhmcyB1c2UgYWNyb3NzIHByb3RvY29scz8KMy4g
SXMgdGhlcmUgYSByZWNvbW1lbmRlZCBwcmFjdGljZSBmb3IgZXhwb3J0aW5nIGNlcGhmcyB2b2x1
bWVzIGJ5IFNhbWJhIGFuZApORlMgc2ltdWx0YW5lb3VzbHk/CgpBbnkgY29tbWVudHMgd291bGQg
YmUgZ3JlYXRseSBhcHByZWNpYXRlZCwgYW5kIHBsZWFzZSBsZXQgbWUga25vdyBpZiBhbnkKYWRk
aXRpb25hbCBsb2dzIG9yIHRlc3QgY29kZSB3b3VsZCBiZSBoZWxwZnVsLgoKVGhhbmtzLApGcmFu
aw==

