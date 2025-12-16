Return-Path: <ceph-devel+bounces-4179-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E44FCC08D0
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Dec 2025 03:02:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C94E130173BF
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Dec 2025 02:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBEBB1A7264;
	Tue, 16 Dec 2025 02:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mpPoUWRU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA90FA59;
	Tue, 16 Dec 2025 02:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765850551; cv=fail; b=M96y/ASi979wVrwNB3CKHbb7b1lJoYiouFx5XkoIWMTj+XjpPqJFQKwHxwqmCp/O0MME+iuOSc8X1iE/ikOt0KhXYOsHEcmvvL9+RFqoHhNkiVqsfVc8fqi+sTBNEhH8odI0/Bj0Vi6B53vkQlxnT0b34p3/TVQ5d2D3EGBVYo4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765850551; c=relaxed/simple;
	bh=e/mGm0k/am0P5QfNBmW8aAoifBw3NN+RTtD1cwqdRjU=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=uyRrJwAXVAHcIVg2KqtCZNVE/0rB2/QTYxDybVfBw+n76b4C56u5A0ZlV8iVCF/8ooUsHJQsBf5sQPWLc9kXilMp1dM8lcL3ry5C0ll9Plk1V6uKO/XWZSfsnJZwuqdyIsr3WOH8YSHS4BolmLzlMhKBZB6PwuyqRkKxgM0sQM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mpPoUWRU; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BFMv8Nm030921;
	Tue, 16 Dec 2025 02:02:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=e/mGm0k/am0P5QfNBmW8aAoifBw3NN+RTtD1cwqdRjU=; b=mpPoUWRU
	XgyUxjONiazbHnxtJp8rBb8e8WtOuoNh0ZgoQ4z9fhcbKLO6Ae73eQGqltDPkYF2
	g+OwybHa8RSoTpYQzhOWX0l8gmvzcRheTtscv16y5rXp6+PWIVBQvcaW9lK3YbuK
	2VDsVECVCe0kmOwlzTXoVklo3I3Taif8gGPSHND+7UQqVmSE1F2c/sQ6NJGj0uOM
	qSYtpoQ2OcN57GIgqh7+a/3RdZ339kVyCXsMrLNJKKafb+fi3dXbme1We93X/y+h
	Onz2FH/y7nP0KnCKJp9LHybpxUaaArBcZjmi4MhKnrO6qVuFKA2V7IxhyqjVDJx8
	2Z8AeslKuJD0CQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0xjkv958-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Dec 2025 02:02:15 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BG21aDl030531;
	Tue, 16 Dec 2025 02:02:14 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010054.outbound.protection.outlook.com [52.101.85.54])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0xjkv955-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Dec 2025 02:02:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QjqtucJXS3i9DDj1PtZbBU9m+eTkr80Mt+Xo+MAkACcrSRNMtU2Vy/FTpi4i3NXoiXLChRshzckXmiLPvZ6aRmMW/mANb1YI9q5/dT435f2fZkvndNhSZvrHVazAIwqzDkTH1/PEwZE4IhYzzt2IBfFCs0kjYG2uLNnZkBrsrD8tKJuUdikx+giYEv7TCSYxtOsUX4AuvKYrVA1j6Ize5h4xa8m+UEZVu3Uka/p+/N4qFQEem63QhZcTRw6GFnuUvP4uVOMSonbruh6Vo57Ps0wqUX2DnkLZaacRTWe2B/tUhoew79XejrL0KXQWgiLcIlxF3htngtF+3ln9Eja1sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e/mGm0k/am0P5QfNBmW8aAoifBw3NN+RTtD1cwqdRjU=;
 b=rIFLcf/vOSujx6eYxOFKKWB+XjJE8z3tm7oPwjvum6L3fTrvt6FznYfm+oTpRDc3KVNaAKJlQIqxFjGKWo9iqNnAuMyFXq1qODW27UP6LMJQiKoVAV0ePZXVPuhjQcGa/E7Gv2IvX1xHEQ0/PYGr7g/73LD2b/KXfYua+ZrgTYOfn/WbqJNzKULAS6UpJUe2DG8YW/xWbYOIm5MClBCZSs+F9UxreBPPeV4bapyBEdjjX+7jNVv+gqsSY+L1sIkxUeXOstmjx3h1ACF2y3uPzFc/4YWz37ge3CkmlqFfSevAw31GF0DplCEr+hyT0TLIaS0uQwUcJm59UEemMlnA2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BL1PPF919D92287.namprd15.prod.outlook.com (2603:10b6:20f:fc04::e32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 16 Dec
 2025 02:02:12 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 02:02:12 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "malcolm@haak.id.au" <malcolm@haak.id.au>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        "00107082@163.com"
	<00107082@163.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Xiubo Li <xiubli@redhat.com>, "surenb@google.com" <surenb@google.com>
Thread-Topic: [EXTERNAL] Re: RRe: Possible memory leak in 6.17.7
Thread-Index: AQHcalYDU1NctrlESU+S2CMf8hQ3tLUjIVeAgABgE4CAAAnkgA==
Date: Tue, 16 Dec 2025 02:02:12 +0000
Message-ID: <4f3d113065ed2fdc8f643c073fed49981e975d0b.camel@ibm.com>
References: <20251110182008.71e0858b@xps15mal>
		<20251208110829.11840-1-00107082@163.com>
		<20251209090831.13c7a639@xps15mal>
		<17469653.4a75.19b01691299.Coremail.00107082@163.com>
		<20251210234318.5d8c2d68@xps15mal>
		<2a9ba88e.3aa6.19b0b73dd4e.Coremail.00107082@163.com>
		<20251211142358.563d9ac3@xps15mal>
		<8c8e8dc4d30a8ca37a57d7f29c5f29cdf7a904ee.camel@ibm.com>
	 <20251216112647.39ac2295@xps15mal>
In-Reply-To: <20251216112647.39ac2295@xps15mal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BL1PPF919D92287:EE_
x-ms-office365-filtering-correlation-id: 9746fd15-da7e-4be1-45b2-08de3c4720a9
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VXZ1RlhVWFFJZktvVTJHaDdobUpwK0l0d29sUURXTklQUUtpTit5NHptZVl5?=
 =?utf-8?B?d0dJRGFYRnFVQ21TQUo3NWNucElieXpyYWNGRHBKOWJpSExWZmUvcHptMkRm?=
 =?utf-8?B?Qkx3SUx4aVkvNVZLL2h5RXJZWkRHaUQvN0JtaUtaOERnWkZjc1dsb1JYMUR1?=
 =?utf-8?B?bzRFNW93dVpiQjN4dnREeUltb2FiV1A1LzJnNGswN01VSDZEZVdiOUxUTXo5?=
 =?utf-8?B?M3I3UndyMk5YYUlySWM2QmZuVWh5SDd3Rnp6TCtDSUU0VnduZ2htblhKcnFj?=
 =?utf-8?B?L2I0Y2JFdTlLMHZEUHU2a3p3a2tONkZxUWNJYUp1eE93T1hUVC9Yd2xtNUhs?=
 =?utf-8?B?cUE2QVY1azBqaG9JTUQwbkZYUWs5VEowdllqZTNrS0lIMU5QSllIYWpoZ2tm?=
 =?utf-8?B?dHdJU3ZUNmpERUpHRUJURFNFNXVYUTR4VDltMm4vc3FQejRuVnVIZE9YU09i?=
 =?utf-8?B?K0gzUXhPNjhKTjRhVm5vOFVXK1JxSzBPMUNxenVwRDNteFovODlyTk96Y25r?=
 =?utf-8?B?dHd1QzNVTDd2eUlZeTcrSlUzRmJkdlZVRjB2bzVBUTF2aDVsKzdvbzBmbEpl?=
 =?utf-8?B?bHJzWXkwMU1GY3Q5WTJLTnh2VEpIbHRvTVN5b1RHZjlmVlJuNkwrL2p1d05P?=
 =?utf-8?B?aTlweGNlaUJwbHZQSExPS245bUpFajh6djNURThLTllOUTExaVN0TzhJOGtz?=
 =?utf-8?B?UzB4Skt3Uk5CSVhHbTlNUEZtY0xucjBFVi9oWUVPL1pWSU1acEVlTnpaK1Ft?=
 =?utf-8?B?aVJ2ZjkyK2V4SnZoWmFLdHlmTG5BQVZuTjhSRzhlZ2tDYkIraHd4alV5WDVS?=
 =?utf-8?B?akh0SC9aZVNQS1psVHRxOE4yZHRRL2k1WFh2a21IbW5VcTRoUnRYV2hIWXAy?=
 =?utf-8?B?N1dIaEhOUVU1enkxajM4UnExWm1LZUwwRnNDWmR1SWhZUVZzMXJaZlA3djlN?=
 =?utf-8?B?VU81alJsUmkrdlZGd2ZGWFJCOTJRN1JzbW9vTGlkY201cGNIN3JmbVFBWG9U?=
 =?utf-8?B?Z1hFL0ZzTkltUDVKOUNMNUVCY1ZCd2FydXhKeUJKczN2SlpNUy9Yc1MwSFQz?=
 =?utf-8?B?UjEwYjN3YVJTZGlvU2tScUpZWG01TlpWMXJKaHduY2RPWnhHR1JBTXZBSmli?=
 =?utf-8?B?emtTallIMFRpQUROT1JoSXRnMWZFQkY3WGRGTVZGcThPOFpQVHB6L21ITGwv?=
 =?utf-8?B?bktSV2JWYURRMGJnV291L3hEVng4a2tkUmZxeCs3ZkpQa2JrbXFnUHNuTVgz?=
 =?utf-8?B?K0gwVndlYTdvdURTTlFMMDJhclZZbmtIVHBzU3RNZjdxTit6WklIYnZPb2I4?=
 =?utf-8?B?QjFURENiQmRzaUZhbjVYdndzbU50MFdsdzBpc2RTY095VysvNHFWRngxYWVP?=
 =?utf-8?B?U3p2NE9wcnpqa1d2Y04vb3lvMEh3Q3lWTlBhQlp6ZlgwTGVERkVLcU1KTXJr?=
 =?utf-8?B?SVQ1aHZ4aTlONjNqQmhOVU9sTnJmbzVpTFZRMUNPNnJ1MTVlSVFVQWpoUmpz?=
 =?utf-8?B?d1ByOGFXYUZMN2FHNktLdkNmT0Q2dXFOTEZxbjZCZlBKUVRLU2JVU3BMblhM?=
 =?utf-8?B?bjJsS2dmSGFCS1ltekZUUlp0amdrdFJGVHE5d3JaTGxVV09MTUVpMG1neHBK?=
 =?utf-8?B?YUJ5cWYxZHpvU0lVbHRIQk00UGxFdm1BNndBT2lUYjlWanZnUE5LQmVhejRN?=
 =?utf-8?B?ZjN3TklpWjJKMzBSUU0ydDBhUmFtc0thR2doUW9FblByTVM5VW91ejNmLzlR?=
 =?utf-8?B?TFpRYkZEbmRDLzdzck4veFU5YXZiQ0kzQXlkRFFPMWRhYWs2b2NYZUEvZDFU?=
 =?utf-8?B?R1lGQ2FTc1VWVjZTWlVLamtjbGRGSmpRaHdGdFBWZTk5UWF2cXpTeCtKbmsy?=
 =?utf-8?B?d3hBOWdnci82RDJ4VjFGMFdTMWdiOWVCcG5BMWJhRHppbnBsdVZQN2NFVEpl?=
 =?utf-8?B?OGcxUnRKTWZmS3pHczhoZ0Fla3NpNWhabURLL21ZMmVDdE5tZVVpVDJhMThE?=
 =?utf-8?B?TjN6MGRmd2NYYW9aajZ3NnJUN2JRbkNDVnY4S3JjWittTWdCR3VFbWVTbllQ?=
 =?utf-8?Q?bLNdFd?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WUorTDE2eFFNYkdxSW9xcjMxV0Nhazl4cnBLMHozTXVMZG41bHA5TlRJcjFR?=
 =?utf-8?B?ZVkxbzdOVEZnN2JRSFFEeVRwbVYzZW9tZVM5TFFXRnZtdlpYN21DTkc0RWxh?=
 =?utf-8?B?U0RjZHFnM3cyYzlIVTI1OWlZZkIyNGN3SlpGQ1Y5Y3l2LzF5RU5OazlvUW5B?=
 =?utf-8?B?NG5qRXhiaGtlbDZXQUVzeG9seXh4TW5ZemZGWWJkbjV3NTIxcER3V0tRS2pS?=
 =?utf-8?B?aTVWZ1dpbS9OYldkdk01WFFQR0NvaFlvakwzS0JZNjljV2wrNlI4Mk5naEFY?=
 =?utf-8?B?S3NvenBsamR1M2k2N1gya1ExYVJNUGhYZmM0NGZDZlFXODhUcEV1SDFLVXRo?=
 =?utf-8?B?cTFzY1dSYXZDNFpTTzBESjMxOGFEa0JwOStIRy90bkc1YjdWU2RpNnRsZTVC?=
 =?utf-8?B?OGNSTmNoSVd0d0tyMzBMUU1CYzg5d3BDWDBuYy9lYzR1OW9LOHA0YVdXOGFD?=
 =?utf-8?B?cnRMWkJ1b3NoYjd5SFF1ZHdzNFMvMjVGWTVUN2JtMnA2eEJPYmRJUTU2VDhF?=
 =?utf-8?B?cnVGMDd1MU1wL3J0Qk1wK3p6SXhDNEl4dnNrS3FvUis0YmZtMlR6RWhhTEpn?=
 =?utf-8?B?MGdOYmNKYThCaDdvYmZ0cDRuWWtGWFpuQm1hS1BuejIwWWY5aHJpaEVnMHNt?=
 =?utf-8?B?VXdtQ0Z3SHd6ZnhPRHV5d0FMNUNKaDhXTUhtS09GVys3SFFrOVBpc2Zyb1Rk?=
 =?utf-8?B?ckw2OGkvdTQySVdXY2tnZkIwK0dyU2U3SnROK2IyZk1pK05GdTdLMnZsQy9q?=
 =?utf-8?B?TVZmaUlJUEVGWEt1OXZqaCtVelZianRRSmRWVmhKR0tBenl4MUZEeEtHUlVZ?=
 =?utf-8?B?ZGdkSDhrQ0RveUEwWGFZM3o2ZFZlNXg2ay8yNXVEeWlCWVlhREl3Z1FGWXYz?=
 =?utf-8?B?RUFMVkFYc3JHbFVOM3NvV0pLYjJuVjdUSHdMVXhLVjBwY3lQajREMFlKUURX?=
 =?utf-8?B?bVQvekpzL2tXc3I5ZWtHcHNxNEkxNGkxK21ZMkF2T2lHUTMyL1dldFU0SW9p?=
 =?utf-8?B?blFBY1BVOXJ1dXlieHUyWjgxdjBZY0lDdVRmQ0YwUUJqNXNrK1UvTWw5VmUz?=
 =?utf-8?B?TW9MQi9QRzNmMkJhSy9UQ0hZck5NNG0rSVFUWmZWbnlsRE4zWUtvcktUQkw5?=
 =?utf-8?B?aXBLcG1tS2U5S0wxNjdNL2M5STNqUnVvaklnTmkwa3Vab1BMVW1DRjJQb2p3?=
 =?utf-8?B?cG9jOUxBc2M3VzczYWgzTzVtaC81TWh0OHFOSHZKZkp1dzZGVkpKcFRYTXhw?=
 =?utf-8?B?a0NlQ2RlUnpSUWZlM3E5NmV0eUJRYjUrVjRRajhNNFpFdjk5YlRJbjdsMjRl?=
 =?utf-8?B?OE5Bd0RyTWs5cklrQWo2RGtRdGZsZ0JoTzhXeDRLSUcrM2tDSTNHVnZ3VHZt?=
 =?utf-8?B?dGFUMCtLdjFEcFRaS2VkRTBsL1pBVGswNUhmZzVEeG0vQWMxODRYc3ZkZlpp?=
 =?utf-8?B?VzdTMkc4eDNocVdKcTRZY0NIVUhqRnQwMk9uRzRWaVpLaWhHMXJ6LzVKRmt6?=
 =?utf-8?B?NmJOc0RzWFBWbTFDT285Yk5mZE9KSEpFNzZGRjRYNTk0ZC9ha1VGV3Q4Y3g2?=
 =?utf-8?B?eS9WZXJTN2tnYitGNHFKRE9ZN2ZhMEg1M0FoUzZTdTNlNHZ3VExNNVlkRkt0?=
 =?utf-8?B?aitDNUNOdVBIUThjQ3RjbXVDQ1hlV1pRMFNsOUlSd3VROUxVd0xRSDM5RTY3?=
 =?utf-8?B?aTZ6MWRmcXpYUWdmN0w1OVJTM3Q3TnhZeHozOWdhNUE4YU9pd09GVkhUa05C?=
 =?utf-8?B?bnErc2tLZkU5K0JsNjVDdktwaTFXbnN0ZVk0b2NRL2k3OEowYXd2ZlZvc3JR?=
 =?utf-8?B?d0ZCZk9BU0RFc2hZZHJnUHlsVVNXdi91NzErRnVFNFh2czJPc1pQZG1tbFox?=
 =?utf-8?B?aVc4eGZNQ2dGc3ZWdEJYTW1qaVh6WE53dDdzQ3ppc05tZ0xSREl3YUQ5M3g1?=
 =?utf-8?B?eHlvZ21XR0RrdlBkS0l2b2F2aVYzdXBSUmMrMFdLODh5ZTRwQ1pxV0FhUUll?=
 =?utf-8?B?Q2NZNFRyWDVNYWZ0dmhHNnRMMFd1ZDIwYkkxYzQ3QWdTV3MwZ3JyYUxrb3RR?=
 =?utf-8?B?d1ZsSlNyVGNMSE1KcGhWY1JOS29VSFkrU0U3U0dsZGs2RlhTWEd4Z2gxMW1J?=
 =?utf-8?B?bkJ2T1grUVZrdE9IQWJEVEZnci9OL3NWbGdxd09Idm9uUWMyMTNQNEhBWmVo?=
 =?utf-8?Q?mrUP8xV1o528u/lipZwEWdw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1995E54524FF8E47BDCB0144F6E5E63D@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9746fd15-da7e-4be1-45b2-08de3c4720a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2025 02:02:12.1242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AWwmS3fufAf8elGiVxyCNnDuLUbkRNo7iRssUzzeXykPu4NwCRbEV5Ou8v5Z2pBWlSf+OUoG6E6mwa8yYUgtvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PPF919D92287
X-Proofpoint-ORIG-GUID: ZOFmDo4kkTgwmFjZUZR2KKihK1hkzmTM
X-Authority-Analysis: v=2.4 cv=CLgnnBrD c=1 sm=1 tr=0 ts=6940bda7 cx=c_pps
 a=Y5aTAp+79vj4S64KMabfRQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=xLO0hVlzOnxC-_x0AoYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: bcaYgKWeVfG193q72AEf6uKMV1zB_Er0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAwOSBTYWx0ZWRfX2iLcr1UJesNM
 Jza0M6M/ux6aa4wM74nC5LMaFLUtiQaGyDIUhZW68xQymiF4f/7sFDjkhKAwH90zrCQ0W1/aBD3
 WXP99slZNmpaNEeoNbPeZkB/V9QZTUZsXDhPrIsTlnODQbU7NXfnRhhKbSeM61P6jTFFTjb/tnm
 QAx9SCon9TcSywU0Y45rAgjBCB//eZA3upnXGw8KYf4GuKLhGmNJAtzKvXBk6xYyHjll3qc7CpP
 gZR9hCkPScp6SzmWW3DpbLsY8YqOmGHDwzT7cAdOBM8aFGU+qJBnXQcoIdJrsCuCqRsmxAV4I+U
 rhYcfGYaUrWWu0B71eayK3HhoUejSqeXC6mQC1tmzd074smwa+OOL5aGMTYtt0bdN1zhvJFxlWX
 JKtWWagdXUsdOXvMQZBaz0F7cvoX4A==
Subject: RE: RRe: Possible memory leak in 6.17.7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_05,2025-12-15_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 suspectscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130009

T24gVHVlLCAyMDI1LTEyLTE2IGF0IDExOjI2ICsxMDAwLCBNYWwgSGFhayB3cm90ZToNCj4gT24g
TW9uLCAxNSBEZWMgMjAyNSAxOTo0Mjo1NiArMDAwMA0KPiBWaWFjaGVzbGF2IER1YmV5a28gPFNs
YXZhLkR1YmV5a29AaWJtLmNvbT4gd3JvdGU6DQo+IA0KPiA+IEhpIE1hbCwNCj4gPiANCj4gPFNO
SVA+IA0KPiA+IA0KPiA+IFRoYW5rcyBhIGxvdCBmb3IgcmVwb3J0aW5nIHRoZSBpc3N1ZS4gRmlu
YWxseSwgSSBjYW4gc2VlIHRoZQ0KPiA+IGRpc2N1c3Npb24gaW4gZW1haWwgbGlzdC4gOikgQXJl
IHlvdSB3b3JraW5nIG9uIHRoZSBwYXRjaCB3aXRoIHRoZQ0KPiA+IGZpeD8gU2hvdWxkIHdlIHdh
aXQgZm9yIHRoZSBmaXggb3IgSSBuZWVkIHRvIHN0YXJ0IHRoZSBpc3N1ZQ0KPiA+IHJlcHJvZHVj
dGlvbiBhbmQgaW52ZXN0aWdhdGlvbj8gSSBhbSBzaW1wbHkgdHJ5aW5nIHRvIGF2b2lkIHBhdGNo
ZXMNCj4gPiBjb2xsaXNpb24gYW5kLCBhbHNvLCBJIGhhdmUgbXVsdGlwbGUgb3RoZXIgaXNzdWVz
IGZvciB0aGUgZml4IGluDQo+ID4gQ2VwaEZTIGtlcm5lbCBjbGllbnQuIDopDQo+ID4gDQo+ID4g
VGhhbmtzLA0KPiA+IFNsYXZhLg0KPiANCj4gSGVsbG8sDQo+IA0KPiBVbmZvcnR1bmF0ZWx5IGNy
ZWF0aW5nIGEgcGF0Y2ggaXMganVzdCBvdXRzaWRlIG15IGNvbWZvcnQgem9uZSwgSSd2ZQ0KPiBs
aXZlZCB0b28gbG9uZyBpbiBMdXN0cmUgbGFuZC4NCj4gDQo+IEkndmUgaGF2ZSBiZWVuIHRyeWlu
ZyB0byBuYXJyb3cgZG93biBhIGNvbnNpc3RlbnQgcmVwcm9kdWNlciB0aGF0J3MgYXMNCj4gZmFz
dCBhcyBteSBwcm9kdWN0aW9uIHdvcmtsb2FkLiAoSXQgY3Jhc2hlcyBhIDMyR0IgVk0gaW4gMmhy
cykgQW5kIEkNCj4gaGF2ZW4ndCBnb3QgaXQgcXVpdGUgYXMgZmFzdC4gSSB0aGluayB0aGUgZGQg
d29ya2xvYWQgaXMgdG9vIHdlbGwNCj4gYmVoYXZlZC4gDQo+IA0KPiBJIGNhbiBjb25maXJtIHRo
ZSBpc3N1ZSBhcHBlYXJlZCBpbiB0aGUgbWFqb3IgcGF0Y2ggc2V0IHRoYXQgd2FzDQo+IGFwcGxp
ZWQgYXMgcGFydCBvZiB0aGUgNi4xNSBrZXJuZWwuIFNvIGR1cmluZyB0aGUgbW9yZSBjb21wbGV0
ZSBwYWdlcw0KPiB0byBmb2xpb3Mgc3dpdGNoIGFuZCB0aGF0IG5vdGhpbmcgaGFzIGNoYW5nZWQg
aW4gdGhlIGJ1ZyBiZWhhdmlvdXIgc2luY2UNCj4gdGhlbi4gSSBkaWQgaGF2ZSBhIGxvb2sgYXQg
YWxsIHRoZSBkaWZmcyBmcm9tIDYuMTQgdG8gNi4xOCBvbiBhZGRyLmMNCj4gYW5kIGRpZG4ndCBz
ZWUgYW55IGNoYW5nZXMgcG9zdCA2LjE1IHRoYXQgbG9va2VkIGxpa2UgdGhleSB3b3VsZCBpbXBh
Y3QNCj4gdGhlIGJ1ZyBiZWhhdmlvci4gDQo+IA0KPiBBZ2FpbiwgSSdtIG5vdCBzdXBlciBmYW1p
bGlhciB3aXRoIHRoZSBDZXBoRlMgY29kZSBidXQgdG8gaGF6YXJkIGENCj4gZ3Vlc3MsIGJ1dCBJ
IHRoaW5rIHRoYXQgdGhlIHdlYiBkb3dubG9hZCB3b3JrbG9hZCB0cmlnZ2VycyB0aGluZ3MgZmFz
dGVyDQo+IHN1Z2dlc3RzIHRoYXQgdW5hbGlnbmVkIHdyaXRlcyBtaWdodCBtYWtlIHRoaW5ncyB3
b3JzZS4gQnV0IGFnYWluLCBJJ20NCj4gbm90IDEwMCUgc3VyZS4gSSBjYW4ndCBmaW5kIGEgcmVw
cm9kdWNlciBhcyBmYXN0IGFzIGRvd25sb2FkaW5nIGENCj4gZGF0YXNldC4gUnN5bmMgb2YgbG90
cyBhbmQgbG90cyBvZiB0aW55IGZpbGVzIGlzIGEgdGFkIGZhc3RlciB0aGFuIHRoZQ0KPiBkZCBj
YXNlLg0KPiANCj4gSSBkaWQgc2VlIHNvbWUgY2hhbmdlcyBpbiBjZXBoX2NoZWNrX3BhZ2VfYmVm
b3JlX3dyaXRlIHdoZXJlIHRoZQ0KPiBwcmV2aW91cyBjb2RlIHVubG9ja2VkIHBhZ2VzIGFuZCB0
aGVuIGNvbnRpbnVlZCB3aGVyZSBhcyB0aGUgY2hhbmdlZA0KPiBmb2xpbyBjb2RlIGp1c3QgcmV0
dXJucyBFTk9EQVRBIGFuZCBkb2Vzbid0IHVubG9jayBhbnl0aGluZyB3aXRoIG1vc3QNCj4gb2Yg
dGhlIHJlc3Qgb2YgdGhlIGxvZ2ljIHVuY2hhbmdlZC4gVGhpcyBtaWdodCBiZSBwZXJmZWN0bHkg
ZmluZSwgYnV0DQo+IGluIG15LCBhZG1pdHRlZGx5IGxpbWl0ZWQsIHJlYWRpbmcgb2YgdGhlIGNv
ZGUgSSBjb3VsZG4ndCBmaWd1cmUgb3V0DQo+IHdoZXJlIGFueXRoaW5nIHRoYXQgd2FzIGxvY2tl
ZCBwcmlvciB0byB0aGlzIGJlaW5nIGNhbGxlZCB3b3VsZCBnZXQNCj4gdW5sb2NrZWQgbGlrZSBp
dCBkaWQgcHJpb3IgdG8gdGhlIGNoYW5nZS4gQWdhaW4sIEkgY291bGQgYmUgbWlsZXMgb2ZmDQo+
IGhlcmUgYW5kIG9uZSBvZiB0aGUgYnVsayByZWNsYWltL3VubG9jayBwYXNzZXMgdGhhdCB3YXMg
YWRkZWQgbWlnaHQgYmUNCj4gY2xlYW5pbmcgdGhpcyB1cCBjb3JyZWN0bHkgb3Igc29tZSBvdGhl
ciBmdW5jdGlvbmFsIGNoYW5nZSBtaWdodCB0YWtlDQo+IGNhcmUgb2YgdGhpcywgYnV0IGl0IGxv
b2tzIHRvIGJlIHBvdGVudGlhbGx5IGluIHRoZSBjb2RlIHBhdGggSSdtDQo+IGV4Y2lzaW5nIGFu
ZCBpdCBoYXMgaGFkIHNvbWUgdW5sb2NrIGxvZ2ljIGNoYW5nZWQuIA0KPiANCj4gSSd2ZSBzcGVu
dCBtb3N0IG9mIG15IHRpbWUgdHJ5aW5nIHRvIGZpbmQgYSBzb2xpZCBxdWljayByZXByb2R1Y2Vy
LiBOb3QNCj4gdGhhdCBpdCB0YWtlcyBsb25nIHRvIHN0YXJ0IGxlYWtpbmcgZm9saW9zLCBidXQg
SSB3YW50ZWQgc29tZXRoaW5nIHRoYXQNCj4gYWdncmVzc2l2ZWx5IHRyaWdnZXJlZCBpdCBzbyBh
IHNtYWxsIHZtIHdvdWxkIG9vbSBxdWlja2x5IGFuZCB3aGVuDQo+IGNvbWJpbmVkIHdpdGggY3Jh
c2hfb25fb29tIGl0IGNvdWxkIHBvdGVudGlhbGx5IGJlIHVzZWQgZm9yIHJlZ3Jlc3Npb24NCj4g
dGVzdGluZyBieSB3YXkgb2YgImRpZCB2bSBjcmFzaD8iLg0KPiANCj4gSSdtIG5vdCBzdXJlIGlm
IGl0IHdpbGwgc3VwZXIgaGVscCwgYnV0IEknbGwgcHJvdmlkZSB3aGF0IGRldGFpbHMgSSBjYW4N
Cj4gYWJvdXQgdGhlIGFjdHVhbCB3b3JrbG9hZCB0aGF0IHJlYWxseSBzZXRzIGl0IG9mZi4gSXQn
cyBhIHB5dGhvbiBiYXNlZA0KPiB0b29sIGZvciBkb3dubG9hZGluZyBkYXRhc2V0cy4gRGF0YXNl
dHMgYXJlIHNwbGl0IGludG8gTiBjaHVua3MgYW5kIHRoZQ0KPiB0b29sIGRvd25sb2FkcyB0aGVt
IGluIHBhcmFsbGVsIDEwMCBhdCBhIHRpbWUgdW50aWwgYWxsIE4gY2h1bmtzIGFyZQ0KPiBkb3du
LiBUaGUgY29tcHJlc3NlZCBkYXRhc2V0IGlzIHRoZW4gdW5wYWNrZWQgYW5kIHJlYXNzZW1ibGVk
IGZvcg0KPiB1c2Ugd2l0aCB3b3JrbG9hZHMuIA0KPiANCj4gVGhpcyBpcyByZXBsaWNhdGluZyBh
IGNvbW1vbiBob21lIGZvbGRlciB1c2VjYXNlIGluIEhQQy4gQ2VwaEZTIGlzIHZlcnkNCj4gYXR0
cmFjdGl2ZSBmb3IgaG9tZSBmb2xkZXJzIGR1ZSB0byBpdCdzICJORlMtbGlrZSIgdXRpbGl0eSBh
bmQNCj4gcGVyZm9ybWFuY2UuIEFuZCBtYW55IHRvb2xzIHVzZSBhIHNpbWlsYXIgbWV0aG9kIGZv
ciBmZXRjaGluZyBsYXJnZQ0KPiBkYXRhc2V0cy4gVG9vbHMgYXJlIGZyZXF1ZW50bHkgd3JpdHRl
biBpbiBweXRob24gb3IgZ28uIA0KPiANCj4gTm9uZSBvZiBteSBjdXN0b21lcnMgaGF2ZSBoaXQg
dGhpcyB5ZXQsIG5vdCBoYXZlIGFueSBlbnRlcnByaXNlDQo+IGN1c3RvbWVycyBhcyBub25lIGhh
dmUgbW92ZWQgdG8gYSBuZXcgZW5vdWdoIGtlcm5lbCB5ZXQgZHVlIHRvIHNsb3cNCj4gdXBncmFk
ZSBjeWNsZXMuIEV2ZW4gUHJveG1veCBoYXZlIG9ubHkganVzdCBzdGFydGVkIHRlc3Rpbmcgb24g
YSBrZXJuZWwNCj4gdmVyc2lvbiA+IDYuMTQuIA0KPiANCj4gSSdtIG1vcmUgdGhhbiBoYXBweSB0
byBoZWxwIGhvd2V2ZXIgSSBjYW4gd2l0aCB0ZXN0aW5nLiBJIGNhbiBydW4NCj4gaW5zdHJ1bWVu
dGVkIGtlcm5lbHMgb3IgdGVzdCBwYXRjaGVzIG9yIHdoYXRldmVyIHlvdSBuZWVkLiBJIGFtIHNv
cnJ5IEkNCj4gaGF2ZW4ndCBiZWVuIGFibGUgdG8gcHJvZHVjZSBhIHN1cGVyIGNsZWFuLCBmYXN0
IHJlcHJvZHVjZXIgKG15IHRlc3QNCj4gY2x1c3RlciBhdCBob21lIGlzIGFsbCBzcGlubmVycyBh
bmQgb25seSA1MDBUQiB1c2FibGUpLiBCdXQgSSBmaWd1cmVkIEkNCj4gbmVlZGVkIHRvIGdldCB0
aGUgd29yZCBvdXQgYXNhcCBhcyBkaXN0cm9zIGFuZCBzb29uIGN1c3RvbWVycyBhcmUgZ29pbmcN
Cj4gdG8gYmUgbW92aW5nIHBhc3QgNi4xMi02LjE0IGtlcm5lbHMgYXMgdGhlIDUtNyB5ZWFyIHVw
ZGF0ZSBjeWNsZQ0KPiBtYXJjaGVzIG9uLiBFc3BlY2lhbGx5IHRob3NlIHdhbnRpbmcgdG8gdGFr
ZSBmdWxsIGFkdmFudGFnZSBvZiBDYWNoZUZTDQo+IGFuZCBlbmNyeXB0aW9uIGZ1bmN0aW9uYWxp
dHkuIA0KPiANCj4gQWdhaW4gdGhhbmtzIGZvciBsb29raW5nIGF0IHRoaXMgYW5kIGRvIHJlYWNo
IG91dCBpZiBJIGNhbiBoZWxwIGluDQo+IGFueXdheS4gSSBhbSBpbiB0aGUgY2VwaCBzbGFjayBp
ZiBpdCdzIGZhc3RlciB0byByZWFjaCBvdXQgdGhhdCB3YXkuDQo+IA0KPiANCg0KVGhhbmtzIGEg
bG90IGZvciBvZiB5b3VyIGVmZm9ydHMuIEkgaG9wZSBpdCB3aWxsIGhlbHAgYSBsb3QuIExldCBt
ZSBzdGFydCB0bw0KcmVwcm9kdWNlIHRoZSBpc3N1ZS4gSSdsbCBsZXQgeW91IGtub3cgaWYgSSBu
ZWVkIGFkZGl0aW9uYWwgZGV0YWlscy4gSSdsbCBzaGFyZQ0KbXkgcHJvZ3Jlc3MgYW5kIHBvdGVu
dGlhbCB0cm91YmxlcyBpbiB0aGUgdGlja2V0IHRoYXQgeW91J3ZlIGNyZWF0ZWQuDQoNClRoYW5r
cywNClNsYXZhLg0K

