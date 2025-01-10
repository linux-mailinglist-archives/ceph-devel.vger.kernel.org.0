Return-Path: <ceph-devel+bounces-2436-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C674DA09BD1
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2025 20:25:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3C5E16B298
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2025 19:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F9DF2144BA;
	Fri, 10 Jan 2025 19:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mHdw31f5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B73824B240;
	Fri, 10 Jan 2025 19:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736537151; cv=fail; b=tnrCFwkHImo2fxwHyQP6gFSeVxqNY5+yUneKNomVVJioRaqXRqWh+xa8LHGw+aDsu2bX1cBYrQ/04PUG+Gw1w6477E1bVdyx4azZLVu9xii+oHvrgyc+CceZm6rxStKJ/bQZQhr9/1GVjFOE1aj98zI+tTwKS9shzs1p7CXLe0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736537151; c=relaxed/simple;
	bh=hOTYfEDBs7zY+cbtMZq73h9OgCdHf26+OMD9xljlxpo=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=PnoUMeYU51BR2SoUcgE4X3iOv45HXzwt6LyKvCDOxEI8WZzis8m4tCICee0T2FovGkGOgU+cCGsliTreBzbpuy2FLmQxNLPPvzH/Suyv8ihZ0avaxjCUSLYmuKJ05G3G0/BR6y+AzI5yrUEvXl6dfGrms9SsPuiky8eNslugaFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mHdw31f5; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50AIM6Z8006482;
	Fri, 10 Jan 2025 19:25:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=hOTYfEDBs7zY+cbtMZq73h9OgCdHf26+OMD9xljlxpo=; b=mHdw31f5
	7xgk8WEsrO5BeFMU29UWhPv8JGzD7gu7ra+XHSxEb6JHRl0Yb7SnCkTvH6bcqc5P
	83TmTzNgLRqjyqHRJSTDNjFiAkOYGl645t6nEnn/L8/96ob3zxCv/0wirPeKFhV5
	LgB37TG2zzTOKliYhS1O5qy2XCiyBvV1o3aSFe/9aFrPQb80xelP/AgrJBQO16mK
	wWSG3y2Mpap+rce7LXdm6eBMKGsm63P+g6haeJid4NhO+5sv3G1LtGVR03TgRHaC
	BbmBksaG36sDeyFVrt+0EgweHxMvH8mYo5uHv3lC3bSaEMLPpkvrKOq+dW3Pdc3i
	dFCNQBA4g8FaSg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 442yr2tu3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 19:25:39 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50AJPcUJ019343;
	Fri, 10 Jan 2025 19:25:38 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2045.outbound.protection.outlook.com [104.47.73.45])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 442yr2tu3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 19:25:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SPnD0vKWWmzCPGfTkbVUBKYe+hNz7zF/nDyRAjtGY0ebPFq1sGHvPnypgHNbZ+l0PS1cZaDBidtK+wAgAaYIQHiArQ3IqU+xbojQJh+diGxUO2PtLdqrFp71bNJT/qTnaerzKfPcw2+GU4piaidKHFq8h8ARSSaA3m2fMSu180cwO3ke5P+89j3amLEeGgOzjicZiS2KyVwNoq3xrKZyUPrCtZtl4wdbXu3qBRC48fa6qswfZd08qHRCOFib/p1GEkwIh/6MieRsJBOPVdmbnlUA1aHX6Yqo6yUKT+9mYmV72a179iIl3EsDbwWAOkweY9KfFIWVzzhkH867+i2Wag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOTYfEDBs7zY+cbtMZq73h9OgCdHf26+OMD9xljlxpo=;
 b=RSvh2SXX98C1JoWbf/fYBmn3NNq1IcIx9cXxgSguYu2n93BGzzsnEyIvTAo8cRchRzsLeO12TxOZbaYoiCP8rWo060WTvcxoIjKBt7jGTUKLNsAukwcxEBPeTdLoGalY+I0+yNmnwgkgT6eSzHGjGqVbpyQa55T76rpcFxWZh4xlx1M1P6w8mgDV5dvKjAhcZmkiLvktgl6CELdtWiHT6+rPov41lw3UVvKHk2NwVIDfi39fG+R8DiAMcBRmk/nma4j6uKfYMf6H2QV5UEKx+ku9VgdYxhwqDPGHvkeJYAcht2oSJZspUflPDgTMSNPMrP1k/HNKMRYu0TDT3Pl/Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB4455.namprd15.prod.outlook.com (2603:10b6:a03:374::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Fri, 10 Jan
 2025 19:25:35 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8314.015; Fri, 10 Jan 2025
 19:25:35 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Xiubo Li <xiubli@redhat.com>, "buaajxlj@163.com" <buaajxlj@163.com>
CC: "fanggeng@lixiang.com" <fanggeng@lixiang.com>,
        "yangchen11@lixiang.com"
	<yangchen11@lixiang.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "liangjie@lixiang.com" <liangjie@lixiang.com>
Thread-Topic: [EXTERNAL] [PATCH] ceph: streamline request head structures in
 MDS client
Thread-Index: AQHbY0c/EPeeWSkY50aeVYkKUV5Mk7MQZEmA
Date: Fri, 10 Jan 2025 19:25:35 +0000
Message-ID: <c5276b40b56a092ea1ec8d161eaa42926018bf5f.camel@ibm.com>
References: <20250110100524.1891669-1-buaajxlj@163.com>
In-Reply-To: <20250110100524.1891669-1-buaajxlj@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB4455:EE_
x-ms-office365-filtering-correlation-id: 2d8c4e40-befa-4b70-e523-08dd31ac8eea
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MmNtYW5ZTUt3a2RyckVPSG9JWUhabVlDRzJ3cStaQTVldzBSdWZOUTU2Zmx6?=
 =?utf-8?B?M2loRlh3b21xb2JpUVN1SXBmOWk2L041eFVIWXpuSnl4UU8rSkNSQi96NG5q?=
 =?utf-8?B?aVNSRXVNblJvSnJwS3ZuMExmcnlKSTg5VXl4UFpsbk9ENThmV1E5RkE5WG5o?=
 =?utf-8?B?azhDbjhrTmhwYXJNK3Q2NnE1VnNGdktGTGVKRFhqa0JsR3BTdS96akdldkV0?=
 =?utf-8?B?TnNybTVVbUkzRFdmL2llZ1F1U3JGNU5yU2lkeG1ReTNlWENnYXRka0t4dW1n?=
 =?utf-8?B?cUNZOVduRnQvWmU5c0oybGRZL09iTXI4aGgzTXZCRTlwMnBaRi95WVZNcStm?=
 =?utf-8?B?MG9STVdsTUNUd0NadTMwVFZVaFh0dTZoZkVtTHpZWjJwVXBUdU5abGE1bytT?=
 =?utf-8?B?emFEdWM4ZmF4bVN3ak9Ccno4aDYvTk5kQk9zc3IzTmlYNjZZa2Z6K1hqRkln?=
 =?utf-8?B?aituL3lrVUo3eVJNZEREN05yYWY2elczck5PL2wzZnVNc2dlZmNIbVl0NkxM?=
 =?utf-8?B?aWxDeXY2VTdKVlVodGRQNmNoY0lLaGh6YVJBd2VYVmYyOFdBbm4vbXNjWEVa?=
 =?utf-8?B?TExyQUJhbXA3QW9nZVJHbzRJeUpjTHdNME50eHJTSUtRNEhtL2kwRGZBV29P?=
 =?utf-8?B?NlN3QWVibVZaLzhRZXNsdmVrSksrZDFoZFR3cHdwYVl1QUFjMkZVSGsybE80?=
 =?utf-8?B?WVVaa0d0QjQyWUxMRkUxd2kwVlVuVkwvRVlIcXgyYXFBeHBpaENFSzVHMnox?=
 =?utf-8?B?N08wRGd5QlJhWTYzd3ZqZDVIYmFScDJOejlZUVlhbFJPMjNJeUQrNXkrM1Fw?=
 =?utf-8?B?c29JRlNZdUNDbHB6T0hVcUtmQlJ2d3VtWDRQUE9iSEhseEhsdXRDU05OYmFu?=
 =?utf-8?B?YmRPWnZ5N0tuMnVhK2I0b2VsZU9YN1M4d0pOSndOajVmTlFpWXVnUjJMS3VN?=
 =?utf-8?B?eWxmS1FDYURMMlNENEQ1ZE5RQnVaRGo3SEp0dUdobVI4UXJOTEJLMHlQWU1D?=
 =?utf-8?B?YjN2UDN3azErNnErZTg5WFlPNnpWRDFnbGRrVGJTakZjOFgyQWNhajl2OTU3?=
 =?utf-8?B?Q1ZyM3hIQTU1NGc4eTFpeVJSYUFpdHZDL1FwVnB2blpGeSsvQUk1V29pZTRv?=
 =?utf-8?B?YzRwK1FJazV2MldYbXhhamxoV2NTdEpmbG1ibUJ1WHVXYkVXTmJoYXBoVjBG?=
 =?utf-8?B?bEFNcXFtR1Q5TTFuemdqOEt6YmlncEF2RlZERzE5VmpqSFRIS0FaTmtxeDQx?=
 =?utf-8?B?RlBBVVIvK2EvNGdBb0xwT2VwdUFEVUMxVCtRS05YRDU3U0N1d2x0RU1VN2Fj?=
 =?utf-8?B?blBaaWkydkFOd0pENlo0dG5XaElJN1B1OGNPNkx0dDF4eXFtcWpvUUt3azJu?=
 =?utf-8?B?Y3ZLSG1oeVNoN0l6YlIxODJETGpHaXpSNk5BZW1qNzgwSUlUWkhGa1NYUWVF?=
 =?utf-8?B?cytBVkJLc2tib2tZd1h3cEV0QlVkWWxkcWNBelBEUWhwb2VnWnRsK1R4RVNG?=
 =?utf-8?B?bUtUMitkNmxJMGlIak85VlRnZWQzTmZSSVVFY0IyalpwVVIyZTg1a0xNV2ZE?=
 =?utf-8?B?L2ZkeHhOQnRHejZmbUdUUkRaa0ExVkFNdmNPSzdYQUZNbld0bjg2ZzVPVEEv?=
 =?utf-8?B?S1VubWNMRTE3R0hOSzZyYldTZHppUjkxcnVaa3R3NzByL3hHRkthK1JZclN0?=
 =?utf-8?B?Y3lDbmM4TGkzOEY0dVdERlFJOE1IeGNZL0J6S2JKSXp4cGpsN3BPZitGRjRL?=
 =?utf-8?B?eHl2TVVqL1lFdWwvejdPaWxNYjJpL093RDBGQ1ljM2VwQ1F6RHhoZWFYcVU5?=
 =?utf-8?B?ZzBBd1hiSElBUVU0Y3EvMEpSNEsxR2YvMk9IVnRSMmxzUmtnb0Qzd3VDcEUw?=
 =?utf-8?B?Z0NIL054YVdTam5UMlBQeXh4MDNWZm9nNXQ5UmlINnA3QUFvVGpmbVl1Q0Vy?=
 =?utf-8?Q?Xv5wJ30znecLskHw0YApBfDzj2QdIs5C?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eVl1SXNFLzB3VkhqYWdCcHF6YTBXcTBUaHlWQ2U0TEUvd09ZUUZHdzdOYXBN?=
 =?utf-8?B?V0x3dzhVdWQ4eU5UR1VZakdtbkQvUHJDZDdkRGlhT3BFbDhjRjNWYjBvVXlQ?=
 =?utf-8?B?eWlibW1WdUdTMk1la2VMZXA3d1FjbjNOV05qYU5ZZU1sS250THNQVUdmNzE3?=
 =?utf-8?B?c1Rnamo0WjVLMCtnNEJ6VmVkbXdCNXpEVzlKLzdRalAwTXVYZ1FRMTJXbTNo?=
 =?utf-8?B?aUVXRUtJN0tCTWg3Wld0UjlOQy91WmkzUXRNVHRGYnkwNlhUa0UrTjJMRDRB?=
 =?utf-8?B?OTI1Rjd6WWQ0eXR4ZmxiM3FYUG1Ya1NFbzBrNlpMMm51elZLV0FxN1RNZUlt?=
 =?utf-8?B?LzNVM0NQYlM4eU95SmVGV0RSbWhxMEd2K1dpWWpxM2N2cTB2MmN3a05YVGZQ?=
 =?utf-8?B?ZzF6TFl3VXlPeE1wUlZmaGFNVWNzMVluM3I2WEJIL1V5OVJVeTNLZUVMRi9X?=
 =?utf-8?B?Smh0TTJLN2VXVFBLb0hFbkJHU0p3VFhSZGVaeE9XQVkybVBlSlFCSGxCUUdP?=
 =?utf-8?B?RXlYUGkxNmp0WWRObEJzdWdKMFFibXJqUDM1Z2dKUGVrcjVZS04vRExSVnl1?=
 =?utf-8?B?YzVMby80anQzZk80dkRlLzNLVzE1V3REeDUrK0xZSE9zTm04OG9ZMlNPbC9M?=
 =?utf-8?B?SEdSNWFsd0FPRUdYbmU0SkVVZU1Vb1pOR3NqankzU2U3NGY3Y0l6V1Y1VkZ6?=
 =?utf-8?B?eFlhaVVlb2lybWVXQ0Zhc3U3RzRpYVZGMGRFQzJDeXBTaW5HMVJUdTBDbE02?=
 =?utf-8?B?RllHdVV3VkMxNU1RUzhWQ0svdU9kNldWZlUwOUYrUlZiTU9EZkZFdmpvb3M4?=
 =?utf-8?B?T2tYcE82QVpqM2tXWlU1N2VZdUJidFpvZngwK0I1dWhkNm5CbzczZFk0NlV6?=
 =?utf-8?B?eUlYaExzNFBUNXl6SE1EVVFIK1dPeVFHKzFrOHJtdzdiUE1lRUUzaVZVM1Jh?=
 =?utf-8?B?c1AzUHl0TmxEN2pFSDJndU51Mmh5aU1uem5EN2JmK0E4Y21MencvakxTR1F1?=
 =?utf-8?B?d1QwVS9sSlVSVlRKRVlDM3lrdDFZNWxLOVJZa3NUWFlyTVJYS1FTbTFtdW9X?=
 =?utf-8?B?eFY1UFhOYVRKTXRPeldTKzdQdFAyc2xiVG1NazdnSUNYQzM5Y0w5aEhzYWRJ?=
 =?utf-8?B?aXRmMThRdG1SaXJlVC9wVG5zYklDdnlvZzNvQWZyQWxQZmNXYlRjVDVBdUhU?=
 =?utf-8?B?MFl4QnJyTGNVaXBEdXA1T1ZFMW15Y2tWUksxSkxpWUJlTEIyekZndHc5SC85?=
 =?utf-8?B?eU55Q0NMS3U0S1UxTGM5cTdXWkwzUW95TGh0V1FTMExsMmxFZENtb0YremdN?=
 =?utf-8?B?Um83R1pidnBEOGM1aFRwYktheHJlK0l2aUpQU1lZUDRMdVlMQWFjZ2RHSnNI?=
 =?utf-8?B?QmlwTHVJWUVjckpZWWRiZkVuQkhXSGpxUTJ4NExIbFhMWi9BSmt4YzRXVGl6?=
 =?utf-8?B?S0ljVGJQWHB2L0w0bXFad2Z1TWg4NGlOMlNKQmc1cEhxcXFxZzZYY3Vxdk9B?=
 =?utf-8?B?Q1RFZitrNmFvWHp5VlZxSmIzSVlKeE9KN1RYN1JJMFh3TXdYUTBTZG44NFly?=
 =?utf-8?B?aEtRVTVDRWFOa1ZSRExJR2F2T0Y4c3hYaXhxbGhIZE0xeHlDU1R5V0o5TXRw?=
 =?utf-8?B?dEZwVWJuQU1CTnh4ekVwZ0hrSnpES28xSXFVMFlpNnFySlpESEpqL0llM2JW?=
 =?utf-8?B?N1YzWnJLTUpGd3VZamlDRUljMU9vbkE3RUxtVWQ5Rk9ZZDYwOWVsT3VsNm5y?=
 =?utf-8?B?aG1rK1hQS2N4aWpsbnczNmZFbGtvTW5vbzFDc3hRcThoR0RFV0xaQ3hnQkNI?=
 =?utf-8?B?M0FPZGVYUnU2ZFoxdDd4aThyNXk5d0lPVFBjVURienR4V3BmK0lkSkhhQTFK?=
 =?utf-8?B?cE5KUkdUUzdQaTB3L2dQWG4xNEtQQ2xQdHZSZmQ1YzBWbVhHTWRVSlRJT3Nv?=
 =?utf-8?B?dHVqdWNyRkVuOGV2cDJxS0o1VVlzTTBOdk85ZWpkYXA4N2NkZ2FENjRBRXZ0?=
 =?utf-8?B?MXVSNWE0TmNPVzlJb3ovVFMyVGlTMDhoRVRuR3ZiT1JadW5UYzN2Mm1qTVVL?=
 =?utf-8?B?aUtzVGhwcDczWERrdlYxWnQvMU9WaVIwTzNMWGhzUDBZcG1WMVRKNis2RENy?=
 =?utf-8?B?WENhaEx3VnN6UmdkWHExNCszYkczVXhubTV2SXpYZDNlRzVIRGs3d3FvUWND?=
 =?utf-8?Q?IS3PerRKZTIkobC5UfpZeiA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4B30EA134916E4D8A65AE824606503F@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8c4e40-befa-4b70-e523-08dd31ac8eea
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2025 19:25:35.7827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MVVThoEWn+hMhJPQwOW/88lDJg8beuIFyAQKn4b3P4WSMoF+caDkPsPQb47r4VU9/tWmXxefNIk4OcEWX3WsMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4455
X-Proofpoint-ORIG-GUID: YDwCq9OzFZ4ki_InZ_FfbDim4OR33p3t
X-Proofpoint-GUID: D10gm1bsoXIlQjm367CihQHXtuo0lucR
Subject: Re:  [PATCH] ceph: streamline request head structures in MDS client
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 adultscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501100147

T24gRnJpLCAyMDI1LTAxLTEwIGF0IDE4OjA1ICswODAwLCBMaWFuZyBKaWUgd3JvdGU6DQo+IEZy
b206IExpYW5nIEppZSA8bGlhbmdqaWVAbGl4aWFuZy5jb20+DQo+IA0KPiBUaGUgZXhpc3RlbmNl
IG9mIHRoZSBjZXBoX21kc19yZXF1ZXN0X2hlYWRfb2xkIHN0cnVjdHVyZSBpbiB0aGUgTURTDQo+
IGNsaWVudA0KPiBjb2RlIGlzIG5vIGxvbmdlciByZXF1aXJlZCBkdWUgdG8gaW1wcm92ZW1lbnRz
IGluIGhhbmRsaW5nIGRpZmZlcmVudA0KPiBNRFMNCj4gcmVxdWVzdCBoZWFkZXIgdmVyc2lvbnMu
IFRoaXMgcGF0Y2ggcmVtb3ZlcyB0aGUgbm93IHJlZHVuZGFudA0KPiBjZXBoX21kc19yZXF1ZXN0
X2hlYWRfb2xkIHN0cnVjdHVyZSBhbmQgcmVwbGFjZXMgaXRzIHVzYWdlIHdpdGggdGhlDQo+IGZs
ZXhpYmxlIGFuZCBleHRlbnNpYmxlIGNlcGhfbWRzX3JlcXVlc3RfaGVhZCBzdHJ1Y3R1cmUuDQo+
IA0KPiBDaGFuZ2VzIGluY2x1ZGU6DQo+IC0gTW9kaWZpY2F0aW9uIG9mIGZpbmRfbGVnYWN5X3Jl
cXVlc3RfaGVhZCB0byBkaXJlY3RseSBjYXN0IHRoZQ0KPiBwb2ludGVyIHRvDQo+IMKgIGNlcGhf
bWRzX3JlcXVlc3RfaGVhZF9sZWdhY3kgd2l0aG91dCBnb2luZyB0aHJvdWdoIHRoZSBvbGQNCj4g
c3RydWN0dXJlLg0KPiAtIFVwZGF0ZSBzaXplb2YgY2FsY3VsYXRpb25zIGluIGNyZWF0ZV9yZXF1
ZXN0X21lc3NhZ2UgdG8gdXNlDQo+IG9mZnNldG9mZW5kDQo+IMKgIGZvciBjb25zaXN0ZW5jeSBh
bmQgZnV0dXJlLXByb29maW5nLCByYXRoZXIgdGhhbiByZWZlcmVuY2luZyB0aGUNCj4gb2xkDQo+
IMKgIHN0cnVjdHVyZS4NCj4gLSBVc2Ugb2YgdGhlIHN0cnVjdHVyZWQgY2VwaF9tZHNfcmVxdWVz
dF9oZWFkIGRpcmVjdGx5IGluc3RlYWQgb2YgdGhlDQo+IG9sZA0KPiDCoCBvbmUuDQo+IA0KPiBB
ZGRpdGlvbmFsbHksIHRoaXMgY29uc29saWRhdGlvbiBub3JtYWxpemVzIHRoZSBoYW5kbGluZyBv
Zg0KPiByZXF1ZXN0X2hlYWRfdmVyc2lvbiB2MSB0byBhbGlnbiB3aXRoIHZlcnNpb25zIHYyIGFu
ZCB2MywgbGVhZGluZyB0bw0KPiBhDQo+IG1vcmUgY29uc2lzdGVudCBhbmQgbWFpbnRhaW5hYmxl
IGNvZGViYXNlLg0KPiANCj4gVGhlc2UgY2hhbmdlcyBzaW1wbGlmeSB0aGUgY29kZWJhc2UgYW5k
IHJlZHVjZSBwb3RlbnRpYWwgY29uZnVzaW9uDQo+IHN0ZW1taW5nDQo+IGZyb20gdGhlIGV4aXN0
ZW5jZSBvZiBhbiBvYnNvbGV0ZSBzdHJ1Y3R1cmUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBMaWFu
ZyBKaWUgPGxpYW5namllQGxpeGlhbmcuY29tPg0KPiAtLS0NCj4gwqBmcy9jZXBoL21kc19jbGll
bnQuY8KgwqDCoMKgwqDCoMKgwqAgfCAxNiArKysrKysrKy0tLS0tLS0tDQo+IMKgaW5jbHVkZS9s
aW51eC9jZXBoL2NlcGhfZnMuaCB8IDE0IC0tLS0tLS0tLS0tLS0tDQo+IMKgMiBmaWxlcyBjaGFu
Z2VkLCA4IGluc2VydGlvbnMoKyksIDIyIGRlbGV0aW9ucygtKQ0KPiANCg0KTG9va3MgZ29vZCB0
byBtZS4gTmljZSBjbGVhbnVwLiANCg0KUmV2aWV3ZWQtYnk6IFZpYWNoZXNsYXYgRHViZXlrbyA8
U2xhdmEuRHViZXlrb0BpYm0uY29tPg0KDQpUaGFua3MsDQpTbGF2YS4NCg0KPiBkaWZmIC0tZ2l0
IGEvZnMvY2VwaC9tZHNfY2xpZW50LmMgYi9mcy9jZXBoL21kc19jbGllbnQuYw0KPiBpbmRleCA3
ODVmZTQ4OWVmNGIuLjIxOTZlNDA0MzE4YyAxMDA2NDQNCj4gLS0tIGEvZnMvY2VwaC9tZHNfY2xp
ZW50LmMNCj4gKysrIGIvZnMvY2VwaC9tZHNfY2xpZW50LmMNCj4gQEAgLTI5NDUsMTIgKzI5NDUs
MTIgQEAgc3RhdGljIHN0cnVjdCBjZXBoX21kc19yZXF1ZXN0X2hlYWRfbGVnYWN5ICoNCj4gwqBm
aW5kX2xlZ2FjeV9yZXF1ZXN0X2hlYWQodm9pZCAqcCwgdTY0IGZlYXR1cmVzKQ0KPiDCoHsNCj4g
wqAJYm9vbCBsZWdhY3kgPSAhKGZlYXR1cmVzICYgQ0VQSF9GRUFUVVJFX0ZTX0JUSU1FKTsNCj4g
LQlzdHJ1Y3QgY2VwaF9tZHNfcmVxdWVzdF9oZWFkX29sZCAqb2hlYWQ7DQo+ICsJc3RydWN0IGNl
cGhfbWRzX3JlcXVlc3RfaGVhZCAqaGVhZDsNCj4gwqANCj4gwqAJaWYgKGxlZ2FjeSkNCj4gwqAJ
CXJldHVybiAoc3RydWN0IGNlcGhfbWRzX3JlcXVlc3RfaGVhZF9sZWdhY3kgKilwOw0KPiAtCW9o
ZWFkID0gKHN0cnVjdCBjZXBoX21kc19yZXF1ZXN0X2hlYWRfb2xkICopcDsNCj4gLQlyZXR1cm4g
KHN0cnVjdCBjZXBoX21kc19yZXF1ZXN0X2hlYWRfbGVnYWN5ICopJm9oZWFkLQ0KPiA+b2xkZXN0
X2NsaWVudF90aWQ7DQo+ICsJaGVhZCA9IChzdHJ1Y3QgY2VwaF9tZHNfcmVxdWVzdF9oZWFkICop
cDsNCj4gKwlyZXR1cm4gKHN0cnVjdCBjZXBoX21kc19yZXF1ZXN0X2hlYWRfbGVnYWN5ICopJmhl
YWQtDQo+ID5vbGRlc3RfY2xpZW50X3RpZDsNCj4gwqB9DQo+IMKgDQo+IMKgLyoNCj4gQEAgLTMw
MjAsNyArMzAyMCw3IEBAIHN0YXRpYyBzdHJ1Y3QgY2VwaF9tc2cNCj4gKmNyZWF0ZV9yZXF1ZXN0
X21lc3NhZ2Uoc3RydWN0IGNlcGhfbWRzX3Nlc3Npb24gKnNlc3Npb24sDQo+IMKgCWlmIChsZWdh
Y3kpDQo+IMKgCQlsZW4gPSBzaXplb2Yoc3RydWN0IGNlcGhfbWRzX3JlcXVlc3RfaGVhZF9sZWdh
Y3kpOw0KPiDCoAllbHNlIGlmIChyZXF1ZXN0X2hlYWRfdmVyc2lvbiA9PSAxKQ0KPiAtCQlsZW4g
PSBzaXplb2Yoc3RydWN0IGNlcGhfbWRzX3JlcXVlc3RfaGVhZF9vbGQpOw0KPiArCQlsZW4gPSBv
ZmZzZXRvZmVuZChzdHJ1Y3QgY2VwaF9tZHNfcmVxdWVzdF9oZWFkLA0KPiBhcmdzKTsNCj4gwqAJ
ZWxzZSBpZiAocmVxdWVzdF9oZWFkX3ZlcnNpb24gPT0gMikNCj4gwqAJCWxlbiA9IG9mZnNldG9m
ZW5kKHN0cnVjdCBjZXBoX21kc19yZXF1ZXN0X2hlYWQsDQo+IGV4dF9udW1fZndkKTsNCj4gwqAJ
ZWxzZQ0KPiBAQCAtMzEwNCwxMSArMzEwNCwxMSBAQCBzdGF0aWMgc3RydWN0IGNlcGhfbXNnDQo+
ICpjcmVhdGVfcmVxdWVzdF9tZXNzYWdlKHN0cnVjdCBjZXBoX21kc19zZXNzaW9uICpzZXNzaW9u
LA0KPiDCoAkJbXNnLT5oZHIudmVyc2lvbiA9IGNwdV90b19sZTE2KDMpOw0KPiDCoAkJcCA9IG1z
Zy0+ZnJvbnQuaW92X2Jhc2UgKyBzaXplb2YoKmxoZWFkKTsNCj4gwqAJfSBlbHNlIGlmIChyZXF1
ZXN0X2hlYWRfdmVyc2lvbiA9PSAxKSB7DQo+IC0JCXN0cnVjdCBjZXBoX21kc19yZXF1ZXN0X2hl
YWRfb2xkICpvaGVhZCA9IG1zZy0NCj4gPmZyb250Lmlvdl9iYXNlOw0KPiArCQlzdHJ1Y3QgY2Vw
aF9tZHNfcmVxdWVzdF9oZWFkICpuaGVhZCA9IG1zZy0NCj4gPmZyb250Lmlvdl9iYXNlOw0KPiDC
oA0KPiDCoAkJbXNnLT5oZHIudmVyc2lvbiA9IGNwdV90b19sZTE2KDQpOw0KPiAtCQlvaGVhZC0+
dmVyc2lvbiA9IGNwdV90b19sZTE2KDEpOw0KPiAtCQlwID0gbXNnLT5mcm9udC5pb3ZfYmFzZSAr
IHNpemVvZigqb2hlYWQpOw0KPiArCQluaGVhZC0+dmVyc2lvbiA9IGNwdV90b19sZTE2KDEpOw0K
PiArCQlwID0gbXNnLT5mcm9udC5pb3ZfYmFzZSArIG9mZnNldG9mZW5kKHN0cnVjdA0KPiBjZXBo
X21kc19yZXF1ZXN0X2hlYWQsIGFyZ3MpOw0KPiDCoAl9IGVsc2UgaWYgKHJlcXVlc3RfaGVhZF92
ZXJzaW9uID09IDIpIHsNCj4gwqAJCXN0cnVjdCBjZXBoX21kc19yZXF1ZXN0X2hlYWQgKm5oZWFk
ID0gbXNnLQ0KPiA+ZnJvbnQuaW92X2Jhc2U7DQo+IMKgDQo+IEBAIC0zMjY1LDcgKzMyNjUsNyBA
QCBzdGF0aWMgaW50IF9fcHJlcGFyZV9zZW5kX3JlcXVlc3Qoc3RydWN0DQo+IGNlcGhfbWRzX3Nl
c3Npb24gKnNlc3Npb24sDQo+IMKgCSAqIHNvIHdlIGxpbWl0IHRvIHJldHJ5IGF0IG1vc3QgMjU2
IHRpbWVzLg0KPiDCoAkgKi8NCj4gwqAJaWYgKHJlcS0+cl9hdHRlbXB0cykgew0KPiAtCcKgwqDC
oMKgwqDCoCBvbGRfbWF4X3JldHJ5ID0gc2l6ZW9mX2ZpZWxkKHN0cnVjdA0KPiBjZXBoX21kc19y
ZXF1ZXN0X2hlYWRfb2xkLA0KPiArCQlvbGRfbWF4X3JldHJ5ID0gc2l6ZW9mX2ZpZWxkKHN0cnVj
dA0KPiBjZXBoX21kc19yZXF1ZXN0X2hlYWQsDQo+IMKgCQkJCQnCoMKgwqAgbnVtX3JldHJ5KTsN
Cj4gwqAJwqDCoMKgwqDCoMKgIG9sZF9tYXhfcmV0cnkgPSAxIDw8IChvbGRfbWF4X3JldHJ5ICog
QklUU19QRVJfQllURSk7DQo+IMKgCcKgwqDCoMKgwqDCoCBpZiAoKG9sZF92ZXJzaW9uICYmIHJl
cS0+cl9hdHRlbXB0cyA+PSBvbGRfbWF4X3JldHJ5KQ0KPiB8fA0KPiBkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9saW51eC9jZXBoL2NlcGhfZnMuaA0KPiBiL2luY2x1ZGUvbGludXgvY2VwaC9jZXBoX2Zz
LmgNCj4gaW5kZXggMmQ3ZDg2ZjAyOTBkLi5jN2YyYzYzYjNiYzMgMTAwNjQ0DQo+IC0tLSBhL2lu
Y2x1ZGUvbGludXgvY2VwaC9jZXBoX2ZzLmgNCj4gKysrIGIvaW5jbHVkZS9saW51eC9jZXBoL2Nl
cGhfZnMuaA0KPiBAQCAtNTA0LDIwICs1MDQsNiBAQCBzdHJ1Y3QgY2VwaF9tZHNfcmVxdWVzdF9o
ZWFkX2xlZ2FjeSB7DQo+IMKgDQo+IMKgI2RlZmluZSBDRVBIX01EU19SRVFVRVNUX0hFQURfVkVS
U0lPTsKgIDMNCj4gwqANCj4gLXN0cnVjdCBjZXBoX21kc19yZXF1ZXN0X2hlYWRfb2xkIHsNCj4g
LQlfX2xlMTYgdmVyc2lvbjvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLyogc3RydWN0
IHZlcnNpb24gKi8NCj4gLQlfX2xlNjQgb2xkZXN0X2NsaWVudF90aWQ7DQo+IC0JX19sZTMyIG1k
c21hcF9lcG9jaDvCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBvbiBjbGllbnQgKi8NCj4gLQlfX2xl
MzIgZmxhZ3M7wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBDRVBIX01EU19G
TEFHXyogKi8NCj4gLQlfX3U4IG51bV9yZXRyeSwgbnVtX2Z3ZDvCoMKgwqDCoMKgwqAgLyogY291
bnQgcmV0cnksIGZ3ZCBhdHRlbXB0cw0KPiAqLw0KPiAtCV9fbGUxNiBudW1fcmVsZWFzZXM7wqDC
oMKgwqDCoMKgwqDCoMKgwqAgLyogIyBpbmNsdWRlIGNhcC9sZWFzZQ0KPiByZWxlYXNlIHJlY29y
ZHMgKi8NCj4gLQlfX2xlMzIgb3A7wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAvKiBtZHMgb3AgY29kZSAqLw0KPiAtCV9fbGUzMiBjYWxsZXJfdWlkLCBjYWxsZXJfZ2lk
Ow0KPiAtCV9fbGU2NCBpbm87wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
LyogdXNlIHRoaXMgaW5vIGZvciBvcGVuYywNCj4gbWtkaXIsIG1rbm9kLA0KPiAtCQkJCQnCoCBl
dGMuIChpZiByZXBsYXlpbmcpICovDQo+IC0JdW5pb24gY2VwaF9tZHNfcmVxdWVzdF9hcmdzX2V4
dCBhcmdzOw0KPiAtfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSk7DQo+IC0NCj4gwqBzdHJ1Y3Qg
Y2VwaF9tZHNfcmVxdWVzdF9oZWFkIHsNCj4gwqAJX19sZTE2IHZlcnNpb247wqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIC8qIHN0cnVjdCB2ZXJzaW9uICovDQo+IMKgCV9fbGU2NCBvbGRl
c3RfY2xpZW50X3RpZDsNCg0K

