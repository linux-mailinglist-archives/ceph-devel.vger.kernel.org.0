Return-Path: <ceph-devel+bounces-3678-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DAA7B829E7
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Sep 2025 04:09:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18CCE1C80912
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Sep 2025 02:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEAE8239581;
	Thu, 18 Sep 2025 02:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PticNO37"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11621D5CC7
	for <ceph-devel@vger.kernel.org>; Thu, 18 Sep 2025 02:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758161350; cv=fail; b=ttrhCv+8mpxi63fOBshmsBeWlrBb2+Y8myKZEk6Blvs9TpuvM4THMpO27Kt5OUvffxr1duIIBy6Fqo3+4LwGNoVLr94jJOGkjYDKys9+qrU9GZLHxTB3bmqK71a1T+CEY0vLGWuN+Q5i81RKMCNh3EAk87Cou0TgoznhoZZMWZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758161350; c=relaxed/simple;
	bh=IUGQ8H+ovUaWaBhr6MZLooF6RF4gAjOtfx4enA1fHx0=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=TS9JCYH5ONZyehZqAXdLP4KtpuNvENaDv6pJn26DHAS4mjkYjI/4XW6g0k+s/8GooSqEqfzStek8nCiSqgj1yCmrEz+DLiHRZEvGRwj11ETzpiCcu13rC5AIIciVFFOKqcMdA3g1NzhXM/vXhVh5VisCFQzDggt7AFlX1hJoO98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PticNO37; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HIZlHd023742
	for <ceph-devel@vger.kernel.org>; Thu, 18 Sep 2025 02:09:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=eddqEU53akN+arxZiVvdGrRsSNb9Ws+LVbrPLpFOW5I=; b=PticNO37
	36ycIJvcqmLZuzhz8WMmeYI0ZaEA+Lj/NcrgzxwD15KSUQAqgB0LOOv1qG900KGK
	ulIUHzH+FPwrGnVBo3Ht2Y4puMYHO0++sEBUWvfsVHzS3omAnILNqclXnGB2kFGH
	NZfWcpAF/1u6IL9vjrl/Q3YSnGf0fR288a13MypdoXIL8EggsldjJahQg/vRuaIU
	vW9QzDZQYupZ0A2wf7u0Nzp7zCwuc+VZemcx+DF4Q9H6WmZ5uD6popeT4wQDrwdC
	RDByz0nCvuA83wiKuqMdACsdTG7Gd2dNbTqNY5H7wMEnd+pWQJVvrTKIJslo1EvG
	rrvJuPCdr5tzpA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qq0s5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Thu, 18 Sep 2025 02:09:07 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58I296Xh006601
	for <ceph-devel@vger.kernel.org>; Thu, 18 Sep 2025 02:09:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qq0s2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 02:09:06 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58I295mf006583;
	Thu, 18 Sep 2025 02:09:05 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011033.outbound.protection.outlook.com [52.101.62.33])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qq0rw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 02:09:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CEtTkBtOvRakAMlPu6OKtw/J5XMZWd3nSnNjcAS+NeXQ2ydFs5CLoiOvn8qrDsHZgtU/WXTws+XeJAHner0IQ6hTiCJVLmH+qm+YhQDZmuKHA1OFtz9Bn98H7f+nLX22Q7gELGUDfsbK8OjJLnTmtYVEhqOkDkEj20XUAYUuf9sOtHc+o7QKQTkY1Dh0K0scXomWgTcYqs3PYZB1lmmv0IT8gRO7eNTXg2WJeNi5QBhmnbe4/d8QvPSQFYeuX2kQZ2aTbUD6Bb5LK7MvHX53oWNqDqx4NRaCRlu/XuHNRCpuFYh8aCgIcP+YTXVCitfn2d00pc3lKMz3l9VDAHAxjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VaZPldIMslKylKiesIQsAk8ipGQH9c6Ri7o2ozzPGnY=;
 b=W3B0S2O6brEKVslEpU4OiGM7DxemaYu8Hg8Gi80Kxd5Ajy2JxmoPrDes0l8yf2iHkhCKl9kbX5sPkaShc1pJrQUfjwJmYzha7Mr84m/dt3HI9Qp0GEdGKbB+/hgpF8UxuOY/g93IyS7ddZPieY7nTUwkydQhZPuqUM+greVfNiQNlDb800Lhl47+rsGNBVbAMoudrKnvz8LTDIa7wr4bHkSe8t84yuVQeC60St8LG/0Ojke1l4cNMf+WIvBC+gWkpxz+gUTTN6nZsJnhN4pa4QiY66lGbzH+3uwVh29Np8cmyGCxxsbMYB7DlzgJw3atcymQh1PiTwy/s1buu7QGog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA0PR15MB3998.namprd15.prod.outlook.com (2603:10b6:806:8d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Thu, 18 Sep
 2025 02:09:03 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9094.021; Thu, 18 Sep 2025
 02:09:03 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "lyican53@gmail.com" <lyican53@gmail.com>
CC: "idryomov@gmail.com" <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH] ceph: Fix potential undefined behavior in
 crush_ln() with GCC 11.1.0
