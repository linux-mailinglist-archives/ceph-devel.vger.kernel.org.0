Return-Path: <ceph-devel+bounces-3885-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 57785C15708
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Oct 2025 16:27:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9708935539A
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Oct 2025 15:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74CDE2BB17;
	Tue, 28 Oct 2025 15:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X2PjpNGO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8397934320A
	for <ceph-devel@vger.kernel.org>; Tue, 28 Oct 2025 15:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761665203; cv=fail; b=R2ETo4J7Zjlqb233BbE6fyMwY26PDy3zOnJrwOcyUdjeAJQ4POr/oWpcadqi4bL/hZ8wnITbaWjdaTEr74t600FnZHW6CGzTWpC9jY2Xj/pHq0Y9E6m5+p+kMRYR9ETRnNlCdF/u92VQoU9urnP+R1Wzgd4zPcfRp2dwSR1TYkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761665203; c=relaxed/simple;
	bh=8MeR6/aZlxlbfx9cpc3wnlRTE2cqiY5JhPB0YHzHmL4=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=UlTzq0bsI1r/XOFKp99fm4Tii3z3n3HtHuhVsfIQHdfjMU2K+yOZcxRuGuAU7Iuu6lmq67MNP+j7wMDSb44UxDbJ0DB7SQuLzC0WXzDeG4+drJudHc1fJXcrKXoU6EgVTxa3euph5hpCRsfWkKO4dNBonllMvDu5XqbhiXxTDVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X2PjpNGO; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SEcJZo025088;
	Tue, 28 Oct 2025 15:26:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=8MeR6/aZlxlbfx9cpc3wnlRTE2cqiY5JhPB0YHzHmL4=; b=X2PjpNGO
	kvnTjBNY+IjJ01zjd/NbdPL4hpv5ZmwMfsGED8rgr2xQwF34ZH8lE+La5qGCBB4p
	OGBWZB7RZB6EH5440nERLx5V7MpQqga6h9CQr75IhIi8QTFV7FvVIaDvysI76FgR
	pD/XZEHaz1jvL0shZs8G//EYQUDIXbv5ECeC4ulozhG6D9ilHR3fly7+hT18GWLs
	aAhcQk+6FNSOdVwgqvJCqx+feI60EvR4RxTbN+IUYeTKN62HtduHBz/e0MaIbu22
	zbVpeUFevY5ctqqrv1nbUUHkENGFPFiIiWHd+6CmoJ1J6fOKBS3IXT8svIkn2pc5
	vMo9j+Xc9U6uqg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0p9952ap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 15:26:23 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59SFOwFg028265;
	Tue, 28 Oct 2025 15:26:23 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013071.outbound.protection.outlook.com [40.93.201.71])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0p9952ak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 15:26:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rJNWnltBH7QpsQgrMdpg0LakzgERS6PCAsdqVcw6QmHCpGEB0uc2qyfte2prktRHTnMKeSHHkXG3epzqIreR6lcpa05JOH1vQp9u/1VNGmjhr7+8npm6+1W+jGTa269FwNAlQjaALw0AbiPzK1fG6dwdQwd+0MFih507cORgOHVzSsYcja8HAtsjvDIgWXl1osUQx6tazOLRsP0m6eGdI3fp8XzWErotGtVj3r2vN6/JbXqODGptGSJ6UBHeRuos1hM3H/HdR6MmXM5xZGKXXYn6yygLpXNwS10fZ2lqgoU3TJ7ZI0Ujc0wIzF92gWVFYKafr4R93y8tDOES2DVKzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8MeR6/aZlxlbfx9cpc3wnlRTE2cqiY5JhPB0YHzHmL4=;
 b=eS8FPyxm0d2AcSYkdJp2NQA48Dip/h6iCupdQL4QvuZUuv1mdEKSRBNH3vrVe0h1q5XAeDxrLtQkZIHBjpz6ViMF7X8uZSamrrvP+03xel9HxR4gb21HHDfd5NHcgyRSaYHCbF2dMbMyv7/RBhgbyWRI3YRWtJ+iGr8rvY68eNT6bbgFbzt6wz3zVoJIzQTlpxZGNZI4N59SMcy5mQQ8ELmyKMX9tEj5Ff9nRZlmc4Juo9+sK5KLnESNRUW0PdidbrsSIzlU9+kchnhUqEnXOSl1u4h2hZzoko4hZKcbl0oYCZeOQqshROQXvBU3aJjN6hMgonJhn/8phdX48laLzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by LV8PR15MB6709.namprd15.prod.outlook.com (2603:10b6:408:25a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 15:26:21 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9253.017; Tue, 28 Oct 2025
 15:26:20 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ethanwu@synology.com" <ethanwu@synology.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Xiubo Li
	<xiubli@redhat.com>,
        Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "ethan198912@gmail.com"
	<ethan198912@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH 2/2] ceph: fix snapshot context missing in
 ceph_uninline_data
Thread-Index: AQHcMdwlXbwCI2FZRk6YgpGCYjPEOrSsELiAgADzYoCAKtaZAA==
Date: Tue, 28 Oct 2025 15:26:20 +0000
Message-ID: <05735ecdb98feb50bd5edfa6b9910e4c375d6e6a.camel@ibm.com>
References: <20250925104228.95018-1-ethanwu@synology.com>
	 <20250925104228.95018-3-ethanwu@synology.com>
	 <a16d910c-4838-475f-a5b1-a47323ece137@Mail>
	 <b7d93760bc06a4ca6b27f9043cb8310898cf48a4.camel@ibm.com>
	 <ec7440fbf1411b76a1a56e3511e4463716614cf2.camel@ibm.com>
	 <1084d2db-580a-417b-a99c-cbde647fd249@Mail>
