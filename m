Return-Path: <ceph-devel+bounces-4255-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EEDE6CF5D48
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 23:29:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 50352300C36A
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 22:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E75573126C3;
	Mon,  5 Jan 2026 22:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SrjOSBpe"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7E9275AE4;
	Mon,  5 Jan 2026 22:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767652149; cv=fail; b=PdMFVSsnG8l8Ov/VgVMRnLY8k+BUXIX7LcBuqhxrPECR2TGybh9dHOpR1y9wI5kdY7Bz2b2+h9LhEVGmNAJotQAZSsekGLzVNzy5neiPdGvuT8G2mXdsdBYeNHjguiehlkN8kh2pn+S0WwyUccy/oO895LYIMMCFRY3bZ368v9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767652149; c=relaxed/simple;
	bh=hqQwjCS7NZFOUqr6NG20YZKH72aLRgJTY8sSgKvEijs=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=RVLC+i49CZu+EzQSIH7K+Hrp8pjqs+AgpAJzsJ/t9zUtG/AR/i7HGM9R37oKeM2Vt80If7SZkfUsfpRCqo1XiDxapnE3mW7kaShuPZoKh5DiXfXOMDVn6Di4dF2rRgpyr/Xili43+1qjXUx1gWo15GT4lyU+tixrHIsKc9f1bB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SrjOSBpe; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 605EVc2W012347;
	Mon, 5 Jan 2026 22:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=hqQwjCS7NZFOUqr6NG20YZKH72aLRgJTY8sSgKvEijs=; b=SrjOSBpe
	scJ7PtqpWwOx6gSw+nVSid4FZ6Kjn2PmDENG+h1s2k60rggshOGg5IB5qsG48ki3
	vz/jkrrKVYhcQOVlGUUB4er/txDuWSyhHrbbGamDhPl06lCyxe5x4aU4cHfyq4j7
	RO0rt+tq1YIM2arEtW14BwEXjzhoOSMNatYDoRtq+xz7m8gweb3wPBChqDe071cT
	i8ztfM2B7R4IclUQI3IRw3jvhAD12isUJ6O2/Jpa5T4PYPlRaTXcgkAnweCY6Sfl
	qQiWSxXXCz7yVn/lUWZP+kKw+dSMRghev95EyfHvNj16rZ5Ff6Zw9YpTpaKYfaQp
	X/IpxCzOqU8byw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betsq1f2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 22:29:03 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 605MO30g006281;
	Mon, 5 Jan 2026 22:29:03 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011040.outbound.protection.outlook.com [52.101.62.40])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betsq1f2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 22:29:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qc22/PbFXqG7ALS89U2K+ZMGcRR11+QYKP2I/ZSS9gm3hL4SwS8itzBTXRgxK3nkBcF6swF2BZ0FmQaL/B2moimBlrXon2IU0JP5Y1rdPsHtkSp8SCp2DTBWpMJS+TIYX3gNe40nsrD71MAM32kUpd9JFPUWwUIIH/Z403yDV7g8a96ToqI2gFuwvnAtK2n68AYGCckjySklmI6+pEFy+Ivul71gahFuSypNZRxndhL2KT6g7NEzDpyEQ+3+ZInANwlWtDoAzIZ437UygqvEOEYVP5ANIPMS5LXRalXumA1r1x/r4ToKaQBoUHGPWYCUhIal2Sp3aGGIj7U+XpNoeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqQwjCS7NZFOUqr6NG20YZKH72aLRgJTY8sSgKvEijs=;
 b=xyEdxbtMFPy3OIhFhL/DUBqkfRSHSeawqHeex/uKletXQIcOVZUEBRQ4fJhIoQx3xzIxPD8mTOhoa5cJnjMrZgtGB/hisI8dshqNKeMt//wRq0VnOw9V6c9WB/ilFbFgotX3+nvmCHYW5WaTCkbK+UPN0Xos4iRl0BEqiFpDYVYgSzGsHTp4hLMWnZF1njBnq5SlkiWo7SsGoNhaQSty6pZzuFXDjXgQUO+UYQ2aBK/qtfX8UnBAeJLPqMOdNLPCzs6ofY7zgh/8ZBAARy9GsM0s9yO2mM57Lq0x+Quvw9yU1i5A8CnThWnKTBVF9PtFhLry4Jm+ZLhW7XWYodOHPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA1PR15MB5094.namprd15.prod.outlook.com (2603:10b6:806:1dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 22:29:00 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 22:29:00 +0000
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
Thread-Topic: [EXTERNAL] [PATCH 4/5] ceph: Assert writeback loop invariants
Thread-Index: AQHcegDwONQywwyhqk6lpy5eHRv46LVEMVkA
Date: Mon, 5 Jan 2026 22:28:59 +0000
Message-ID: <5fba25f7b85276411c091cb7206b2dc057d89c68.camel@ibm.com>
References: <20251231024316.4643-1-CFSworks@gmail.com>
	 <20251231024316.4643-5-CFSworks@gmail.com>
