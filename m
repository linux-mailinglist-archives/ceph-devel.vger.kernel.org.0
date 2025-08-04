Return-Path: <ceph-devel+bounces-3353-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 02D7FB1AA94
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Aug 2025 23:58:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 922BA189E034
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Aug 2025 21:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E8B239E7F;
	Mon,  4 Aug 2025 21:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LXsyiuID"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB942376F7;
	Mon,  4 Aug 2025 21:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754344720; cv=fail; b=VroYTf7qRBIpPn6zIymH6XDCHiXtlFI4HFUn2x6/GtiOyfgqEnjxyDGr5eGVQi/7YujXX4pQ4pJcG9D89I/Uuhn09Xx4qQSl4Wopy7iT/lkExKpxofmf6f1gGmAzQcplkdljIkL6aj4eKcQGs5MJ3tYNGneEVPuLGjDsgtErrgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754344720; c=relaxed/simple;
	bh=HgQh/0nS8COEhf1wVx9+M6X5zCXnHI76mNTxDBoas64=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=epdilZjZLTgjuHsIOKg/oHlwzhvQXoKjdqBCHZDrRwf8RrmwCvOWsKW/h4DiwjaKaB1sDfB2Rsac1TsxSZUqFHhbpYDXcubIyzlMjDEmb9enwCtnEBmJ3dpqzQg8PSvJAaAcJfXMUmoDAnsiXc2jKcSbQg8e7j2VLEtuX7TCmGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LXsyiuID; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 574KTRHs029114;
	Mon, 4 Aug 2025 21:58:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=HgQh/0nS8COEhf1wVx9+M6X5zCXnHI76mNTxDBoas64=; b=LXsyiuID
	IqsKBOeXpee0mG+NC6/hJ8lPa9PxkiHEhEPeJajRkGxt1OGOu1kiz/Fk1GIs5t+m
	tGLF7KRnIhj0fz7ndnKJOXHl9rPylfeBHs1JOBXVwFllYL1/4cG+wWy+vZADmjtu
	xDHDpKPwoy2Jxe2s0y9O2Y4DuzCnubZBI4W2zM2srkl8kISMzCyQrZrZaOpGz62d
	DNs/ed+EPTftT83Iqp7IeiBrh2o89ibX6CrYTJyYt5G1UNP7ZtOTHN8bJOQTczjA
	6yAtBKKYFx4VKhcHfMDC6v8NlYvQa9gNcHcWlq6mJ46xjI5TEeIkN38RKa7WsBlY
	RfKbU9FknZze8Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 489ab3k7jw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Aug 2025 21:58:36 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 574LwZCq012092;
	Mon, 4 Aug 2025 21:58:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 489ab3k7js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Aug 2025 21:58:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gCa0MMbUoRqbTTGj38bLxbLZhr4DfmsNnv2JfVt0Ml4u1PIF8D7tNkL+hglzttgyACETuIbz/11XRfWAVGfJizw73Gz1qrJa3p83PngJ6IvoRHPseuzaVrGGYR8iIutYCVJVA7AbxTjhmUFDYu/6kQWW3lZIc+z3chdaGDKcKT37GwcTZ8/KSPxxipa9i00WtUVxyG2IUm3t5R+4fJZKM+BUV07eBH0kzopKyfTEUZUlOmRj6DfG73DK34c/HWjAYinDQ1W91Gpv+ekLamW9xWtlFCR0LHVysQ8DApSrWGPa+W/Oaq7G6FWPLyYeh4OAqdKh3LR8QLP9Rs1/HpuW6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgQh/0nS8COEhf1wVx9+M6X5zCXnHI76mNTxDBoas64=;
 b=g0jfJ/1K5W/K1ArDumtBjGBSsR65LVz4SmGrFNLNt0AfK983CFimIypldlT9si5q5EhjyMYv0uK5/83T3Fn+AW8xdBHmmfQbFaUMKKxPrlocIv3MNIwVPm4Z7DkRa9TfiUst7jxhrB7TfyEd3QdZ2VVM5KL4mcAVZu/LANf8sUvn/veDFZgqxE7MC51lqzpaaut58sY5MYkqh2q1pakNEa3VuW31/uClkkfZvfb/IXWFwDIO2dkky1xix33GjkEsq5bndjdhg7kXvgB/2oGYbOnTxWgoKiT0Nu37c6DaRl5pQUPYuzmyQHlvgGhxmFtYR1d731zjzDLhBBB58gl77A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DS4PPFCAA75D67C.namprd15.prod.outlook.com (2603:10b6:f:fc00::9bb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 21:58:33 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 21:58:33 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH v2 2/2] ceph: fix client race condition where
 r_parent becomes stale before sending message
