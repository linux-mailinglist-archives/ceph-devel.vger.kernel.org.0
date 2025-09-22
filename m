Return-Path: <ceph-devel+bounces-3704-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F28B9263D
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Sep 2025 19:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 744731905C9B
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Sep 2025 17:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E7931352B;
	Mon, 22 Sep 2025 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o6/EfNHr"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27153128B0
	for <ceph-devel@vger.kernel.org>; Mon, 22 Sep 2025 17:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758561584; cv=fail; b=YXQs8JP0G+yg4aOnFOB3sGCzeM8aeTrW7n7XRAzPZV+qjNwBCYTr0Pkk3/DKbxkZ+87YnrJ0R3jJ6O3iaBB0ax6uIN9J7d1T8wckcUTQMDumk0TJswNXbqFaBHabLkpoJLd7hHsA05uxYjVviTuNkzcU621R7pdIVGDE9BfSp5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758561584; c=relaxed/simple;
	bh=WflRnZ/nwBN7c6Ef+qS01DwenH4IuVEFax2x6uQjyJw=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=elLhxs9yj3dReWy4qjdbe5E7219oaWxFUQYimM8uPbgeAK1NhLegBlyfoWBhokYylbINjQ7Hr1jsoDy6+Fnh2/220c2B1fU5ya0ygpu1VC5GpSI2WY69C+5J1R3xWnis/wFfYNaQLas8gvuZisc1d6coNloSfpFE7ws/GZUzAkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o6/EfNHr; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58MHGU0k010287
	for <ceph-devel@vger.kernel.org>; Mon, 22 Sep 2025 17:19:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=WflRnZ/nwBN7c6Ef+qS01DwenH4IuVEFax2x6uQjyJw=; b=o6/EfNHr
	N+El7FvLHMrWaXnDrrsAVAvRNwN5IX54B2iXbe3ijv4Bjjy2AZKHlkQ+IcBnlmZQ
	VdDPTeRQs5m4UfTI8/naCbGRsfmNhjf7N1+hzGLmEPH8nuG9imKYEjxq+PHoqXJC
	3S1KnfKJ0frqDqee6NKo4pzoEahSVvZgrKKeysAUQ3vL/F5sAGbnmjmtbWhhDh4L
	hAo9xmi9rdttj34wKXQGk+IkcOW6MuJJ4EOI4NLM2f8sWYCe+CF7VAhEDVobF5y8
	Gt9o9BJ9DsJa4a1J6eze7q9j79sjMEe7uGa+YX5RHOeNtSBuyaawt/gt/7aj0Tl7
	HbqZJvze4CMxng==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499hpq483b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Mon, 22 Sep 2025 17:19:41 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58MH8wHW015750
	for <ceph-devel@vger.kernel.org>; Mon, 22 Sep 2025 17:19:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499hpq4835-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Sep 2025 17:19:40 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58MH26Hs001294;
	Mon, 22 Sep 2025 17:19:40 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012008.outbound.protection.outlook.com [40.93.195.8])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499hpq4834-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Sep 2025 17:19:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M7fjg7Ef9Fx8QfU/YC6If4ke6fE3w35yBqaA8Qw6vf51podvYC4/5JdBY7nX4PvYIZAWTANPdChIRCRkIYGkMMorfIDlj+nWJvJW5ucRKAT1UVqRCQjoT6ObgXq5fRq42tQ3kYrx+hbzgKece8yOuJRhtntpYAo4W+R/KCXILUDXR/zf7j8cnJ1efmVo/mf7RGinXNkt0pu8yUtObmkoloK33jHlwHHU2nb8hWa1SqQU+9BUfHumzFgpTcev7YtjFKOv2zfh38IY7Kk6EQyW11nscHwwc8IDzHD55U0QjVsxiAUb7dxGP/7nJcZf/oiSCrKKtER25pn+BrhuhPQAgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8YrH22i0jtlOUL2x8BOWh6iqLph7XM50Kq1eW+7L7vo=;
 b=xsZweGCxw8QR4hk0XTXakVtLYlezKIWiCzlFIr+eGpoXFxvsM0Sd/SoqNUQZiW+HND28LLDMW541zYwYYutbuDvjP4FPV1P2g+URctl+/3GaeEMST7OVJNHtpuLB4IGPVjJSfMvEyDWpyqccv1WyrSwzj8Q4CHkXR0ooOIkanQjaxxFXMZ8U/ISS2sE/Yyo4/BKoryVIQYywYYkfZ8NNBgJVj+q5/WWL7rd66lMb6wsXjBRMec5FDbsWzZvG25C1r9WLHJm8zpWWDCI3vGmiQg/ucabjQ8dPqnEi9oY00lLxOvXvuHcGgO7sFOPNquWG27EzuH3O1Wpf4W9iMuVVgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH0PR15MB4494.namprd15.prod.outlook.com (2603:10b6:510:84::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 17:19:38 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Mon, 22 Sep 2025
 17:19:37 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "lyican53@gmail.com" <lyican53@gmail.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Xiubo Li <xiubli@redhat.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] ceph: Fix potential undefined behavior in
 crush_ln() with GCC 11.1.0
