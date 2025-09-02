Return-Path: <ceph-devel+bounces-3502-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49F35B40DF4
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Sep 2025 21:37:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B90301B63590
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Sep 2025 19:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2F902E5B05;
	Tue,  2 Sep 2025 19:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="euV8Gvw7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734E429BDBC;
	Tue,  2 Sep 2025 19:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756841854; cv=fail; b=i7CofSuvDyooUr6bYAfQFXMp0gAsVDgqmgJjULFJBj21f4FsMMRKGEj/OtAPMDU9I1eP6muRwnWRJ2kBPuO55vFJlvFqjQJQeXWR6eOC/SlhLqmY6qYMTXjiQ6tYUe3+PFV7b/lot3zfCzAxbcLpjGnKCA1VdFuOMU7w+TxXDFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756841854; c=relaxed/simple;
	bh=y7NMDtKJar3uYSmGxc5qeEmkgj9EKuxCrAANKX/nEXY=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=O/87e/NygBDyAskri6LaqEvtd1pFPY1c+Bu6oDChfoc/IddLC0FXEnyGHvky0ND7uZlDBLKkdVS9CRvYxWUUuwGs39zxoXTBvvkL334qgKKJF7vTmHksmohPTd2ZpWXGRNOo3iOsFOm6cgC8oHMXXNe2tAa35vY1byTq0sfHx9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=euV8Gvw7; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 582CgUJf023425;
	Tue, 2 Sep 2025 19:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=y7NMDtKJar3uYSmGxc5qeEmkgj9EKuxCrAANKX/nEXY=; b=euV8Gvw7
	6w2eisCLtnXGC9ZHtkJyUEXkkTFqk3wpzQyja2l6XJuC8kpvsxfm0dLnExGkYylu
	wAri0CLwSCEMLAkir1a1fj5aKC5mqrJSHALVHpDizod/widaWnCmPNlfJhEl0ukQ
	rV1xAStf5emW6BMLUw2ll/2/UNMFJEowAhKtHlEnJ/EGuJ8nUSqNS7UzPg40uQhT
	BB4uu1a4kQ+QOzgKOJnUGE6bPbu0cvoY32t3T5xbpePcpNbH4itS68BjJnKoxqQv
	uW1WO3HOYGT01D7tVYCUrhSDfeFzLFIRaAsr68uHrbADub2g/Jn70wctCNFtGb6v
	vykc9CH16Kafmg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usur0d8b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Sep 2025 19:37:27 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 582JbRXZ030708;
	Tue, 2 Sep 2025 19:37:27 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usur0d87-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Sep 2025 19:37:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FuPOctfuYFC0scGDHZDUH9M632SQjUHFDGhRRHBTBYHsngX0mDBare+9UZLuRl1y42B+DJmzODaGTzCIyxuHthJbj68solP9rog8RSr2b6vjbLAupRGueYO97kDQsVRA3cd9c5VPiba3t0taUftV5N8diKEbplc96BREkhV0ZoupEXEsAmE89MxkJhBGPglXH5T9pCpyeqT6z0cfYCVLMGI990SYB8hn6qT0N3GMpAhkDVgm7awqJ0bLIA5a01h7ac/9n7r1/vAPl7IrDElmmCsaAG8wULDTL4AWDBJg+s7BTo80Kb4OSLkAOnnehb16TPXpkOpRXmtYjhGl1UokJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7NMDtKJar3uYSmGxc5qeEmkgj9EKuxCrAANKX/nEXY=;
 b=Klo/qoprJwszbyVxlsETgRNpOqphYjTzUvWzRv4ZaQlJ3ctUlaEo6kdZ9wl4sZ2QmP7nGp3HP2eyJf2yEeKY1BnFHw3JfNqWG6iTunBfTKxiI4LCULSW3RzbJGBKAEiqBKg9XurjI1WLbwwLh4sgouERinYto+qQ15ExZFc7CEilW9Pco593VtC9JoP/DwuzCOlrZsq1S9EKQnaa5rLtBCf+95G6s+HQURdWpXnayq7tJN9obEImq8Gd/HMxw/NWH4myDlrdkr3uhLnNbNUgOOhEYG1IHBIkInSGvT6I5HmI5gOWlhD2Ub+w8KMJVipQ+Zj6z+bcb3i87jxrDEsCVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com (2603:10b6:a03:4e4::8)
 by SJ2PR15MB6402.namprd15.prod.outlook.com (2603:10b6:a03:573::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.29; Tue, 2 Sep
 2025 19:37:23 +0000
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::266c:f4fd:cac5:f611]) by SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::266c:f4fd:cac5:f611%4]) with mapi id 15.20.9052.027; Tue, 2 Sep 2025
 19:37:22 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "409411716@gms.tku.edu.tw" <409411716@gms.tku.edu.tw>,
        Xiubo Li
	<xiubli@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH] ceph: optimize ceph_base64_encode() with
 block processing
