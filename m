Return-Path: <ceph-devel+bounces-3400-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78779B214F9
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 20:54:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C4613AF8AB
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 18:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC68C2D4819;
	Mon, 11 Aug 2025 18:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PBzHjDNS"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DB92E2841;
	Mon, 11 Aug 2025 18:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754938368; cv=fail; b=i5p1KksGoRbwa01tSYNEEH64M5vesJUuZb8SPJBBu4iryJCM1Y4paHQhtMurNL+/7c5PLaRW7E+LoZ4b3omDvQsGlCwEULG5l1DgBZ8UF011F+4c74CiVGINDDi+qVHU0NrxZMgNY/hAL6slmQ/TlgoV3BFOe3hZ9bT3bank3BY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754938368; c=relaxed/simple;
	bh=weuvgpRtq4rQ1Lndmjq+jQq6umgWavoJ6qo5DrUjlJw=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=H1owoOHFbunseRb/OJ9raA/5G9PX/A7KUJHmuK20+jDcTZNc0IKx4dzuBH8e4SNB7qbMhiC4mNXrNxG9kYXpI/VQKc7S1L3gmUR1DX16c93Bdrfmnz2nuIIcZCskv6Kf7wtMA8KWqS/2C5s/tYpisnruHHMvVpA+PLAen7uJvGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PBzHjDNS; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BChwPd002268;
	Mon, 11 Aug 2025 18:52:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=weuvgpRtq4rQ1Lndmjq+jQq6umgWavoJ6qo5DrUjlJw=; b=PBzHjDNS
	SNUQSt4D+2SNhztlqRVJsamJkV6UBa+fkLyCgft8HMUf+UFTspDTaLz7he6i7pSl
	nkBj3bgGTYx2JEgaHjU4a5iOprsm/TQH228YuXtfSH5XhFbMiiGEFvUHlQvieB9J
	E2Ld7BHbf2ZQDjTcouF3guJL0wnjdQJ8rxBTAX2Sisv8ShwEQGjMTNghGjPvN/wa
	96rxCPWheuAqcf1gAUZ4qFMjDGh1fE930A41TZSgewmkOepC6KnuzKDuIg+0cBmk
	h6CNVQ/fm6WXXl0TBiUdAtW0pcBcPGOYtQJhSVXsEourgPEXtqn4eZ4sZRFyydo4
	+x27hhF8TtJr8Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx2ctuwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 18:52:44 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57BIqhdc030655;
	Mon, 11 Aug 2025 18:52:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx2ctuwd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 18:52:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pKSH+NAOwh0m/udL1LtsN9vfxBUxOBPRAbKEbdDiznLpfLOMNIHXPoq/jFUDibVQpt2nFP91vKoIus5sjRql54s+JkuV5nxQF3FftbeUwPAi1vOEMgcKcnA9viFhDMHtnLkmgrvJaGYRIMw1vsfbBfF/zihlgWuSGPXSAuimZsTRGFRr0IlhVMdeXE4vPQT/0I98pB4x4NQ8qipjrtr5XfD7HYuoFmwsOlPLiSYthrMTnK5lN0y/Mw3nQ2aV8/PSWKu7y8bf3cgC7zIq8pIZH+/6RxqjPO2zEzP0XCc6CvbBDy20tgHIgYVzBb5JoKY+7RAeCQlwR4M1KrRSuLgHdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=weuvgpRtq4rQ1Lndmjq+jQq6umgWavoJ6qo5DrUjlJw=;
 b=hY91CHjsLDqtP6Bpjas9k2WtwUPy49z+LvScgwn4I9px6X/4EAyZjexovvaSwYMuBJgCkzUUXUWDkxhxS3LjO71DDSV6VHgLoBl0s/SjcYgmSJ14cDnTQ6u8RKTi7sjDNKT2mRNAq7zmu4FoS3MZDET5lUg5ra64r/dGxCqqXyGw1Oyba3W4zvN9G5I7fkL4uo1Fg/azGW25EScwIinaV3hvKxiN4jTlkhuENZYrmvTDlhqxGdeJpDLbLqXq6Nz/B2MGlz5+2BPgEYUegUlN6vjt5UH6FZR54ktibyqoo3hlyXy/kWDfusjgu6yq4uq0isaIstxL3aA0vFpx3u44hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DS7PR15MB5786.namprd15.prod.outlook.com (2603:10b6:8:e6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.21; Mon, 11 Aug 2025 18:52:41 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9009.017; Mon, 11 Aug 2025
 18:52:40 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH v3 2/2] ceph: fix client race condition where
 r_parent becomes stale before sending message
