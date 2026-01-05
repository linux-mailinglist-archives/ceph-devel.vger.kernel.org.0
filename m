Return-Path: <ceph-devel+bounces-4250-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 94515CF589C
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 21:37:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9AE5830A5EBA
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 20:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9499827F756;
	Mon,  5 Jan 2026 20:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BCPlLpXL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5643D561;
	Mon,  5 Jan 2026 20:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767645395; cv=fail; b=UU33pF/ETIxsDG9bcjy6IpTuNQwqI48d/2azh9f5DSfHhvPTeYyw+YPJBpblIH/2lu8UY4MPI/CvxbefSUelxD3Lz8dHlYcbTExuzarymrKYG5AYCHJO5Zpld4BjUXQwDp44Giq2pMFLekdS9QfD986QcjB+m/g4evO9D3hiIyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767645395; c=relaxed/simple;
	bh=7yTZW5CIoBMw5BpcXVP8lZinb6KIDiVjbw/oHTTg6DQ=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=InxaYIMGqcFztsNQDy9mXN7PrZhFegYRFVH4w/3jlxl9U+UVnwvMzrhfUoC05vQ2GHIyiCXBlcv2lQbXoL8o2aIhHOLIkT0lFlynLgqtDPHb6s42Ksq43Y/ZqDtn4TGzR5FYMhVqEwBhcyhOydafVOD8BQsZIIq45Vob921x7NI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BCPlLpXL; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 605DH6jg008176;
	Mon, 5 Jan 2026 20:36:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=7yTZW5CIoBMw5BpcXVP8lZinb6KIDiVjbw/oHTTg6DQ=; b=BCPlLpXL
	vnykPoZIZkeddbwqzgsZHMvESFZseun5tIWhDwlVkBN4xaNCerfp7s0HHCHiI/PX
	TjU7JVjYpn0XdYuAPL54bFdfTkBIWvg8AgzST/tOpNNmxNyskEs5Y6X0qpozE4is
	9F1hsLkmrsyJMaTOIS47s6fcAMWA+OysWkcimZ+cA30ALo1mny8nA1qwQvXa5DAO
	72xFRRHjQKL6iAHHB40oX9f4tZKGwdv3Yxa2pWtq5eGZV4zjIgNJ4IRyFr6IUAhp
	eD1rKbn/q5uXYOXFVBnMiDDXa//KYZXxe6zeQdPRampFhLFN+FoM2pPCN9RH6bw2
	gGOoZssyndxt8A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betu614gp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 20:36:29 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 605KZvqY023896;
	Mon, 5 Jan 2026 20:36:29 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012021.outbound.protection.outlook.com [40.107.200.21])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betu614gm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 20:36:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZBgGw4nUh54RQEs0+X8FbbZqs0q2t/oEtPNHO+3jyQW4pWs9apYsc4SDmnzjSQKwLrNcA2ppcriVOs7YwEd5jdhGvVkxuskHOUOAOHTKcyeQOc81ZBZRNYP5+AJQoWX/vXhul1XP3ImGAxToTW32m13Io25TjzhVAlobiG1qiItpne8NZjVCgisuY9LOPKhV/tGu2i/vZW2LHCSZYtCPzL7TJbEuv75te/9lKufEh3q4GFWcj+qoDEETINcFKMjtO2Jninycq8mz3Z5CcoqSD7AynonMUmf+BOrce9CsbrhUz9bdsBGFUI7y6SFclML5hA6eJJKnGnot4SUPrHJl0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7yTZW5CIoBMw5BpcXVP8lZinb6KIDiVjbw/oHTTg6DQ=;
 b=BtOY7NzRnbxbLRz0SgIpuKD9dmILXvyOVX4fhdJE32pWB2Cz8J9De5upxw5+6Bp3al3FPfpou3DV7DcIDk2P5asltCY1cMmV1DQ7rGfdUCsIp4iEeZWodYH83jiriDvUey7DTJXfEQTAHN3RMk+blHkIrmUImix6sa1f408s93Yzz/Kw88E+Kt5VwSD/Ta4RVxuhRVWD5DrwfRMTNCqOFydOx6dYlmHzAAKHPFJL4gn6tqR8BN9cbr05NCsH+yctiZdiJ8NH/zWe8Jf2H6BHTdK8kse1eSxH4KvuSZt5xLAqXfefrlzGVdEfo2zKQ+NhdvBVV7zwuf15VD7Q+YX3Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by IA0PPF81A6374A2.namprd15.prod.outlook.com (2603:10b6:20f:fc04::b2f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Mon, 5 Jan
 2026 20:36:26 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 20:36:26 +0000
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
Thread-Topic: [EXTERNAL] [PATCH 2/5] ceph: Remove error return from
 ceph_process_folio_batch()
Thread-Index: AQHcegDv2KhqS1fOpEas/rCEkO8KLLVEEemA
Date: Mon, 5 Jan 2026 20:36:26 +0000
Message-ID: <fe859743904a2add8d7d67f64ab9686769670782.camel@ibm.com>
References: <20251231024316.4643-1-CFSworks@gmail.com>
	 <20251231024316.4643-3-CFSworks@gmail.com>
In-Reply-To: <20251231024316.4643-3-CFSworks@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|IA0PPF81A6374A2:EE_
x-ms-office365-filtering-correlation-id: 3bdac492-f588-4dd9-01ed-08de4c9a1909
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?QXFqMHVyZGo2N1hKcWNXUVpSNWVGK2c3Q29OM2NLQitSazZ3NGE5YWcwd1VX?=
 =?utf-8?B?QTRNeEdSQVdVOWhzL2wwbkwvditoYk9zM3pHaWpzNXlscHlsTGovbDRhWUJS?=
 =?utf-8?B?ekRXY2grYjFzdVJydDVBaksvcEliN3pQREVHMis4RjhjRWFsTkhZUnpWK3Z3?=
 =?utf-8?B?b21udjhTV3FhTDZyeitnTFEyaUxYbC9RY2ZzVjNsT2pmNjFRZS9rQWFjTXRK?=
 =?utf-8?B?dC8weVMvZ0luTTBsdUhhMHdObm5kK2l3ejdQdUd4eWhJaEQzME4yWnp3RDdS?=
 =?utf-8?B?UHE2Y3lhaG9nTWlheGhKRC8xMFkxYko0c3ZCeCtvYlBXcWJ0a1Z6K1FVb2Fp?=
 =?utf-8?B?dzI1SzRRVzZCb25sRWN6dGpTeUZvZnlWUUIvVitFMWJzYVo0aWY5U2NzeUNF?=
 =?utf-8?B?NlI5ZE1NUWZvWWFnTElGR0pnN3NQRGR6M0FxT0ltdXFJS2xrQkxXbSt5dGZa?=
 =?utf-8?B?cXJ0OUhHTlo1TURabWk2U1dLOTk4Wi9ha1gxTFN0T2FLU2k1clphTnMrMDFD?=
 =?utf-8?B?Ymg2Sml2Sit6RjlvWTFpZFNHQkxNbVEwdzliRFJFSGRoVEtjUUNBZWhQZk1G?=
 =?utf-8?B?SitHS1dzanU2c2FaNks5djZVcXA3cnZMakwvdTBIYWM3RW1rVnhSUEZCWFdr?=
 =?utf-8?B?SzhwdHgzNUlpeWZwYUUxaWlKME9salh2VXRDeC8wZXZPa0dJYTZhVk1kOVJx?=
 =?utf-8?B?M1Z4UGI5Tzc3Szd6NEpyYUVva1NnWnF1YjVVSkNkcm1mREwwUlpGd2x0NDFG?=
 =?utf-8?B?MTI5NTFROHRLeDZCbWFVQ2hJeC95emd2THg2d2U5VTdVMXkxS3FGL2plOTB6?=
 =?utf-8?B?UmJFbzN6bG5DcWo3KzBKT1poc00vcFJIN3pCVXlUVU5GV2pVbUlNRzlGZExR?=
 =?utf-8?B?a3VianBoVXp3R0JOSXJDWkFoVUJpU09EUHk2cWpZTDR5T3VRcUVWdkJmZVFE?=
 =?utf-8?B?T3VrdHoxQ2Q0NktDeExXYWxHZFljNnZOVW9nSXU0RTljRlJrZi82K3BMZUUy?=
 =?utf-8?B?RWlybFk2QktvUG5KYkw4S3JsMmNuWWF1YnNIV3pBMjR5UXM4bTBRYThQTEQ4?=
 =?utf-8?B?bTNLdHo0Rlc2YmJoMlhrTklkZ0wvM0ttK0V1Z05HcXBZZ2Nhem1FSGNXZzhr?=
 =?utf-8?B?ZUtyOU10VlNXUkVpdXRLRXRKcUlNZXJkNjJtTHdvdGt5WlM5MkNJR1A2L2Ry?=
 =?utf-8?B?YnIwQXV5VFg5NG5NcXVWVFk2emF6QkNhTFZ0Yjc3c0NReExDakZLeUVzV1pX?=
 =?utf-8?B?TUg1RnlJTVpIZUJXUFJJR2NJcllJbDZoNzNQczhXVGtuc0lKTU1BYWJiSVp1?=
 =?utf-8?B?S3JIa0s0aFBtWUdLTjNzS3lWbUdVUFMxN1FWOTBUSFNyWU5BSTQvVTR5YVBE?=
 =?utf-8?B?eVRwSjAzRUlTaFpiYlpzTVBIa3VvN29RUERDdWdLa1Z3aVF6UUx5K2N6cUkz?=
 =?utf-8?B?TkNSRjljbXZtclhZTmJHSTlUNlF6c0Z0QW5xZ0FEaFVyYm1wNWo2U1FEQVdH?=
 =?utf-8?B?dDRvaEZlQ1VSUlRJc3Q0N3FZdDFYOVQ2Zng2bmdyVWdYZTlxOHMrSGo3bUhm?=
 =?utf-8?B?MHp4eEYxVk01WW5WeS9Sd1ZyVXlCYlhlV3NFTkNzZFRJczZxUyt1ZTRXOWpz?=
 =?utf-8?B?cGJOL2FHME8vdmVDVFMvYUpBZEFpRDIvZExtVk5BcDBkRkpVOHV4TmU0Tkc1?=
 =?utf-8?B?SlZtVmNmZmFlUE9INExFUjNVY2kxbjlJL2JUMEltdzVvQmI3VDlnOFZSc2Rw?=
 =?utf-8?B?ejlYaXYwYUpXcXllVWN3UEFCSG0xdE9yV1dFRXc3YzFpSEFLUmllMjlUVFpV?=
 =?utf-8?B?MXI0M2tQOHl1ZFR4NDZMLzRpaHhhazZsNVhWZWUzU0dyb1pKb3Vyd2p3STND?=
 =?utf-8?B?ODQxUHp0Rk0yem01RDZxdFRVRGNrbFJhWlpneEwvYTVIMWVHQ3FxZmRiUFJV?=
 =?utf-8?B?OENBMVFZR3B2YW5JdUlad1UxS2VRcHJkRW9ZRkdwQUd6ajNBZWFRbWRlL2po?=
 =?utf-8?B?b0ZMb3dDc0dHeU9LRERxMU8vRUNPU3g4MkdmcmI0THAydGp0NFhIME96dXM3?=
 =?utf-8?Q?QlliZe?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NzRncG1SNXFsajVmUEdOclRwRVpWL1Z0Sk5tRnVRb1VKYkoxajZwZk1kVWcw?=
 =?utf-8?B?dHcrSlpxNU0rNlFRMFpMUTFaZFpnSllydUxaSmtheFRJTE9Zek9CQlFSZHhz?=
 =?utf-8?B?Y0c5TjY4eUZmNU12aUY0MGx2QU9hZCtrVVRMVnd6Tkd4bzRHWUJGd0FYRzNs?=
 =?utf-8?B?byt5T2I0cjJ0dFdUNTRkWkNEcTdFUEI0emFralQ2YmZKTzg1M3YvM0YyUjdZ?=
 =?utf-8?B?djNEdGszUjlzUytyWWhtSHNJdnlQcDZoNlUyU2lUbUZtbTNCQkV0cnkxQWl3?=
 =?utf-8?B?ZlFTdGJzSFdqK2I2UWZiMkdOWkVqVDBYRGR6c1AvY3pWa3VkTEtPUDRSV0E0?=
 =?utf-8?B?SXRmbVpxVklTK0JjRzBFajh1bmxiWWQ2Z0tqWXFybi80MHVKWldoNUNxeGRq?=
 =?utf-8?B?Q3N0dTlJdGc1V1VGeUtreGtlUXVxYjljcXR0dlA1anFVSGtocFIxek84RU56?=
 =?utf-8?B?blV1eXB3MTNtSU1JZzFPTVVkUlYvL2l1QTZhNUtOT20wbEMyNmpwUjhacUJE?=
 =?utf-8?B?YW5DanhvYnlsT0FGRlE0Ym9ydnMzT3ZYa0R4OVJ6QWtranJxQ1BWU0ZkWjF3?=
 =?utf-8?B?bzhyRzR4R1NMeXBnR00venpaK0s1ZytMaHhwdjdJK0FHSHhYZjN5TDRpdDE4?=
 =?utf-8?B?bHNDZ2ZDWEtZNkFXWG1JT0IwaTMrNXlnK1hhT1Nob2ttTGk1Z0pUc3dPOFRr?=
 =?utf-8?B?N1RnTVZEZlJrSnAyYkd1bnBMaFJ5bFQ4OXI4SDhJMlpwWUZQRkozSHUzMTE4?=
 =?utf-8?B?amdEQzcrQUtHSXMzUWpRdzU5cy9OSGtkT3RrUU5qelJpS1E5WXAzOWJtYXM0?=
 =?utf-8?B?QnEyQ2FUQmY3bUpOVXN6Mi9mM2JXYk9HM3VrYWRaV1I3TVlEVUZCQjk5ZVh4?=
 =?utf-8?B?bHZJUHNPWjdKbjMvcThUZ0s3Ui9PTFNMNFdNZkpLTjFybXlrRFF6VFB5RnZO?=
 =?utf-8?B?VDl2TmxXZmhDNGhYR25jNDQxb1hmQnVDbUNGQjdqd1d4OHdBRktITGszRjNj?=
 =?utf-8?B?cm04Mm91NUNFWnB3a3ZSZ1d3ekExOFVNVTUrRVZWdGxzVUxLQzRva1pyenFx?=
 =?utf-8?B?Nzk3MXVROFJiMU5SR3V5NHZhSGR6S3VJKy9kUm5BOXlqYWVsc2J2VDJRU2Ft?=
 =?utf-8?B?b0czNVZ2b2FiQy9FU0pFMDZIcldLd09OZXNLOHNzdkVCS3BHOUVlVjZaT0Uw?=
 =?utf-8?B?MS81VTloTFZDL1BzSmdNMmV6WHhTaWgvSWFsS3doRStFbjcwSEpoVjdlL1lB?=
 =?utf-8?B?VmVmNmJmdzJpcEFLdlhCK201SjRDL2lDNW50djVBMHZ6T3JOQytyWkdtVysx?=
 =?utf-8?B?cEIrcHRYOWI3cHB1enlJWGVjMjVBakZoY1JSbGhtVjlPeUo4bFFvLzBKcmlx?=
 =?utf-8?B?Q2ZtblR3amkxYTRtWFlWQVR3Z2JrRDBvYk9GYkx0ci84YzBuL28zQ1MwYzQ4?=
 =?utf-8?B?NXA3VTROOW43REVFbU4ydXJQZU9VOFNKV3FieWNaTndLREdiUVR5eGlSWXVQ?=
 =?utf-8?B?NGZmRzF2QURhMXQrWkJuVmpuTk1COWs3ckU1b3ZxNnVQYVYvbTFING43RkY5?=
 =?utf-8?B?ZUUxU2tLeHpGd3NwQUVRY2xHV3UwRnBuRVVsSjZDeXpLRU5YV3dQdnpQeUVv?=
 =?utf-8?B?KzNPZkdiN2hXZ05vOEVBZUxTajZWNEdYR25sMTBrZURMekFKWVpoazdyRGt0?=
 =?utf-8?B?VXNJQWo4VXY5bXlvQUxkMjBScWxobkVZSSswTWtFMURmVGd3QnR3OUpPNGQv?=
 =?utf-8?B?RVc2UVFYcnFKcDdlb0VOTU1SY0NYNVRHL21BZVIrdlJjWVlYR3pWMmIyM0Zi?=
 =?utf-8?B?OGRRQU95Nm5JZG1WNml2RjJ3WHk4aE56Njg5MmJZRGpoOTFPd2grS2pqbGZu?=
 =?utf-8?B?UWlSeTM3VXk3K0VzYVZwZHNsK1owWTlabnpYa2gvaXZCN1I1SzZPR2VDdU80?=
 =?utf-8?B?Z2VadGtkdXEvRnNOdFNMYW9pWkNBMnA1K0dNRU1tMGZKeTdoaysvS20yWnNn?=
 =?utf-8?B?MEJGUVY1cGZtNlI5TlZwYzB6Wjdaa1FTRUQzck1NWFpSM1V3eHlNYjdOUGd0?=
 =?utf-8?B?SDRZYWlBeHU5YWNNWlhsMmJKanFSYXhRQkc3aXhZZmo1U1FnK29tdWtKVFUw?=
 =?utf-8?B?Rm5mc3IrQWF2elNJNE1pUlVuWnNMZFZWMXlkNy9wSXZMWlBXOGd6cG9iOWtj?=
 =?utf-8?B?NlVySmlFOEREODhCcXVJTUxrSFRsaUg0UHVMcmUrR01ad3hFMUhzbXE5MkNr?=
 =?utf-8?B?N1lkb2lGZWRmZTBVYk04aCs2ZTNWTG94ZjA2aXVKVnV1WDJJTVJ2Qk9sL1hk?=
 =?utf-8?B?R0RCTyt5Q1dCSVRaS1YrTmowSXQzQUJLVVVkSWNQenAvNWhISE90UHFsWGJ2?=
 =?utf-8?Q?1Gm28xChp1VDsB3HVBCvcUnc8NOY75P3LeyFC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <413AFFE076ECF2499FAD6FAD2E71E3E1@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bdac492-f588-4dd9-01ed-08de4c9a1909
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2026 20:36:26.1856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Crip0/x9bxlSadzMB++BwggT4/ZAtvThS+bYP/4cq/DZxIY/fQVKuyJDPu5mnIvkan3jwflpVzxz+DbxAU70A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF81A6374A2
X-Authority-Analysis: v=2.4 cv=QbNrf8bv c=1 sm=1 tr=0 ts=695c20cd cx=c_pps
 a=qCFiEXCgs887QpJba4awmw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8
 a=KBVUG00mDK2Yv5t489gA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: MkoWSe4L5kKjfOlbDsC4qHmU7bmyblZe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE3NyBTYWx0ZWRfX797IKRnNQ89K
 KRr6n79vGZ9JL0c33gLMNNvZEpGdQ+QN2E3VakLLG2VFsa7vFGQGdL5UZxbql+0L4X5fxv1hZhm
 RawSycuAbJM9xXPCV5TfvQijFRSi4qWjEKVcajrFwXWZkouLoI428uTOCQVEUyD96ISl1Ni15EJ
 vP0sXD+HL0PnyuPEmoVg9Y4xZhgbwe5qhX5OboRbyNWCXkZ6ILP8sUWkGPvu/yu7jyPLgn5DDtN
 BEuwowLWVtPo4HMvai/0afB31KFlM+7rFfzxfmF+u0/JZ26ma7ibFCeHUmda3Mxg/3e8vFGoY9f
 JuIjZnehkDjCtwUj1nxA0Htx2PUHk2+RUBNB6aubDWQB24Q3eFiclplmtugRKn7FFYI9l19VNOd
 nJzefBNT/96SZLNfxEGyO2/FEUbCUe6h2Q9Fzo3E8F0mNPoPqUVW5CntH6pZT0xsXN4XRLcWXmV
 W+X0uu7h0OLfPHK6zyg==
X-Proofpoint-GUID: Nd80ugUSpp1mgqtOa1KHTYfpqLaKVpfl
Subject: Re:  [PATCH 2/5] ceph: Remove error return from
 ceph_process_folio_batch()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 bulkscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601050177

T24gVHVlLCAyMDI1LTEyLTMwIGF0IDE4OjQzIC0wODAwLCBTYW0gRWR3YXJkcyB3cm90ZToNCj4g
Rm9sbG93aW5nIHRoZSBwcmV2aW91cyBwYXRjaCwgY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKCkg
bm8gbG9uZ2VyDQo+IHJldHVybnMgZXJyb3JzIGJlY2F1c2UgdGhlIHdyaXRlYmFjayBsb29wIGNh
bm5vdCBoYW5kbGUgdGhlbS4NCg0KSSBhbSBub3QgY29tcGxldGVseSBjb252aW5jZWQgdGhhdCB3
ZSBjYW4gcmVtb3ZlIHJldHVybmluZyBlcnJvciBjb2RlIGhlcmUuIFdoYXQNCmlmIHdlIGRvbid0
IHByb2Nlc3MgYW55IGZvbGlvIGluIGNlcGhfcHJvY2Vzc19mb2xpb19iYXRjaCgpLCB0aGVuIHdl
IGNhbm5vdCBjYWxsDQp0aGUgY2VwaF9zdWJtaXRfd3JpdGUoKS4gSXQgc291bmRzIHRvIG1lIHRo
YXQgd2UgbmVlZCB0byBoYXZlIGVycm9yIGNvZGUgdG8ganVtcA0KdG8gcmVsZWFzZV9mb2xpb3Mg
aW4gc3VjaCBjYXNlLg0KDQo+IA0KPiBTaW5jZSB0aGlzIGZ1bmN0aW9uIGFscmVhZHkgaW5kaWNh
dGVzIGZhaWx1cmUgdG8gbG9jayBhbnkgcGFnZXMgYnkNCj4gbGVhdmluZyBgY2VwaF93YmMubG9j
a2VkX3BhZ2VzID09IDBgLCBhbmQgdGhlIHdyaXRlYmFjayBsb29wIGhhcyBubyB3YXkNCg0KRnJh
bmtseSBzcGVha2luZywgSSBkb24ndCBxdWl0ZSBmb2xsb3cgd2hhdCBkbyB5b3UgbWVhbiBieSAi
dGhpcyBmdW5jdGlvbg0KYWxyZWFkeSBpbmRpY2F0ZXMgZmFpbHVyZSB0byBsb2NrIGFueSBwYWdl
cyIuIFdoYXQgZG8geW91IG1lYW4gaGVyZT8NCg0KPiB0byBoYW5kbGUgYWJhbmRvbm1lbnQgb2Yg
YSBsb2NrZWQgYmF0Y2gsIGNoYW5nZSB0aGUgcmV0dXJuIHR5cGUgb2YNCj4gY2VwaF9wcm9jZXNz
X2ZvbGlvX2JhdGNoKCkgdG8gYHZvaWRgIGFuZCByZW1vdmUgdGhlIHBhdGhvbG9naWNhbCBnb3Rv
IGluDQo+IHRoZSB3cml0ZWJhY2sgbG9vcC4gVGhlIGxhY2sgb2YgYSByZXR1cm4gY29kZSBlbXBo
YXNpemVzIHRoYXQNCj4gY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKCkgaXMgZGVzaWduZWQgdG8g
YmUgYWJvcnQtZnJlZTogdGhhdCBpcywgb25jZQ0KPiBpdCBjb21taXRzIGEgZm9saW8gZm9yIHdy
aXRlYmFjaywgaXQgd2lsbCBub3QgbGF0ZXIgYWJhbmRvbiBpdCBvcg0KPiBwcm9wYWdhdGUgYW4g
ZXJyb3IgZm9yIHRoYXQgZm9saW8uDQoNCkkgdGhpbmsgeW91IG5lZWQgdG8gZXhwbGFpbiB5b3Vy
IHBvaW50IG1vcmUgY2xlYXIuIEN1cnJlbnRseSwgSSBhbSBub3QgY29udmluY2VkDQp0aGF0IHRo
aXMgbW9kaWZpY2F0aW9uIG1ha2VzIHNlbnNlLg0KDQpUaGFua3MsDQpTbGF2YS4NCg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogU2FtIEVkd2FyZHMgPENGU3dvcmtzQGdtYWlsLmNvbT4NCj4gLS0tDQo+
ICBmcy9jZXBoL2FkZHIuYyB8IDE3ICsrKysrLS0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgNSBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9m
cy9jZXBoL2FkZHIuYyBiL2ZzL2NlcGgvYWRkci5jDQo+IGluZGV4IDM0NjJkZjM1ZDI0NS4uMmI3
MjI5MTZmYjliIDEwMDY0NA0KPiAtLS0gYS9mcy9jZXBoL2FkZHIuYw0KPiArKysgYi9mcy9jZXBo
L2FkZHIuYw0KPiBAQCAtMTI4MywxNiArMTI4MywxNiBAQCBzdGF0aWMgaW5saW5lIGludCBtb3Zl
X2RpcnR5X2ZvbGlvX2luX3BhZ2VfYXJyYXkoc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcs
DQo+ICB9DQo+ICANCj4gIHN0YXRpYw0KPiAtaW50IGNlcGhfcHJvY2Vzc19mb2xpb19iYXRjaChz
dHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZywNCj4gLQkJCSAgICAgc3RydWN0IHdyaXRlYmFj
a19jb250cm9sICp3YmMsDQo+IC0JCQkgICAgIHN0cnVjdCBjZXBoX3dyaXRlYmFja19jdGwgKmNl
cGhfd2JjKQ0KPiArdm9pZCBjZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2goc3RydWN0IGFkZHJlc3Nf
c3BhY2UgKm1hcHBpbmcsDQo+ICsJCQkgICAgICBzdHJ1Y3Qgd3JpdGViYWNrX2NvbnRyb2wgKndi
YywNCj4gKwkJCSAgICAgIHN0cnVjdCBjZXBoX3dyaXRlYmFja19jdGwgKmNlcGhfd2JjKQ0KPiAg
ew0KPiAgCXN0cnVjdCBpbm9kZSAqaW5vZGUgPSBtYXBwaW5nLT5ob3N0Ow0KPiAgCXN0cnVjdCBj
ZXBoX2ZzX2NsaWVudCAqZnNjID0gY2VwaF9pbm9kZV90b19mc19jbGllbnQoaW5vZGUpOw0KPiAg
CXN0cnVjdCBjZXBoX2NsaWVudCAqY2wgPSBmc2MtPmNsaWVudDsNCj4gIAlzdHJ1Y3QgZm9saW8g
KmZvbGlvID0gTlVMTDsNCj4gIAl1bnNpZ25lZCBpOw0KPiAtCWludCByYyA9IDA7DQo+ICsJaW50
IHJjOw0KPiAgDQo+ICAJZm9yIChpID0gMDsgY2FuX25leHRfcGFnZV9iZV9wcm9jZXNzZWQoY2Vw
aF93YmMsIGkpOyBpKyspIHsNCj4gIAkJZm9saW8gPSBjZXBoX3diYy0+ZmJhdGNoLmZvbGlvc1tp
XTsNCj4gQEAgLTEzMjIsMTIgKzEzMjIsMTAgQEAgaW50IGNlcGhfcHJvY2Vzc19mb2xpb19iYXRj
aChzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZywNCj4gIAkJcmMgPSBjZXBoX2NoZWNrX3Bh
Z2VfYmVmb3JlX3dyaXRlKG1hcHBpbmcsIHdiYywNCj4gIAkJCQkJCSAgY2VwaF93YmMsIGZvbGlv
KTsNCj4gIAkJaWYgKHJjID09IC1FTk9EQVRBKSB7DQo+IC0JCQlyYyA9IDA7DQo+ICAJCQlmb2xp
b191bmxvY2soZm9saW8pOw0KPiAgCQkJY2VwaF93YmMtPmZiYXRjaC5mb2xpb3NbaV0gPSBOVUxM
Ow0KPiAgCQkJY29udGludWU7DQo+ICAJCX0gZWxzZSBpZiAocmMgPT0gLUUyQklHKSB7DQo+IC0J
CQlyYyA9IDA7DQo+ICAJCQlmb2xpb191bmxvY2soZm9saW8pOw0KPiAgCQkJY2VwaF93YmMtPmZi
YXRjaC5mb2xpb3NbaV0gPSBOVUxMOw0KPiAgCQkJYnJlYWs7DQo+IEBAIC0xMzY5LDcgKzEzNjcs
NiBAQCBpbnQgY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKHN0cnVjdCBhZGRyZXNzX3NwYWNlICpt
YXBwaW5nLA0KPiAgCQlyYyA9IG1vdmVfZGlydHlfZm9saW9faW5fcGFnZV9hcnJheShtYXBwaW5n
LCB3YmMsIGNlcGhfd2JjLA0KPiAgCQkJCWZvbGlvKTsNCj4gIAkJaWYgKHJjKSB7DQo+IC0JCQly
YyA9IDA7DQo+ICAJCQlmb2xpb19yZWRpcnR5X2Zvcl93cml0ZXBhZ2Uod2JjLCBmb2xpbyk7DQo+
ICAJCQlmb2xpb191bmxvY2soZm9saW8pOw0KPiAgCQkJYnJlYWs7DQo+IEBAIC0xMzgwLDggKzEz
NzcsNiBAQCBpbnQgY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKHN0cnVjdCBhZGRyZXNzX3NwYWNl
ICptYXBwaW5nLA0KPiAgCX0NCj4gIA0KPiAgCWNlcGhfd2JjLT5wcm9jZXNzZWRfaW5fZmJhdGNo
ID0gaTsNCj4gLQ0KPiAtCXJldHVybiByYzsNCj4gIH0NCj4gIA0KPiAgc3RhdGljIGlubGluZQ0K
PiBAQCAtMTY4NSwxMCArMTY4MCw4IEBAIHN0YXRpYyBpbnQgY2VwaF93cml0ZXBhZ2VzX3N0YXJ0
KHN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nLA0KPiAgCQkJYnJlYWs7DQo+ICANCj4gIHBy
b2Nlc3NfZm9saW9fYmF0Y2g6DQo+IC0JCXJjID0gY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKG1h
cHBpbmcsIHdiYywgJmNlcGhfd2JjKTsNCj4gKwkJY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKG1h
cHBpbmcsIHdiYywgJmNlcGhfd2JjKTsNCj4gIAkJY2VwaF9zaGlmdF91bnVzZWRfZm9saW9zX2xl
ZnQoJmNlcGhfd2JjLmZiYXRjaCk7DQo+IC0JCWlmIChyYykNCj4gLQkJCWdvdG8gcmVsZWFzZV9m
b2xpb3M7DQo+ICANCj4gIAkJLyogZGlkIHdlIGdldCBhbnl0aGluZz8gKi8NCj4gIAkJaWYgKCFj
ZXBoX3diYy5sb2NrZWRfcGFnZXMpDQo=

