Return-Path: <ceph-devel+bounces-3776-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26336BB1745
	for <lists+ceph-devel@lfdr.de>; Wed, 01 Oct 2025 20:09:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAE7F3C5BD9
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Oct 2025 18:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D652E2C21F6;
	Wed,  1 Oct 2025 18:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="a81GkQwY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DA82441A0;
	Wed,  1 Oct 2025 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759342191; cv=fail; b=O6RZB1V7GFavVBLUHXWuS9mzgyRFHazrAR5835DrnNrBmo7yTzctrSI+LBCXwxOZE1kDLuMVcNqlSIwRmyZ1MTlwQhjrCPD9KtuRDbCOHu5Hcsvkn+bbM3oybI9u7+um0qsMY3avD4gQu1CRnpZDW22NotFuQGEfwE5MuY+Bunc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759342191; c=relaxed/simple;
	bh=6bPC2EnrLCwCpGtqGN+RMz3dU3dYol9FzkbGLyAqsAc=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=m2x9SK1FL/3Ndwzxr9eG77DqvoPHdszBq1lbI2K7Khypx7ydXgf9h3q1wElrztCsPjs8IRLetrVWRt2wFFm1Hn/z3omN+bpt3DchPPzCGxd3rRC7ayXljsL92AE3ZW7XxqzX1R829D2RuYBjdmX0QxI+tI3D/0LlN833tBrQY/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=a81GkQwY; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591E12Q9030156;
	Wed, 1 Oct 2025 18:09:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=6bPC2EnrLCwCpGtqGN+RMz3dU3dYol9FzkbGLyAqsAc=; b=a81GkQwY
	pGI7gKE9/5yFje1/DC7NKjGPT1NY0JG03ItFXcE4t519cCJSpuZ+Bl/KCHp92+nw
	XQIOZ37BoAWkl2N/yEehTJTqx5CaRr66NkI++snmDv1qEtjIxIbHoB/9rS52h2mi
	tE9OjRzxRV80LnqXu3TLWOhR8KWooAfNsrdgzYmeZN8GspEpKWJY+QgqQWvCGxZ0
	VwydmXYsjcYOdvci+aw4H3+uC1aBK2Hl5PoyFR7mPcJsexzLRT9qnYYm0Sek3VcO
	O0EHl/3cNJzrWzlOSMVNlDhXwFUFXqBHyBao8we79P1kri6A76xSFPyj9cLQhmZH
	NvEaHHB/NyqbFA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7e7h85g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 18:09:39 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 591I7Qmu018403;
	Wed, 1 Oct 2025 18:09:39 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012060.outbound.protection.outlook.com [40.107.200.60])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7e7h85d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 18:09:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xflF4VM3xHNnUpPwLbQvfGpqtmJG8Yk9nWaZ7o0W5XCkqlH4EW9l3E36B4DoXAmN2YuXgr0oi7n8niNImi4U1acpR/fCqxZ5oRZZtHdRJJMfPEGNcFXHdCBC+BNmpdE1wn1fWxKjLNoRj6VIYszv8x5/yFI+zLQHKIu2g7Rf/wOLYPqqUnSKCAWZdmZnMUptH2ikg2RIJo4DA+aMlNCYjeHXG4pQIpQDeHhdWFmwEudGE1nICiMV0B448KSeEA2LaLG/W233D4oxybn6hHWxaKZSQyyyalCYeUxBTBM8ZlGnLBEEjrKxaSy7d+UjaXv8MVkkeoyy83wYji1fngNhrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bPC2EnrLCwCpGtqGN+RMz3dU3dYol9FzkbGLyAqsAc=;
 b=SXaUWQvqYWJxCHY+NvBEQnYFkjcpm3crIK/Y4mFZXQHsx3PBzCDwq8db5M0x+gP5W2TjgMzva06W9W9SsJjXMeCBdXi3ZbsnNH2NatbEOvEprkGsk4SC25UOgKYS3QY9hNvDoR2W4FobfBpkCH8Oi5GAlNTMdWA6opEu0j+I1sJQVogrgfA6jO5e94NrpXdR2Y5ellhottUq3hZW8811Ck4qq7+14/qb7v3ze/xqTqEub9fmF6cnRN+T+p7+/SPqMEPgeAJirOwoIT9RSC8bnhhO9TgZb/K1OuXApnYJE13I7toNADZ5oLkrFFKrfSV90IhV+CIefHFsAe2V5RC1KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by MW3PR15MB3962.namprd15.prod.outlook.com (2603:10b6:303:45::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.15; Wed, 1 Oct
 2025 18:09:35 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Wed, 1 Oct 2025
 18:09:34 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ethanwu@synology.com" <ethanwu@synology.com>
CC: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "ethan198912@gmail.com" <ethan198912@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] ceph/006: test snapshot data integrity
 after punch hole operations
