Return-Path: <ceph-devel+bounces-3746-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A66DBBA5451
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Sep 2025 23:52:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1712188E61E
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Sep 2025 21:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25CD2848AD;
	Fri, 26 Sep 2025 21:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H74uQm3l"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1E9283CB8
	for <ceph-devel@vger.kernel.org>; Fri, 26 Sep 2025 21:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758923553; cv=fail; b=oBtw8L5aCDairY/Lyk5NJv1H2uAQcIfe0l3z5DQbT18S8A7aJouUBL5rWInu3Wv0M/H0dJ72GgLtFY/oka1dNlcvVaArAA/o1K/E2+yZQ+cDUjcob3IcIH7sllMjxIb8fW+3GyYfuC1ihAmt0cs1BHDFKRI28ghPsyVgv7j244w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758923553; c=relaxed/simple;
	bh=8Sin9AYh/9svzqQ2RKLpZy5lObgI9JS0ZMFk1O2E7D8=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=qXQA7upMX0vvoZHLmXhyDcOTYP86NsA1a7BQXCkN6FS13W3DrBi6A8rEkwOUlQnK1IOZWlCrp48h8lU6RruyvePOXNeFQH0eIO3/kL3G5hoBWbfZRY7vakAzyUf5W+TaZE5ExVGVa8+qMV7EY75xgX6kovVyrST6zn4ZQdBBZZc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H74uQm3l; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58QHK4UA029827;
	Fri, 26 Sep 2025 21:52:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=8Sin9AYh/9svzqQ2RKLpZy5lObgI9JS0ZMFk1O2E7D8=; b=H74uQm3l
	g1VcD6vC4mAQPw8g3IS4np5sGSiObY/DV8xyqzySpOgd57RkSfnYuixP5Hokr8MF
	llKsF4S3pnAw+Vbis9OFasC6BQfm8GxtFhnMBybg8KYU8MWsADc1pS5R+Tfijk0i
	pnX6qAHmASS3Cli+Z+27ZYB3BRKl5yzRXEU9r7Co2q6gtZ98YIY7lepGMw/iQkqI
	orXe3WKbB6BVb89bV9bfVZzD/cBrgXyRt+sbUnzU9mnyVguvB6yIMp/giJmqkNRH
	zEcBPGhvTYY9DeYAs7WGb2bRndvdcm7S1cLiiFaZA2AAWAHkYR8Lrfw8mhihyBF6
	rcc2oFzNeylhGQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49dbbaqb6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 21:52:17 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58QLqH2W016720;
	Fri, 26 Sep 2025 21:52:17 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011045.outbound.protection.outlook.com [52.101.52.45])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49dbbaqb6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 21:52:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YPXiSfYAeHMmlWI94wTqUry4uNr2IaAwGhGaotIsEnJ3xV4IehsqL/i8BVwC6fnKiFBt2MlQR65K0wG5TsJ3gljg6POskImvpX9fbN0V4H8lU1Hy8GH2iF2+/lUCjpPs3ygklVyiymf737UVy98Q+ghagdw91W9sTFmjzlPpuBMLng+ToLJ33riWOPtZSzfR7iTVk0EHEAhC+5OZC4prj6I3zjVM3BRctWo3C/ajVvBKQLd2NzPoYpOeavgv6+SkP/WecDwIDSi7Uarch60oK7uNqEP4vJFqfh6vDK9iOWd8FvSplw5DrBGYsfVIGEheTx7zsBOuablXYKtNzc9Wqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Sin9AYh/9svzqQ2RKLpZy5lObgI9JS0ZMFk1O2E7D8=;
 b=FVQPcW/l/A1JGsuokJAvjSlfvXraUOKc2Mdyl4tEjKr6HiR+8VgoGRKIuhd9tzK7GXWLnl4oG0qzPibR2ARVaHo7TIyj+4mYsZIqfk5od9e9rTk9Yi7uFOdKzDdJIaFCRTLQ1c0CIlg8vhC+Jv/LEB5pNp0Z9trLDy53B6tOumKZLvgp328oGgbDNFj1rxByh36DxifIXfIjqFBY4UHlIBQg05o8gBv9y8XNTOsdhE9NU0AqRGNeILQ2tyhrRZFjMXRcsIKc+ydNQhmqeGb+SDXU8+IX52u/LUGE3NDWVtqtCUyCo9K7ZAIWORWRZQgjq+dAvHJEuP3V/s0Y+NhLEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CY8PR15MB5846.namprd15.prod.outlook.com (2603:10b6:930:79::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.13; Fri, 26 Sep
 2025 21:52:13 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Fri, 26 Sep 2025
 21:52:13 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ethanwu@synology.com" <ethanwu@synology.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
CC: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
        Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>
Thread-Topic: [EXTERNAL] [PATCH 2/2] ceph: fix snapshot context missing in
 ceph_uninline_data
Thread-Index: AQHcLgkuSY0IOiWvkEazrLlRWMCorbSmA4+A
Date: Fri, 26 Sep 2025 21:52:13 +0000
Message-ID: <b7d93760bc06a4ca6b27f9043cb8310898cf48a4.camel@ibm.com>
References: <20250925104228.95018-1-ethanwu@synology.com>
	 <20250925104228.95018-3-ethanwu@synology.com>
In-Reply-To: <20250925104228.95018-3-ethanwu@synology.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CY8PR15MB5846:EE_
x-ms-office365-filtering-correlation-id: b1a6fa25-a04a-47d9-a685-08ddfd46f3cc
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MkNkMFJ1UDZwOEN4M0dGcUFldDhFSXFQUHVoMDdTZmdIR3o5WUVUbWhUd0Zj?=
 =?utf-8?B?Q2FHTjRrdThoY2xsUWhNTEhJcUJKR2NyQ0M2eW54NnExNktHQ2hGSng1Q2Y4?=
 =?utf-8?B?c2kxWG1sb21YdEI1OGVQNy94bkdUK2t3bXRJR3d3UllGVUhkc0t1dWlzbXY3?=
 =?utf-8?B?TGw0TjhaczZqTGtvSG5uNFRCVWtrTi9vY0VRNTVSR2xVbW9vMCtsWlZpVjJ5?=
 =?utf-8?B?NHNOOGQ2OU8rVklDbTgzVEVXbEpyK3ZsTnNtS0E0NlNJUDRPWTh5NFh0Y2hT?=
 =?utf-8?B?VGt5TS9LdjlpOFM1c1pDRFVXKzk1dHVtbEZkT0dPNEtvOTNyN0hsUFI0THJw?=
 =?utf-8?B?cTJ3RUJYdE5IRDd3ZVNOSTZNeDJOUTVWM2dUclBQa25QMmFBa1FEc2lST0NF?=
 =?utf-8?B?aUFiVUNtVnJSaDJTZ1NaazRMSEFvTXdUQ01uUGNQSEd6UWdtUmJBTXJOWWxq?=
 =?utf-8?B?aTlVU1IvQ09BS1JaSWd5QXFTamp3SldSTGROVnhCZUVKLzBIaHhGL0c3OEFi?=
 =?utf-8?B?SkUrM2RGN0hZc0Y5RU9GMzBmcWlQWDBHK0pLSkZpaDltSlNJeUN6Z3pjNHRO?=
 =?utf-8?B?bExwQ2p6eGRndXQ1TGZoeDhISGhScHh3ZHBLSVhlUG0vTHNrdGtIZ0ZjcFZK?=
 =?utf-8?B?elorWnVRd2NlYVpuL3pwb1J6OHduWmZKZVJSVGRtN3dBUEVYQzlIaGF3Tm5V?=
 =?utf-8?B?MHpvRVZLc21hRnVjd0VXQU5LcE82NmZnU3E2cDVYdFdUZEtXWnE0emhJaklH?=
 =?utf-8?B?cmo0RW83dXpadkxpaGwzTlNRbm9kTGtZVC9hbjQrSzBjeTBIWndRbkNBL1Rv?=
 =?utf-8?B?ZnZyQitvbVROTngwSTJlRHpPY0NtZVZzR1c1OVNNanpJWFBrenMwRC9IVVJ4?=
 =?utf-8?B?LzJIZE1TUGFqTUhLUVhFNkd0QVBsbHVVL0dqSkVtdDdUd0liR1pZRC9IaHFP?=
 =?utf-8?B?NUZVVUZ3dU9hTnM4aEYrbVk0WDJHVFFmRW94Ly82WjQ1d2JISFdRbXpENWxt?=
 =?utf-8?B?U0l2MG93ODJlZWxLZ3V1ZDNtaGJxMUlTNDFVRk9hYjVFZXo3S3BORUR0UnBP?=
 =?utf-8?B?N3pnR0EwbXczYzZielE3NEEwZC9rOHRndjZnV0lhYlQzNWpGZGlJOGhtK2Q0?=
 =?utf-8?B?UUFsMjkwS3JkRHlaZEFWS2FCNUhZQUFHa29LcGVFWHpkTWY0eGhteTczaHBj?=
 =?utf-8?B?eTk3WXlaZTFMZUdvWXdYYnlZN0RqR3BRcFVCbG1uWjdQL3NDcUxIbjBGOC8v?=
 =?utf-8?B?V3EwUVZGWmt0cVE3ak8yVmh4NmVKZEF3OUJFcXJLSWNqc0xNTFBkMzFqMCsx?=
 =?utf-8?B?Tks3Smtna0NYS0JUL2JPQ0syM1NCM2xYc1JiWnJENkU4QzFSRldaRUU4WGJ4?=
 =?utf-8?B?aUZ1eGcrMDFuZkZkUGllelNRbW1NbjRWdWRWblJ4RDAwN2ZpZHpvbVR4cnZh?=
 =?utf-8?B?T2J3WFNyOGVlWC9IRGd3c3hDMlR2K1JaQnp6K0FVamNXeVZaRzRNTi93NHJ4?=
 =?utf-8?B?b0wxcGRlMk5nbWFoYTd4RG5kWGJBZzhxRGtmbml0MkhlSitJQTVkMWJRVHVV?=
 =?utf-8?B?M0hWQ09IUnVBRFAxR2hlVTdnd3F5VmlsbEF1Y01uQ1RTeFA2ZERZWFVpWW5G?=
 =?utf-8?B?SXRrbWp1Z0hoa25FaXVvSU5wK3NvbW5XSllQMmpuM056SjJOYlp4aEtCS2xq?=
 =?utf-8?B?ZTgwVHVoU241WFE3bHRLdWxoMVh3cmo2TGVTdWtJcVJyeW91K1RYT21wZzhP?=
 =?utf-8?B?eVVzd3V6eTVtVmZvU09qZm9uZ3A3TktrcGZnS1k0ZGF6UnlyRXFJc1lIUXl2?=
 =?utf-8?B?Mkd5VnVzYUppRGdIakJGdmVLeHhLRnJGZUlHa2E1dE0rYUdZbVdqNklVTjJI?=
 =?utf-8?B?cGYyL2o4SUZNcENYNHVHVWlaUjdLdFBLcCt3R2pIRkpVRDRGVzBvMy82OHhi?=
 =?utf-8?B?RGwyZk5tcmNYeWlybnpkN1E1RWVLSUFRcmRTanA5MFFhRkJKcXVmUk83dEZp?=
 =?utf-8?B?R29zQ0FwbVZCcDVjQXQwcVlmWHd4Y0lmejRpakY5eWRiNkhpTWxBMk9JQ3Z4?=
 =?utf-8?Q?UDroje?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MkhvNGZBd1pDb2JNcUFQY3AwYWdDTFBNdjhQNStYMVI3ZXl0Y1hzWnhZOElK?=
 =?utf-8?B?TTFwWVdWU2p3ajdXVmVEY2NpSzNJOXZxd0JqK3RVS3hUUEVibDFtbkVIUXRo?=
 =?utf-8?B?T2FHZm1QWHhLVkhRMTNibFJIR2d6Wm5oMi9Ta1l2ZmxyYjFmVzdMdUZNODMx?=
 =?utf-8?B?Qi8zaFdMT0RXcCtKR213czFieEN4MjZwOVkvd0NSRHZMNk5SZy92Y3NiMUxN?=
 =?utf-8?B?QmtOUGVjNUdYMERETFFFc3F3aERzcEFYem1vLzdiN0FJMVRLS0NWaGg3Rmo5?=
 =?utf-8?B?KytYSXphWEtNTi9BRWxNbWE2ZmFNckF2ZDhRZm9iMXYwVEVIL3U5Mnl5azVq?=
 =?utf-8?B?MFNaellzM1h1eE1kUTlQczZYSFpZUUNPZFFtYVp0emZuRTk0T2o3dlpqVVRI?=
 =?utf-8?B?czA5UGswcDBrdDRlcUFCRUJSRFlXR0IvelQ4RWVRYWJqRnFhQmlJQ0ZnbVFN?=
 =?utf-8?B?c2M2UEs1UjRRNzRFWXpoeUVEUUkzZ1poTzBFZWdvODR0V2JQTXVFZE1YMTgx?=
 =?utf-8?B?eHEyNVV1eko5S00waEQ5eDNZY1R2STBNQTEyUTR3ODEyNTVLWjRaQ3JEc1di?=
 =?utf-8?B?cFU1R2hmckpkcW5VZS9jd3FQck5OVFNIVFk2bGFHUXJGZmpqZTJoNjVzbDZ2?=
 =?utf-8?B?WXNmUUdXN3BZUmwvUStycVBRMGZ0VEtoazluYWVRS3VQUjdRZUhmVE5ZQXVG?=
 =?utf-8?B?aXh2TmprWS9kb0xNb1J6UDFxektzQkVTRUlxbVZtcHRYSlFjeGY3T2dDU1BV?=
 =?utf-8?B?Rzc1WmNtbWh6ZHBBcWRIamJJTWw3SU5ZRURCWWd1OFVYU0p4WDZSek9ZREhY?=
 =?utf-8?B?eldmYXc2eXo0c2h5SWtIdEZkK3J5aUU1ZUp1bG1OaFpTcGNPNXZMQlVpSUlK?=
 =?utf-8?B?YWNPUUp5eGQwbk9vL2F3RThtSjdqd2JyUWViTll2M0E2aEVzTk9uU3JsZUoy?=
 =?utf-8?B?UkZsY1VtK1Y3aGJUc003dXB2VHBkS2VUQmVtRHZvbHpyQW9Pa0hEUFVyMDJo?=
 =?utf-8?B?T3U3bmloTFhTR1BuY1dnUjU2QVhQb0hGQXV1MWhrSVJJcEg0SUx1eXhHS1dj?=
 =?utf-8?B?VDhoVWk2Y002WEZ3SWpCbFA4UUZZL3JXMWxTaHRwK0creXhDZUp4VEdCSGZD?=
 =?utf-8?B?L2hQbENKaGp1Y0ljQTdaeFRYRXpQTURvS0dhSGV1bWxzay91MUpJb2M4MkN0?=
 =?utf-8?B?OEh5elBxaHh3bElPYkR1R3JhcXFVTFF5anAwMUw4eEJqU2dYdnBvVmE2MVp3?=
 =?utf-8?B?VU1MU1JpczN1Z2pmMVRtV21oOEFZU2VwT1FlWkxTMWVkQjR2czE2cnlyOVVI?=
 =?utf-8?B?RnNKSjU4NVFJZlVFLzhMZXJaRHRlMGQvdGRVMjdUMTQ5S2VFeDVhbTZSVkVi?=
 =?utf-8?B?WWd3SHJlT28rM2k4Q2d4Z2NTYW5BbWZZN0JkNHprQzMxY2FvZ3hVOWZPdHFV?=
 =?utf-8?B?KzNqU2RQd1ZDZWdwQ3RIY0Fpcm1LUUNnZFdnS1pkalFnbWswZ1JDZ01OdHhP?=
 =?utf-8?B?S05KQVkwelY1ZnhkdFZUZ1dJeEp5eExKVG5IVTBNd0J1TGhKVkxlNi91NzZs?=
 =?utf-8?B?TkpkZEFYZStRSVc5b21DWmhjNlJjV250SGVKTlZSY0RQemdsd3VTNnhnTzVY?=
 =?utf-8?B?UUZqS0JoU0lkU0FpUk1ReVFMQnNkVmdlNmpUcWw3NVlvajJVQWQwSEtMSTJW?=
 =?utf-8?B?M0NHOVVVUmVLNm1Rc3VRN0NFa2pKSlNDc0NEWThOOGY5REZDRkRqZHRLa2JU?=
 =?utf-8?B?OXZlZVdCcysxQ3NlQXhBZEJ6NC9tdndXckc3Mk1ORGJ1T1g1cEplTEEyU0R5?=
 =?utf-8?B?ME1Dai83UksrY0ZZZ0orT29GUmhEM1BPRE5GRGNhYzZheGZJbzlvMjZ2Smtr?=
 =?utf-8?B?OG1JclMxUWhDS2txdlUvWVMwOEQxQ09ZNEpIcXBzTWVwRXJYeDNNRFNIKzhK?=
 =?utf-8?B?c1M2a2U3eGFwSTFqY3l5akkzNUNpdEpKZ2hNdUlBOVBtWm1KMFVKQWhnUm5y?=
 =?utf-8?B?ei8xVlZNSEQyejgzNW8rMDNNWDFyZHRGTXo4UkJsUFpJZTc1S3JSLzEvTktk?=
 =?utf-8?B?c1ZqdzY3S1RybVUrcEVkdnpFdS9MMmlvYTZkRDBBNVkzajc5aGkxS1lPOVdY?=
 =?utf-8?B?aW1OcUlWL1hodnhnaGwyeVU5Mmh6eDNFR05xeVJoL1VCWmtkWmsyYzlzMThw?=
 =?utf-8?Q?EQXo0SOiilMTgH8KeOt+CHo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84C685555B110443BE404DE6808FC5E5@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a6fa25-a04a-47d9-a685-08ddfd46f3cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 21:52:13.6243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dnl8BzZfe6XDhqHyDWe8Mce9/6n6cAyAo2xQElSJpdMpgSnFaGUiPtKRkywHp3Mkfv/2OT+ku87hxS/qbjSUZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR15MB5846
X-Proofpoint-GUID: Fm9D0xyhPIT_jXMgv7vtCwyVIrw9Zftx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI1MDE3NCBTYWx0ZWRfX+2IGLCVHt/3r
 6PhB1vsN8Ap+KqFjH98TmKMsxJCCXFd+/kvoyqRP3aTRJ8fs2XzYA3sSKPaL95aHWwPX2bz9UMG
 YkBQMXqDipYoXEVe/9udj2rs3jRoy1Rv5GhKeFsyh8Uo6SqPcftU4rQ7Y2z/15Ttm9DqjBxDq7/
 eFY4TDfeod+oN1wDJ8LbPVEFXFhS4QkATshpuLHNM9zPLVhLdqNRa2O2sWfUJS78ss/A+noMps4
 2zGARSM4i3/GVunNFpj75dw5VZ6aaai3i8UN2+wS4GeDWxmnxlPvk0XbHeIPhBkPdepg8oK6NX+
 ktNbz7FN/yZfrqgE7siymPiEWW0YrGpi20GY35TImzuJAhj10fqNFpY6g6mFU+DFOoc5EGHTtbI
 amqvcdiWn480cJbIMwLN6vS07vu0zg==
X-Proofpoint-ORIG-GUID: AKaOA4o-trsmFc8JrPdN8qUI_Kfh1K_4
X-Authority-Analysis: v=2.4 cv=B6W0EetM c=1 sm=1 tr=0 ts=68d70b11 cx=c_pps
 a=f/vGOH3Q9iIJglbWlzIglQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=LM7KSAFEAAAA:8 a=MfpOsAsw1qA4csPMs7QA:9 a=QEXdDO2ut3YA:10
Subject: Re:  [PATCH 2/2] ceph: fix snapshot context missing in
 ceph_uninline_data
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-26_08,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 phishscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509250174

T24gVGh1LCAyMDI1LTA5LTI1IGF0IDE4OjQyICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiBUaGUg
Y2VwaF91bmlubGluZV9kYXRhIGZ1bmN0aW9uIHdhcyBtaXNzaW5nIHByb3BlciBzbmFwc2hvdCBj
b250ZXh0DQo+IGhhbmRsaW5nIGZvciBpdHMgT1NEIHdyaXRlIG9wZXJhdGlvbnMuIEJvdGggQ0VQ
SF9PU0RfT1BfQ1JFQVRFIGFuZA0KPiBDRVBIX09TRF9PUF9XUklURSByZXF1ZXN0cyB3ZXJlIHBh
c3NpbmcgTlVMTCBpbnN0ZWFkIG9mIHRoZSBhcHByb3ByaWF0ZQ0KPiBzbmFwc2hvdCBjb250ZXh0
LCB3aGljaCBjb3VsZCBsZWFkIHRvIHVubmVjZXNzYXJ5IG9iamVjdCBjbG9uZS4NCj4gDQo+IFJl
cHJvZHVjZXI6DQo+IC4uL3NyYy92c3RhcnQuc2ggLS1uZXcgLXggLS1sb2NhbGhvc3QgLS1ibHVl
c3RvcmUNCj4gLy8gdHVybiBvbiBjZXBoZnMgaW5saW5lIGRhdGENCj4gLi9iaW4vY2VwaCBmcyBz
ZXQgYSBpbmxpbmVfZGF0YSB0cnVlIC0teWVzLWktcmVhbGx5LXJlYWxseS1tZWFuLWl0DQo+IC8v
IGFsbG93IGZzX2EgY2xpZW50IHRvIHRha2Ugc25hcHNob3QNCj4gLi9iaW4vY2VwaCBhdXRoIGNh
cHMgY2xpZW50LmZzX2EgbWRzICdhbGxvdyByd3BzIGZzbmFtZT1hJyBtb24gJ2FsbG93IHIgZnNu
YW1lPWEnIG9zZCAnYWxsb3cgcncgdGFnIGNlcGhmcyBkYXRhPWEnDQo+IC8vIG1vdW50IGNlcGhm
cyB3aXRoIGZ1c2UsIHNpbmNlIGtlcm5lbCBjZXBoZnMgZG9lc24ndCBzdXBwb3J0IGlubGluZSB3
cml0ZQ0KPiBjZXBoLWZ1c2UgLS1pZCBmc19hIC1tIDEyNy4wLjAuMTo0MDMxOCAtLWNvbmYgY2Vw
aC5jb25mIC1kIC9tbnQvbXljZXBoZnMvDQo+IC8vIGJ1bXAgc25hcHNob3Qgc2VxDQo+IG1rZGly
IC9tbnQvbXljZXBoZnMvLnNuYXAvc25hcDENCj4gZWNobyAiZm9vIiA+IC9tbnQvbXljZXBoZnMv
dGVzdA0KPiAvLyB1bW91bnQgYW5kIG1vdW50IGl0IGFnYWluIHVzaW5nIGtlcm5lbCBjZXBoZnMg
Y2xpZW50DQo+IHVtb3VudCAvbW50L215Y2VwaGZzDQo+IG1vdW50IC10IGNlcGggZnNfYUAuYT0v
IC9tbnQvbXljZXBoZnMvIC1vIGNvbmY9Li9jZXBoLmNvbmYNCj4gZWNobyAiYmFyIiA+PiAvbW50
L215Y2VwaGZzL3Rlc3QNCj4gLi9iaW4vcmFkb3MgbGlzdHNuYXBzIC1wIGNlcGhmcy5hLmRhdGEg
JChwcmludGYgIiV4XG4iICQoc3RhdCAtYyAlaSAvbW50L215Y2VwaGZzL3Rlc3QpKS4wMDAwMDAw
MA0KPiANCj4gd2lsbCBzZWUgdGhpcyBvYmplY3QgZG9lcyB1bm5lY2Vzc2FyeSBjbG9uZQ0KPiAx
MDAwMDAwMDAwYS4wMDAwMDAwMCAoc2VxOjIpOg0KPiBjbG9uZWlkIHNuYXBzICAgc2l6ZSAgICBv
dmVybGFwDQo+IDIgICAgICAgMiAgICAgICA0ICAgICAgIFtdDQo+IGhlYWQgICAgLSAgICAgICA4
DQo+IA0KPiBidXQgaXQncyBleHBlY3RlZCB0byBzZWUNCj4gMTAwMDAwMDAwMDAuMDAwMDAwMDAg
KHNlcToyKToNCj4gY2xvbmVpZCBzbmFwcyAgIHNpemUgICAgb3ZlcmxhcA0KPiBoZWFkICAgIC0g
ICAgICAgOA0KPiANCj4gc2luY2UgdGhlcmUncyBubyBzbmFwc2hvdCBiZXR3ZWVuIHRoZXNlIDIg
d3JpdGVzDQo+IA0KDQpNYXliZSwgSSBhbSBkb2luZyBzb21ldGhpbmcgd3JvbmcgaGVyZS4gQnV0
IEkgaGF2ZSB0aGUgc2FtZSBpc3N1ZSBvbiB0aGUgc2Vjb25kDQpWaXJ0dWFsIE1hY2hpbmUgd2l0
aCBhcHBsaWVkIHBhdGNoOg0KDQpWTTEgKHdpdGhvdXQgcGF0Y2gpOg0KDQpzdWRvIGNlcGgtZnVz
ZSAtLWlkIGFkbWluIC9tbnQvY2VwaGZzLw0KL21udC9jZXBoZnMvdGVzdC1zbmFwc2hvdDMjIG1r
ZGlyIC4vLnNuYXAvc25hcDENCi9tbnQvY2VwaGZzL3Rlc3Qtc25hcHNob3QzIyBlY2hvICJmb28i
ID4gLi90ZXN0DQp1bW91bnQgL21udC9jZXBoZnMNCg0KbW91bnQgLXQgY2VwaCA6LyAvbW50L2Nl
cGhmcy8gLW8gbmFtZT1hZG1pbixmcz1jZXBoZnMNCi9tbnQvY2VwaGZzL3Rlc3Qtc25hcHNob3Qz
IyBlY2hvICJiYXIiID4+IC4vdGVzdA0KL21udC9jZXBoZnMvdGVzdC1zbmFwc2hvdDMjIHJhZG9z
IGxpc3RzbmFwcyAtcCBjZXBoZnNfZGF0YSAkKHByaW50ZiAiJXhcbiINCiQoc3RhdCAtYyAlaSAu
L3Rlc3QpKS4wMDAwMDAwMA0KMTAwMDAzMTNjYjEuMDAwMDAwMDA6DQpjbG9uZWlkCXNuYXBzCXNp
emUJb3ZlcmxhcA0KNAk0CTQJW10NCmhlYWQJLQk4DQoNClZNMiAod2l0aCBwYXRjaCk6DQoNCmNl
cGgtZnVzZSAtLWlkIGFkbWluIC9tbnQvY2VwaGZzLw0KL21udC9jZXBoZnMvdGVzdC1zbmFwc2hv
dDQjIG1rZGlyIC4vLnNuYXAvc25hcDENCi9tbnQvY2VwaGZzL3Rlc3Qtc25hcHNob3Q0IyBlY2hv
ICJmb28iID4gLi90ZXN0DQp1bW91bnQgL21udC9jZXBoZnMNCg0KbW91bnQgLXQgY2VwaCA6LyAv
bW50L2NlcGhmcy8gLW8gbmFtZT1hZG1pbixmcz1jZXBoZnMNCi9tbnQvY2VwaGZzL3Rlc3Qtc25h
cHNob3Q0IyBlY2hvICJiYXIiID4+IC4vdGVzdA0KL21udC9jZXBoZnMvdGVzdC1zbmFwc2hvdDQj
IHJhZG9zIGxpc3RzbmFwcyAtcCBjZXBoZnNfZGF0YSAkKHByaW50ZiAiJXhcbiINCiQoc3RhdCAt
YyAlaSAuL3Rlc3QpKS4wMDAwMDAwMA0KMTAwMDAzMTNjYjMuMDAwMDAwMDA6MTAwMDAzMTNjYjMu
MDAwMDAwMDA6DQpjbG9uZWlkCXNuYXBzCXNpemUJb3ZlcmxhcA0KNQk1CTAJW10NCmhlYWQJLQk0
DQoNCk1heWJlLCByZXByb2R1Y3Rpb24gcGF0aCBpcyBub3QgY29tcGxldGVseSBjb3JyZWN0PyBX
aGF0IGNvdWxkIGJlIHdyb25nIG9uIG15DQpzaWRlPw0KDQpUaGFua3MsDQpTbGF2YS4NCg0KPiBj
bG9uZSBoYXBwZW5lZCBiZWNhdXNlIHRoZSBmaXJzdCBvc2QgcmVxdWVzdCBDRVBIX09TRF9PUF9D
UkVBVEUgZG9lc24ndA0KPiBwYXNzIHNuYXAgY29udGV4dCBzbyBvYmplY3QgaXMgY3JlYXRlZCB3
aXRoIHNuYXAgc2VxIDAsIGJ1dCBsYXRlciBkYXRhDQo+IHdyaXRlYmFjayBpcyBlcXVpcHBlZCB3
aXRoIHNuYXBzaG90IGNvbnRleHQuDQo+IHNuYXAuc2VxKDEpID4gb2JqZWN0IHNuYXAgc2VxKDAp
LCBzbyBvc2QgZG9lcyBvYmplY3QgY2xvbmUuDQo+IA0KPiBUaGlzIGZpeCBwcm9wZXJseSBhY3F1
aXJpbmcgdGhlIHNuYXBzaG90IGNvbnRleHQgYmVmb3JlIHBlcmZvcm1pbmcNCj4gd3JpdGUgb3Bl
cmF0aW9ucy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IGV0aGFud3UgPGV0aGFud3VAc3lub2xvZ3ku
Y29tPg0KPiAtLS0NCj4gIGZzL2NlcGgvYWRkci5jIHwgMjQgKysrKysrKysrKysrKysrKysrKysr
Ky0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2FkZHIuYyBiL2ZzL2NlcGgvYWRkci5jDQo+IGlu
ZGV4IDhiMjAyZDc4OWU5My4uMGU4N2EzZThmZDJjIDEwMDY0NA0KPiAtLS0gYS9mcy9jZXBoL2Fk
ZHIuYw0KPiArKysgYi9mcy9jZXBoL2FkZHIuYw0KPiBAQCAtMjIwMiw2ICsyMjAyLDcgQEAgaW50
IGNlcGhfdW5pbmxpbmVfZGF0YShzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gIAlzdHJ1Y3QgY2VwaF9v
c2RfcmVxdWVzdCAqcmVxID0gTlVMTDsNCj4gIAlzdHJ1Y3QgY2VwaF9jYXBfZmx1c2ggKnByZWFs
bG9jX2NmID0gTlVMTDsNCj4gIAlzdHJ1Y3QgZm9saW8gKmZvbGlvID0gTlVMTDsNCj4gKwlzdHJ1
Y3QgY2VwaF9zbmFwX2NvbnRleHQgKnNuYXBjID0gTlVMTDsNCj4gIAl1NjQgaW5saW5lX3ZlcnNp
b24gPSBDRVBIX0lOTElORV9OT05FOw0KPiAgCXN0cnVjdCBwYWdlICpwYWdlc1sxXTsNCj4gIAlp
bnQgZXJyID0gMDsNCj4gQEAgLTIyMjksNiArMjIzMCwyNCBAQCBpbnQgY2VwaF91bmlubGluZV9k
YXRhKHN0cnVjdCBmaWxlICpmaWxlKQ0KPiAgCWlmIChpbmxpbmVfdmVyc2lvbiA9PSAxKSAvKiBp
bml0aWFsIHZlcnNpb24sIG5vIGRhdGEgKi8NCj4gIAkJZ290byBvdXRfdW5pbmxpbmU7DQo+ICAN
Cj4gKwlkb3duX3JlYWQoJmZzYy0+bWRzYy0+c25hcF9yd3NlbSk7DQo+ICsJc3Bpbl9sb2NrKCZj
aS0+aV9jZXBoX2xvY2spOw0KPiArCWlmIChfX2NlcGhfaGF2ZV9wZW5kaW5nX2NhcF9zbmFwKGNp
KSkgew0KPiArCQlzdHJ1Y3QgY2VwaF9jYXBfc25hcCAqY2Fwc25hcCA9DQo+ICsJCQkJbGlzdF9s
YXN0X2VudHJ5KCZjaS0+aV9jYXBfc25hcHMsDQo+ICsJCQkJCQlzdHJ1Y3QgY2VwaF9jYXBfc25h
cCwNCj4gKwkJCQkJCWNpX2l0ZW0pOw0KPiArCQlzbmFwYyA9IGNlcGhfZ2V0X3NuYXBfY29udGV4
dChjYXBzbmFwLT5jb250ZXh0KTsNCj4gKwl9IGVsc2Ugew0KPiArCQlpZiAoIWNpLT5pX2hlYWRf
c25hcGMpIHsNCj4gKwkJCWNpLT5pX2hlYWRfc25hcGMgPSBjZXBoX2dldF9zbmFwX2NvbnRleHQo
DQo+ICsJCQkJY2ktPmlfc25hcF9yZWFsbS0+Y2FjaGVkX2NvbnRleHQpOw0KPiArCQl9DQo+ICsJ
CXNuYXBjID0gY2VwaF9nZXRfc25hcF9jb250ZXh0KGNpLT5pX2hlYWRfc25hcGMpOw0KPiArCX0N
Cj4gKwlzcGluX3VubG9jaygmY2ktPmlfY2VwaF9sb2NrKTsNCj4gKwl1cF9yZWFkKCZmc2MtPm1k
c2MtPnNuYXBfcndzZW0pOw0KPiArDQo+ICAJZm9saW8gPSByZWFkX21hcHBpbmdfZm9saW8oaW5v
ZGUtPmlfbWFwcGluZywgMCwgZmlsZSk7DQo+ICAJaWYgKElTX0VSUihmb2xpbykpIHsNCj4gIAkJ
ZXJyID0gUFRSX0VSUihmb2xpbyk7DQo+IEBAIC0yMjQ0LDcgKzIyNjMsNyBAQCBpbnQgY2VwaF91
bmlubGluZV9kYXRhKHN0cnVjdCBmaWxlICpmaWxlKQ0KPiAgCXJlcSA9IGNlcGhfb3NkY19uZXdf
cmVxdWVzdCgmZnNjLT5jbGllbnQtPm9zZGMsICZjaS0+aV9sYXlvdXQsDQo+ICAJCQkJICAgIGNl
cGhfdmlubyhpbm9kZSksIDAsICZsZW4sIDAsIDEsDQo+ICAJCQkJICAgIENFUEhfT1NEX09QX0NS
RUFURSwgQ0VQSF9PU0RfRkxBR19XUklURSwNCj4gLQkJCQkgICAgTlVMTCwgMCwgMCwgZmFsc2Up
Ow0KPiArCQkJCSAgICBzbmFwYywgMCwgMCwgZmFsc2UpOw0KPiAgCWlmIChJU19FUlIocmVxKSkg
ew0KPiAgCQllcnIgPSBQVFJfRVJSKHJlcSk7DQo+ICAJCWdvdG8gb3V0X3VubG9jazsNCj4gQEAg
LTIyNjAsNyArMjI3OSw3IEBAIGludCBjZXBoX3VuaW5saW5lX2RhdGEoc3RydWN0IGZpbGUgKmZp
bGUpDQo+ICAJcmVxID0gY2VwaF9vc2RjX25ld19yZXF1ZXN0KCZmc2MtPmNsaWVudC0+b3NkYywg
JmNpLT5pX2xheW91dCwNCj4gIAkJCQkgICAgY2VwaF92aW5vKGlub2RlKSwgMCwgJmxlbiwgMSwg
MywNCj4gIAkJCQkgICAgQ0VQSF9PU0RfT1BfV1JJVEUsIENFUEhfT1NEX0ZMQUdfV1JJVEUsDQo+
IC0JCQkJICAgIE5VTEwsIGNpLT5pX3RydW5jYXRlX3NlcSwNCj4gKwkJCQkgICAgc25hcGMsIGNp
LT5pX3RydW5jYXRlX3NlcSwNCj4gIAkJCQkgICAgY2ktPmlfdHJ1bmNhdGVfc2l6ZSwgZmFsc2Up
Ow0KPiAgCWlmIChJU19FUlIocmVxKSkgew0KPiAgCQllcnIgPSBQVFJfRVJSKHJlcSk7DQo+IEBA
IC0yMzIzLDYgKzIzNDIsNyBAQCBpbnQgY2VwaF91bmlubGluZV9kYXRhKHN0cnVjdCBmaWxlICpm
aWxlKQ0KPiAgCQlmb2xpb19wdXQoZm9saW8pOw0KPiAgCX0NCj4gIG91dDoNCj4gKwljZXBoX3B1
dF9zbmFwX2NvbnRleHQoc25hcGMpOw0KPiAgCWNlcGhfZnJlZV9jYXBfZmx1c2gocHJlYWxsb2Nf
Y2YpOw0KPiAgCWRvdXRjKGNsLCAiJWxseC4lbGx4IGlubGluZV92ZXJzaW9uICVsbHUgPSAlZFxu
IiwNCj4gIAkgICAgICBjZXBoX3Zpbm9wKGlub2RlKSwgaW5saW5lX3ZlcnNpb24sIGVycik7DQo=