Thread-Index: AQHcBSaKOR4RNNlcLka3w+v5u7d1jrRTC4gA
Date: Mon, 4 Aug 2025 21:58:33 +0000
Message-ID: <0d4ffc45c292005a65ca244b013a313f7d35e607.camel@ibm.com>
References: <20250804095942.2167541-1-amarkuze@redhat.com>
	 <20250804095942.2167541-3-amarkuze@redhat.com>
In-Reply-To: <20250804095942.2167541-3-amarkuze@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DS4PPFCAA75D67C:EE_
x-ms-office365-filtering-correlation-id: bb0ab668-4e00-4199-3def-08ddd3a20e16
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RHlQTXBuWU9RdUJKOTNTYys1eGY1VGdLckpHZDN1Rnl1ejJ2OEhhcjJyY2Vo?=
 =?utf-8?B?Nkk5bER3ZlhmSnhLU0ZqejBrcEFXYWcrb2IvM0xZNDRObnprblJ6ancxSVhC?=
 =?utf-8?B?b0dFOTdMVmZ3Y0p5L1IrcDduYkI4R1pZeG1semlYZHFISFBtSTl2MHNidWNk?=
 =?utf-8?B?LzVaK3RVNmgxVzJ6bmhqVk5OdTJ4a2w2MzFWeHRYMVhQalgvMTBjY0tMQmhO?=
 =?utf-8?B?dWxVbVBGTlhmQ0dQaWJVWjE1b1l3alRzOWZLZ0d5blJTcFg3S1MyODFOUEpH?=
 =?utf-8?B?NmVERkFZL3dmeldTVjZCNzVoNEtsTDU5eFZpV1RtWnAxekRuRVVWSzVSL25y?=
 =?utf-8?B?TTdCTXRqankwR3JSR1VkTDQ5RzZHckc0bGVKaHI5TGtnbUptVjBiaTRHVm1N?=
 =?utf-8?B?MGVPeDUrWEJxVlhTekFMcUpiT1V5Y0JWZXhYUXhvZjYzazBxbDk2clVQQzJI?=
 =?utf-8?B?elIvSGEzSHB6Q1VQaktXcjZYMVhtam5qcW9GanVGRE5WZEo3ZkRBRng5Yjc1?=
 =?utf-8?B?R3FLRmlvMjRBMnVDa1BNbkMrbVNBOEZxVkNvWEtJYnhjV1ZBblR6N3RsR2Jx?=
 =?utf-8?B?RGxwek5HbW1jS1VKNERMNDFLRW5TR2VpbFF6SWwxQkIzbTArd3lvbTNqWEpU?=
 =?utf-8?B?V0hLMjVoN2dIYzY3YURmRUcwU2xNLzR0WG9jeDg2dUlXZ0ZpSUpNS2dmNllJ?=
 =?utf-8?B?MkM3bi8zVkhJNzhrRkNzL3p2WEo0WUxWeVdjSllsMWJyR2toUGFTSlQrdVVK?=
 =?utf-8?B?T3FrVzlqb2xldGk0UG5hQ1o3bVd6R2krZGQvVFl2VHhWdU9BVnFUb1IvSXdM?=
 =?utf-8?B?anFxbG9XN3V3bThkNzdRRkJsWGR3NkxBZE9aTlpyaERNTEtFWUJqN0N3YUIv?=
 =?utf-8?B?SVg5c2dHMU42SC9ETks3c0hUT0VHOTgyWVQvc3hrQU83UDdJR1ZzY2FmWk9Z?=
 =?utf-8?B?OHZ4ZUxXVVVHeFJJY1BiQldxWk1WemxneGU3SDVyUjd2NDF1UTJBcWErMmF2?=
 =?utf-8?B?L3JwcnFadlhQcXcrWFNSbzB4L3RxY3JkQWFSSlBkcGYwWlNldjNQVkRHOUV1?=
 =?utf-8?B?T2dPNHhpQUdPU1pzamx5dEZ1b1A5UURvbFRFVFZXaW84Uy91UTRrUlcrZkJo?=
 =?utf-8?B?OEFSVmt0cWg3T1RsRy9uSVNHVGplTWE2aGY1cWhzNmVpVGVYV2FDaHRkQVBF?=
 =?utf-8?B?UkV5SE03Yzl5N1FvdzlsNTFkbHowUlhEd01nbCtKaSsvWDBqT2ZNMlVRdS9U?=
 =?utf-8?B?enpSK2UyTkxjWENsRlZCdHc1Q3FmbTE4LzZRN1Z1MVlNZ05hQkRmU05TdE5E?=
 =?utf-8?B?SDFaYnppT0k4dDlYVkxNWmR5cFM0UjZJSkhqWjFPQzNnalNLY0ZaUU0xZFFh?=
 =?utf-8?B?ekxXZldHYStiR2pCenBucGJVdDM2MmdObmRSRW9EM3JnbHZmTTNyQ1hYS0NR?=
 =?utf-8?B?M2lvWXZicDRmYWExYStTVytaSEovWnVaamdIa2IrOFJlZ1FGRHdENkZNNGpH?=
 =?utf-8?B?UE92djF6YThaa2pPTE5uelg3dkhwcHZOZFd3TmNJUkN4L1dKTHQ0dHJobzBm?=
 =?utf-8?B?RTZBSnhCMjMyMFlpZ1NDL2xmalNsV1BSYzJsWnBxR0tUNUhkSlQzMDVEU3Zy?=
 =?utf-8?B?ZzhCNk1hdndYTGh6SEZQbFZZOEIzb2JZRnZDZFJ2TXVhMWxtRTFZNzB4cmZT?=
 =?utf-8?B?cFJ6SzdDM2VLOFRKQjZITUVNQXNONS9oQWVvU2d3VGdJdS9uV2xjQS9Lcldw?=
 =?utf-8?B?SUE2UW5ZU2JqNjljL3F5TjBqajJDcFpaNE41N2Fia0U2aUs5S1gvZnBIaVJm?=
 =?utf-8?B?OFFSd0xHNjA3K3FlanhlYzBQMjlYLy8rekJwdSsrZjNRbjBSaGtMaHNnbk5o?=
 =?utf-8?B?RUZpeUlmdXdyY0IwNmJKNDZERWdsZTVxRkVUU3pFRThXeGlucUFubXJNeWxj?=
 =?utf-8?B?cm9VVUNVVlVFRWI5R2VLc3pqNEdlL1hwTEdkb3VYcklQTHBlZHY0NXdrckR6?=
 =?utf-8?Q?mgpEQN3nHI+dMir2vSoYtgTUybKTzE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S1FsNDZZMWw3R0ZFbytFczY2aTN4SGdlSGZpa2pPTjlURmtvMXJaQ08xSFgv?=
 =?utf-8?B?V1NWOCs0SjB6YjU0bjZ1SHBLTDBoYUgvc0d1MFl5Tm51OFlQNVl0RlhrR09l?=
 =?utf-8?B?OHhzUFJ3TkIvZFozNGhpNXRRVTVLcnM1SVhvZ2FBK1Bla2JWbllkejZiOW9z?=
 =?utf-8?B?L1JlWjUvNi9qeGE4RTBNdG1adk45VFQxMjZldVZ3b0RyRTFFQzlXOW9VZ1lJ?=
 =?utf-8?B?dG1wZVRMOWpPTjlEQ1ZGejhPNnltOHN2bjRrTlpzZnAxOFMwUHljcTNFUG9D?=
 =?utf-8?B?ZnVxNHNTeWJ0YWZwdXExaWF0cUhXWFFQZGR2RWR5WjlWZVdPVCtlRituOW51?=
 =?utf-8?B?bllzOGlPckl5Z0FadWlvT2pBQnFQWmFQTDV3QmNEMi9PdDdoSitlM256Ulo1?=
 =?utf-8?B?ckE0ZDJwWWNFbERjcDNiSHFNWlc4aTk3VmhVcXZpNUN2YXZCdGNlZmloZ1Z4?=
 =?utf-8?B?dzNFdEhwMzVlZEZDSEo4UC9TODFpZks0WWhucUN4d2NXYW1HT1ZvelF3RE5z?=
 =?utf-8?B?bm1STld4eko2ek1nKzgyNjIyb1JGWW1QeHo5OUJvTENpbkpXWGtOcjBKRHdu?=
 =?utf-8?B?TWcvWHRhZVNwM1YvTHEyQnBFN2c3b0JrN3hlTzJpWXBzVGcrYXJpWTJCd3dx?=
 =?utf-8?B?TkQ0aDVOd2w0cURKdnkwb1NNRG1Ubnp2NExKWHdBVU9vTERIRkdydi9CTjdh?=
 =?utf-8?B?STk1S2xVWkgyTDQ0YUxhUWxqM3FWN3N0WGFRcGJtYUxaM0ZDb3ZxZmlnU3Vq?=
 =?utf-8?B?ODQ1ZWVwK29uaUZKVmRCSERCL1JIL3QrY2lad3ZBY2hGOW1sUFVkUHd3U2Fu?=
 =?utf-8?B?UUY1THdhU0ZCMlNnSUdmb0dMV0hPOG0wRzI2dWFBTTF3aWkydGxIUyt0aU5Z?=
 =?utf-8?B?V0I0SkxqV1Z3SDJwYTcrN3ZETjNucGpNZlVQZGttZTNNSEdxV3JQTlpFaFZw?=
 =?utf-8?B?NWFydUFFbDdJTEtjKzlpTGxxamR2UVRDcUpnKzYwUTV2ZTNjKzJMcXU5TDZO?=
 =?utf-8?B?MkRpZ0RmYnhRRDBZVUY2T2ZHVklBRmptRTNBeEl1ODE1TlVjWjFxakwvTkhs?=
 =?utf-8?B?aEhSSUpqZ09mQ1ViMHROS2kwa3Fkd2t4QU4weTVybVdwdTFDdm11YS93dW5H?=
 =?utf-8?B?ZTZzWVJhKytwc1JMNUNXRHlaZ253STBWbXVZaFdqS0VOWnZGQjRENytESE5J?=
 =?utf-8?B?UUNEZmJJdEhaMFEydXMrYmx5WDdNTUNLQkhYMVFML0xTMWdnRllrQWFCakdQ?=
 =?utf-8?B?a1I5OXRNK2MvdEM0RDlzM1FaVzRGcHNqdzYzU2hwUTVXZlQ0NDlCK25Cc1Zw?=
 =?utf-8?B?NzE2WTFDa2pmc3lqRjNuQmNtQnBwcTFvV0Nnckd0T0RkNFB2RnA0b2xEV2pz?=
 =?utf-8?B?dWRJYTVqdENyTWhOdHJSNTBNYk1ianpjRlVCRjFTMzZ5TERvbXNyUExIUFZP?=
 =?utf-8?B?VEEvb3YvU1RYRVRzenhkOVRScU0rck5zTGwrdUpzL2M3dzliSUlSck9HWGZE?=
 =?utf-8?B?T0FwVTErdWZ4dlhXdTJEaHZHR3ZhNXM3cTRBek4zTDBtLzNRZGcvRWplWHpG?=
 =?utf-8?B?OWhLSzNJdWx2MVZCSHRGamVCRXNQM3ltaWprcjJSb2RjTTVORW5LYVlQdVM3?=
 =?utf-8?B?R2ZRVVVNOVg4cUQvWGtHY0FpRldQdVZRNElXVTg0RlE1b05Zejc1cEM5STFi?=
 =?utf-8?B?aEdmZ1Jsc0ZQWG1LbXZzeWFkZXVHbGlYM09VcTNYVE40UEtlTFp3MWV4WHpJ?=
 =?utf-8?B?UTRaZVJwTmFnRjVhSURSM2xvMkV3ckNyVWQyY05kcGFrV2JXSTVZTUo2TkNk?=
 =?utf-8?B?MWxiVVQ0YTZ1NFo0em1qVTNvUGNqaDl6LzhlNXE4bmh4eGlja1V4bkhlYUNZ?=
 =?utf-8?B?UUNFakJuOUZla2JtckRiL2ZjNjV0MlN2endCWnlWZVc3MG50UUNMZXhLcWpU?=
 =?utf-8?B?VW9kTlVYUW1QS29NVE1xdERCUkQyUE0yTVRnRUxtQ1lKQW5PTFBrWWI4Tysw?=
 =?utf-8?B?cEZaMjk1b1VkMmJPZnF6OHB3eVVISlhTaG03YkV1U2hyMklKMVRydjFaeHNR?=
 =?utf-8?B?Z2p5NVJwY3FPUjJJdWJGdnd0T2x5UzMySUVCVjMza2RaVUJXYkM0eU9LM3Vk?=
 =?utf-8?B?S3owbkxyUnh3K25yVkZRMklUbHJtUUF1R0FLT2IvbDgxMVo3bngwRFpnQjND?=
 =?utf-8?Q?ENb9YYCihIdsPCpccYAQVyE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8069102129A9F43889F329FCA57BC3E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb0ab668-4e00-4199-3def-08ddd3a20e16
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2025 21:58:33.0467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dwaU7s3+ny1ZXyzrYS0TzTyXNG5RXHZsNS9xZw4UMoXcYIEDGvbMAsdYob0Yq7QfLn7aRh5fUTKZZGgC2l2ygQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFCAA75D67C
X-Authority-Analysis: v=2.4 cv=Z+jsHGRA c=1 sm=1 tr=0 ts=68912d0c cx=c_pps
 a=t7FPbsrzSg/TVobB0oTxVQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=IKZbrOtTXqJckMbK4qIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: GHDKWPo2dbrCH3UJL7Bm6oc1fzqbo-GR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDEzMyBTYWx0ZWRfX4D5eYpq0Mne0
 ek2YJ3EjJxVunqyT3IIKLL3Pw48E5jVuhBfagHvlC5uSsv3MRl/ilKxXuYMlbAP3KfrdE5VQh5v
 BYRBzoc3/fHyxFCy1wVRMyY2WuDP1H6AkTWBLi/2cP7Rcu9tpvtvFh2fOYhqAW4WUpFpi/cdWnR
 ySGv3MYpqkyBw/VnasNqxWQaTnjUepLvKaCsFVt41M4l3pM/pI7i3bBNSvvjFIpqNUoTGGwNYyf
 lIiL/dIfa+UbJiIJgmKnWtM3D07fp84IQYeZy9FAulfSxpycZDyvufM36RG7BJxnXkkM5O9RGhs
 cA7PnUscdMRRGIp/Hs/Vu6xmkggnYyezYbKnUczG7wqhEAvM4+0TLDTW3UEZyMujrauGJxhZvvG
 cGkrPhNcYRKV3ZY68KWADsangSp65wg6mNdEIwY70Q7Munn3RDxNPG/v+LLc8t6xvKDbiaCh
