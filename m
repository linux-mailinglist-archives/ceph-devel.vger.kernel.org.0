Return-Path: <ceph-devel+bounces-4268-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3396DCFB0A5
	for <lists+ceph-devel@lfdr.de>; Tue, 06 Jan 2026 22:09:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7823D3033D44
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jan 2026 21:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3419828B4FE;
	Tue,  6 Jan 2026 21:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eC2rwEVi"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341EA7E0FF;
	Tue,  6 Jan 2026 21:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767733741; cv=fail; b=BC7DAjsIDkSykRnz7vs5/QdC+qR/ENfJkBKpyO3jFFRGh5Who0I6HDdz2vqWaw0eJhowp7b0s8HCfOdJB1Belnp+imLwdlT07MGoQwhr73tYKSNhWP0WUZ5WwT5vKt2327VQsmwwxi02SeI3GEw3JYq9Q6GP4eukVKSYmHNui0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767733741; c=relaxed/simple;
	bh=WrOl1739gzucKv9hh/XzTGc+6sHtbkQqKjQV1n2ROiQ=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=dauRajsuriHFyxrxtiHNWiDXZampg/2xPhIm7WGqkiskQXdoEHOjzyzxMiJzfT9L/IezWZYQjTsUYlW3Rgrh3qoO3nlXmDVnsS5zhQfyjcMq4ZL5+dQw8JL+2vb58YoXE5xxAJr/yz4Pmfub5NPEkthzfaUlCdHmo9a0xsJIiVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eC2rwEVi; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 606GXmWT020194;
	Tue, 6 Jan 2026 21:08:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=WrOl1739gzucKv9hh/XzTGc+6sHtbkQqKjQV1n2ROiQ=; b=eC2rwEVi
	HX4vcRbgVVOunpr9/O/DxmDl/SXTX4TTIzYl2LGRvjL3otonECq7Q/0V2IfAurCS
	nUzUIg3BKFZTJbX19Mu/0qMO5A6t7m4cbzJrwQEXx/zTzYHQ/NoX3drdkWWTUQ3c
	KozwG8716WNK9FrM1QhyJc2fQR90AVVp+NPOaBuUwJY1zonLPS0iQFBHES9mgotT
	rcf0BsamP2Ll/7kEpAsA57Wi+2tbxW3m64wxMESgbX79BI1ezz/3jp+zqEI6Qej/
	qPYg3teVizun9p1sPzFya1iYwg8hvG/bGrz2aGZnJJOH9tZxrG9l6h4YLlK+8Msn
	b9RjDahvk6/BUw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betrtmwtg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jan 2026 21:08:54 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 606L2t1p017700;
	Tue, 6 Jan 2026 21:08:54 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013030.outbound.protection.outlook.com [40.107.201.30])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betrtmwte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jan 2026 21:08:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OKAvez+yCLnycIXeAVAS/mnXZ90rciPOOWDfp3AIUK8EpMUY2LkDvT6AS1/BXgIln+8+F5B22b6Fxp4S8GHEhovTbtU8qAAvbEuPvFNsWh66oQaNvTLM75sl1VYpWcdJi19qaKh19Kt6Pg8eFgrIku2hqFuqPhjkV3fO9Z/X9666EHmRZFxAhmYB5IH2tnQy+HEZgkJY7prqVqhJvVGp1uhtUjDJftI/ftEIQX/t31hd59zk4ym9Xp+Vux/eJp1UKW+X4yr8Cb7yrTOG5u3GnMnImpSZMotnwDktHdAoQ4FLs009ENdL/kNEPvgC6IdzO7UasvXI1WqS0nMXV6YS+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WrOl1739gzucKv9hh/XzTGc+6sHtbkQqKjQV1n2ROiQ=;
 b=uawFSdixYsu32jhEAQ+LFywtBkhDkiNBpRFiHrQAZaH1XQdCFwPdNSarkzRM/NYk5w0MGe/0kEtYS5CUA8OSmY3LXB3xr0S9klg5FAcvCMAtoPqOcOQYLuqbqlaJ4c2PSdJglHdDFNqzNKKUtGfEE+fJSLBCInycL1kQaUErQR2EJJEl63p7GJxEpYg3yOYEZ083qV7zaDWObY9wlzb0KzW7nZ9/DdGHpwK8HayqwyqifX4YdJhv4KZdF+cn0BQoRRQJhOoI/zSEQrDBKaqrkwshhZt3pZS2GvfGPMM+UiGHgzYp5ETT7cf16cSQ7hnTvAg+BVkcLMrDwH/ChcF2tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA1PR15MB4529.namprd15.prod.outlook.com (2603:10b6:806:198::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 21:08:51 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 21:08:51 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "cfsworks@gmail.com" <cfsworks@gmail.com>
CC: Xiubo Li <xiubli@redhat.com>, "brauner@kernel.org" <brauner@kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        Milind Changire
	<mchangir@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [PATCH 1/5] ceph: Do not propagate page array
 emplacement errors as batch errors
Thread-Index: AQHcftkETfUWtDf340ma29eoQrJr1bVFo50A
Date: Tue, 6 Jan 2026 21:08:51 +0000
Message-ID: <8d8860371bcf4db044a8e1559b674189996c0790.camel@ibm.com>
References: <20251231024316.4643-1-CFSworks@gmail.com>
	 <20251231024316.4643-2-CFSworks@gmail.com>
	 <24adfb894c25531d342fdc20310ca9286d605e3d.camel@ibm.com>
	 <CAH5Ym4gHTNDVCiy5YQwQwg_JmBt=UKgoui9RzUcBgv6Vr-ezZw@mail.gmail.com>
In-Reply-To:
 <CAH5Ym4gHTNDVCiy5YQwQwg_JmBt=UKgoui9RzUcBgv6Vr-ezZw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA1PR15MB4529:EE_
x-ms-office365-filtering-correlation-id: 23b738d1-9fa6-4777-8a98-08de4d67caf9
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?cmVaTVlVanNhbnJ6QkhEcFluclRQeFAycFB3amNqV0REakYzQ2JvWnEyRFFH?=
 =?utf-8?B?ZXAxclZjMS81Zk9Zdkd5Y3hNcWZyTjUyK0V1TlpWM1VyZmxBdlc2S2d2UHlZ?=
 =?utf-8?B?UmRXRmVmeVZ1Y0VSeHB6MjdqNXVqUEpHMEFXRklTVi9odzBuaEd4RkJFbnNy?=
 =?utf-8?B?VDlKVlc0SDNmZ0VRVnFkSm5XZWQrZUlJYTdkbDUwQ0k2RFpwWnBXNkp4SDY5?=
 =?utf-8?B?N2QyV0gyOTR3RE9mWWducjJvUGUxMHdmMi9ja1daWCtwNFNzbHZ1Y00wQWh5?=
 =?utf-8?B?bUFVakpTcE4zeHhWYU9udVdHazVDeUFKTFEyUUJUMUs1ZllWcVJrbDdwNG1p?=
 =?utf-8?B?ZFd5NGcxTjVRNzM0Z2FESzNESHRpZDg0U0lLeStsVkwxNVl0aStMRmZEWFZy?=
 =?utf-8?B?SUZkWmkvR2VZbCtKNDdncWVWU3J1cjZLSG1uQzBFM2o1bXF1V25MY1lEbDZh?=
 =?utf-8?B?OWpHQjI0QktVOGhReGJTUXMrY0p1WXIyWUhtWm1HOFk5MDY4WEN1Y3pwRkZh?=
 =?utf-8?B?Um5qZ3FaUDNXN0puZ1BrNjM3MUVPQitJZTVNbUdtUzg5Tm0yMkJTcGx1clJX?=
 =?utf-8?B?OGlzQmFiZTlGT0xkRzRZczRPbnRJOFo1aENZenJBUW41Q3RQV0FjV3BWRWYz?=
 =?utf-8?B?WHp4bGlMQTFVVEtpVW9ma2VhOGNsOXY0U0YyblYwa3VlR1VKNHZSSEUrMDB0?=
 =?utf-8?B?Tml2bWQ0ZWNBT1pKbDFISnB1SUNOWllTTUNjQnBCczdLV3VpUEE3aENNeVNq?=
 =?utf-8?B?NUY4dlFGcGt6elJwOENwbGg0WURRaWplaXhoR1pHd25GT3NIQVJMNFZGbWNX?=
 =?utf-8?B?WXIraktITHNRZnExbmluVytZdlFqMTFhSUVVck1MTWVQM2J2VllPbTJUdVJZ?=
 =?utf-8?B?MTE1WUltdVZ5L2pzdUZQdUpSUVM1anN1Tzc1NXpaMmRYVm9iZkVta0NJUVE4?=
 =?utf-8?B?bDA5R3dTOC9IV1ErTGFlWlU3a0twZGRyeURKanZqaEdoc2NXZjdwL0hBQitM?=
 =?utf-8?B?ZnhSTEc2Mm95N3hUOFlBU0FhY0dVdkE0MDN1dm1JditkMDVPc0MveEhnaUx0?=
 =?utf-8?B?cUJLcUtCaVQ3YmNZZnRqUnBKNFpyY01jekRKU2Q2dHlpVUlWZVgzdlJnTWkx?=
 =?utf-8?B?TUx3STdtY21UNklJU0dvdzhoRHIveUZtVXA3OGpTSkF2THk5K3ZKL2VLSEFL?=
 =?utf-8?B?YlI2MitoeWxtSndESVRDaTNLU0loajdZcmdCY2lRbE9CYThYSWowRXowaGk1?=
 =?utf-8?B?a1BQS0luQ1djZ1FaRWJEZy9VMytTOVdYZ3haWmNtQ25XTXNCS3IxWXFuMlZC?=
 =?utf-8?B?cythR2dLWWx2cVlNQXhUcXBwb1Zla3dCUXMyZEdTWWZ4MGtjOVJNY1EyMHZz?=
 =?utf-8?B?NkNJRkx4SU85SDZQaGtleUVjYWs1WlJkRHpaVXRhZEt0dmp5V01nSjYvbGNs?=
 =?utf-8?B?WWhrdWI2YnMzcDhhREJkN3BRQ1YwTjEyWVpYODBVbkYzSmdCTjV5cG91MXA4?=
 =?utf-8?B?N2U2cHNCaTR3b0lqWWNYZHd3U3RZLzN3SFFqeWw0cC9GMTVPQWZ6QjZDQi92?=
 =?utf-8?B?TldaaUdENG9OcXYvNFJjMzFwa3VhVGt2VzBXK0NVd1NHNU1tYlk0ZTZiMThv?=
 =?utf-8?B?ZE5KZkNhUDdFNHgzOTlNU2xja0Vpa3dLYzRpU2JwaGpyek9JNXg4a2YwaDM2?=
 =?utf-8?B?Ny9Qb1pQdWpmTldIQ3RsWXRia05XSmRnVTVYdCs0RmpSTWRxNWlTeHVjZCtk?=
 =?utf-8?B?VzR3U2pqVTZ0TWwyL280ZTZNZ3ZMajNPaUpTUmdRV0EwOTdoSFRDcHQ1a2dG?=
 =?utf-8?B?TEFvb1NFK2UxWVVjUDh0SjdIYVB0OEhYRUFnY3Y0cnRUUUFucGFJUHNXY0Ja?=
 =?utf-8?B?NkdsdElDWFppUlU4TENOR3FLYVVON2lxTDBqM0RGa1JCS0lxUytsc2laY2Nl?=
 =?utf-8?B?bStkWWIreUxDUG9JWm9Da2Z6TGZwZjlaVGEzblRYaitSS1M2TUtjSnBPenVm?=
 =?utf-8?B?am9tVUNzRGhqd3ZqL3JJZGtKNVZyOGtPNm8wTFBvRWVLSWZoVHltV0RVcmpW?=
 =?utf-8?Q?tGnL19?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Um44d0dZUld6TXNma3kzeU1vQ3ZKbUFWMTNqbEptS2VnZWxETktTUkVwOG5U?=
 =?utf-8?B?OWxEVDVVazFEajlhYm1pZkJLc3dsbnJJc0pKOW56bkdtMG5vOEk3cExPcHcz?=
 =?utf-8?B?MjdEbXY1cjNVOThwdUtYd3h5THZpa0Q4a0JXQjVyRG84eGpTV1RVVDcwN0pj?=
 =?utf-8?B?L3hXeW53U0hCVEhoVVoycTZoR3ZrN2FFNUtsQ1NGRE90Rk5leTY4V0Z3Zm1C?=
 =?utf-8?B?c0ludFlwcjBYN3gzUitWdlp1L1RvSEMzRmZIL3hsbDBmellCQVo1ekNCckVy?=
 =?utf-8?B?dG9TT25TdEg0eTdISzdIc0xMNjFrVjhTZGhWdkdPeFBsc05VYmhpa2lOdVdy?=
 =?utf-8?B?WGkyTnZ1MmVGZGFvbnlyb2grTnZGa2p4MCtya2M1UllXUXBPMGUvejcxd085?=
 =?utf-8?B?RTRGYUU0Szd5Zmo5LzhxcndvclloamN0Z2I0eG5kQzNkZlJ3VFJTcC9tYUh6?=
 =?utf-8?B?SlVIQ2sydUN2M0NUaU9lb05USXpPbHJYbWs3TTJBODdSSVkxQWM2Z2cyRjBO?=
 =?utf-8?B?QjR5OUJ6a3ljaFY4K0dleTI1UDFpVUNzclZNaEVqV3RPMHNkbzdRU3R5S1NJ?=
 =?utf-8?B?R29GYkl1dFdHNlp0ckxhRXFoTzAvcGY3bFp3THBlcVFzbzBkcG4vbzhXU1M2?=
 =?utf-8?B?SUM2ZU91dlZaR3FEVVVVTCtudVo5ekl2MGVsblpsRHNjcnRLVE9XdFg4djAz?=
 =?utf-8?B?elhFYjJJdHh6U2QwQjZGeGErQk9EazdTdHdiL3lKYnVNWUMvOUpZcU9mU2tq?=
 =?utf-8?B?NWYxaUtnTTZIMkJsUTA3b1hFMkRTQVZMR0FjU2haMG5CTUtsTmJrU3FzTHll?=
 =?utf-8?B?akVHUEFNOThYcGFjSVJFMUZ1WFlqTDJUelJ5UjF3Y1pTQmR5bXovREVEWWJB?=
 =?utf-8?B?ZXUzdloxM1lvOENXdWV2U0Yxb1VFazlrS3l6YTVZZW9hd0libGVJMndQUEc4?=
 =?utf-8?B?WFBzbFo0Z3Y0NEVmWENWcWJaV0plajNqNE0waHdCZjVTQWRjZXR6dHFKai9P?=
 =?utf-8?B?Z1F5K1Nrd0dNQmdYd3pST1IwK0pKTzYvWHEyZWdjVFZKaE1tM2JRRjdxNjFY?=
 =?utf-8?B?dSsvNncwbGFjczVqR1Bld2tWSmJzSTk3UGdxWWp3aGlZV3FlYjlVTVp0Y2p2?=
 =?utf-8?B?cjA0Q0diSFRiM1ZGdG9KaEpvMlo2eGRZcUV4YWNFSFZsd1hncjUrYTUwUk5q?=
 =?utf-8?B?NmZHbUR4SXQreWd1SzFXL0RUOGFkZ0ovMEpoUHJoSTJCVWhYMEF4a1VpbTR1?=
 =?utf-8?B?bk9Pb3N2REdvdDhKUmVxSUF4K2ZNRU5ZQ1g4aDRNcHJjZXRPblMyQU9yYTAy?=
 =?utf-8?B?UlVmckxiZjg2WGM3KzlEbUVPUEtoUEwva0VTU1N5TGt3L0hlcm1YM2h5UHMr?=
 =?utf-8?B?QWpabFUzVEJ3YmxSblhSanY2elRJT2VOVHlQVmRwSElOWmtKdzl1WGVvelNR?=
 =?utf-8?B?Y0hjR3lFZnQwUGcyd0I3NVR6blZ5d2tVR0tlVVI1bEZwU3lCNE5UVTlxTFlJ?=
 =?utf-8?B?bzZabEdPSWxHWnVjV2s5V29NaHN5TFNLbnpDdXZqVkhJaGg4N1pqRkQxTU5J?=
 =?utf-8?B?WmZOYUhTM0pNVjZWS29xeGo5d2ovSldkY1l5aE5hS2RGTTlFK3dDWVBIby9G?=
 =?utf-8?B?cWp3VnBYbjdBcVBlRXVzb0xBZW81K2hoM093V0FNdFdpVUVsTG5BeWdtRTU1?=
 =?utf-8?B?SWNWYWlIcDJLMnl5VzhtNEs5bXVMQWI1VVFXMUhpL3dKb1ZMZTZLQTJPTFFJ?=
 =?utf-8?B?WjFZMURGNDc3cGYrZjNLUmJzclZ1S3Y4Vm9jMkdvbWw3b1RrQVZEYTh2WFdu?=
 =?utf-8?B?NXNydUZERmdvVUI5bDZKSER3WlJTVEhESEh2SGVsUFZXSk93SXczN2xibnVo?=
 =?utf-8?B?dlV1R1NtOEtSRG5BV1ozY0d1MTJDdkdRNFJCUWZGSzYxQkxWQ2cvV0Q3bTd1?=
 =?utf-8?B?blkrbWdEanFjTWQyZWhyeU1mNUZzcXZLZEpiT092TzZwUFM3czBTUnQ5VzNt?=
 =?utf-8?B?Y29qMDdkNC9Pb0FlSVdKMHZkTGg3YUFCVitXYlpjdEhZM1hjQkc3N1lUME1h?=
 =?utf-8?B?MTB0MHo2WFVtK3c3VDh5VkxncVd1R1gvUUNzMkhNVUNET2N1bXp3RUMzNXVW?=
 =?utf-8?B?TFVPb1V4TGxDK2IvTFZNMm5UaTBSdGlQVVYvN3hVOFpKejFZb1hIa05UYy9F?=
 =?utf-8?B?ajErdURzUkRDa3M3R29zc0l6RU9pbUc4Slc4eHprNnVGb2JBbjlHNGF6WkU3?=
 =?utf-8?B?bnFCcjRkMUxNV0NDcUVoSVFCNXF5SnNhUjkwNUVrbjJ1ZThjTG1XdGtmSWJo?=
 =?utf-8?B?UG0yNkpSSGw2OFVVVkRnMkJWeEt3Q0piQnMzWG9HVFZ2cjcrUFVab0E4a0VG?=
 =?utf-8?Q?9aRbxx8+ablhZrcZpyxqXx0kGoeG78fmM1wbb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <60D19D3401F060449080B13BA242C293@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b738d1-9fa6-4777-8a98-08de4d67caf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2026 21:08:51.2412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NAUAQu7Gf7GLK0xB61q7ugW3/sDX4ZhrDF6I1f8ltxhkFpRZOsKKUqxFfLDVI/PRkdplUpSemhHJXCYqbP76EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4529
X-Authority-Analysis: v=2.4 cv=aaJsXBot c=1 sm=1 tr=0 ts=695d79e6 cx=c_pps
 a=8mz6MTC2HIKUG4doMpATJQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=7PeAuJZS_Z88lqHh--YA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: P2VX52urjnjzTF4I9cMzcsTyvgNyOBZg
X-Proofpoint-ORIG-GUID: InVjTWU3x9RkVFHbUbAUwZNOYwWmZ8u8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE4MCBTYWx0ZWRfXxzCiHssCB2/5
 iglb8LEaeC8TDP8V3u8xokacyYnflPIyeKpSsxLxCMkMHsf623nep1ccRb3QAEgRgPR/UbKcCO7
 yY2QPMXc4eFAvCkzGItnP4ZrkBRsHpCMxKJwVh2mMa9PQWuil80sjD7TADJ3dgRrHLcrmFGHvpB
 40bRypW85MPS7mc3kmBu7WJpTpKNlZ6nn4DnHHHh3zEULMw4nRB+5bMP1kAoY95mL7hiDx1F07b
 m0UTvUZ6TIZmSEOeJEZTBPJ8Enqev+kPt2G/Ul6WUzc+4OnkI7pwhSMQHD6b3/dW/c226POgTTd
 pBzFspsjJf8q6PHRbT/PL128B0S6CIH81P9c8NSjvYE0EZv84ebvDAkxMqWOba7e30lxsC8H8Gp
 lh0fNjWPVqAfrmConJio8jZ1OMQwxBu2riqvQ3X4r7ni1LvGYqIRiXzUa38Tenx1t3nLPT5Fseh
 T2Jl5cZ3zhfO6NCjSvg==
Subject: RE: [PATCH 1/5] ceph: Do not propagate page array emplacement errors
 as batch errors
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601060180

T24gTW9uLCAyMDI2LTAxLTA1IGF0IDIyOjUyIC0wODAwLCBTYW0gRWR3YXJkcyB3cm90ZToNCj4g
T24gTW9uLCBKYW4gNSwgMjAyNiBhdCAxMjoyNOKAr1BNIFZpYWNoZXNsYXYgRHViZXlrbw0KPiA8
U2xhdmEuRHViZXlrb0BpYm0uY29tPiB3cm90ZToNCj4gPiANCj4gPiBPbiBUdWUsIDIwMjUtMTIt
MzAgYXQgMTg6NDMgLTA4MDAsIFNhbSBFZHdhcmRzIHdyb3RlOg0KPiA+ID4gV2hlbiBmc2NyeXB0
IGlzIGVuYWJsZWQsIG1vdmVfZGlydHlfZm9saW9faW5fcGFnZV9hcnJheSgpIG1heSBmYWlsDQo+
ID4gPiBiZWNhdXNlIGl0IG5lZWRzIHRvIGFsbG9jYXRlIGJvdW5jZSBidWZmZXJzIHRvIHN0b3Jl
IHRoZSBlbmNyeXB0ZWQNCj4gPiA+IHZlcnNpb25zIG9mIGVhY2ggZm9saW8uIEVhY2ggZm9saW8g
YmV5b25kIHRoZSBmaXJzdCBhbGxvY2F0ZXMgaXRzIGJvdW5jZQ0KPiA+ID4gYnVmZmVyIHdpdGgg
R0ZQX05PV0FJVC4gRmFpbHVyZXMgYXJlIGNvbW1vbiAoYW5kIGV4cGVjdGVkKSB1bmRlciB0aGlz
DQo+ID4gPiBhbGxvY2F0aW9uIG1vZGU7IHRoZXkgc2hvdWxkIGZsdXNoIChub3QgYWJvcnQpIHRo
ZSBiYXRjaC4NCj4gPiA+IA0KPiA+ID4gSG93ZXZlciwgY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNo
KCkgdXNlcyB0aGUgc2FtZSBgcmNgIHZhcmlhYmxlIGZvciBpdHMNCj4gPiA+IG93biByZXR1cm4g
Y29kZSBhbmQgZm9yIGNhcHR1cmluZyB0aGUgcmV0dXJuIGNvZGVzIG9mIGl0cyByb3V0aW5lIGNh
bGxzOw0KPiA+ID4gZmFpbGluZyB0byByZXNldCBgcmNgIGJhY2sgdG8gMCByZXN1bHRzIGluIHRo
ZSBlcnJvciBiZWluZyBwcm9wYWdhdGVkDQo+ID4gPiBvdXQgdG8gdGhlIG1haW4gd3JpdGViYWNr
IGxvb3AsIHdoaWNoIGNhbm5vdCBhY3R1YWxseSB0b2xlcmF0ZSBhbnkNCj4gPiA+IGVycm9ycyBo
ZXJlOiBvbmNlIGBjZXBoX3diYy5wYWdlc2AgaXMgYWxsb2NhdGVkLCBpdCBtdXN0IGJlIHBhc3Nl
ZCB0bw0KPiA+ID4gY2VwaF9zdWJtaXRfd3JpdGUoKSB0byBiZSBmcmVlZC4gSWYgaXQgc3Vydml2
ZXMgdW50aWwgdGhlIG5leHQgaXRlcmF0aW9uDQo+ID4gPiAoZS5nLiBkdWUgdG8gdGhlIGdvdG8g
YmVpbmcgZm9sbG93ZWQpLCBjZXBoX2FsbG9jYXRlX3BhZ2VfYXJyYXkoKSdzDQo+ID4gPiBCVUdf
T04oKSB3aWxsIG9vcHMgdGhlIHdvcmtlci4gKFN1YnNlcXVlbnQgcGF0Y2hlcyBpbiB0aGlzIHNl
cmllcyBtYWtlDQo+ID4gPiB0aGUgbG9vcCBtb3JlIHJvYnVzdC4pDQo+ID4gDQo+IA0KPiBIaSBT
bGF2YSwNCj4gDQo+ID4gSSB0aGluayB5b3UgYXJlIHJpZ2h0IHdpdGggdGhlIGZpeC4gV2UgaGF2
ZSB0aGUgbG9vcCBoZXJlIGFuZCBpZiB3ZSBhbHJlYWR5DQo+ID4gbW92ZWQgc29tZSBkaXJ0eSBm
b2xpb3MsIHRoZW4gd2Ugc2hvdWxkIGZsdXNoIGl0LiBCdXQgd2hhdCBpZiB3ZSBmYWlsZWQgb24g
dGhlDQo+ID4gZmlyc3Qgb25lIGZvbGlvLCB0aGVuIHNob3VsZCB3ZSByZXR1cm4gbm8gZXJyb3Ig
Y29kZSBpbiB0aGlzIGNhc2U/DQo+IA0KPiBUaGUgY2FzZSB5b3UgYXNrIGFib3V0LCB3aGVyZSBt
b3ZlX2RpcnR5X2ZvbGlvX2luX3BhZ2VfYXJyYXkoKSByZXR1cm5zDQo+IGFuIGVycm9yIGZvciB0
aGUgZmlyc3QgZm9saW8sIGlzIGN1cnJlbnRseSBub3QgcG9zc2libGU6DQo+IDEpIFRoZSBvbmx5
IGVycm9yIGNvZGUgdGhhdCBtb3ZlX2RpcnR5X2ZvbGlvX2luX3BhZ2VfYXJyYXkoKSBjYW4NCj4g
cHJvcGFnYXRlIGlzIGZyb20gZnNjcnlwdF9lbmNyeXB0X3BhZ2VjYWNoZV9ibG9ja3MoKSwgd2hp
Y2ggaXQgY2FsbHMNCj4gd2l0aCBHRlBfTk9GUyBmb3IgdGhlIGZpcnN0IGZvbGlvLiBUaGUgbGF0
dGVyIGZ1bmN0aW9uJ3MgZG9jIGNvbW1lbnQNCj4gb3V0cmlnaHQgc3RhdGVzOg0KPiAgKiBUaGUg
Ym91bmNlIHBhZ2UgYWxsb2NhdGlvbiBpcyBtZW1wb29sLWJhY2tlZCwgc28gaXQgd2lsbCBhbHdh
eXMgc3VjY2VlZCB3aGVuDQo+ICAqIEBnZnBfZmxhZ3MgaW5jbHVkZXMgX19HRlBfRElSRUNUX1JF
Q0xBSU0sIGUuZy4gd2hlbiBpdCdzIEdGUF9OT0ZTLg0KPiAyKSBUaGUgZXJyb3IgcmV0dXJuIGlz
bid0IGV2ZW4gcmVhY2hhYmxlIGZvciB0aGUgZmlyc3QgZm9saW8gYmVjYXVzZQ0KPiBvZiB0aGUg
QlVHX09OKGNlcGhfd2JjLT5sb2NrZWRfcGFnZXMgPT0gMCk7IGxpbmUuDQo+IA0KDQpVbmZvcnR1
bmF0ZWx5LCB0aGUga2VybmVsIGNvZGUgaXMgbm90IHNvbWV0aGluZyBjb21wbGV0ZWx5IHN0YWJs
ZS4gV2UgY2Fubm90DQpyZWx5IG9uIHBhcnRpY3VsYXIgc3RhdGUgb2YgdGhlIGNvZGUuIFRoZSBj
b2RlIHNob3VsZCBiZSBzdGFibGUsIHJvYnVzdCBlbm91Z2gsDQphbmQgcmVhZHkgZm9yIGRpZmZl
cmVudCBzaXR1YXRpb25zLiBUaGUgbWVudGlvbmVkIEJVR19PTigpIGNvdWxkIGJlIHJlbW92ZWQN
CnNvbWVob3cgZHVyaW5nIHJlZmFjdG9yaW5nIGJlY2F1c2Ugd2UgYWxyZWFkeSBoYXZlIGNvbW1l
bnQgdGhlcmUgImJldHRlciBub3QNCmZhaWwgb24gZmlyc3QgcGFnZSEiLiBBbHNvLCB0aGUgYmVo
YXZpb3Igb2YgZnNjcnlwdF9lbmNyeXB0X3BhZ2VjYWNoZV9ibG9ja3MoKQ0KY291bGQgYmUgY2hh
bmdlZCB0b28uIFNvLCB3ZSBuZWVkIHRvIGV4cGVjdCBhbnkgYmFkIHNpdHVhdGlvbiBhbmQgdGhp
cyBpcyB3aHkgSQ0KcHJlZmVyIHRvIG1hbmFnZSBzdWNoIHBvdGVudGlhbCAoYW5kIG1heWJlIG5v
dCBzbyBwb3RlbnRpYWwpIGVycm9uZW91cw0Kc2l0dWF0aW9uKHMpLg0KDQo+ID4gDQo+ID4gPiAN
Cj4gPiA+IE5vdGUgdGhhdCB0aGlzIGZhaWx1cmUgbW9kZSBpcyBjdXJyZW50bHkgbWFza2VkIGR1
ZSB0byBhbm90aGVyIGJ1Zw0KPiA+ID4gKGFkZHJlc3NlZCBsYXRlciBpbiB0aGlzIHNlcmllcykg
dGhhdCBwcmV2ZW50cyBtdWx0aXBsZSBlbmNyeXB0ZWQgZm9saW9zDQo+ID4gPiBmcm9tIGJlaW5n
IHNlbGVjdGVkIGZvciB0aGUgc2FtZSB3cml0ZS4NCj4gPiANCj4gPiBTbywgbWF5YmUsIHRoaXMg
cGF0Y2ggaGFzIGJlZW4gbm90IGNvcnJlY3RseSBwbGFjZWQgaW4gdGhlIG9yZGVyPw0KPiANCj4g
VGhpcyBjcmFzaCBpcyB1bm1hc2tlZCBieSBwYXRjaCA1IG9mIHRoaXMgc2VyaWVzLiAoSXQgYWxs
b3dzIG11bHRpcGxlDQo+IGZvbGlvcyB0byBiZSBiYXRjaGVkIHdoZW4gZnNjcnlwdCBpcyBlbmFi
bGVkLikgUGF0Y2ggNSBoYXMgbm8gaGFyZA0KPiBkZXBlbmRlbmN5IG9uIGFueXRoaW5nIGVsc2Ug
aW4gdGhpcyBzZXJpZXMsIHNvIGl0IGNvdWxkIC0tIGluDQo+IHByaW5jaXBsZSAtLSBiZSBvcmRl
cmVkIGZpcnN0IGFzIHlvdSBzdWdnZXN0LiBIb3dldmVyLCB0aGF0IG9yZGVyaW5nDQo+IHdvdWxk
IGRlbGliZXJhdGVseSBjYXVzZSBhIHJlZ3Jlc3Npb24gaW4ga2VybmVsIHN0YWJpbGl0eSwgZXZl
biBpZg0KPiBvbmx5IGJyaWVmbHkuIFRoYXQncyBub3QgY29uc2lkZXJlZCBnb29kIHByYWN0aWNl
IGluIG15IHZpZXcsIGFzIGl0DQo+IG1heSBhZmZlY3QgcGVvcGxlIHdobyBhcmUgdHJ5aW5nIHRv
IGJpc2VjdCBhbmQgcmVncmVzc2lvbiB0ZXN0LiBTbyB0aGUNCj4gb3JkZXJpbmcgb2YgdGhpcyBz
ZXJpZXMgaXM6IGZpeCB0aGUgY3Jhc2ggaW4gdGhlIHVudXNlZCBjb2RlIGZpcnN0LA0KPiB0aGVu
IGZpeCB0aGUgYnVnIHRoYXQgbWFrZXMgaXQgdW51c2VkLg0KPiANCg0KT0ssIHlvdXIgcG9pbnQg
c291bmRzIGNvbmZ1c2luZywgZnJhbmtseSBzcGVha2luZy4gSWYgd2UgY2Fubm90IHJlcHJvZHVj
ZSB0aGUNCmlzc3VlIGJlY2F1c2UgYW5vdGhlciBidWcgaGlkZXMgdGhlIGlzc3VlLCB0aGVuIG5v
IHN1Y2ggaXNzdWUgZXhpc3RzLiBBbmQgd2UNCmRvbid0IG5lZWQgdG8gZml4IHNvbWV0aGluZy4g
U28sIGZyb20gdGhlIGxvZ2ljYWwgcG9pbnQgb2Ygdmlldywgd2UgbmVlZCB0byBmaXgNCnRoZSBm
aXJzdCBidWcsIHRoZW4gd2UgY2FuIHJlcHJvZHVjZSB0aGUgaGlkZGVuIGlzc3VlLCBhbmQsIGZp
bmFsbHksIHRoZSBmaXgNCm1ha2VzIHNlbnNlLg0KDQpJIGRpZG4ndCBzdWdnZXN0IHRvbyBtYWtl
IHRoZSBwYXRjaCA1dGggYXMgdGhlIGZpcnN0IG9uZS4gQnV0IEkgYmVsaWV2ZSB0aGF0DQp0aGlz
IHBhdGNoIHNob3VsZCBmb2xsb3cgdG8gdGhlIHBhdGNoIDV0aC4gDQoNCj4gPiBJdCB3aWxsIGJl
DQo+ID4gZ29vZCB0byBzZWUgdGhlIHJlcHJvZHVjdGlvbiBvZiB0aGUgaXNzdWUgYW5kIHdoaWNo
IHN5bXB0b21zIHdlIGhhdmUgZm9yIHRoaXMNCj4gPiBpc3N1ZS4gRG8geW91IGhhdmUgdGhlIHJl
cHJvZHVjdGlvbiBzY3JpcHQgYW5kIGNhbGwgdHJhY2Ugb2YgdGhlIGlzc3VlPw0KPiANCj4gRmFp
ciBwb2ludCENCj4gDQo+IEZ1bmN0aW9uIGlubGluaW5nIG1ha2VzIHRoZSBjYWxsIHRyYWNlIG5v
dCB2ZXJ5IGludGVyZXN0aW5nOg0KPiBDYWxsIHRyYWNlOg0KPiAgY2VwaF93cml0ZXBhZ2VzX3N0
YXJ0KzB4MTZlYy8weDE4ZTAgW2NlcGhdICgpDQo+ICBkb193cml0ZXBhZ2VzKzB4YjAvMHgxYzAN
Cj4gIF9fd3JpdGViYWNrX3NpbmdsZV9pbm9kZSsweDRjLzB4NGQ4DQo+ICB3cml0ZWJhY2tfc2Jf
aW5vZGVzKzB4MjM4LzB4NGM4DQo+ICBfX3dyaXRlYmFja19pbm9kZXNfd2IrMHg2NC8weDEyMA0K
PiAgd2Jfd3JpdGViYWNrKzB4MzIwLzB4M2U4DQo+ICB3Yl93b3JrZm4rMHg0MmMvMHg1MTgNCj4g
IHByb2Nlc3Nfb25lX3dvcmsrMHgxN2MvMHg0MjgNCj4gIHdvcmtlcl90aHJlYWQrMHgyNjAvMHgz
OTANCj4gIGt0aHJlYWQrMHgxNDgvMHgyNDANCj4gIHJldF9mcm9tX2ZvcmsrMHgxMC8weDIwDQo+
IENvZGU6IDM0ZmZkZWUwIDUyODAwMDIwIDM5MDNlN2UwIDE3ZmZmZWY0IChkNDIxMDAwMCkNCj4g
LS0tWyBlbmQgdHJhY2UgMDAwMDAwMDAwMDAwMDAwMCBdLS0tDQo+IEtlcm5lbCBwYW5pYyAtIG5v
dCBzeW5jaW5nOiBPb3BzIC0gQlVHOiBGYXRhbCBleGNlcHRpb24NCj4gDQo+IGNlcGhfd3JpdGVw
YWdlc19zdGFydCsweDE2ZWMgY29ycmVzcG9uZHMgdG8gbGludXgtNi4xOC4yL2ZzL2NlcGgvYWRk
ci5jOjEyMjINCj4gDQo+IEhvd2V2ZXIsIHRoZXNlIHJlcHJvIHN0ZXBzIHNob3VsZCB3b3JrOg0K
PiAxKSBBcHBseSBwYXRjaCA1IGZyb20gdGhpcyBzZXJpZXMgKGFuZCBubyBvdGhlciBwYXRjaGVz
KQ0KPiAyKSBNb3VudCBDZXBoRlMgYW5kIGFjdGl2YXRlIGZzY3J5cHQNCj4gMykgQ29weSBhIGxh
cmdlIGRpcmVjdG9yeSBpbnRvIHRoZSBDZXBoRlMgbW91bnQNCj4gNCkgQWZ0ZXIgZG96ZW5zIG9m
IEdCcyB0cmFuc2ZlcnJlZCwgeW91IHNob3VsZCBvYnNlcnZlIHRoZSBhYm92ZSBrZXJuZWwgb29w
cw0KDQpDb3VsZCB3ZSBoYXZlIGFsbCBvZiB0aGVzZSBkZXRhaWxzIGluIHRoZSBjb21taXQgbWVz
c2FnZT8NCg0KVGhhbmtzLA0KU2xhdmEuDQoNCj4gDQo+IFdhcm0gcmVnYXJkcywNCj4gU2FtDQo+
IA0KPiANCj4gDQo+IA0KPiA+IA0KPiA+ID4gDQo+ID4gPiBGb3Igbm93LCBqdXN0IHJlc2V0IGBy
Y2Agd2hlbiByZWRpcnR5aW5nIHRoZSBmb2xpbyBhbmQgcHJldmVudCB0aGUNCj4gPiA+IGVycm9y
IGZyb20gcHJvcGFnYXRpbmcuIEFmdGVyIHRoaXMgY2hhbmdlLCBjZXBoX3Byb2Nlc3NfZm9saW9f
YmF0Y2goKSBubw0KPiA+ID4gbG9uZ2VyIHJldHVybnMgZXJyb3JzOyBpdHMgb25seSByZW1haW5p
bmcgZmFpbHVyZSBpbmRpY2F0b3IgaXMNCj4gPiA+IGBsb2NrZWRfcGFnZXMgPT0gMGAsIHdoaWNo
IHRoZSBjYWxsZXIgYWxyZWFkeSBoYW5kbGVzIGNvcnJlY3RseS4gVGhlDQo+ID4gPiBuZXh0IHBh
dGNoIGluIHRoaXMgc2VyaWVzIGFkZHJlc3NlcyB0aGlzLg0KPiA+ID4gDQo+ID4gPiBGaXhlczog
Y2U4MGI3NmRkMzI3ICgiY2VwaDogaW50cm9kdWNlIGNlcGhfcHJvY2Vzc19mb2xpb19iYXRjaCgp
IG1ldGhvZCIpDQo+ID4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gU2lnbmVk
LW9mZi1ieTogU2FtIEVkd2FyZHMgPENGU3dvcmtzQGdtYWlsLmNvbT4NCj4gPiA+IC0tLQ0KPiA+
ID4gIGZzL2NlcGgvYWRkci5jIHwgMSArDQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2FkZHIuYyBiL2ZzL2Nl
cGgvYWRkci5jDQo+ID4gPiBpbmRleCA2M2I3NWQyMTQyMTAuLjM0NjJkZjM1ZDI0NSAxMDA2NDQN
Cj4gPiA+IC0tLSBhL2ZzL2NlcGgvYWRkci5jDQo+ID4gPiArKysgYi9mcy9jZXBoL2FkZHIuYw0K
PiA+ID4gQEAgLTEzNjksNiArMTM2OSw3IEBAIGludCBjZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2go
c3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcsDQo+ID4gPiAgICAgICAgICAgICAgIHJjID0g
bW92ZV9kaXJ0eV9mb2xpb19pbl9wYWdlX2FycmF5KG1hcHBpbmcsIHdiYywgY2VwaF93YmMsDQo+
ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmb2xpbyk7DQo+ID4gPiAgICAgICAg
ICAgICAgIGlmIChyYykgew0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgIHJjID0gMDsNCj4g
PiANCj4gPiBJIGxpa2UgdGhlIGZpeCBidXQgSSB3b3VsZCBsaWtlIHRvIGNsYXJpZnkgdGhlIGFi
b3ZlIHF1ZXN0aW9ucyBhdCBmaXJzdC4NCj4gPiANCj4gPiBUaGFua3MsDQo+ID4gU2xhdmEuDQo+
ID4gDQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgZm9saW9fcmVkaXJ0eV9mb3Jfd3JpdGVw
YWdlKHdiYywgZm9saW8pOw0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgIGZvbGlvX3VubG9j
ayhmb2xpbyk7DQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo=