Thread-Index: AQHcKQ3x2RlbiGvXF0GmNaNKGmqQ67Sa2qgAgAEhUACAA3wPAA==
Date: Mon, 22 Sep 2025 17:19:37 +0000
Message-ID: <2eddc77bea32f3baa47cfb1bafb4e20edfe00417.camel@ibm.com>
References: <1AD55673-B7F4-4DB7-AE80-1AC81709F65A@gmail.com>
	 <e6987f0268bd7bceddbd6ec53fa174d07cfa3114.camel@ibm.com>
	 <C8E92D42-0336-45DD-A415-EA8588DE731D@gmail.com>
	 <d6ccd709466d1460baf6e9b0bcec212007172622.camel@ibm.com>
	 <A246BD33-C009-4C12-94E7-E95CABB94D04@gmail.com>
In-Reply-To: <A246BD33-C009-4C12-94E7-E95CABB94D04@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH0PR15MB4494:EE_
x-ms-office365-filtering-correlation-id: 8462dcf2-d001-4ca1-c091-08ddf9fc34e6
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?cGExUUc0dkt2dDdQU3BtcnpqRVMyMTlJWld6R2ZCTG5PMlp5T3NDbXNSZEVj?=
 =?utf-8?B?T0RWTGF0cWFxWVg1dkJwVDZReUFZemFNdkYyQ3hyQmo0YmlaSUFUdmVOeHZN?=
 =?utf-8?B?SnpQd0pUR1FtdEF2WjJzei9KWExRTjdkWkpFeEozUDFVSTNUTVVXV2hveURk?=
 =?utf-8?B?amh3TWFJZXk1UEVWZHZlSUp5Tnh4c1FsWDRsa1VNQWJqZVk0UTJRT1V6b2xk?=
 =?utf-8?B?QitzSkdBb3RlRnZRTzR3UVFxc1JYc2RqNkQyODBLN3pHc1pGUU5nbVNNVUt0?=
 =?utf-8?B?WkozSGdaY1hQV0pNcHdFVVJKWkJ1aVFiSVFHYVhCc0V5U1U2MnBsbGhGdXdP?=
 =?utf-8?B?TDNsNXY1cnlCQTBYVG9TWjRPTitOSk9MZENOQVFtamdUV01XbmMwc0tWcGRH?=
 =?utf-8?B?dStVdTZqSTZKZm9mZ1dyRlFudnVJbktmUU52WVRWT2JxenMrTmVqQ2oyUmFl?=
 =?utf-8?B?SlZnV29yKzJ0T1diNnhiR1BCaTMzYlFTeTZocjA3SGJnSEtEdTJVYmJKbXc5?=
 =?utf-8?B?dW1CRlFyV3lCMEdvOG1PU2JhN3VnMnhRYmJSNE9sdCtWQTZuNEg3VWNJRmxt?=
 =?utf-8?B?L2xPeTR1S0g2M0E2QTRrTWJxYy9UemZXUC9SNUVpUVQ3TlFBVTRzaWhka2lt?=
 =?utf-8?B?RlZsRi9wUjBWaytRTUExajRjN1VZb1FSQ2xsSFZQeTZtdnE3SkxkdFRJN1pH?=
 =?utf-8?B?OUd0K04vU1JDT1V6NW82V2tVMHh2U2xuWHVtVngwUERGaUJqRFRGZzF3K0JE?=
 =?utf-8?B?K1lWdk5EbkYvZ2NJdzJ2VDRHWUJQdld6WTdVTVFVNTZrc3VvNG9tUjlSQlBD?=
 =?utf-8?B?WXFZR0xZazdBbHp2VDRhYmhEVzhpVCt5WEVGdWh0aHZJNU9wQ0lSN2xoaCsw?=
 =?utf-8?B?ZnlxRjZmVjBOTlBZajRjZlpSdmU1RTh1YlkxQkp5NERmd2grdXBwMkNRRlFN?=
 =?utf-8?B?UEVra1JqT3JEbzIwck9GSGdtdTNmY3VlV2xpSWFWdlhaanh6ZGdmK1pqMDhn?=
 =?utf-8?B?UU1mbTNEQSt1ZlJBZmhNY2RFbHhWZkpsb0JtU3RVem0vYzZlWVJFVUFrTGpO?=
 =?utf-8?B?R3dPTDYyUm5KOTdvc0g1NDVSSm9GdFZVQTUzbFU1L2VhNSszZWN1dkVtQ1FL?=
 =?utf-8?B?RGt5Wk1adXlqODR3NmNEZHB1ZVAyR1dENXVRTnNJTWdITHN4enlWeXl6aFBS?=
 =?utf-8?B?TmpwSkVlV2gxOXM3dHVIZCtvYmNuaFUxSzdGUmZoc1hteTV4Z0ZUeGRrWWpt?=
 =?utf-8?B?VHpsemtwdnZwc0J6b0NUUWlrNlUrREpQQTNZWmNTZGVsaWN6STZFWm04RUlh?=
 =?utf-8?B?L2xocVk4dGZxemVZNHd2R01BR01LMmkyQW91WWJqRmJ2TXZrU0JsaDZHVGJs?=
 =?utf-8?B?aWcyWHo2MlpOb3JBdXI3MlRScCszU3p6Y2FUUHRURmhKVEllUU1PYjBKaFE2?=
 =?utf-8?B?b2NkU3dqUjc4ZFFyS0xhWWsybXpIUHZuMVVvZ3JwcVA3QXQwMGZVR1dMOWlk?=
 =?utf-8?B?Mmwwc0FQdGVZZTg3Vll4c0lvZkhCOHVZQXFEZGM4K2YreU41WTBmZnV3d2Nk?=
 =?utf-8?B?ZEhBeWFUVUhleDRVRXRyMnZDWHBIdVlWR1llbXliUnAwYTR0SVo1TzZ4K1Jm?=
 =?utf-8?B?QjZkR0x1SmNEbGtWcW93am0waUZqR0UxWUMyMzgvdkJvWEY3VW51L2xjdzc4?=
 =?utf-8?B?SzZieU1lc3VZT3pLamIyQzFJU25OQXdKOXNwWmlDenpLRWRKdmhyWXZOclpO?=
 =?utf-8?B?bTh0YjVhMml4aTdoT2xrMnpmWDREelNpYS9TMFoxN21uSjVnbFFqTmxyN2Vq?=
 =?utf-8?B?L2VqR0VyRmJUSk1pSk5hajRJYmJ4SWRQaUwzWW9MeHBQdjZ6YmVjMGpkUmR2?=
 =?utf-8?B?ckZrSk5DenZFZ1d6YTRIYVBjRnJXUFF1bVFWQkVySjNBZmpENVZ5QnhRNHY0?=
 =?utf-8?Q?+MaSHHreg9w=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?djJwNTV6OHhaenNnNlVxQzdzZlB2OFF0TlZPOE93TjByTlQzU2NmenJoWENk?=
 =?utf-8?B?bjNRc1Y3L0pSaUpJTS8rZjNualhPNHY5czNnZS9LSnVTZW4wRFQ5WGtKY0Vi?=
 =?utf-8?B?SG5ONWRMdy80SGdtOUdyK213TWVmSEdFdWlOOGpEdU96WVZ0QlRXYVRnQ2hj?=
 =?utf-8?B?cS9jWDNaVFNjOVk2QkEwZ2VGdjlsWmZLQ0tjMncrMU9rTkkzeXp1dmhETmEy?=
 =?utf-8?B?aTBIeGR6NXQ0TFJuQ2J1RlRnenFYQ0ptNjdQY2VQcGcyU3NOQzdHYzQrOTBT?=
 =?utf-8?B?UzE0cUwxSEllb3k5dzk1clZIaFU5QkZOYTJJZ216a1ZxZEhJRjkrNlROVHdq?=
 =?utf-8?B?NUlkTXFJT3FrMjY4Z2h2d0YvWmdVOHlocG81K3hsN3E1TEhLSTJCeHVzUVZL?=
 =?utf-8?B?Q1VUWXRBemZlRmVsR1NPS2s2LzN6bTdsZjc0K1p1Mk1SWVp4T1dUUEZnQ2pP?=
 =?utf-8?B?dXorL3M3K1FYUGR0UkQ1aVdWVS9DaHFQUUkxNHJXd0wxSEx5SzhvWUltYVVP?=
 =?utf-8?B?WjlCb0tIRkM5ZjF4WmpiWDZCK2VMZkFEcUNyZEdZTFZnbk1oU3VXbUtDWmN2?=
 =?utf-8?B?M3ZQZXd3bmQvR09IT3V1eGxDMFllOXJDZmJYcCs1RjYzdkwzR2pQb3VGM0Z3?=
 =?utf-8?B?bmt4eU0xZjRDQjFvQWZKaVFvcER0bDJNb2wySm1YWC9PUUdSK21BS3JyT3pn?=
 =?utf-8?B?bW1ZTlNtV0QzbFpDK3cybVBYanJOQlh4OVhzcEx6bWtsa3dMbW1iengzazZi?=
 =?utf-8?B?SFBzN1ByT0JkekhEc3lNQVFxQVQrb2JkSEF2TGQzYkxLWG43cEc3NVdCY3k3?=
 =?utf-8?B?c28yeTgwZ05FeWU1WTBjNFJjczZkYW0zZjhTSVptVXFLdWVieWViNnJzSXcr?=
 =?utf-8?B?SnB2YytNdGh4ZjhyQ29RQXZBMzJxZWVwSk9xaE1TMEhRN0NOTjlDeGp5ZnFp?=
 =?utf-8?B?d3Q4WGh5Sy8xTVNLUGdURjNzWlRNWUJCQUQ1eDRaS0FLbGhCT0dMOXVZWVE2?=
 =?utf-8?B?eEt4R2hGdGoxa0UxaEdtS3Frc1N2SlVpQlRSTGZYM3R3bGdmQkU4dUgxdXda?=
 =?utf-8?B?aFphNXA2d0pneW0zeTZIblQ0T0MwUWhYTlo2Q3ZnVzZYaURLaXpHZFlsNS9v?=
 =?utf-8?B?b3pJNVRkS3E2eDJ3L2EvK2pTdWtUazZkQ3c3RXd4UHBBSjcxNmkwSHNZaHB0?=
 =?utf-8?B?UGNXeGQ5VURLaDFleFJ6SjdhNXc3Z0FVR2R2RzRobzBleDZlZUh2SlphRU4x?=
 =?utf-8?B?MG1UdERWdWt0WFgzSnJGUXF0TDNOTWFRaDhlQXpmVmV1L2F5NmlRL3ZhUWRu?=
 =?utf-8?B?TjcrQmp3QmR0dm1senlHSEw5UStucmxiZVc2L1RHWDYxOEJLQ1BZQjVEdUpD?=
 =?utf-8?B?VnRCc3FrTGp5bFhPUkgrNFpOV1VudzFQUjJmZ1diRkQ2dnJ0NENzTmVST1U0?=
 =?utf-8?B?MnRQaHI0bkg4SlJZYmFURDV4WnZOa3A1aFNkMlgrVHJTV2VGUVVBSGR6RUF1?=
 =?utf-8?B?SnJaSWttcXBhTHhkd0tJaW9MYVQwL2kyVHRXMjEwRElaWUo0RGI4eVA3d3Q5?=
 =?utf-8?B?dmdRTE9tTEdWVFF5ODRyb1FCUkRPV3lPVUw3UzBuSlZ3T3Y3QVpDdFU3VlNv?=
 =?utf-8?B?VTgzMFl4QnFCSkpOODg5QTJnY0NzSlkvL1BlMWNRVG0zTUk4c2Z6WGVSVjdU?=
 =?utf-8?B?eHVoZDJKNkVVU1BNSm5PT0JCMlRiYnI5UThPWXNUck9QOUtteW5sb25zRysy?=
 =?utf-8?B?U1Jhb1dKZDZjeTlYZjdhb0J5YUhhdFgyejhUYUtlL3B4aWY0N3dhalYvbmd3?=
 =?utf-8?B?S0FrcDVTKy80K1hBZFlwRUZNZGNEQmdjMGx4eWtER0JRMUVxODlhSHIvUm15?=
 =?utf-8?B?cnBua01oMzJucWlxa01za2U2TS92T29LOFIzaURUNC80SHhXZm5PMHNWT2x3?=
 =?utf-8?B?bkRMVzUxZ2kydnA3S0FrQng4a0UyVHNyTnYzUXF3enpjL0x4cm1kaDQ5V0ha?=
 =?utf-8?B?SUdJUjV4enZPQTlMSlBiZ0tOWnp1dkZPOXNkUGtyRUFRZTFYdUFkaVErRTcw?=
 =?utf-8?B?L0R4N2J0VWZTeUNrcjVtNkhaM2IxOXMrcytpUWp5L0VwWit4VTd3cTByVFF4?=
 =?utf-8?B?ekszL1BhanhjazlUMlRYTXdIVm00UHpyQkxjbFZCYm1YK1FQTHBRYkxTL0NP?=
 =?utf-8?Q?QcVJpZFgGLJrxhatvCXzHFU=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8462dcf2-d001-4ca1-c091-08ddf9fc34e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2025 17:19:37.0944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AVa3Uw3hZh6/FRrNMBleR/XeVcExJTJifVJAZGMX8zP/aTjEqvUeSyu1TFSXfEw6gSk/84119tRXE1BzphmPDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4494