Thread-Index: AQHcMoFh+qS+MPTqHkCSnrKaais7f7StmBCA
Date: Wed, 1 Oct 2025 18:09:34 +0000
Message-ID: <cc9d84c5a3b683ccd7c86fcede503e07b048e94c.camel@ibm.com>
References: <20250930075743.2404523-1-ethanwu@synology.com>
	 <7d9866d591e7fe4e5f3336aaa13107db402a608d.camel@ibm.com>
	 <d6b17cbb-3504-4c3c-9f31-35c538248503@Mail>
In-Reply-To: <d6b17cbb-3504-4c3c-9f31-35c538248503@Mail>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|MW3PR15MB3962:EE_
x-ms-office365-filtering-correlation-id: 65c4ad15-c368-444c-7efb-08de0115ad1c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MnN5TmprOXFPU0ZNQ0grZG5EUElaYkFtMXplaUVsZVZ2UVhDRnFEZmRYSk9X?=
 =?utf-8?B?MGtjQmtRRWVWb1JTOHNsMytQM2hMK0NVZ0p5bWRKN1hseXlQWU9VTWVXdGhY?=
 =?utf-8?B?UFltZktqN2VaOG93V1JmMktGZ28xeXdNYVd4T0lQNDQ5dWw5QkYyVGxSbUhq?=
 =?utf-8?B?UlBydVNHUUVhOXNoYnoxbUNta2plSTg2NTRyMDBGN29ZZ1ZEWlBhUkdKeTM2?=
 =?utf-8?B?SjB1ZGRoUmJkUjRZcy9UVEd0NGZOUmI3cmh5clZJNHpzTFlHRXg5QmpQdWl3?=
 =?utf-8?B?cEpMYklGZ0VCSkVYbXlPMzRoS0d6alh4T0EzVWF2b3MyWGp6K21BWlpUUzJm?=
 =?utf-8?B?RWFFeVBRcjVuZTFMandTanFUOVZvNHNUalQzNjRjQ3RMQjdoZzFjbjM2R0ZX?=
 =?utf-8?B?MjhyMjJHZENHSzY1NFpXZU84bkRualZQOThsSUFtNUtWOG1EU1c4aktFNldM?=
 =?utf-8?B?QkdSMWdkOU5vUkhTMlc2TXhTbmwzVjk1MFRsS1ZWMVNiays5K25Vb2R0YVlo?=
 =?utf-8?B?Sk1FanJWV1ZGR1hqbHFpRnJiQ3dYR3VaT05DUVBsbjg0MHRyVEF6MzNvN25B?=
 =?utf-8?B?VHV4Vmo4OUYzVUd6b2N4WUU3ZE5MczhTd3UwLzNpSldMSkZwUlcvMjhScUtn?=
 =?utf-8?B?WENsclBVZEVUWVFmZDN1WnNuRklrU1hmU3NObWJtY2xtWTF6dWtxN3BNU0dT?=
 =?utf-8?B?WjRLTUNUMmR4SEdYSWFpVTNYMktON096QjBrQ0JsQVZYOTQ5OHgwMjdGLytU?=
 =?utf-8?B?eGlsaW1SUHNTNjNGOFpOajVvWUJUMTV3bVFwdXhVc0FGS0NSYmd1aVpUaTE5?=
 =?utf-8?B?Q0Zyb3N2SlpHeThESVRxZ1I1bjRGRytzK1VrKzZsbDBXR1VJTHZzdnk0K3Za?=
 =?utf-8?B?SGt6NnQxNDRTazVaM1dZSEo3aEFXZVV1ZWp0a3FabjJUZTB5Y0RGdGdXRlFO?=
 =?utf-8?B?dUdoVy9JVVZrS0lLNFpNcHR0c2U0TVVpMCt4cUp5cndXVmpYNzNiK3VKanNJ?=
 =?utf-8?B?YmMrc09FVGpTTTVNZGJ4aDYxZHNwTlU5dmdqbm9lanFCcU5PT2dKMUtYU1Fa?=
 =?utf-8?B?cFU3Yno0WS8vYWs1OUwwOEJPdE0xU2sveHhmbURObGhvaTZkN09SYjZPWGxl?=
 =?utf-8?B?TldoTloyaytDeXJVV3pJOHNqTzhoU0tIZHpKbElrMnpuZ0U2MHg4dWdtcW5M?=
 =?utf-8?B?Q2t4eVBlWElqMExhcTc1QXZuUjJqalE1c2wvTUFra1IxMHRqZzlsTzRJblU2?=
 =?utf-8?B?aWVBRnczUlJSSWtTNjRGajNDTEV4b0U2VGNEYmdMdjU0YThtY3BERm1IbGlU?=
 =?utf-8?B?VVNrTmNzOFdudU1FYVU1NVFyTzZYeFByU2lKVmp6eWltL0NwNy9kV2xEKytQ?=
 =?utf-8?B?ZEM2dDVnVG1lRnpBZ3dMWW1mZnJ0TlRrRDJJYXpzTkQrTUo4K01rQ01VZkNt?=
 =?utf-8?B?NzNCUzdUb3U1NW43QjlJeEdvSzlWcjBtQWxSRDJZTjl5ZXBnMnJuckI2cmJQ?=
 =?utf-8?B?MVdxMU93YzFQSjNNNFFLWVlvcFhiVGgwd2xsVEZHNkhmcythbE13bU1IZVdp?=
 =?utf-8?B?YWc4NHJVM1dBTHEzNDVLNFJLMkROelRzUnpZS09WS05ZVTFsR2NhSFZwV1V0?=
 =?utf-8?B?MjJOVXJIamtiNGRpMXE0MHMzdWxVQXdhS0l5d2lQc0NEWjZieGxXcEpmYWhH?=
 =?utf-8?B?TDlUdEwzU2RjcHJtcjdld0RhVFEyWFlLR2VBUzU5eVRlZkRCeDZQeUlzSFA4?=
 =?utf-8?B?RDRFVUFWRktldEU1aDNpL1BrMUhUb2hlZENLMzE2MHJTZjIwRUdsTlozYmFm?=
 =?utf-8?B?d3J2NFNRcUpwQzRobTQrMlcyZitzQk94Zy9LL1RVVGwwN3VkNGM5dTk2dTB4?=
 =?utf-8?B?WFRiTWdYTUs3NXFZRDVrZXJ3QWxVejkrZnVlMkhwbUdQUXpCNEg2cTRDL2Fu?=
 =?utf-8?B?UnZnTDdlRXVESUc4aytFMnJLUzNjVlUwbSswTE1IbXprOEVLZ2pUTi9HUDNF?=
 =?utf-8?B?bXByMUc3NVZ5bVdiU1pXaE5SSlAvZGtCRW0rVkRoVGFJNjVrOG1rUmF5Tmpu?=
 =?utf-8?Q?tCzhVX?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YWMzS05jYXVhQTU0UjNoUU5TRUpwa05JNElZNEYzQkZDdjAzdC94NGk2S0Zv?=
 =?utf-8?B?c0ViSmxZYVBXMitnTkxVVzdObGJiT3ZwQ1NEemxaOTB4TUtIYXJnWWVGdmpz?=
 =?utf-8?B?K1dPWXZuOHFGZkVYMG04b2JTZmhpTENUZ05zTCtyaVBtc3dPT3FpSDQycVl1?=
 =?utf-8?B?c0dNMkx3UGpXVXdOdmNQWjd3MHNLUTBjWGVoZUZJTVkvaVBqNXpZZEZ0Z0ll?=
 =?utf-8?B?VHBNd3lwL0R4bS84S0R1dUl6VWFiL0FTTFFvMTUxZENkM0Y1aUEvcjNDSjVH?=
 =?utf-8?B?RUpyenU0dEUrMUF5b016c2pvYVNiWWRLY3F4d3JXak94djhxUzhKRW9wazZj?=
 =?utf-8?B?VFFMdFZIL2NPaTl5Y1A0c1d2ZjlhVnVLMWczakNGblFTMzZyVGxibVlGTTZs?=
 =?utf-8?B?NDM1WWgzc094TmxGRGhrM3c0aGd6WmE1MTlhY2hiYVVKZ0tYcS9TRTVTQWJh?=
 =?utf-8?B?eStDazRXVWkxei9lN1ZPbGh2Mkp3RmpBcEVrc2lQYTdPbE93eVZZcXhhSFBu?=
 =?utf-8?B?VDdLN2M3SUd6Z0xkbHF1L3NmZkdpZFRZQjBkR0dXczdiYjEyaG1VRnNlQzZ1?=
 =?utf-8?B?VXlEQVZaTjVQR0dVN3owUE1sRUp3UmFOVWVCMlVndDJtaTRnVkFhRnluQ3M1?=
 =?utf-8?B?MHpCVTNEbkZxdDhnQ1NHMm9Od1RNZ0k2UVRTSnUyMWp1cHAxdVFmVW9WZGda?=
 =?utf-8?B?dUhsaFFvT21YWEJMbmJFbDYwNVlqSFZWUTFGK3BYVUd6cjg5QWo1dU5MZUt2?=
 =?utf-8?B?bXUzZlJXcTdQK053QzhJUzkzVFpjVUo5SERzUUVGV3dTczNpQVdxOTRlUVVs?=
 =?utf-8?B?UWtzWWFaR2Z3SldSVk9mOTZ4S0QzYmpINmVPQVJWM24xbmZpcUZpM0dOaFc1?=
 =?utf-8?B?TmZOR3dLODJtbE1veCtyODY1SC91MkRTZnE3cHR6R2N6WldHRlVpNFpZME9F?=
 =?utf-8?B?bjJVZWY2RGZlWDJXTjhSZ1UrNWJGRTU2elV5aGU0TEVwS3JYWXl4MSs3UTNW?=
 =?utf-8?B?SmZGK0dZN2prSTZRUlJSNWlnMmMyeWVjVzhqcVgzUHg4aExiUkRwakgwSjE5?=
 =?utf-8?B?TitCdDFUNGdpUGRiV3lQYVZaQ3JHZ3ZzSU0rMFF3SVVnSUZaeHhpVjVBUXpx?=
 =?utf-8?B?NlRqNy95UnJGZFdza0RObjJRRTdkQVRDS0V6Z0tWdnF5TFNvcHRCQnF3T21Z?=
 =?utf-8?B?MTRTRnJYN29wUGdJdUFkWFEyRUo2VzJUOThjUENvb09lNmtva0hCTXhvajFE?=
 =?utf-8?B?Q05ZZWpKNDBMTDR0aDNLMXJ2Z1VEdlRrTFlGWnl5TTNFdm92VFE4ZDAyZkRV?=
 =?utf-8?B?V0xjUnhaNmdId2JZa1ljb3BrRVl6bzdyODFnZG41cUVCNEZsNkhtM3RvczN0?=
 =?utf-8?B?TEdCWk9ZbkJITmZDYmVRQkVHNVV4QVRXY3VBRUIwZlJGM1dRSXV4ZlhiQkJI?=
 =?utf-8?B?eklmNEdaL0pqdGZvQmpsMTltYVVjUVhwRGJXeXlaMm1HQjV1b1ZlMWd5V0V2?=
 =?utf-8?B?RmZjMGJCck0rNE5JZnhXMlhadEt1M25XQzJjT3BhN3lsV0thL2ZYMHFPYnZt?=
 =?utf-8?B?L2Jac0lDdGhQbzc3d3lyK3BVekJkVXEvNTNFT2ZuMjlTbnhIMmUxTWFYSmJU?=
 =?utf-8?B?NllkZktBeitxLzFZUTR5SmFoTVdKdGZna2dCSlhBbWNaMTJWR0tLNTFqdkpW?=
 =?utf-8?B?bG1XaFVXblM3SFlIb1VuNXFjd0NDbXo2QUlOaXBrZkVOR0YrMnAwZ28rZ2lD?=
 =?utf-8?B?clAvc2ZlRHArMXVNSGcwOWNJWjBOdVRkNmNPMU15NEFWT1RaRXkybkdvampo?=
 =?utf-8?B?Zzl0VVFnbmVsNHlwREN3MjhUeThqTWdxaGxhTFFqbWx6ZGNZaGdQVmowN2NU?=
 =?utf-8?B?SVRLeTdINFFhYXdsNGRxZlhoS0Noc0gzK1hvYUllSnNWakZsS3NucGxMV0lI?=
 =?utf-8?B?RWRuZTU1dXFtOEVxK1JQeVFSV0dqcWRLWGsyVDdBMzFlVStuWjZ4a1R5TTZF?=
 =?utf-8?B?MS9teHdGSXJEMzdkTXhsOUZZYjZ1eWNwenFRQzl5elhhZm1vQmsrbC9NZFQ4?=
 =?utf-8?B?MkRzRGt3UmsxSDRibUU2Tnd5c0M5UzEzcWJsOEtXaWdvNUNDQmI5QnNwSVRS?=
 =?utf-8?B?T0xWaDNDL2lidHJiS1c5eVN4T3IvdlVUblNVQVlVK3hadkd6cUJkVXR4ODhm?=
 =?utf-8?Q?VPgdEeCkpDfo7/b5lF5yUiw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D72E79737CB2254B89CF39326CDAE567@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c4ad15-c368-444c-7efb-08de0115ad1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2025 18:09:34.3158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K+LSNKBltqSCETiDPVUtz2X8Io6LlnQpXihZIRTHGI9RGueyhcUhc2M0VnXes6kxMJclT6XmsIB4AaratVyV7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3962
