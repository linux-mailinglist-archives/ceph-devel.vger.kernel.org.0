Return-Path: <ceph-devel+bounces-4339-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F084D06009
	for <lists+ceph-devel@lfdr.de>; Thu, 08 Jan 2026 21:12:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 872BE300F64C
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jan 2026 20:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7CB32D42B;
	Thu,  8 Jan 2026 20:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PTKUUc/X"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93C12D73B5;
	Thu,  8 Jan 2026 20:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767903160; cv=fail; b=quMNPt3uPwg9w82QW11U3qJ1+XkLqYBYMbT7eCt+adoa4EzcVz8tusT6XsdiJjbA3ZqYhAmC+lInpGbdr1mPy0KOShNXXtc717DPlGXiUPHflJiHiBVCKPLwnlUrytPWrL/xhCIDBriMb7zANmbukHDnfwM0JL6yc2+3IWxsyps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767903160; c=relaxed/simple;
	bh=GcRmkf2647zwrhr38nNe50LW5N6ShmqLwe4v9s6iPWU=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=BeqI7Oa1XyP24INZBJC5bBkaPYMUZsfnIIrHhk0V5dW/yt1qoQn1B3PvdxH6cUp2qWFwmPa71d3Wn1bsY0/sEHLJOHcd4m/FQvs8RcpJixKKrqGjhnMPswZVikVg6ffqeHcI3TLhCc4FDi+JqAxlfqTig5kGPQpik6gWB9T1yts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PTKUUc/X; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 608JwstR014123;
	Thu, 8 Jan 2026 20:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=GcRmkf2647zwrhr38nNe50LW5N6ShmqLwe4v9s6iPWU=; b=PTKUUc/X
	amhjwNT5e96QZMo1p/HqMU2UcxSIbAG71PfvMuRQGNsw4n1rVgx8Ph5R5oiG43zq
	o/3enMmfERlkQamW1PA9w74/jqLm/ufSNgzCBhY61PLE6eu8RrnjUww2sL1K6N7B
	VbXTYhfiZzdWb31j9+MwT72+6+0zVHFNPPDalvERMhGmlu3v9kjI2wZlah8HKeWT
	YNXTPSD7IPruwknMRcV153l23OwlB37u/ldqb1JksZctg8kI5gOHnpuk01ffVJC9
	arwkkvamTEbFvByeoNcxnsCHRigjNtonZ6h4G2g4ABkjyLeKoGXtkIm/mi7Jni2+
	QMJQaeERXaYwpw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4berhkf0dy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 20:12:34 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 608K2koE030392;
	Thu, 8 Jan 2026 20:12:34 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012059.outbound.protection.outlook.com [40.107.200.59])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4berhkf0ds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 20:12:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Za2EkdxbtmbJdj0BZiPTmH8QpIVxfhvmB5iVnM0AzqYDI/nDn8EmIop4sLMSWwSLIlQST0ThT/uI3GeRuXqnXOO1aNzHafCjO3DvMp75HoecJr/FoKIS3eysxnP8ksrzo6XcxNzr9/KWc+lDXIrSRkqC+8y4IB7IVvHn8ZSKg1+PAIWulHPJSfSMVlPmAs+CMzdXgcHILMeQa1KDcqHRWSOMapAZUBm+DtL2PTIPcVlyhSDnqBrlAICUxb6zvOVqe7fWAEzEuK50OZBuG5zTe3AhoMojqgxWN/+Zssa9/AiM5JNwaD0dtmSb9cGoW2wRCRDoD16skFMT3lzb3Lw0ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GcRmkf2647zwrhr38nNe50LW5N6ShmqLwe4v9s6iPWU=;
 b=Midwpo/UE7C10nBeF17UeJIgOrTWftkg0GT+R3JdkTlsmN2Pqn5RvShoL3EBS+KD/Jc5uhjqZQcuP0tLGIZtDlXWyrxFEO6P2Zf/BxTwJHmI1n662XwuCbvZpLGahAhXjGBKUUwGHd2WXLERViR0ZHKjwPYRp9KAQbfYQ5k8KXtUdHah6XEKo27aLVN+dJxQ+trP8t/Jlo9NhCTKOQIf+MJFPeT6kC5ykY9S6PTS65eeDsXhwBMZpYwOsD6u6+szFO3dYdLcmYMuubrPsWsKSQ5iH7gFOUNWwDRTAf2K6SZzN7jVhWq0mYYsRi5wqBcAtTSu0ZTanxfeW1IyEf0ICg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BY3PR15MB4834.namprd15.prod.outlook.com (2603:10b6:a03:3b5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 20:12:31 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9499.001; Thu, 8 Jan 2026
 20:12:31 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
        "cfsworks@gmail.com" <cfsworks@gmail.com>
CC: Milind Changire <mchangir@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH v2 5/6] ceph: Assert writeback loop invariants
Thread-Index: AQHcgBjqQXn2Qw5UT0msCtIdjFB94bVItgkA
Date: Thu, 8 Jan 2026 20:12:31 +0000
Message-ID: <88231472d7506484b011221128469787edb11577.camel@ibm.com>
References: <20260107210139.40554-1-CFSworks@gmail.com>
	 <20260107210139.40554-6-CFSworks@gmail.com>