X-Authority-Analysis: v=2.4 cv=FrEF/3rq c=1 sm=1 tr=0 ts=68d1852d cx=c_pps
 a=5ppPJOB7bB2hO4guNQQ//Q==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=P-IC7800AAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8
 a=njcMwL8ce5bqlsCUKUwA:9 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-ORIG-GUID: pSd_dcoKs4vMq9sgsiV7JUSeENt_7izc
X-Proofpoint-GUID: awl1RiuumUkDBg45HEh5K0OUlUHmqqlW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE5MDIyNCBTYWx0ZWRfX6iJlEDi6rXnM
 RYK64BSrhQxaoU6h+kchA/PA1L67aGGi6y6b8H5l6BBkyB1D/nd9iJ6jImS5lmmM62uDdQ0ZHcz
 C0V6prZ/2EDPnKF84Qs5Fd1WX2+1LrQKlgvUp8qKbJccm04J1Xcw8VJW8JDvOhXIseg2CWHnnbN
 PlHPzOr+EGnvLW+cJu7byQhiZy4VhkUkRCoqZsaY8ZkfbAlNT/nPHLpWAaS4JNZxTjbPqgeIPir
 e3k6UmIeP0zo3kcSgezoKwszT1UPa/bT34Ps5IcaSzVw62JaRh2zhpPLmsHT7uH467Tba1x51mM
 V+j1NS/K8JeXOh/z1EnhxC30vGqv2Is9vFuKiLEZXmgkW4+Gq5ueIdfqXiJCWfh7NBolTkJHqbX
 1IDGeGWM
