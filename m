Return-Path: <ceph-devel+bounces-3470-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA458B34A5D
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Aug 2025 20:32:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4B1617551B
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Aug 2025 18:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09EF2741DA;
	Mon, 25 Aug 2025 18:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mmg7coFU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24C927FD74
	for <ceph-devel@vger.kernel.org>; Mon, 25 Aug 2025 18:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756146719; cv=fail; b=aUM4nA9rjkAEnUNNwBiUIDtRmAJkPDmYWEE1TNrjnJcY5ayvkUycTAthXl+Pe/lhDFSoPg5a3EsS4u+4dxUxJqdWIy+PRVSEMcXQ37R05VMmZLzow1xQj2GoGtNaad3NgDwU3AR1cz3peVARpPQxA5MUj8Oi2IW4kn/WLOtZWvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756146719; c=relaxed/simple;
	bh=XabR4kqHKAHYf0t67pRCpIbiLsBK8MYoKhSBZ4H0YaQ=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=qQFtsiQv0dIu6M/a49daDipsTJ/4eJUpxMNM0LC1/UqOWibQIIMzFfND2fKF2Mb/nTwq+L2KyFWDGlEQKB1E6xWxDd2ubyQDD9hgs4n0hawC0DlT5jX55OEJV5nPfWIRw28VI/RnixxrXoPIIMPMPzklBqK6lrSmttHenqZNqAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mmg7coFU; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PB9xv4020682
	for <ceph-devel@vger.kernel.org>; Mon, 25 Aug 2025 18:31:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=KZUDGbPmfqcXjXcp6Q4XL5x6UnqehQMVPpKTBXFnppo=; b=mmg7coFU
	/RTukx1layx18RTNYOVQVYYshYOU4qoNZv7LEZAxU2hl/1WEVVwetx0KeIrxbpcY
	FN8aFyzXqIVCSmcWei4YViWA6b13wY1bFHjazJWRlsTKtErtvc/zWpawAhCX5Lr1
	za3k/WzHY/eWnDl7Ir3O5i7Uogh2zaVcr08ni3aWLhu/WqxI2f+GTodQOnlOBWqI
	O0RmKHtGrCFSPf5/DSvGXbGmFOiewrzKABcGpKk6hlD+wQs7qv8dZNJhAyyEqOw2
	DYcoMVXc4MlG8P9FStbWlKXkicpTj0yjOEZCUN0sa8ThNgeWKB7kutMtGhOcTy3m
	Jho5vzIlMQ0bzA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5avak4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Mon, 25 Aug 2025 18:31:56 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57PIVumH007757
	for <ceph-devel@vger.kernel.org>; Mon, 25 Aug 2025 18:31:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5avak48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 18:31:56 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57PISg78002290;
	Mon, 25 Aug 2025 18:31:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5avak44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 18:31:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=icfsoRrNGts/jd0+4IYUSHgOeTip6LX/dxbh89mfru8kY2BOQCrc5Z0GsMCINR8WAWgHuybyFJ03zaPFk5539UdqJOVtlc8eSdemlkFf/pRvAiNOkqIKXnQwlEY3qYswbsMVaZFVmihLJZoVNcEiyrVdScejuoqwSTNgu82/L3ojpO06pbkROxONtYEj8vkhJvCLzXtFVz1TxF1rdST2h72pRrMau3zIKKVY+WeK4pADWl/ApCIkJeZni1eJnU6ZRd5OrjS+69R0Fk4X4hTkGeoM0PguUTQU+cwt3XXo26UzIoXiORwVyxAeWS0pgGFQPy+ymg0GONqNz/xH8PgjXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xqkiqGuabaLdvKKpBwi2W8tbsljobRdKq2dTkW1bSjE=;
 b=wNFbhQm+8CweZMXI9sRSDpPMTl/OqvL4cqmTbSZ1qv1qTL1k0POqd8Z7LzoY596GwffA00YXN76DI3KvlNx2KeeU6I4w4OkUVw+9/WJbBlz7/dxXPyIeHWN2LfYyUKMPyJgyDzQypSh5T5oML3w964MiUvlGq9xA+oFgBoqI3P/8ixw5Y8yU57pugLM2ctiBaExIfYTHxqwQTnkKrY07LpEP8QCAX1k3kgVOvvXwnytFEoEnNINYkbk99YVih/+fwSlxtfCIP+4ptmAczoTmFqch17HsPkiJLh86qHv9OSAqWK6y9wporhHw3xWqh3y4EQer/bY9tvjvZYylmki0uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BLAPR15MB3873.namprd15.prod.outlook.com (2603:10b6:208:254::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 18:31:52 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9031.023; Mon, 25 Aug 2025
 18:31:51 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Kotresh
 Hiremath Ravishankar <khiremat@redhat.com>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        Alex Markuze
	<amarkuze@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Venky Shankar
	<vshankar@redhat.com>
Thread-Topic: [EXTERNAL] [PATCH v3] ceph: Fix multifs mds auth caps issue
Thread-Index: AQHcFSgZX1N187j5+U+TUNNBD3L0uLRzsruA
Date: Mon, 25 Aug 2025 18:31:51 +0000
Message-ID: <9f15c800374bc29bb9bf89df3d4949f58195fed5.camel@ibm.com>
References: <20250824184858.24413-1-khiremat@redhat.com>
In-Reply-To: <20250824184858.24413-1-khiremat@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BLAPR15MB3873:EE_
x-ms-office365-filtering-correlation-id: acb6cfdd-5569-4fcb-b9f9-08dde405a911
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WXc3YjBnVUtMeGFHSUZrUjIwL2NJRUhPSXBXQjlMcVg0YW81VWFxOStSdWFn?=
 =?utf-8?B?Q2hNS1c1RlhRZVlsYmtKb0MxeFVqL2VSb2NpN3gxRyt4OXZURVVBQmFId2s1?=
 =?utf-8?B?VnFVbVB5UWFST09nNWkzM0xpcDlwRzVVb29NWGdva1pETFN5WXI4bVJBeTMv?=
 =?utf-8?B?bTRxU2dtdmZwdk1NQmY3WmFTN0dKZUozdDJhQmhjWEFWTnJOUThSaWV1U1BO?=
 =?utf-8?B?cnZsRTdEbHRuTEhwaWhDbzRHR1l4Myt2MTNYYlh3Q1BZN3BPUTBjaGtTZkkv?=
 =?utf-8?B?cWNHQWZ0RVNXUXBUemRjL0xRVXkyRWl3K1NnSklLNGJhNFdITmpFd2ZMdDFF?=
 =?utf-8?B?YzJ4WHBEYzRYSC9ZS1NPNGFxdTExVEZUbG1iUklST2QrMTAvT0NBQ2djejBU?=
 =?utf-8?B?eGVGZG1keVBUM0JXV3owZHFLSDNOUVBCMkJaVTFoKzNyN2tkbTgvVm5xbk1O?=
 =?utf-8?B?SXhTaXFySHd1ajlUa3RBNXZTQXRlVXdOZ2RZb1BUUFY2QlRlTWpYK3J6TWFn?=
 =?utf-8?B?cVdaR1ZBcFdxRlRJOG5GMjlzSTRwVGRQVmNjVGZLTno1NTZaVjZ6aU1qMkxl?=
 =?utf-8?B?ZzVTLzlOSGFQVWU2YzNyckE1Tk5PVUFYeWZ3aWF2MGlFK2x1TFhsTTJmdmNU?=
 =?utf-8?B?ZkRUQXA0SkkyNVVSejFNWk1VMSt0Nk9BbmNDZ29xcGcyQk9RbnMvbGFwMlNM?=
 =?utf-8?B?Ykh6ZGdkT1hhZHBYc1lPNkVvSEFrYW5OZVVsYm5kUTJMMnlVajI2bVBFbzNp?=
 =?utf-8?B?c2pSYk1FMHZpcUdueXRzRGVYMGhteTNjZk9WWnAwM0VSc0RaelJHMmFTcWly?=
 =?utf-8?B?cW1NZXlqemROaUoyYWlPV25DYmxTVnpjSjkwUVQxVm5Fb1UwYk1heFVaTWJz?=
 =?utf-8?B?djFXWmhRbElIMExldVREUUdXZDdXVVAzSTRyVUl6V1pGZ1VCeHkySURhOVFt?=
 =?utf-8?B?MmxMNWxnY25CY2ZhbFZONnZTTUpCVnFMTjlpaGZkcDBLcFZ4aXFSWU0vR0pU?=
 =?utf-8?B?aDZoeUtmczN5NEg2YTc0MFUwMm05UGZubWE4Q0s5T3dxMUpEeVZqU0MzR2dv?=
 =?utf-8?B?c3V5eWNYbUoxejVlSklZZ0NHSEExTkhIMk1NMVVuell3azZIMlcxSlBoVFlh?=
 =?utf-8?B?aGR3TlhoeXd1UWx4dWFFRm5KVXZQUWpFME9ldk9OTlhUUldzTXdTQXNicnQv?=
 =?utf-8?B?Smp4aGROcmlwU2JoamZwbFJMRWI4T3NJS04xd28rT1ZjTVNvSUxPSkpzTy9K?=
 =?utf-8?B?bGo2c3Jib280OVphT2FESkkxK2VBZnowdG1NMS90S1B5YVVkamFTNjJUTGxl?=
 =?utf-8?B?NUNEUUZDTGNiN1hRTHhLMnFIK2hrcGRWaWpBbjFNenhCajRJNFUvdmtYUGZW?=
 =?utf-8?B?YWFzWlFCMERGUTEwMHV6b01wdE85UDYvUzJhZVJjeGFueWlxNFJRN3dRUXRE?=
 =?utf-8?B?QnpJVWw4Z3p6Q29HY2I3YzVmblZYd2tzbk1idlUwRFFhOC9xWTNTc0psZUVk?=
 =?utf-8?B?aC92RGllYVJsajhVK0xFek1PWVhBUkRyRTBqdjJrOXc2aS9GOXNDZWFaN2R1?=
 =?utf-8?B?bXpvcEVhV3cxZmd5UFYzWUp0WlA2YUtpZEVFUVE2dHY3N0s0MGxLS3BVZnF0?=
 =?utf-8?B?WXVXeFplNEgxQzdqdnZac3RJR3AybllESlhsUFNCSG9lSnk1ZjFZWlRoQ3hR?=
 =?utf-8?B?cS95cS85OUdRVzc2UGRFTVdkdTBtQ01qSDFQdXhJdnFjYTN0aEhCNU80dUhN?=
 =?utf-8?B?N1pZcTVQa3FTVVR1WDVQd1pOUXVxRG5mcXdrbVpzY1hxOEpPYXduYlkxbWJp?=
 =?utf-8?B?a05TMXJqU1FqUmxnYTFoeWhSaDV3OURPajVtL3hEbnMrRHZXelh4MmZ6WXlO?=
 =?utf-8?B?Z0JGclA2WWRpUlo0ZEJxRVUrb2tsOEx6U2NLYlBFU01rWmJlUnVJLzF4Z2JV?=
 =?utf-8?Q?kNOOmNvnNXA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Ym1CVHNvSWhlYzFOZkxZZUtZMm1CcUE2VzRmS0hNMGIxSDdENmxxZERMVzVk?=
 =?utf-8?B?TnNKSmZFWkl3SmxUaFU4aVhwM29hTCs2ZWJud01hMWxVWTJLeXFYR2Izazc3?=
 =?utf-8?B?SmtnQ0hkNkZCS0JaSzVPWGxZc3Vid2U4ODZhS01WN2lsSCtFQkQ5YmZhS1RF?=
 =?utf-8?B?NEZoNHptZWhMTHVQUXVUNWZHR0M5d1ZGQ0pkKzQ4clhVbGV2K2IzbjJRbUox?=
 =?utf-8?B?R2FpSXNONW9YL2NnOERkNVpERk1xb1lMYldoeHFnQ2pzUWpqL0t1SmZ5Y0Nz?=
 =?utf-8?B?N01VaVZLTzdENU1Da1FwV0FyRUlFUUNSSURCcHc3TEUzMVB1Ukl6K2tzRjBT?=
 =?utf-8?B?b0V2RmJoQWNHbS9SbDdMK054UFhza2tBRkVFQU1FZFhKRzRGQ3pUalR5TDBr?=
 =?utf-8?B?Z0FDT3dLTDF1eVZjWDM0UjVrR29NRldFdWhyeStqcmptMnRnYjFqbHRYRnls?=
 =?utf-8?B?NVphVnNSMVplZzhzZFUrT09zaG9JRnh1R1NFNTZZc1VXcmtUdjVEdUJJRnQ5?=
 =?utf-8?B?NEJaYXJvanA3bE5sM3hSS0FJQndzVTF4WUlyM3hSV2ZFRTdzd0xIZlE4TEkv?=
 =?utf-8?B?RHE5Z0l1TDA2SkxZdWFEaXlsRVJvRHFjaDBnUUdheHlYNWdtOGRZdE1JYm51?=
 =?utf-8?B?VXFYVm5YRjREV2IyQ0F0dDM0eHlmOVpSdi9CV0VMM3N1UG1KVmhmSkRFcUg3?=
 =?utf-8?B?bU9xN0lLb2R2K0ZpZXVVcXJNQkRkbytvTnhndHVnM1U2dzdEOVRWY1duNWRQ?=
 =?utf-8?B?OFFJVGE5dlZMMXd2bm0vRE54ODNob0loSnhNQzRvSEE2UnBsSkR2VzhkWkJj?=
 =?utf-8?B?QW5qdmVnaGdYTTAwTlQ2Z1djZUJpSUFkK0wvN3VOOG1wQ0Z6eFB2SGJ3Sklj?=
 =?utf-8?B?Q1NsY25JMUpvMEZnRTZ1cHhZaEJ4R2UxWXlKc0tOVnkzSXVESnBiYlVkZFZj?=
 =?utf-8?B?LzI0WXBCanM0RDk0Uko5YmJJV3JlVFZocVFZdmlleUhJUmptNHFvQnl6bytR?=
 =?utf-8?B?NjVUQXJ0N2pwTGRFTGhNVElkZlFrMkpRSHRBNS9hTyszak5pSjFFdVpXVFFp?=
 =?utf-8?B?SHA3YVh6dHZTODZqMGEyZ05YK29BZkQvUWg5OHNWSGRYdWtlN3o1R0Vxc0F0?=
 =?utf-8?B?aEFWLytTSUJhVGZxcEVIVXFOMCs0L3FadHNVbHdZUUkydzlxZ3d5d0NncHFJ?=
 =?utf-8?B?aDRmVUdhYUpCWklZeVNIUnBqbUhVUVgwaDFBTThQYW8vRjVpdHlXRFdxZFhZ?=
 =?utf-8?B?TmJIWUFNNEwrMVVIZzlyZDdGQVVTR2MxbW1hcXVnSmpZZ3F2RzFPS3V6MHJz?=
 =?utf-8?B?cXZZY2JtcmN2ZURGbWZyZWY5aTlzOXVVYTN2UXplYjNuRiswZTJPZW1RK2Yv?=
 =?utf-8?B?cEx4OWc4T3NObUY1dUhtMFBkY0x0c1E4NnJjMVpUWVFvVFlGdFVzbmo1eDVu?=
 =?utf-8?B?ZmRNNVRqLzE2a0hOZDluQ2xNU0hNSkFQTFB5RW4yTXEwdVIwdXhCclJpZUFM?=
 =?utf-8?B?Y2Q0Q2tlbytvak1DUW56NTQ1U2Y0a0tiT0k2T1ZvWndjbW1GZ3E4QjI5Q210?=
 =?utf-8?B?Q2toaENoTG5UdnZuSTlMcElDcElORlVhQjZIcnQ0NnZKaGFiMlVsYlFNb2E5?=
 =?utf-8?B?T2ZhSVgwbEgzbWdaQjF6Y0t1Qk8xcUdaeTNGQlczeVRycmVBeVdVQ0NkaTRS?=
 =?utf-8?B?bVNtUUVEd3YwYk9vQ2MxZDR5b2tsOW5STlZaVUFGR0g2VlZaV1Nlc08xUEQ1?=
 =?utf-8?B?Z0ZuMVpjUkgyYjQxcGJZbTQvNVFXTmlYeE5FeHlGZEFJQ1A2b29Da1J4eitO?=
 =?utf-8?B?bmw4UkVWa0YvYk5leFhhenozNUVFQTF4M2lCTm55T1hHV3JZbkJxd2p3Mmww?=
 =?utf-8?B?Yk41eWwyOW9MU2VmMjZ1Q3hkQkVoRm8rWWVHekZrZWEzN3h5V20zdm56dW0w?=
 =?utf-8?B?eWl5VmpSSWFpY0hRelpHb0xxK3M3TDl0Q0RJemlyaWlxZGFTNWF3TGRGVGlz?=
 =?utf-8?B?NjNsTGRRMzF4dktPWEUwbmVIcDJxT2IzTUVLdHlPT2trWXc0Z2s1cXZIV0Vw?=
 =?utf-8?B?VTVTbEVwclRYdkNzeWpKV1FscFc4bU9vL0ptMVJOcFlyWjJaSjJoUWlYd0NC?=
 =?utf-8?B?NmErV1hCZ2ZIN0lBZjV5Z0JNckJjUktDNXdzU3l1U2pnS0x0WXRMQTlhVnZQ?=
 =?utf-8?Q?r0aRVqRAqXBlnMzODqioLtM=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acb6cfdd-5569-4fcb-b9f9-08dde405a911
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2025 18:31:51.8391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mpHAIQL22wTnj5KNg+ukiMqcVMA3kuZ6Jw9bII1Zj0RoUzZZte9swSw461bwm0GDL0bqNHc3AZMU2Mk66eWA5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3873
X-Proofpoint-GUID: -Yd2YaxVnbCEIAmGKNvp19ejolyupWkM
X-Proofpoint-ORIG-GUID: T7N-Fs6gG6whMMtgQaNJ67JgS2tP0D9m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfXxh/PeOfmd9FY
 9qrg0dK4Aoj0SkBQd3Vlebq03sTePbCFAzGHYeJzJ/+MaY+SqgcHiVkbaRDNPAa478Z4aWXt8hJ
 06RVpME6BIsM9UmBcgZtn89+WdptLo9kPnmwM8X2n8LM+8/pM2DvoDkWEa8akd07zgfhujaEKxh
 87157vJMshm5J4xjIhYeitFfRoXHoQaigzACSnY9NUo0QxkLAm/VpQjTHRzJywsiq9jKVfLFKxK
 FtKhCFkxQImPBMfErLPqHUaXo75LC2DLjDvmgMgmhPeiMILYsplo111J4ZRkmiii2hbDebTFq47
 vO+IEoExd5iuJA68RNlskI7i0ZNprzv4nc0XHcnGsTH20x/y4wFDGK9NII4aFXA3fGCwgEhaVY7
 sAWb3uyb
X-Authority-Analysis: v=2.4 cv=SNNCVPvH c=1 sm=1 tr=0 ts=68acac1c cx=c_pps
 a=ZwOCfSBgJ6FT52HY8rp51w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=4u6H09k7AAAA:8 a=20KFwNOVAAAA:8 a=BOokjy8hzOdu2QGMrBMA:9
 a=QEXdDO2ut3YA:10 a=5yerskEF2kbSkDMynNst:22
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B9EC79671740040939C2AA253DA1B1D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re:  [PATCH v3] ceph: Fix multifs mds auth caps issue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_08,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=2 engine=8.19.0-2507300000 definitions=main-2508230021

On Mon, 2025-08-25 at 00:18 +0530, khiremat@redhat.com wrote:
> From: Kotresh HR <khiremat@redhat.com>
>=20
> The mds auth caps check should also validate the
> fsname along with the associated caps. Not doing
> so would result in applying the mds auth caps of
> one fs on to the other fs in a multifs ceph cluster.
> The bug causes multiple issues w.r.t user
> authentication, following is one such example.
>=20
> Steps to Reproduce (on vstart cluster):
> 1. Create two file systems in a cluster, say 'fsname1' and 'fsname2'
> 2. Authorize read only permission to the user 'client.usr' on fs 'fsname1'
>     $ceph fs authorize fsname1 client.usr / r
> 3. Authorize read and write permission to the same user 'client.usr' on f=
s 'fsname2'
>     $ceph fs authorize fsname2 client.usr / rw
> 4. Update the keyring
>     $ceph auth get client.usr >> ./keyring
>=20
> With above permssions for the user 'client.usr', following is the
> expectation.
>   a. The 'client.usr' should be able to only read the contents
>      and not allowed to create or delete files on file system 'fsname1'.
>   b. The 'client.usr' should be able to read/write on file system 'fsname=
2'.
>=20
> But, with this bug, the 'client.usr' is allowed to read/write on file
> system 'fsname1'. See below.
>=20
> 5. Mount the file system 'fsname1' with the user 'client.usr'
>      $sudo bin/mount.ceph usr@.fsname1=3D/ /kmnt_fsname1_usr/
> 6. Try creating a file on file system 'fsname1' with user 'client.usr'. T=
his
>    should fail but passes with this bug.
>      $touch /kmnt_fsname1_usr/file1
> 7. Mount the file system 'fsname1' with the user 'client.admin' and creat=
e a
>    file.
>      $sudo bin/mount.ceph admin@.fsname1=3D/ /kmnt_fsname1_admin
>      $echo "data" > /kmnt_fsname1_admin/admin_file1
> 8. Try removing an existing file on file system 'fsname1' with the user
>    'client.usr'. This shoudn't succeed but succeeds with the bug.
>      $rm -f /kmnt_fsname1_usr/admin_file1
>=20
> For more information, please take a look at the corresponding mds/fuse pa=
tch
> and tests added by looking into the tracker mentioned below.
>=20
> v2: Fix a possible null dereference in doutc
> v3: Don't store fsname from mdsmap, validate against
>     ceph_mount_options's fsname and use it
>=20
> URL: https://tracker.ceph.com/issues/72167 =20
> Signed-off-by: Kotresh HR <khiremat@redhat.com>
> ---
>  fs/ceph/mds_client.c | 10 ++++++++++
>  fs/ceph/mdsmap.c     | 14 +++++++++++++-
>  2 files changed, 23 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index ce0c129f4651..638a12626432 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5680,11 +5680,21 @@ static int ceph_mds_auth_match(struct ceph_mds_cl=
ient *mdsc,
>  	u32 caller_uid =3D from_kuid(&init_user_ns, cred->fsuid);
>  	u32 caller_gid =3D from_kgid(&init_user_ns, cred->fsgid);
>  	struct ceph_client *cl =3D mdsc->fsc->client;
> +	const char *fs_name =3D mdsc->fsc->mount_options->mds_namespace;
>  	const char *spath =3D mdsc->fsc->mount_options->server_path;
>  	bool gid_matched =3D false;
>  	u32 gid, tlen, len;
>  	int i, j;
> =20

The doutc is debug output and it will never be shown without enabling it. S=
o, it
will be completely enough to place the doutc one time for both cases here.=
=20

> +	if (auth->match.fs_name && strcmp(auth->match.fs_name, fs_name)) {
> +		doutc(cl, "fsname check failed fs_name=3D%s  match.fs_name=3D%s\n",
> +		      fs_name, auth->match.fs_name);
> +		return 0;

If the check is failed, then it sounds to me that we need to show an error
message here and return error code:

pr_err_client(<error message>);
return -EINVAL; ????

Am I correct here?

> +	} else {
> +		doutc(cl, "fsname check passed fs_name=3D%s  match.fs_name=3D%s\n",
> +		      fs_name, auth->match.fs_name ? auth->match.fs_name : "");
> +	}
> +
>  	doutc(cl, "match.uid %lld\n", auth->match.uid);
>  	if (auth->match.uid !=3D MDS_AUTH_UID_ANY) {
>  		if (auth->match.uid !=3D caller_uid)
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 8109aba66e02..44f435351daa 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -356,7 +356,19 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_m=
ds_client *mdsc, void **p,
>  		/* enabled */
>  		ceph_decode_8_safe(p, end, m->m_enabled, bad_ext);
>  		/* fs_name */
> -		ceph_decode_skip_string(p, end, bad_ext);
> +	        const char *mds_namespace =3D mdsc->fsc->mount_options->mds_nam=
espace;
> +		u32 fsname_len;

I am afraid we could have compiler warnings for such C declarations. Let's =
have
all declarations in the beginning of scope:

if (mdsmap_ev >=3D 8) {
     const char *mds_namespace =3D mdsc->fsc->mount_options->mds_namespace;
     u32 fsname_len;

     /* enabled */
    ceph_decode_8_safe(p, end, m->m_enabled, bad_ext);
    /* fs_name */
    <rest logic>
}

> +		ceph_decode_32_safe(p, end, fsname_len, bad_ext);
> +
> +	        void *sp =3D *p;

What the point to introduce sp variable but not to use p pointer directly? =
Any
particular reason?

> +		if (!(mds_namespace &&
> +		      strlen(mds_namespace) =3D=3D fsname_len &&
> +		      !strncmp(mds_namespace, (char *)sp, fsname_len))) {

Frankly speaking, I think to introduce a static inline function for this ch=
eck
could make the code cleaner.=C2=A0I mean something like this:
=20
if (fsname_mismatch()) {
   <complain>
   goto bad;
}

> +			pr_warn_client(cl, "fsname doesn't match\n");

What's about sharing the mismatched names?

pr_warn_client(cl, "fsname %s doesn't match to mds_namespace %s\n");

Thanks,
Slava.

> +			goto bad;
> +		}
> +		// skip fsname after validation
> +		ceph_decode_skip_n(p, end, fsname_len, bad);
>  	}
>  	/* damaged */
>  	if (mdsmap_ev >=3D 9) {