X-Proofpoint-ORIG-GUID: hCd7CB7Vsm-upYd5PwNChOjj7Zv7fPOt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyMCBTYWx0ZWRfXxS8mclKd3XKR
 s27HhuSyjkbcOjM2o49XbodXQwuZZzKkpaioibg+JvcKZ+1TMEm+mmlb/HiH7T56ov8WTaIkE4i
 eN283wlbxTiftLPRk6AIz7mfzEi4IsXWX3v6DC+eK4x6uU3P+VVK61uS5KSp8R4SXooBmXKTzn8
 xGVrhdoPaezwJVPZvD4AuOvi3p8PNTpyILt++Y0FR6FfMC+WdCRwaQNGEO/vKn2S7d0RRMzDBA2
 ylD4J6IderkJWjFUN03I4h+e7Ay5ov7PX8hzXEzOorPNBAXXuU8L23uFH+SPehDImSp+skpfcU1
 BglqIsXYehydyK3s5QP11G9JP6U0/NrB7tTssZ2OVkh2J3VnHjeAGqfeNZ2spSxKT2H0Nme9v/i
 PJWNqBLUUE59BrTWU+k+UECP5wLtDA==
X-Proofpoint-GUID: 4d7pMYXl5UMiTY7Pv2HZTrDR9CV8XiqK
X-Authority-Analysis: v=2.4 cv=Jvj8bc4C c=1 sm=1 tr=0 ts=68dd6e63 cx=c_pps
 a=P3LZRqt57NYhn536gl30yA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=VnNF1IyMAAAA:8 a=LM7KSAFEAAAA:8 a=nc4ksfMGi_owJDidy7gA:9
 a=QEXdDO2ut3YA:10