Content-Type: text/plain; charset="utf-8"
Content-ID: <D918D8133182984E97580497A253DADE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: RE: [PATCH] ceph: Fix potential undefined behavior in crush_ln() with
 GCC 11.1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-22_01,2025-09-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=2 engine=8.19.0-2507300000 definitions=main-2509190224

On Sat, 2025-09-20 at 20:06 +0800, =E9=99=88=E5=8D=8E=E6=98=AD=EF=BC=88Lyic=
an=EF=BC=89 wrote:
> > 2025=E5=B9=B49=E6=9C=8820=E6=97=A5 02:51=EF=BC=8CViacheslav Dubeyko <Sl=
ava.Dubeyko@ibm.com> =E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > On Fri, 2025-09-19 at 10:34 +0800, =E9=99=88=E5=8D=8E=E6=98=AD=EF=BC=88=
Lyican=EF=BC=89 wrote:
> > > > 2025=E5=B9=B49=E6=9C=8819=E6=97=A5 02:07=EF=BC=8CViacheslav Dubeyko=
 <Slava.Dubeyko@ibm.com> =E5=86=99=E9=81=93=EF=BC=9A
> > > >=20
> >=20
> > <skipped>
> > I still have the same issue with the new patch. Your patch is trying to=
 modify
> > the line 262. However, we have comments on this line [1]:
> >=20
> > 260 /*
> > 261 * figure out number of bits we need to shift and
> > 262 * do it in one step instead of iteratively
> > 263 */
> > 264 if (!(x & 0x18000)) {
> > 265 int bits =3D __builtin_clz(x & 0x1FFFF) - 16;
> > 266 x <<=3D bits;
> > 267 iexpon =3D 15 - bits;
> > 268 }
> >=20
> > Thanks,
> > Slava.
> >=20
> > [1]
> > https://elixir.bootlin.com/linux/v6.17-rc6/source/net/ceph/crush/mapper=
.c#L262 =20
> Hi Slava,
>=20
> Thank you for your patience with this patch. I want to clarify the confus=
ion about the line numbering.
>=20
> The patch header "@@ -262,7 +262,7 @@" was automatically generated by git=
 format-patch - I did not manually specify line 262. This is how git diff f=
