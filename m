Return-Path: <ceph-devel+bounces-3463-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9FFDB2CB9D
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Aug 2025 20:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E1231BC73A2
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Aug 2025 18:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40DD30F540;
	Tue, 19 Aug 2025 18:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JhT28eEi"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0722D30F52A
	for <ceph-devel@vger.kernel.org>; Tue, 19 Aug 2025 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755626628; cv=fail; b=PZf+aW9I/3B6kc8JpTntdQaeb43b5LC3iuVLNStudfaTzbiQzqw5akKQbxMDYXSRaDSvhgBpkS0zgbcvYP+fzrS1Srg0zS0Sagz3YhwdSawTmZGhajoMYa19O9Gm0HdNdulu1Cupwrxy2xOxtlfP5YPnqwoG86jbijb8KqQ3sb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755626628; c=relaxed/simple;
	bh=0G1QS78B3WJ3N30RHs6zjXgfUR8JM02ywaD3C36HnKU=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=exV5g/ja5ttuyYFvovau6f5FvK7Urmf8u1YlansXTh8KJBxB8133JD3T/3iBmebORy3y3zZtLJ69C/K6MJN6ELN0IUogx9npvH1eY2hNds5mJYcF5dH8QyXKUpi5foDVTORBBXTPEMgi3S+7sOoD22/tcKW8Ab4Xv/NX6uRySIg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JhT28eEi; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JCDnU9005885;
	Tue, 19 Aug 2025 18:03:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=0G1QS78B3WJ3N30RHs6zjXgfUR8JM02ywaD3C36HnKU=; b=JhT28eEi
	NQRR8Yw/YjydA5hmZsPzs3927/2QU2MuciNaeS/IVNyWQv7Wtz4Y/VFiOLaOrQcU
	kyAbcY18CMVtTWoFML0gsbuwjUT5l2JquwqsqgqxxFpTIkjEO/DrxAYXwn/AnMXZ
	wHbOL2z0Zt3jYk8wIMStcwgONvdKmeqXbHDjLOyttQZNYAZRloydq743i0/3A+wn
	8bFlVKXjjYZEv9aJNsfIcM/tiVONw21F8f887xafds6H6FZjZx6K5qoNkBMednFI
	oBmT8jNRsy2lf0VfHSvHjME/ok0oqjhy/zcjuIVWNYhMX3qgtcLKRSVvHtkUta0a
	flT4JYu/sfx8qw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48k60g5bcf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Aug 2025 18:03:43 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57JI0cNY023626;
	Tue, 19 Aug 2025 18:03:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2056.outbound.protection.outlook.com [40.107.236.56])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48k60g5bca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Aug 2025 18:03:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rXb2VEYXSr0i3EW2PjhVVxwa9QNbRvEmGZilc99PLcD9AYVtgkEWbGiipoa7CSQ6+9oQxjK+/9+DYgeMqf6LJJcL24cPkP515rLhrvvjdrPNFhUAmvDbR2ER2mqbP3SmwE8Lts2Ktc5v0Wk7KUgtmZGotBkkmlTBGep4JJ3BZcOgYKbcwPlmqPdjsb6pNOm3lnN7zjYOXgMKJYb4D5ZkmrATP0qZqcIlm+XfZ9PUj52To2cB9dnrtzWPvYgR0xgLCXWrP5uWIG2/VpU9AxusraZ/XBfmdw1h2xKkluWOzQMcBPqDORpafqa/DatJvvUPJTQVLbB8TUdS9Fo0gTxV5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0G1QS78B3WJ3N30RHs6zjXgfUR8JM02ywaD3C36HnKU=;
 b=vfQLxVGk1RkDLW3ird3uvHOpPOX1rfNhoQ+FkIYhKysYNPImifWqVykUtY0KF8nBNXMDzoBrbOiCo5PSPew1AauZ2dSjXL8L6hkNYOZc6UvPV/oj3LzV1iPSjsQKnhuLKM7UBaB8/lCEX6Uthlc5UevDd7lVfveWleef915OQFr3L1d7ES5UGFp6y3zKLzVxCJYIr32swwyUNk8EP3VC8u+7etWkiGF0JoKvfHr/uRnNj+CANfGQRdyN7iCnNf/4IDAzUfiRt7E12yA/11XYIllzkS35NEDb8OrAo6hMu1D2SeEIpXeDtfM9g0x+p6OJ3arV5f584ftzDzzG+R813Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH0PR15MB5023.namprd15.prod.outlook.com (2603:10b6:510:ce::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 18:03:40 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 18:03:40 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Kotresh Hiremath Ravishankar <khiremat@redhat.com>
CC: Venky Shankar <vshankar@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Alex Markuze <amarkuze@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] ceph: Fix multifs mds auth caps issue
Thread-Index:
 AQHcAwnX8VFv10r3BUWfP7rTtDMVw7RON+EAgAchUwCACKxSAIAAxVaAgAC0VYCAAMJ0AIAAtrwAgAkk/ACAAEO9gA==