Subject: RE: [PATCH] ceph/006: test snapshot data integrity after punch hole
 operations
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_05,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2509270020

T24gV2VkLCAyMDI1LTEwLTAxIGF0IDExOjExICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiBWaWFj
aGVzbGF2IER1YmV5a28gPFNsYXZhLuKAikR1YmV5a29A4oCKaWJtLuKAimNvbT4g5pa8IDIwMjUt
MTAtMDEgMDI64oCKMjQg5a+r6YGT77yaIE9uIFR1ZSwgMjAyNS0wOS0zMCBhdCAxNTrigIo1NyAr
MDgwMCwgZXRoYW53dSB3cm90ZTogPiBBZGQgdGVzdCB0byB2ZXJpZnkgdGhhdCBDZXBoIHNuYXBz
aG90cyBwcmVzZXJ2ZSBvcmlnaW5hbCBmaWxlIGRhdGEgPiB3aGVuIHRoZSBsaXZlIGZpbGUgaXMg
bW9kaWZpZWQgd2l0aCBwdW5jaA0KPiDCoA0KPiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1
YmV5a29AaWJtLmNvbT4g5pa8IDIwMjUtMTAtMDEgMDI6MjQg5a+r6YGT77yaDQo+IA0KPiANCj4g
PiBPbiBUdWUsIDIwMjUtMDktMzAgYXQgMTU6NTcgKzA4MDAsIGV0aGFud3Ugd3JvdGU6DQo+ID4g
PiBBZGQgdGVzdCB0byB2ZXJpZnkgdGhhdCBDZXBoIHNuYXBzaG90cyBwcmVzZXJ2ZSBvcmlnaW5h
bCBmaWxlIGRhdGENCj4gPiA+IHdoZW4gdGhlIGxpdmUgZmlsZSBpcyBtb2RpZmllZCB3aXRoIHB1
bmNoIGhvbGUgb3BlcmF0aW9ucy4gVGhlIHRlc3QNCj4gPiA+IGNyZWF0ZXMgYSBmaWxlLCB0YWtl
cyBhIHNuYXBzaG90LCBwdW5jaGVzIG11bHRpcGxlIGhvbGVzIGluIHRoZQ0KPiA+ID4gb3JpZ2lu
YWwgZmlsZSwgdGhlbiB2ZXJpZmllcyB0aGUgc25hcHNob3QgZGF0YSByZW1haW5zIHVuY2hhbmdl
ZC4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogZXRoYW53dSA8ZXRoYW53dUBzeW5vbG9n
eS5jb20+DQo+ID4gPiAtLS0NCj4gPiA+IMKgdGVzdHMvY2VwaC8wMDYgICAgIHwgNTggKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ID4gwqB0ZXN0cy9j
ZXBoLzAwNi5vdXQgfCAgMiArKw0KPiA+ID4gwqAyIGZpbGVzIGNoYW5nZWQsIDYwIGluc2VydGlv
bnMoKykNCj4gPiA+IMKgY3JlYXRlIG1vZGUgMTAwNzU1IHRlc3RzL2NlcGgvMDA2DQo+ID4gPiDC
oGNyZWF0ZSBtb2RlIDEwMDY0NCB0ZXN0cy9jZXBoLzAwNi5vdXQNCj4gPiA+IA0KPiA+ID4gZGlm
ZiAtLWdpdCBhL3Rlc3RzL2NlcGgvMDA2IGIvdGVzdHMvY2VwaC8wMDYNCj4gPiA+IG5ldyBmaWxl
IG1vZGUgMTAwNzU1DQo+ID4gPiBpbmRleCAwMDAwMDAwMC4uM2Y0YjQ1NDcNCj4gPiA+IC0tLSAv
ZGV2L251bGwNCj4gPiA+ICsrKyBiL3Rlc3RzL2NlcGgvMDA2DQo+ID4gPiBAQCAtMCwwICsxLDU4
IEBADQo+ID4gPiArIyEvYmluL2Jhc2gNCj4gPiA+ICsjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVy
OiBHUEwtMi4wDQo+ID4gPiArIyBDb3B5cmlnaHQgKEMpIDIwMjUgU3lub2xvZ3kgQWxsIFJpZ2h0
cyBSZXNlcnZlZC4NCj4gPiA+ICsjDQo+ID4gPiArIyBGUyBRQSBUZXN0IE5vLiBjZXBoLzAwNg0K
PiA+ID4gKyMNCj4gPiA+ICsjIFRlc3QgdGhhdCBzbmFwc2hvdCBkYXRhIHJlbWFpbnMgaW50YWN0
IGFmdGVyIHB1bmNoIGhvbGUgb3BlcmF0aW9ucw0KPiA+ID4gKyMgb24gdGhlIG9yaWdpbmFsIGZp
bGUuDQo+ID4gPiArIw0KPiA+ID4gKy4gLi9jb21tb24vcHJlYW1ibGUNCj4gPiA+ICtfYmVnaW5f
ZnN0ZXN0IGF1dG8gcXVpY2sgc25hcHNob3QNCj4gPiA+ICsNCj4gPiA+ICsuIGNvbW1vbi9maWx0
ZXINCj4gPiA+ICsNCj4gPiA+ICtfcmVxdWlyZV90ZXN0DQo+ID4gPiArX3JlcXVpcmVfeGZzX2lv
X2NvbW1hbmQgInB3cml0ZSINCj4gPiA+ICtfcmVxdWlyZV94ZnNfaW9fY29tbWFuZCAiZnB1bmNo
Ig0KPiA+ID4gK19leGNsdWRlX3Rlc3RfbW91bnRfb3B0aW9uICJ0ZXN0X2R1bW15X2VuY3J5cHRp
b24iDQo+ID4gPiArDQo+ID4gPiArIyBUT0RPOiBVcGRhdGUgd2l0aCBmaW5hbCBjb21taXQgU0hB
IHdoZW4gbWVyZ2VkDQo+ID4gPiArX2ZpeGVkX2J5X2tlcm5lbF9jb21taXQgMWI3YjQ3NGIzYTc4
IFwNCj4gPiA+ICsgImNlcGg6IGZpeCBzbmFwc2hvdCBjb250ZXh0IG1pc3NpbmcgaW4gY2VwaF96
ZXJvX3BhcnRpYWxfb2JqZWN0Ig0KPiA+ID4gKw0KPiA+ID4gK3dvcmtkaXI9JFRFU1RfRElSL3Rl
c3QtJHNlcQ0KPiA+ID4gK3NuYXBkaXI9JHdvcmtkaXIvLnNuYXAvc25hcDENCj4gPiA+ICtybWRp
ciAkc25hcGRpciAyPi9kZXYvbnVsbA0KPiA+ID4gK3JtIC1yZiAkd29ya2Rpcg0KPiA+ID4gK21r
ZGlyICR3b3JrZGlyDQo+ID4gPiArDQo+ID4gPiArJFhGU19JT19QUk9HIC1mIC1jICJwd3JpdGUg
LVMgMHhhYiAwIDEwNDg1NzYiICR3b3JrZGlyL2ZvbyA+IC9kZXYvbnVsbA0KPiA+ID4gKw0KPiA+
ID4gK21rZGlyICRzbmFwZGlyDQo+ID4gPiArDQo+ID4gPiArb3JpZ2luYWxfbWQ1PSQobWQ1c3Vt
ICRzbmFwZGlyL2ZvbyB8IGN1dCAtZCcgJyAtZjEpDQo+ID4gPiArDQo+ID4gPiArIyBQdW5jaCBz
ZXZlcmFsIGhvbGVzIG9mIHZhcmlvdXMgc2l6ZXMgYXQgZGlmZmVyZW50IG9mZnNldHMNCj4gPiA+
ICskWEZTX0lPX1BST0cgLWMgImZwdW5jaCAwIDQwOTYiICR3b3JrZGlyL2Zvbw0KPiA+ID4gKyRY
RlNfSU9fUFJPRyAtYyAiZnB1bmNoIDE2Mzg0IDgxOTIiICR3b3JrZGlyL2Zvbw0KPiA+ID4gKyRY
RlNfSU9fUFJPRyAtYyAiZnB1bmNoIDY1NTM2IDE2Mzg0IiAkd29ya2Rpci9mb28NCj4gPiA+ICsk
WEZTX0lPX1BST0cgLWMgImZwdW5jaCAyNjIxNDQgMzI3NjgiICR3b3JrZGlyL2Zvbw0KPiA+ID4g
KyRYRlNfSU9fUFJPRyAtYyAiZnB1bmNoIDEwMjQwMDAgNDA5NiIgJHdvcmtkaXIvZm9vDQo+ID4g
PiArDQo+ID4gPiArIyBNYWtlIHN1cmUgd2UgZG9uJ3QgcmVhZCBmcm9tIGNhY2hlDQo+ID4gPiAr
ZWNobyAzID4gL3Byb2Mvc3lzL3ZtL2Ryb3BfY2FjaGVzDQo+ID4gPiArDQo+ID4gPiArc25hcHNo
b3RfbWQ1PSQobWQ1c3VtICRzbmFwZGlyL2ZvbyB8IGN1dCAtZCcgJyAtZjEpDQo+ID4gPiArDQo+
ID4gPiAraWYgWyAiJG9yaWdpbmFsX21kNSIgIT0gIiRzbmFwc2hvdF9tZDUiIF07IHRoZW4NCj4g
PiA+ICsgICAgZWNobyAiRkFJTDogU25hcHNob3QgZGF0YSBjaGFuZ2VkIGFmdGVyIHB1bmNoIGhv
bGUgb3BlcmF0aW9ucyINCj4gPiA+ICsgICAgZWNobyAiT3JpZ2luYWwgbWQ1c3VtOiAkb3JpZ2lu
YWxfbWQ1Ig0KPiA+ID4gKyAgICBlY2hvICJTbmFwc2hvdCBtZDVzdW06ICRzbmFwc2hvdF9tZDUi
DQo+ID4gPiArZmkNCj4gPiA+ICsNCj4gPiA+ICtlY2hvICJTaWxlbmNlIGlzIGdvbGRlbiINCj4g
PiA+ICsNCj4gPiA+ICsjIHN1Y2Nlc3MsIGFsbCBkb25lDQo+ID4gPiArc3RhdHVzPTANCj4gPiA+
ICtleGl0DQo+ID4gPiBkaWZmIC0tZ2l0IGEvdGVzdHMvY2VwaC8wMDYub3V0IGIvdGVzdHMvY2Vw
aC8wMDYub3V0DQo+ID4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+ID4gaW5kZXggMDAwMDAw
MDAuLjY3NWMxYjdjDQo+ID4gPiAtLS0gL2Rldi9udWxsDQo+ID4gPiArKysgYi90ZXN0cy9jZXBo
LzAwNi5vdXQNCj4gPiA+IEBAIC0wLDAgKzEsMiBAQA0KPiA+ID4gK1FBIG91dHB1dCBjcmVhdGVk
IGJ5IDAwNg0KPiA+ID4gK1NpbGVuY2UgaXMgZ29sZGVuDQo+ID4gDQo+ID4gT25lIGlkZWEgaGFz
IGNyb3NzZWQgbXkgbWluZC4gSSB0aGluayB3ZSBuZWVkIHRvIGNoZWNrIHNvbWVob3cgdGhhdCBz
bmFwc2hvdHMNCj4gPiBzdXBwb3J0IGhhcyBiZWVuIGVuYWJsZWQuIE90aGVyd2lzZSwgSSBiZWxp
ZXZlIHRoYXQgdGVzdCB3aWxsIGZhaWwuIEJ1dCBpdCB3aWxsDQo+ID4gYmUgYmV0dGVyIHRvIGlu
Zm9ybSBhYm91dCBuZWNlc3NpdHkgdG8gZW5hYmxlIHRoZSBzbmFwc2hvdHMgc3VwcG9ydC4NCj4g
PiANCj4gPiBUaGFua3MsDQo+ID4gU2xhdmEuDQo+IA0KPiBPSywgSSdsbCBhZGQgdGhlIGZvbGxv
d2luZyBpbnRvIGNvbW1vbi9jZXBoDQo+IMKgDQo+ICsjIHRoaXMgdGVzdCByZXF1aXJlcyBjZXBo
IHNuYXBzaG90IHN1cHBvcnQNCj4gK19yZXF1aXJlX2NlcGhfc25hcHNob3QoKQ0KPiArew0KPiAr
IGxvY2FsIHRlc3Rfc25hcGRpcj0iJFRFU1RfRElSLy5zbmFwL3Rlc3Rfc25hcF8kJCINCj4gKyBt
a2RpciAiJHRlc3Rfc25hcGRpciIgMj4vZGV2L251bGwgfHwgX25vdHJ1biAiQ2VwaCBzbmFwc2hv
dHMgbm90IHN1cHBvcnRlZCAocmVxdWlyZXMgZnMgZmxhZyAnYWxsb3dfc25hcHMnIGFuZCBjbGll
bnQgYXV0aCBjYXBhYmlsaXR5ICdzbmFwJykiDQo+ICsgcm1kaXIgIiR0ZXN0X3NuYXBkaXIiDQo+
ICt9DQo+IMKgDQo+IGFuZCBhZGTCoA0KPiArX3JlcXVpcmVfY2VwaF9zbmFwc2hvdA0KPiBpbiBj
ZXBoLzAwNg0KPiDCoA0KPiBpcyB0aGlzwqBjaGVjayBhbmTCoGVycm9yIG1lc3NhZ2UgY2xlYXIg
ZW5vdWdoPw0KPiANCg0KTG9va3MgZ29vZC4gSSBiZWxpZXZlIGl0IGxvb2tzIHJlYXNvbmFibHkg
ZW5vdWdoLiA6KQ0KDQpUaGFua3MsDQpTbGF2YS4NCg==