In-Reply-To: <20260107210139.40554-6-CFSworks@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BY3PR15MB4834:EE_
x-ms-office365-filtering-correlation-id: d8f4c957-2d09-4dce-0e8a-08de4ef24118
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?QUxPZmoybnBTSWw2clVpVDdibGYySEovbFpxVitESldmdm9HSzNPZTVYMGgr?=
 =?utf-8?B?Y1NtKy8rRFZobjJjc05KS1lXTXVyNHllbWtZWS9EbUFQNjFPajhuTGdSVklE?=
 =?utf-8?B?bHRTT1JwWDF6OEZCZUJVT0p3L2FkcW5rckpGSkJTTUo4ZzBCaTd1dVFieFIx?=
 =?utf-8?B?K3FhV3RrU1BTemhIVEU2WC8xaE9SMzU1cU1zenRhNDZCQTUzRzZsbkN5My8y?=
 =?utf-8?B?amlSOWtka01XZHg0aXZhb2NYYXVWZ2MzcXNUMytoTTY1cnhJMEltZjAvcU1h?=
 =?utf-8?B?K1JEZEJseloxOUNqME1qMzYyV1ozK0tvS1V4TFVlRXk0RzVTZ00zbnc5ajBl?=
 =?utf-8?B?YmVEYUQ3ZnlkWUhrVVo0WDRGNzNVYzdIaUJuYWFzcWpXL3dzV2RsQXV2TXd3?=
 =?utf-8?B?eFZoVFhDd25rY01zTWZoUnRWYm9TbmZoYVorU1h0eTBBVm9jRW5pQkFsVE9o?=
 =?utf-8?B?czhXL2tucWhXVVpxMDc2Q28vZlB6SWNjaWdqcE5BUE8rTGxqSTU3bTFZQnRm?=
 =?utf-8?B?Tmw1K3ZxSFdiTWo2a0UxOTh3RXk4YW5YZm5qRHhHaFIrMksvd21ML3RZK3cz?=
 =?utf-8?B?c1R2MitIZmZibEpNRWxXK3R1eHMrZFZSRy8vUTdCNmlXUGc3aXN2eXBzSTlx?=
 =?utf-8?B?czgxZVhiWUJGc3cyRGt5OHpBZHliQXZqM05XcEZzQ1hVNi9sbm5EbE9aUEZ6?=
 =?utf-8?B?Nnk1NCtwTDB3bER1ek5wVE5qZ3Y0ZW9iWCtwc1dTbDVoQko1MjVyQmRlSzFJ?=
 =?utf-8?B?aXkyOThJMUJKcUlnRWx5QmxJNHhLVmFsWUJ2RVdESUhheDhXTEpqQnBYSlR3?=
 =?utf-8?B?RzY5ZEw1RHJQMTRxVTBuMXE2U1NzOGNFdTQ0c3pJTmVKbFVna2dBSTAyc3cv?=
 =?utf-8?B?Z0xVOE51Z28rd0ZscncyVzduQkFseEF0dFRDOVZ2aUNXWGxYVURHM1FCSFF2?=
 =?utf-8?B?MC9zY05iYjNIU3NNaFVKZmtiSXRXWUxOc21SWjVWdjRvdE9KeXgzdzQ3dGFa?=
 =?utf-8?B?amdBSkV6dmtuWGUyK1duZzJIY0t4YzhsK1ViQ2RocUZ1RDBUWC8vZlEyc2x4?=
 =?utf-8?B?bzFRQUtXbUdjMEtpd21jTzBXMy91RmpLQTRyeUwyYmswTE1keGdTL0hWM2E2?=
 =?utf-8?B?YlpHQXU3bjdjWHRxYUZySTF2a1F1R01TRmtDSWNTWVB5K0JKL2Q2ajZvTEl2?=
 =?utf-8?B?d01OUkpOdzFuMmZRdHA3K3BSaURnNlVLd0sybllUczNEUTNHMlFrSUZvTWNK?=
 =?utf-8?B?ZWpzcjBRWkhVeWh4Y3BuaVZ2M2t2MXB1WGo2NTd4QmZhVGs1VEVobEErdDY5?=
 =?utf-8?B?WGl6TEMxT1Zzazk2L0RUTTh4WU9yNmpSWlJMT1Z4Zi9VVnVaK2ZLKzNGWTMw?=
 =?utf-8?B?c1VZQjFPZDhxMktKQW5qSHFoYUNKU0lCV1M3Z1Q2ZHhyWDRRN1JuRmFNcnh0?=
 =?utf-8?B?NnhCbEsyZDltalQrYnl6NEliMGUzdnIrZm01bDg4MVdGY2tid2ZBeWVSVjhp?=
 =?utf-8?B?TWtsbE5KNjBmK0xtaTFMWk9qcHVGUGVRS1BDZFdET1ZROUdic0ZQcEdSUmN3?=
 =?utf-8?B?a3RJV1BwYmNDUzJxeHpPc3NJQlZsYWNITzJVMEJGKzY1eHdHR2pBU1Vkdm1R?=
 =?utf-8?B?Sm11eTA0NEpENnFZMkNWUmI0eE9VbFFvMUlNOTFoWEVMeGV6L1o3M0NXQ2Rt?=
 =?utf-8?B?dzI5dTRINTVLZXJwN3B1REhNVTJLMzVxRkx0WmRHcXYxeHhDb0lqYVdEWGps?=
 =?utf-8?B?Z2hqR29IS0VZMTgyNHIvcUhFci9WREliWElONWJqMHRkSEdYemFaWnMxd0hv?=
 =?utf-8?B?amN4Slg5d01NNUNGSVFzY3d3ZWdSY1dPTGtma1lNN2Q2dVRoSHVxU2RtVGRp?=
 =?utf-8?B?amlnUEJZS2FCTXA3alN2Y2Y4S2F5S3dZcW5McCt6OWZHNHhieTI1RUtYS3dh?=
 =?utf-8?B?UmozSHphNmdTWEN4QXVHRmszL1k0WW5iY1locFBtVmhOdUtiUHJEMzE1bFQ0?=
 =?utf-8?B?MzJnMDJaUjVybzVIZnhwbXJydWF5RXRBdU94aDY0Snd1SmFxc2F4dkZyV3ZV?=
 =?utf-8?Q?8FeuNx?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aHNrMklJZWpmSmVXNGNzcE0zY3dJVnJrSklLT3U4dUV2SlNZczk1MTZaRGlW?=
 =?utf-8?B?WC8wZGJHV2dDeHdtTXhmMlZlUFNBaTdweHVZOUNNcGpRZ0tYR1B3V1FEQ3By?=
 =?utf-8?B?K2dIRUYvdUIwd09rMk1wV2tWU2hLbWRMMzloRUwrWDNjUW8xNGZrQmJGRG4w?=
 =?utf-8?B?Z09SbXJ3Zm1hcVcwWVVndGNQU01la3BGSk83blpzcTVSR29nZUFtT3labVBy?=
 =?utf-8?B?d1EwSFV3NmV6MEptUEM2QWlsWkFOdDhPRWNJeUNoaC9jVkZFZWhML2J4ZnFu?=
 =?utf-8?B?OHcrVVROWHN2RWdjRzBDYUY0QjlJaEppRTZodGYwd1BkcGVsUmo0QkhwY2Z0?=
 =?utf-8?B?Q0MyeW5ucXhSaVVDOUpIWHdteDIzcWsvaFpQL09wVG9laGFDK3pZOE5YVXlP?=
 =?utf-8?B?WElnMW0rT0ErWFNscGUwWkduNWsvN0ZtUUN3a3BiR01DVEFmRWJGSFpxbWZn?=
 =?utf-8?B?Qm11RS9JV2JyTHhlTzQxQStWZTNjNTJ0WGI5cVVoUUZkTVQveThpWWhYczRT?=
 =?utf-8?B?c2wvcFJhc3JHbjVhYWpvRVVCM2t1QkNpbkV4dDVHZmZUVXU5NWVITHVzd01I?=
 =?utf-8?B?S29yY0dpU0R6MzN3S3JobXk3SG5CQXpCNlBhbys3MzlZWTZjTnRyWHVWTjJU?=
 =?utf-8?B?SGFnZ1RoeUIvV0JYTmJwUlg1Z3RsOW5vOExvVG9HNWNlMUd4MFYwaHRMV3hw?=
 =?utf-8?B?RVBzWVhBQ0h5VE05S3RCUWRIZEpCWUp2V2NoZ1NGRUtKYnRHUktzTjNFMzBv?=
 =?utf-8?B?aUFFaXc5T1NaUTZWS3JTUjBWdjNTYjVQamFSR1JMeE1LNGtBUHV3K3FtTmk3?=
 =?utf-8?B?cTNIQzdJZnBxQzVyb3lUTGNNVFR6bG85VGlUNzZyUDJobzhzNEk2MWRRb09M?=
 =?utf-8?B?ckZBWUtKdm5JSlZSSTVrWmp5ZWoyYmZuQnBCZFo5bXpkcWNmZDNYMkJhZlVO?=
 =?utf-8?B?bHNOcTJuVDFkekQ3Wmw2b09nNnpSMjd4MXcwR25oVFdPUU4vcytnK09nUm1x?=
 =?utf-8?B?U2pWODBKeTYra3NTY1dkVVpjYW5HdEE5NGk4ckFCVlpCYjBYSThmYUtRbDlB?=
 =?utf-8?B?SFFGckdTb0xNc2NMWWtraHM5clAyUW1KY1Yzc2Q1dUlvNWJHaHZSRUZZbXFW?=
 =?utf-8?B?S1dYeDVjQ1dWMjJDMzR0ajRIcngvQ2tYa21abjcvd1NYajdhMWNzUGxjMFNN?=
 =?utf-8?B?NmMyTkdTaEZBTFJWNHd1Y053dkYzVlRia0VyMVl6alI0Z1A0K3JOZzVKaURY?=
 =?utf-8?B?Mk1LeEU3ZXhKalJra0xJZGg1OXMvZDVQcmdFWldDa1RVd3ZQTEI5UWpWZ09G?=
 =?utf-8?B?dFdzbm5SS3h4TFZ4a2xSdHlmOWRQUytlOURsTTh5WDFuN2lWeUl3ZWVySi9T?=
 =?utf-8?B?dUtJVjhFSlhIUGdpbW9sMVVZOXhUZVJnTU5qcmhmdGZmejJJQjFLenpVRWVu?=
 =?utf-8?B?R3JHN3ZCR3hlUUEzRFZTVWFSY3BBUVpSbE9KbHlJcURNVEIrQ0d1WjFrOXJX?=
 =?utf-8?B?NEFEZkpONzltei81bDU4Z2tTUGZzWkhpajFlR3hibkh1d1RmZ0lyQ3ZEc29k?=
 =?utf-8?B?Y1BqTjdTdEJRWkZUWkJKaHNrMityU2NzZmFTNjdzQit1QkZra0Roc0x0TkNy?=
 =?utf-8?B?UC9rODNhYWZoMVBJcU1zdThLa2MvYzI3ZjhrdlFrZE9lWlBxNGpTOStOWEYy?=
 =?utf-8?B?RlBJbFRsbmdtZWdVTDAycVd4L3dSM3FuZWpuMGV3UXdla2NhMU1RRjluYzJ4?=
 =?utf-8?B?V2VnN2hDdmJ3YVY0NWdiYXdwYWJQTEdVUmIrUVFoSk14QVRtUk1DTDV0SjRl?=
 =?utf-8?B?OHRrUTlpdHlZRnY0RlVKdUxVRGRnWGh3d0doaXVsSHc4SlJGMXN1SUl0eTgx?=
 =?utf-8?B?S3RDRUF6WHRpazVjc3V0Q0s4L2Y3WWRxQUhmeThFOGtsa3plWmlzdzU3QnBr?=
 =?utf-8?B?Rmp0RlNpVmk5UkUwaWhENXkyUWcvZ0VXZEw4ZGJwTGJuUWFCVXREbXQ5R3RC?=
 =?utf-8?B?S2JETGFhTFFHTXNvaXA1SHBlbjB2T1g3R2xlOUpOSG1pWFhNN3crSER5Mmhy?=
 =?utf-8?B?cjdRZk9seFNNLytOVXBVS3JQNDMwTHQ1RTZsVCtKQllJSWdIS2dmSXRCRWpW?=
 =?utf-8?B?V2cxT0Q0Y1QzMkhuZ1hyd2VST3JCcSt4dkNRdFQ1MWg5M05hcDlmcy9uZ09K?=
 =?utf-8?B?RXY5cmVnS0kwZVZ4eTRqdVdvbUQ4K3pQUy8xSStnUWRFb3U1Qkd1dkxoTVlY?=
 =?utf-8?B?US90eUZQR0IweHp4QzFDUC9aUGhCN0lCS21USzE3empCR1k2Ry8xVEZTSXpM?=
 =?utf-8?B?TzZVbFFxa0F4eHdQRjRTN2R5OVprTnp1UEdCM1FHYlp2bnptcENJUFh1ZGFC?=
 =?utf-8?Q?JY964ngMX64AAiqwVbtvocZgmO77DuzAmLWkM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB81D12090BBCC46ACE07A85B8045DF8@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d8f4c957-2d09-4dce-0e8a-08de4ef24118
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 20:12:31.4315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Es0b7ayH6C5VzB/iNqhwD0ZjCDR9JYPIgxM0HnawifWye1L0OrUC/75kWQ5dzvyE8ymreHhfh/uNTx3QN08x8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4834
X-Authority-Analysis: v=2.4 cv=P4s3RyAu c=1 sm=1 tr=0 ts=69600fb2 cx=c_pps
 a=+/t0CT+QaJpOasvqRK9qOg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8
 a=DKoRq0qRxQFqUkqCu-IA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: dyczCW49kukfoh11mT1a1JqJDEcEXxmk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDE0OCBTYWx0ZWRfXzw6SUqtW1ASn
 7zqPxlGT+BBH+FrwmFRjJ6+NYa0InTFMGivHZkrY4l1uIehVlisRuAznxS7w+86yim2yhiV009A
 QmVWgFJC7s07dH///GyGpAjIhYotsz1/8U0rBZuoNEYXqIuIds1Z42B/1Wkn61k41KsVjLR32DH
 5X4cnms9CiLsHsmD5pryFzroX1Fd45kVdG+HyKzW92+MH+VNR0zYK8gK/lmsrDBh5HQEzHUl7+c
 c/5u9Di7Dhq2c6Azfxqw0vVsFMFPJjnZMoq1vAiJ3re4MsWTcE/u8OFnW3Ul19Tbx1W+4ezaWDY
 hTwGga2KlgXH0v/qNkbus/evNBWD384qVzM83ll37bOqi3jHuQWIjaBQXoFoA+rINQyZs6I+p5q
 nggGrQiHOApwqalcqxJ5je8PUq833cjRgRq3E4345yDU9sdEy8noGXOu6zLbEVi0VxSxCEV4/7A
 j3k34ItoBKSqBzdWSQg==