Thread-Index: AQHcGbIGM1YUyIHLzkSOvjRd/ZSWpLSATpuA
Date: Tue, 2 Sep 2025 19:37:22 +0000
Message-ID: <fce1adab2b450097edbcea3ec83420257997ec00.camel@ibm.com>
References: <20250830132822.7827-1-409411716@gms.tku.edu.tw>
In-Reply-To: <20250830132822.7827-1-409411716@gms.tku.edu.tw>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR15MB5821:EE_|SJ2PR15MB6402:EE_
x-ms-office365-filtering-correlation-id: c3aeae05-002a-4aa6-e97f-08ddea5822fe
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|38070700018|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?cmRmNkJvTVdvekhueUVHN2R3aXRHMmFlOXp3NmxKb0RndVVSL00vb3dGRWpu?=
 =?utf-8?B?Z01SVzR2V01YdEVlaE5DRjkwVGJZcFQ4ZEkvQnlpS1pZcVVCQ2pGeUNKdmRj?=
 =?utf-8?B?R0xoby96V2I3dEZXR2YvM3pMWmhwTGVJL1BrdEtWUW1VVDV3SVBJZHgrSFEz?=
 =?utf-8?B?aHdwSWhMaTBuQlZPT2ZNaVZBRTIvU0NMcWhCbmhiU1ArUWc5TGYwa3p3RUlt?=
 =?utf-8?B?N0R6VXRtR0NZRTQvL2pSTGlWWFZnMVRmMUJocDlqSmJVWmplZkdEbmtCVHUr?=
 =?utf-8?B?S1hEeHE1T0dzUS8xeVBRQUNjSXRIQ2Vhc2w4ZFdLTDhXMXVETmcrUzJLV01k?=
 =?utf-8?B?QnUrMU1Pa2RUMStQY2dNY0NVRXBEK0Z5WjVpYS9CTWFsanI2RXdmY2piY2Rk?=
 =?utf-8?B?SjBKaUx2MzdRVWpHZHFhSzBjQjQ2QnpGNTJGZGVPV3kwR3diWW5SZzFFalBm?=
 =?utf-8?B?Z2VYL3p3bUJmTnB0bmhLZXhIWnJZbU9ZOXFnbnJ1MFNOUDdlZnpuODhwUkVD?=
 =?utf-8?B?YU82QWUvWHFUNWxrYldyUmo3MDZHOFJCSE9NQVhkYU9TNWlEMnpNSUZzaGNi?=
 =?utf-8?B?dy9TVXFzR3dPR0MveU0yNnFUT0pwNDdBVC9MbC96YzhWaUdJMDNOcDF0U1pa?=
 =?utf-8?B?SWlaTkFpNFZsa3BZektRZFEwWmxPRFlMR3JSSnhmajNGMkM5NnJiaU14cTQr?=
 =?utf-8?B?dVpqdkRscncvRytTbzlrRUlUZUN3dk42MURBbTAwYW1kV2F5S1BoZlc3a2ZV?=
 =?utf-8?B?b1A0eVJnSEpZd3V6ZmVUbGpBck93ZURYYVFVeUMrb0xFNnJ4WlJPalNPc3Ir?=
 =?utf-8?B?VFFZUWlXRTVycnMwdWs1VWRSQlBvVk0zMHdDMXdmcjRpZ1BteVhlZE5oMUNM?=
 =?utf-8?B?WUM4S3F2bEQrbmxtNEZIbGtVYmp6SGtZbDBML3RsNTNscHg5UHg0Q2E0bEpx?=
 =?utf-8?B?cEQ3M2lsUmgwYVdKRWNQN3RhMUdwQmJkQVRZblV5MkJQMmdXYU4ycml2YllX?=
 =?utf-8?B?MkhweE56Q3NqT05YdWEvL0pNd2o3aEFEY0E0b0FHd1NQVnF2VGdXWEFpZG8y?=
 =?utf-8?B?ZlZUL01aRDh4d29kb2Jsc2FvNFJOS3pUNlRHY0NRUGZjNHFDTUZSZGlEVklO?=
 =?utf-8?B?WU9WaG1NVmVkK1NpSlNrUkNYVHB6eUhQN3VadzhMejVSN3RPcUR3RXQ3UUJt?=
 =?utf-8?B?OG1uc29TZnljandRT0RaSE96bmI5WnY5NzU1aEdMR3BMWkhVNDQrT0NBUzVN?=
 =?utf-8?B?d1hNd2VWUEs0aWQwRkJ3cmtGc2doOWU2YjROSzZRcTgrSkZSRkZJTUpabzdp?=
 =?utf-8?B?d0tTYXZuOUxWaW04TDdKWHJqem0zbGxhVXlsNlpTa3Y0VU1PZDZLWlhYcmxh?=
 =?utf-8?B?MW1ZUFM2OE9lZEExRlpObkw3TSs5cGJXOURPMHBxOE0yaFp5aEFpYTNTSWYx?=
 =?utf-8?B?ZlFUVlM3QWlNbmF6cXI3YnZaUzFSeXhPN2JVdmkvdGZpZDh0TW5kVFE4RDBU?=
 =?utf-8?B?ektQcWttSkdDeVFLMGJYT2p6V2o5MnZsU0ZxZkptaU1xaHo1WVpHOGFEMmk2?=
 =?utf-8?B?WkRPSVNIM1RGQXdQUExkQnh1U1pwbmJTNlloUVRZZzZZYlU4VVVtTWFJd25W?=
 =?utf-8?B?TWx1Uk1HMjR5NFFyK1VqSW84SmN3MTFrSEhPb2ZmbWVteDV5OEVDZDBIeUxl?=
 =?utf-8?B?YnZqTnBqcnVPSzlMd2hTc2tPSkhzSnUwZlBoK1hXZEplMUlHeW53SmhBYm5j?=
 =?utf-8?B?Z2VCbE4zcHBJM1dNeTBCM0YrSUhBaHpvYkFvR3lRSXMwQmVFQ014a0NyN3Vu?=
 =?utf-8?B?YmF2SjNYRWlmOFQwblcrU2JtVDVZTkJJcjMvSzlDYy8rR0Qxekl3eFJRTUs1?=
 =?utf-8?B?S1VsNkxJRVFPeWdLcE9ZQ0UyUUs4eURPcGpJWG91bVpyNVJhSk44RWoweEo0?=
 =?utf-8?B?aEorMW5WdUNiUThaUGRTWG1DbUFLcUlxWWs4dkJKc2RUTjhCamZpQXdGTDZp?=
 =?utf-8?B?VzRJTnlRMG13PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR15MB5821.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M1RzMDV1YklhRTJXbXBjU0ZrZTAwMVVwWC9WSFNQQzcxSXB6Qy81dGZhY1p5?=
 =?utf-8?B?aWhGR3BKOEFPdjNXNk9yRkNQSmRnWFNTSk5hNmFHNGxSSzM4eGM4cmVGR0xV?=
 =?utf-8?B?VDJCakU2NFNmdWVzNlRaajNCZmp2VDlJYnRtQVBaTlZUV1AxU3BNWlI1Q0pH?=
 =?utf-8?B?aVFubU5hUUV1ME9xc2JTZFRsYStpV1IzNkYzeEUyUzdlOTd5a05GUlhkbmIz?=
 =?utf-8?B?UU5GM0hCalZ6R0NsRE5JMnV2Wlp0S2VNZVh5SllaNXNsc2JJbXRKbXpBMm9o?=
 =?utf-8?B?b2FwT1B0NXhWTmNMM0pXOS9lanRwSVpCdGR3TStTSE5wRXlvK211bDMwVlh3?=
 =?utf-8?B?eUhOcTlOekhHWlJ4c2p1T3VMRElVMWFsR1hYWEZ2RFZlR0pSVll5TzRaQXpx?=
 =?utf-8?B?aWV0dFpwTlM4VnZOUDlENUJibXgzWUxKS3A4b2hFUDYyNVEwalA5aDFTTzAy?=
 =?utf-8?B?SW14N1M0bHN6UE1mZ0xTVWlveDE1enpHOUlCWTlCQ0FKdVdLYU1lT3gxOGkw?=
 =?utf-8?B?b3lwdUF1clRPMFpLbzYzMUNydXVxeTcyTDR1OHJTTlpiYWpVNGF5WlIwOW9Q?=
 =?utf-8?B?VG5SVzB1WjhKZ1EwTnN0d2RhR3RDa1BDaWUyTWFXOFJKQW9iUlZtOVJDWi9B?=
 =?utf-8?B?TDRVaVVpdm5pbjhlNnBPcXd3elNGbW5tMDhKVjJKRjJaNHZhRVJiY3FlWFVs?=
 =?utf-8?B?MkxzNkNMS1k3Z2ZCSmcrT1EyQUlRVWI5V2dxNXlkVys0Rzc4ZFBZbzlUck9Q?=
 =?utf-8?B?bFlRWGdMY2Yza3ZRY0R4TXNuN2owWW9kd1pqUi8wclBOanQ4cVNRaUNCUXA4?=
 =?utf-8?B?VDhRYnprc2ZwdlBycFE2QlJuMzNmd2dtYnB2OHpCcjRpUytMR0dBOFJhZUtC?=
 =?utf-8?B?RExPQmpsakpLUjkvdWdlWHU5RDZtMGlZeW1Fc2hmdHRhZjNYNmR5UFE3Sy9K?=
 =?utf-8?B?L2pYVTdzcnhyRmEzY25ieS8zY3dUUHJCSXpCZTJGdGl4SXRhYnRzYkliK2Zs?=
 =?utf-8?B?bmNaclpSYThRLyt5QlpWZzVDeHVXUlFhT21mWVRlNnBYakc2MXdSeUI2amo2?=
 =?utf-8?B?SGZMWWdvK3Z1SzlzNXVmcG01SnZDRWIyMDdpY0R2VDhFYnh0MkJGbnBNSE5H?=
 =?utf-8?B?K3ZSSFMycnhEOVZQb3ZCa1lrSnpmTG96Q0xyblVTcW1sTURSTjhBZDdPWnFB?=
 =?utf-8?B?aE53dlgvZkJHdm4yUWppQ0VqamptWkl2d2g2ZXh3T0xZU0x2c3ljVVhFcnU1?=
 =?utf-8?B?WmJydkVITEZ5QmdIMkNRcFJYVHM1YnFHeWI3MVR2T1M2bGNzbTRjdGl4QVh5?=
 =?utf-8?B?UEFNb0hHdDltRHZVenJ2Q2oyWjkvSzlTbGtPbE91S1F5aGFhOGpJeWhDd2xJ?=
 =?utf-8?B?cGs1dERITGVkSXdQSXBDbGtONzFJS1hySkNqTW94UUZQWGtZV2tUN1N5TDZs?=
 =?utf-8?B?UlRHZTFrQXR1amd6bzRES2lUdmJWMFVPWXNFMHh6bC92R1E0Z0E5Q2JNd2ZP?=
 =?utf-8?B?OGd5am5Da2Q1OHdTdDVKcnh5dDZNNGlCZ1BzS3g5aC9leitlZGRiMXVhdElU?=
 =?utf-8?B?TGFaNmg3Q1BRTjN5WXlveld1bSthK0FWdGhkUERjeUNHWUh6c3ZCNldIMkpu?=
 =?utf-8?B?R2xRRU9UZEtQeVR1aTB4VTRCYTlXYTVLVmVORERBSEJGb0lrWmVLK2liUXFI?=
 =?utf-8?B?TTdpWXJZVFlvcHlIVnRIbDFYbmVKNmFtaTdmcEN2azJjRnNxQXlka2pENHBp?=
 =?utf-8?B?TnMrOTJMTVBnYzRoMlNSd3JYUUIrR1lOckJrWTlNSVJUUmozWWI5endSM3V3?=
 =?utf-8?B?cEZvczFJU2RmZnhTOTg3cVc0aVRTNTA3MjBNWEVuK0t5Q1IwWDRXYTZnaFNC?=
 =?utf-8?B?RklUSXVlZGYvMXdXcWxBRE9wOGwxUVozL3hoNnZ6RWlTQjFNWWsxamNaamlZ?=
 =?utf-8?B?dlArYWJLKzA0bUNQVHBPK0RGQ3dvZCtCMHVmQXBWa2RsbS8wdGlHWHhYWjI4?=
 =?utf-8?B?a2FFVFhZQXlJdkpYa2t4SmN5UFNsU3N1M0hNVUE3YlpjbXFtRUxadEhaeUNY?=
 =?utf-8?B?TklIbDg4dnlicGxETkkybnNBMjBBZ25YNFdTTEo0SnZHekpTNFRyeitpN0M3?=
 =?utf-8?B?NXNOaGtBVjJhV3U0VEV5MG5xS2gyQ2ozdzhmVGRoejhVVTNPSHRJSmFTWllX?=
 =?utf-8?Q?lKXB/IaCfaMAGAj0kheDbHc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <38A4ACCF636C6A44BBC192E70F9AE8A3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR15MB5821.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3aeae05-002a-4aa6-e97f-08ddea5822fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2025 19:37:22.1596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ig5aMsoHwz8Rtlcpuxo/Em075TDeFeg1Q9AQxsmO+XbbMwhozYbMMhcKq8mCUtZs5ofKxCvWkcqyEcVcAKHuBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR15MB6402
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMCBTYWx0ZWRfX+n0o8EsZHz9B
 5AMMvoSPb4EnKbXhIoG+Gsj5DsaPc/dyeJBUjLe/4lOaoxKXNw5ebBujhQf6h7a764M/Hoyx293
 rw8pk43PDaPrwrW72n0ylZxECsILKvc0jcOY/wpgvgYeUL+CALLn9Zq+IYKw/Fwle1TcuswTGqP
 dxUVIZAG1mmWPQPGiEuKBHzsiINUVsKkYKg+t0CW7VSDq8w+2Hl+tRA2gI1HLZWYf9D9sY7J0KS
 73Qd07M80yzQnSwRrRL8Dch9oGuaLadGLTXuyy1G2h/biNiR3tSakJxFi8Dj3J2/Pi2ENymicz5
 xrYwIbSE8TlN6+pUN9fqMbkkInfyqPpBvSDfRCucfVoRRI73o1ggreK6jeoMj7ZU5LYL7RssUoC
 aguCCYPN