Date: Tue, 19 Aug 2025 18:03:39 +0000
Message-ID: <35eed4288342fd73fa7ba4166eff899daa28a8e6.camel@ibm.com>
References: <20250729170240.118794-1-khiremat@redhat.com>
	 <3dbbabbd68b58c95a73d02380ce6e48b5803adf2.camel@ibm.com>
	 <CAPgWtC4s6Yhjp0_pnrcU5Cv3ptLe+4uL6+whQK4y398JCcNLnA@mail.gmail.com>
	 <6ec6e3f45e4b90c2b56f4732e0e56fb389442c6e.camel@ibm.com>
	 <CAPgWtC5muDGHsd5A=5bE4OCxYtiKRTLUa1KjU348qnfPDb54_Q@mail.gmail.com>
	 <75632a861cf3c3fe77bbc384a805e9e4e77b95a8.camel@ibm.com>
	 <CAPgWtC4z2G5GuWjzTf4oRc=h=Vx7_0=S4FHvRMe-fmKFgrAdUQ@mail.gmail.com>
	 <185b42f5e88db732e299ca5f8323306951b08c88.camel@ibm.com>
	 <CAPgWtC5EVzdWZbF3NgntHaT03fiqH=NM-HTUPunE6GeJD1QPSw@mail.gmail.com>
	 <ae92e8a5cf730e997d031adb5e1708f17975e8a9.camel@ibm.com>
	 <CAPgWtC6QSaGfrjHWRiW9OL6SF4fpKedqXzb1mUzjhNepRh-C=A@mail.gmail.com>
In-Reply-To:
 <CAPgWtC6QSaGfrjHWRiW9OL6SF4fpKedqXzb1mUzjhNepRh-C=A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH0PR15MB5023:EE_