X-Proofpoint-GUID: w2nwoLIAgLBCmk5TQe13wiNPPVbvSmb-
Subject: Re:  [PATCH v2 5/6] ceph: Assert writeback loop invariants
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_04,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601080148

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDEzOjAxIC0wODAwLCBTYW0gRWR3YXJkcyB3cm90ZToNCj4g
SWYgYGxvY2tlZF9wYWdlc2AgaXMgemVybywgdGhlIHBhZ2UgYXJyYXkgbXVzdCBub3QgYmUgYWxs
b2NhdGVkOg0KPiBjZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2goKSB1c2VzIGBsb2NrZWRfcGFnZXNg
IHRvIGRlY2lkZSB3aGVuIHRvDQo+IGFsbG9jYXRlIGBwYWdlc2AsIGFuZCByZWR1bmRhbnQgYWxs
b2NhdGlvbnMgdHJpZ2dlcg0KPiBjZXBoX2FsbG9jYXRlX3BhZ2VfYXJyYXkoKSdzIEJVR19PTigp
LCByZXN1bHRpbmcgaW4gYSB3b3JrZXIgb29wcyAoYW5kDQo+IHdyaXRlYmFjayBzdGFsbCkgb3Ig
ZXZlbiBhIGtlcm5lbCBwYW5pYy4gQ29uc2VxdWVudGx5LCB0aGUgbWFpbiBsb29wIGluDQo+IGNl
cGhfd3JpdGVwYWdlc19zdGFydCgpIGFzc3VtZXMgdGhhdCB0aGUgbGlmZXRpbWUgb2YgYHBhZ2Vz
YCBpcyBjb25maW5lZA0KPiB0byBhIHNpbmdsZSBpdGVyYXRpb24uDQo+IA0KPiBUaGlzIGV4cGVj
dGF0aW9uIGlzIGN1cnJlbnRseSBub3QgY2xlYXIgZW5vdWdoLCBhcyBldmlkZW5jZWQgYnkgdHdv
DQo+IHJlY2VudCBwYXRjaGVzIHdoaWNoIGZpeCBvb3BzZXMgY2F1c2VkIGJ5IGBwYWdlc2AgcGVy
c2lzdGluZyBpbnRvDQo+IHRoZSBuZXh0IGxvb3AgaXRlcmF0aW9uOg0KPiAtICJjZXBoOiBEbyBu
b3QgcHJvcGFnYXRlIHBhZ2UgYXJyYXkgZW1wbGFjZW1lbnQgZXJyb3JzIGFzIGJhdGNoIGVycm9y
cyINCj4gLSAiY2VwaDogRnJlZSBwYWdlIGFycmF5IHdoZW4gY2VwaF9zdWJtaXRfd3JpdGUgZmFp
bHMiDQo+IA0KPiBVc2UgYW4gZXhwbGljaXQgQlVHX09OKCkgYXQgdGhlIHRvcCBvZiB0aGUgbG9v
cCB0byBhc3NlcnQgdGhlIGxvb3Ancw0KPiBwcmVleGlzdGluZyBleHBlY3RhdGlvbiB0aGF0IGBw
YWdlc2AgaXMgY2xlYW5lZCB1cCBieSB0aGUgcHJldmlvdXMNCj4gaXRlcmF0aW9uLiBCZWNhdXNl
IHRoaXMgaXMgY2xvc2VseSB0aWVkIHRvIGBsb2NrZWRfcGFnZXNgLCBhbHNvIG1ha2UgaXQNCj4g
dGhlIHByZXZpb3VzIGl0ZXJhdGlvbidzIHJlc3BvbnNpYmlsaXR5IHRvIGd1YXJhbnRlZSBpdHMg
cmVzZXQsIGFuZA0KPiB2ZXJpZnkgd2l0aCBhIHNlY29uZCBuZXcgQlVHX09OKCkgaW5zdGVhZCBv
ZiBoYW5kbGluZyAoYW5kIG1hc2tpbmcpDQo+IGZhaWx1cmVzIHRvIGRvIHNvLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogU2FtIEVkd2FyZHMgPENGU3dvcmtzQGdtYWlsLmNvbT4NCj4gLS0tDQo+ICBm
cy9jZXBoL2FkZHIuYyB8IDQgKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL2NlcGgvYWRkci5jIGIvZnMv
Y2VwaC9hZGRyLmMNCj4gaW5kZXggM2JlY2IxM2EwOWZlLi5mMmRiMDViNTFhM2IgMTAwNjQ0DQo+
IC0tLSBhL2ZzL2NlcGgvYWRkci5jDQo+ICsrKyBiL2ZzL2NlcGgvYWRkci5jDQo+IEBAIC0xNjc5
LDcgKzE2NzksOSBAQCBzdGF0aWMgaW50IGNlcGhfd3JpdGVwYWdlc19zdGFydChzdHJ1Y3QgYWRk
cmVzc19zcGFjZSAqbWFwcGluZywNCj4gIAkJdGFnX3BhZ2VzX2Zvcl93cml0ZWJhY2sobWFwcGlu
ZywgY2VwaF93YmMuaW5kZXgsIGNlcGhfd2JjLmVuZCk7DQo+ICANCj4gIAl3aGlsZSAoIWhhc193
cml0ZWJhY2tfZG9uZSgmY2VwaF93YmMpKSB7DQo+IC0JCWNlcGhfd2JjLmxvY2tlZF9wYWdlcyA9
IDA7DQo+ICsJCUJVR19PTihjZXBoX3diYy5sb2NrZWRfcGFnZXMpOw0KPiArCQlCVUdfT04oY2Vw
aF93YmMucGFnZXMpOw0KPiArDQo+ICAJCWNlcGhfd2JjLm1heF9wYWdlcyA9IGNlcGhfd2JjLndz
aXplID4+IFBBR0VfU0hJRlQ7DQo+ICANCj4gIGdldF9tb3JlX3BhZ2VzOg0KDQpJIGRvbid0IGFn
cmVlIHdpdGggdXNpbmcgQlVHX09OKCkgaGVyZS4NCg0KVGhhbmtzLA0KU2xhdmEuDQo=