In-Reply-To: <20251231024316.4643-5-CFSworks@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA1PR15MB5094:EE_
x-ms-office365-filtering-correlation-id: b0d7167e-4cf1-4514-4b19-08de4ca9d2bd
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?NXh4QUxsdGFIZXB2U2VreTUxSGM4M1J6NWIrcFhOYmhwS1ZDZUFWcGdHNHpK?=
 =?utf-8?B?dCtoZVdUa2x5c0ZLQ3AwbzRHYWFtWWh6K1JtSmwrbkNmMXBVTkppN0E2cmhB?=
 =?utf-8?B?OUovRkw5RGI5L1VseTFrRVFFVDRReDUzSUpYVmxaQjF5Z243RE9Cd002Vk5l?=
 =?utf-8?B?V3BPa2dWZ0J6OWJBNXYxSmJwcXBqRDJmMEIrdzArTWdYbDVUWC80SlFVR0k2?=
 =?utf-8?B?cUhibHRLYTdkSUJxOXJzOXo4by9hMFgzdnoxbW5FZDlNdm1PQlR2bElmWmdY?=
 =?utf-8?B?dW52a2oxNG1DNkM1NTdHSjNUakpZT1JHaXlNQ1g5emlzV3VwRGJJN2VOeUc0?=
 =?utf-8?B?QWlZV3hZeFdtVzhpaVBiZ1dNZnAwVGM4UkZ4MHpIY0wwckxJUjJ5QUZoVHhW?=
 =?utf-8?B?ZFNxRjg3ZFBOTmEvWjhHNEVMUTZNdTVqZVNtZ0pjOXVJS2RJTGZac0RENTg1?=
 =?utf-8?B?d0FuVGhHVlc3Q0JVRUQxT0Z6OEQ3bnM2UGxZZkVMMU1oYTFDcVhvVnBWTEhC?=
 =?utf-8?B?aVhEdXhuWVprMTJrOTRDNmpQVXd0STFLT1IrQjBvN1FkZG11M09OVkt5YXY3?=
 =?utf-8?B?SjdSTE9hbGNSdWZOd05aekoyaWdTaDFxeXhSaVpWY0tsS0VLSy8zNVVWZVc5?=
 =?utf-8?B?TVg4R05HT1pUQU9yc05RTEw1WHg4TjBqcUZPNWtLaVZibXdEU2ZHeVViYXFI?=
 =?utf-8?B?aXFUbzhab2lqTnRaeWl6Q2VtWmJOVHlHNjFVblNqb3dVZVJ4YXlOcWJMRTRo?=
 =?utf-8?B?Q25EYkZoV2RjQWI3WGNoVy9KL2xBS1ZPZkkzbUc3Zm5QQ0hCVE1UNW9xZ1J5?=
 =?utf-8?B?MVVsYUNrQTZxNzdtWVRXelE1NHA4dUhCaVlsQTZiYk1RRTBNMUJQOGhocDh1?=
 =?utf-8?B?TDB2ZnlLbHdBNC9wU3NUWXhyWE9KcFhERm9PdEk4UGpFeDg5ZUJLakk5cW8w?=
 =?utf-8?B?SEpoa1orZFdBcjVyVStkUUk0Y3I2cFBkcStqYnpFZlpvWE04d0ZmS2dKY09w?=
 =?utf-8?B?L0hpQVJxZDh2MXdadnF0L1NyZmw2RkpkWlA5MXJqZzg0MC9DTTh5aUtQWlhy?=
 =?utf-8?B?UFVNMWlDbWFUdXlaOXhhT0hJU1lNZXRBcSs2QThENUpvV2xQbDR0Znl4ajd5?=
 =?utf-8?B?eXFpZHVsdE9lY0ZyMGdON0Nxb05QUWgwV0hiSUxyL0xCS2Zmc1B0N1A0eVU4?=
 =?utf-8?B?WFBFUVo3K01kZ3VxVzJjL3MrN3g3cGs3SUwwelhwNVVqeDBKOEx6RXFrc1Jt?=
 =?utf-8?B?REhpZkphUXVnVmFmM3pPZTVpc3VGd2daZ2FyOE9GRVlzcDN6RjlOR2dTUzM5?=
 =?utf-8?B?dkZjOUhKWnVBSXQzbzltYjVOVWdYK2lKZlZoYWJneHNnMXFvTnFPdUN1RVMy?=
 =?utf-8?B?aDRBaWtkd0VuQlFpSjFkNThBdm9PSklFRVhpYm84cCtDTkxSTXJSbi9CWjRJ?=
 =?utf-8?B?VWpxZ3BNSWVmbVV3UWM3QjJ2ZDQwbzdEdTJTNXpUQjlyRk80VTBXbFo0YkVh?=
 =?utf-8?B?OTZWWnJ6N1djT1ltdU1jRnlJMUZYZ3hGem1ETk52eHhWZXM0UVl6clZKbnNz?=
 =?utf-8?B?dlB6OGF4U0VacUZHZjQzNisvc1hwU1lmenJxc2YvcEtZRFJyWXhxczBZSmNR?=
 =?utf-8?B?WEhaWVpyL1FuQ0ZVdExLUnM4b1lBUG4rNE5kemUyNnFlWmJVMCtnTzdnUFhX?=
 =?utf-8?B?VkpxUFI0dmhBZ3VGNjB6Q1dFcFZpZjVZV2hSQ25NWUp3ZFh2MVZxZWtqL0NF?=
 =?utf-8?B?V3VGR3NKVWg4UW5PS05qSDY2MzlseGZZblZJVzFnMmZrVjhiZ2JvQmM4Z1o2?=
 =?utf-8?B?alpWbmFFUGE2WDMrVm4vOEVqMFBGVkZyK2oydHBhYk9ROEZnYTdOZDVQWUc3?=
 =?utf-8?B?bmhhUzd5dHF2dTY4L2VNMjl1NUVLSWxLOTM4SkhtM1JmdW1mSWhMZG9YaEtz?=
 =?utf-8?B?a0Q0Zkg5UjlwMUhXOEtQSFdXd1p1MDdFSkI2QlQ0Wmk4SlErZzZDa2NnK0NF?=
 =?utf-8?B?K3dUMkl3L2crL1NQV3FROURpM1VoTnF6aXBkR3hkRURyc3FvV1R0K0lGUWQ0?=
 =?utf-8?Q?Ub9Fpb?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?amg0ck5HeE1IRmw1RlFzaEo5TUdwd0FzR1NzVm55TFI4SlFmQVN1MGFoWlFl?=
 =?utf-8?B?QnJPbnVqVFVmRTJhckZsS1gzMy9TUEZSVmlZQndvOFBhYWVKVlBvcVFPejF4?=
 =?utf-8?B?S2EyWURpeXlWenRrL3Q2M0d3VGR6RWpwSnVBSmdHNi9OZXJhRWtHSXUxODVw?=
 =?utf-8?B?bTljOE91S1c4eTFnbXJIQ3R5ZFVyRitjdGlKR2lOQWR2eTVjTWRLbjBIWTZi?=
 =?utf-8?B?Q0xuV0FQb3MvUFVCeE1tZWpKZ0Y2NmM1UGlvTm9Hc3NzNHVReGIwYmhHeDdj?=
 =?utf-8?B?SVJEVlFteldpY04zcC9XU0UwLzFpVGtlM2lVQkxDVFplaTVuTVhIakl1QXR2?=
 =?utf-8?B?dlpIb1VlelNPSDUyaHdVTFd3R3VPRjlKRWFlN1RVOCtGZWI0L0JnMUh2WDV1?=
 =?utf-8?B?OGJYeDZnUGhKU1ZmTkhpYmlFRHJLWENPS0x0N1c3Q25BV21oOEo2SGhsYTVP?=
 =?utf-8?B?STUrUWNZZ2tRZUphVVplSEk0UStGejlFbzRXaWlNUmx6ODRwSTJDNXlETDZ2?=
 =?utf-8?B?R2pqRTQ5RmlOQjB1eUZOTUxMNVFUMS9odGlxaU1ONXdOVVJiUUV5UytQWjNG?=
 =?utf-8?B?MW9FZ08zaVY0QSt1cDNZVUNtNURQOWprQ0NkWktoNkhGamgydjNyZ2NycnV2?=
 =?utf-8?B?dmJKNm0yQUZ4Z25icHo2dUU4OGJOM1NsRnh0NzFFRUFyejdQN1F4cGFJanBv?=
 =?utf-8?B?Qkl1OWMrL1N3aEM4ZjMwMVVHYWFsRnJtZXRkVmkwNXlBdDJXczJIWHFWSVpS?=
 =?utf-8?B?TkZxOWVqOWQ5RjNTamYwRjN4U3RqZ2ZNQ1pwYVMyWUVhUW81Y2lUUFJnM0hk?=
 =?utf-8?B?b3ZSZk9JSkpUOWU1UGVkZ0JIdVdXQWZFMlhTaER3VktJZzRWOXIxaWFob2JJ?=
 =?utf-8?B?N2l6bWp4cTlEWVF1SFRKRG1LcEZuL01UQUpES20xWTIrUE1vQnRROXhUcFVY?=
 =?utf-8?B?YmxjOVR2YWs5cmtzdFRnY1JZRFpsVS9mdWk3MTViVTVuN084VDlVTkpFR0Rz?=
 =?utf-8?B?aHRGUFFFbW1IUHppSi9oT05IamNjd2JnR1N4M3NwZFA2cEhyOGNZZS9CY0NQ?=
 =?utf-8?B?eThXN2Nrckk4UU1nSDE3eFRUYktzdHpPOXpJaGhkdXJMRTJpdnQreFJhQUh4?=
 =?utf-8?B?M0p6VGxFSFJsTWZVWHpvcm9qdzNyZXlZYUFjOUYvclFqQmZzNnk1dzliVkQ4?=
 =?utf-8?B?cHFNVllURWJSSzUzL09neC9tK3Z4bkN1aEJpU2hPRGhhS1k5ejV2UDNKOXo1?=
 =?utf-8?B?MVBBSUpGRnZwZ0NMTnNsU2EzeVA5ZGlpMlk1YzVHbFYyK2orRWpjaE1HSURq?=
 =?utf-8?B?ZkFPa3VsWWMyeDVGTkFMb21aMlM4WnRPSE5MRjFkWWRHcTZqNGxFRHBtQ0xS?=
 =?utf-8?B?b2VIQUdBcnJuZHpCVDZETlVrUy8vTTN3R3Y3UkVYRHlVbmUyeEdFMDJjSkRR?=
 =?utf-8?B?cm56dWxuWHZQYXZIb1VDblZuWXlFVDc4MEszSktTaWJ0cHZhMUxGMkFYOGg4?=
 =?utf-8?B?aGgvSUVPMFZ2cWlUY0svb3Z0R1lsZTlIZDg0TjVEVUpOa3REUkg4N1ozSTN4?=
 =?utf-8?B?ZFVYV3h0NlY5akZ6VktFOGtyRTRkdUZENXNUZmE4YTl4NFNBa0hEZGVsSTlo?=
 =?utf-8?B?VmNBS3gyQVVQZVVxZ1pPSE1QNEhHN0FieFpqZHIxZjhxSE1uUTEySVdGYjBC?=
 =?utf-8?B?ZDV4cVRhRkNaTUlBRUNEZmNyU3RNRXFaaUptOGRMZVorUEhONDVuaXAzOWQ1?=
 =?utf-8?B?ZG1mWFFOSjRNcDhtT2lieW9rMWJWQTZaa3dKOEc4Vi9ROWFBV0R4R0pRZnlB?=
 =?utf-8?B?UVFFcWF2aDZxZU5FemN2Y3hrTnk1TldydCtRNlhCWkRVL3IrbjNZK01xYVB1?=
 =?utf-8?B?VmE5YWx0bXBseXRPUzhwRXFhOWN6SVVRYzBSdDBBMjY4Um9JTEQ2K2gvaWJp?=
 =?utf-8?B?TnJJQWxscEs5RTgvV05jOG43dzBPZHpDT1dBQVNNcVV4ZmRJekNwaUwwbjFZ?=
 =?utf-8?B?R2ptSjN5NlpKdGh6Tzkyc1ZMNDBIL0VIblhQRXVZMTBGdVFkZDR4N1JDc1V1?=
 =?utf-8?B?bXFLc1FtTEZkN2xjVWxwMHVQOTlwWXNHZWwwM051bUNqMUJuc3Zxem9RcW1S?=
 =?utf-8?B?d3kwRDdPS0lzQUtPRnpVMHphL1h6K2J2OTgyeVZ3NnlUUU9MSlFETWMzQ1Mv?=
 =?utf-8?B?NmlkRnY5UkFPRnhySzZMdW44TStxS3g4TzNiTkwrTmY0a1lDWEpZNGppcFJo?=
 =?utf-8?B?cWp6dEFCemYxV0w2VUJ2ZUdHTjIxZTVPRHlGZmZVa3paR3FpV3pZU3pKdDdM?=
 =?utf-8?B?RENuYW5WdldUMFNGZ1FxWW5qTGNHczN1eU4zcEtUVWR3djJQMzdFcXVqZFZj?=
 =?utf-8?Q?HWl/OgXoP66avasK3FUhxmKEVTvTif0CQZCzJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1A4749FCC26DF4095E3EB62EC34DE18@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b0d7167e-4cf1-4514-4b19-08de4ca9d2bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2026 22:29:00.1116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I+GMQHnnPBuOJgOzg73gju2nnyWwO2qIY7bBlqEHFHddqgoIFUQVaz+w/hLFXbiY6hmJy7WSU6hnBFxFH7S+4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5094
