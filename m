Return-Path: <ceph-devel+bounces-3403-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB8A0B21738
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 23:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AABD3B5015
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 21:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E861F4C8C;
	Mon, 11 Aug 2025 21:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LuBg/7T7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB152DCBFC
	for <ceph-devel@vger.kernel.org>; Mon, 11 Aug 2025 21:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754947255; cv=fail; b=Q+wiIXA/ImOzagp5OKOnMTjYzntixq17s+ppw3zDZ5wsAB2mNzZYZ5DzH1uwdTN2Qy5J7zu3dMG08PvVkGzSGqPofFxUf0vdtAt1hW80nKTr5j14RmQg2uJGwO1A7EZcxawXcjILmI5vTECpdVrTjx7MxShTSsEA8lK90kOP2J8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754947255; c=relaxed/simple;
	bh=TzVt9ikyvhTt2Vq4SWlWZlWYoXzQsGF4bOECKR6afGo=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=soWuOXveZvNXKHHhrUjO5fkB0NqYMU+NGUWzZN10p0zIUfrb+pWDjz/d6TbE+wjJoF8XPOqIrXt01ephzg7E4hJJdRgg5n/QzwtDt7caTGGlWuVVGRpfFi2sBXFSZQX/A8IPLhwsIsZzOb9X3Fp83AW8iKD8wOtj/87DiAQAiBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LuBg/7T7; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BKWauO015213;
	Mon, 11 Aug 2025 21:20:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=TzVt9ikyvhTt2Vq4SWlWZlWYoXzQsGF4bOECKR6afGo=; b=LuBg/7T7
	jlHF2ysMcU/1juGzP191xdWjbqZNbD61gtrZEiDrm1P0NGWu6Sou0aE9FMYQ5i50
	lrRfsOuRkZc5jvmK9BUE/ePib7DwctFCXUWbKKdhXM6OTbj7jNKoJHpnvKOqwLny
	TRB3Oy8tkBCI0m6UJgiZ3cY/JkK/JQnE5v8tTLFcNB4/I8+MgXMhoqir45G3LsGg
	gZBTY4x3GSluCw7hNxhsIOTyTGA8nScLms2cjrv75tyP5HAqadj9aqrdojNAsJUa
	HTnoZ0aKxVYfHbll/qckSXrsT2inBrKB2Z2/Gv6CWbxlj/gzqtDi2brjQiPD3xQy
	5MWCuzmkSqGfww==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48duru3ct8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 21:20:49 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57BLKnsT014885;
	Mon, 11 Aug 2025 21:20:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48duru3ct4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 21:20:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E57E9FYqOoKGmxsQLCKa2xVhERlvMGwGNkIrfKmSYBHHk5i192oBda8XSkTybpRvuGSsapV2YiJqej1HbBa2F6eskbUKcqnm07Cl0cWNbXLf9Eo9bRfilnrd2DyZdzwM5EHcpyEkS48Bp9+JSXWvre9TOYRHfNuXV97JRoqBlRN30zYxj7dqguAK0sAHyXC8dJ8X58wYc4d3BgH0ucPJyAi8RBXvduY7a6EzaGds0rjJuLpyhtkxHKqDuvqqtkVVModWXKiOiCLs/FtvOtOk653wrwEeVP0nLuJ0q+X/X5nxkWEeR376B+uUHQoFrkezJLOxE3Xbdx5+kAfyyJOLTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TzVt9ikyvhTt2Vq4SWlWZlWYoXzQsGF4bOECKR6afGo=;
 b=x5xeZgQrSkje2bxREbIZIxqf3aArEOS8EWW74wp9X7mL0NEFsXky8kQc0yq/+FWYGeJ9apIUpB1osu42oG1f3CMTfGzzVzXA13Dq/zqZ45G3QAPW1YkN52mzNLCG7PgbtlDD12+DcJX4+8Cai82puGNL5FRB2T0t4RHP5a5uE7KSBVCHBVGk271xc44g81/MSs1iY0GvudQcOiFMvnsT33hbsj2lQ0krDOolIm6+vWui/8szRZhQ72No1n1sgfzBj50fGYoMfJkPBDnNQCZcx5bTBnxJI0Sc/qR2F61v4gfqfU73I22KwUKt4gIwzmajDTQwVMfMuhCld34Sunrc0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ4PPFC308B8970.namprd15.prod.outlook.com (2603:10b6:a0f:fc02::8c1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Mon, 11 Aug
 2025 21:20:47 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9009.017; Mon, 11 Aug 2025
 21:20:47 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Kotresh Hiremath Ravishankar <khiremat@redhat.com>
CC: Alex Markuze <amarkuze@redhat.com>, Venky Shankar <vshankar@redhat.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Patrick Donnelly
	<pdonnell@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] ceph: Fix multifs mds auth caps issue
Thread-Index: AQHcAwnX8VFv10r3BUWfP7rTtDMVw7RON+EAgAchUwCACKxSAA==
Date: Mon, 11 Aug 2025 21:20:46 +0000
Message-ID: <75632a861cf3c3fe77bbc384a805e9e4e77b95a8.camel@ibm.com>
References: <20250729170240.118794-1-khiremat@redhat.com>
	 <3dbbabbd68b58c95a73d02380ce6e48b5803adf2.camel@ibm.com>
	 <CAPgWtC4s6Yhjp0_pnrcU5Cv3ptLe+4uL6+whQK4y398JCcNLnA@mail.gmail.com>
	 <6ec6e3f45e4b90c2b56f4732e0e56fb389442c6e.camel@ibm.com>
	 <CAPgWtC5muDGHsd5A=5bE4OCxYtiKRTLUa1KjU348qnfPDb54_Q@mail.gmail.com>
In-Reply-To:
 <CAPgWtC5muDGHsd5A=5bE4OCxYtiKRTLUa1KjU348qnfPDb54_Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ4PPFC308B8970:EE_