x-ms-office365-filtering-correlation-id: f57dab00-1556-49c6-9ea4-08dddf4aba1a
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?S2VVVEV0UWE2SFFaNVgyZ3p6VG5TSHhzQ2dON01qZWZ1b0k2WkVLU1VKdlZm?=
 =?utf-8?B?ZHVUTEhQdDI0MmxyL1FQTmFkWHBFc0dFcTVHZmk4NUZ6QzQxY3N5S0Q1T0Ju?=
 =?utf-8?B?WkNhc210QWttVlUvcHROVTY2ZlF2OUtpL241cGM3bmlQemFSMnNNbDZraCtW?=
 =?utf-8?B?OGc4T0E0S1EvVkl0TGFkN2hNOGxzZU0vbHBNUTFtQnJzWnNWQXN1RTRFVmRB?=
 =?utf-8?B?UnExTG5JV2UxNE1aMEJVK2hWYzlqejlhZi9MdHI2Umw2MEMzU0Z0YnFoUHBL?=
 =?utf-8?B?WkRxU1ZtU0tZd2xjRnY5UGdhak9jOFAyZW4xNHE1YnVDLzhDd01aSkQyOXJS?=
 =?utf-8?B?MHlYREJ1U2dWVk9BZkcwS2tmT2VkVVBRVDlpREc0UGZDQnpXWU9EYi8wS2RS?=
 =?utf-8?B?cHhDdFQrRlBaUE9xYlJwZmRlOFhJSDArK1BIMSs0cDBKcEhTMHVtY1dBcUJs?=
 =?utf-8?B?RUkyVmdRd01GV1ExNFF1VlFMaGpYcjMrcHhTSTB4QWQ5R2c5UGt0azlWZjhJ?=
 =?utf-8?B?K2g4U2dtb0drY3NWQkRxWFIyTUo2dEdEZ24wRnBpQVY4ek5taFVMYVB4Q0sr?=
 =?utf-8?B?SkI4NnRCODV2UkpiN3lkZ3NCZ0VrWFVNWSt6UWlpdERuSWlJcXZyVi90MUYx?=
 =?utf-8?B?Y2RQTFRHMEZrcGJjUnFpWGFPcTl6dEx0enFab0NJbGlwTHhTa2tVSVpLMXgy?=
 =?utf-8?B?ekphU05TUitsYXlmTjQ1bTVOM2pXaDlTVnRwQnJCcFMzeUNJRGdQZ1pBbkZs?=
 =?utf-8?B?ZnFiM2IwM3JHUFRqZTR4Y3J5UWlrUFhYeUFabkRQalBmc1ptYUV1OE53Rklr?=
 =?utf-8?B?cHE4TDlTZmxNQ3RrUE41emxrVGRDaTJmK1ROdkhFNTZJMjFVaGFiQ1paODZ0?=
 =?utf-8?B?MS85dWVGcU9aVlF3R0FMWk5jWjhZL3ZyMDh0ZzdSMlBNUXM1eHNiQ3VxeGFT?=
 =?utf-8?B?WnNKMHJ3SU1lNVRwc1ZtcHdjYXdZVXhPRUwrVFRnWFJGR0o4VU5jUGhFN1RT?=
 =?utf-8?B?cFJSSFNVYnUvNG4zY0piZjVQRHgvSkQ0T3BSajVDNzVwd3Q5emZDYVZLUWZl?=
 =?utf-8?B?SmdDbXVMOUhQSjBBcklqTk1odk1HU1Radmt0QktqbjlsYnVxOGpaSjZxVHZa?=
 =?utf-8?B?WWk5NUtFSjAraGl5SlF4T0c1bEZSaVRzZ2wvdFo1RzRXSHg3SURBV2NZREtY?=
 =?utf-8?B?TVRzdmlpQldzL2VTN1RaK1ZhV3lsVGhtaHhMZTJWenUwS0JEcGhQcmU4VFZL?=
 =?utf-8?B?R1lpNk9XeDlzckFiMW5qRzNzWm9BeWdHcnhFS0dEdm1XdHI1TXlJY1dNbURJ?=
 =?utf-8?B?d3NWWGVHQkZWYnZmSndiWEJVaUlJUk16QnkvSlM0b2NzZ1VQbitKN2o3ZlNo?=
 =?utf-8?B?UnpFTlpRUEc5SURZbE03L0xyc2g2US9NOTdRaXdMckVyeDQrZ0sxZmoyUUlV?=
 =?utf-8?B?ajlnb1Uyazl5a2gvUlpJM2xGODlTa3BicFJTYjk0TW9WaG95RVhTTmgwZnI4?=
 =?utf-8?B?UFBDNDRQV3dWUDJrbUJhYXZWVENNdmM5WE41MXdDcFZPNnFlZW5NUmhvbHJr?=
 =?utf-8?B?Y015ZEZkejZ3Z2NhMzR0bWFkVForWGg0cldxMzdYVXo2MDBianRVZk9GYVNa?=
 =?utf-8?B?NlcxREhvSHB3SDhPc25hYTBwOE1UN1VLRmZsMXdBbEpRZ1BnV2dvZzhiVEp0?=
 =?utf-8?B?UXdzS0pxeEc0SDlDYUcra0FKajlyWVhCcHRXVEdBWG9QdjRvaG1YaTlCa1N3?=
 =?utf-8?B?Rk1ZbkVmcUlRcEZaZzdLVWl3eHhrbXRmSmdjVWIxK3NlRUF2TUdwVU9iTmFj?=
 =?utf-8?B?ekFGaGlDaG5jTk8vdjdCN3M1Vjg5MjE2ODhGMGxpaVlOTjR5eEZPbC9ObDJM?=
 =?utf-8?B?ZDlMV2pGTEM0VGFVOVlPODYrRC9UQi9xUEc0TVRGTnYzaUlpaDl6L3hTOXpi?=
 =?utf-8?B?bWxuejRFRW81bTVWQlR1aEdsWGNOdlM4R1ZqQm40ellsMFdsMEVSZmptcVE3?=
 =?utf-8?B?WHVScXUwS29RPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NGsrLzBBVkoyckhadkRUc1hQNmtWSDlOcGxHRUl0UjgwZ0s5Zm1lbWJzWkRo?=
 =?utf-8?B?cHh2WHMzZU12akpxVXFZVWQwNTMxNWhxVnByTmRhVVJwc1RYaEpNMk9XVFJj?=
 =?utf-8?B?TjdDQ2JaUXJrczFkNEg3R3VHMVY1UE5JeXBpNE5UVUQ5T1pDbTd4dDZBWjlB?=
 =?utf-8?B?WEpRN0JqcE13c3FvZkgzVWtoRkh6c0VMczBURG10ZnRwTWpRdDZpbXpjM0lP?=
 =?utf-8?B?V1VaNkcxbVdXaEY2cEdlY2JQMjZXbU1XS2Z5NEVGSkk0YTZGSVpVTC81ZTl3?=
 =?utf-8?B?NEZPSmxlM3lLZW5IQnZ2L0tlMjltK25heldJZDdsN2wxci9xbDNieG9Mekhk?=
 =?utf-8?B?bmtFN2tTT3BpLzdkbVBYZUVJdkIySlhaUzlrTTEvTVhZQldoZzFEZVE5ZDFp?=
 =?utf-8?B?M3dFRlJyb1BkRmVZSkwreDlpS2hxQ2JSekUxajQwTGlTLzVIYnlEZk54USth?=
 =?utf-8?B?b2xwaXFrSW9lcXVad0IvVWRUcFUrME00SE9GOXRYZU1lREhaWUNVeEh4SHM1?=
 =?utf-8?B?MVFURnhvYjVWaWh3WHdCZTVIMnZHdlpSYWxicWVkMU11WWY5UHltY2pKRy92?=
 =?utf-8?B?VDJTZjEwYjUzeTBLR0xnU0dYRjI2VnRKN0lnZDFKeFRoU1F2d1BDemIwVWZn?=
 =?utf-8?B?czFaQ1FTa3ZHN1ZwNzE4dExtbnZ0MHNnYmZUNzQxbzVMbDJ4SG1HRzcrcm9K?=
 =?utf-8?B?WFNIVllXLzRhczhpWm1SS2RkY1ROeTdkYVBRakhvNkpOYjAyUmJnMEpMQllq?=
 =?utf-8?B?NVdWUWlGNWZrdS9DN1RhNUZqWkZ0T1lPajI5Tk0yYkFXSWp2OG56dUlxK3lP?=
 =?utf-8?B?eGdoTGsyZm0ySWdZR0VCSDlaMVZ0c2NPdDBZOFdqcFNyenhGTTQvQ2JFeWps?=
 =?utf-8?B?MndTV2lFaHdJRHJZcGN3RzJHbzNITDJMd2E1MVRLZzBRM3d1NmV0dDRSMjF6?=
 =?utf-8?B?VHNCVnlXV2U3ZFhOM2p5T1llZ0dCK2dScW1DUlFwSGhUZElMSlh5bS9aZWxB?=
 =?utf-8?B?cHB0RHY2VVdvY1o2TkFkM0dna1FITFFsZnluU0Z6S2pONExDcnFMZnpsL2M2?=
 =?utf-8?B?WG5pWWFYYytYUGRMc0VaRDg1eWVHNHRjSnRzL1JKY2pqdnEySmpONFJkcG55?=
 =?utf-8?B?Wm96c1kveDB0M21ZVWx0K0tYVUVMUXlsbFFKbDNNOGpzWlpMK29pUyttejEv?=
 =?utf-8?B?NXcxSHBQcmVlaFNwZis2NUdBS1luMk9PL0ZkREU3cjJDUTFUVWJMc002VWx5?=
 =?utf-8?B?Sk1CTy95bGZ4M1J0MW9XR2JVNWdnRU9XZFlGeGhFWVlkbzlSZzdweVZmL0N5?=
 =?utf-8?B?eW83MHlhL2VESlh5cSt0MWdJVGoweCtEaUtBczh0UTJsTzdNY05Gak0wRFVr?=
 =?utf-8?B?SnBoMWNaR0tlMnhObG9PVnVGeWpDaERyVyt2NHF6cFp5djJUWVJHcXJ2bVkv?=
 =?utf-8?B?bmRMb1V4YXJuQ1hScng4UW1Zbk5ubE16VTNVVkpwN0VuWTJ1eUF0dWlxQi9B?=
 =?utf-8?B?TmFLS25QYStrUUVqK3JtcEl2bzBCVndNV0FmS3hyWnozM1VWbVhoRTU1VHFy?=
 =?utf-8?B?WTRMQ0lpUDZKOHFpNEhWWjdJNVJuenZQL1plak9qamdEUlNkWTl4QVg2Q0ZS?=
 =?utf-8?B?TGZsMEtLSUZXRFV1bTN6NXUxTm5CWmt1eTYrdHI4MlhRUUxaWjZXTStOYldw?=
 =?utf-8?B?dGMxaHFmbjlWNDk5UDFBOWFaZ2s2SmxSZC9icnZ6S2N4RlpZaDJwOEM0WVhZ?=
 =?utf-8?B?TXlUUVQ3dmJJeUNobURQbUlhNGVnWFpVbng4SHRmdjhVaFE0cnNDcyt3c0VK?=
 =?utf-8?B?VGNEK2VVWmFUeWdIbVd2ZjBlaDlSUW5maDR6UXlPT1FadU5jUGlPTnVWL3hF?=
 =?utf-8?B?akpjTTZSR2hUYTJrbVA0aG52RTFncVFKeG9sak1maWNsUStWeE05a2UvVGho?=
 =?utf-8?B?aDVmUDFhbTk1cUNvRkUxRnVLN2ZsT2pMakYzN1lGRFYySHNwOXZaaklJSk56?=
 =?utf-8?B?RTA4RFkzMWx4ZUJaZnFUL3plY3pOOFFjVU91U21SeWhPYXJzbmZpaFZtdWxm?=
 =?utf-8?B?QXZ6US90c3ZjVWFVRWM2VEdsYktHR0tPR2NlbWFmdVJoNDc0emRiT3BZbkVR?=
 =?utf-8?B?elFJS0FHRGlsOWcyR0FNQ3FyZUhZaFJIaGpneWdqeFltZlJHR3RtQzJqZXBL?=
 =?utf-8?Q?d8m46zaxO33eYK1yBN+qhUY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8CE6C0E0AC92C48A3885F1172F24D78@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f57dab00-1556-49c6-9ea4-08dddf4aba1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2025 18:03:39.8893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1y3qm1XmQIlNIjPGe0+Gc8+dIITn7aHh6k/0Wlx0WmIq+if42+4gILtBE2E1WvBNvK6/YMHOfiNWv2f/SM+G5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5023
