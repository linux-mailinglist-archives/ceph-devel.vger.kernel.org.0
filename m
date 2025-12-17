Return-Path: <ceph-devel+bounces-4186-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C055CC5BB8
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Dec 2025 02:57:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 07552300248E
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Dec 2025 01:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABCF722A80D;
	Wed, 17 Dec 2025 01:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NfhjjZV2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EB642AA3;
	Wed, 17 Dec 2025 01:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765936636; cv=fail; b=LkfvRDyrY/mtpwFU7Nk2QldahqjSUy8SN5ewNhNwVCpZUWBDRXngkQ0n7v8MV3fIkAyKXmBzZA70BABfVqSosfWOf1vcizfvFQP/BfTKpgM7PLrblAD1Q+aLowRxR4v8HLXMcUNGKgZVhadL724nf5fBTcoYGdzsbVP035xNCso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765936636; c=relaxed/simple;
	bh=2C4S4EYMSe3ygpciXbuWTGFQUfyDprALt9qWeSxc+QY=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=CPdwf9+3vGinsfiWszUVPvC/RUiy9jj1I6VXYb1DsK5SFqHmJxewm/JbUhXYH+lES7HYJYL4rKA8JstDyMXYQZUl30GzGQHsB53rUL2bzfiuqp1WUusRdSIXDj7XF7PI+yIiJcE1z44KKMgLPRSPAAKJgJzxV6nO4w9tNGdYiJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NfhjjZV2; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BGIKwvK013949;
	Wed, 17 Dec 2025 01:56:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=2C4S4EYMSe3ygpciXbuWTGFQUfyDprALt9qWeSxc+QY=; b=NfhjjZV2
	BWUVF+0Wghv5KWa0uRUF/aZkusctCF5ZIWMfSorkPknxM51owUh0Rybead+8DRRE
	zEl0E6cjnseHf/HQZJdK8WGWRVcwea1SRuMCDrQcwpQ/nj0gATYa6JQzOm9vinMx
	y07ni8UZ8yOi1OAlv4zqyUJNxZgjGUzH7wc4W36uGs+hcFR+vC5gqTpUu1tN+fab
	pGCETpDbkOv2y/XG2hEfFE78f8kPK8p4fXoUtw6QjDn/liizu7F36Qcu4BBBufKG
	Mm45D8+kZtQEobvzzdv6tWitkAkMr1SDK8dqwdo1jcsV7NgWk8iasraMVptzdyIH
	QgK6cVaEFxSmGg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0wjq202j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Dec 2025 01:56:55 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BH1q2Cc013297;
	Wed, 17 Dec 2025 01:56:55 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010054.outbound.protection.outlook.com [52.101.85.54])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0wjq202f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Dec 2025 01:56:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ugwwhOPeLFIB/FTEb2cSY0UK6hMNRTNl+/g5UZZhHDQRAVJ0TzFSdVDrF13RzUQJxi3QEAp8DSc4o4nz4fYwlV67Kl1zwS6cNfYtQmBZRTXMCkhfQ+MiXFXtbGsREKAUBPnz5h7IfneEbgQnDabvOiqjBYGwz0iYxxIFVjUYRNhR5Dh0bQ+nFw14Z+StZbO5Q/x2PeaGtH4CzA0g18eyJdWPFXhvD19+jAVw+yJkLUmhIzwyFwGtQGSkktmosEcgusvWngkq+jfNq7AKoPC5pag+MeodMaBM4TlVyUqH4zg5jvD2enJ++/687CRo+5SUD4iHnpeShcMLFUMhyyGFbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2C4S4EYMSe3ygpciXbuWTGFQUfyDprALt9qWeSxc+QY=;
 b=x8ADaR+hr4uNt+rv81PBSewqVC4pJxslaAdYUdD/nGoBJ4Zz/iunSeTZt50EBRlA/ufaEoAIZWAFIhaN6u18nT9Vou+fM3xslqYDAS9ng0esRKuFqsyZsES8VaUcflkUF/CHKYBGyldrueeY09fNvpJHCrdTOGMZeCzH8qspYekZ9zLgejADeWfGPrTuqK9IvVZGNdykoGZSyFI6yPTHPOhpxpk2GuhpUaEZiaMzv5QxQFz9vFEp4nV4Ssy9H1MOmB/29Dg4DKK3wEmGf8Atfoq7UIag5xS8qvVkkiMhLQeso65SHtDzHyaWbaaxhLpsuC9x9ryK9FlYj5VwjMwQgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BLAPR15MB3939.namprd15.prod.outlook.com (2603:10b6:208:278::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 01:56:52 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 01:56:52 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "malcolm@haak.id.au" <malcolm@haak.id.au>,
        "00107082@163.com"
	<00107082@163.com>
CC: Xiubo Li <xiubli@redhat.com>, David Howells <dhowells@redhat.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "surenb@google.com" <surenb@google.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "netfs@lists.linux.dev"
	<netfs@lists.linux.dev>,
        "pc@manguebit.org" <pc@manguebit.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>
Thread-Topic: [EXTERNAL] Re: Possible memory leak in 6.17.7
Thread-Index: AQHcblnAW/aaYMg3hkGmyCaHD17ZybUj2RYAgABP84CAAAZagIAABtOAgADd6IA=
Date: Wed, 17 Dec 2025 01:56:52 +0000
Message-ID: <ec3b777ba176a6ca4738da8c62c030577a4e58eb.camel@ibm.com>
References: <20251110182008.71e0858b@xps15mal>
	 <20251208110829.11840-1-00107082@163.com>
	 <20251209090831.13c7a639@xps15mal>
	 <17469653.4a75.19b01691299.Coremail.00107082@163.com>
	 <20251210234318.5d8c2d68@xps15mal>
	 <2a9ba88e.3aa6.19b0b73dd4e.Coremail.00107082@163.com>
	 <20251211142358.563d9ac3@xps15mal>
	 <8c8e8dc4d30a8ca37a57d7f29c5f29cdf7a904ee.camel@ibm.com>
	 <20251216112647.39ac2295@xps15mal>
	 <63fa6bc2.6afc.19b25f618ad.Coremail.00107082@163.com>
	 <20251216170918.5f7848cc@xps15mal> <20251216215527.61c2e16f@xps15mal>
	 <5845dde.b3e3.19b2718bc89.Coremail.00107082@163.com>
	 <10b5964a.b798.19b272f1b79.Coremail.00107082@163.com>
In-Reply-To: <10b5964a.b798.19b272f1b79.Coremail.00107082@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BLAPR15MB3939:EE_
x-ms-office365-filtering-correlation-id: 6d25ea63-6867-4783-6c75-08de3d0f8c63
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|10070799003|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SWFhMHc3aWtlc2FzLzVkRXdLdWdNWU03WHM5OHpvSHZlUjdsazJQdHdBZjN3?=
 =?utf-8?B?TTRXclkvRElzZU1ZVFovY2pjUThla2xDQm9YUTc0QmtET2JXZktLei84QXpU?=
 =?utf-8?B?OTNDY1BGUldSbncvemZJQWl2Q3NZWkVxTVJmT0lLU3g2UHQ4RVBoeEl1bUNL?=
 =?utf-8?B?Tm5DL3krTUVXT1dNUU9lVjdlSElEODF6dnp4T0lnZ3pTZzlock0xRnI3Szg0?=
 =?utf-8?B?UU5rcUNNL3hObkozbjhnMGsvODl3emlxL2JIdUdXUVFzOWN5M0ZDa3ZXazY3?=
 =?utf-8?B?SVdTaHphRVU3YU90WitkTlc0TjVWcDQvZXVwRy9yTGdlTS9YKy8wZEdTYXYr?=
 =?utf-8?B?SGlmeDVKVGh3Smw2QklZRnovY2hoblgzd3AzTmhkc1ZxTTZOY1N0WkwvYkc3?=
 =?utf-8?B?bG5LYm1OMVRzMXNrekFLUzIrRWpRaG1QRXFGS1BUVmZQcHBWaHdzdDBoVGpP?=
 =?utf-8?B?SmFqSFQrMTBwakRXK3hOQzZxYUtZcGlVK3pXS2Q5UWtKWHZzVy80a29OZG5F?=
 =?utf-8?B?S0tDdi9IYmd0K0FlOThnUUo4aGY4OTMxVEEwQkJNYVpGODV0UnFvWWE4TVpD?=
 =?utf-8?B?aHUrS2ROY3B5R0tBRUlBSzRMS1gyajUxditjY0RRVnI2TkdzY052TUQ0cGVZ?=
 =?utf-8?B?b2kxYkZKOW5yVjE0cUdWZ0pNY2NxWUNONXpHdGFnNkpCaUdBZXFUWmxQZWtB?=
 =?utf-8?B?ZHdBQmlBbGJLV3N5RmpaV1pWRms5T2VhK0FORTFud0tDODZqaDVRTjFYY3FM?=
 =?utf-8?B?TTdUZEQxdU9WRXBjWVR3YU5ORnB3TjJubkdWTW1PeFlzVFVZYjN5VTVsc2VT?=
 =?utf-8?B?bUlKSzdvOUcwMnhJMWxaR25ZNmhZZi9YbU9XMjJ3SmRETU8zMkcvaDUvOHN5?=
 =?utf-8?B?bVBUaFZHclhQVENsMzRlQ1hJZ0tlUW9PNzAwdFhsVFg5aDRsdHAyaml1ZTZI?=
 =?utf-8?B?WWVWVGlER2N0ekxEQ2VMNkFBWEFKYXpWZWEwQUxhdFF3Q1ZCTXZRWnVwZTdY?=
 =?utf-8?B?b3IxZEJDUmZYVXdQMmlaOHJ1ZnRBQ0Z6bHVyTE5ZaXNhSWhUU3pvMEQ3ZjVD?=
 =?utf-8?B?L25LS3VjTGdudjRFK0xtVjBSRk5vOUdaTmFpMnN1RnpzeXlscVl0UFpvNFZZ?=
 =?utf-8?B?d2ZLQUNvcno4NVNRTWlGTnMvM0MxRmt4MTNtTVl2RnVyOFhqaHlRT3FTQ295?=
 =?utf-8?B?TEhETHFIMit3YkhQUTI0ckNTeU1kMENuTU41VllTV2FDaHl6MFhWMkp5OG91?=
 =?utf-8?B?SzMyaU9zK2pzaFFpV0Nma1pUSFdBWUF4bEhOMkZyeDlqWG1uRUQzL08vTS9x?=
 =?utf-8?B?TWFxWHYyV1FEK3BNcUlUTmFsbDVtVHRuU045d3l0K1hScnlvUkZNbDBYRTQx?=
 =?utf-8?B?bGJOL3lTdHFybU02K2Z0Z0FYVkdtYzE0TkpNQjBML3dvWWE2R2NjUk1LQ2hk?=
 =?utf-8?B?VFk0WHhHdmtuRzZhalI2YzJuUS9WdlRIKzdqS09pdFk5dnlHMEU2UDE5SHVo?=
 =?utf-8?B?cEg1cjg2WVh0c1lnS3NKL2RiaW9tR1NscU9XY0hOTjFGNXpIZ3UxMU84VXZN?=
 =?utf-8?B?RTNha2FWeG44VDRJT3JPcWxkNzBKeEV1TWx1REZqdldXaW9pTjZHamVHQkp2?=
 =?utf-8?B?ME5QVjlINjdaRVdMcnVLTkhkckpsTnJYdlVha3RTUi9nTVk5VnZNOUJvbith?=
 =?utf-8?B?WHkxbVZ0TVNMamJUb2lDMkFOWThLV2FVYkNKVE16OGxoRkNDUmZHanFWdUQ1?=
 =?utf-8?B?bmtsNG9LM0h0aWErNFFsc1NsbEJUVy83UjZ4V3NJTUprR1dZRVpDMGpQZGZG?=
 =?utf-8?B?QUdHcDNybG9rUkZtbk0xQzB0ZWRsZkpocVhqelR4RUFtL1B4cEF3MmNuL3FU?=
 =?utf-8?B?TjI2b2UvQkkvbkJKTVZGdEN6OTlvYWdobVh2eDdmbERXMkR1RmJVM25BSjEr?=
 =?utf-8?B?Lzk4MjIxdWgxZGcxK1h6dlFaV2tDRmlXc0FRRHUwL2FlN05oMUdDbUFFa08w?=
 =?utf-8?B?U0F2cXl2TjVGQUFTbjFuRGZRaFp5RytOUkJsYWRXb0swV0Q5cWtrb2l5LzZE?=
 =?utf-8?Q?OWfPvK?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(10070799003)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dDdZMUk1ZkZUaFR5T0pIOG5nTzR3UXFIY3JGN3FPWVM1NFBFVVV2c2szbE0z?=
 =?utf-8?B?U2ZDM1puRVB5Mm1qWmV3TFVYTFpuRmdyUkI4Vm01aUxZS1JDMCtNSWs3NEJu?=
 =?utf-8?B?ZDZITFdPakczREMyYjkxallqSzdaVTVOcmtic0hSZFVZcUlLT0RYWUgxU25K?=
 =?utf-8?B?US80QnhEM2JlMzJENSs1REdOSjdnWFJxZWgvY0RRckR5WDV3NEI1d0lWNUhw?=
 =?utf-8?B?NVFtYVZtT1pYR2JnbXMydU1TTTRQTUs5SVdZeFg5M1REMU1ZbklKdWxTaEd4?=
 =?utf-8?B?aFFiWGE4Q1NVTitMSDhYWHVWaWViN09PM0kreklVUEw4VjBrZVNpZGRCOGJl?=
 =?utf-8?B?WG5MTDlWRnI1OHhrMGY2WTkrbUw2VlVkTkluOVZpZmIrZnk0dFVrN25aV2Vk?=
 =?utf-8?B?bjNQYitEZDBRQ2Ftc25SbjAwUERXbng1dThkdlVpQ3FTSS9SR0c3aGVVYXRx?=
 =?utf-8?B?WXFPeW5GV0hnTGM5eWNSL0dTZ29ta21EV0ZZWHpsWUFQR0JBcXNZalVubU96?=
 =?utf-8?B?ZUxWbFRkdlVQK2R5Snlvb3oyMFpXM1MyYTNPZCtQR1lQNlp6VUJoUlNyTnc1?=
 =?utf-8?B?OTRoZUsvM0U5M1U1aUgxaEViV0QrOHFlLzIwSlN3WjA3SjRpNXlHa0lVTHR1?=
 =?utf-8?B?YVU3dmxydVV2bnhoWVloRmljdTdQcXZ1QjRCVjlMV01WSzI4QjNxNXRZRVhm?=
 =?utf-8?B?L1M5Nk8rbVFXVFd1ZTVQcHpmYWVCcFRjUE1uYnVuUjYyV2hFUmN5TXoxZ083?=
 =?utf-8?B?ckxjR0IwbHRmRG5tUkl6S1pBU1hVZEtnaHpmUXlGcUk2MW9RUnpiQTEyYW9C?=
 =?utf-8?B?WGM2S0hZWmtObC8wQ3lBWlUxbGF5VVVxUDNSRzBSQjdudzU4SmViOTE1UU5M?=
 =?utf-8?B?UjdpbENUd2R1WVRCVVZHOUFOSXpBT0VjOENOT0k5R1dzTGh5MCtvYTNoeitq?=
 =?utf-8?B?QjRrcUgwNkJMcjh2Z1JOd0hJMkJuMC9jM3lGeVVrVjhlYTdxemR1WjRJZEdp?=
 =?utf-8?B?M0kvSFBCUnEvWU9MV1IwclBocWRxYWlHaFloVVFvMUdJMHNUQ0dyQmJ1L2Jw?=
 =?utf-8?B?QjRub2dqazhhNm5US2VXRkNVMW9iQm9QYWRmd3dxcVpmVjB0d1d5NFRFaVhh?=
 =?utf-8?B?ampUcjJzMFRHbm1TdnM2akZncXQ5ZHBxWlJhUlVySi91dXlDOExoQXRQZ2Zs?=
 =?utf-8?B?NlhRdjdmL1JSQlJDQSswKy85dHM0QXZkTGNrK0xvT29rZUJmaVZNTHg4dXB5?=
 =?utf-8?B?RWdjVVJpMnVvOWhnc1JMRHA1T241TERoMTBxZDFxMmt3c3JqSGtlUEdndlJB?=
 =?utf-8?B?NHhtQWMrQWhJdUJZRnUySjNyblRJUnNHeTkrcE5naDZlTnIzYkF3d0Rjeng4?=
 =?utf-8?B?bDliMmVBR1kyejRoQWU3OFV2eUJUbnNyandNd2N4Q0RoZHBVVkFrZHNhcS9C?=
 =?utf-8?B?QW80UjVJTGE1Z3NLVTR4OGNJOTlScVRXWGlSdWJsSW5BY1I0YkM1K0hEdDVx?=
 =?utf-8?B?eGx1bW9ZU2NJVFd0Y28rdkY1QXFodnM0K25UYmlueWZaVGNCaEI5NmV6UUlo?=
 =?utf-8?B?Mk1xQ1QzNldLck4yT3NxdUhialdOZm1qN085RU93djltbnpmbUJGOFlXaFVS?=
 =?utf-8?B?T1BOc3YvWXVRalk2NEZncWJ4VExpWmdVNkxOSVhKQnc2Nk93WndxbklObUNT?=
 =?utf-8?B?aUpwZm52VWFXTjM4NlM1UElmUUNjQ2NCbHVOQ3FYaUtJdVU2eGhUOEhsb08x?=
 =?utf-8?B?dGVqZS9rZ2gySWZOQi93aVBSazFpeHRHdStoR3hhUUpHMCtNdm9ZVUNENStX?=
 =?utf-8?B?RkQ5cmg0aURsK1JvOWN6aFVsZjR6NUwyb2tnN3R4YVRMcXZ4TXJQcnh4Nzht?=
 =?utf-8?B?bElPZUpmK2dvby9wUXZlckIrUE1QSnpOL21kZ3g2SllETlNNeFZyaHdNdG5K?=
 =?utf-8?B?dTNZdmc4YWtRNUdWYXRjNkZVZDhDdjdrR3ZoVGJqYWVWTmplZElSRTJiNHFz?=
 =?utf-8?B?V280bzFUeDJtUXF3dHk1YUVtZ2RES3BEVnltYVRHU2xXYnI4YkFKaHk0WWhM?=
 =?utf-8?B?OElPdldqc3dCd0RxYmVoTkxYWFQ0RzBIOFNoeTVHWC9TTVozWk80Nms2TDRa?=
 =?utf-8?B?OGVxMlBSMHZVTkNFK2p4Skx4RGJQMkoybXd1UEZBMTA4a0pPMHBvWFBGZExZ?=
 =?utf-8?Q?+ss9assVRAAd7WyQnHymFd8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C7B5259238BB349806D76EB13FE89B3@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d25ea63-6867-4783-6c75-08de3d0f8c63
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2025 01:56:52.1270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4ygKqEXxCcWDO7dFoSx8rWoOvA14R4u13Ks1pjBAga6pXT/rV0bxxCz81cASQWy65zfIsa7+6gEftSplkMjDNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3939
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAwMSBTYWx0ZWRfXxu+Meq85SbzZ
 MlVWt0iP72QUJrcNSnyrygS5wYlVbKpcAOPPQQASH7GwWNIfCZ5TmyawmMr8JMY/XzAmshj+ERz
 RHKuVe+E3Z/XR8waHjXTjKV7gj/AcAcPqADk1w4Rp3hSrXlieMEe9nFxRorUPehjJ8WwzYedG2L
 oBBvtEwI8ahipJ93IFRXVL81Cn7sCNOPL7lHv4MvTYVcPfvGeLCWULr5xW8qR6aKG4UY6AQ4uUH
 118JOCuPXmS8OjaatyIFal3USh0F/t79n0qkGXyHsnbgOmZDmswUAGkTTT+vURVj7q22YNmNlHP
 6rX2dLramTtVTWJkm7Z5llMhy5uDXXTQalabN96Ig5hMp+71SMeboFMvA31+LhSmE3rDlJJxSaQ
 808D/Hl+JP4YZLX0rdKtcmevibkz9g==
X-Proofpoint-GUID: jGSlbOzGPNnRvj3_-Bryan68xHHaGQXo
X-Proofpoint-ORIG-GUID: kBVDTP7ghoyz96HuwfxS89o5k3FHlnbb
X-Authority-Analysis: v=2.4 cv=Kq5AGGWN c=1 sm=1 tr=0 ts=69420de7 cx=c_pps
 a=Y5aTAp+79vj4S64KMabfRQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=4u6H09k7AAAA:8 a=Byx-y9mGAAAA:8
 a=GhTlzHfgm0L-qe0VFc8A:9 a=QEXdDO2ut3YA:10 a=5yerskEF2kbSkDMynNst:22
Subject: RE: Possible memory leak in 6.17.7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 impostorscore=0 clxscore=1011 spamscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130001

SGkgTWFsLA0KDQpPbiBUdWUsIDIwMjUtMTItMTYgYXQgMjA6NDIgKzA4MDAsIERhdmlkIFdhbmcg
d3JvdGU6DQo+IEF0IDIwMjUtMTItMTYgMjA6MTg6MTEsICJEYXZpZCBXYW5nIiA8MDAxMDcwODJA
MTYzLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gDQoNCjxza2lwcGVkPg0KDQo+ID4gPiANCj4gPiA+
IA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBJJ3ZlIGhhdmUgYmVlbiB0cnlpbmcgdG8gbmFy
cm93IGRvd24gYSBjb25zaXN0ZW50IHJlcHJvZHVjZXIgdGhhdCdzDQo+ID4gPiA+ID4gPiBhcyBm
YXN0IGFzIG15IHByb2R1Y3Rpb24gd29ya2xvYWQuIChJdCBjcmFzaGVzIGEgMzJHQiBWTSBpbiAy
aHJzKQ0KPiA+ID4gPiA+ID4gQW5kIEkgaGF2ZW4ndCBnb3QgaXQgcXVpdGUgYXMgZmFzdC4gSSB0
aGluayB0aGUgZGQgd29ya2xvYWQgaXMgdG9vDQo+ID4gPiA+ID4gPiB3ZWxsIGJlaGF2ZWQuIA0K
PiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBJIGNhbiBjb25maXJtIHRoZSBpc3N1ZSBhcHBlYXJl
ZCBpbiB0aGUgbWFqb3IgcGF0Y2ggc2V0IHRoYXQgd2FzDQo+ID4gPiA+ID4gPiBhcHBsaWVkIGFz
IHBhcnQgb2YgdGhlIDYuMTUga2VybmVsLiBTbyBkdXJpbmcgdGhlIG1vcmUgY29tcGxldGUNCj4g
PiA+ID4gPiA+IHBhZ2VzIHRvIGZvbGlvcyBzd2l0Y2ggYW5kIHRoYXQgbm90aGluZyBoYXMgY2hh
bmdlZCBpbiB0aGUgYnVnDQo+ID4gPiA+ID4gPiBiZWhhdmlvdXIgc2luY2UgdGhlbi4gSSBkaWQg
aGF2ZSBhIGxvb2sgYXQgYWxsIHRoZSBkaWZmcyBmcm9tIDYuMTQNCj4gPiA+ID4gPiA+IHRvIDYu
MTggb24gYWRkci5jIGFuZCBkaWRuJ3Qgc2VlIGFueSBjaGFuZ2VzIHBvc3QgNi4xNSB0aGF0IGxv
b2tlZA0KPiA+ID4gPiA+ID4gbGlrZSB0aGV5IHdvdWxkIGltcGFjdCB0aGUgYnVnIGJlaGF2aW9y
LiANCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gQWdhaW4sIEknbSBub3Qgc3VwZXIgZmFtaWxp
YXIgd2l0aCB0aGUgQ2VwaEZTIGNvZGUgYnV0IHRvIGhhemFyZCBhDQo+ID4gPiA+ID4gPiBndWVz
cywgYnV0IEkgdGhpbmsgdGhhdCB0aGUgd2ViIGRvd25sb2FkIHdvcmtsb2FkIHRyaWdnZXJzIHRo
aW5ncw0KPiA+ID4gPiA+ID4gZmFzdGVyIHN1Z2dlc3RzIHRoYXQgdW5hbGlnbmVkIHdyaXRlcyBt
aWdodCBtYWtlIHRoaW5ncyB3b3JzZS4gQnV0DQo+ID4gPiA+ID4gPiBhZ2FpbiwgSSdtIG5vdCAx
MDAlIHN1cmUuIEkgY2FuJ3QgZmluZCBhIHJlcHJvZHVjZXIgYXMgZmFzdCBhcw0KPiA+ID4gPiA+
ID4gZG93bmxvYWRpbmcgYSBkYXRhc2V0LiBSc3luYyBvZiBsb3RzIGFuZCBsb3RzIG9mIHRpbnkg
ZmlsZXMgaXMgYQ0KPiA+ID4gPiA+ID4gdGFkIGZhc3RlciB0aGFuIHRoZSBkZCBjYXNlLg0KPiA+
ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBJIGRpZCBzZWUgc29tZSBjaGFuZ2VzIGluIGNlcGhfY2hl
Y2tfcGFnZV9iZWZvcmVfd3JpdGUgd2hlcmUgdGhlDQo+ID4gPiA+ID4gPiBwcmV2aW91cyBjb2Rl
IHVubG9ja2VkIHBhZ2VzIGFuZCB0aGVuIGNvbnRpbnVlZCB3aGVyZSBhcyB0aGUNCj4gPiA+ID4g
PiA+IGNoYW5nZWQgZm9saW8gY29kZSBqdXN0IHJldHVybnMgRU5PREFUQSBhbmQgZG9lc24ndCB1
bmxvY2sNCj4gPiA+ID4gPiA+IGFueXRoaW5nIHdpdGggbW9zdCBvZiB0aGUgcmVzdCBvZiB0aGUg
bG9naWMgdW5jaGFuZ2VkLiBUaGlzIG1pZ2h0DQo+ID4gPiA+ID4gPiBiZSBwZXJmZWN0bHkgZmlu
ZSwgYnV0IGluIG15LCBhZG1pdHRlZGx5IGxpbWl0ZWQsIHJlYWRpbmcgb2YgdGhlDQo+ID4gPiA+
ID4gPiBjb2RlIEkgY291bGRuJ3QgZmlndXJlIG91dCB3aGVyZSBhbnl0aGluZyB0aGF0IHdhcyBs
b2NrZWQgcHJpb3IgdG8NCj4gPiA+ID4gPiA+IHRoaXMgYmVpbmcgY2FsbGVkIHdvdWxkIGdldCB1
bmxvY2tlZCBsaWtlIGl0IGRpZCBwcmlvciB0byB0aGUNCj4gPiA+ID4gPiA+IGNoYW5nZS4gQWdh
aW4sIEkgY291bGQgYmUgbWlsZXMgb2ZmIGhlcmUgYW5kIG9uZSBvZiB0aGUgYnVsaw0KPiA+ID4g
PiA+ID4gcmVjbGFpbS91bmxvY2sgcGFzc2VzIHRoYXQgd2FzIGFkZGVkIG1pZ2h0IGJlIGNsZWFu
aW5nIHRoaXMgdXANCj4gPiA+ID4gPiA+IGNvcnJlY3RseSBvciBzb21lIG90aGVyIGZ1bmN0aW9u
YWwgY2hhbmdlIG1pZ2h0IHRha2UgY2FyZSBvZiB0aGlzLA0KPiA+ID4gPiA+ID4gYnV0IGl0IGxv
b2tzIHRvIGJlIHBvdGVudGlhbGx5IGluIHRoZSBjb2RlIHBhdGggSSdtIGV4Y2lzaW5nIGFuZA0K
PiA+ID4gPiA+ID4gaXQgaGFzIGhhZCBzb21lIHVubG9jayBsb2dpYyBjaGFuZ2VkLiANCj4gPiA+
ID4gPiA+IA0KPiA+ID4gPiA+ID4gSSd2ZSBzcGVudCBtb3N0IG9mIG15IHRpbWUgdHJ5aW5nIHRv
IGZpbmQgYSBzb2xpZCBxdWljayByZXByb2R1Y2VyLg0KPiA+ID4gPiA+ID4gTm90IHRoYXQgaXQg
dGFrZXMgbG9uZyB0byBzdGFydCBsZWFraW5nIGZvbGlvcywgYnV0IEkgd2FudGVkDQo+ID4gPiA+
ID4gPiBzb21ldGhpbmcgdGhhdCBhZ2dyZXNzaXZlbHkgdHJpZ2dlcmVkIGl0IHNvIGEgc21hbGwg
dm0gd291bGQgb29tDQo+ID4gPiA+ID4gPiBxdWlja2x5IGFuZCB3aGVuIGNvbWJpbmVkIHdpdGgg
Y3Jhc2hfb25fb29tIGl0IGNvdWxkIHBvdGVudGlhbGx5IGJlDQo+ID4gPiA+ID4gPiB1c2VkIGZv
ciByZWdyZXNzaW9uIHRlc3RpbmcgYnkgd2F5IG9mICJkaWQgdm0gY3Jhc2g/Ii4NCj4gPiA+ID4g
PiA+IA0KPiA+ID4gPiA+ID4gSSdtIG5vdCBzdXJlIGlmIGl0IHdpbGwgc3VwZXIgaGVscCwgYnV0
IEknbGwgcHJvdmlkZSB3aGF0IGRldGFpbHMgSQ0KPiA+ID4gPiA+ID4gY2FuIGFib3V0IHRoZSBh
Y3R1YWwgd29ya2xvYWQgdGhhdCByZWFsbHkgc2V0cyBpdCBvZmYuIEl0J3MgYQ0KPiA+ID4gPiA+
ID4gcHl0aG9uIGJhc2VkIHRvb2wgZm9yIGRvd25sb2FkaW5nIGRhdGFzZXRzLiBEYXRhc2V0cyBh
cmUgc3BsaXQNCj4gPiA+ID4gPiA+IGludG8gTiBjaHVua3MgYW5kIHRoZSB0b29sIGRvd25sb2Fk
cyB0aGVtIGluIHBhcmFsbGVsIDEwMCBhdCBhDQo+ID4gPiA+ID4gPiB0aW1lIHVudGlsIGFsbCBO
IGNodW5rcyBhcmUgZG93bi4gVGhlIGNvbXByZXNzZWQgZGF0YXNldCBpcyB0aGVuDQo+ID4gPiA+
ID4gPiB1bnBhY2tlZCBhbmQgcmVhc3NlbWJsZWQgZm9yIHVzZSB3aXRoIHdvcmtsb2Fkcy4gDQo+
ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IFRoaXMgaXMgcmVwbGljYXRpbmcgYSBjb21tb24gaG9t
ZSBmb2xkZXIgdXNlY2FzZSBpbiBIUEMuIENlcGhGUyBpcw0KPiA+ID4gPiA+ID4gdmVyeSBhdHRy
YWN0aXZlIGZvciBob21lIGZvbGRlcnMgZHVlIHRvIGl0J3MgIk5GUy1saWtlIiB1dGlsaXR5IGFu
ZA0KPiA+ID4gPiA+ID4gcGVyZm9ybWFuY2UuIEFuZCBtYW55IHRvb2xzIHVzZSBhIHNpbWlsYXIg
bWV0aG9kIGZvciBmZXRjaGluZyBsYXJnZQ0KPiA+ID4gPiA+ID4gZGF0YXNldHMuIFRvb2xzIGFy
ZSBmcmVxdWVudGx5IHdyaXR0ZW4gaW4gcHl0aG9uIG9yIGdvLiANCj4gPiA+ID4gPiA+IA0KPiA+
ID4gPiA+ID4gTm9uZSBvZiBteSBjdXN0b21lcnMgaGF2ZSBoaXQgdGhpcyB5ZXQsIG5vdCBoYXZl
IGFueSBlbnRlcnByaXNlDQo+ID4gPiA+ID4gPiBjdXN0b21lcnMgYXMgbm9uZSBoYXZlIG1vdmVk
IHRvIGEgbmV3IGVub3VnaCBrZXJuZWwgeWV0IGR1ZSB0byBzbG93DQo+ID4gPiA+ID4gPiB1cGdy
YWRlIGN5Y2xlcy4gRXZlbiBQcm94bW94IGhhdmUgb25seSBqdXN0IHN0YXJ0ZWQgdGVzdGluZyBv
biBhDQo+ID4gPiA+ID4gPiBrZXJuZWwgdmVyc2lvbiA+IDYuMTQuIA0KPiA+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gPiBJJ20gbW9yZSB0aGFuIGhhcHB5IHRvIGhlbHAgaG93ZXZlciBJIGNhbiB3aXRo
IHRlc3RpbmcuIEkgY2FuIHJ1bg0KPiA+ID4gPiA+ID4gaW5zdHJ1bWVudGVkIGtlcm5lbHMgb3Ig
dGVzdCBwYXRjaGVzIG9yIHdoYXRldmVyIHlvdSBuZWVkLiBJIGFtDQo+ID4gPiA+ID4gPiBzb3Jy
eSBJIGhhdmVuJ3QgYmVlbiBhYmxlIHRvIHByb2R1Y2UgYSBzdXBlciBjbGVhbiwgZmFzdCByZXBy
b2R1Y2VyDQo+ID4gPiA+ID4gPiAobXkgdGVzdCBjbHVzdGVyIGF0IGhvbWUgaXMgYWxsIHNwaW5u
ZXJzIGFuZCBvbmx5IDUwMFRCIHVzYWJsZSkuDQo+ID4gPiA+ID4gPiBCdXQgSSBmaWd1cmVkIEkg
bmVlZGVkIHRvIGdldCB0aGUgd29yZCBvdXQgYXNhcCBhcyBkaXN0cm9zIGFuZCBzb29uDQo+ID4g
PiA+ID4gPiBjdXN0b21lcnMgYXJlIGdvaW5nIHRvIGJlIG1vdmluZyBwYXN0IDYuMTItNi4xNCBr
ZXJuZWxzIGFzIHRoZSA1LTcNCj4gPiA+ID4gPiA+IHllYXIgdXBkYXRlIGN5Y2xlIG1hcmNoZXMg
b24uIEVzcGVjaWFsbHkgdGhvc2Ugd2FudGluZyB0byB0YWtlIGZ1bGwNCj4gPiA+ID4gPiA+IGFk
dmFudGFnZSBvZiBDYWNoZUZTIGFuZCBlbmNyeXB0aW9uIGZ1bmN0aW9uYWxpdHkuIA0KPiA+ID4g
PiA+ID4gDQo+ID4gPiA+ID4gPiBBZ2FpbiB0aGFua3MgZm9yIGxvb2tpbmcgYXQgdGhpcyBhbmQg
ZG8gcmVhY2ggb3V0IGlmIEkgY2FuIGhlbHAgaW4NCj4gPiA+ID4gPiA+IGFueXdheS4gSSBhbSBp
biB0aGUgY2VwaCBzbGFjayBpZiBpdCdzIGZhc3RlciB0byByZWFjaCBvdXQgdGhhdA0KPiA+ID4g
PiA+ID4gd2F5Lg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+IA0KDQpDb3VsZCB5b3UgcGxlYXNlIGFk
ZCB5b3VyIENlcGhGUyBrZXJuZWwgY2xpZW50J3MgbW91bnQgb3B0aW9ucyBpbnRvIHRoZSB0aWNr
ZXQNClsxXT8NCg0KVGhhbmtzIGEgbG90LA0KU2xhdmEuDQoNClsxXcKgaHR0cHM6Ly90cmFja2Vy
LmNlcGguY29tL2lzc3Vlcy83NDE1NiANCg==