Thread-Index: AQHcKD62wAtpkSIONkKx6UhtKA1hyLSYMeoA
Date: Thu, 18 Sep 2025 02:09:03 +0000
Message-ID: <2ac16f39027656b9c906f43a376794bcaec7bd76.camel@ibm.com>
References: <1AD55673-B7F4-4DB7-AE80-1AC81709F65A@gmail.com>
In-Reply-To: <1AD55673-B7F4-4DB7-AE80-1AC81709F65A@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA0PR15MB3998:EE_
x-ms-office365-filtering-correlation-id: 0926dd11-7b59-4078-ecd3-08ddf65856fb
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YXIyWmRpTERLRU93a2ltQng1S21Cb2VjdTJuaEY2Z2Fjd04yekoreHZ5bW0z?=
 =?utf-8?B?WkRuVVRIZGg0MEJjUXRIa1Q2KzFnWWxyVlQ2YmdUcUo4b1hEZmhFK1ltRitP?=
 =?utf-8?B?TS8wdWZnMnVvN1R4T3k5a2hJSThydkFYM1pGKzJXTER3d0owMXZyekpCWlF4?=
 =?utf-8?B?MklrTmo2WUQ1ejQrTi9sZWYySXFubFNqalBMR2c1eWp6THNVOUZVVGZqQ2F1?=
 =?utf-8?B?VGZCMGt6RHJOdmxXLzB1ZU8xMThLd2cwem5LQlRycmlxazQvSE9vbFNsRTJ0?=
 =?utf-8?B?RGtDamZiWDhnNFhkbGtlRjZrbWJESVVsQW5uK09rZXN2citvc29DVHNuaTBT?=
 =?utf-8?B?R09OaDhhaGY2MUFUS0NzTy9pa25IaEZoZGhDZGh6RjNNTmdaSDc1KzlZQnk3?=
 =?utf-8?B?aDlmY3A3azJ3UjV6WDI5QW54bm9aVlY5cUxLNURzeVlVUllrWS9HaXJjd29u?=
 =?utf-8?B?M0t5anRZbU05ejdKbmVidk1pTm40OVZwVDFVLzJQZ3Q5ek5lMkpzSm1DMnZj?=
 =?utf-8?B?K2kxSDcrZ2Vadm1oS0JkWkZKNUhheWpaKzJuVnByYW1obksvQWxmazlkOXV4?=
 =?utf-8?B?c01xd2FxRDVjcnB0eTFsRm5BVk1ndkN3WnhrRDdib2t3QmlXcTRUZlVuOXpt?=
 =?utf-8?B?TGNqM0J5WHhQcXI5U2VOTVV2SmVCdXRhNXZIcWl3SFJKd3FKS0ZEdEloMzJM?=
 =?utf-8?B?alVEN2VnRk1iR1YzK3lLTHJkakRFNDNaYWFXR3JkdFJXV3Q5ajZZbXh1OG56?=
 =?utf-8?B?dE9KaytMbkVPT3BOcW41ejZqL2owb0lNNWdDdVlOTG1zYk5hWXE4NjJXQ2xs?=
 =?utf-8?B?SWpaQkpDVE9zYWRVcW9JdlErTHpNU3ljUTlkck5lclVTeW1IMVVENUtodWh6?=
 =?utf-8?B?N3pKVmFXTXdnYWxSSFRRU3E0NCtPYkFwYXFqRUdWbUJuS1hiUERlbzliNkhS?=
 =?utf-8?B?b2R2Nk9VVUttQitUN3ZkK1pLR0pSMExob1kzWVpoWHFSek9iTDYzUDY2Sklz?=
 =?utf-8?B?S2lRaDZIUzRDVWYySlVpOHloSElnSUEySVova3NqM3U0Y281VUE3SmRIbUVG?=
 =?utf-8?B?Q1F1MHJseDllNTNEdkcrOS9TRXZ3NytYdWlpR01BSkxBNWJwczgvOUZvR09z?=
 =?utf-8?B?NmZ1TytSeERsL1hqWTZYWmpjUlFzME91L0J3K0xpZWFQVXo4U0Y4ZE5LVzdH?=
 =?utf-8?B?bC9BNTN3azJpLzB2NjZucTR4QVlHMnQ3L3hpTEM3Q2NYNHVEbkRnbGdtNmhC?=
 =?utf-8?B?YW1mZ3orZUswWUhoa0Y3R2R6SFpSQUV2MmFBTDc1KzhuTHFUOG8yaUVjQ1JN?=
 =?utf-8?B?VlRzUUFRRjdKRzJHbG1FcktwUXdsbGNTSjY2eHBrVVQzOHZpeWRNOUtJdUs0?=
 =?utf-8?B?SHQ4bjlKNFEvQ1RNdVNQNkllSHhoOG4vYWlUUUcvVlJGOCtjRUZDdTRsVFly?=
 =?utf-8?B?VkNxUm92OXdCZlNqaUcwNlpjMUhYN21pR3c1Skh5V1JXZ3RaSi9HU0ZZQWpD?=
 =?utf-8?B?N09VdHhPNzBEUTlaWFBUNVV0MFhzU3ljdDFMNVN3bC9DbTFSWVluNVV6blZM?=
 =?utf-8?B?OExYWFpXUGtmR3ErTTlmRzc3WXNuMWpMRWxDNDJ3ME8yUTlhQko1QkYveU1F?=
 =?utf-8?B?RWxmZ1NSWHRKYUlabWl4WFhkVklabjdBUHNmdFUrMlpJRWhmQytvZkd6WmhR?=
 =?utf-8?B?TUJwTWY5VEpoMWhnblI3by9OcmNaVUZyQ3drMDdzSUNBTHRxRzlnOWZMcjR4?=
 =?utf-8?B?MHBSZ2MrNm5RMUl2L0QzbG9iODlIN2FpbExNam5oMlRxRjBQcUVVK2JucHU5?=
 =?utf-8?B?YllOTVpaSUVyd2VSS1NPa1dwNmpvZFVNK0Q4T21YL1BHMkxqOWtTVTN1Zlh2?=
 =?utf-8?B?VEwyZW5vZSt3bE8xMllBemFhSW1rSkxpWXQzVFMyZ1B6cDFWNElRNmdPT3Jh?=
 =?utf-8?B?OXM0SmQwTytPV01ZRU8wcS9FdXd4NGQyTHR6WGUzUTJHZ1hNVmt3NFhiR1NC?=
 =?utf-8?Q?Sf86etuLYGv9MfiS/n1IgExEZfVn+8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T2pPeURmcENHRkt4eTEzM1VYY0wrdW00aVE3dzVwZWdjUjZKOVRONlhlb2hw?=
 =?utf-8?B?b0xpUnZFLzdDSng1elJZbmdCWEVXSHE1akZhaGMwNFNoMGs5S2V4RnpwZyt6?=
 =?utf-8?B?UTlkQW1jWlpPb3ZGSkhFTk1pZXpLcmt6VzFyMDVoeHdwbmFjUkFpQnl5SDYx?=
 =?utf-8?B?SFNuRUFGZkhGVXgybFkxNFdPcG1MSnpmZzFGR3E1T1VVY2pTeE50Q0szd3VO?=
 =?utf-8?B?Z1lCdVptckRwdXJlem0zSVNOT3R2dks0Z1NEb2RKaTZrU2Rwb01WODRCRnRo?=
 =?utf-8?B?dVJCNEN2RUxzS0NaSzdUdVRKN2s0anZUY1ROT0ROOTVKblJpUHFxUTNqQjJ1?=
 =?utf-8?B?ZVdTYU5TY1hYQmVkZS9kQWdCL01wN0xmR0RNUXhoRzBnb0xPQlVhVXV6bXBq?=
 =?utf-8?B?MmVQdk1ydnVFMWJkMHdvNXA5MWVoS091eTRmOHJsUjZIaW9rZXFmdE9xd1RV?=
 =?utf-8?B?TVpkUFZtYlZaK2VuSm5MRVFMa2VXaGdCMldxcmRkTVMrcjB0cVRGbEFnMncz?=
 =?utf-8?B?SXkvUklERGcwSXhsZzBBVEVDMmR1dVRRV0s5VTFpd3BrOFBiNzBnQWRuWkxt?=
 =?utf-8?B?NTEwMVJVN2pabFVTNjBzUGsrc2ltNzJOc2tqTWxBREFGNFFVVzFFMTcvakxs?=
 =?utf-8?B?TERxWkpybXlYOUU3TE5OU05mc1c3RmNuTWFOZmVidWhVdnZnUVMwWFFtVE9t?=
 =?utf-8?B?WFlPZzNqVm1sSEdYYk4vdk1JUzQ0ekYyeGdnRmhSNXpxWFVqLzJKcTRDc3g0?=
 =?utf-8?B?anFiMG0wNW5mWlNBUlFndGZMY0xacUI1TVVHRm8xYldpMGIwdEtPRXZDdEpD?=
 =?utf-8?B?MjlaOFJsSmhHWU83REwvK0FHTGgzOFgvNHNXeTEvaTRDVGk0QXdtNGVmUUw5?=
 =?utf-8?B?TjkyT1dTOVh6b2Fjdmc0UmRVdTJhQ1FHYVpNSGZrOHhtYk9jY0M2WkdYTExP?=
 =?utf-8?B?b1FDU3gveE9DcStHVENKYU15UGYvbzFOdTg5YWRsV3piVmF4a3FkbkxhbVNX?=
 =?utf-8?B?aUYrWE94RUtmSVZMWjcxblU5SEpXWi9xYVhaOTdSTkREVXMwdWI3U1VoRFdE?=
 =?utf-8?B?eVRTck1weWY0eWJ2YUJZRGlUbmVPbFVlVDVGUEY5eGhROVBCT0VNMEdYeEZn?=
 =?utf-8?B?TFhVTzVzd2VUanVvUDVZUi9QcEZZY3dXM1ovUU5yT1c3cUVoQzE4TE1RZjVh?=
 =?utf-8?B?cXBQdDczQWVveXpZS0xyUHhDNUlxT0drdkxRcjkyNDV6eE4yRGZiclNyQWox?=
 =?utf-8?B?ODlsV0ZRUFAveWJmeU5qNUM2ZUNIdThFc0Z3Y3cwTnhPSXI2dzB3NGxVbjYv?=
 =?utf-8?B?MkhqNFJMU0JsSHdremVKMStCc0k2SVVYMlVGZEZjbWRGd3hlV2tQVEI5WXpI?=
 =?utf-8?B?TWRpeXVSby9tMlFRUWgrbFZ0UWpLUkdNUmFWdjNZNitUSVB5VUF6ZmJzalhI?=
 =?utf-8?B?QmNhdDkzLzRIMWsvS2pvYmpBTHB0UlN1dDZvTlNIQUU1TkpoTlk4dnZUNjhr?=
 =?utf-8?B?REVUeHJlQ0o1MGxSeEIzR29reSt1T0J0Ly92ZXlONHVNNmd1YnYwdlZ4OHI5?=
 =?utf-8?B?eFRSc1c0QTlzTll3a1daTlNla2N5enlpVVdhRUxlNENqTWpZMnk2bk05SDk4?=
 =?utf-8?B?eXhRVmN6SmpjUk1aZm10Z05nbmluT1JPRVRua2h4ZGtqUjR1WnF5NUVHQzdL?=
 =?utf-8?B?a2tEeEFWM3l5WWNRUHhyVW5ZNGFYZHdLay8zTFFmaytjSFpkdU5BRHpiakZP?=
 =?utf-8?B?UTRiSTYxNXZwM1UveGpvaDFyM3hNdEVRdC9lZTBRc2VVRy9LanFheEhyamhw?=
 =?utf-8?B?bTBUYXhhZ2Z5M2xoaGU1MTVjWlhuSm1KaWtLWHBmaHJLRFdqMXRZUlN5M0ht?=
 =?utf-8?B?MWxGOHlJSnNnc2swelZCYXh4MzQ0NjgzUk1UUHdZajM5U25CaTQwNWxJMUtD?=
 =?utf-8?B?R3lmNHZORGdGK2krZlV1WE0vNDFtUEZ4RE1Ca3FYd2t3M3p5WFFGbVhubUtq?=
 =?utf-8?B?TXRkbzBFQk5DVXpWVDVDZEZNQTBsSDVBYnZMM2RSa0QxRHFvMkJYRVk5RTV1?=
 =?utf-8?B?SEdQZnBJZk5qNEtHZFBsOHRTSE90Mm1tQ0lUcDQ2MkVhVlFDcExMZkkvendv?=
 =?utf-8?B?ZDZzQjlIbHJWa0NUOFpmRDVWaTZZRDRPdkYrQ0p3NHdobmhLa2VacE96cjho?=
 =?utf-8?Q?OsGcQSyLCCP8aOTsPu6t9N4=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0926dd11-7b59-4078-ecd3-08ddf65856fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2025 02:09:03.3139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HiL1g9sYwIYhxw8ESKXu0T1NhnrGqqR2ML7kQRJihco3+aA9j/PWbYk0DEfUSGBZ0JjgLx+yBfZe+K1YI5i8GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3998