Thread-Index: AQHcCqgiheuA3OE9F0abMt1BvqNR3rRdzOkA
Date: Mon, 11 Aug 2025 18:52:40 +0000
Message-ID: <b08ad3eca04f90c055b48fa7255c1f3182ea8526.camel@ibm.com>
References: <20250811100953.3103970-1-amarkuze@redhat.com>
	 <20250811100953.3103970-3-amarkuze@redhat.com>
In-Reply-To: <20250811100953.3103970-3-amarkuze@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DS7PR15MB5786:EE_
x-ms-office365-filtering-correlation-id: 5d09bab7-4bd1-4d26-9567-08ddd9083fbe
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aHQrMFRSZXJuUWE3Z0Z4ZVF0d3RvUldoNEtqNnNCZ1k5UW9HbUJ4UnpYR09s?=
 =?utf-8?B?MmtQdWcvOFNNbk40bkJObnpQQVQvd3B2b2R3bFlkY1lydndnWG9CSVo4QktZ?=
 =?utf-8?B?ZlQrVVd0WUFMaVdPbThlZytIS05BQk96MGlyVDYwazd6bmVRVExDVGRKTHM5?=
 =?utf-8?B?Q3hSWTlQZys0a3pvb0dmZC9Qb0htVHVaa25VaHZQTE13Z2VmdUZFOU5mRS95?=
 =?utf-8?B?MXlBYjVHTUFOL0l5SmhCT1lwdEdhMk9zM3IzVk5pemRxb3AvV3RxZHcvUjhk?=
 =?utf-8?B?K1I5RDFva2FzMHlUT2o2STJRenNvN292Qk55UTlqU1BIMGwzZVNVMERjK2Z4?=
 =?utf-8?B?U1JoYVYreWFoZHdLQmcyeTNaRW9yMC9kYlNDYVN0Tm53cGtjOHpralJpMWQ2?=
 =?utf-8?B?Y09EZlhicmpmV1Z6SUgrcEZpZFFscmx4OVIvQ2t3Y2g1TmhhY0l4MFFQWTZv?=
 =?utf-8?B?ZWNIcThjZXFBeHpOWmtFQ2RvWVRkdUU2WnhNN2RKR2lYYTVYNzBtTDZTaENB?=
 =?utf-8?B?czkxb0pib0trM1A3OXlhWWRrQ2g2dnJTejVad0FzdzBRalRjZEdCSHo5RHNS?=
 =?utf-8?B?b3loVnY0NkphWFV3Q1BweDhXK2xwb0FhZmFzenM0YnQrY3JNbDVOYmMyOHpi?=
 =?utf-8?B?Rk9RU25NT3FKaGJ4YXNmbFFlMkcrVnJVSGRqYVE3NzlycFlGbDJORzJFY2tZ?=
 =?utf-8?B?WTROejZwTHVNbXMwaTU4UVJ2UnNpSm9ZS1lTM2x2Mk5XU1Q5NTU0a0w3NmxU?=
 =?utf-8?B?c1p4Q05neWZNcGFPK0J2d01YaGtkSW9hZGtzL0JVU3BDWmUwTjIyeEJLRTZp?=
 =?utf-8?B?RXhpM3E0TVdxTXVlQ1Z4TlRlWmhOWDFoOFY5djhScEkzcGhvZk02WWhGRENW?=
 =?utf-8?B?TUFDR005dGt4MDI1NkkwV3JQZk9zMkhYWTRyS2ZyUUdUbjFQNlEyOGd2UU9o?=
 =?utf-8?B?WGtGdGsxM0NtMzFGRnNoWi9NM0EzYWo5MUNOVzZ6MFBDdlhHWnNXL1RlZUdH?=
 =?utf-8?B?OGhiYThMMkh0UFJJZm9rV29lU2xzeEZtK1JqdkhCc0RraVpvZVR2V1pKenE2?=
 =?utf-8?B?aEprSEhzOG5tZE9mZ1BUVGdMYit4bnVGOWZiRTRaZjJwOGNwdld0UlJITEVj?=
 =?utf-8?B?VDNOaTFxUkpBbVE0QzZScFhkWWw0MnN0LytrQ3hBT29pQ2lPZ0Mvelo2ZVl6?=
 =?utf-8?B?QTNrWDRsbkhlTU1iazRFTzQ3SGFVZTF2bXRSNnJyS1FNMncyeWpveU55Wjh3?=
 =?utf-8?B?MElueW9TbEVyWFI4YWEwdlVMSitYSjFqcUhTNVhSVnZuZnRRTUxBVGJIVlRw?=
 =?utf-8?B?b004dzNjcnpZSEd2SXFnbUlSQ2dFbzVTTjhLRzY0elNvS3lwa29BMWp4K3BD?=
 =?utf-8?B?VHEyMGIvZklIalByODU2TEhxamNGUUJzdFhXOXBTa2ZlUXRvbzNjS3J6WVg2?=
 =?utf-8?B?bWdTZFpUakgxSWc1NnFJRlRzR2t1eVc4WW96cGFSSHlVRHJFNlhzQ044ek4r?=
 =?utf-8?B?Z1hQdDRGMWcrcm9YVTBtLzZ6NEFTdG5CZWpIbEgwdlpFUi85bEQwVTB0MEhQ?=
 =?utf-8?B?bGVpQXZwbU5Ud3NxU0xrbGcyV0NoOXlRaFdoRk5kamJpVjc1bHNMY1BtbmFJ?=
 =?utf-8?B?Y1kxSnpyZkptL3pMNjBOM0lqTHMxNVc5OGRNb3BYdnhYaGNoLzlkVjYzbXpT?=
 =?utf-8?B?b2w5Y2VHaDgvSG5YeHZnMThaZllTMThiZjV1aXUzMEpQV1FNeTFDK213enYx?=
 =?utf-8?B?UEVBVG5WQm5NVjB3RlV3N3c2em5TVDhRdEFpSlkzRnVQZmh3ZUIvS1kyamcv?=
 =?utf-8?B?TXREbWR5Y0EzOGxyZTNBUnl1a28ydkRENE1mRkVGRHowaGsvWkQ2V1V4ZWZC?=
 =?utf-8?B?RWFoeUZCelNsdVVjS0t1dC84MlNsdnd4cUpwQ0U1YVltTDFlNi9rQ0RJUEwv?=
 =?utf-8?B?MTNUWEllQ1dRMUtxYXpScVBFWW5YTWZuNXlGQ3RiUmR4SzRTNnNLazlWY2k1?=
 =?utf-8?B?WjNlTHJrM0d3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dk4xN3lBbnFHWjZaYVdxeCtaOVY4Wmt2OGs3dENZNnVnTldxNUM5ZE9OcUxl?=
 =?utf-8?B?MEpvc0hHRTY5ekZCV0xGK29vMjhQczRYeFplSnNyOXd1WmdHTTVVL01FSnJR?=
 =?utf-8?B?MytQSVhrNEZabHRZcXBjYldxdkM4KzQxSGN4Rlk3RE8vZEptNHFEQXlhd0ly?=
 =?utf-8?B?cURHeWxrOEpOeFdHOWFmYlBLcTlEWk51empXVStlcCtzSDBndDk2TXFSQllo?=
 =?utf-8?B?UjlNS0tmNmpjaThkUWlyMURsQzZvdTJEQ3JoOENlanFHQ0UzMDRHV09EVE94?=
 =?utf-8?B?Z3hSZjRXeUNvUVNPa09Cd2JFcUJpVE54cTdUUHRqQUhNWXF4aG5XZmxSUWFw?=
 =?utf-8?B?bTNwbWk4c2xGejVveFVMYStoa2h4QXFhN2NqV2NvN0V6emt3UEFQMy9aNWtk?=
 =?utf-8?B?UnJRaXZEWDN4V29IOTVEZ2prOVBJMzhPSkNrS013OFIwSVlPSVpLeEF3b2ha?=
 =?utf-8?B?aENaQnNiRFNjWWtXREJJKytOSGVVbTZ3WW80ODhCRHF1cW1OL0dYUW1jMzQ1?=
 =?utf-8?B?Sy9zeG9TOXk4c0JIM1RaWWJRdkl2Sm9CQXU2NXRHbUw0c1IyYXpWTGdJb2xM?=
 =?utf-8?B?OTc3WTFmd3ZIMmRaVVMySTdndjBPVCt1UDVOM3BTbFRXTHE0T2gwWlFaZUpv?=
 =?utf-8?B?UHIzRXd3L0lQclBEdjhFaGF6V0RUVmpBSDZ0bVRLTU9PbnNsRzBTNU9qM2x3?=
 =?utf-8?B?QTk4d205NThDYU9HVWFwdklqUlJGd0M2dTBVUHpKbHpKRWwyRW1kRFhWTFJk?=
 =?utf-8?B?bEl3bUdmSmpGVzBGanVTTlAvczFSenNvY3NqRnd1NEZCMTJScDlEb09hUCtn?=
 =?utf-8?B?RG51RkZ6Q3REWkhNQXNDeHU1RCtxWG1pYU1KaDNKVVpIM3c2R1pvTWhtcnhR?=
 =?utf-8?B?cUQxamNxNGNudTBYODhCRW5LZVAwMm13amNnT1FmMFZTbFI0WGNkSW1ZYjdw?=
 =?utf-8?B?bmE1aENPeGtNWUlFSi9kSXFtWHEwUlBrS1lrWjlnSmRMaDg3anRyTG03dVJ5?=
 =?utf-8?B?RGNpa3d4Z2ZaYUdiUEwxS2lFa21kS09GWmFaWmJUVjJTcndlSlAwK3F3TlNF?=
 =?utf-8?B?WnNUVzJ4U0JRcnhEU0NOOFdOZENXQ1A5Q1hoN2dMQ1RmK2hWaVhhNTZZUDhs?=
 =?utf-8?B?M1k2UEkyTGV2UWdsc1V3d3FpTUNTUWZHWkkxMlpIYzUzN3hkbzdOL2dXSHVO?=
 =?utf-8?B?c2RIeFU1VFZzbGZWUG1vM2s0dWRlMVBNaGYybndmVlUvTXhQdk52emNEaFdF?=
 =?utf-8?B?azdoSjVZdXJnNER1azhiZ1Fxa1lIRDJxcTV0T1lieDRhdjQxM2N4eDlDZmhQ?=
 =?utf-8?B?eE5ZSzdVSnBjUk9oQkNXSGVSK2tLdmh2TGxXQjh4aFlNOVpIc09GaitiMDhR?=
 =?utf-8?B?Z0czb21JbVJlcE5CeUk3bTI3WW42bDEzTHpnT3VvbUJtZGJ3U1F1SXpFK3Fo?=
 =?utf-8?B?VGdZNDlPcWdmUTNrcjk2QjE1cUkvWVp6czNBVnpsdDlxWDkwM2dmeVhZUlRE?=
 =?utf-8?B?ZTJQNUhVRXBsVDJoNjBMTDQreU9nNkpDVi93aDlteWVyME44RERzVEZFZnVu?=
 =?utf-8?B?dThRcVBJeHpmSjJKUDI4eUlhZkRmRm5kUmlBK0tjYnVYbzVoaTRrWlp1OVZr?=
 =?utf-8?B?ZTdDQ2I1VWFlSGVDZlZnSGZvVzhwS3B6a1h6QzVjTkhNQnFJT0ZuWVZ5WXc2?=
 =?utf-8?B?V3MxUkhESU5kRW1uU2VXbkR6T0oyL2wzcjJncUN1Zng4RWtaZmloYTliZUxj?=
 =?utf-8?B?Vm1ERG5XYnFremhHdlBYSitCa25xUFg0Y3c1L0tRcHBuaVRHZjltUVhKZys3?=
 =?utf-8?B?RFNpYnJQNjkxT2N2UTdZcTNTVFhWaWFENmVpT2lEZkVYUzJmKzRvU2xXem9G?=
 =?utf-8?B?VmxUaXRTaTZYL1k3UnBKRDBkS2l6ZlJOVEhkYWNHb3RERWZ5OVlTYUtQa3Y2?=
 =?utf-8?B?dTFDRDk2UVJvaHBaYnlDdkJtR3FpdnMweDRkNHY3QzcyOUxpMVhPOHdYOEFr?=
 =?utf-8?B?dy9EeUc2N1gzQUovS2o0K1lNdG42NDBmSmlLUjQxYUVSbmJVS3BxdWlqQlVu?=
 =?utf-8?B?QlYvOUVVb3NjTjNtcEttd21wRzVWV01MYWxRaGw2K29UZzlrcVlHT1N4Z0M4?=
 =?utf-8?B?bjF1OWhRTTQ2Rm82dVVRRDVTT1BnbFFkM2o0RERSUEhhRXlKNjBaUERDb2ta?=
 =?utf-8?Q?LYa+XlUGMHBPS6zZ1Pv+eA0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3EA36AC9FF1DA745B96FC1AD86200AA8@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d09bab7-4bd1-4d26-9567-08ddd9083fbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 18:52:40.8822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aR4xG0xFDKtrxx2+EnhkERRXkDGS1F09DzWnENAKscQqL4Jw64/hDLdPnIxCgByf2XZZS9A8me4e1TuY2vSTAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR15MB5786
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDEyNCBTYWx0ZWRfX6XCPVj/Pd4zK
 HsSOZJeZiIuPF6dlCvFyJPhpQOHCiGVH9jdbBCEV2klbWu50piPkMwW84rZs/WTr8WqGSOjb77P
 UG4pWX2rTFKZ1BDTDxVp/tp/KiUhTqeRsZT+yQwcLss8IEKL4he3NwFkCuWs5crFcxpaMyIv+Vd
 bp+SuXSScWgdCZ3pDeeasta15pUta2k2f1+GAfIfax26hymcdraZ6l6TDkb9or5Cg5vct2dsCrS
 /QIemQd38hQQzHz0pem0pMTvHqk9aVZ9D8akXsVF+fV2SzHvMJPMYDeTPkqhZcX5AQwgU6VGRBy
 gcUbXq5QIh59Y1ZDtOjbbNCZFtW53S1zKHoZTAV2grpKRdPLrtAkdCsb8qXx7y1jZKOREPy8Yrh
 po1/C0s5Hyqd50YRmPr+83PkrrsXRY+uPzROHYkAPKBLeP0IIk/aJydZkGo9ZrAmEeeAUhPr
