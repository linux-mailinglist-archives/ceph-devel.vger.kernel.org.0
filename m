Return-Path: <ceph-devel+bounces-3061-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A730EAC9352
	for <lists+ceph-devel@lfdr.de>; Fri, 30 May 2025 18:19:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45784A246E6
	for <lists+ceph-devel@lfdr.de>; Fri, 30 May 2025 16:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79F11A23B5;
	Fri, 30 May 2025 16:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WQh5egVZ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2242D2E401;
	Fri, 30 May 2025 16:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748621865; cv=fail; b=GLuMhwHdE1PmNLDzPGpHUMT64rmNSBA8rOdGDDVxqdgLyt/RsLmWblApAR3AlpyguQLxc1GLdSnWgzhUgs30JkjBoGgrcwQ3SgCZEyVb3qN+7s7DLg/hmr1uVGzqXCtZLFpVLKyhmv4yV09TIMRSlR3HbE6G6kimLrgwLl5TO4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748621865; c=relaxed/simple;
	bh=XQW+Qo6kN373xeO2u2Vq06sH8oP4aou72BuIQoPauFo=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=BGpzQ3GGXEvncCQaxOW9CV/LXYEnlAxH4eVhMFX3o2FcSZl//5wbsbk6gfTPCwz5Cto9aSeHTVlKPnxMqIZGmWislC0/RJJ+onGB2mQVX3K8ZrJDKDIIEIjY6sLag4Fkfm1lUJ4EKkGY6LhgWKEpbgOEA2zeUqciBALvc4bXbU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WQh5egVZ; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54UC8gcn017111;
	Fri, 30 May 2025 16:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=XQW+Qo6kN373xeO2u2Vq06sH8oP4aou72BuIQoPauFo=; b=WQh5egVZ
	WLoB8NJIZsAYvC/VSUuOl8/0KytO2d4nhlPg2kpqaKKs6fzRFPx0NJ7fXFAHmAUD
	Tb8hjylQmBQx3oL7EJiruiA7bwrjhp/Y51ELbwEduK3WwZzy2DuQowRCFrBnTgHT
	QJWcMcq84VJSeygn9ipMic+IB4bf1yo2j0fFBVN4Cg5HI7oJOUPr/hNCWwR9I1Vr
	CekD+8RWjRTYjamXVdzcHCQsBeARxj1LphATGHW0r3Uzew1mhi/Ei0m7DaQgLBwu
	xuEOgcrfrjktCGZ/Kq++vA00ZOJtRcuePRYBRBxsUICDmpmK/PHq0Og1NytM2oyW
	uk1v9lKv9xQBzA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46x40hvp4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 May 2025 16:17:41 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 54UGB2IB011125;
	Fri, 30 May 2025 16:17:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46x40hvp42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 May 2025 16:17:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ADAG9+ZJMb/K4kzd8I/teUvGExW4M/r6+gruzJ1MDTJU0WVO5Yy8sjg5Oi1uXrxmw6WSnrLWo/QDdjn25Hjr3GF2KthA6P4XdYqhB3nI9xcDvnDZtU99K/25ivD+eddl257P6pG5RbevbMLfziONrM0x4965d9LUOduqfl0Ra5SXZVKpHY8WHCZ8W2sUlXWXYFy0z/H5pnqhUyG2HqL/Y7b53+CXEu/d1s4Wmpyy9vCkuq9IPxxm5srX+nLR9VNQOijV8cjmgI/sSMDS9Z/1xtSx4zzrVD3KNvRWSJ/7kG/OUmzjacT/wuOD5Op+3KMS37+hdYh6Q178E2ngYSAAAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQW+Qo6kN373xeO2u2Vq06sH8oP4aou72BuIQoPauFo=;
 b=cDtJZ2Xq8kDfI6wkFPB5g1mEOBuQqODkxSGDhzUNfUJ6wwuQsmPnMAVHXoddq5c56nb79A2llDXhQ2lJNGq9RgwdKrL6D8Jmkw0JALnCbYof/dK0nh7y/WDQwrv31KHW7L4paz2SHEYEWquiMo03XmVPgaveR1EMtKUUff1DAPFo7lbAsBLlG5b0NjHkbMyC48TLaCsL0HIP2r+iPEFX4ehRF2EUAwr4tSPjw74iTtykjkopfEZpYMs3eZOW/odop4jM8SDrB+tSLrI6dpshI9XD1Ax5t/FLgAj1OyAuZ+clIyQD3djsju5+t5LQVILkq9TJsSJhEKytmUFStOQEWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB5227.namprd15.prod.outlook.com (2603:10b6:a03:42a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 30 May
 2025 16:17:38 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%6]) with mapi id 15.20.8769.025; Fri, 30 May 2025
 16:17:38 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "frank.li@vivo.com" <frank.li@vivo.com>, Xiubo Li <xiubli@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH] ceph: correct superblock flags