x-ms-office365-filtering-correlation-id: 3f78a389-f3f4-4582-f89f-08ddd91cf038
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Z25OYUd1WHJRUVl2V3lzejNIcXA1ak5qRXZGZVg2RnFaQzZITTFqazFUZm1Z?=
 =?utf-8?B?V3VWNk05Mjl1VVk3a1JKVlBMbW0zQlJkWTQrVlJJNVhzOWxRRk1lTldKdjFF?=
 =?utf-8?B?bjdlUG1vNzlBeHkyclpCWTFDNlJ5b0dVbGo2YmdCd2QxeEwvZXIzQWlUVllv?=
 =?utf-8?B?b0pPUW5lbnFPVmZSSndKcWpKSDRmZFR2RDY5b2lPVXgrTS9MdG9CblZibjFE?=
 =?utf-8?B?UmxvNVZQR0hhUnVlYXVTZWQwMWJkejQxUFJjTk9mem9ZUGpNZERZd3JiTnlJ?=
 =?utf-8?B?OWt1WDFIWGl2NDZxR1ZhUCsyVW5IZXlRYkFTaERzZUtSbEtQd3pZWXFMY05j?=
 =?utf-8?B?VFpyMmFzdFdCeUt2c1V0a24yY3JXblFDS3EzWFJqTjg2cVBPdDczMGRGVkg3?=
 =?utf-8?B?MTB0VDY3OGV1WWVDdkdZY25SS0lXaDM5VGNOSkVPNWFkcVJ0bjJDMHlMRENB?=
 =?utf-8?B?Yzd2dCs2WXBKMGJVTUxFNUw0cjFvKzJ1bG03TGM0aHJFdUptdk80NmZ4M25p?=
 =?utf-8?B?L25xUVJnSkJ1WGJvbDM1dlErbU85M1FaZm1yYzRFNWFaWjJJNFVOK01KZlQv?=
 =?utf-8?B?RkhXL0tHMzFBSlpBbmR6WDFleE1GcHZEWHZTZ1lWeStBR3ZoTmhPdVhCZVFy?=
 =?utf-8?B?SWJocHh1RmF6L3crcXU4K255U2RCMHJKcHNyNnB3MUdQQXFCN3loNThBM3E5?=
 =?utf-8?B?QmNod2tVYnYwSkdkUGxmak5KTnQ5M01oc2hhZTJrOVRDVjZLZU83UUtsMVFm?=
 =?utf-8?B?MGJlck40WDJQVUdLU0t3eTNlQ3VjQVpzbXIyamM1K0NPa0JBdlVMWEIvaU5G?=
 =?utf-8?B?SEQzcUZVODBYYWVSTStpWTVIUjl2ckF2MFRhYWgwNnh0d2I0WUZ1NldIaURM?=
 =?utf-8?B?S2VlOGd5dXo5WE5VWTdDZ1UvYmtwT3pYWHM1c2d6Uys2cmdGQWxIVTZnWkpI?=
 =?utf-8?B?R3hDQ2JFMzB6TnNaNUFvZWpyTjJmbFBBVTFhdU1iZHdDQ01EcXdxd3hJem43?=
 =?utf-8?B?OVY4K3F5VEgvMXY3NW5vVk1KaFBOQ0syeVNsMkhNaFhHL2FzeUx4RW1GV2g2?=
 =?utf-8?B?OXVOVGhRcGNHdktPa3c5QVJockVnWUtVczJqRUxjcDV2VnQ0QXlFWTVkRlpx?=
 =?utf-8?B?UHprUWRaekRLaXNLTWNCaEw0YTI4eXVFcXU0b1VOeGo5bTkwRG03TjBZUFA1?=
 =?utf-8?B?SzdJdmR1ZEllR0ZpeERucE9PWU5haSthdU5od0p6MW5mT21aY3FLNC9lRmp3?=
 =?utf-8?B?MkZWM0xqSVBRcjc1SnlKdlE3Y0Ywc1h3RTNhcFUvVkkxRGcxZE9xcXpsNmQ2?=
 =?utf-8?B?dUpDZEVZME1tWVdLZ3BsbEM1a2dESGg4Tkc2Q2IvTUhIeElBSGQxdW96cVRQ?=
 =?utf-8?B?aDBqK3FYYzBZWFd5V2dsTkFCTmpuVHFod3drZFlKUGp3OFBMeXdUNlhDZnFI?=
 =?utf-8?B?eHNUVWlhVXlCNkhSSnY4QWVJTnBmaTFoSnZwYXZWUHJCbGY5ZzlKU2ErczY5?=
 =?utf-8?B?OFdUWlAyVzljTWFtQkF3dG5Gd0dwN0tPZDB4SE5PSDVYZisvWmdOOU5JdGpo?=
 =?utf-8?B?Y3d6dE1xczdPbi9GR1FkSEtWcXpWMXh4eVVtcTRpU0FqdndMQ0p6ZDc4U000?=
 =?utf-8?B?VXdLUnJDSTZrb3B2NGtMandZQTFCSUlMNUNLaitZWkh0akRIbEpQUDJXK0VP?=
 =?utf-8?B?VUc2U3BjMkdVcVhBbWpKc1VkcWFyamltOThnd3k1dTMxQWtLbzJXNXR2ZHhm?=
 =?utf-8?B?TGxPUmI1UDFacHFuRDZ6L3B5YzdzRURXM0hWMzhxU1FGckE5WUpTRFJET0xN?=
 =?utf-8?B?YmpoaHdVeXpDdkxLdjQ0YUN5RzdRUXpvSnVxdVFET1JwSE9OVk1vZFhtWTJx?=
 =?utf-8?B?VXJKNEtvb2lVUkIvYTh2bmo5RXF4TmhpeDhXSlFGcm1iT0loVjE4UUhyeDhs?=
 =?utf-8?Q?/kEhta52F+WOO2+nUrg7UQKrYNxDRNAp?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?akQrNG9kMGs4cnBZNjlpb0hEWm84ejRlV3pWTjJhazByOXR1WExDeGxodHM4?=
 =?utf-8?B?Y21pWVJqOGhsSkJvRXB5Yyt4d2tycE9KZVJuK21Nb0xIdFJBM1FrQllWTUtM?=
 =?utf-8?B?dTdGSGl2MllBU1dEeGF1eXpURjlVMy96bnh4bUN1elhHdWZNNUUwQXhaWW5t?=
 =?utf-8?B?NnN3YzdrNUhZSU1ETS9qL1ZqUWlXOTBMbk1peWQ3NE1WSDMzM1F0ckwxajdx?=
 =?utf-8?B?UkR6bWRXV0wvQ2c2emJXQmdkc2dqS0V1WTEvcktBc3NSV01iWVhGNHpZOUxz?=
 =?utf-8?B?UXVhVlQ3QzVDZnYweGIyZ3o4VTVYSTZTOTNyQ0F3TW15UlRkbkxnRVN5WXJP?=
 =?utf-8?B?OVVNOTZIZmRxK280YU1XelZzK3M5N1lVK3BGa0htaG9VU0lFZ3ppOUpmYUlW?=
 =?utf-8?B?WDdlaU41a01haHJKTEtGV0RCVUN4L05nNG52L09BQnlxckRSWG1jMGhTaWVh?=
 =?utf-8?B?dEhFNGUwclMxUnUyTWZNQk9ydlNxOXlMN0JEdkZHKytTOEgzNnNXS1d0ejkw?=
 =?utf-8?B?NTE4bDlLUVNWc3h1a3ZIV2t3ZWlHc1JNdWJZSTEvQVZMeUtPRU1SN1k0Mi9z?=
 =?utf-8?B?YTF1TFRjZkRuS2VzQXFRbWpZMDBJazFCQ3F6a3A5N1IrNnJleTV6aEhTV1c3?=
 =?utf-8?B?RzVCSmVXa2ZkU2V5RnQvRkNKNUNPRC9DQ3hieS9TN2xyY3p4SnZZRTBqSUxY?=
 =?utf-8?B?N3VvazdqRFhNUlJvVEFqbkN1VUdvV0lETVFxTnFmZ1gzUzdRN01YeUFtZDJu?=
 =?utf-8?B?S1dkc0pLT2w0bTBHQUtLTkUxUmxWOXoydTNkRjhqd2tnVWhBUmgzc1RBc1Nx?=
 =?utf-8?B?SWFscUZZVFIvdUNLWHdkSG9Sa1dVVTBsM1BvT0VIcDhSRW5COTcxMUdWRWRv?=
 =?utf-8?B?UTRtbFhMV09CUmhxbEZ0aktjUEZlc1FrbUJIbU94dFlNMFBsK05wV0NtWU8z?=
 =?utf-8?B?YXozSFJBRFVCNEhSaUJzZVNrZ2tya0QzcWNKK3V1VWpNUE5MY0xIRnB1RGFW?=
 =?utf-8?B?N3RLZ2RkN0NWWnFGTW4rN044alN4MEIxU1RKbkRzeGd2TllWYjF5V1NnMHU3?=
 =?utf-8?B?ZXZZQTlvZ2dvSVphMHhLejhCQzdzWFhPS0pFWkk4UG5kOEtXVHBId1UvV3BJ?=
 =?utf-8?B?bUlERlFLQ0lMYWJuZUlhd3lnWkFUTGdwVFRTS1RKRVFKbXpid3N3MHljNUJD?=
 =?utf-8?B?Z0FzcnhqZVdCUHpaeGxtYll6d1ZadzNjbGpkTURab0FHUFpKWVJFWEU5Z0M2?=
 =?utf-8?B?eDNlWU1iYXREaUJEUWJ4ekhMb1JwNlBKSXJxMzFOeFo3NXhPK2pFMWJKdFA5?=
 =?utf-8?B?SkFlR1BNclpUbEJhRHRCS2NwSllpdXNXNXZkV01raytVYjYzbHpOS3dwMWZL?=
 =?utf-8?B?OWJwSVE4NjZYY2hzUjd3TnB0bVJWVXVSbnZKSEdEb2lhc1pWWS9SekFIdkJa?=
 =?utf-8?B?Vmhsd0dEcE93aVNRaUh1SmxOUUFseUFqY0JHUUQ5N1A3SUQ0SFFvcFA3d0Fk?=
 =?utf-8?B?bWlLajdaZTNjcnA1bUFHQlpnait1RFJKTWY2WTVFUmlNNzRJcytpZmk4ZTdR?=
 =?utf-8?B?Szk5ZzRpaitTQkFNWWVGMmRZU2dqOG1hVE4rbnpRL2pJb1E0bXk3YkZIZ3VS?=
 =?utf-8?B?ZXVNSFo3aW8yd25MN05GUXRsNTRXa2JHbVhXL09JK1RNLzU0U2tTaGhidUVY?=
 =?utf-8?B?aFR6bStBcDMvZUlobmxWalYwdHJ1NExMWDN4NURPaTlqNlhUMjlXbXVUMXpU?=
 =?utf-8?B?YmpPM0tYdHAwakFBbXJhTFFiQ0IyZW9JVmlKTmErbE50cGlSc1FSblM5SDlx?=
 =?utf-8?B?NHJyWEpkTHE1eERXN05TSDI4KzVaQWVkaFRFVFZmMkp5c3pWejBjb0tSK1BU?=
 =?utf-8?B?MWJZS1hQKyt1ZXk0bmtBR0p3MXZCQzdmTVJjUHB2aldHRkxwWkZtL0ZZc0lZ?=
 =?utf-8?B?dnNhRzg1cVV1TWVmc1JIRlVzQWRRcklhZE1OZjZtL2Ewclo2Q0hWREpESnZi?=
 =?utf-8?B?WE5QTHpUYkg1SFEvRVFoVURzbytZdHlkK3JLd2t0UG5jQ1ZvV3pFcm5QZFNp?=
 =?utf-8?B?YXpORVk3V04ydWlDaDdaMGlvL0hDeXhIdmFTWUFiUEljYk1KRDNUVm5aRWdh?=
 =?utf-8?B?VkhkWUduclprdDVla3dhQk9ERUxmRE1vaGVuNHRzUk12WGFlampYeG1seHpn?=
 =?utf-8?Q?i1HhZyo32BDLijgX4t95i2s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <289AAB7E84C02F47BB86AE185A57C824@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f78a389-f3f4-4582-f89f-08ddd91cf038
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 21:20:46.8474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ny5XP5NzlvJ0BR3Z4xqFOpTklWlMziZBlLUJ8Gv2+7lnBtxHgnR3M9U01cY0gWHPwGch0aqmnCPW1sT74PrfQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ4PPFC308B8970
X-Proofpoint-GUID: PxKPqmQ3BK27LAh332LdO6i8ugvvUS3u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDE0NCBTYWx0ZWRfX85NNKDCe+j89
 jqx0/BRTYApyFLbmyLAczr6+3ukOtx4Zk5ZDuK+5Fhc2OtCFrbPQ+ujoQ2muas1HEnk22OUgxiD
 ygWth6azSFKgbKEr4oq912rFT8uhx9G65FBuCsXzI/x4KTTpFUGqfw9Daflu5nSpDQhOgR1oHON
 b2SzUrLt28FuEJDynLmoXJACBptaOJ8br47biC628/eF5vjtNbs5RB5qaslRBzqVLcAaPsJ1uSZ
 9yrtNfmXMIdDYxdxkvQcIAkwiKE+4g/3eqZRrvF7xZPP6QUKViXmdb8SWIAuP6hicQJwb8x3bez
 C7ACFyoaavpsTesulP1ZvfWBsBJNgdLmJtaxVbNIUEzZGP0oJGOV9S8m3YVVTJsNrrBQCpBTDGY
 D1UcijltNqKIbxUdVvvl07kz6cUyFZR2onbab4614Cm/ZgVy81QOico3K5Qcanv7fP60dSxQ