In-Reply-To: <1084d2db-580a-417b-a99c-cbde647fd249@Mail>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|LV8PR15MB6709:EE_
x-ms-office365-filtering-correlation-id: 01782e45-d527-4947-2297-08de163658ee
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?anBwZDFlNW9wVGhVOU8wNXlFWlhBM2p1L0d3eWVqV0oybTFJTmlUWlh4U2Mw?=
 =?utf-8?B?c2VHZnU2ZGs5eitURWl0YTNLOVJ0ZFpBYXVzZXpxWS8vYm5xYTl1V00yU2pq?=
 =?utf-8?B?dlExaUcxcDZvSXZBdHlrQmZxSmxHN0p4T2F6UG5DZ3M3NkxUNk4vMUtMZU9a?=
 =?utf-8?B?YnNYU0RVbHE2NW12WlpMY1VmMFAyM00zcTVLZTZ6VHVOZzdlbnoxVElzQzd1?=
 =?utf-8?B?bmlUK2lOL0NOV0ZtZTI3bURSZEhMV3FObHRTNEFFdlFndGlDSUYxZ1dFYTJU?=
 =?utf-8?B?Ukt4S1MxYURzV3dGeWxGMHI4NzJtMGxOTG5Jd3NuUWkvaG9KTlVFRUFYNFQv?=
 =?utf-8?B?cHlqVzROK1Uxd2R3a3AyZWxuNFZNSUZmL3N4U2ZzYWtoeCszUXlHRkJPblhO?=
 =?utf-8?B?ZTJzL05nZlEvRytlUUsyY0dUSGlOWjkwUHA2TFdrM1RLdHo4Y2pKOHBONGNI?=
 =?utf-8?B?QWlwSzFTSGRpRWpndGxVTXNUQk5rMGxDazBHRHR0L3J1MzRtYkovOGR4NkF4?=
 =?utf-8?B?ZWhvd2hDYUsrOTlWOTVNQjZRbENoaGlYNXdKOFdjdEtGWjN3ZVM1ekFpMUd5?=
 =?utf-8?B?WlVveUg1U2k3bDV1V1N1UWYwdHJHVTlVZ2hwb2JidzVMcitJWDNpMjhsRi9M?=
 =?utf-8?B?bG5STEpPeElicmpmV3h3aDZacXd5RGtoNUNSb1N2bS9uSzJ1eTJacnNGNGlr?=
 =?utf-8?B?aFBEQjVENmN6d01NU1EySXI5Z1J3OStRaWJrNW0wQ202anhONHZScnA4OHNp?=
 =?utf-8?B?THliS3hwRitDQkZkY2Nqdi8vclNKZ3hNK08yZkZwUVRKT0JnK3lzbkZhSVg4?=
 =?utf-8?B?Nmh4dVJRbDhQMmxZS2Y3alMydDNaWEZUUEhHUDlVVFR4bUFpY0VTT2MvN0l5?=
 =?utf-8?B?dTFvQUpham1JQUpNK1hrRTZDZjV2amVrcE9RQjFSbTdKcElWenQ1RzYzblBy?=
 =?utf-8?B?dzVQVXpNQ3lJZ0xjMTMzTHREN21qVXc0T2xQY0VxU3pZU0tPbDVhWm13dGs3?=
 =?utf-8?B?ZSt2aVJFaEl5bi9WMWJGTHByLzlXRXZDbTBINzJOVWlzK3N5UjAzQTFoOXJZ?=
 =?utf-8?B?bG9YZzdmQWF2QWVwZ2pqNFB3SEhvZGFibDF6S0ZUWUEzVEc4S2hOMDUzamEz?=
 =?utf-8?B?M1pQbDdFK2FjUS90dlJDbjB4N0dkN2tNRFRFWHdxWkNaZlY1OXlNL051enF6?=
 =?utf-8?B?NVg5NGRIQlFTTHpvZit1d0lPWEhvb1grV0FXOEZuaEJRZVMzUW5pSDl3a1FS?=
 =?utf-8?B?U1R6RnI1Y0MvZTFud3ZsZWpCeG1oQXFFeW9HdmZwWVM5eUVrYmhJcXJCYXZT?=
 =?utf-8?B?Yjc4TlRQbzNVVHhla1Z6UDVxYmVBa1g5MzgxUjJCeE9yM2tTcVhUeXVRelBY?=
 =?utf-8?B?YmM3TWg2YWRvdjZuRUc4WDJUSFI4MjkrVFVFWW9NN2g2cTRnc3hnVlJzUGVn?=
 =?utf-8?B?bFlKem9rSFJxZEROSDh4Qm1ON0x1bElFaXJ4R2ZGOFdoKzl4VnpsNU5tYVQw?=
 =?utf-8?B?TnlGWmp1NHIrUE1SY1Z4RUNIdEVmM2NsTlFWemgrdUVvakNSS2NGN25hc3Vy?=
 =?utf-8?B?dUhDTXE5TENiRWd1R3h0U1FNSXVIb20rdFFiWFh3OGlRWlN5NGNvS2FKekFx?=
 =?utf-8?B?MFVGOFI2MHdremw5TkhYSmJwMEZyeUV5em93dk5EMVBLdno4TTZGNlFNd2Vp?=
 =?utf-8?B?VHJlNjRMUjA3UWNNb1Zid0pNZ2RYRjc2ZU9XejhVdjQzRjR5UHNPbkUxajJC?=
 =?utf-8?B?QzZlZDhTbE9uQlozd0N5bnRObVp1UGdmVXp0bTFySnFOMVpuYktDNlo4cW84?=
 =?utf-8?B?TENIcEFQVUdLNmRKRXR6YkJvQUpsWW81Nnp2S0wwRE8yaXRGZ0hSdWptWjZq?=
 =?utf-8?B?a2V0Vmk0V0Q2L2pCT0pRRkszQ2lBK1VmQzBRcmNadkZ1NWxuSVNweGVFTU5V?=
 =?utf-8?B?NU9DVHJHKzJhWisvNVpiZnkxNWhkRmZTQXBMRVhqeDNSOHF2RjBISnA2aXVy?=
 =?utf-8?B?aVIyY2pyYXh6MlVtRVk1U20ybEdCaVhlbmdIZ2lLS3pIUDQySlZlZWtKR09M?=
 =?utf-8?Q?37qqsU?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?d05PSWNwVHBLUE41OGQ4aU4vdUJSV3RHOFd1VFlCM3ArRmZNRS9COVV4bzhz?=
 =?utf-8?B?STJxaCszQWVvT3N5SVdpZVdNejNaZFh6R2xuQWJubGw5NWFrVTVTMEw4OXd0?=
 =?utf-8?B?clJvZ1BVcDdnNXV1T1RrQUF3NWR3bHNmajFLMnJLMEgySEUzQWxHdFNGaWEz?=
 =?utf-8?B?cXcrbDA2b0hlYWxjTmhTVTNjQzhOZ3ZCc2FKaDdOVE44dEVabVYvTUwxN2I4?=
 =?utf-8?B?cFNtb0RONUd5amo2MFVmc0xsVisyQ2RUZTduVVpuMjRCOFZrY1JYRmZvQUlE?=
 =?utf-8?B?RUVMUzhjc2xybXM5b2RqTm9FaGZ3NytTbm9VamtiTkJMdXNxcVRGMTdGMXBL?=
 =?utf-8?B?Zmw4akNNbVo2RWVnQVM1cDE0cGlQNmZGbU1oeVpONFVGUHAwcU9ycmJSYlZN?=
 =?utf-8?B?NVlZVkhoRmhLTEsyWjd5R0dNR1JOZGpvNkxXSmpQdVJ3K2lpT051Q3pCN3N5?=
 =?utf-8?B?ZmZTdyswdS96NEd1QXp6cllpVE5pU1ZsSkRLZ1VESGpZK0VBUWNhSjUxWmVX?=
 =?utf-8?B?bXV0cjZGNkkwTHhjQU9CT2wwM01jOE1UbEFteFZpMzQ0QStSWUd3MVV5SlVQ?=
 =?utf-8?B?N2dPQ1NXaU11L1JUU2VmUDQzSXI2UWhKMjl2amM1VCtrWEFsV3UvT282dnJ4?=
 =?utf-8?B?MHJGL0NZdVlicCt1cmhEZjlNYjhHY1p3dkFOUENmak1SekFzOUVzVTYyU21m?=
 =?utf-8?B?K2M5M2NSN2ZqaW93WDZieERzSk1HeTdqdVczNkc4RmlsMS9sc2NKL05jbnph?=
 =?utf-8?B?MXhiT2JkblVjTWFEZ3V0ZFZHaWd1eVVLZVg3ajBtU2E5UTk1K3A2VkpYeXdK?=
 =?utf-8?B?MWQ1LzFOWGtWaXIzTXc2MnFQM1lJekFtOVJKYUJ3bnVlSWdLOWUzc2h5SVVX?=
 =?utf-8?B?a0l3N2ZqejhNVWJOa2F1ZGdOcjhzUEVEZzhJak83bzBsSmNrYVV4akFZdFVT?=
 =?utf-8?B?cWNpek1EQlU3Zm9ab09naVdVaGtBbW9ZNHJkbTlKTHJFODNCYm1oeS9mQ1N6?=
 =?utf-8?B?a1ZvZ3l3aU5EWUQ5QjNoWmJLTFF5emVLNkhoN2ZXN3JML1ZlZS9ONm1aZ2wx?=
 =?utf-8?B?Z3hsdW50Ui95RjJJa0o3Z2JabEdHN1dibnZXRUFGa2hHNXlMMktGMEZ6ekJ0?=
 =?utf-8?B?eFNOMDhMUVBoOFdmemw2amsyUHBsbEhNUGVCRFVjb2xMQ0k0LzdZZmN1eTV3?=
 =?utf-8?B?czZWY2hwZ3NSRnlUUnNjZFNBemxEQTFudmhQamdwOHNsRDZoYmNvQmJyZXFD?=
 =?utf-8?B?anU0SUQwT1FOWFIyazlmRFRmTnlWbGdsbXBzYjdITUVKakYvaFRaYzBaTUtQ?=
 =?utf-8?B?cWIxMFAzWmpHK2V4MDQrbUUrdmJhcXVOUktPaEJjTGVTYlBMMGdzRmxlSjRw?=
 =?utf-8?B?KzhNM2dEbFI1c3RyN1lJY2M0RkoxS3NIMW1TMzFrSnd1UFdYUmNpaWIwUk9u?=
 =?utf-8?B?TldxbGhIUHF4ODRRaXJGTCt0UDk5SXVUd04vdE5sRDVrVW45YmNMdXE0M1k0?=
 =?utf-8?B?OEJPazNsRjVRSW9RUVB4L1dBRzZrVUdEdGxaQmp6OGhUNTNjKytnTUxKV0l2?=
 =?utf-8?B?RUVmbWtrbktKQ1hzZzRoWGUvTVFVeDB1dGQ1ZUlrQXhsZ3czOUVYbHp1dWtS?=
 =?utf-8?B?OEoyakpaemxFMjZpRERwL2RSV1VTakxsWENWNjh0MlJJYXVNTEIzRU5uZ2JX?=
 =?utf-8?B?MVl6aVVVbXRURml2eVdXUHpKTVpzY3UyUjNvMGw0cks0aXFYS0JDVG8wOTVZ?=
 =?utf-8?B?VmNwbFB3bnk5S2dRL1dsSkJibHJuODhxc3lEOCtEVy9oZ08yWnRQVE9md01F?=
 =?utf-8?B?S2wzTEd6RTMrb1VJRHNnMys0U1pTRmlNQVgvdFVWNHhWZjZ5aHUvQ2lvQVhI?=
 =?utf-8?B?b3dVWU9yVk1GS1RIUVlkb25xb0RrbzRXRkN3ZGNrdnFucitOamRzdHlJQmdm?=
 =?utf-8?B?ZHVEY1hBNlRKQXVibTBoaC9MVmdsVllXcXZMcmtydkdsYUhVb0phZG1IRFA0?=
 =?utf-8?B?dEhvay8zTzRoNjQraENHRFFOdHlsTUx1OENod3B5L1I4dDB2emZOVEg3TGQv?=
 =?utf-8?B?ejlQb0lBVHBSWjNRMndSUytsVVRuUDUrOXQrbU54cDRQbXR0ZGJ1TllDQ2Fk?=
 =?utf-8?B?Y3ZXNENIU3h4WEV1ajNKeWNqUFFVdzI2eWtXcVdzbUczTEwrQmNOSG5weXRR?=
 =?utf-8?Q?Bdn52ekeRu7dOESCyw8Vhvs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C883495AD720724EBBB7928FFA1D2A95@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 01782e45-d527-4947-2297-08de163658ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2025 15:26:20.9140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hSOQQ0DR9Lk5t9jXss6RIN7A7yXFgPmVeMRAAedyjiDJZwINuUu+lZUd5Yd5Qj/DvwyAuK2hhzpL6iULzAAimg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR15MB6709
