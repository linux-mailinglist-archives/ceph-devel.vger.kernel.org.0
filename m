Return-Path: <ceph-devel+bounces-2337-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D7E9F1780
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Dec 2024 21:43:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B71197A04D4
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Dec 2024 20:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82BCF191F62;
	Fri, 13 Dec 2024 20:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cc/QzfGV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74330175AB
	for <ceph-devel@vger.kernel.org>; Fri, 13 Dec 2024 20:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734122580; cv=fail; b=BlpjiVb3NkoYoEqrdF6CZvuOnVmQlyqY8wYawSAaBKcxJXDDe62pSpv4TkBm8mG/CvsSeRaw6linyc5QD0ZLyOaezGJLOa9ykTkA/GMEUasFg3hZdS7OCraUYUR/6W+PcNZTKEQNE5iAyu4dcPcTFa+Fp7+uOIbBQjXzNdw+b30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734122580; c=relaxed/simple;
	bh=vVeR8ygvEaE4wA52vB4X7L3J8affYsf51euWSNMiJHg=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PLzCFMTgRBtlJJuuoy65qfJFDW3dorOEE8W90qRckWEZN0tq82RU+ycq8yA0vqOSU54nL48/SvxCrB3j8ZbUxFPNel8C96gJSv5vpwFKbkZFYnXNxUunYILn39IZsa9VFaesTP0nqZLisWHliLRb4CYJub4a64csOBvWVDVlXe0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cc/QzfGV; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BDGfG3I026690;
	Fri, 13 Dec 2024 20:42:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=pp1; bh=vVeR8ygvEaE4wA52v
	B4X7L3J8affYsf51euWSNMiJHg=; b=cc/QzfGVQym//4nOSpmgz0DBFVXVS2Yxm
	VUGOEy+aAvG5E7rMFYwlQCfhC9aY0aGZX1kk630iQOeKLzX+bd5q1uFqnsYilesq
	vRGUpqE/2rFs26K4THBflRUEuHAHDJ5DJH1Og4jo1rYUYtVU4YBQkEvvR7T/w16B
	CApsOAu2QaS1I4ql0O0pYaNdFjjLx2fmvX379gPy0ejQyH/GhBQthX0pLjWfQqUo
	jOBdus8Yt2fKoAWE9hT9W3hnvqmjAtkm+8xz4y+sjH2mZsVORjtVAbddFvXPQVUx
	VoRVbCxUjzi/Q6o1FPJYfsuoVo9GeJvZQhQy5qa6ZrmjgVJGLsypw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43g9yhna5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Dec 2024 20:42:55 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4BDKdHMZ015742;
	Fri, 13 Dec 2024 20:42:55 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43g9yhna5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Dec 2024 20:42:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NTNRv/EvCQDGT0BvNImTxgag4zcBWakHCWwk6qikIbolLbbitZpU/+nevzFKLjeTVsx713rfTZKIzm91fWzsSS1agAdFTEVnQBGaivXbvhCnX/+ZXSdNrfX6otcodyC7B0+cKHU4P9df+sqvm/Wu6+FnDmbqrZpDrDz5IrZg81hdnq4FiLsp/w4aPR2L3Ctdu5ZMFvbcpo2JZT1RH/uYtZ365uiZIC0/juJAUJeVxSPyygWqPp2swcZoFmc1gjMVDReeYLFNIM/ip0baW6eSM+TkRgyLmXfjlMUZKNHMhNU0x50MlmYjYEN0z2MC65dCVLxOyxjXA0sDXUBhxZWUtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vVeR8ygvEaE4wA52vB4X7L3J8affYsf51euWSNMiJHg=;
 b=DBfEsebHYG39532tFRPct5Fy56PPVqjoZuBqNW2SevczZhl5KvjtnkBfLZqtDB71Y0+431jDQ2g2AbHts3Bqa7oBKfoxajpD+k7XKrnm4JX1zueHMmVhWmdd8jPD5dk4A0GGKjOtsI62IzTDWQsg1JfkCHAxvBqGWBU8+iefcWDvX83bgenPvkSjveJOdFBo3RR0iXAEi+lPw26Fm+oq/k8Y1eyFLitS8J3ma10IzrY0QaOJFViosz0qe5Y6wGqIybPutLL3a1ivj83SppO4hf+h86bNsN5HoW9s405ocD1xi1QQDFnqC9BKbrmStrkGZqWRrO58VDJM2/wYIX3nLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DS7PR15MB5327.namprd15.prod.outlook.com (2603:10b6:8:72::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.16; Fri, 13 Dec
 2024 20:42:51 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8251.015; Fri, 13 Dec 2024
 20:42:51 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "idryomov@gmail.com" <idryomov@gmail.com>,
        "jlayton@kernel.org"
	<jlayton@kernel.org>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: CAP_MSG_FIXED_FIELDS mistery
Thread-Topic: CAP_MSG_FIXED_FIELDS mistery
Thread-Index: AQHbTZ+TQSbfTbgaqEWcZxoWrHuCJA==
Date: Fri, 13 Dec 2024 20:42:51 +0000
Message-ID: <94bc9836f5feb9029459bcb863cb289a623eca5c.camel@ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DS7PR15MB5327:EE_
x-ms-office365-filtering-correlation-id: 9146427b-3d7a-424b-0fa5-08dd1bb6b65f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?anpValcxY3paT21OcVZzRmJUWjlpREJOUGlXazBhTUhxWFJ3aU1zT1VwWUJX?=
 =?utf-8?B?dE9peStDQkozZGVIY1BYTVNnWU5ab21XcUNvOEhxby9HN1ZDb2Vwb0thaVB2?=
 =?utf-8?B?SFFhdWQyU3pWMUFNcUVWVDhLLys1MmlhaGhyZkFUbEhyK3JMcHZ6Q1NKWEdB?=
 =?utf-8?B?QlFJbmVhVzZkQ1JwekFFZHUvRE9hWWlXVFZ5RzlnWTdkVEgyK29TaUMzMWtO?=
 =?utf-8?B?czVvR045eEpXVG1jOFhDTGE0ZkVESVhsbWhZZjF6ekFBcDZmcmpKU3d3NlF5?=
 =?utf-8?B?YVBaVGtDMzRHTFJsVlBCZHZUZ1RSbGdJdUgzbTluT3FSd0c0ZjFjWldsbTlt?=
 =?utf-8?B?UFRpNHU4eC9KSnJ3SGxGUjFxbmoyY0hRS0txbUNHZlZ3b0hRWjN0N1N6WUVt?=
 =?utf-8?B?NFdoK1B0T0MyemxZSVNPYUFLdGF1bTlGNGg4NnlJWlNsaW5aWVl5ZDFjaWNa?=
 =?utf-8?B?aEtYUFUrT1h4LzdlQUgyWHVNV0lQSnNvMUxzZmZ6ZFM0NVppYXVoVFkwWnR3?=
 =?utf-8?B?aEZuU1pNTU01emgwN2pMelN2TS9jUjBDVW5pamowRnRiKzVZRXJHQ0VRRXdv?=
 =?utf-8?B?eE1sL2JwNEw4WkdzTWJXK2N1dnlHRitFVEljQmxjWU1Pell3d3BveGRZR0Vx?=
 =?utf-8?B?dGVjcERMZm5ybytaSzQrQzQ0K2FLRU5iZFh3V1NnRjB1RzZjMUtiRW12a08r?=
 =?utf-8?B?S0U2K3JTcnRISnRhdHZTNVVLR0FJWjVGRXNNT29nMFpKRVFaT1JuTGRhNE9t?=
 =?utf-8?B?N2xUY09QSURWTk5FUFI4M1NXbGVxTXhxbHg5dUtwNzVTaUZQdkpkaEFOc1pp?=
 =?utf-8?B?SFB4Vi9MNE9QRHBYeFY1NU9DQXMxNTh0aEdzSmZaUWtsMExPV09HTG9vWTFy?=
 =?utf-8?B?M05nbUpKcTM2Z1hTeWtKTlhBT1RqTEJEWmdVc2J3UTBwbmVEckFRUG9qWXVk?=
 =?utf-8?B?VE9lbzNOZUlHL3BBcjVkaW83aDArdnhxVTZsRldPc25kR1NOekU0elc4ZUl5?=
 =?utf-8?B?NXVKdmtZTUY3dWptdjZrLzFxUm9JV3JnRXFPeDZvTmQxV05hVnVSMjRtNHcx?=
 =?utf-8?B?a0FvUk92TzhHVDlnbE56YzNMWUxIc3ZueWt5aGwvb2NJUkFMRzZlWVQ5RDBj?=
 =?utf-8?B?S1lJc1BJQXErdWdpVlphcEh6b1M2SWFoTUFHMUFISnpaSmdyMWZBRlh3UGJv?=
 =?utf-8?B?MmdUSTBCQVlWQXdrUE8yMVJVN1pISEo2QkJweXVzUG9IUitKd04vVllqRTFx?=
 =?utf-8?B?MFJOYWNsa2IxL3FwL2JkZDNTTkJYZXFhM3ZmdU1la2hPSklnQ3d6bUo5aWNL?=
 =?utf-8?B?U3RMdWMwTVY0bTVIVTczUThUckdlclZTU1cyeVF2RVN6dnBGMUQrYkxzVEti?=
 =?utf-8?B?THZHUWE1WGRmdFV0cHIzRUhwUW1hNGJnRkFSdExRSTJ2TXpJRDNycjkxbndz?=
 =?utf-8?B?dG16RDZjZXZBZ3RUc0xjU25LZzRRVGlRQjkwVnVWeW1OWDdBUXhDR0FBcDM5?=
 =?utf-8?B?TW1oSWppSUZMaFVxdkREOE5KbForYUNGaHVsdlZEdjd0cWhkazNhU3BHVVV6?=
 =?utf-8?B?c2FBc0w4NGU2M3FEdjVWUnRKOXp6c0VpY3k1dXVBM2lacWpmVXVuVWlpL0pv?=
 =?utf-8?B?c21kVkxNTXJ2Y2piQm9ZNnBXVklOVkx5RTBWVzQ3djFubEpFK3JuZndGRDBN?=
 =?utf-8?B?MWpUZzFxWlJuVXhFWnYyUEw1QXVzc2JyU1Jva3lTOERjaWpBYmRpOCtDR0Yx?=
 =?utf-8?B?YlZ3emE5cHNkaFpRTnprRnIwTXhmMXlFbllINWFxaCs5MWM5bURSeXBURnBC?=
 =?utf-8?Q?pP7aR6+6nMwXq+//6eR6/Xd6YzucfdJ6SUjgY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?L3M4ZE1vVjdyYXJ0eGJDMHBNbE91OVVEcStTd0lvRFZ4ZXhLcW96aTltZTJS?=
 =?utf-8?B?TklOb0R4bHVYRkU0dG8wd1ZERXptVkN2Rnhtd1ZTY3R0MFZIV3lUbUhya01W?=
 =?utf-8?B?cjNSMEVKM0JsMVlaQkpzSWY1bjVnenZXSytVRHdHSVh0cEZ4dCt1L3RpNVI0?=
 =?utf-8?B?d3lOWUFmNkRvWUtlNVBrUzVORHRaTUlIUjRxOEhmcmtrTVE0MkdFdEdidGN5?=
 =?utf-8?B?OFZrM2tFK0dTNWc0YUhwZlMyWXRnL1MvOGJWMTBuQW9UZXR3T080Z29mS2JO?=
 =?utf-8?B?YzB5VFQrSlgvOXFlOU16M3Y2eHQwZlRTVHVNeFA1TGZzQnV6VkFRdlVlR1U4?=
 =?utf-8?B?UW9Rcm5mVlBPMVZUcUtHT0Q3cnA4SVdBVGlIQk1SZTcydU9IK0E5bzdCMDlV?=
 =?utf-8?B?WDNxcXhSZWtXNnl2aldxWEhBcEZ6bWlRUjJ6cDF3dlNnNGFvSzl5dDBUdFNz?=
 =?utf-8?B?eW9Hc0lwb1g4alhrem5yaGxMMHZDY0ZLS2Q5M2QyQVdELzFkUUlVdXBuVmZp?=
 =?utf-8?B?M01YZEpEVlR3SysrV1B6Ry9XQnMrTnl6Rkl1VGRSellGa1d3VkxzRkQ2Q3Br?=
 =?utf-8?B?ODNOOTZYTlJHTGJVeTRBSnlDQ2kxcG0wZzg0dU1rb0dUWFgyWFprdklWWXVx?=
 =?utf-8?B?VmsyVUIxK2wzNEF1bVVKNDd2dnEwejgvRURENkhYeWF4NXI1cU5Ka3VndENB?=
 =?utf-8?B?OHQzRG5vNks1RnBwb1BKb1VMa1dLYWVFRGJVSkVRdDZXZEFjdnJ2NW9FZ3lN?=
 =?utf-8?B?OFNyNjc0RWN2ejFTNHpjbjZaUFlTSENqT01OVlU4YlNybFBGUXl1eTd6Rm9j?=
 =?utf-8?B?ZDk4Z0VrMytCNnc1TGxMaGh6Tm4xS2xYeGliS1N1WldWNE96d2Y0THlSZy9U?=
 =?utf-8?B?L1BseG9sVlpmOGNJekxEaitrRlptUWJ6TE9YVm1CU0tFMVZDQ3Zzd3RaNG5F?=
 =?utf-8?B?NGdlanVKV0w1TWpKR1JybTQybjFzVE1vZjFWaVhTTnZLRGhRWjNJbURpNExy?=
 =?utf-8?B?Q2liS2lYRlR3bVgrMnc4Wk5YR0R3VHJJdU1RMHRhR2dhL1FIVzg2QzVEZHZY?=
 =?utf-8?B?SHl3eWxrbjFGYXY5aStrWkFPL2ptTDRtZFRlbnFwaHlMZDBwcjQ3ME94SHdU?=
 =?utf-8?B?TFIraUoxS2pzSUZUNktSRWlOOFo5eFNqNmx3VmxEUkV3aVlaZlBIdTVWL2Iv?=
 =?utf-8?B?aEFWU3hpVkt3c3ZLcjdrQ2x6SnRScU1XemdSa0dHandvYVd0Zlo3czcwQlo1?=
 =?utf-8?B?ekcwcEdiTVRjWmN4K1QzeXVzS2ZHMEUyNXdYT3AxUjJTWnVRbXZsaGNyenZp?=
 =?utf-8?B?TXd6NEJQbUV6bzdpS2dXOUUvZVRvYkJEWnJNanhlS1IrdGRsMi91L1lISFg2?=
 =?utf-8?B?UWJJV0w3RHpyRUd4d0JYWml6T2ptbUZySnFRUmIyUnd6V2lKTkdrUGJteEZa?=
 =?utf-8?B?eEZ2OEV1NGl5T0lVU0JVaDFERTdXUzhFNjJTSDVFaWJyeHZCNDFiV3VQdThk?=
 =?utf-8?B?eFlhQnJTc0VNdjNuZXFNQXBOV0lEL2dIdGk4VjRWMER6akhTeEJGU3pnNHZn?=
 =?utf-8?B?ajhLamdtTmNLL3p3NlkwVzFubytlSGlYUkp3YXRjZUVkRTJCZEFkNGIwbVN0?=
 =?utf-8?B?elFlMEQ0UFVSNFliT1pnVk9iZ3JBb0NBNHo4NUpZdFhnUVp0RHQ0ZS9BMk5B?=
 =?utf-8?B?aCs4T1lkdUh0MFJuS29yOCs4WGltMnJwUFJFRHVTdDFLVFJXemFpdUJqOWtq?=
 =?utf-8?B?a0x1MFhGbUFzRlFYZjZEMGdINnAzT3hzbkZTcEoycUNtNFdqSXZ5dVVDRmFq?=
 =?utf-8?B?bXlhREV5YTNJM1Noc01YREsvb2Y5aWJPM0paUEY5V1F1L3ZVV0lXV2hrM1lo?=
 =?utf-8?B?MDNSUngyWkFsdU9IVTQ4TlBWbWh1ZDEwOFVDT3phckNsK2RGZWRyRjIydHdi?=
 =?utf-8?B?UThuQlNzQmRLRGNsbGVjTXRqMXB0RXpqRTBpUGtxbDhudnNXWFF6TE5udERi?=
 =?utf-8?B?Yk1IWGZBY21Gc2REYkd5NzdNUUYvWEZVbkY0UjBpVjJ0TkphYlc1VUFDa2Jy?=
 =?utf-8?B?YXJDeHZCSDUrNThSdGFZeHhjOWowbVhFdjNqSXVJNHRjZ3NTRkdGMWpUWFNX?=
 =?utf-8?B?MktZOFRtL1FYK2tldXlJcVpMY014WEtFcXJ4QWdIOUE4bG51TkorS1FrVklH?=
 =?utf-8?Q?R44Tj3S3JSWBs8RwPlh1oM0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C03199D4CBF60E4BBF29F593C3E2BCCF@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9146427b-3d7a-424b-0fa5-08dd1bb6b65f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2024 20:42:51.3978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y4HPdDx/TnRTmmCcDktq1rDUUuhwJf2d5posnOeU5y72FftjlT6kTGiMQmZjRfTl/9v2dvdsCFanW77a9TPi7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR15MB5327
X-Proofpoint-GUID: _4YL6MWuyNC3-JiPLYFuSUWCGz9OY9l2
X-Proofpoint-ORIG-GUID: Pauk4fZMpETkE01iMiSvq8NphG_31FE5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 priorityscore=1501 spamscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412130146

SGVsbG8sDQoNCkkgYW0gdHJ5aW5nIHRvIHVuZGVyc3RhbmQgQ0FQX01TR19GSVhFRF9GSUVMRFMg
ZGVmaW5pdGlvbiBtZWFuaW5nLg0KQ3VycmVudGx5LCB3ZSBoYXZlIHRoZSAibXlzdGVyaW91cyIg
ZGVmaW5pdGlvbiBbMV06DQoNCiNpZiBJU19FTkFCTEVEKENPTkZJR19GU19FTkNSWVBUSU9OKQ0K
I2RlZmluZSBDQVBfTVNHX0ZJWEVEX0ZJRUxEUyAoc2l6ZW9mKHN0cnVjdCBjZXBoX21kc19jYXBz
KSArIFwNCgkJICAgICAgNCArIDggKyA0ICsgNCArIDggKyA0ICsgNCArIDQgKyA4ICsgOCArIDQg
KyA4ICsNCjggKyA0ICsgNCArIDgpDQoNCjxza2lwcGVkPg0KDQojZWxzZQ0KI2RlZmluZSBDQVBf
TVNHX0ZJWEVEX0ZJRUxEUyAoc2l6ZW9mKHN0cnVjdCBjZXBoX21kc19jYXBzKSArIFwNCgkJICAg
ICAgNCArIDggKyA0ICsgNCArIDggKyA0ICsgNCArIDQgKyA4ICsgOCArIDQgKyA4ICsNCjggKyA0
ICsgNCkNCg0KQXMgZmFyIGFzIEkgY2FuIHNlZSwgdGhpcyBjb21taXQgaW50cm9kdWNlZCB0aGUg
dmVyeSBmaXJzdCBkZWZpbml0aW9uOg0KDQpjb21taXQgZTIwZDI1OGQ3M2E4ZDU2NWI3MjliNmZj
MDI5MGUwNjBkYWFiZDhiOA0KQXV0aG9yOiBZYW4sIFpoZW5nIDx6eWFuQHJlZGhhdC5jb20+DQpE
YXRlOiAgIEZyaSBOb3YgMTQgMjI6Mzk6MTMgMjAxNCArMDgwMA0KDQogICAgY2VwaDogZmx1c2gg
aW5saW5lIHZlcnNpb24NCiAgICANCiAgICBBZnRlciBjb252ZXJ0aW5nIGlubGluZSBkYXRhIHRv
IG5vcm1hbCBkYXRhLCBjbGllbnQgbmVlZCB0byBmbHVzaA0KICAgIHRoZSBuZXcgaV9pbmxpbmVf
dmVyc2lvbiAoQ0VQSF9JTkxJTkVfTk9ORSkgdG8gTURTLiBUaGlzIGNvbW1pdA0KbWFrZXMNCiAg
ICBjYXAgbWVzc2FnZXMgKHNlbnQgdG8gTURTKSBjb250YWluIGlubGluZV92ZXJzaW9uIGFuZCBp
bmxpbmVfZGF0YS4NCiAgICBDbGllbnQgYWx3YXlzIGNvbnZlcnRzIGlubGluZSBkYXRhIHRvIG5v
cm1hbCBkYXRhIGJlZm9yZSBkYXRhDQp3cml0ZSwNCiAgICBzbyB0aGUgaW5saW5lIGRhdGEgbGVu
Z3RoIHBhcnQgaXMgYWx3YXlzIHplcm8uDQogICAgDQogICAgU2lnbmVkLW9mZi1ieTogWWFuLCBa
aGVuZyA8enlhbkByZWRoYXQuY29tPg0KDQoJLyogZmxvY2sgYnVmZmVyIHNpemUgKyBpbmxpbmUg
dmVyc2lvbiArIGlubGluZSBkYXRhIHNpemUgKi8NCglleHRyYV9sZW4gPSA0ICsgOCArIDQ7DQoN
Ck5leHQgY29tbWl0IGFkZHMgYW5vdGhlciBjb25zdGFudCBpbnRvIHRoZSBlcXVhdGlvbjoNCg0K
Y29tbWl0IGEyOTcxYzhjY2I5YmQ3Njc3YTZjNDNjZGJlZDlhYWNmZWY1ZTlmMjYNCkF1dGhvcjog
WWFuLCBaaGVuZyA8enlhbkByZWRoYXQuY29tPg0KRGF0ZTogICBXZWQgSnVuIDEwIDExOjA5OjMy
IDIwMTUgKzA4MDANCg0KICAgIGNlcGg6IHNlbmQgVElEIG9mIHRoZSBvbGRlc3QgcGVuZGluZyBj
YXBzIGZsdXNoIHRvIE1EUw0KICAgIA0KICAgIEFjY29yZGluZyB0byB0aGlzIGluZm9ybWF0aW9u
LCBNRFMgY2FuIHRyaW0gaXRzIGNvbXBsZXRlZCBjYXBzDQpmbHVzaA0KICAgIGxpc3QgKHdoaWNo
IGlzIHVzZWQgdG8gZGV0ZWN0IGR1cGxpY2F0ZWQgY2FwIGZsdXNoKS4NCiAgICANCiAgICBTaWdu
ZWQtb2ZmLWJ5OiBZYW4sIFpoZW5nIDx6eWFuQHJlZGhhdC5jb20+DQoNCgkvKiBmbG9jayBidWZm
ZXIgc2l6ZSArIGlubGluZSB2ZXJzaW9uICsgaW5saW5lIGRhdGEgc2l6ZSArDQoJICogb3NkX2Vw
b2NoX2JhcnJpZXIgKyBvbGRlc3RfZmx1c2hfdGlkICovDQoJZXh0cmFfbGVuID0gNCArIDggKyA0
ICsgNCArIDg7DQoNClRoaXMgY29tbWl0IGFkZGVkIGFub3RoZXIgY29uc3RhbnRzIGludG8gdGhl
IGVxdWF0aW9uIGJ1dCBjb21tZW50DQpoYXNuJ3QgYmVlbiB1cGRhdGVkOg0KDQpjb21taXQgNDNi
Mjk2NzMzMDczODdmN2I5MzlmY2VlZWRlZmQwOGVjZTEzYzQxZA0KQXV0aG9yOiBKZWZmIExheXRv
biA8amxheXRvbkBrZXJuZWwub3JnPg0KRGF0ZTogICBUaHUgTm92IDEwIDA3OjQyOjA1IDIwMTYg
LTA1MDANCg0KICAgIGNlcGg6IHVwZGF0ZSBjYXAgbWVzc2FnZSBzdHJ1Y3QgdmVyc2lvbiB0byAx
MA0KICAgIA0KICAgIFRoZSB1c2VybGFuZCBjZXBoIGhhcyBNQ2xpZW50Q2FwcyBhdCBzdHJ1Y3Qg
dmVyc2lvbiAxMC4gVGhpcyBicmluZ3MNCnRoZQ0KICAgIGtlcm5lbCB1cCB0aGUgc2FtZSB2ZXJz
aW9uLg0KICAgIA0KICAgIEZvciBub3csIGFsbCBvZiB0aGUgdGhlIG5ldyBzdHVmZiBpcyBzZXQg
dG8gZGVmYXVsdCB2YWx1ZXMNCmluY2x1ZGluZw0KICAgIHRoZSBmbGFncyBmaWVsZCwgd2hpY2gg
d2lsbCBiZSBjb25kaXRpb25hbGx5IHNldCBpbiBhIGxhdGVyIHBhdGNoLg0KICAgIA0KICAgIE5v
dGUgdGhhdCB3ZSBkb24ndCBuZWVkIHRvIHNldCB0aGUgY2hhbmdlX2F0dHIgYW5kIGJ0aW1lIHRv
DQphbnl0aGluZw0KICAgIHNpbmNlIHdlIGFyZW4ndCBjdXJyZW50bHkgc2V0dGluZyB0aGUgZmVh
dHVyZSBmbGFnLiBUaGUgTURTIHNob3VsZA0KICAgIGlnbm9yZSB0aG9zZSB2YWx1ZXMuDQogICAg
DQogICAgU2lnbmVkLW9mZi1ieTogSmVmZiBMYXl0b24gPGpsYXl0b25AcmVkaGF0LmNvbT4NCiAg
ICBSZXZpZXdlZC1ieTogWWFuLCBaaGVuZyA8enlhbkByZWRoYXQuY29tPg0KDQoJLyogZmxvY2sg
YnVmZmVyIHNpemUgKyBpbmxpbmUgdmVyc2lvbiArIGlubGluZSBkYXRhIHNpemUgKw0KCSAqIG9z
ZF9lcG9jaF9iYXJyaWVyICsgb2xkZXN0X2ZsdXNoX3RpZCAqLw0KCWV4dHJhX2xlbiA9IDQgKyA4
ICsgNCArIDQgKyA4Ow0KCWV4dHJhX2xlbiA9IDQgKyA4ICsgNCArIDQgKyA4ICsgNCArIDQgKyA0
ICsgOCArIDggKyA0Ow0KDQpUaGlzIGNvbW1pdCBpbnRyb2R1Y2VkIHRoZSBkZWRpY2F0ZWQgZGVm
aW5pdGlvbiBmb3IgdGhlIHdob2xlIGVxdWF0aW9uOg0KDQpjb21taXQgMTZkNjg5MDNmNTZhZTI3
NzQ0NmNjMmQyNGFiMThkYjgzNTM2M2VkYQ0KQXV0aG9yOiBKZWZmIExheXRvbiA8amxheXRvbkBr
ZXJuZWwub3JnPg0KRGF0ZTogICBNb24gTWFyIDMwIDA3OjIwOjI3IDIwMjAgLTA0MDANCg0KICAg
IGNlcGg6IGJyZWFrIHVwIHNlbmRfY2FwX21zZw0KICAgIA0KICAgIFB1c2ggdGhlIGFsbG9jYXRp
b24gb2YgdGhlIG1zZyBhbmQgdGhlIHNlbmQgaW50byB0aGUgY2FsbGVyLiBSZW5hbWUNCiAgICB0
aGUgZnVuY3Rpb24gdG8gZW5jb2RlX2NhcF9tc2cgYW5kIG1ha2UgaXQgdm9pZCByZXR1cm4uDQog
ICAgDQogICAgU2lnbmVkLW9mZi1ieTogSmVmZiBMYXl0b24gPGpsYXl0b25Aa2VybmVsLm9yZz4N
CiAgICBTaWduZWQtb2ZmLWJ5OiBJbHlhIERyeW9tb3YgPGlkcnlvbW92QGdtYWlsLmNvbT4NCg0K
DQogKiBjYXAgc3RydWN0IHNpemUgKyBmbG9jayBidWZmZXIgc2l6ZSArIGlubGluZSB2ZXJzaW9u
ICsgaW5saW5lIGRhdGENCnNpemUgKw0KICogb3NkX2Vwb2NoX2JhcnJpZXIgKyBvbGRlc3RfZmx1
c2hfdGlkDQogKi8NCg0KI2RlZmluZSBDQVBfTVNHX1NJWkUgKHNpemVvZihzdHJ1Y3QgY2VwaF9t
ZHNfY2FwcykgKyBcDQoJCSAgICAgIDQgKyA4ICsgNCArIDQgKyA4ICsgNCArIDQgKyA0ICsgOCAr
IDggKyA0KSANCg0KRmluYWxseSwgdGhpcyBjb21taXQgcmVtb3ZlIGNvbW1lbnQgKyBDQVBfTVNH
X1NJWkUsIGFuZCBpbnRyb2R1Y2VzIGENCm5ldyBkZWZpbml0aW9uIHdpdGhvdXQgYW55IGNvbW1l
bnQ6DQoNCmNvbW1pdCAyZDMzMmQ1YmM0MjQ0MDQ5MTE1NDAwMDZhOGJiNDUwZmJiOTZiMTc4DQpB
dXRob3I6IEplZmYgTGF5dG9uIDxqbGF5dG9uQGtlcm5lbC5vcmc+DQpEYXRlOiAgIE1vbiBKdWwg
MjcgMTA6MTY6MDkgMjAyMCAtMDQwMA0KDQogICAgY2VwaDogZnNjcnlwdF9hdXRoIGhhbmRsaW5n
IGZvciBjZXBoDQogICAgDQogICAgTW9zdCBmc2NyeXB0LWVuYWJsZWQgZmlsZXN5c3RlbXMgc3Rv
cmUgdGhlIGNyeXB0byBjb250ZXh0IGluIGFuDQp4YXR0ciwNCiAgICBidXQgdGhhdCdzIHByb2Js
ZW1hdGljIGZvciBjZXBoIGFzIHhhdHRzIGFyZSBnb3Zlcm5lZCBieSB0aGUgWEFUVFINCmNhcCwN
CiAgICBidXQgd2UgcmVhbGx5IHdhbnQgdGhlIGNyeXB0byBjb250ZXh0IGFzIHBhcnQgb2YgdGhl
IEFVVEggY2FwLg0KICAgIA0KICAgIEJlY2F1c2Ugb2YgdGhpcywgdGhlIE1EUyBoYXMgYWRkZWQg
dHdvIG5ldyBpbm9kZSBtZXRhZGF0YSBmaWVsZHM6DQogICAgZnNjcnlwdF9hdXRoIGFuZCBmc2Ny
eXB0X2ZpbGUuIFRoZSBmb3JtZXIgaXMgdXNlZCB0byBob2xkIHRoZQ0KY3J5cHRvDQogICAgY29u
dGV4dCwgYW5kIHRoZSBsYXR0ZXIgaXMgdXNlZCB0byB0cmFjayB0aGUgcmVhbCBmaWxlIHNpemUu
DQogICAgDQogICAgUGFyc2UgbmV3IGZzY3J5cHRfYXV0aCBhbmQgZnNjcnlwdF9maWxlIGZpZWxk
cyBpbiBpbm9kZSB0cmFjZXMuIEZvcg0Kbm93LA0KICAgIHdlIGRvbid0IHVzZSBmc2NyeXB0X2Zp
bGUsIGJ1dCBmc2NyeXB0X2F1dGggaXMgdXNlZCB0byBob2xkIHRoZQ0KZnNjcnlwdA0KICAgIGNv
bnRleHQuDQogICAgDQogICAgQWxsb3cgdGhlIGNsaWVudCB0byB1c2UgYSBzZXRhdHRyIHJlcXVl
c3QgZm9yIHNldHRpbmcgdGhlDQpmc2NyeXB0X2F1dGgNCiAgICBmaWVsZC4gU2luY2UgdGhpcyBp
cyBub3QgYSBzdGFuZGFyZCBzZXRhdHRyIHJlcXVlc3QgZnJvbSB0aGUgVkZTLA0Kd2UgYWRkDQog
ICAgYSBuZXcgZmllbGQgdG8gX19jZXBoX3NldGF0dHIgdGhhdCBjYXJyaWVzIGNlcGgtc3BlY2lm
aWMgaW5vZGUNCmF0dHJzLg0KICAgIA0KICAgIEhhdmUgdGhlIHNldF9jb250ZXh0IG9wIGRvIGEg
c2V0YXR0ciB0aGF0IHNldHMgdGhlIGZzY3J5cHRfYXV0aA0KdmFsdWUsDQogICAgYW5kIGdldF9j
b250ZXh0IGp1c3QgcmV0dXJuIHRoZSBjb250ZW50cyBvZiB0aGF0IGZpZWxkIChzaW5jZSBpdA0K
c2hvdWxkDQogICAgYWx3YXlzIGJlIGF2YWlsYWJsZSkuDQogICAgDQogICAgU2lnbmVkLW9mZi1i
eTogSmVmZiBMYXl0b24gPGpsYXl0b25Aa2VybmVsLm9yZz4NCiAgICBSZXZpZXdlZC1ieTogWGl1
Ym8gTGkgPHhpdWJsaUByZWRoYXQuY29tPg0KICAgIFJldmlld2VkLWFuZC10ZXN0ZWQtYnk6IEx1
w61zIEhlbnJpcXVlcyA8bGhlbnJpcXVlc0BzdXNlLmRlPg0KICAgIFJldmlld2VkLWJ5OiBNaWxp
bmQgQ2hhbmdpcmUgPG1jaGFuZ2lyQHJlZGhhdC5jb20+DQogICAgU2lnbmVkLW9mZi1ieTogSWx5
YSBEcnlvbW92IDxpZHJ5b21vdkBnbWFpbC5jb20+DQoNCiNkZWZpbmUgQ0FQX01TR19GSVhFRF9G
SUVMRFMgKHNpemVvZihzdHJ1Y3QgY2VwaF9tZHNfY2FwcykgKyBcDQoJCSAgICAgIDQgKyA4ICsg
NCArIDQgKyA4ICsgNCArIDQgKyA0ICsgOCArIDggKyA0ICsgOCArDQo4ICsgNCArIDQpDQoNClNv
LCBhcyBmYXIgYXMgSSBjYW4gZm9sbG93Og0KDQo0ICsgOCArIDQgKyA0ICsgOCBtZWFuczoNCg0K
KDEpIGZsb2NrIGJ1ZmZlciBzaXplIC0+IDQNCigyKSBpbmxpbmUgdmVyc2lvbiAtPiA4DQooMykg
aW5saW5lIGRhdGEgc2l6ZSAtPiA0DQooNCnCoG9zZF9lcG9jaF9iYXJyaWVyIC0+IDQNCig1KSBv
bGRlc3RfZmx1c2hfdGlkIC0+IDgNCg0KQnV0IHdoYXQgZG9lcyBpdCBtZWFuIHRoZSByZXN0IG9m
IHRoZSBmb3JtdWxhOiA0ICsgNCArIDQgKyA4ICsgOCArIDQgKw0KOCArIDg/DQoNClRoYW5rcywN
ClNsYXZhLg0KDQpbMV0NCmh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L3Y2LjEzLXJj
Mi9zb3VyY2UvZnMvY2VwaC9jYXBzLmMjTDE0OTgNCg0KDQo=