X-Authority-Analysis: v=2.4 cv=QtNe3Uyd c=1 sm=1 tr=0 ts=689a5eb2 cx=c_pps
 a=XbCLgsAEGm7m6p89S+a4Ww==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=NEAV23lmAAAA:8 a=P-IC7800AAAA:8 a=4u6H09k7AAAA:8
 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=AfZbgqyEUkX2YeBWknkA:9 a=QEXdDO2ut3YA:10
 a=d3PnA9EDa4IxuAV0gXij:22 a=5yerskEF2kbSkDMynNst:22
X-Proofpoint-ORIG-GUID: AZvp3NIz2Wzup2T35qntRcyT49c4TM3S
Subject: RE: [PATCH] ceph: Fix multifs mds auth caps issue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_04,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508110144

T24gV2VkLCAyMDI1LTA4LTA2IGF0IDE0OjIzICswNTMwLCBLb3RyZXNoIEhpcmVtYXRoIFJhdmlz
aGFua2FyIHdyb3RlOg0KPiBPbiBTYXQsIEF1ZyAyLCAyMDI1IGF0IDE64oCKMzEgQU0gVmlhY2hl
c2xhdiBEdWJleWtvIDxTbGF2YS7igIpEdWJleWtvQOKAimlibS7igIpjb20+IHdyb3RlOiA+ID4g
T24gRnJpLCAyMDI1LTA4LTAxIGF0IDIyOuKAijU5ICswNTMwLCBLb3RyZXNoIEhpcmVtYXRoIFJh
dmlzaGFua2FyIHdyb3RlOiA+ID4gPiA+IEhpLCA+ID4gPiA+IDEuIEkgd2lsbCBtb2RpZnkgdGhl
IGNvbW1pdCBtZXNzYWdlDQo+IA0KPiBPbiBTYXQsIEF1ZyAyLCAyMDI1IGF0IDE6MzHigK9BTSBW
aWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5a29AaWJtLmNvbT4gd3JvdGU6DQo+ID4gDQo+
ID4gT24gRnJpLCAyMDI1LTA4LTAxIGF0IDIyOjU5ICswNTMwLCBLb3RyZXNoIEhpcmVtYXRoIFJh
dmlzaGFua2FyIHdyb3RlOg0KPiA+ID4gDQo+ID4gPiBIaSwNCj4gPiA+IA0KPiA+ID4gMS4gSSB3
aWxsIG1vZGlmeSB0aGUgY29tbWl0IG1lc3NhZ2UgdG8gY2xlYXJseSBleHBsYWluIHRoZSBpc3N1
ZSBpbiB0aGUgbmV4dCByZXZpc2lvbi4NCj4gPiA+IDIuIFRoZSBtYXhpbXVtIHBvc3NpYmxlIGxl
bmd0aCBmb3IgdGhlIGZzbmFtZSBpcyBub3QgZGVmaW5lZCBpbiBtZHMgc2lkZS4gSSBkaWRuJ3Qg
ZmluZCBhbnkgcmVzdHJpY3Rpb24gaW1wb3NlZCBvbiB0aGUgbGVuZ3RoLiBTbyB3ZSBuZWVkIHRv
IGxpdmUgd2l0aCBpdC4NCj4gPiANCj4gPiBXZSBoYXZlIHR3byBjb25zdGFudHMgaW4gTGludXgg
a2VybmVsIFsxXToNCj4gPiANCj4gPiAjZGVmaW5lIE5BTUVfTUFYIMKgIMKgIMKgIMKgIDI1NSDC
oCDCoC8qICMgY2hhcnMgaW4gYSBmaWxlIG5hbWUgKi8NCj4gPiAjZGVmaW5lIFBBVEhfTUFYIMKg
IMKgIMKgIMKgNDA5NiDCoCDCoC8qICMgY2hhcnMgaW4gYSBwYXRoIG5hbWUgaW5jbHVkaW5nIG51
bCAqLw0KPiA+IA0KPiA+IEkgZG9uJ3QgdGhpbmsgdGhhdCBmc25hbWUgY2FuIGJlIGJpZ2dlciB0
aGFuIFBBVEhfTUFYLg0KPiANCj4gQXMgSSBoYWQgbWVudGlvbmVkIGVhcmxpZXIsIHRoZSBDZXBo
RlMgc2VydmVyIHNpZGUgY29kZSBpcyBub3QgcmVzdHJpY3RpbmcgdGhlIGZpbGVzeXN0ZW0gbmFt
ZQ0KPiBkdXJpbmcgY3JlYXRpb24uIEkgdmFsaWRhdGVkIHRoZSBjcmVhdGlvbiBvZiBhIGZpbGVz
eXN0ZW0gbmFtZSB3aXRoIGEgbGVuZ3RoIG9mIDUwMDAuDQo+IFBsZWFzZSB0cnkgdGhlIGZvbGxv
d2luZy4NCj4gDQo+IFtrb3RyZXNoQGZlZG9yYSBidWlsZF0kIGFscGhhX3N0cj0kKDwgL2Rldi91
cmFuZG9tIHRyIC1kYyAnYS16QS1aJyB8IGhlYWQgLWMgNTAwMCkNCj4gW2tvdHJlc2hAZmVkb3Jh
IGJ1aWxkXSQgY2VwaCBmcyBuZXcgJGFscGhhX3N0ciBjZXBoZnNfZGF0YSBjZXBoZnNfbWV0YWRh
dGENCj4gW2tvdHJlc2hAZmVkb3JhIGJ1aWxkXSQgYmluL2NlcGggZnMgbHMNCj4gDQo+IFNvIHJl
c3RyaWN0aW5nIHRoZSBmc25hbWUgbGVuZ3RoIGluIHRoZSBrY2xpZW50IHdvdWxkIGxpa2VseSBj
YXVzZSBpc3N1ZXMuIElmIHdlIG5lZWQgdG8gZW5mb3JjZSB0aGUgbGltaXRhdGlvbiwgSSB0aGlu
aywgaXQgc2hvdWxkIGJlIGRvbmUgYXQgc2VydmVyIHNpZGUgZmlyc3QgYW5kIGl04oCZcyBhIHNl
cGFyYXRlIGVmZm9ydC4NCj4gDQoNCkkgYW0gbm90IHN1cmUgdGhhdCBMaW51eCBrZXJuZWwgaXMg
Y2FwYWJsZSB0byBkaWdlc3QgYW55IG5hbWUgYmlnZ2VyIHRoYW4NCk5BTUVfTUFYLiBBcmUgeW91
IHN1cmUgdGhhdCB3ZSBjYW4gcGFzcyB4ZnN0ZXN0cyB3aXRoIGZpbGVzeXN0ZW0gbmFtZSBiaWdn
ZXINCnRoYW4gTkFNRV9NQVg/IEFub3RoZXIgcG9pbnQgaGVyZSB0aGF0IHdlIGNhbiBwdXQgYnVm
ZmVyIHdpdGggbmFtZSBpbmxpbmUNCmludG8gc3RydWN0IGNlcGhfbWRzbWFwIGlmIHRoZSBuYW1l
IGNhbm5vdCBiZSBiaWdnZXIgdGhhbiBOQU1FX01BWCwgZm9yIGV4YW1wbGUuDQpJbiB0aGlzIGNh
c2Ugd2UgZG9uJ3QgbmVlZCB0byBhbGxvY2F0ZSBmc19uYW1lIG1lbW9yeSBmb3IgZXZlcnkNCmNl
cGhfbWRzbWFwX2RlY29kZSgpIGNhbGwuDQoNCj4gPiANCj4gPiA+IDMuIEkgd2lsbCBmaXggdXAg
ZG91dGMgaW4gdGhlIG5leHQgcmV2aXNpb24uDQo+ID4gPiA0LiBUaGUgZnNfbmFtZSBpcyBwYXJ0
IG9mIHRoZSBtZHNtYXAgaW4gdGhlIHNlcnZlciBzaWRlIFsxXS4gVGhlIGtlcm5lbCBjbGllbnQg
ZGVjb2RlcyBvbmx5IG5lY2Vzc2FyeSBmaWVsZHMgZnJvbSB0aGUgbWRzbWFwIHNlbnQgYnkgdGhl
IHNlcnZlci4gVW50aWwgbm93LCB0aGUgZnNfbmFtZQ0KPiA+ID4gwqAgwqAgd2FzIG5vdCBiZWlu
ZyBkZWNvZGVkLCBhcyBwYXJ0IG9mIHRoaXMgZml4LCBpdCdzIHJlcXVpcmVkIGFuZCBiZWluZyBk
ZWNvZGVkLg0KPiA+ID4gDQo+ID4gDQo+ID4gQ29ycmVjdCBtZSBpZiBJIGFtIHdyb25nLiBJIGNh
biBjcmVhdGUgYSBDZXBoIGNsdXN0ZXIgd2l0aCBzZXZlcmFsIE1EUyBzZXJ2ZXJzLg0KPiA+IElu
IHRoaXMgY2x1c3RlciwgSSBjYW4gY3JlYXRlIG11bHRpcGxlIGZpbGUgc3lzdGVtIHZvbHVtZXMu
IEFuZCBldmVyeSBmaWxlDQo+ID4gc3lzdGVtIHZvbHVtZSB3aWxsIGhhdmUgc29tZSBuYW1lIChm
c19uYW1lKS4gU28sIGlmIHdlIHN0b3JlIGZzX25hbWUgaW50bw0KPiA+IG1kc21hcCwgdGhlbiB3
aGljaCBuYW1lIGRvIHdlIGltcGx5IGhlcmU/IERvIHdlIGltcGx5IGNsdXN0ZXIgbmFtZSBhcyBm
c19uYW1lIG9yDQo+ID4gbmFtZSBvZiBwYXJ0aWN1bGFyIGZpbGUgc3lzdGVtIHZvbHVtZT8NCj4g
DQo+IEluIENlcGhGUywgd2UgbWFpbmx5IGRlYWwgd2l0aCB0d28gbWFwcyBNRFNNYXBbMV0gYW5k
IEZTTWFwWzJdLiBUaGUgTURTTWFwIHJlcHJlc2VudHMNCj4gdGhlIHN0YXRlIGZvciBhIHBhcnRp
Y3VsYXIgc2luZ2xlIGZpbGVzeXN0ZW0uIFNvIHRoZSDigJhmc19uYW1l4oCZIGluIHRoZSBNRFNN
YXAgcG9pbnRzIHRvIGEgZmlsZSBzeXN0ZW0NCj4gbmFtZSB0aGF0IHRoZSBNRFNNYXAgcmVwcmVz
ZW50cy4gRWFjaCBmaWxlc3lzdGVtIHdpbGwgaGF2ZSBhIGRpc3RpbmN0IE1EU01hcC4gVGhlIEZT
TWFwIHdhcw0KPiBpbnRyb2R1Y2VkIHRvIHN1cHBvcnQgbXVsdGlwbGUgZmlsZXN5c3RlbXMgaW4g
dGhlIGNsdXN0ZXIuIFRoZSBGU01hcCBob2xkcyBhbGwgdGhlIGZpbGVzeXN0ZW1zIGluIHRoZQ0K
PiBjbHVzdGVyIHVzaW5nIHRoZSBNRFNNYXAgb2YgZWFjaCBmaWxlIHN5c3RlbS4gVGhlIGNsaWVu
dHMgc3Vic2NyaWJlIHRvIHRoZXNlIG1hcHMuIFNvIHdoZW4ga2NsaWVudA0KPiBpcyByZWNlaXZp
bmcgYSBtZHNtYXAsIGl04oCZcyBjb3JyZXNwb25kaW5nIHRvIHRoZSBmaWxlc3lzdGVtIGl04oCZ
cyBkZWFsaW5nIHdpdGguDQo+IA0KDQpTbywgaXQncyBzb3VuZHMgdG8gbWUgdGhhdCBNRFMga2Vl
cHMgbXVsdGlwbGUgTURTTWFwcyBmb3IgbXVsdGlwbGUgZmlsZSBzeXN0ZW1zLg0KQW5kIGtlcm5l
bCBzaWRlIHJlY2VpdmVzIG9ubHkgTURTTWFwIGZvciBvcGVyYXRpb25zLiBUaGUgRlNNYXAgaXMg
a2VwdCBvbiBNRFMNCnNpZGUgYW5kIGtlcm5lbCBuZXZlciByZWNlaXZlcyBpdC4gQW0gSSByaWdo
dCBoZXJlPw0KDQpUaGFua3MsDQpTbGF2YS4NCg0KPiBbMV0gaHR0cHM6Ly9naXRodWIuY29tL2Nl
cGgvY2VwaC9ibG9iL21haW4vc3JjL21kcy9NRFNNYXAuaA0KPiBbMl0gaHR0cHM6Ly9naXRodWIu
Y29tL2NlcGgvY2VwaC9ibG9iL21haW4vc3JjL21kcy9GU01hcC5oIA0KPiANCj4gVGhhbmtzLA0K
PiBLb3RyZXNoIEggUg0KPiANCj4gPiANCj4gPiBUaGFua3MsDQo+ID4gU2xhdmEuDQo+ID4gDQo+
ID4gPiDCoA0KPiA+ID4gDQo+ID4gDQo+ID4gWzFdDQo+ID4gaHR0cHM6Ly9lbGl4aXIuYm9vdGxp
bi5jb20vbGludXgvdjYuMTYvc291cmNlL2luY2x1ZGUvdWFwaS9saW51eC9saW1pdHMuaCNMMTIN
Cj4gPiANCj4gPiA+IFsxXSBodHRwczovL2dpdGh1Yi5jb20vY2VwaC9jZXBoL2Jsb2IvbWFpbi9z
cmMvbWRzL01EU01hcC5oI0w1OTYNCj4gPiA+IA0KPiA+ID4gT24gVHVlLCBKdWwgMjksIDIwMjUg
YXQgMTE6NTfigK9QTSBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5a29AaWJtLmNvbT4g
d3JvdGU6DQo+ID4gPiA+IE9uIFR1ZSwgMjAyNS0wNy0yOSBhdCAyMjozMiArMDUzMCwga2hpcmVt
YXRAcmVkaGF0LmNvbSB3cm90ZToNCj4gPiA+ID4gPiBGcm9tOiBLb3RyZXNoIEhSIDxraGlyZW1h
dEByZWRoYXQuY29tPg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFRoZSBtZHMgYXV0aCBjYXBzIGNo
ZWNrIHNob3VsZCBhbHNvIHZhbGlkYXRlIHRoZQ0KPiA+ID4gPiA+IGZzbmFtZSBhbG9uZyB3aXRo
IHRoZSBhc3NvY2lhdGVkIGNhcHMuIE5vdCBkb2luZw0KPiA+ID4gPiA+IHNvIHdvdWxkIHJlc3Vs
dCBpbiBhcHBseWluZyB0aGUgbWRzIGF1dGggY2FwcyBvZg0KPiA+ID4gPiA+IG9uZSBmcyBvbiB0
byB0aGUgb3RoZXIgZnMgaW4gYSBtdWx0aWZzIGNlcGggY2x1c3Rlci4NCj4gPiA+ID4gPiBUaGUg
cGF0Y2ggZml4ZXMgdGhlIHNhbWUuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gU3RlcHMgdG8gUmVw
cm9kdWNlIChvbiB2c3RhcnQgY2x1c3Rlcik6DQo+ID4gPiA+ID4gMS4gQ3JlYXRlIHR3byBmaWxl
IHN5c3RlbXMgaW4gYSBjbHVzdGVyLCBzYXkgJ2EnIGFuZCAnYicNCj4gPiA+ID4gPiAyLiBjZXBo
IGZzIGF1dGhvcml6ZSBhIGNsaWVudC51c3IgLyByDQo+ID4gPiA+ID4gMy4gY2VwaCBmcyBhdXRo
b3JpemUgYiBjbGllbnQudXNyIC8gcncNCj4gPiA+ID4gPiA0LiBjZXBoIGF1dGggZ2V0IGNsaWVu
dC51c3IgPj4gLi9rZXlyaW5nDQo+ID4gPiA+ID4gNS4gc3VkbyBiaW4vbW91bnQuY2VwaCB1c3JA
LmE9LyAva21udF9hX3Vzci8NCj4gPiA+ID4gPiA2LiB0b3VjaCAva21udF9hX3Vzci9maWxlMSAo
U0hPVUxEIE5PVCBCRSBBTExPV0VEKQ0KPiA+ID4gPiA+IDcuIHN1ZG8gYmluL21vdW50LmNlcGgg
YWRtaW5ALmE9LyAva21udF9hX2FkbWluDQo+ID4gPiA+ID4gOC4gZWNobyAiZGF0YSIgPiAva21u
dF9hX2FkbWluL2FkbWluX2ZpbGUxDQo+ID4gPiA+ID4gOS4gcm0gLWYgL2ttbnRfYV91c3IvYWRt
aW5fZmlsZTEgKFNIT1VMRCBOT1QgQkUgQUxMT1dFRCkNCj4gPiA+ID4gPiANCj4gPiA+ID4gDQo+
ID4gPiA+IEkgdGhpbmsgd2UgYXJlIG1pc3NpbmcgdG8gZXhwbGFpbiBoZXJlIHdoaWNoIHByb2Js
ZW0gb3INCj4gPiA+ID4gc3ltcHRvbXMgd2lsbCBzZWUgdGhlIHVzZXIgdGhhdCBoYXMgdGhpcyBp
c3N1ZS4gSSBhc3N1bWUgdGhhdA0KPiA+ID4gPiB0aGlzIHdpbGwgYmUgc2VlbiBhcyB0aGUgaXNz
dWUgcmVwcm9kdWN0aW9uOg0KPiA+ID4gPiANCj4gPiA+ID4gV2l0aCBjbGllbnRfMyB3aGljaCBo
YXMgb25seSAxIGZpbGVzeXN0ZW0gaW4gY2FwcyBpcyB3b3JraW5nIGFzIGV4cGVjdGVkDQo+ID4g
PiA+IG1rZGlyIC9tbnQvY2xpZW50XzMvdGVzdF8zDQo+ID4gPiA+IG1rZGlyOiBjYW5ub3QgY3Jl
YXRlIGRpcmVjdG9yeSDigJgvbW50L2NsaWVudF8zL3Rlc3RfM+KAmTogUGVybWlzc2lvbiBkZW5p
ZWQNCj4gPiA+ID4gDQo+ID4gPiA+IEFtIEkgY29ycmVjdCBoZXJlPw0KPiA+ID4gPiANCj4gPiA+
ID4gPiBVUkw6IGh0dHBzOi8vdHJhY2tlci5jZXBoLmNvbS9pc3N1ZXMvNzIxNjcNCj4gPiA+ID4g
PiBTaWduZWQtb2ZmLWJ5OiBLb3RyZXNoIEhSIDxraGlyZW1hdEByZWRoYXQuY29tPg0KPiA+ID4g
PiA+IC0tLQ0KPiA+ID4gPiA+IMKgIGZzL2NlcGgvbWRzX2NsaWVudC5jIHwgMTAgKysrKysrKysr
Kw0KPiA+ID4gPiA+IMKgIGZzL2NlcGgvbWRzbWFwLmMgwqAgwqAgfCAxMSArKysrKysrKysrLQ0K
PiA+ID4gPiA+IMKgIGZzL2NlcGgvbWRzbWFwLmggwqAgwqAgfCDCoDEgKw0KPiA+ID4gPiA+IMKg
IDMgZmlsZXMgY2hhbmdlZCwgMjEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4g
PiA+IA0KPiA+ID4gPiA+IGRpZmYgLS1naXQgYS9mcy9jZXBoL21kc19jbGllbnQuYyBiL2ZzL2Nl
cGgvbWRzX2NsaWVudC5jDQo+ID4gPiA+ID4gaW5kZXggOWVlZDZkNzNhNTA4Li5iYTkxZjMzNjBm
ZjYgMTAwNjQ0DQo+ID4gPiA+ID4gLS0tIGEvZnMvY2VwaC9tZHNfY2xpZW50LmMNCj4gPiA+ID4g
PiArKysgYi9mcy9jZXBoL21kc19jbGllbnQuYw0KPiA+ID4gPiA+IEBAIC01NjQwLDExICs1NjQw
LDIxIEBAIHN0YXRpYyBpbnQgY2VwaF9tZHNfYXV0aF9tYXRjaChzdHJ1Y3QgY2VwaF9tZHNfY2xp
ZW50ICptZHNjLA0KPiA+ID4gPiA+IMKgIMKgIMKgIMKgdTMyIGNhbGxlcl91aWQgPSBmcm9tX2t1
aWQoJmluaXRfdXNlcl9ucywgY3JlZC0+ZnN1aWQpOw0KPiA+ID4gPiA+IMKgIMKgIMKgIMKgdTMy
IGNhbGxlcl9naWQgPSBmcm9tX2tnaWQoJmluaXRfdXNlcl9ucywgY3JlZC0+ZnNnaWQpOw0KPiA+
ID4gPiA+IMKgIMKgIMKgIMKgc3RydWN0IGNlcGhfY2xpZW50ICpjbCA9IG1kc2MtPmZzYy0+Y2xp
ZW50Ow0KPiA+ID4gPiA+ICsgwqAgwqAgY29uc3QgY2hhciAqZnNfbmFtZSA9IG1kc2MtPm1kc21h
cC0+ZnNfbmFtZTsNCj4gPiA+ID4gPiDCoCDCoCDCoCDCoGNvbnN0IGNoYXIgKnNwYXRoID0gbWRz
Yy0+ZnNjLT5tb3VudF9vcHRpb25zLT5zZXJ2ZXJfcGF0aDsNCj4gPiA+ID4gPiDCoCDCoCDCoCDC
oGJvb2wgZ2lkX21hdGNoZWQgPSBmYWxzZTsNCj4gPiA+ID4gPiDCoCDCoCDCoCDCoHUzMiBnaWQs
IHRsZW4sIGxlbjsNCj4gPiA+ID4gPiDCoCDCoCDCoCDCoGludCBpLCBqOw0KPiA+ID4gPiA+IMKg
DQo+ID4gPiA+ID4gKyDCoCDCoCBpZiAoYXV0aC0+bWF0Y2guZnNfbmFtZSAmJiBzdHJjbXAoYXV0
aC0+bWF0Y2guZnNfbmFtZSwgZnNfbmFtZSkpIHsNCj4gPiA+ID4gDQo+ID4gPiA+IFNob3VsZCB3
ZSBjb25zaWRlciB0byB1c2Ugc3RybmNtcCgpIGhlcmU/DQo+ID4gPiA+IFdlIHNob3VsZCBoYXZl
IHRoZSBsaW1pdGF0aW9uIG9mIG1heGltdW0gcG9zc2libGUgbmFtZSBsZW5ndGguDQo+ID4gPiA+
IA0KPiA+ID4gPiA+ICsgwqAgwqAgwqAgwqAgwqAgwqAgZG91dGMoY2wsICJmc25hbWUgY2hlY2sg
ZmFpbGVkIGZzX25hbWU9JXMgwqBtYXRjaC5mc19uYW1lPSVzXG4iLA0KPiA+ID4gPiA+ICsgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZnNfbmFtZSwgYXV0aC0+bWF0Y2guZnNfbmFtZSk7DQo+
ID4gPiA+ID4gKyDCoCDCoCDCoCDCoCDCoCDCoCByZXR1cm4gMDsNCj4gPiA+ID4gPiArIMKgIMKg
IH0gZWxzZSB7DQo+ID4gPiA+ID4gKyDCoCDCoCDCoCDCoCDCoCDCoCBkb3V0YyhjbCwgImZzbmFt
ZSBjaGVjayBwYXNzZWQgZnNfbmFtZT0lcyDCoG1hdGNoLmZzX25hbWU9JXNcbiIsDQo+ID4gPiA+
ID4gKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBmc19uYW1lLCBhdXRoLT5tYXRjaC5mc19u
YW1lKTsNCj4gPiA+ID4gDQo+ID4gPiA+IEkgYXNzdW1lIHRoYXQgd2UgY291bGQgY2FsbCB0aGUg
ZG91dGMgd2l0aCBhdXRoLT5tYXRjaC5mc19uYW1lID09IE5VTEwuIFNvLCBJIGFtDQo+ID4gPiA+
IGV4cGVjdGluZyB0byBoYXZlIGEgY3Jhc2ggaGVyZS4NCj4gPiA+ID4gDQo+ID4gPiA+ID4gKyDC
oCDCoCB9DQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+IMKgIMKgIMKgIMKgZG91dGMoY2wsICJtYXRj
aC51aWQgJWxsZFxuIiwgYXV0aC0+bWF0Y2gudWlkKTsNCj4gPiA+ID4gPiDCoCDCoCDCoCDCoGlm
IChhdXRoLT5tYXRjaC51aWQgIT0gTURTX0FVVEhfVUlEX0FOWSkgew0KPiA+ID4gPiA+IMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgaWYgKGF1dGgtPm1hdGNoLnVpZCAhPSBjYWxsZXJfdWlkKQ0KPiA+
ID4gPiA+IGRpZmYgLS1naXQgYS9mcy9jZXBoL21kc21hcC5jIGIvZnMvY2VwaC9tZHNtYXAuYw0K
PiA+ID4gPiA+IGluZGV4IDgxMDlhYmE2NmUwMi4uZjE0MzFiYTBiMzNlIDEwMDY0NA0KPiA+ID4g
PiA+IC0tLSBhL2ZzL2NlcGgvbWRzbWFwLmMNCj4gPiA+ID4gPiArKysgYi9mcy9jZXBoL21kc21h
cC5jDQo+ID4gPiA+ID4gQEAgLTM1Niw3ICszNTYsMTUgQEAgc3RydWN0IGNlcGhfbWRzbWFwICpj
ZXBoX21kc21hcF9kZWNvZGUoc3RydWN0IGNlcGhfbWRzX2NsaWVudCAqbWRzYywgdm9pZCAqKnAs
DQo+ID4gPiA+ID4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBlbmFibGVkICovDQo+ID4gPiA+
ID4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjZXBoX2RlY29kZV84X3NhZmUocCwgZW5kLCBtLT5t
X2VuYWJsZWQsIGJhZF9leHQpOw0KPiA+ID4gPiA+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLyog
ZnNfbmFtZSAqLw0KPiA+ID4gPiA+IC0gwqAgwqAgwqAgwqAgwqAgwqAgY2VwaF9kZWNvZGVfc2tp
cF9zdHJpbmcocCwgZW5kLCBiYWRfZXh0KTsNCj4gPiA+ID4gPiArIMKgIMKgIMKgIMKgIMKgIMKg
IG0tPmZzX25hbWUgPSBjZXBoX2V4dHJhY3RfZW5jb2RlZF9zdHJpbmcocCwgZW5kLCBOVUxMLCBH
RlBfTk9GUyk7DQo+ID4gPiA+ID4gKyDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoSVNfRVJSKG0tPmZz
X25hbWUpKSB7DQo+ID4gPiA+ID4gKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBlcnIg
PSBQVFJfRVJSKG0tPmZzX25hbWUpOw0KPiA+ID4gPiA+ICsgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgbS0+ZnNfbmFtZSA9IE5VTEw7DQo+ID4gPiA+ID4gKyDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBpZiAoZXJyID09IC1FTk9NRU0pDQo+ID4gPiA+ID4gKyDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBnb3RvIG91dF9lcnI7DQo+ID4gPiA+ID4g
KyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBlbHNlDQo+ID4gPiA+ID4gKyDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBnb3RvIGJhZDsNCj4gPiA+ID4gPiAr
IMKgIMKgIMKgIMKgIMKgIMKgIH0NCj4gPiA+ID4gPiDCoCDCoCDCoCDCoH0NCj4gPiA+ID4gPiDC
oCDCoCDCoCDCoC8qIGRhbWFnZWQgKi8NCj4gPiA+ID4gPiDCoCDCoCDCoCDCoGlmIChtZHNtYXBf
ZXYgPj0gOSkgew0KPiA+ID4gPiA+IEBAIC00MTgsNiArNDI2LDcgQEAgdm9pZCBjZXBoX21kc21h
cF9kZXN0cm95KHN0cnVjdCBjZXBoX21kc21hcCAqbSkNCj4gPiA+ID4gPiDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoGtmcmVlKG0tPm1faW5mbyk7DQo+ID4gPiA+ID4gwqAgwqAgwqAgwqB9DQo+ID4g
PiA+ID4gwqAgwqAgwqAgwqBrZnJlZShtLT5tX2RhdGFfcGdfcG9vbHMpOw0KPiA+ID4gPiA+ICsg
wqAgwqAga2ZyZWUobS0+ZnNfbmFtZSk7DQo+ID4gPiA+ID4gwqAgwqAgwqAgwqBrZnJlZShtKTsN
Cj4gPiA+ID4gPiDCoCB9DQo+ID4gPiA+ID4gwqANCj4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvZnMv
Y2VwaC9tZHNtYXAuaCBiL2ZzL2NlcGgvbWRzbWFwLmgNCj4gPiA+ID4gPiBpbmRleCAxZjIxNzFk
ZDAxYmYuLmFjYjBhMmEzNjI3YSAxMDA2NDQNCj4gPiA+ID4gPiAtLS0gYS9mcy9jZXBoL21kc21h
cC5oDQo+ID4gPiA+ID4gKysrIGIvZnMvY2VwaC9tZHNtYXAuaA0KPiA+ID4gPiA+IEBAIC00NSw2
ICs0NSw3IEBAIHN0cnVjdCBjZXBoX21kc21hcCB7DQo+ID4gPiA+ID4gwqAgwqAgwqAgwqBib29s
IG1fZW5hYmxlZDsNCj4gPiA+ID4gPiDCoCDCoCDCoCDCoGJvb2wgbV9kYW1hZ2VkOw0KPiA+ID4g
PiA+IMKgIMKgIMKgIMKgaW50IG1fbnVtX2xhZ2d5Ow0KPiA+ID4gPiA+ICsgwqAgwqAgY2hhciAq
ZnNfbmFtZTsNCj4gPiA+ID4gDQo+ID4gPiA+IFRoZSBjZXBoX21kc21hcCBzdHJ1Y3R1cmUgZGVz
Y3JpYmVzIHNlcnZlcnMgaW4gdGhlIG1kcyBjbHVzdGVyIFsxXS4NCj4gPiA+ID4gU2VtYW50aWNh
bGx5LCBJIGRvbid0IHNlZSBhbnkgcmVsYXRpb24gb2YgZnNfbmFtZSB3aXRoIHRoaXMgc3RydWN0
dXJlLg0KPiA+ID4gPiBBcyBhIHJlc3VsdCwgSSBkb24ndCBzZWUgdGhlIHBvaW50IHRvIGtlZXAg
dGhpcyBwb2ludGVyIGluIHRoaXMgc3RydWN0dXJlLg0KPiA+ID4gPiBXaHkgdGhlIGZzX25hbWUg
aGFzIGJlZW4gcGxhY2VkIGluIHRoaXMgc3RydWN0dXJlPw0KPiA+ID4gPiANCj4gPiA+ID4gVGhh
bmtzLA0KPiA+ID4gPiBTbGF2YS4NCj4gPiA+ID4gDQo+ID4gPiA+ID4gwqAgfTsNCj4gPiA+ID4g
PiDCoA0KPiA+ID4gPiA+IMKgIHN0YXRpYyBpbmxpbmUgc3RydWN0IGNlcGhfZW50aXR5X2FkZHIg
Kg0KPiA+ID4gPiANCj4gPiA+ID4gWzFdIGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4
L3Y2LjE2L3NvdXJjZS9mcy9jZXBoL21kc21hcC5oI0wxMQ0KPiA+ID4gPiANCg==