X-Proofpoint-ORIG-GUID: fJG8YPA2kYD2goJwHHEKlLIv9S3fMRSd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX1lDDRf4I9Hyp
 Znje2BE6YVkkLsvqE8nUYrcK53/Z+Hy+P0MZiN5nO6GayfO9//osva01cUV+mFSbTGAOVWrBWGV
 LIl9I4q+yJoHIQGmtrMhdSbNdGBFetWSBi1kJLObQ0Zheq2vUI7J+i+P0YtZM85C1I3XFZhPosv
 PPxiLu9wdwZqmsbhUa2vH4S2o5LNZe+XbindGzXqhZN70DhqWZzzGAvBvkMCwkw3I+0OBPlNY2U
 ok8b9ham7EuROqTt5opyjj+fQQ4tw/RZkW8ianHp8wrOzDs9uaIYEawpvufytz5Bc1+8Vt1EqAA
 o9g2IvEzf5eHVNN6ewohF7GBByRADX7FAgU82ZKLltLMcK24jBmkGUqvwM2GitisviBkuSw1M9P
 yNaqGXvK
X-Authority-Analysis: v=2.4 cv=R8oDGcRX c=1 sm=1 tr=0 ts=68cb69c2 cx=c_pps
 a=4QVYENZnsEoURNel/cbnog==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=mDV3o1hIAAAA:8 a=pGLkceISAAAA:8 a=ef-c-dziiP-RDGYgz_4A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: yQuQUNlu4Uil1_fX5TkZs48Tx71zLYU4