Thread-Index: AQHb0TxI2r81OZVdG0+9Iy6QFqBT17PrWj8A
Date: Fri, 30 May 2025 16:17:38 +0000
Message-ID: <5b3f5414f900b16dfcc316c5b46b5c6bc8d2354e.camel@ibm.com>
References: <20250530084459.2434286-1-frank.li@vivo.com>
In-Reply-To: <20250530084459.2434286-1-frank.li@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB5227:EE_
x-ms-office365-filtering-correlation-id: f057b158-d8ea-4167-20c0-08dd9f957f22
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bVptMndlNGpXcldoams3emZLV2g2bjJiNlI1bTMyZ0w0TUFuY0FDTFdPZFE5?=
 =?utf-8?B?b3RkV2NDZkk2VjVtOTZ4TTJsM1hPancrUFVTT0xZSThpSSt0Sllxd21scUh1?=
 =?utf-8?B?cXI5S3pTUk9oUk1ZRkFQdXpja0V6UTlrcGtwbmd2NkZhVzg3SzRYU0Zkdk55?=
 =?utf-8?B?WGlRMUd3STJOT1JEZk1CT3BzeTdjMjZQdkd6SWIyOXNFQjY1M0gxQXhLM1pH?=
 =?utf-8?B?Q05Id0VBNDEzSldUeUR4SlBIZzRZd3FjdmxNbFVzZ0hsaVhxQ0RXLzc0amZz?=
 =?utf-8?B?U1ExbkVSN0ZIbGRnODVKS1VrRjJSUCthK0F2aG9GUHB1OCttcTNvM0ZzWmNW?=
 =?utf-8?B?WUlucll6OUhGSmhnVUh5dnJYWDNaa3FFUElBbGZGaE5lWDNaYlVuVjFDQ1Nu?=
 =?utf-8?B?WUtlVmJUVG1uYkh4anJJWkVqMG9QY0NueGRxTEM5emhQU3VmVGExTWlhYUk3?=
 =?utf-8?B?MzRYdTkvMURzMlpvbjI4NmZmQ05xRWxxek1PSVNHdjFLWnFsaXVtNWxlOHMv?=
 =?utf-8?B?Q1hiejVoL3pBckpicHFOdFRFYmlEK09NSWdCcXRmVEtHUWVOYjlGalM0M1Z1?=
 =?utf-8?B?RnFidWFNOWhnMTJaU2FqT3VKTFY4ZTBYQkhMOWpPdHhwWWVYaThMU04vLzhC?=
 =?utf-8?B?R0F6aHFVS0YraysweHNnaTJmYXdKL2VSTUxrSzlua1JIY0NNREJZZG8rOFRW?=
 =?utf-8?B?Qk1vN2tNbGNidUwxV2VrTEM4NTBEeUdNNk5wbEIzQ1BKb2NyUmQ3bk0zY1lC?=
 =?utf-8?B?VE1kRW5uOFNkRlNvN284QzB2b3UzTDVKUVpxZm51RHFjdTdDRjJVMmlZTGcw?=
 =?utf-8?B?RlViNmdiV3l5dzRtUk1oRlpiU2w2WFUwSGMvcndqY3c4bDJyQWtrOXh5ZENE?=
 =?utf-8?B?b3U2S2kraGw4cE5Ld2xUM3hEL1RBcjRLbktqTU0xbGhpcjd5TmtlMGdqOUJN?=
 =?utf-8?B?REZoa3lPSjJQc3Q3U21ESmU2SzFlS3ZzTVV0TUJIaituTDhhWHVDMDhnaCs4?=
 =?utf-8?B?ZlhFQmxreXpCQkkxSm90cE1SMzQwVktORU1oZ05zMlJoYnp3eGVwTUN1aDlL?=
 =?utf-8?B?bmUxQzYrWlNTN2k5VGlKV2RTYWREQkQ5cmxTZ293bi8wZHBUQURZTnhtc3ht?=
 =?utf-8?B?UlNxQTFBS3ZPT0NRUUh3MlV3Zms0UmdzbExMR3ZLdUIvaXFjeE5OZ0VBdjZK?=
 =?utf-8?B?SVdMQlEwYndpWm1VSUlaV3dVMSsrSXQzb05qbVJnTWRHdGdPTWVub0o4RGZh?=
 =?utf-8?B?YnlkMjBJQ0wxVFR3R3o4Nzk5bFROL3dvSVVwR2F0eDNOM0s3aFZtWUFoVW5N?=
 =?utf-8?B?UHZmbVpnVjhkMUNHQm1pQVYvU0YzbEdYakl5OGk2U1R5eEptLzZGaTBmOGNC?=
 =?utf-8?B?UjB5TnZyR2kyWkUxNExvTHJzaldQMHRGeGgvR292S1NwS2U1UG1walZoWnVC?=
 =?utf-8?B?TG9BK3IvMXRpbXN0dGtZL2VPdDY5Qkk4elhqMzRNOWtydU44WTFDb3NhR1BQ?=
 =?utf-8?B?b3dHV2szSlUweWljS0I3d25lQzJiVEFmUUR3MzI0Q0QyWWhVVk9jNlYwenUx?=
 =?utf-8?B?NnkzNkx3S00xT0hSYUFoMjFMTlJwankwaFdJdEZYMmpBY0Y4RUZwV0lyNXBr?=
 =?utf-8?B?enEyeGhGN3F5WURtR1laYVQ0WDVnMzZyN0tTZitSS3dSOGptenluQVRodGEy?=
 =?utf-8?B?dUtkcjM0QUxBTGQ1R2NQMHU4SHJSN1NEZHVvd1VhZEhsSEZGeGxMZU9MMGVV?=
 =?utf-8?B?Ny9EVjVyVDJlaVRHNEsxb0t5WE1pdHRiZVUyZXZzYkx4YmJsTkhiZU80eUZp?=
 =?utf-8?B?NXc3WFhtR1FZYzVJY2VPandDa1JjcGRtU0JhUjFiWDNCWHVxdWhOR3FzMjh4?=
 =?utf-8?B?NzIybVUrcDhTeGorVVAzUkFXVGRDSFpZTy9LSnEzSVpzeE5CK3lLYWVhMVM5?=
 =?utf-8?B?bkdlK0FtOEg2MnNNbTFNQVBVUjdPektUTEZwdnJoMWl4QWpCQm04MzRkb0Q1?=
 =?utf-8?Q?B+cnND5jr019GVkH6b7Btm2sL2wKOk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eFdLMzZ6NXNpbUR0TFB0RnNqdWtac0VrN0trNENlaDUxMGdIL2JIZGxKQ0h5?=
 =?utf-8?B?SEdtTGFiU0hRd1RkRGNoNlNaMG5kVDRrakZLWlBsMGQyU2JSN0lSZHc0ZE5S?=
 =?utf-8?B?NVNKSmM4bXY0WWpMa1hjcDYwa3FMc1FUL2Z4MC9QdWFxY3RhVjdTc1UyOEtl?=
 =?utf-8?B?UjRzbVRQMWhyR2NrVjIzRGpFUkJxUi9iQm9VK3kxc1V6cnRTbGcrR3dNMFpl?=
 =?utf-8?B?QTI1TmxONHphVXl2NmFHUUgrS3VvbE1hNTRETFRvMFNtcGZQYmlycWplaXBX?=
 =?utf-8?B?QWhpTXVlSjRLc2RjaHJtU01vM3RMTml1Z1p5dkdweFZCSFgwalpBdHdKamtR?=
 =?utf-8?B?SFdmcmlvNlFHZWhNZ2NSM2R6Z1J6UlFpVXc2aVF1Unk3UFRFdVJtV0ZJSUZQ?=
 =?utf-8?B?NE9vdU05RmM4UThmbHo0YVJwU0NDcURwTG1CQXRFeCtFRHBXRVVMUXpHK3M2?=
 =?utf-8?B?a0doam9QVFNuMnczNHE3cVFlaDgyOVRuOUk2RnFrQkE0Sm1VTWwrL3BGa2x2?=
 =?utf-8?B?dWZmN1lFUWxoK2tBRWVUQXhEN1p0SE9abW9Yb3ZiV09TY2x3UldzRG5HOWdB?=
 =?utf-8?B?REIyK1A0TThwNFhFbDE4eWVGZXRGeU80Um9LTG5nbHNmUDMwK0Q4YTZiL2Mv?=
 =?utf-8?B?dDQ4QlF3NktZc0NSbVFzRjhIOGJncVpZdjBkYURRVjdYUVhOSTNnRkNKUzFk?=
 =?utf-8?B?VWt2MFdvckdtYmljbmhWaXpobFphNU1SdzBQb3NQSGNaaHk0SEtxaEtJZFhm?=
 =?utf-8?B?UkFZektxenQ1Wmcvb0ptVDIveExqT3VwWGYyaThrb0dmYTVkMXREb093NzYy?=
 =?utf-8?B?b0g5YjhoMHQ1UDl0SlBXYzA4ejkxS0Rsa1k2NlBkempab1V4Vm9WcmRVdllK?=
 =?utf-8?B?dkxNZ3NUdmxRQzZoSjY0S3RZWmQ3WTFPaXVQR0xjSjNENGhlcEduUXJwdTZX?=
 =?utf-8?B?MW1qMTRiMk0wUDc4dlRoenhKRm5JTGY3Wm9OVWhmQ1FUUlZFc3VUWnBqeVFP?=
 =?utf-8?B?RzUrRE1TNWxESE9Wd1VTR0VqOE9PUjN1ajhLWVdqa2NVNUlBZHpJam9UeUxH?=
 =?utf-8?B?Nmg4YzJKd0U5VnNBZXRYSWpKalNvZldTTWZqR25zZ1BiMXRXUzBRSS9XVWJp?=
 =?utf-8?B?cjQ1NUdOeURJRVhOazc2RFlaNUhvTkRXWmNYUkE5UEJPSjh4MWp0eFNTaHVB?=
 =?utf-8?B?YW5leDhlSzQya0Nkb3BRZ052TzZlRGlJUW9WcmhTSXRpcmVReVpWZjlmaVpB?=
 =?utf-8?B?VStYbTd1Q29iSTNMTUt6S2toUHdvNmY2QlJoNmJzNXBVOS94RWtJRUM4ZENF?=
 =?utf-8?B?d2haTUNHYWRtNHZuQ1dITFFHOVVqRldzcHFoZjcwb1pIKy90TDJWT2ZlVndK?=
 =?utf-8?B?WUtock5RTlRMcjFZdXRwOUtPUVFvSFhpb0JNUUlsL1lxSCtFKzBvKy8vVjZx?=
 =?utf-8?B?L3FYMkVxd2V4L2l5a2FyY2gwOEdSbVM4cGRtQjRPRFNxRnVMUFk1cThNVUV0?=
 =?utf-8?B?b3RwV1RHZnh2WVZhYWlhd1cwRzE1TlNlbVMxd1BGVGx2cTB1TWZnaGlJRSta?=
 =?utf-8?B?cXJzZm14eVBWUTNtbHpJS1htc2VLSzJUem9Ia3E3SHNXc3VoOTdpMis0RFpZ?=
 =?utf-8?B?SVU4L2tFcmZLYmhoRXRzckhSSTNFM1J4TWt4QWFSdEE1amM1U3h0Y3JEcnpI?=
 =?utf-8?B?ckpPOE5aVVpvcVNDWTN6WFVvMlhFYkRCUWNWMEJyZFpoL1F4OUhmcXhqSTRi?=
 =?utf-8?B?Mno4SnJjUmIxVEl2VXdRWCt3WXFvMmY0VklnZ0NDbjBBNkJBSkF2c1NJZXZ2?=
 =?utf-8?B?U2poa1FNZ1RYUmx5RVJMVzJIR2I0bjBpS0JENzFzNHk5VG8valFTSHBwRXJC?=
 =?utf-8?B?RHNuR3B4TUFtVWZCQ2h4VStMY0RhNFVMdmRqUk9BU3U2MnlLNFovN2FEMzZE?=
 =?utf-8?B?WENMY1RxQkRJa3ExMmIvOUJFLy8rRnZFNmtUTTJXS0R5dEtESHZZTVFQeGpw?=
 =?utf-8?B?cWdMTXV4M2pGWmNFa2o1NDdWenhmTWtGUGpMaytqa1B5THJYdWNPTXhkbHU4?=
 =?utf-8?B?T3E0a3lYU1Y3SkM2T3JKQmIyV3YwaFN1aGNMa2VCRzFNTXdJVjFoZHkwWllv?=
 =?utf-8?B?N21JYUNuYUNZVVBYVmM5bGxlQlF4NjdiSlhYbWNyRmwrMzdkREpzWTZLY2JU?=
 =?utf-8?Q?4fNDK08Q3OMTSOMtLmlkM2k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25DD046D7B09D94C80B8DE08E5FF43E9@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f057b158-d8ea-4167-20c0-08dd9f957f22
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2025 16:17:38.8001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UAPJo034S5oqcvkLMtXe5drndAatc/CthA86M1N0Jp5T6ct8VFqkq5yYVFKUgv7Dq940QyMPe3x49I6QEHFRUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB5227
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTMwMDE0MSBTYWx0ZWRfX4mpXn3AS6O4C xjtpMJE3jUwec4NgWFe2tEoDpDnHn4qMNO5DIV0MWyPY7KVxk5wXpU2ipJhm6Kpz6nTiwzYDfkY 29NlF+788eFiNwAAzH5TwYCqueacZqKFS8lsR44OaLkm9Yu3mFzklb/I0JrwK4YUIkdjOQg/PYo
 QT9C/cdqRszjzR9o/fOKI2g0bQASB7zlW7SCHIClZBKqMoN8PhB2LDV8NWJWKjzymyPcWkTPPGz B8TU9zMz4A8mQl0MAg1/yrFIuLO1rm0j3x8K1kmFA06uTJ9I7Emop8HOx9k7QZEjWFSdgOoOL/3 88ZvAPeU1/eiMcQusLHUOBbJVVt7U8ktwN2LxeBi9ahi9MOc8Hr+ExGPPe7dml66hi5i+IzIPm0
 mn++OB0MFbuoYN8mrZJ/hnasqSW/ekWf287ZgTQdpQYrQGwuq4NoyR2DUgNcYiybcPt11IAE