X-Proofpoint-GUID: OT5gmqp_15eWJW9_ahE4Z5MYTf8pVvMq
X-Authority-Analysis: v=2.4 cv=Jvf8bc4C c=1 sm=1 tr=0 ts=695c3b2f cx=c_pps
 a=bIHOvEVewOWTfzx0yc51bg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8
 a=AGs0dgBC2CpJwckbQH0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: zWwZsraalC3C_B8fhqKlN9g9HaaKT8uS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE5NCBTYWx0ZWRfX5m21Rmrt1wl2
 b3KPosQE7REyBPu5UoXSAjQdU+8sjZs+45cfonkoD/6OSlmQeS61V6ZsKpREcWMMOmW7zMneCR7
 G4jMU3ywen6ziilKf836C6G6BQFsi6WosVaxbPacye1/0c7umw9jwU+XwqQ7oMFLRSq1R0OiNnG
 ctMy/c+gnqTn0Csh2752MtyQ39IA7gkn7xSp2w6unMCHCbJ6f0ZSLl141zahG+uyXdxgAbTyjC2
 sGtwt0jBLEGVTuI/f6LXI7ZnZ+44nRQmQo5K4lBiyBI6R2vBz+E3bic8FzNUWOC/Pox7/4fXAbD
 qiSUVn9VhP+5VjNl+bOq0PhPlU8pOTpnVrULSokUgYNFHZv3Sbv8mpB5sfMKXKnTj5UCML0YPNu
 +PBe7XKoZywCR0XXKZtEmRjb62rWLQgDfHUUCIcLqvPReGqPtcmqiA8nD9I6OJfBGvgAA1jwu07
 VCHW80vSL7g9+sxLjbQ==