X-Authority-Analysis: v=2.4 cv=JqL8bc4C c=1 sm=1 tr=0 ts=6900e09f cx=c_pps
 a=J0RhwYao4za//xiv/28V8w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=QWb7glRVjEOIhbxoX4sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: -yHXY4y_7mtrhKlfV19PMt6Uan-eMS_T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAxOSBTYWx0ZWRfXzinOFQzu40lU
 8rMTHfHYxSflXu4zqFfZED6W+mi7WJ02mA9Ab7K4HG+XFLq7hpBxKLpkg13CVhZSHY/jA59QYXV
 v56XhpBIn8JSm5mKB61pAUtjgpwYR4rUuFo7TgOj9dT4Eg/v5Woq58m0Io8DvtOvdZoEJ5nO45W
 6mUI6D8AsTy2TgVXD7yIEnfeU1Bb4sfs9Aid+b2k1dpSuZyzwW/WXI8QT7VsqAscUl//1SJ0MjH
 eMj5KoctijVs3vDC5g4EKEXaHk/rDPtIYyoobLP9sOTKueXqWh8d5aCr/qR5kd180LT07zl8cJd
 4qLz6ZcClwgOlJQAsT7Kv6iYGaU0QWOdkoQzhBZA+E9fdOC4vqR4rStmq74+j4Y2XhXYJZnrHnH
 fcqv3PtYx9iUFa7Di7sPylfhkCiOzA==