X-Proofpoint-GUID: TDIgTiavtXgcahCwRItyRgPgSvHeJqm1
X-Authority-Analysis: v=2.4 cv=WOd/XmsR c=1 sm=1 tr=0 ts=6839da25 cx=c_pps a=lUYDfCFJ8uif96mLs61nOg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=1WtWmnkvAAAA:8 a=WgNERMmzcvXzMJC9dAkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 51HvhS4lSX53xvvYv7ZgkeEu5QaXpaYp
Subject: Re:  [PATCH] ceph: correct superblock flags
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-30_07,2025-05-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 adultscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505300141

T24gRnJpLCAyMDI1LTA1LTMwIGF0IDAyOjQ0IC0wNjAwLCBZYW5ndGFvIExpIHdyb3RlOg0KPiBT
Ql9OT0FUSU1FIGluY2x1ZGVzIFNCX05PRElSQVRJTUUgYXMgYSBzdWJzZXQuIFRoZXJlZm9yZSwN
Cj4gc2V0dGluZyBTQl9OT0FUSU1FIGlzIHN1ZmZpY2llbnQgdG8gZGlzYWJsZSBhdGltZSB1cGRh
dGVzDQo+IGZvciBhbGwgZmlsZXMgYW5kIGRpcmVjdG9yaWVzLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogWWFuZ3RhbyBMaSA8ZnJhbmsubGlAdml2by5jb20+DQo+IC0tLQ0KPiAgZnMvY2VwaC9zdXBl
ci5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9u
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMvY2VwaC9zdXBlci5jIGIvZnMvY2VwaC9zdXBlci5j
DQo+IGluZGV4IGYzOTUxMjUzZTM5My4uN2M5ZTQ5ODdhZGY0IDEwMDY0NA0KPiAtLS0gYS9mcy9j
ZXBoL3N1cGVyLmMNCj4gKysrIGIvZnMvY2VwaC9zdXBlci5jDQo+IEBAIC0xMjI2LDcgKzEyMjYs
NyBAQCBzdGF0aWMgaW50IGNlcGhfc2V0X3N1cGVyKHN0cnVjdCBzdXBlcl9ibG9jayAqcywgc3Ry
dWN0IGZzX2NvbnRleHQgKmZjKQ0KPiAgCXMtPnNfdGltZV9ncmFuID0gMTsNCj4gIAlzLT5zX3Rp
bWVfbWluID0gMDsNCj4gIAlzLT5zX3RpbWVfbWF4ID0gVTMyX01BWDsNCj4gLQlzLT5zX2ZsYWdz
IHw9IFNCX05PRElSQVRJTUUgfCBTQl9OT0FUSU1FOw0KPiArCXMtPnNfZmxhZ3MgfD0gU0JfTk9B
VElNRTsNCj4gIA0KPiAgCWNlcGhfZnNjcnlwdF9zZXRfb3BzKHMpOw0KPiANCg0KVGhpcyBtb2Rp
ZmljYXRpb24gZG9lc24ndCBtYWtlIHNlbnNlIHRvIG1lLiBBbmQgSSBwcmVmZXIgdG8gYmUgbW9y
ZSBjb25zZXJ2YXRpdmUNCmhlcmUuIE1vcmVvdmVyLCBmcm9tIG15IHBvaW50IG9mIHZpZXcsIFNC
X05PRElSQVRJTUUgZmxhZyBpcyBhc3NvY2lhdGVkIHdpdGgNCm5vZGlyYXRpbWUgbW91bnQgb3B0
aW9uIGFuZCBTQl9OT0FUSU1FIGlzIGFzc29jaWF0ZWQgd2l0aCBub2F0aW1lIG1vdW50IG9wdGlv
bi4NCkJ5IHNldHRpbmcgdGhlc2UgZmxhZ3MsIHdlIGluc3RydWN0IGhvdyBmaWxlIHN5c3RlbSBu
ZWVkcyB0byBiZWhhdmUgZm9yIHRoZSBjYXNlDQpvZiBub2RpcmF0aW1lIGFuZCBub2F0aW1lIG1v
dW50cy4gU28sIHNlbWFudGljYWxseSwgdGhpcyBtb2RpZmljYXRpb24gc291bmRzDQp3cm9uZyB0
byBtZS4gSSBkb24ndCB0aGluayB0aGF0IHdlIG5lZWQgdG8gYWNjZXB0IHRoaXMgbW9kaWZpY2F0
aW9uLCBvdGhlcndpc2UsDQpzb21ldGhpbmcgY291bGQgYmUgYnJva2VuLg0KDQpUaGFua3MsDQpT
bGF2YS4NCg0K