X-Proofpoint-ORIG-GUID: qeb9nRE8sGTZdMUrkZQNSQPYIuwznmTq
X-Authority-Analysis: v=2.4 cv=coObk04i c=1 sm=1 tr=0 ts=68a4bc7f cx=c_pps
 a=Z35tn85hJNknc3PDpfQsnQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=UH7Hl2zEejK48dt7A6wA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: hXBa2IBCa7eQjFlcvF0p3br2Pq1lgOvQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE3MDAxNiBTYWx0ZWRfX3RO0O+RHOGGY
 XprlH78mBL9Caqp3sPRcO+O3vF5jK5xWQeHHc6LnaN0wOFWHL33LtPIUJH5iVmFZDtBFtM6XRbk
 hYcJ/MteDDYPkow0rkfARO3SFTqZZv3FD7NbwfjNX04HwCtEC+89exfj2SP7SR+I3aIaRBnlFcn
 Ax9RE3S64XHKK7yggt+7bSKsuZh9dmcOXJtn1qiD5n6x5/s26LIA0ycfodpEtiGwFuRbNIC0bSH
 dOczy2G0OZD99/Riqex63eUcLGw/g4OlX91UfEiwlg78/zs6RD3F3UR8WA+kfRaG01xw/ilFDUC
 t4q1nejuV1UoxH7RbhKEH2EMFYOUq7S5Jyib928zR71apC8NZd/kFChONeWRyjUy6RHtVcZ2wlT
 /PFlC17f