X-Proofpoint-GUID: GYQ7naE9YABpMI145wAcXNecHoaS3VmE
X-Proofpoint-ORIG-GUID: Tlmqk-LVMmr7fsTU_IsZBARTSZwQLpoZ
X-Authority-Analysis: v=2.4 cv=Ao/u3P9P c=1 sm=1 tr=0 ts=68b74778 cx=c_pps
 a=i9pkE5bvGANzVitP6bK0Rg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=w_fEhHaIglNKW6YiRjIA:9 a=QEXdDO2ut3YA:10
Subject: Re:  [PATCH] ceph: optimize ceph_base64_encode() with block
 processing
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_06,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508300030

T24gU2F0LCAyMDI1LTA4LTMwIGF0IDIxOjI4ICswODAwLCBHdWFuLUNodW4gV3Ugd3JvdGU6DQo+
IFByZXZpb3VzbHksIGNlcGhfYmFzZTY0X2VuY29kZSgpIHVzZWQgYSBiaXRzdHJlYW0gYXBwcm9h
Y2gsIGhhbmRsaW5nIG9uZQ0KPiBpbnB1dCBieXRlIGF0IGEgdGltZSBhbmQgcGVyZm9ybWluZyBl
eHRyYSBiaXQgb3BlcmF0aW9ucy4gV2hpbGUgY29ycmVjdCwNCj4gdGhpcyBtZXRob2Qgd2FzIHN1
Ym9wdGltYWwuDQo+IA0KDQpTb3VuZHMgaW50ZXJlc3RpbmchDQoNCklzIGNlcGhfYmFzZTY0X2Rl
Y29kZSgpIGVmZmljaWVudCB0aGVuPw0KRG8gd2UgaGF2ZSBzb21ldGhpbmcgaW4gY3J5cHRvIGxp
YnJhcnkgb2YgTGludXgga2VybmVsPyBNYXliZSB3ZSBjYW4gdXNlDQpzb21ldGhpbmcgZWZmaWNp
ZW50IGVub3VnaCBmcm9tIHRoZXJlPw0KDQo+IFRoaXMgcGF0Y2ggcHJvY2Vzc2VzIGlucHV0IGlu
IDMtYnl0ZSBibG9ja3MsIG1hcHBpbmcgZGlyZWN0bHkgdG8gNCBvdXRwdXQNCj4gY2hhcmFjdGVy
cy4gUmVtYWluaW5nIDEgb3IgMiBieXRlcyBhcmUgaGFuZGxlZCBhY2NvcmRpbmcgdG8gc3RhbmRh
cmQgQmFzZTY0DQo+IHJ1bGVzLiBUaGlzIHJlZHVjZXMgY29tcHV0YXRpb24gYW5kIGltcHJvdmVz
IHBlcmZvcm1hbmNlLg0KPiANCg0KU28sIHdoeSBuYW1lbHkgMy1ieXRlIGJsb2Nrcz8gQ291bGQg
eW91IHBsZWFzZSBleHBsYWluIGluIG1vcmUgZGV0YWlscyB5b3VyDQptb3RpdmF0aW9uIGFuZCBp
bXByb3ZlZCB0ZWNobmlxdWUgaW4gY29tbWl0IG1lc3NhZ2U/IEhvdyBleGFjdGx5IHlvdXIgdGVj
aG5pcXVlDQpyZWR1Y2VzIGNvbXB1dGF0aW9uIGFuZCBpbXByb3ZlcyBwZXJmb3JtYW5jZT8NCg0K
PiBQZXJmb3JtYW5jZSB0ZXN0ICg1IHJ1bnMpIGZvciBjZXBoX2Jhc2U2NF9lbmNvZGUoKToNCj4g
DQo+IDY0QiBpbnB1dDoNCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQ0KPiA+IE9sZCBtZXRob2QgfCAxMjMgfCAxMTUgfCAxMzcgfCAxMTkg
fCAxMDkgfCBhdmcgfjEyMSBucyB8DQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiBOZXcgbWV0aG9kIHwgIDg0IHwgIDgzIHwgIDg2
IHwgIDg1IHwgIDg0IHwgYXZnIH44NCBucyAgfA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IA0KPiAxS0IgaW5wdXQ6DQo+IC0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4g
T2xkIG1ldGhvZCB8IDEyMTcgfCAxMTUwIHwgMTE0NiB8IDExNDkgfCAxMTQ5IHwgYXZnIH4xMTYy
IG5zIHwNCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0NCj4gPiBOZXcgbWV0aG9kIHwgIDc3NiB8ICA3NzIgfCAgNzcyIHwgIDc3NCB8ICA3
NzAgfCBhdmcgfjc3MyBucyAgfA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiANCj4gU2lnbmVkLW9mZi1ieTogR3Vhbi1DaHVuIFd1
IDw0MDk0MTE3MTZAZ21zLnRrdS5lZHUudHc+DQo+IC0tLQ0KPiBUZXN0ZWQgb24gTGludXggNi44
LjAtNjQtZ2VuZXJpYyB4ODZfNjQNCj4gd2l0aCBJbnRlbCBDb3JlIGk3LTEwNzAwIEAgMi45MEdI
eg0KPiANCg0KSSBhc3N1bWUgdGhhdCBpdCBpcyBzdGlsbCB0aGUgY29tbWl0IG1lc3NhZ2UuIFNv
LCBJIHRoaW5rIHRoaXMgcG9ydGlvbiBzaG91bGQgYmUNCmJlZm9yZSBTaWduZWQtb2ZmLWJ5Lg0K
DQo+IFRlc3QgaXMgZXhlY3V0ZWQgaW4gdGhlIGZvcm0gb2Yga2VybmVsIG1vZHVsZS4NCg0KPiBU
ZXN0IHNjcmlwdDoNCj4gDQoNCklzIGl0IGZpbmFsbHkgc2NyaXB0IG9yIGtlcm5lbCBtb2R1bGU/
IEFzIGZhciBhcyBJIGNhbiBzZWUsIGl0IGlzIG5vdCBjb21wbGV0ZQ0Kc291cmNlIGNvZGUuIFNv
LCBJIGFtIG5vdCBzdXJlIHRoYXQgZXZlcnlib2R5IHdpbGwgYmUgY2FwYWJsZSB0byBidWlsZCBh
bmQgdGVzdA0KdGhpcyBtb2R1bGUuDQoNCldoYXQncyBhYm91dCB0byBpbnRyb2R1Y2UgdGhpcyBh
cyBLdW5pdCB0ZXN0IG9yIHNlbGYtdGVzdCB0aGF0IGNhbiBiZSB1c2VkIGJ5DQpldmVyeWJvZHkg
aW4gQ2VwaEZTIGtlcm5lbCBjbGllbnQgZm9yIHRlc3RpbmcgYW5kIGNoZWNraW5nIHBlcmZvcm1h
bmNlPyBJIGFtDQp3b3JraW5nIG9uIGluaXRpYWwgc2V0IG9mIEt1bml0IHRlc3RzIGZvciBDZXBo
RlMga2VybmVsIGNsaWVudCByaWdodCBub3cuDQoNCj4gc3RhdGljIGludCBlbmNvZGVfdjEoY29u
c3QgdTggKnNyYywgaW50IHNyY2xlbiwgY2hhciAqZHN0KQ0KPiB7DQo+IAl1MzIgYWMgPSAwOw0K
PiAJaW50IGJpdHMgPSAwOw0KPiAJaW50IGk7DQo+IAljaGFyICpjcCA9IGRzdDsNCj4gDQo+IAlm
b3IgKGkgPSAwOyBpIDwgc3JjbGVuOyBpKyspIHsNCj4gCQlhYyA9IChhYyA8PCA4KSB8IHNyY1tp
XTsNCj4gCQliaXRzICs9IDg7DQo+IAkJZG8gew0KPiAJCQliaXRzIC09IDY7DQo+IAkJCSpjcCsr
ID0gYmFzZTY0X3RhYmxlWyhhYyA+PiBiaXRzKSAmIDB4M2ZdOw0KPiAJCX0gd2hpbGUgKGJpdHMg
Pj0gNik7DQo+IAl9DQo+IAlpZiAoYml0cykNCj4gCQkqY3ArKyA9IGJhc2U2NF90YWJsZVsoYWMg
PDwgKDYgLSBiaXRzKSkgJiAweDNmXTsNCj4gCXJldHVybiBjcCAtIGRzdDsNCj4gfQ0KPiANCj4g
c3RhdGljIGludCBlbmNvZGVfdjIoY29uc3QgdTggKnNyYywgaW50IHNyY2xlbiwgY2hhciAqZHN0
KQ0KPiB7DQo+IAl1MzIgYWMgPSAwOw0KPiAJaW50IGkgPSAwOw0KPiAJY2hhciAqY3AgPSBkc3Q7
DQo+IA0KPiAJd2hpbGUgKGkgKyAyIDwgc3JjbGVuKSB7DQo+IAkJYWMgPSAoKHUzMilzcmNbaV0g
PDwgMTYpIHwgKCh1MzIpc3JjW2kgKyAxXSA8PCA4KSB8ICh1MzIpc3JjW2kgKyAyXTsNCj4gCQkq
Y3ArKyA9IGJhc2U2NF90YWJsZVsoYWMgPj4gMTgpICYgMHgzZl07DQo+IAkJKmNwKysgPSBiYXNl
NjRfdGFibGVbKGFjID4+IDEyKSAmIDB4M2ZdOw0KPiAJCSpjcCsrID0gYmFzZTY0X3RhYmxlWyhh
YyA+PiA2KSAmIDB4M2ZdOw0KPiAJCSpjcCsrID0gYmFzZTY0X3RhYmxlW2FjICYgMHgzZl07DQo+
IAkJaSArPSAzOw0KPiAJfQ0KPiANCj4gCXN3aXRjaCAoc3JjbGVuIC0gaSkgew0KPiAJY2FzZSAy
Og0KPiAJCWFjID0gKCh1MzIpc3JjW2ldIDw8IDE2KSB8ICgodTMyKXNyY1tpICsgMV0gPDwgOCk7
DQo+IAkJKmNwKysgPSBiYXNlNjRfdGFibGVbKGFjID4+IDE4KSAmIDB4M2ZdOw0KPiAJCSpjcCsr
ID0gYmFzZTY0X3RhYmxlWyhhYyA+PiAxMikgJiAweDNmXTsNCj4gCQkqY3ArKyA9IGJhc2U2NF90
YWJsZVsoYWMgPj4gNikgJiAweDNmXTsNCj4gCQlicmVhazsNCj4gCWNhc2UgMToNCj4gCQlhYyA9
ICgodTMyKXNyY1tpXSA8PCAxNik7DQo+IAkJKmNwKysgPSBiYXNlNjRfdGFibGVbKGFjID4+IDE4
KSAmIDB4M2ZdOw0KPiAJCSpjcCsrID0gYmFzZTY0X3RhYmxlWyhhYyA+PiAxMikgJiAweDNmXTsN
Cj4gCQlicmVhazsNCj4gCX0NCj4gCXJldHVybiBjcCAtIGRzdDsNCj4gfQ0KPiANCj4gc3RhdGlj
IHZvaWQgcnVuX3Rlc3QoY29uc3QgY2hhciAqbGFiZWwsIGNvbnN0IHU4ICpkYXRhLCBpbnQgbGVu
KQ0KPiB7DQo+ICAgICBjaGFyICpkc3QxLCAqZHN0MjsNCj4gICAgIGludCBuMSwgbjI7DQo+ICAg
ICB1NjQgc3RhcnQsIGVuZDsNCj4gDQo+ICAgICBkc3QxID0ga21hbGxvYyhsZW4gKiAyLCBHRlBf
S0VSTkVMKTsNCj4gICAgIGRzdDIgPSBrbWFsbG9jKGxlbiAqIDIsIEdGUF9LRVJORUwpOw0KPiAN
Cj4gICAgIGlmICghZHN0MSB8fCAhZHN0Mikgew0KPiAgICAgICAgIHByX2VycigiJXM6IEZhaWxl
ZCB0byBhbGxvY2F0ZSBkc3QgYnVmZmVyc1xuIiwgbGFiZWwpOw0KPiAgICAgICAgIGdvdG8gb3V0
Ow0KPiAgICAgfQ0KPiANCj4gICAgIHByX2luZm8oIlslc10gaW5wdXQgc2l6ZSA9ICVkIGJ5dGVz
XG4iLCBsYWJlbCwgbGVuKTsNCj4gDQo+ICAgICBzdGFydCA9IGt0aW1lX2dldF9ucygpOw0KPiAg
ICAgbjEgPSBlbmNvZGVfdjEoZGF0YSwgbGVuLCBkc3QxKTsNCj4gICAgIGVuZCA9IGt0aW1lX2dl
dF9ucygpOw0KPiAgICAgcHJfaW5mbygiWyVzXSBlbmNvZGVfdjEgdGltZTogJWxsZCBuc1xuIiwg
bGFiZWwsIGVuZCAtIHN0YXJ0KTsNCj4gDQo+ICAgICBzdGFydCA9IGt0aW1lX2dldF9ucygpOw0K
PiAgICAgbjIgPSBlbmNvZGVfdjIoZGF0YSwgbGVuLCBkc3QyKTsNCj4gICAgIGVuZCA9IGt0aW1l
X2dldF9ucygpOw0KPiAgICAgcHJfaW5mbygiWyVzXSBlbmNvZGVfdjIgdGltZTogJWxsZCBuc1xu
IiwgbGFiZWwsIGVuZCAtIHN0YXJ0KTsNCj4gDQo+ICAgICBpZiAobjEgIT0gbjIgfHwgbWVtY21w
KGRzdDEsIGRzdDIsIG4xKSAhPSAwKQ0KPiAgICAgICAgIHByX2VycigiWyVzXSBNaXNtYXRjaCBk
ZXRlY3RlZCBiZXR3ZWVuIGVuY29kZV92MSBhbmQgZW5jb2RlX3YyIVxuIiwgbGFiZWwpOw0KPiAg
ICAgZWxzZQ0KPiAgICAgICAgIHByX2luZm8oIlslc10gT3V0cHV0cyBhcmUgaWRlbnRpY2FsLlxu
IiwgbGFiZWwpOw0KPiANCj4gb3V0Og0KPiAgICAga2ZyZWUoZHN0MSk7DQo+ICAgICBrZnJlZShk
c3QyKTsNCj4gfQ0KPiAtLS0NCj4gIGZzL2NlcGgvY3J5cHRvLmMgfCAzMyArKysrKysrKysrKysr
KysrKysrKysrLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyMiBpbnNlcnRpb25zKCsp
LCAxMSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2NyeXB0by5jIGIv
ZnMvY2VwaC9jcnlwdG8uYw0KPiBpbmRleCAzYjNjNGQ4ZDQwMWUuLmEzNTU3MGZkOGZmNSAxMDA2
NDQNCj4gLS0tIGEvZnMvY2VwaC9jcnlwdG8uYw0KPiArKysgYi9mcy9jZXBoL2NyeXB0by5jDQo+
IEBAIC0yNywyMCArMjcsMzEgQEAgc3RhdGljIGNvbnN0IGNoYXIgYmFzZTY0X3RhYmxlWzY1XSA9
DQo+ICBpbnQgY2VwaF9iYXNlNjRfZW5jb2RlKGNvbnN0IHU4ICpzcmMsIGludCBzcmNsZW4sIGNo
YXIgKmRzdCkNCj4gIHsNCj4gIAl1MzIgYWMgPSAwOw0KPiAtCWludCBiaXRzID0gMDsNCj4gLQlp
bnQgaTsNCj4gKwlpbnQgaSA9IDA7DQo+ICAJY2hhciAqY3AgPSBkc3Q7DQo+ICANCj4gLQlmb3Ig
KGkgPSAwOyBpIDwgc3JjbGVuOyBpKyspIHsNCj4gLQkJYWMgPSAoYWMgPDwgOCkgfCBzcmNbaV07
DQo+IC0JCWJpdHMgKz0gODsNCj4gLQkJZG8gew0KPiAtCQkJYml0cyAtPSA2Ow0KPiAtCQkJKmNw
KysgPSBiYXNlNjRfdGFibGVbKGFjID4+IGJpdHMpICYgMHgzZl07DQo+IC0JCX0gd2hpbGUgKGJp
dHMgPj0gNik7DQo+ICsJd2hpbGUgKGkgKyAyIDwgc3JjbGVuKSB7DQoNCkZyYW5rbHkgc3BlYWtp
bmcsIEkgYW0gbm90IGNvbXBsZXRlbHkgaGFwcHkgYWJvdXQgaGFyZGNvZGVkIGNvbnN0YW50cy4g
QXMgYQ0KcmVzdWx0LCBpdCBtYWtlcyBjb2RlIGhhcmQgdG8gdW5kZXJzdGFuZCwgbW9kaWZ5IGFu
ZCBzdXBwb3J0LiBDb3VsZCB5b3UgcGxlYXNlDQppbnRyb2R1Y2UgbmFtZWQgY29uc3RhbnRzIGlu
c3RlYWQgb2YgaGFyZGNvZGVkIG51bWJlcnM/DQoNCg0KPiArCQlhYyA9ICgodTMyKXNyY1tpXSA8
PCAxNikgfCAoKHUzMilzcmNbaSArIDFdIDw8IDgpIHwgKHUzMilzcmNbaSArIDJdOw0KPiArCQkq
Y3ArKyA9IGJhc2U2NF90YWJsZVsoYWMgPj4gMTgpICYgMHgzZl07DQo+ICsJCSpjcCsrID0gYmFz
ZTY0X3RhYmxlWyhhYyA+PiAxMikgJiAweDNmXTsNCj4gKwkJKmNwKysgPSBiYXNlNjRfdGFibGVb
KGFjID4+IDYpICYgMHgzZl07DQo+ICsJCSpjcCsrID0gYmFzZTY0X3RhYmxlW2FjICYgMHgzZl07
DQo+ICsJCWkgKz0gMzsNCj4gKwl9DQo+ICsNCj4gKwlzd2l0Y2ggKHNyY2xlbiAtIGkpIHsNCj4g
KwljYXNlIDI6DQo+ICsJCWFjID0gKCh1MzIpc3JjW2ldIDw8IDE2KSB8ICgodTMyKXNyY1tpICsg
MV0gPDwgOCk7DQo+ICsJCSpjcCsrID0gYmFzZTY0X3RhYmxlWyhhYyA+PiAxOCkgJiAweDNmXTsN
Cj4gKwkJKmNwKysgPSBiYXNlNjRfdGFibGVbKGFjID4+IDEyKSAmIDB4M2ZdOw0KPiArCQkqY3Ar
KyA9IGJhc2U2NF90YWJsZVsoYWMgPj4gNikgJiAweDNmXTsNCj4gKwkJYnJlYWs7DQo+ICsJY2Fz
ZSAxOg0KPiArCQlhYyA9ICgodTMyKXNyY1tpXSA8PCAxNik7DQo+ICsJCSpjcCsrID0gYmFzZTY0
X3RhYmxlWyhhYyA+PiAxOCkgJiAweDNmXTsNCj4gKwkJKmNwKysgPSBiYXNlNjRfdGFibGVbKGFj
ID4+IDEyKSAmIDB4M2ZdOw0KPiArCQlicmVhazsNCj4gIAl9DQo+IC0JaWYgKGJpdHMpDQo+IC0J
CSpjcCsrID0gYmFzZTY0X3RhYmxlWyhhYyA8PCAoNiAtIGJpdHMpKSAmIDB4M2ZdOw0KPiAgCXJl
dHVybiBjcCAtIGRzdDsNCj4gIH0NCj4gIA0KDQpMZXQgbWUgdGVzdCB5b3VyIHBhdGNoIGFuZCBj
aGVjayB0aGF0IGl0IGRvZXNuJ3QgaW50cm9kdWNlIHJlZ3Jlc3Npb24ocykuDQoNClRoYW5rcywN
ClNsYXZhLg0K