X-Proofpoint-GUID: dmmyI9IerwJH4og7NW4PfTrK_GzDpI2B
X-Authority-Analysis: v=2.4 cv=C9zpyRP+ c=1 sm=1 tr=0 ts=689a3bfc cx=c_pps
 a=AGF89FsVm9+G2LWTQtfgrg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=IKZbrOtTXqJckMbK4qIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: uB3JpBWfk_kTXhnCJW1pHf3zeOJiH8Ed
Subject: Re:  [PATCH v3 2/2] ceph: fix client race condition where r_parent
 becomes stale before sending message
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_03,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 spamscore=0 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2507300000
 definitions=main-2508110124

T24gTW9uLCAyMDI1LTA4LTExIGF0IDEwOjA5ICswMDAwLCBBbGV4IE1hcmt1emUgd3JvdGU6DQo+
IFdoZW4gdGhlIHBhcmVudCBkaXJlY3RvcnkncyBpX3J3c2VtIGlzIG5vdCBsb2NrZWQsIHJlcS0+
cl9wYXJlbnQgbWF5IGJlY29tZQ0KPiBzdGFsZSBkdWUgdG8gY29uY3VycmVudCBvcGVyYXRpb25z
IChlLmcuIHJlbmFtZSkgYmV0d2VlbiBkZW50cnkgbG9va3VwIGFuZA0KPiBtZXNzYWdlIGNyZWF0
aW9uLiBWYWxpZGF0ZSB0aGF0IHJfcGFyZW50IG1hdGNoZXMgdGhlIGVuY29kZWQgcGFyZW50IGlu
b2RlDQo+IGFuZCB1cGRhdGUgdG8gdGhlIGNvcnJlY3QgaW5vZGUgaWYgYSBtaXNtYXRjaCBpcyBk
ZXRlY3RlZC4NCj4gLS0tDQo+ICBmcy9jZXBoL2lub2RlLmMgfCA1MiArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNTAg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQoNCldoZXJlIGlzIHRoZSBTaWduZWQt
b2ZmLWJ5Pw0KDQo+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2lub2RlLmMgYi9mcy9jZXBoL2lub2Rl
LmMNCj4gaW5kZXggNThkYTBmNjQxOWY3Li5jNmY3ZmQ5YTI1ZjMgMTAwNjQ0DQo+IC0tLSBhL2Zz
L2NlcGgvaW5vZGUuYw0KPiArKysgYi9mcy9jZXBoL2lub2RlLmMNCj4gQEAgLTU2LDYgKzU2LDUx
IEBAIHN0YXRpYyBpbnQgY2VwaF9zZXRfaW5vX2NiKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHZvaWQg
KmRhdGEpDQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+ICANCj4gKy8qDQo+ICsgKiBDaGVjayBpZiB0
aGUgcGFyZW50IGlub2RlIG1hdGNoZXMgdGhlIHZpbm8gZnJvbSBkaXJlY3RvcnkgcmVwbHkgaW5m
bw0KPiArICovDQo+ICtzdGF0aWMgaW5saW5lIGJvb2wgY2VwaF92aW5vX21hdGNoZXNfcGFyZW50
KHN0cnVjdCBpbm9kZSAqcGFyZW50LCBzdHJ1Y3QgY2VwaF92aW5vIHZpbm8pDQo+ICt7DQo+ICsJ
cmV0dXJuIGNlcGhfaW5vKHBhcmVudCkgPT0gdmluby5pbm8gJiYgY2VwaF9zbmFwKHBhcmVudCkg
PT0gdmluby5zbmFwOw0KPiArfQ0KPiArDQo+ICsvKg0KPiArICogVmFsaWRhdGUgdGhhdCB0aGUg
ZGlyZWN0b3J5IGlub2RlIHJlZmVyZW5jZWQgYnkgQHJlcS0+cl9wYXJlbnQgbWF0Y2hlcyB0aGUN
Cj4gKyAqIGlub2RlIG51bWJlciBhbmQgc25hcHNob3QgaWQgY29udGFpbmVkIGluIHRoZSByZXBs
eSdzIGRpcmVjdG9yeSByZWNvcmQuICBJZg0KPiArICogdGhleSBkbyBub3QgbWF0Y2gg4oCTIHdo
aWNoIGNhbiB0aGVvcmV0aWNhbGx5IGhhcHBlbiBpZiB0aGUgcGFyZW50IGRlbnRyeSB3YXMNCj4g
KyAqIG1vdmVkIGJldHdlZW4gdGhlIHRpbWUgdGhlIHJlcXVlc3Qgd2FzIGlzc3VlZCBhbmQgdGhl
IHJlcGx5IGFycml2ZWQg4oCTIGZhbGwNCj4gKyAqIGJhY2sgdG8gbG9va2luZyB1cCB0aGUgY29y
cmVjdCBpbm9kZSBpbiB0aGUgaW5vZGUgY2FjaGUuDQo+ICsgKg0KPiArICogQSByZWZlcmVuY2Ug
aXMgKmFsd2F5cyogcmV0dXJuZWQuICBDYWxsZXJzIHRoYXQgcmVjZWl2ZSBhIGRpZmZlcmVudCBp
bm9kZQ0KPiArICogdGhhbiB0aGUgb3JpZ2luYWwgQHBhcmVudCBhcmUgcmVzcG9uc2libGUgZm9y
IGRyb3BwaW5nIHRoZSBleHRyYSByZWZlcmVuY2UNCj4gKyAqIG9uY2UgdGhlIHJlcGx5IGhhcyBi
ZWVuIHByb2Nlc3NlZC4NCj4gKyAqLw0KPiArc3RhdGljIHN0cnVjdCBpbm9kZSAqY2VwaF9nZXRf
cmVwbHlfZGlyKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsDQo+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgaW5vZGUgKnBhcmVudCwNCj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBjZXBoX21kc19yZXBseV9pbmZvX3Bh
cnNlZCAqcmluZm8pDQo+ICt7DQo+ICsgICAgc3RydWN0IGNlcGhfdmlubyB2aW5vOw0KPiArDQo+
ICsgICAgaWYgKHVubGlrZWx5KCFyaW5mby0+ZGlyaS5pbikpDQo+ICsgICAgICAgIHJldHVybiBw
YXJlbnQ7IC8qIG5vdGhpbmcgdG8gY29tcGFyZSBhZ2FpbnN0ICovDQo+ICsNCj4gKyAgICAvKiBJ
ZiB3ZSBkaWRuJ3QgaGF2ZSBhIGNhY2hlZCBwYXJlbnQgaW5vZGUgdG8gYmVnaW4gd2l0aCwganVz
dCBiYWlsIG91dC4gKi8NCj4gKyAgICBpZiAoIXBhcmVudCkNCj4gKyAgICAgICAgcmV0dXJuIE5V
TEw7DQo+ICsNCj4gKyAgICB2aW5vLmlubyAgPSBsZTY0X3RvX2NwdShyaW5mby0+ZGlyaS5pbi0+
aW5vKTsNCj4gKyAgICB2aW5vLnNuYXAgPSBsZTY0X3RvX2NwdShyaW5mby0+ZGlyaS5pbi0+c25h
cGlkKTsNCj4gKw0KPiArICAgIGlmIChsaWtlbHkoY2VwaF92aW5vX21hdGNoZXNfcGFyZW50KHBh
cmVudCwgdmlubykpKQ0KPiArICAgICAgICByZXR1cm4gcGFyZW50OyAvKiBtYXRjaGVzIOKAkyB1
c2UgdGhlIG9yaWdpbmFsIHJlZmVyZW5jZSAqLw0KPiArDQo+ICsgICAgLyogTWlzbWF0Y2gg4oCT
IHRoaXMgc2hvdWxkIGJlIHJhcmUuICBFbWl0IGEgV0FSTiBhbmQgb2J0YWluIHRoZSBjb3JyZWN0
IGlub2RlLiAqLw0KPiArICAgIFdBUk4oMSwgImNlcGg6IHJlcGx5IGRpciBtaXNtYXRjaCAocGFy
ZW50IHZhbGlkICVsbHguJWxseCByZXBseSAlbGx4LiVsbHgpXG4iLA0KPiArICAgICAgICAgY2Vw
aF9pbm8ocGFyZW50KSwgY2VwaF9zbmFwKHBhcmVudCksIHZpbm8uaW5vLCB2aW5vLnNuYXApOw0K
PiArDQoNCkkgdGhvdWdodCB0aGF0IHlvdSB3YXMgYWdyZWVkIHRvIHJld29yayB0aGUgV0FSTiBv
biBzb21ldGhpbmcgZWxzZS4NCg0KVGhhbmtzLA0KU2xhdmEuDQoNCj4gKyAgICByZXR1cm4gY2Vw
aF9nZXRfaW5vZGUoc2IsIHZpbm8sIE5VTEwpOw0KPiArfQ0KPiArDQo+ICAvKioNCj4gICAqIGNl
cGhfbmV3X2lub2RlIC0gYWxsb2NhdGUgYSBuZXcgaW5vZGUgaW4gYWR2YW5jZSBvZiBhbiBleHBl
Y3RlZCBjcmVhdGUNCj4gICAqIEBkaXI6IHBhcmVudCBkaXJlY3RvcnkgZm9yIG5ldyBpbm9kZQ0K
PiBAQCAtMTU0OCw4ICsxNTkzLDExIEBAIGludCBjZXBoX2ZpbGxfdHJhY2Uoc3RydWN0IHN1cGVy
X2Jsb2NrICpzYiwgc3RydWN0IGNlcGhfbWRzX3JlcXVlc3QgKnJlcSkNCj4gIAl9DQo+ICANCj4g
IAlpZiAocmluZm8tPmhlYWQtPmlzX2RlbnRyeSkgew0KPiAtCQlzdHJ1Y3QgaW5vZGUgKmRpciA9
IHJlcS0+cl9wYXJlbnQ7DQo+IC0NCj4gKwkJLyoNCj4gKwkJICogcl9wYXJlbnQgbWF5IGJlIHN0
YWxlLCBpbiBjYXNlcyB3aGVuIFJfUEFSRU5UX0xPQ0tFRCBpcyBub3Qgc2V0LA0KPiArCQkgKiBz
byB3ZSBuZWVkIHRvIGdldCB0aGUgY29ycmVjdCBpbm9kZQ0KPiArCQkgKi8NCj4gKwkJc3RydWN0
IGlub2RlICpkaXIgPSBjZXBoX2dldF9yZXBseV9kaXIoc2IsIHJlcS0+cl9wYXJlbnQsIHJpbmZv
KTsNCj4gIAkJaWYgKGRpcikgew0KPiAgCQkJZXJyID0gY2VwaF9maWxsX2lub2RlKGRpciwgTlVM
TCwgJnJpbmZvLT5kaXJpLA0KPiAgCQkJCQkgICAgICByaW5mby0+ZGlyZnJhZywgc2Vzc2lvbiwg
LTEsDQo=

