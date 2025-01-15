Return-Path: <ceph-devel+bounces-2453-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DBC8A12C31
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2025 21:04:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A16F71887FB3
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2025 20:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 482BD1B0F3D;
	Wed, 15 Jan 2025 20:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fBWbycwi"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC9D24A7CC
	for <ceph-devel@vger.kernel.org>; Wed, 15 Jan 2025 20:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736971441; cv=fail; b=WbpNVDRHw4d5I38x90mN+D1h21qF8xMAW1OR+kCqjLHBFWVrFxn7zw8HwR/TkZu7XdthgokkP1vhQs+sUh7MJmag4S6SEwDXbbGm8zXOnDhzc7raRpx4Giob4vQQNx9UeKdZRa21OvD1rSiNxEwYEclYSUa+kBYI9vguUKUrg3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736971441; c=relaxed/simple;
	bh=WExh3Gf6gAh76S5fphwkVY7qZ7b4r8btH59t+PHbbEA=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=U4vcj3mn12on7tCQ6ZJO4G56lc0Yon/p3uUguwQGkTagkaIzMillFykzf1uK9m57Z/VUGkOC9pHg3A91vXU78a/vTVB7fUc5qELnWbPUtKyykOoQ0mSFHUklbWwdoctbthi3025QnyLFh+9ha5KlGX6CpcS1K2XV/rM6IU+0VVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fBWbycwi; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FHX4FG024410;
	Wed, 15 Jan 2025 20:03:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=WExh3Gf6gAh76S5fphwkVY7qZ7b4r8btH59t+PHbbEA=; b=fBWbycwi
	r4iMIdQd/N/Ter9szddaYXaKnsjywxAs8oifmszuayQTCa7Ozy1zKgq+6VeRQnuK
	WM6HE+9oGc300EWsSIxWEjUOVEsiXzxpV3ezrsQR5UCxG3HBuEdec7TnTz8ABgyG
	1ZWIvmn9QXmg/u7SqWfq7lxSFG1YUYC2r9z36gpgfTjYRVPbTq//vtNPZlQ8dpy3
	H37JRmyqlzSPEtX42Ltdsi8O71AfEREga4AexsKQmAw4QDG/gPVH8Qe9YtTkA8Dh
	8uYMtya/X8k++01djIlj3BmmwnplS08xSUhlcL4jT2kiMhLfQXeLMk0hcji6LeqT
	HB2YGajV/WhLbg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44622hw2yy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 20:03:53 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50FK3qwu025056;
	Wed, 15 Jan 2025 20:03:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44622hw2yv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 20:03:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qx2FoeXiyc5givlR4n+E7vHyDdLOZKCp/OvYMdS07qoianTvPRWUI5lkkT61/aymbi6bSRiCQDjYnurQbyHlwXEW0tgOY2krzQuxR2vWLdc0fYdvc5CvGhcwbW1z5rgBNXmnI+27beeiy0RQ8I4kHspiLmSEMDY1lTEVMR3PMWOfYxtXO1cwcrIi/JdG+bterV3yCkL1TCAQbi91zjl/ckDyONL0Zl7WmC85k8yPPo5BPNVkerNqZ1BeiGfRo/UIbEaavmQORmiWOzRu1XUf7CdIITvJYN9UjW1+nKeZPr5Ljlg8hgITeG3kGRCPDZrRyY2oIEeF8xhFwLvYkHpQGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WExh3Gf6gAh76S5fphwkVY7qZ7b4r8btH59t+PHbbEA=;
 b=T/YJpSisJg97KK3vTs3MglO5CJC71AmnpVY/jrnXznrDJViBFnxM9EuddfTXU2YTrQY2tmqJH7LSaBVXaeTbnMs80tcq9dcqc8b1rG4+ftiM5xcKNgnDEbjLBvV/TGhNNX+1zRGPlv8hdujNAhtdaOrvDUeDgMvcj6dDD+j/EqRpmTPvZNYWTLvJUPuujmSOUxpJjqnCvdWQA7sWWmBeW6fHdpkU0VNBxBYxjTU3b8+SisYwfLntcVCBPh/MpnrN3Sb17Lamst3RpRes3oUUOwyl/uC/joKc00Rctx3zg97MsNUFOvmaaxJOx50cDyHN+J1oUivPPQ8exmMxwRCYZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA1PR15MB4902.namprd15.prod.outlook.com (2603:10b6:806:1d1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Wed, 15 Jan
 2025 20:03:51 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 20:03:44 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "idryomov@gmail.com" <idryomov@gmail.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "antoine@lesviallon.fr" <antoine@lesviallon.fr>
Thread-Topic: [EXTERNAL] Re: [PATCH v2] ceph: fix memory leak in
 ceph_mds_auth_match()
Thread-Index: AQHbZ4aWwsihgj2wLkudpjs493w/z7MYQhkA
Date: Wed, 15 Jan 2025 20:03:44 +0000
Message-ID: <187c44868453c865ea363753456a06916a4424b7.camel@ibm.com>
References: <20250114123806.2339159-1-antoine@lesviallon.fr>
	 <20250114224514.2399813-1-antoine@lesviallon.fr>
	 <9cd7c8f4c194fcb8c63c818f2155a9b4f55ce682.camel@ibm.com>
	 <CAOi1vP-zzoBrJF=rSLVRLdE_=pk8A5UWmQwQV0VhvdnzsPijkg@mail.gmail.com>
In-Reply-To:
 <CAOi1vP-zzoBrJF=rSLVRLdE_=pk8A5UWmQwQV0VhvdnzsPijkg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA1PR15MB4902:EE_
x-ms-office365-filtering-correlation-id: 5553ba2c-1d9f-47b5-79a6-08dd359fb74d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aW5xNWRINDVyaTBqeERwOW5VM3RMZHhzam9xNG9kM2krQXhyZE9jQW9DTU5Z?=
 =?utf-8?B?SVpZSGV3MnZrc09VSk9GTUJyUzBwVllwbGJXNWkya1N6NmJ0TDMrL1lwaDNS?=
 =?utf-8?B?TzN2Sjd4T1JlUXJ0eGw3MXQyNVYwNWRlVnhIdmlxMjMzeDMybkJVeGp1SEdY?=
 =?utf-8?B?cHFoMkNncHNLTGJLZUlHR1JLR2JsS3NNckcvZVZNT29ueVQveG1BSUVnbzI1?=
 =?utf-8?B?RXVLbmZJNWJQaWVkQ2JweUVNZjhoOVBONk1Rd2NSZGYrY0IyMXlSbVdWSVlj?=
 =?utf-8?B?Z3VwampKRHVNdE9LcDJhYm1nd0ZwUjh1WkhQUWJrcTVoK0NXSzBCeVkzeG83?=
 =?utf-8?B?bHZ1YXl2d2VocERwa1lXT044bVV5VjQ1ajUrWkNhWHVXMG10SDBNbW1oK1Z6?=
 =?utf-8?B?RkNnMUtPRWhNeXVDVGtPVU9vNWc4Z291RG5JU01xR043dTRmaG9HOTFDd05Z?=
 =?utf-8?B?V1pJZFljajlpR3dKdU1aNFpUTHNiWEpPMm9DMGc2SlNuSE90NEdINzJUa3Fa?=
 =?utf-8?B?Um52M21hdnoybmRaZHRqL0swbkk5QWNxWDFGajhFRUVyODZYQ3Z6R2FGWUha?=
 =?utf-8?B?UGI1SEV4WmxIMEJrZjZIdEhJRWpWWDhoUDdsWmx6NTNZZlhWM1ZiR3JnbHl4?=
 =?utf-8?B?RkxvcVhVWmNFYklOWm1pRHNvOW1DZWJtL2ZxZGpLUGxnVHB3aVVQeXFmOTVZ?=
 =?utf-8?B?YW9OZk50RzNmMElqVFNQYUZLOVVmeWowQmhabUdYU3g2bmVVSWlvb1BWUEd4?=
 =?utf-8?B?TXVwYndtMjQ4c1JMbTFhdHlGMFNrS2p3WG9VU1FCOHBEd2hsNjYzUE5qeWFw?=
 =?utf-8?B?Q1oyUTAvc04rTmg5emdJN0VsZ3Y2T0xHenNQNGE2S3VPUXdEMVlkMmZVbGR2?=
 =?utf-8?B?Z2xXREdmT3RNOEQwOFVISFROaWpINExqOWpaak45TEtNVEpnTC9nRWI4T2lE?=
 =?utf-8?B?enJhT3RwaXBJdjBDamNsQmdNcE1ibEZIc0plSWRlNHp0blBkVUJGNGNzVEhJ?=
 =?utf-8?B?Q0UrMGpqTTBITU41ZDRTKzVxVWQ5M2NzNDhQWXczRnA2N3BYd0t3S3J3c3Br?=
 =?utf-8?B?S3QwbXYxU3Irek5XaEZJVU4wcWpvUnRSRSsxM215OHJBcEMyNDdKQUtKUjRU?=
 =?utf-8?B?TlBTNUxRMGFNalU2d3pMOUQ0NzFtMEgzdnJZU2tzSS9EcUk4aWIvUE03U3lh?=
 =?utf-8?B?VGVGVWZSc3N4UXJ6ZjVTTTJROVZOYmdCU280c0tWOG9QbXg4NFNTUXhJY3BX?=
 =?utf-8?B?aks3U3RNZml5ejJmM0wxR09Rb1ZBTTBEeHVzNnBHUHh6ZGsvbzNaZ211eWZv?=
 =?utf-8?B?RDdodEdLeDVaM1JmOGpadzBuVk5ZS1d6RlpJU3hheVptK0NKRFlTN1ZhTEti?=
 =?utf-8?B?WUh2ZlZsYTFJMk1iVmVaNEdMV0N2SmtxeU9qNzdJMm1nK09teEtvN0x4c3Fj?=
 =?utf-8?B?VUozbm81T0xxdTNkbVlkNDk2ZExlSEMwNFpCbEk1MWhDWUpocDVsZ05VY25O?=
 =?utf-8?B?eHVDOG96QUJ6Zit2LzNyKzBrbkZ4dzg3UXRTdHZoWmpiZ2M2MmEzcXArQVBY?=
 =?utf-8?B?K3UybVJvRncvWk1sTG9HOTFVampvU0E2dnY3VFNYTEVXUkQ2UXZOMk1oKzVQ?=
 =?utf-8?B?ZzhBTDZ4bFZibDAvR2N0djV5ZWZ6a3dNT0xERllxNFF6U0Uva0VhalFESWlu?=
 =?utf-8?B?MUhHditWbzQ4YWNrTkR2cFNBQWZnV2c4a3k5NnRjdFpsbU9pdTNZRURndlRi?=
 =?utf-8?B?dkVMbjNiRlNFYVV6K1dJZWpmY1BFZHRvU0R2K2ttVjZvTjBjcnJKVnFJMWtJ?=
 =?utf-8?B?R2xydkV3YUw3Rnp3Rm1NT09DdU94TWxONmE1c2t0aHBuUUUwYkFLQlAzL2RC?=
 =?utf-8?B?RjdDL2EzcHZkY21UVmZrUXlBVWh5UzBXVEU4L1FOY2lTOTNJUXhhdnova2dE?=
 =?utf-8?Q?zgmN34YN7uf+L36RRDyDRQlQjB5/vhH+?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Wkd0TUc2ZEt2Qk95MWZaQ0ZjRmFTdSs0TjQ5aWs3ZHJWYnF1ZUtsNHNGczBo?=
 =?utf-8?B?R2ZDc2ZZWFNqb1BkN3V0ZzB4dVNLZkhUcU1ESGtDUHk5VDZMQjRLbGVxSjdp?=
 =?utf-8?B?M01rdGU3bDhBNytlSk1NU3FSYVFtQlYwZXRsZjVuRTU2dDc1clFOeHVOa29n?=
 =?utf-8?B?T3ArWlZjcWtTTThGdmhsM1BTa1pVQncxQ2Q4cEllVGVYYWpDbENIem5teDRC?=
 =?utf-8?B?QWhIdXJZeHFicnZtYlBneUY1VS9LcVlNMno4aUEzRlQ1MUJoWlhuMVA3amxm?=
 =?utf-8?B?R0lRREtQNmkyZ1pvSXNqMTlQQnJHMGNUUEhMamd1VWs0bFFFSDNnVnRHUWlQ?=
 =?utf-8?B?S0Y3eklvR3djNTdUNnM4M3FkT3pxdTlNL0ZWUThiLzVCR00yaWRRQ3BzYzdn?=
 =?utf-8?B?a3psdEI4b0tFQVRhOTVRak51MFRNUFl1WHludzRkWE1zRUlDMzlkWUpTbHFM?=
 =?utf-8?B?VW9sSTNwb2RhMjN6RkRkUTIyUDV2VnBQbDZsS1JxWXJ1R1BHeUNuUXIwTDFa?=
 =?utf-8?B?bGpzRlBSV3B0czlFK3d3T0tPODR3cnZTRTFSS29DZWQ5dDRSUjg1eG55REdN?=
 =?utf-8?B?ZTM2dXo4WHZvMGp5aU9RMWZCZldScUFMcm9KeXN6ZVErTCtkNHZMUDg4Q1Zl?=
 =?utf-8?B?S2ZlNGFqd2F4U00xV1p2T0pHbGhKbnFlQlQrYzVZd3c2Wk5jRWdVaTVkN3N0?=
 =?utf-8?B?MTVjSVIyZ0h6UzZjUmRHUkY0ZGFqa1dKNFFXTHk5NTJ4Q3hBU3N0S3ZBODB0?=
 =?utf-8?B?TUI0NnIzMVNqdWg2LzdFNlJnL1FmbVBieDMzbmpqVXZJNnV1U0w2MGZGNlEv?=
 =?utf-8?B?bnFvaUluYU1OcEg4dWpHN1hWaUo0UTdqNFY1MWFJTHQxSmRVNE9Pd2RyRkxP?=
 =?utf-8?B?SkFNaWJ5Y3FCejZKODNYRklMYnJCRVhlVjhVRFE5djNlZE1UOHJJbFNheEE1?=
 =?utf-8?B?Q3VDdHN4N2RSRDk3dXZIamVZMW5rRnd2S1cwV0xIbS84a3J2cWltZDd6MEtu?=
 =?utf-8?B?c0JDZ3YybkNtdkhMMlJjT1dEL1h2dDdidjYyMXdaZThtZ2c1eGNTRnFNRVlN?=
 =?utf-8?B?V1dNSTFtaHhzZ2lnZENHL3o4eDdWOFJsd0cyNmIyMGFIc1l6dWVlMGk1ODRY?=
 =?utf-8?B?NzZnTWd1SHZYS0k5T2FLY1luOFRuSmI1bndoN0V4U1k1TnFUbUZibmc4N28y?=
 =?utf-8?B?ZytWVHlNUUR1VlVnMU5YUlFJVHBqVUJQd2s2a1lMU1VTVjFJMzM2SlRaK3Rs?=
 =?utf-8?B?RVp2dTRNbHQ3REg5dWJuRy8zd0k5czlkUEw0ZEIvamc5dVlTSFJQaFJqZE03?=
 =?utf-8?B?aGFsbEtUYTlrdFF5a1ltUjV6ZUtIR0kzRVBCZERmZ3lPMUZkRGxEb1lTVGh4?=
 =?utf-8?B?KzlNcFladlZ1cVAyWjJmQVhMWGpOQjdaUjFQRUlaQnlPemZYekx0YzdlR1Zv?=
 =?utf-8?B?Y1d2cHREc0djVXAvNkxobEdGNUxRWUQ5TWROZ0NLWEJhOUxCcWZKbjRJU1lJ?=
 =?utf-8?B?RFc5T0lQMGtjeHdyd3FGU2VtbmhWOUF6NS9JNDliQkZDb0ZnWVRaNnZMS0xZ?=
 =?utf-8?B?aG8rLys3RzJpMDV6RU9qQWpLbWNDOVlBRlV2ci9uVDVPb003bnY0a1A3NkNz?=
 =?utf-8?B?WHJwbllYSHZNd3hXaHd5cHFDQUREWUhGcFRWT2xsMEZUVmZQWEk4bGxCaUx1?=
 =?utf-8?B?NXJscXowbmlWUVl4QVN4T1NEZjlVKy9rQnBwT3paejhaVDNqV3grdURWNTUr?=
 =?utf-8?B?eWh1K3Z5NnczMmY1YWlaVUdGdE56R2hOeldDY1VwaTNPYmdHNkJrSS9MYXFT?=
 =?utf-8?B?MyttWXZySElja2Z6anEyTTYzdnpNbWJIUzludWRKOEhJMGhVa3pDTXlEWVNP?=
 =?utf-8?B?ZVVRQmx2Q0NBMWdLZzZyTHlPKzdNTlZhUnUxM01JS2pKbHgrOWVxTWlFQXRJ?=
 =?utf-8?B?NW12enhmbGxERTgwempseWZoVkVCcExKZUlaNDgvcFJad01mSUlNdEwwdHFX?=
 =?utf-8?B?NmJpRFAzdzRHYUI1SW15d21TS0VEdzlnSGRmMFYwSmNlVHA1R2pVOFJkcWFa?=
 =?utf-8?B?Z0hNOUxTd3ZkRjJ3UEJEbmEzQ25ZTTRvaWszSXE0V2hBdjk3NFMwNFNtemdU?=
 =?utf-8?B?Z1o2cHVGMkI2Z1Vwb2lvUnBIYUlPWFZ2RW9tZDJnc25IWkJYMFg3dE90UWhi?=
 =?utf-8?Q?ihoZ8m4ujdHVfop1ZYH3VBM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2441BE96891EA84F9E416565BEEA16D7@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5553ba2c-1d9f-47b5-79a6-08dd359fb74d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 20:03:44.7334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Sj1VOXG4gq/CnCQXJK+XDwJsqEgcpfB8newrmmH6dHTg6xvMZZMym6Y/HcvJc6mxIh1ucO2i0Q6933bi+8jvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4902
X-Proofpoint-GUID: b4d-iFd4yxDlnVR7oDZeTpR-Ujo7NSxZ
X-Proofpoint-ORIG-GUID: 0aw9DGY5DnFSGszqA2CZmOnxk9zA6c0g
Subject: RE: [PATCH v2] ceph: fix memory leak in ceph_mds_auth_match()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_09,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 mlxlogscore=924 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501150145

T24gV2VkLCAyMDI1LTAxLTE1IGF0IDIwOjQ5ICswMTAwLCBJbHlhIERyeW9tb3Ygd3JvdGU6Cj4g
T24gV2VkLCBKYW4gMTUsIDIwMjUgYXQgNjo0OeKAr1BNIFZpYWNoZXNsYXYgRHViZXlrbwo+IDxT
bGF2YS5EdWJleWtvQGlibS5jb20+IHdyb3RlOgo+ID4gCj4gCgo8c2tpcHBlZD4KCj4gSGkgQW50
b2luZSwgU2xhdmEsCj4gCj4gSSBoYXZlIGEgc2xpZ2h0IG5pdCB0aGF0Cj4gCj4gwqDCoMKgIGlm
IChmaXJzdCAhPSBfdHBhdGgpIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJjID0gMDsKPiDC
oMKgwqAgfQo+IAo+IMKgwqDCoCBpZiAodGxlbiA+IGxlbiAmJiBfdHBhdGhbbGVuXSAhPSAnLycp
IHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJjID0gMDsKPiDCoMKgwqAgfQo+IAo+IGlzbid0
IHRoZSBleGFjdCBlcXVpdmFsZW50IG9mIHRoZSBwcmV2aW91cwo+IAo+IMKgwqDCoCBpZiAoZmly
c3QgIT0gX3RwYXRoKSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAuLi4KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHJldHVybiAwOwo+IMKgwqDCoCB9Cj4gCj4gwqDCoMKgIGlmICh0bGVuID4g
bGVuICYmIF90cGF0aFtsZW5dICE9ICcvJykgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLi4u
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gMDsKPiDCoMKgwqAgfQo+IAo+IGxvZ2lj
LsKgIEkgdGhpbmsKPiAKPiDCoMKgwqAgaWYgKGZpcnN0ICE9IF90cGF0aCB8fAo+IMKgwqDCoMKg
wqDCoMKgICh0bGVuID4gbGVuICYmIF90cGF0aFtsZW5dICE9ICcvJykpIHsKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHJjID0gMDsKPiDCoMKgwqAgfQo+IAo+IHdvdWxkIGJlIGJldHRlciBhbmQg
YSB0aW55IGJpdCBtb3JlIGVmZmljaWVudC7CoCBBbHNvLCByZW5hbWluZyByYyB0bwo+IHBhdGhf
bWF0Y2hlZCBhbmQgbWFraW5nIGl0IGEgYm9vbCBmb3IgY29uc2lzdGVuY3kgd2l0aCBnaWRfbWF0
Y2hlZCBpbgo+IHRoZSBmaXJzdCBoYWxmIG9mIHRoZSBmdW5jdGlvbiBzZWVtcyB3b3J0aCBpdC4K
PiAKClllYWgsIHRoYXQncyByaWdodC4gSSBoYXZlIG1pc3NlZCB0aGlzIHBvaW50LiBMb29rcyBi
ZXR0ZXIuCgpUaGFua3MsClNsYXZhLgoK