X-Proofpoint-GUID: 2i2Se90HGz6rFsrGe7OrjO7I7jDloR6L
Subject: Re:  [PATCH v2 2/2] ceph: fix client race condition where r_parent
 becomes stale before sending message
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_09,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508040133

T24gTW9uLCAyMDI1LTA4LTA0IGF0IDA5OjU5ICswMDAwLCBBbGV4IE1hcmt1emUgd3JvdGU6DQo+
IFdoZW4gdGhlIHBhcmVudCBkaXJlY3RvcnkncyBpX3J3c2VtIGlzIG5vdCBsb2NrZWQsIHJlcS0+
cl9wYXJlbnQgbWF5IGJlY29tZQ0KPiBzdGFsZSBkdWUgdG8gY29uY3VycmVudCBvcGVyYXRpb25z
IChlLmcuIHJlbmFtZSkgYmV0d2VlbiBkZW50cnkgbG9va3VwIGFuZA0KPiBtZXNzYWdlIGNyZWF0
aW9uLiBWYWxpZGF0ZSB0aGF0IHJfcGFyZW50IG1hdGNoZXMgdGhlIGVuY29kZWQgcGFyZW50IGlu
b2RlDQo+IGFuZCB1cGRhdGUgdG8gdGhlIGNvcnJlY3QgaW5vZGUgaWYgYSBtaXNtYXRjaCBpcyBk
ZXRlY3RlZC4NCj4gLS0tDQo+ICBmcy9jZXBoL2lub2RlLmMgfCA1MiArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNTAg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9jZXBo
L2lub2RlLmMgYi9mcy9jZXBoL2lub2RlLmMNCj4gaW5kZXggODE0ZjllOTY1NmEwLi43ZGE2NDhi
NWU5MDEgMTAwNjQ0DQo+IC0tLSBhL2ZzL2NlcGgvaW5vZGUuYw0KPiArKysgYi9mcy9jZXBoL2lu
b2RlLmMNCj4gQEAgLTU2LDYgKzU2LDUxIEBAIHN0YXRpYyBpbnQgY2VwaF9zZXRfaW5vX2NiKHN0
cnVjdCBpbm9kZSAqaW5vZGUsIHZvaWQgKmRhdGEpDQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+ICAN
Cj4gKy8qDQo+ICsgKiBDaGVjayBpZiB0aGUgcGFyZW50IGlub2RlIG1hdGNoZXMgdGhlIHZpbm8g
ZnJvbSBkaXJlY3RvcnkgcmVwbHkgaW5mbw0KPiArICovDQo+ICtzdGF0aWMgaW5saW5lIGJvb2wg
Y2VwaF92aW5vX21hdGNoZXNfcGFyZW50KHN0cnVjdCBpbm9kZSAqcGFyZW50LCBzdHJ1Y3QgY2Vw
aF92aW5vIHZpbm8pDQo+ICt7DQo+ICsJcmV0dXJuIGNlcGhfaW5vKHBhcmVudCkgPT0gdmluby5p
bm8gJiYgY2VwaF9zbmFwKHBhcmVudCkgPT0gdmluby5zbmFwOw0KPiArfQ0KPiArDQo+ICsvKg0K
PiArICogVmFsaWRhdGUgdGhhdCB0aGUgZGlyZWN0b3J5IGlub2RlIHJlZmVyZW5jZWQgYnkgQHJl
cS0+cl9wYXJlbnQgbWF0Y2hlcyB0aGUNCj4gKyAqIGlub2RlIG51bWJlciBhbmQgc25hcHNob3Qg
aWQgY29udGFpbmVkIGluIHRoZSByZXBseSdzIGRpcmVjdG9yeSByZWNvcmQuICBJZg0KPiArICog
dGhleSBkbyBub3QgbWF0Y2gg4oCTIHdoaWNoIGNhbiB0aGVvcmV0aWNhbGx5IGhhcHBlbiBpZiB0
aGUgcGFyZW50IGRlbnRyeSB3YXMNCj4gKyAqIG1vdmVkIGJldHdlZW4gdGhlIHRpbWUgdGhlIHJl
cXVlc3Qgd2FzIGlzc3VlZCBhbmQgdGhlIHJlcGx5IGFycml2ZWQg4oCTIGZhbGwNCj4gKyAqIGJh
Y2sgdG8gbG9va2luZyB1cCB0aGUgY29ycmVjdCBpbm9kZSBpbiB0aGUgaW5vZGUgY2FjaGUuDQo+
ICsgKg0KPiArICogQSByZWZlcmVuY2UgaXMgKmFsd2F5cyogcmV0dXJuZWQuICBDYWxsZXJzIHRo
YXQgcmVjZWl2ZSBhIGRpZmZlcmVudCBpbm9kZQ0KPiArICogdGhhbiB0aGUgb3JpZ2luYWwgQHBh
cmVudCBhcmUgcmVzcG9uc2libGUgZm9yIGRyb3BwaW5nIHRoZSBleHRyYSByZWZlcmVuY2UNCj4g
KyAqIG9uY2UgdGhlIHJlcGx5IGhhcyBiZWVuIHByb2Nlc3NlZC4NCj4gKyAqLw0KPiArc3RhdGlj
IHN0cnVjdCBpbm9kZSAqY2VwaF9nZXRfcmVwbHlfZGlyKHN0cnVjdCBzdXBlcl9ibG9jayAqc2Is
DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgaW5vZGUg
KnBhcmVudCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVj
dCBjZXBoX21kc19yZXBseV9pbmZvX3BhcnNlZCAqcmluZm8pDQo+ICt7DQo+ICsgICAgc3RydWN0
IGNlcGhfdmlubyB2aW5vOw0KPiArDQo+ICsgICAgaWYgKHVubGlrZWx5KCFyaW5mby0+ZGlyaS5p
bikpDQo+ICsgICAgICAgIHJldHVybiBwYXJlbnQ7IC8qIG5vdGhpbmcgdG8gY29tcGFyZSBhZ2Fp
bnN0ICovDQo+ICsNCj4gKyAgICAvKiBJZiB3ZSBkaWRuJ3QgaGF2ZSBhIGNhY2hlZCBwYXJlbnQg
aW5vZGUgdG8gYmVnaW4gd2l0aCwganVzdCBiYWlsIG91dC4gKi8NCj4gKyAgICBpZiAoIXBhcmVu
dCkNCj4gKyAgICAgICAgcmV0dXJuIE5VTEw7DQo+ICsNCj4gKyAgICB2aW5vLmlubyAgPSBsZTY0
X3RvX2NwdShyaW5mby0+ZGlyaS5pbi0+aW5vKTsNCj4gKyAgICB2aW5vLnNuYXAgPSBsZTY0X3Rv
X2NwdShyaW5mby0+ZGlyaS5pbi0+c25hcGlkKTsNCj4gKw0KPiArICAgIGlmIChsaWtlbHkoY2Vw
aF92aW5vX21hdGNoZXNfcGFyZW50KHBhcmVudCwgdmlubykpKQ0KPiArICAgICAgICByZXR1cm4g
cGFyZW50OyAvKiBtYXRjaGVzIOKAkyB1c2UgdGhlIG9yaWdpbmFsIHJlZmVyZW5jZSAqLw0KPiAr
DQo+ICsgICAgLyogTWlzbWF0Y2gg4oCTIHRoaXMgc2hvdWxkIGJlIHJhcmUuICBFbWl0IGEgV0FS
TiBhbmQgb2J0YWluIHRoZSBjb3JyZWN0IGlub2RlLiAqLw0KPiArICAgIFdBUk4oMSwgImNlcGg6
IHJlcGx5IGRpciBtaXNtYXRjaCAocGFyZW50IHZhbGlkICVsbHguJWxseCByZXBseSAlbGx4LiVs
bHgpXG4iLA0KPiArICAgICAgICAgY2VwaF9pbm8ocGFyZW50KSwgY2VwaF9zbmFwKHBhcmVudCks
IHZpbm8uaW5vLCB2aW5vLnNuYXApOw0KDQpJIGFtIG5vdCBjb21wbGV0ZWx5IHN1cmUgdGhhdCBJ
IGZvbGxvdyB3aHkgd2Ugd291bGQgbGlrZSB0byB1c2UgbmFtZWx5IFdBUk4oKQ0KaGVyZT8gSWYg
d2UgaGF2ZSBzb21lIGNvbmRpdGlvbiwgdGhlbiBXQVJOKCkgbG9va3MgbGlrZSBuYXR1cmFsIGNo
b2ljZS4NCk90aGVyd2lzZSwgaWYgd2UgaGF2ZSB1bmNvbmRpdGlvbmFsIHNpdHVhdGlvbiwgdGhl
biwgbWF5YmUsIHByX3dhcm4oKSB3aWxsIGJlDQpiZXR0ZXI/IFdvdWxkIHdlIGxpa2UgdG8gc2hv
dyBjYWxsIHRyYWNlIGhlcmU/DQoNCkFyZSB3ZSByZWFsbHkgc3VyZSB0aGF0IHRoaXMgbWlzbWF0
Y2ggY291bGQgYmUgdGhlIHJhcmUgY2FzZT8gT3RoZXJ3aXNlLCBjYWxsDQp0cmFjZXMgZnJvbSBt
dWx0aXBsZSB0aHJlYWRzIHdpbGwgY3JlYXRlIHRoZSByZWFsIG1lc3MgaW4gdGhlIHN5c3RlbSBs
b2cuDQoNClRoYW5rcywNClNsYXZhLg0KDQo+ICsNCj4gKyAgICByZXR1cm4gY2VwaF9nZXRfaW5v
ZGUoc2IsIHZpbm8sIE5VTEwpOw0KPiArfQ0KPiArDQo+ICAvKioNCj4gICAqIGNlcGhfbmV3X2lu
b2RlIC0gYWxsb2NhdGUgYSBuZXcgaW5vZGUgaW4gYWR2YW5jZSBvZiBhbiBleHBlY3RlZCBjcmVh
dGUNCj4gICAqIEBkaXI6IHBhcmVudCBkaXJlY3RvcnkgZm9yIG5ldyBpbm9kZQ0KPiBAQCAtMTU0
OCw4ICsxNTkzLDExIEBAIGludCBjZXBoX2ZpbGxfdHJhY2Uoc3RydWN0IHN1cGVyX2Jsb2NrICpz
Yiwgc3RydWN0IGNlcGhfbWRzX3JlcXVlc3QgKnJlcSkNCj4gIAl9DQo+ICANCj4gIAlpZiAocmlu
Zm8tPmhlYWQtPmlzX2RlbnRyeSkgew0KPiAtCQlzdHJ1Y3QgaW5vZGUgKmRpciA9IHJlcS0+cl9w
YXJlbnQ7DQo+IC0NCj4gKwkJLyoNCj4gKwkJICogcl9wYXJlbnQgbWF5IGJlIHN0YWxlLCBpbiBj
YXNlcyB3aGVuIFJfUEFSRU5UX0xPQ0tFRCBpcyBub3Qgc2V0LA0KPiArCQkgKiBzbyB3ZSBuZWVk
IHRvIGdldCB0aGUgY29ycmVjdCBpbm9kZQ0KPiArCQkgKi8NCj4gKwkJc3RydWN0IGlub2RlICpk
aXIgPSBjZXBoX2dldF9yZXBseV9kaXIoc2IsIHJlcS0+cl9wYXJlbnQsIHJpbmZvKTsNCj4gIAkJ
aWYgKGRpcikgew0KPiAgCQkJZXJyID0gY2VwaF9maWxsX2lub2RlKGRpciwgTlVMTCwgJnJpbmZv
LT5kaXJpLA0KPiAgCQkJCQkgICAgICByaW5mby0+ZGlyZnJhZywgc2Vzc2lvbiwgLTEsDQoNCi0t
IA0KVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGlibS5jb20+DQo=