Subject: RE: [PATCH] ceph: Fix multifs mds auth caps issue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 bulkscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 adultscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508170016

T24gVHVlLCAyMDI1LTA4LTE5IGF0IDE5OjMxICswNTMwLCBLb3RyZXNoIEhpcmVtYXRoIFJhdmlz
aGFua2FyIHdyb3RlOg0KPiBPbiBXZWQsIEF1ZyAxMywgMjAyNSBhdCAxMTo1MuKAr1BNIFZpYWNo
ZXNsYXYgRHViZXlrbw0KPiA8U2xhdmEuRHViZXlrb0BpYm0uY29tPiB3cm90ZToNCj4gPiANCj4g
PiANCg0KPHNraXBwZWQ+DQoNCj4gPiANCj4gPiBPSy4gSSBhZ3JlZSB0aGF0IHJlc3RyaWN0aW9u
IGNyZWF0aW9uIG9mIGZpbGVzeXN0ZW0gbmFtZXMgZ3JlYXRlciB0aGFuIE5BTUVfTUFYDQo+ID4g
bGVuZ3RoIHNob3VsZCBiZSBjb25zaWRlcmVkIGFzIGluZGVwZW5kZW50IHRhc2suDQo+ID4gDQo+
IA0KPiBBcmUgeW91IHN1Z2dlc3RpbmcgdG8gdXNlIHRoZSBpbmxpbmUgYnVmZmVyIGZvciBmc25h
bWUgd2l0aCBOQU1FX01BWA0KPiBhcyB0aGUgbGltaXQNCj4gd2l0aCB0aGlzIHBhdGNoID8NCj4g
DQoNClBvdGVudGlhbGx5LCBpbmxpbmUgYnVmZmVyIGZvciBmc25hbWUgY291bGQgYmUgYmV0dGVy
IHNvbHV0aW9uLiBIb3dldmVyLCBpZiB0aGUNCnVzZXItc3BhY2Ugc2lkZSBjYW4gY3JlYXRlIHRo
ZSBuYW1lIGJpZ2dlciB0aGFuIE5BTUVfTUFYLCBjdXJyZW50bHksIHRoZW4gd2UNCmNhbm5vdCBh
ZmZvcmQgdGhlIGlubGluZSBidWZmZXIgeWV0IGZvciB0aGlzIHBhdGNoLg0KDQpVc3VhbGx5LCB3
ZSBjYW4gZGVmaW5lIGFzIHZvbHVtZSBsYWJlbCBhcyBVVUlEIGR1cmluZyBmaWxlIHN5c3RlbSB2
b2x1bWUNCmNyZWF0aW9uIGJ5IG1lYW5zIG9mIG1rZnMgdG9vbC4gQnV0IGl0IGlzIGFsd2F5cyBs
aW1pdGVkIGJ5IHNvbWUgbnVtYmVyIG9mDQpzeW1ib2xzIGFuZCBpdCBpcyB1c3VhbGx5IG11Y2gg
c2hvcnRlciB0aGFuIDI1NiBzeW1ib2xzLiBBbHNvLCB0aGUgdm9sdW1lIGxhYmVsDQppcyBuZXZl
ciBpbnZvbHZlZCBpbnRvIHRoZSBmaWxlIHN5c3RlbSBvcGVyYXRpb25zIGFuZCBwYXRoIHN0YXJ0
cyBmcm9tIHRoZSByb290DQpmb2xkZXIuDQoNCj4gPiBTbywgaWYgd2UgYXJlIHJlY2VpdmluZyBm
aWxlc3lzdGVtIG5hbWUgYXMgbW91bnQgY29tbWFuZCdzIG9wdGlvbiwgdGhlbiBJIHRoaW5rDQo+
ID4gd2UgbmVlZCB0byBjb25zaWRlciBhbm90aGVyIHN0cnVjdHVyZShzKSBmb3IgZnNfbmFtZSBh
bmQgd2UgY2FuIHN0b3JlIGl0IGR1cmluZw0KPiA+IG1vdW50IHBoYXNlLiBQb3RlbnRpYWxseSwg
d2UgY2FuIGNvbnNpZGVyIHN0cnVjdCBjZXBoX2ZzX2NsaWVudCBbMV0sIHN0cnVjdA0KPiA+IGNl
cGhfbW91bnRfb3B0aW9ucyBbMl0sIG9yIHN0cnVjdCBjZXBoX2NsaWVudCBbM10uIEJ1dCBJIHRo
aW5rIHRoYXQgc3RydWN0DQo+ID4gY2VwaF9tb3VudF9vcHRpb25zIGxvb2tzIGxpa2UgYSBtb3Jl
IHByb3BlciBwbGFjZS4gV2hhdCBkbyB5b3UgdGhpbms/DQo+ID4gDQo+IA0KPiBXZSBkbyB0aGlz
IGFscmVhZHkuIFRoZSBmc25hbWUgaXMgc2F2ZWQgaW4gdGhlICdzdHJ1Y3QgY2VwaF9tb3VudF9v
cHRpb25zJyBhcyB3ZQ0KPiBwYXJzZSBpdCBmcm9tIHRoZSBtb3VudCBvcHRpb25zLiBJIHRoaW5r
IHRoaXMgaXMgdXNlZCBvbmx5IGR1cmluZyB0aGUNCj4gbW91bnQuIFRoZQ0KPiBtZHMgc2VydmVy
IGRvZXMgc2VuZCBtZHNtYXAgYW5kIGZzbmFtZSBpcyBwYXJ0IG9mIGl0LiBUaGlzIHdpbGwgYmUg
dXNlZCBmb3IgbWRzDQo+IGF1dGhjYXBzIHZhbGlkYXRpb24uIEFyZSB5b3Ugc3VnZ2VzdGluZyBu
b3QgdG8gZGVjb2RlIHRoZSBmc25hbWUgZnJvbSBtZHNtYXAgPw0KPiA+IA0KDQpJZiB3ZSBhbHJl
YWR5IGhhdmUgdGhlIGZzbmFtZSBpbiB0aGUgJ3N0cnVjdCBjZXBoX21vdW50X29wdGlvbnMnLCB0
aGVuIHdlIGNhbg0KZGVjb2RlIHRoZSBmc25hbWUgZnJvbSBtZHNtYXAgYW5kIHRvIGNvbXBhcmUg
d2l0aCB0aGUgbmFtZSBpbiAnc3RydWN0DQpjZXBoX21vdW50X29wdGlvbnMnLiBUaGUgbmFtZSBp
biBtZHNtYXAgc2hvdWxkIGJlIHRoZSBzYW1lIGFzIG5hbWUgaW4gJ3N0cnVjdA0KY2VwaF9tb3Vu
dF9vcHRpb25zJy4gQnV0IGl0IGRvZXNuJ3QgbWFrZSBzZW5zZSB0byBzYXZlIHRoZSBmc25hbWUg
aW4gJ3RoZSBzdHJ1Y3QNCmNlcGhfbWRzbWFwJyBiZWNhdXNlIHdlIGFscmVhZHkga2VlcCB0aGlz
IG5hbWUgaW4gdGhlICdzdHJ1Y3QNCmNlcGhfbW91bnRfb3B0aW9ucycuIERvZXMgaXQgbWFrZXMg
c2Vuc2UgdG8geW91PyA6KQ0KDQpUaGFua3MsDQpTbGF2YS4NCg==