Subject: Re:  [PATCH 4/5] ceph: Assert writeback loop invariants
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601050194

T24gVHVlLCAyMDI1LTEyLTMwIGF0IDE4OjQzIC0wODAwLCBTYW0gRWR3YXJkcyB3cm90ZToNCj4g
SWYgYGxvY2tlZF9wYWdlc2AgaXMgemVybywgdGhlIHBhZ2UgYXJyYXkgbXVzdCBub3QgYmUgYWxs
b2NhdGVkOg0KPiBjZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2goKSB1c2VzIGBsb2NrZWRfcGFnZXNg
IHRvIGRlY2lkZSB3aGVuIHRvDQo+IGFsbG9jYXRlIGBwYWdlc2AsIGFuZCByZWR1bmRhbnQgYWxs
b2NhdGlvbnMgdHJpZ2dlcg0KPiBjZXBoX2FsbG9jYXRlX3BhZ2VfYXJyYXkoKSdzIEJVR19PTigp
LCByZXN1bHRpbmcgaW4gYSB3b3JrZXIgb29wcyAoYW5kDQo+IHdyaXRlYmFjayBzdGFsbCkgb3Ig
ZXZlbiBhIGtlcm5lbCBwYW5pYy4gQ29uc2VxdWVudGx5LCB0aGUgbWFpbiBsb29wIGluDQo+IGNl
cGhfd3JpdGVwYWdlc19zdGFydCgpIGFzc3VtZXMgdGhhdCB0aGUgbGlmZXRpbWUgb2YgYHBhZ2Vz
YCBpcyBjb25maW5lZA0KPiB0byBhIHNpbmdsZSBpdGVyYXRpb24uDQo+IA0KPiBUaGlzIGV4cGVj
dGF0aW9uIGlzIGN1cnJlbnRseSBub3QgY2xlYXIgZW5vdWdoLCBhcyBldmlkZW5jZWQgYnkgdGhl
DQo+IHByZXZpb3VzIHR3byBwYXRjaGVzIHdoaWNoIGZpeCBvb3BzZXMgY2F1c2VkIGJ5IGBwYWdl
c2AgcGVyc2lzdGluZyBpbnRvDQo+IHRoZSBuZXh0IGxvb3AgaXRlcmF0aW9uLg0KPiANCj4gVXNl
IGFuIGV4cGxpY2l0IEJVR19PTigpIGF0IHRoZSB0b3Agb2YgdGhlIGxvb3AgdG8gYXNzZXJ0IHRo
ZSBsb29wJ3MNCj4gcHJlZXhpc3RpbmcgZXhwZWN0YXRpb24gdGhhdCBgcGFnZXNgIGlzIGNsZWFu
ZWQgdXAgYnkgdGhlIHByZXZpb3VzDQo+IGl0ZXJhdGlvbi4gQmVjYXVzZSB0aGlzIGlzIGNsb3Nl
bHkgdGllZCB0byBgbG9ja2VkX3BhZ2VzYCwgYWxzbyBtYWtlIGl0DQo+IHRoZSBwcmV2aW91cyBp
dGVyYXRpb24ncyByZXNwb25zaWJpbGl0eSB0byBndWFyYW50ZWUgaXRzIHJlc2V0LCBhbmQNCj4g
dmVyaWZ5IHdpdGggYSBzZWNvbmQgbmV3IEJVR19PTigpIGluc3RlYWQgb2YgaGFuZGxpbmcgKGFu
ZCBtYXNraW5nKQ0KPiBmYWlsdXJlcyB0byBkbyBzby4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNh
bSBFZHdhcmRzIDxDRlN3b3Jrc0BnbWFpbC5jb20+DQo+IC0tLQ0KPiAgZnMvY2VwaC9hZGRyLmMg
fCA5ICsrKysrLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNCBkZWxl
dGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2FkZHIuYyBiL2ZzL2NlcGgvYWRk
ci5jDQo+IGluZGV4IDkxY2M0Mzk1MDE2Mi4uYjM1NjlkNDRkNTEwIDEwMDY0NA0KPiAtLS0gYS9m
cy9jZXBoL2FkZHIuYw0KPiArKysgYi9mcy9jZXBoL2FkZHIuYw0KPiBAQCAtMTY2OSw3ICsxNjY5
LDkgQEAgc3RhdGljIGludCBjZXBoX3dyaXRlcGFnZXNfc3RhcnQoc3RydWN0IGFkZHJlc3Nfc3Bh
Y2UgKm1hcHBpbmcsDQo+ICAJCXRhZ19wYWdlc19mb3Jfd3JpdGViYWNrKG1hcHBpbmcsIGNlcGhf
d2JjLmluZGV4LCBjZXBoX3diYy5lbmQpOw0KPiAgDQo+ICAJd2hpbGUgKCFoYXNfd3JpdGViYWNr
X2RvbmUoJmNlcGhfd2JjKSkgew0KPiAtCQljZXBoX3diYy5sb2NrZWRfcGFnZXMgPSAwOw0KPiAr
CQlCVUdfT04oY2VwaF93YmMubG9ja2VkX3BhZ2VzKTsNCj4gKwkJQlVHX09OKGNlcGhfd2JjLnBh
Z2VzKTsNCj4gKw0KDQpJdCdzIG5vdCBnb29kIGlkZWEgdG8gaW50cm9kdWNlIEJVR19PTigpIGlu
IHdyaXRlIHBhZ2VzIGxvZ2ljLiBJIGFtIGRlZmluaXRlbHkNCmFnYWluc3QgdGhlc2UgdHdvIEJV
R19PTigpIGhlcmUuDQoNCj4gIAkJY2VwaF93YmMubWF4X3BhZ2VzID0gY2VwaF93YmMud3NpemUg
Pj4gUEFHRV9TSElGVDsNCj4gIA0KPiAgZ2V0X21vcmVfcGFnZXM6DQo+IEBAIC0xNzAzLDExICsx
NzA1LDEwIEBAIHN0YXRpYyBpbnQgY2VwaF93cml0ZXBhZ2VzX3N0YXJ0KHN0cnVjdCBhZGRyZXNz
X3NwYWNlICptYXBwaW5nLA0KPiAgCQl9DQo+ICANCj4gIAkJcmMgPSBjZXBoX3N1Ym1pdF93cml0
ZShtYXBwaW5nLCB3YmMsICZjZXBoX3diYyk7DQo+IC0JCWlmIChyYykNCj4gLQkJCWdvdG8gcmVs
ZWFzZV9mb2xpb3M7DQo+IC0NCg0KRnJhbmtseSBzcGVha2luZywgaXRzJyBjb21wbGV0ZWx5IG5v
dCBjbGVhciB0aGUgZnJvbSBjb21taXQgbWVzc2FnZSB3aHkgd2UgbW92ZQ0KdGhpcyBjaGVjay4g
V2hhdCdzIHRoZSBwcm9ibGVtIGlzIGhlcmU/IEhvdyB0aGlzIG1vdmUgY2FuIGZpeCB0aGUgaXNz
dWU/DQoNClRoYW5rcywNClNsYXZhLg0KDQo+ICAJCWNlcGhfd2JjLmxvY2tlZF9wYWdlcyA9IDA7
DQo+ICAJCWNlcGhfd2JjLnN0cmlwX3VuaXRfZW5kID0gMDsNCj4gKwkJaWYgKHJjKQ0KPiArCQkJ
Z290byByZWxlYXNlX2ZvbGlvczsNCj4gIA0KPiAgCQlpZiAoZm9saW9fYmF0Y2hfY291bnQoJmNl
cGhfd2JjLmZiYXRjaCkgPiAwKSB7DQo+ICAJCQljZXBoX3diYy5ucl9mb2xpb3MgPQ0K