X-Proofpoint-ORIG-GUID: 0XADxV2qpUpzzD1t6OGUlnF2bJnjnSlH
Subject: RE: [PATCH 2/2] ceph: fix snapshot context missing in
 ceph_uninline_data
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_05,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510250019

T24gV2VkLCAyMDI1LTEwLTAxIGF0IDE3OjE1ICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiBWaWFj
aGVzbGF2IER1YmV5a28gPFNsYXZhLuKAikR1YmV5a29A4oCKaWJtLuKAimNvbT4g5pa8IDIwMjUt
MTAtMDEgMDI64oCKNDQg5a+r6YGT77yaIE9uIFR1ZSwgMjAyNS0wOS0zMCBhdCAxNTrigIozMCAr
MDgwMCwgZXRoYW53dSB3cm90ZTogPiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLiBEdWJleWtv
QCBpYm0uIGNvbT4g5pa8IDIwMjUtMDktMjcgMDU6IDUyIOWvq+mBk++8miBPbiBUaHUsIDIwMjUt
MDktMjUgYXQgMTg6IDQyICswODAwLCBldGhhbnd1DQo+IA0KPiBWaWFjaGVzbGF2IER1YmV5a28g
PFNsYXZhLkR1YmV5a29AaWJtLmNvbT4g5pa8IDIwMjUtMTAtMDEgMDI6NDQg5a+r6YGT77yaDQo+
ID4gT24gVHVlLCAyMDI1LTA5LTMwIGF0IDE1OjMwICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiA+
ID4gVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS7igIpEdWJleWtvQOKAimlibS7igIpjb20+IOaW
vCAyMDI1LTA5LTI3IDA1OuKAijUyIOWvq+mBk++8miBPbiBUaHUsIDIwMjUtMDktMjUgYXQgMTg6
4oCKNDIgKzA4MDAsIGV0aGFud3Ugd3JvdGU6ID4gVGhlIGNlcGhfdW5pbmxpbmVfZGF0YSBmdW5j
dGlvbiB3YXMgbWlzc2luZyBwcm9wZXIgc25hcHNob3QgY29udGV4dCA+IGhhbmRsaW5nIGZvciBp
dHMgT1NEIHdyaXRlIG9wZXJhdGlvbnMuIEJvdGgNCj4gPiA+IMKgDQo+ID4gPiANCj4gPiA+IFZp
YWNoZXNsYXYgRHViZXlrbyA8U2xhdmEuRHViZXlrb0BpYm0uY29tPiDmlrwgMjAyNS0wOS0yNyAw
NTo1MiDlr6vpgZPvvJoNCj4gPiA+ID4gT24gVGh1LCAyMDI1LTA5LTI1IGF0IDE4OjQyICswODAw
LCBldGhhbnd1IHdyb3RlOg0KPiA+ID4gPiA+IFRoZSBjZXBoX3VuaW5saW5lX2RhdGEgZnVuY3Rp
b24gd2FzIG1pc3NpbmcgcHJvcGVyIHNuYXBzaG90IGNvbnRleHQNCj4gPiA+ID4gPiBoYW5kbGlu
ZyBmb3IgaXRzIE9TRCB3cml0ZSBvcGVyYXRpb25zLiBCb3RoIENFUEhfT1NEX09QX0NSRUFURSBh
bmQNCj4gPiA+ID4gPiBDRVBIX09TRF9PUF9XUklURSByZXF1ZXN0cyB3ZXJlIHBhc3NpbmcgTlVM
TCBpbnN0ZWFkIG9mIHRoZSBhcHByb3ByaWF0ZQ0KPiA+ID4gPiA+IHNuYXBzaG90IGNvbnRleHQs
IHdoaWNoIGNvdWxkIGxlYWQgdG8gdW5uZWNlc3Nhcnkgb2JqZWN0IGNsb25lLg0KPiA+ID4gPiA+
IA0KPiA+ID4gPiA+IFJlcHJvZHVjZXI6DQo+ID4gPiA+ID4gLi4vc3JjL3ZzdGFydC5zaCAtLW5l
dyAteCAtLWxvY2FsaG9zdCAtLWJsdWVzdG9yZQ0KPiA+ID4gPiA+IC8vIHR1cm4gb24gY2VwaGZz
IGlubGluZSBkYXRhDQo+ID4gPiA+ID4gLi9iaW4vY2VwaCBmcyBzZXQgYSBpbmxpbmVfZGF0YSB0
cnVlIC0teWVzLWktcmVhbGx5LXJlYWxseS1tZWFuLWl0DQo+ID4gPiA+ID4gLy8gYWxsb3cgZnNf
YSBjbGllbnQgdG8gdGFrZSBzbmFwc2hvdA0KPiA+ID4gPiA+IC4vYmluL2NlcGggYXV0aCBjYXBz
IGNsaWVudC5mc19hIG1kcyAnYWxsb3cgcndwcyBmc25hbWU9YScgbW9uICdhbGxvdyByIGZzbmFt
ZT1hJyBvc2QgJ2FsbG93IHJ3IHRhZyBjZXBoZnMgZGF0YT1hJw0KPiA+ID4gPiA+IC8vIG1vdW50
IGNlcGhmcyB3aXRoIGZ1c2UsIHNpbmNlIGtlcm5lbCBjZXBoZnMgZG9lc24ndCBzdXBwb3J0IGlu
bGluZSB3cml0ZQ0KPiA+ID4gPiA+IGNlcGgtZnVzZSAtLWlkIGZzX2EgLW0gMTI3LjAuMC4xOjQw
MzE4IC0tY29uZiBjZXBoLmNvbmYgLWQgL21udC9teWNlcGhmcy8NCj4gPiA+ID4gPiAvLyBidW1w
IHNuYXBzaG90IHNlcQ0KPiA+ID4gPiA+IG1rZGlyIC9tbnQvbXljZXBoZnMvLnNuYXAvc25hcDEN
Cj4gPiA+ID4gPiBlY2hvICJmb28iID4gL21udC9teWNlcGhmcy90ZXN0DQo+ID4gPiA+ID4gLy8g
dW1vdW50IGFuZCBtb3VudCBpdCBhZ2FpbiB1c2luZyBrZXJuZWwgY2VwaGZzIGNsaWVudA0KPiA+
ID4gPiA+IHVtb3VudCAvbW50L215Y2VwaGZzDQo+ID4gPiA+ID4gbW91bnQgLXQgY2VwaCBmc19h
QC5hPS8gL21udC9teWNlcGhmcy8gLW8gY29uZj0uL2NlcGguY29uZg0KPiA+ID4gPiA+IGVjaG8g
ImJhciIgPj4gL21udC9teWNlcGhmcy90ZXN0DQo+ID4gPiA+ID4gLi9iaW4vcmFkb3MgbGlzdHNu
YXBzIC1wIGNlcGhmcy5hLmRhdGEgJChwcmludGYgIiV4XG4iICQoc3RhdCAtYyAlaSAvbW50L215
Y2VwaGZzL3Rlc3QpKS4wMDAwMDAwMA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IHdpbGwgc2VlIHRo
aXMgb2JqZWN0IGRvZXMgdW5uZWNlc3NhcnkgY2xvbmUNCj4gPiA+ID4gPiAxMDAwMDAwMDAwYS4w
MDAwMDAwMCAoc2VxOjIpOg0KPiA+ID4gPiA+IGNsb25laWQgc25hcHMgICBzaXplICAgIG92ZXJs
YXANCj4gPiA+ID4gPiAyICAgICAgIDIgICAgICAgNCAgICAgICBbXQ0KPiA+ID4gPiA+IGhlYWQg
ICAgLSAgICAgICA4DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gYnV0IGl0J3MgZXhwZWN0ZWQgdG8g
c2VlDQo+ID4gPiA+ID4gMTAwMDAwMDAwMDAuMDAwMDAwMDAgKHNlcToyKToNCj4gPiA+ID4gPiBj
bG9uZWlkIHNuYXBzICAgc2l6ZSAgICBvdmVybGFwDQo+ID4gPiA+ID4gaGVhZCAgICAtICAgICAg
IDgNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBzaW5jZSB0aGVyZSdzIG5vIHNuYXBzaG90IGJldHdl
ZW4gdGhlc2UgMiB3cml0ZXMNCj4gPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+IE1heWJlLCBJ
IGFtIGRvaW5nIHNvbWV0aGluZyB3cm9uZyBoZXJlLiBCdXQgSSBoYXZlIHRoZSBzYW1lIGlzc3Vl
IG9uIHRoZSBzZWNvbmQNCj4gPiA+ID4gVmlydHVhbCBNYWNoaW5lIHdpdGggYXBwbGllZCBwYXRj
aDoNCj4gPiA+ID4gDQo+ID4gPiA+IFZNMSAod2l0aG91dCBwYXRjaCk6DQo+ID4gPiA+IA0KPiA+
ID4gPiBzdWRvIGNlcGgtZnVzZSAtLWlkIGFkbWluIC9tbnQvY2VwaGZzLw0KPiA+ID4gPiAvbW50
L2NlcGhmcy90ZXN0LXNuYXBzaG90MyMgbWtkaXIgLi8uc25hcC9zbmFwMQ0KPiA+ID4gPiAvbW50
L2NlcGhmcy90ZXN0LXNuYXBzaG90MyMgZWNobyAiZm9vIiA+IC4vdGVzdA0KPiA+ID4gPiB1bW91
bnQgL21udC9jZXBoZnMNCj4gPiA+ID4gDQo+ID4gPiA+IG1vdW50IC10IGNlcGggOi8gL21udC9j
ZXBoZnMvIC1vIG5hbWU9YWRtaW4sZnM9Y2VwaGZzDQo+ID4gPiA+IC9tbnQvY2VwaGZzL3Rlc3Qt
c25hcHNob3QzIyBlY2hvICJiYXIiID4+IC4vdGVzdA0KPiA+ID4gPiAvbW50L2NlcGhmcy90ZXN0
LXNuYXBzaG90MyMgcmFkb3MgbGlzdHNuYXBzIC1wIGNlcGhmc19kYXRhICQocHJpbnRmICIleFxu
Ig0KPiA+ID4gPiAkKHN0YXQgLWMgJWkgLi90ZXN0KSkuMDAwMDAwMDANCj4gPiA+ID4gMTAwMDAz
MTNjYjEuMDAwMDAwMDA6DQo+ID4gPiA+IGNsb25laWQgc25hcHMgc2l6ZSBvdmVybGFwDQo+ID4g
PiA+IDQgNCA0IFtdDQo+ID4gPiA+IGhlYWQgLSA4DQo+ID4gPiA+IA0KPiA+ID4gPiBWTTIgKHdp
dGggcGF0Y2gpOg0KPiA+ID4gPiANCj4gPiA+ID4gY2VwaC1mdXNlIC0taWQgYWRtaW4gL21udC9j
ZXBoZnMvDQo+ID4gPiA+IC9tbnQvY2VwaGZzL3Rlc3Qtc25hcHNob3Q0IyBta2RpciAuLy5zbmFw
L3NuYXAxDQo+ID4gPiA+IC9tbnQvY2VwaGZzL3Rlc3Qtc25hcHNob3Q0IyBlY2hvICJmb28iID4g
Li90ZXN0DQo+ID4gPiA+IHVtb3VudCAvbW50L2NlcGhmcw0KPiA+ID4gPiANCj4gPiA+ID4gbW91
bnQgLXQgY2VwaCA6LyAvbW50L2NlcGhmcy8gLW8gbmFtZT1hZG1pbixmcz1jZXBoZnMNCj4gPiA+
ID4gL21udC9jZXBoZnMvdGVzdC1zbmFwc2hvdDQjIGVjaG8gImJhciIgPj4gLi90ZXN0DQo+ID4g
PiA+IC9tbnQvY2VwaGZzL3Rlc3Qtc25hcHNob3Q0IyByYWRvcyBsaXN0c25hcHMgLXAgY2VwaGZz
X2RhdGEgJChwcmludGYgIiV4XG4iDQo+ID4gPiA+ICQoc3RhdCAtYyAlaSAuL3Rlc3QpKS4wMDAw
MDAwMA0KPiA+ID4gPiAxMDAwMDMxM2NiMy4wMDAwMDAwMDoxMDAwMDMxM2NiMy4wMDAwMDAwMDoN
Cj4gPiA+ID4gY2xvbmVpZCBzbmFwcyBzaXplIG92ZXJsYXANCj4gPiA+ID4gNSA1IDAgW10NCj4g
PiA+ID4gaGVhZCAtIDQNCj4gPiA+IA0KPiA+ID4gwqANCj4gPiA+IA0KPiA+ID4gTG9va3MgbGlr
ZSB0aGUgY2xvbmUgY29tZXMgZnJvbSB0aGUgZmlyc3QgdGltZSB3ZSBhY2Nlc3MgcG9vbC4NCj4g
PiA+IGNlcGhfd3JpdGVfaXRlcg0KPiA+ID4gLS1jZXBoX2dldF9jYXBzDQo+ID4gPiAtLS0tX19j
ZXBoX2dldF9jYXBzDQo+ID4gPiAtLS0tLS1jZXBoX3Bvb2xfcGVybV9jaGVjaw0KPiA+ID4gLS0t
LS0tLS1fX2NlcGhfcG9vbF9wZXJtX2dldA0KPiA+ID4gLS0tLS0tLS0tY2VwaF9vc2RjX2FsbG9j
X3JlcXVlc3QNCj4gPiA+IMKgDQo+ID4gPiANCj4gPiA+IElmIG5vIGV4aXN0aW5nIHBvb2wgcGVy
bSBmb3VuZCwgaXQgd2lsbCB0cnkgdG8gcmVhZC93cml0ZSB0aGUgcG9vbCBpbm9kZSBsYXlvdXQg
cG9pbnRzIHRvDQo+ID4gPiBidXQgY2VwaF9vc2RjX2FsbG9jX3JlcXVlc3QgZG9lc24ndCBwYXNz
IHNuYXBjDQo+ID4gPiANCj4gPiA+IA0KPiA+ID4gc28gdGhlIHNlcnZlciBzaWRlIHdpbGwgaGF2
ZSBhIHplcm8gc2l6ZSBvYmplY3Qgd2l0aCBzbmFwIHNlcSAwDQo+ID4gPiDCoA0KPiA+ID4gDQo+
ID4gPiBuZXh0IHRpbWUgd3JpdGUgYXJyaXZlcywgc2luY2Ugd3JpdGUgaXMgZXF1aXBwZWQgd2l0
aCBzbmFwIHNlcSA+MA0KPiA+ID4gc2VydmVyIHNpZGUgd2lsbCBkbyBvYmplY3QgY2xvbmUuDQo+
ID4gPiDCoA0KPiA+ID4gDQo+ID4gPiBUaGlzIGNhbiBiZSBlYXNpbHkgcmVwcm9kdWNlLCB3aGVu
IHRoZXJlIGFyZSBzbmFwc2hvdHMoc28gd3JpdGUgd2lsbCBoYXZlIHNuYXAgc2VxID4gMCkuDQo+
ID4gPiBUaGUgZmlyc3Qgd3JpdGUgdG8gdGhlIHBvb2wgZWNobyAiZm9vIiA+IC9tbnQvbXljZXBo
ZnMvZmlsZQ0KPiA+ID4gd2lsbCByZXN1bHQgaW4gdGhlIGZvbGxvd2luZyBvdXRwdXQNCj4gPiA+
IDEwMDAwMDAwMDA5LjAwMDAwMDAwIChzZXE6Myk6DQo+ID4gPiBjbG9uZWlkIHNuYXBzIHNpemUg
b3ZlcmxhcA0KPiA+ID4gMyAyLDMgMCBbXQ0KPiA+ID4gaGVhZCAtIDQNCj4gPiA+IMKgDQo+ID4g
PiANCj4gPiA+IEkgdGhpbmsgdGhpcyBjb3VsZCBiZSBmaXhlZCBieSB1c2luZyBhIHNwZWNpYWwg
cmVzZXJ2ZWQgaW5vZGUgbnVtYmVyIHRvIHRlc3QgcG9vbCBwZXJtIGluc3RlYWQgb2YgdXNpbmcg
dGhhdCBpbm9kZQ0KPiA+ID4gSSBjaGFuZ2UgDQo+ID4gPiBjZXBoX29pZF9wcmludGYoJnJkX3Jl
cS0+cl9iYXNlX29pZCwgIiVsbHguMDAwMDAwMDAiLCBjaS0+aV92aW5vLmlubyk7DQo+ID4gPiB1
bmRlciB0byBfX2NlcGhfcG9vbF9wZXJtX2dldA0KPiA+ID4gY2VwaF9vaWRfcHJpbnRmKCZyZF9y
ZXEtPnJfYmFzZV9vaWQsICIlbGx4LjAwMDAwMDAwIiwgTExPTkdfTUFYKTsNCj4gPiA+IHRoZSB1
bm5lY2Vzc2FyeSBjbG9uZSB3b24ndCBoYXBwZW4gYWdhaW4uDQo+ID4gPiDCoA0KPiA+ID4gDQo+
ID4gDQo+ID4gRnJhbmtseSBzcGVha2luZywgSSBkb24ndCBxdWl0ZSBmb2xsb3cgdG8geW91ciBh
bnN3ZXIuIDopIFNvLCBkb2VzIHBhdGNoIG5lZWRzDQo+ID4gdG8gYmUgcmV3b3JrZWQ/IE9yIG15
IHRlc3Rpbmcgc3RlcHMgYXJlIG5vdCBmdWxseSBjb3JyZWN0Pw0KPiA+IA0KPiA+IFRoYW5rcywN
Cj4gPiBTbGF2YS4NCj4gDQo+IMKgDQo+IEl0J3MgYW5vdGhlciBwbGFjZSB0aGF0IG1pc3NlcyBz
bmFwc2hvdCBjb250ZXh0Lg0KPiBwb29sIHBlcm1pc3Npb24gY2hlY2sgbGliY2VwaGZzIGFuZCBr
ZXJuZWwgY2VwaGZzIGRvZXMgbm90IGVxdWlwIHNuYXBzaG90IGNvbnRleHQNCj4gd2hlbiBpc3N1
aW5nwqBDRVBIX09TRF9PUF9DUkVBVEUgZm9yIHBvb2wgd3JpdGUgcGVybWlzc2lvbiBjaGVjay4N
Cj4gwqANCj4gV2hlbiBrZXJuZWwgY2VwaGZzIGNhbGzCoGNlcGhfZ2V0X2NhcHMgb3LCoGNlcGhf
dHJ5X2dldF9jYXBzDQo+IGl0IG1heSBuZWVkwqAgY2VwaF9wb29sX3Blcm1fY2hlY2soaWYgbm8g
cG9vbCBwZXJtaXNzaW9uIGNoZWNrIGlzIGV2ZXIgZG9uZSBmb3IgdGhhdCBwb29sKS4NCj4gY2Vw
aF9wb29sX3Blcm1fY2hlY2sgd2lsbCB0cnkgdG8gaXNzdWUgYm90aCByZWFkIGFuZCB3cml0ZSh1
c2UgQ0VQSF9PU0RfT1BfQ1JFQVRFLCkgcmVxdWVzdCBvbiB0YXJnZXQgaW5vZGUgdG8gdGhlIHBv
b2wgdGhhdCBpbm9kZSBiZWxvbmdzIHRvDQo+IChzZWUgZnMvY2VwaC9hZGRyLmM6X19jZXBoX3Bv
b2xfcGVybV9nZXQpDQo+IGl0IHVzZXPCoGNlcGhfb3NkY19hbGxvY19yZXF1ZXN0IHdpdGhvdXQg
Z2l2aW5nIHNuYXAgY29udGV4dCwNCj4gc28gdGhlIHNlcnZlciBzaWRlIHdpbGwgZmlyc3QgY3Jl
YXRlIGFuIGVtcHR5IG9iamVjdCB3aXRoIG5vIHNuYXBzaG90IHNlcXVlbmNlLg0KPiDCoA0KPiB3
ZSdsbCBzZWUgdGhlIGZvbGxvd2luZyBvdXRwdXQgZnJvbcKgLi9iaW4vcmFkb3MgbGlzdHNuYXBz
IC1wIGNlcGhmcy5hLmRhdGEgJChwcmludGYgIiV4XG4iICQoc3RhdCAtYyAlaSAvbW50L215Y2Vw
aGZzL3Rlc3QpKS4wMDAwMDAwDQo+IDEwMDAwMDAwMDMyLjAwMDAwMDAwIChzZXE6MCk6DQo+IGNs
b25laWTCoCBzbmFwc8KgIHNpemUgb3ZlcmxhcA0KPiBoZWFkwqAgwqAgwqAgLcKgIMKgIMKgIMKg
IMKgIDANCj4gwqANCj4gTGF0ZXIgd2hlbiBkYXRhIGlzIHdyaXR0ZW4gYmFjaywgaXQgd3JpdGUg
b3AgaXMgZXF1aXBwZWQgd2l0aCBzbmFwc2hvdCBjb250ZXh0Lg0KPiBjb21wYXJlIHRoZSBzbmFw
c2hvdCBpZCB3aXRoIHRoZSBvYmplY3Qgc25hcCBzZXENCj4gT1NEIHRoaW5rcyB0aGVyZSdzIGEg
c25hcHNob3QgYW5kIGNsb25lIGlzIG5lZWRlZC4NCj4gwqANCj4gY2VwaC1mdXNlIC0taWQgYWRt
aW4gL21udC9jZXBoZnMvDQo+IC9tbnQvY2VwaGZzL3Rlc3Qtc25hcHNob3Q0IyBta2RpciAuLy5z
bmFwL3NuYXAxDQo+IC9tbnQvY2VwaGZzL3Rlc3Qtc25hcHNob3Q0IyBlY2hvICJmb28iID4gLi9k
dW1teSAjZXJyb3Igb25lDQo+IC9tbnQvY2VwaGZzL3Rlc3Qtc25hcHNob3Q0IyBlY2hvICJmb28i
ID4gLi90ZXN0wqAgI2NvcnJlY3Qgb25lIGJlY2F1c2UgZGF0YSBpcyBpbmxpbmVkLMKgDQo+IMKg
DQo+IHJhZG9zIGxpc3RzbmFwcyAtcCBjZXBoZnNfZGF0YSAkKHByaW50ZiAiJXhcbiIgJChzdGF0
IC1jICVpIC4vZHVtbXkpKS4wMDAwMDAwMA0KPiB3aWxsIHNlZQ0KPiAxMDAwMDAwMDAzMi4wMDAw
MDAwMCAoc2VxOjApOg0KPiBjbG9uZWlkwqAgc25hcHPCoCBzaXplIG92ZXJsYXANCj4gaGVhZMKg
IMKgIMKgIC3CoCDCoCDCoCDCoCDCoCAwDQo+IGJ1dA0KPiByYWRvcyBsaXN0c25hcHMgLXAgY2Vw
aGZzX2RhdGEgJChwcmludGYgIiV4XG4iICQoc3RhdCAtYyAlaSAuL3Rlc3QpKS4wMDAwMDAwMA0K
PiBzaG93cyAoMikgTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQ0KPiBzZWVpbmcgRU5PRU5UIGlz
IGNvcnJlY3QgYmVoYXZpb3IgYmVjYXVzZSBkYXRhIGlzIGlubGluZWQuDQo+IMKgDQoNClNvcnJ5
LCBJIHdhcyBpbiBwZXJzb25hbCB0cmlwIHRoZSBsYXN0IHRocmVlIHdlZWtzLiBTbywgSSB3YXNu
J3QgYWJsZSB0byB0YWtlIGENCmRlZXBlciBsb29rIGludG8gdGhpcy4NCg0KSSBzdGlsbCBjYW5u
b3QgY29uZmlybSB0aGF0IHRoZSBwYXRjaCBmaXhlcyB0aGUgaXNzdWUuIFRoZSBwYXRjaCdzIGNv
bW1pdA0KbWVzc2FnZSBjb250YWlucyBleHBsYW5hdGlvbiBvZiBzdGVwcyBhbmQgdGhlIGV4cGVj
dGVkIG91dGNvbWUuIEFuZCBJIHNlZSB0aGUNCmRpZmZlcmVudCBvdXRjb21lLCB0aGlzIGlzIHdo
eSBJIGNhbm5vdCBjb25maXJtIHRoYXQgcGF0Y2ggZml4ZXMgdGhlIGlzc3VlLiBJDQpiZWxpZXZl
IHRoYXQgdGhlIGNvbW1pdCBtZXNzYWdlIHJlcXVpcmVzIG1vcmUgY2xlYXIgZXhwbGFuYXRpb24g
b2Ygc3RlcHMgdGhhdCBJDQpjYW4gcmVwcm9kdWNlIGFuZCB0byBzZWUgdGhlIHNhbWUgcmVzdWx0
IGFzIGV4cGVjdGVkIG91dGNvbWUuDQoNClRoYW5rcywNClNsYXZhLg0K