Content-Type: text/plain; charset="utf-8"
Content-ID: <B0D364B51DDF1245AEC9141554A7DE4C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re:  [PATCH] ceph: Fix potential undefined behavior in crush_ln()
 with GCC 11.1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=2 engine=8.19.0-2507300000 definitions=main-2509160204

On Thu, 2025-09-18 at 09:50 +0800, =E9=99=88=E5=8D=8E=E6=98=AD=EF=BC=88Lyic=
an=EF=BC=89 wrote:
> When compiled with GCC 11.1.0 and -march=3Dx86-64-v3 -O1 optimization fla=
gs,
> __builtin_clz() may generate BSR instructions without proper zero handlin=
g.
> The BSR instruction has undefined behavior when the source operand is zer=
o,
> which could occur when (x & 0x1FFFF) equals 0 in the crush_ln() function.
>=20
> This issue is documented in GCC bug 101175:
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D101175 =20
>=20
> The problematic code path occurs in crush_ln() when:
> - x is incremented from xin =20
> - (x & 0x18000) =3D=3D 0 (condition for the optimization)
> - (x & 0x1FFFF) =3D=3D 0 (zero argument to __builtin_clz)
>=20
> Testing with GCC 11.5.0 confirms that specific input values like 0x7FFFF,=
=20
> 0x9FFFF, 0xBFFFF, 0xDFFFF, 0xFFFFF can trigger this condition, causing
> __builtin_clz(0) to be called with undefined behavior.
>=20
> Add a zero check before calling __builtin_clz() to ensure defined behavior
> across all GCC versions and optimization levels.
>=20
> Signed-off-by: Huazhao Chen <lyican53@gmail.com>
> ---
> net/ceph/crush/mapper.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
> index 1234567..abcdef0 100644
> --- a/net/ceph/crush/mapper.c
> +++ b/net/ceph/crush/mapper.c
> @@ -262,7 +262,8 @@ static __u64 crush_ln(unsigned int xin)
> 	 * do it in one step instead of iteratively
> 	 */
> 	if (!(x & 0x18000)) {
> -		int bits =3D __builtin_clz(x & 0x1FFFF) - 16;
> +		u32 masked =3D x & 0x1FFFF;
> +		int bits =3D masked ? __builtin_clz(masked) - 16 : 16;
> 		x <<=3D bits;
> 		iexpon =3D 15 - bits;
> 	}

Let me spend some time for reproduction the issue and testing the patch. I'=
ll be
back ASAP.

Thanks,
Slava.