ormat works: it shows context lines starting from line 262, but the actual =
code modification is on line 265 where the `__builtin_clz()` call is locate=
d (exactly as you referenced in [1]).
>=20
> To be absolutely clear:
> - I am NOT trying to modify line 262 (which contains comments)
> - I AM modifying line 265: `int bits =3D __builtin_clz(x & 0x1FFFF) - 16;`
> - The "@@ -262,7 +262,7 @@" header is git's standard way of providing con=
text
> - Git automatically chooses how many context lines to show and where to s=
tart them
>=20
> The patch content clearly shows the actual change:
> ```diff
> - int bits =3D __builtin_clz(x & 0x1FFFF) - 16;
> + int bits =3D (x & 0x1FFFF) ? __builtin_clz(x & 0x1FFFF) - 16 : 16;
> ```
>=20
> This line-by-line diff shows exactly what gets modified - line 265 in the=
 official kernel source.
>=20
> Here is the git-generated patch:
>=20
> ---
>=20
> From ac3a55a6a18761d613971ef6f78fa39e6d7d2172 Mon Sep 17 00:00:00 2001
> From: Huazhao Chen <lyican53@gmail.com>
> Date: Sat, 20 Sep 2025 19:42:54 +0800
> Subject: [PATCH] ceph: Fix potential undefined behavior in crush_ln() wit=
h GCC
> =C2=A011.1.0
>=20
> When x & 0x1FFFF equals zero, __builtin_clz() is called with a zero
> argument, which results in undefined behavior. This can happen during
> ceph's consistent hashing calculations and may lead to incorrect
> placement group mappings.
>=20
> Fix by checking if the masked value is non-zero before calling
> __builtin_clz(). If the masked value is zero, use the expected result
> of 16 directly.
>=20
> Signed-off-by: Huazhao Chen <lyican53@gmail.com>
> ---
> =C2=A0net/ceph/crush/mapper.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
> index 3a5bd1cd1..000f7a633 100644
> --- a/net/ceph/crush/mapper.c
> +++ b/net/ceph/crush/mapper.c
> @@ -262,7 +262,7 @@ static __u64 crush_ln(unsigned int xin)
> =C2=A0=C2=A0* do it in one step instead of iteratively
> =C2=A0=C2=A0*/
> =C2=A0=C2=A0if (!(x & 0x18000)) {
> - int bits =3D __builtin_clz(x & 0x1FFFF) - 16;
> + int bits =3D (x & 0x1FFFF) ? __builtin_clz(x & 0x1FFFF) - 16 : 16;
> =C2=A0=C2=A0x <<=3D bits;
> =C2=A0=C2=A0iexpon =3D 15 - bits;
> =C2=A0=C2=A0}

I completely lost myself in the multiple versions of the patch. Could you p=
lease
send one formal patch only that I can successfully apply?

Thanks,
Slava.

