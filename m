Return-Path: <ceph-devel+bounces-4249-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 324F3CF5827
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 21:25:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7BEB6308C3A8
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 20:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5107320A2C;
	Mon,  5 Jan 2026 20:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kAuZa3cD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E22338590;
	Mon,  5 Jan 2026 20:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767644651; cv=fail; b=H0SliEDFfdOpVHEWOGAYK+jSVpgTC23FCSfznxKVLH5lHnnAimDwqEXBYUyZVCy+fVr+nREI1RUuA1iRq/m1dGZh0q2E98KxYQP9RWDaX0IqfE6FLbl8VhVXEkIYaTl1IwdvyMwsSMjI5Xn8vWhOGeg6DAlT7/9rYTQlucbh3ko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767644651; c=relaxed/simple;
	bh=CZ59YjGq2MG37QyX/0H6RS0R6MBEKRCOEDepFB3OHfw=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=MYsuLCwjlILKV3CxSpmYlvyyFJ/jWMeOzZmX5lT62kM0X9TbYaiCRCaoNsSGkYsUbVRj+8NQ2gBBawoxyk4pVvYuhehAS5LKB3B2KyI4FPHGJR8zGdcQboWPPgxDE2JIYnRnXFORxWl8ddNrApbrXNY7PxCtzwM0RyU8qwzLrmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kAuZa3cD; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 605CqlP0004439;
	Mon, 5 Jan 2026 20:24:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=CZ59YjGq2MG37QyX/0H6RS0R6MBEKRCOEDepFB3OHfw=; b=kAuZa3cD
	NMkjaKqVzcPHunDurNP16rgaK2o6Dxij7Fj4aTYBIS721KktyTjbl2RWir9FjJ+e
	fASxmDipRI5nYZ1vTqtK9jMklOB3+KuiqELjL7DSFydprH0dBzPtC9HEsR24kFna
	qUGXFy83dLjqHhynlE55BnygWCIqFrEidIULTGEWWr/iJJnvtQjor+bTIUmOSp0o
	5ElgRH6alMKMATQ+vm5lxvXxTCRbavC8ZTlCB8jgiR7oezry37sfbnwi0/Mk9pHw
	dr23wpfyQgU7L/51Qr2dkJlQP9U1TCJEBtLqnatFY58fUVJqRkByOdbjsUEQAKIg
	540J8B4rv9NKdQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betu613de-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 20:24:05 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 605KLuHA030415;
	Mon, 5 Jan 2026 20:24:05 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010053.outbound.protection.outlook.com [52.101.56.53])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betu613d6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 20:24:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mp76BGRqe2r0spXQWu13cEMB7IvufoXc+TBWgZO+xfmkXEcD+KJtDEEifJXzGB+HISJ213hJeXNDOFlb32Gp3hRKJHP1aT/myz8XWhQYqZFR4RW3qfMWqsLkrGz1/xUh5i4lpomqhlO05W9ELUftIercpxpWJMGb/YXcDl4bcDd8JzMbrGyG5H/jY5V/Lx41EVLrNUNJfQxEA1+aFGGU6kmqAPhCbMFbREhphBM/c+fQuBaVlQp3bolPxFaLwQt1RKPVGgr71AuRvuP0BkVkLrqI9XfH4WC9zE2P8GD77H3AAzA9jj70gk7K5r6Ygzc6uCrRwnKnqkxJUyNUANEOjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZ59YjGq2MG37QyX/0H6RS0R6MBEKRCOEDepFB3OHfw=;
 b=LRxbVw5ooz2OU4qtlTXuEX+N1b8SHqLdx4p8fY+x7t/LqT87Hh/7hqRNKKUQYDbru/buxHN61YsY4VtOLZCgFnHuJHIDjrGkZdpZsqYAISgetsMNg5vlr8AwXLSxKAHOWdpGgtfF24+/iHdXXCLzlr9V+7zoYvb1EczMY4IVXpclg/nMn8p3ikWXgB18ZDG8pbRoJ3T+Ub0VdoykWwi4QahAh0SYMDLKcggcJiaMLhMPrTD+irVtUJoaa5ElaMBa80+QPQpQxcZN39TtRsH94KEoi1pqd40ZfeGXBPv2Narl10fxYGNVyfc8oWO2OghRJlUyksc4n7tJECyOm6k6hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DM4PR15MB5996.namprd15.prod.outlook.com (2603:10b6:8:186::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 20:23:58 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 20:23:58 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
        "cfsworks@gmail.com" <cfsworks@gmail.com>
CC: Milind Changire <mchangir@redhat.com>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH 1/5] ceph: Do not propagate page array
 emplacement errors as batch errors
Thread-Index: AQHcegDuwOFplSSGlEaQAPlhRITstrVEDm6A
Date: Mon, 5 Jan 2026 20:23:58 +0000
Message-ID: <24adfb894c25531d342fdc20310ca9286d605e3d.camel@ibm.com>
References: <20251231024316.4643-1-CFSworks@gmail.com>
	 <20251231024316.4643-2-CFSworks@gmail.com>
In-Reply-To: <20251231024316.4643-2-CFSworks@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DM4PR15MB5996:EE_
x-ms-office365-filtering-correlation-id: 6d5c01ba-9f27-49c6-4696-08de4c985b40
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MlBieHRtT2gwS01uMUJ4RGZ2SnpxSW9zSW9iUE1WalRRbTV1ZXNKd1dwTHQy?=
 =?utf-8?B?djhhcjZZSEJ0emhpR2JYNUdKQUlSRHNNMVo1R0pkZ3ZoVWdIOG5BVmE4RWVZ?=
 =?utf-8?B?V3ZZRHVhL00yTlJKc0h0OUljTXNBd25vU3RCUlJuYXYyTHdVelRxSk04NUN6?=
 =?utf-8?B?QUhDNHBFUG9KNWVMU2JqanlMOCtQM3hHT01lTmFWSmVIaVdJSVQwYkl3a0ZD?=
 =?utf-8?B?OTlhQW5QeThGRFRTUmxYRHlTOWRlc0R0blQvV0o5RDBjNkg3TVJFdFJMTDZD?=
 =?utf-8?B?NzVvb0RYSFJXY2JlbGUxMDN6U25wc0UzYTFLRWU0VGRMandrdHhacHNsY25Y?=
 =?utf-8?B?b0VJTXJiTldqejFGMUh1SlhnT3ljNnBhaG5oR2pqcnhXWjZyZHBlS1VZcEtl?=
 =?utf-8?B?eUNwNGovZEZpT0ZjTTZMUE4yS3hHZ3Nmc1N2K2xNSjdsRWpnbi9SSlpJOTRz?=
 =?utf-8?B?T1F4SW5VUFc1dTkreUkyK1h5aGF5T0RyamhOeXhqWTMxbHdYMjgvc0JiVkFO?=
 =?utf-8?B?Q0lPV0kvdGI1N2JIaGkzWkNnVTFtRForczVsQkg2ckMyMVEwTkdkTjYyMnBW?=
 =?utf-8?B?d2wra3E0UCthUi9ObThiVHV1VnN4Y3F5K0ZOczlQMXhmNmdQZnF5eXhjYWpw?=
 =?utf-8?B?NXpWdHJ6N3Z5WVJqYUl6N2s0bGhuQms0dmgvM2hRTVBEV0FLYkNUc1FPWjIy?=
 =?utf-8?B?RTBSallqL01ZMDYybXpHM3ZBaW9ZV2lvUmV5VXB0UlBBZG5sVmU0b1N6bjU5?=
 =?utf-8?B?ZlQxbVVzZEJhL0daTkpLOXpTU0tiUGNnYXE5QXRnK1k1MkJWU2FxdXp0Rlpy?=
 =?utf-8?B?QUR6aGl1MDVmNmhzeDY0M1lwZzAwb3dlTGtjMWVOYkM3RTFpeWUzK1dlSDY0?=
 =?utf-8?B?dXB2cjlQVTVRRVVOYStoMlhsWjJJdUdkbUNyL3RobmpEU0hIL0tlbVFTVXhT?=
 =?utf-8?B?UWJPbG9XSDJnTmpITmtzMEJiNnZsVkIvdTBocUJ5MWhmQUdubWEyQzBkVGli?=
 =?utf-8?B?dEVDQ2dhRmM0akxTUDRLUlgrWjVlTE1pV1ZWUUtOeDliLzdORDk4NWJUS1VF?=
 =?utf-8?B?UVduVHMrbDZnZ1l1V3pEY2YwcmxjV3lsdy9zTlRrUDJ4SUxkekNwcU13VWJO?=
 =?utf-8?B?Ly9WWEdtck9wdXZHTkkyd2ExNHFUQjdkb2ZkTTUrRklUOXNIVnhMd3NvNGRI?=
 =?utf-8?B?MFExM0FyQml6LzErNWx6MmN1WTgvTTluODlvbU8xd1dLMC83S1F4ZHJVeitG?=
 =?utf-8?B?SEdSMk5NRmpGZkU4TVdGU3hpSzFIMExJWjJIZm1UcStsQTg2QXVEN0J5bWRm?=
 =?utf-8?B?eEdrRG4yNnZKY0NFRG84WGJyTTVBQmpPTXdZZEt5cFVLZTJ3N1IrQWRvam55?=
 =?utf-8?B?alVzWUlHbzdZRnpBMWlRMExYdmRSdGtnUEdURlJzSXVwcUhJMENpbzRIYWMz?=
 =?utf-8?B?RjFYS203WlQrbGE2ODJsTS9JS3huUm1rNUIvUzJqWDJvaThmSkU3TTZUNWg2?=
 =?utf-8?B?M0ozZ2pwS2EzSVlzVEo4SGNsVG9DMFZtQWd1TkJuZUsvekF2ekpFK2V6NTQ5?=
 =?utf-8?B?Nm5ZMnpiZnMzQ0s1cTR2TVRaaGFIeUJYbXh0QWkxdU1ZaHIrWFZNRHp2SVFR?=
 =?utf-8?B?Y25hKyszcmlEbTRtcy91T3FqbmpvYTFDWXN1NTg1aHFrMmk2WUhicUNuZ3BQ?=
 =?utf-8?B?UkRzbTBkTzFBNEhqbzFpbVk2MmVVQW13eWhaU0hPK2JnVWFMaldwZkNRVUFQ?=
 =?utf-8?B?V2VZOVYvWnlCcGpOakIyM016TkdhdStFM1RvUEJPL3VGR0t6cVk3Tms0dVFq?=
 =?utf-8?B?eHcyTFY4V3ZnZ1d4bmNqS21uZkRtNVRIWE11VXF3ZGUzUlkraVR6UzFMWmMz?=
 =?utf-8?B?RDBVZElKdWNoeU9wT2dsN0ZWY2lsL0xZUXAvZTVVOE01a1dmZWlpbWV1ZGNj?=
 =?utf-8?B?Tzg0TXphN1dGK2p4OG8zS3h5L052WXpKSHgrYVZUTGM5eTlBSG5HM2d5VXdX?=
 =?utf-8?B?eVhKdVNMSE1pZkZPU1VnQzI4OU15QVJRK1A2bWROMzZ3a1hmSEdTNjljblJh?=
 =?utf-8?Q?j+H5Y5?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RlNKaGVzL2FSZ1pacWJmZDBFbFVVcWJsUlFXVGhjTTgrZGFpOXFxdm5UOW9h?=
 =?utf-8?B?cm54WWpaNFdTVlQ5ZXVGc3RlcjZhSm8zRWhpWno4TjZ5T25iTEVucVZFYzU0?=
 =?utf-8?B?S0xseVRiYytLZUJYZ2pMNGRzV0JtaDkxV2l4ZFE4RytodkNiU3dZUUFZQ29M?=
 =?utf-8?B?Y2ROcVF1OXhueVg0azhBSkt1bitYVFdCejlFUWoxWGdDeDE5OVNmT2NIZXh1?=
 =?utf-8?B?QjZxc0hKUWhoYXBNWFFlZ1N2bDJxbHdmR3ZiazJxYSt6QlVnLy96UDAzT2Rh?=
 =?utf-8?B?cHdTOU1xUTNDRExBTWsvVHgxaDkvMi9Ma2xaRnMxMHdQTklYOXdhR3BXalpt?=
 =?utf-8?B?M3E4K2FpbDNNK0dQRmMycWlhVXlTeUgwWTQ0a2s4UUM3WlNhWE44MWlDMDVi?=
 =?utf-8?B?TWdLYkJuams5Z05WeHZaYkpSSVNLbEpaVEVXcUdxM3RYVVZDRXdZUHA1Qkor?=
 =?utf-8?B?RFljSklUNy9NYngrMjF2VmkvVjRUeVh2WG9SUm1HMFJBVlpJWnV5WmFXaW9Q?=
 =?utf-8?B?anZVd2tENGFhOTJ2SUNKaTF2RzNSL0dkUHdqbTVxZjFaYlRkb3JzcnNyYmFa?=
 =?utf-8?B?andoZkNWNU0yOTh4QThuV0YyaHlHaGxmSjgxOGZRTGI3VnhrSENLWDM0K0dT?=
 =?utf-8?B?ejF1ekkxMlhpK05XMUdXL0F2bmxqNVVRbTFnMnpyZkN6VFpoU3Y4aHR5RkFB?=
 =?utf-8?B?TnROMDdCYnZmWVVwVGZ3b05odjVhU2F5Y1VqZ3Vra1Z0NFpYVDhieDV3alVu?=
 =?utf-8?B?QVNpbjNVTUttUndXeExIVVpoSHBiSmZtdTBLdFZSYjV6TEsrVzk4WkU5TmFv?=
 =?utf-8?B?VFF3QVJPTkFRWWp1VnZyQjh0cGF5emlJbjJkZmViT1BvQ3FUWFB1cDg1NkFX?=
 =?utf-8?B?TkUrNDJiVUR1a2hveU95eEpVRHkzNlNKbnlNRi9DNlI0QUY0ak1CamU0RUNq?=
 =?utf-8?B?a3J6RXhSTjlRSk9DT1BTQVd1dkFlUUZ6Y2c4cUcyQnREbkhadUNhN3pHaXVX?=
 =?utf-8?B?UmJSQThOMjdMUG9mUkd1MitIaktGeFVZeFR0Z2ZXT0psUldnMlU5eU53N2VY?=
 =?utf-8?B?UW1xK0MxQVIrQkd6VmdiNEVscmJnNzdHMjlTK01VY2c3M3RqUlF2UGFEV1hP?=
 =?utf-8?B?dE5MdWl4SXZVbElBSmNxKzRISCtNRGtucGhQeE5xVHBLeWNIb3BPR3VRd0ZT?=
 =?utf-8?B?SDJPMUJsd3U0SlhKZExYQXFNTWJyYTFkK2JRQTYvT1c2WThrSGZ2b3ZlbjZ6?=
 =?utf-8?B?SUo5bFRsSDFQWllRSFdETDVTNXNKM0Vkb2tsQUlzU1Y4VmlHZWpodXRFWXBQ?=
 =?utf-8?B?b3VEQ1ZlTTVjN3V6UlBNdzJ0cVNwczhneFBkM2VWZGlTekpVSDUxN2Y3ZEZy?=
 =?utf-8?B?THM0R2dpOEtVbmRkQW1Ic2lQdzIyL0pJazJicnZMWmtLR21Mc2N0d3VEcnNv?=
 =?utf-8?B?NlhCVXdTYktINFdmcFFWZk9WZVl0V01pdXI4MDNWenlJQ1VaUkhqRmJaZEJB?=
 =?utf-8?B?bnphN3pwaEV1aUxBUXpGYVlBZHJjcERmcjVFR2V6bHZGUUhsNmRYNXVJN0M5?=
 =?utf-8?B?eDBtNTQ1MlQ4dmR4SXBMMFgwRXMzK3R3Y1VWcm1zT2pGbENBZ21OdnZTRElO?=
 =?utf-8?B?bnVpMXIyeGxHVDdBZjhJTnlSd0FteU9lNWJHNmJ6eHBGNlF4clVJMlh1Nmli?=
 =?utf-8?B?cDZrSE1DSTlnSDJ5b0srUVVWTEdIUWZVRTBOYnpsMXpjb3Bqb3EvZkYrRnBR?=
 =?utf-8?B?eW9SQ3c4MXpEVmtNcWY4RVF6T09OTDk4OUVxWWFJWU9sb1ZOK1ZZTFdMdnMy?=
 =?utf-8?B?UHVGd2ZNYlF2Wi95cnpFR2R2K3Z5RlZsYzJoejhKSW9UMmMycTFVK3VtWG9k?=
 =?utf-8?B?d3FLaG1WT25mZmtwZ0s5V1cxZy9KM0FEWXJ0ZHV3UjBXUk84dWQ3MzlVQmgz?=
 =?utf-8?B?Tm1rcVpNTmxtZmhzVi9QWXE1amxBdjJPanBDUmNzU1ZHdG5lNWNjSjlnd3Aw?=
 =?utf-8?B?WmFSZDJKc1cvbnl0Kzk0cUhKejBCczZhTGthb21FVWpQY21xMFl4b1kvVHA0?=
 =?utf-8?B?TkZCTkhZVkZUZFdzbXpMcnlLMlpxeVFlaVJVUmowOXBQa0pQa0J0UU51YWQ3?=
 =?utf-8?B?YWc5WncyNmZ0aTN4bGgzZzAycWxLOXM5YW5yMzlFMzFhakQ2eVZVRCs1QS9D?=
 =?utf-8?B?UG5MZTM0cVdjaTJYcllpSGg0OExNTEdMOGtpMkNydWpRSWUwR2hzUVlqdkNr?=
 =?utf-8?B?OVRqVmR4SXBJNDRMVlRPY0hlNDFJMTlGMnlRQXVOUjBLeEhaMkF2dEYzR3pG?=
 =?utf-8?B?a1pQVFl0bm1HbWphellPQXlLZjhrUGlVOFZVdE5QVERmVzBvNjg4ZEZSL25Q?=
 =?utf-8?Q?38JD6XVwb2A64Y+x4CZDjCouaNefB7cAe+V7f?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0295475EA567D941ADF7F912F099DDA8@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d5c01ba-9f27-49c6-4696-08de4c985b40
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2026 20:23:58.2777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q6n1IrgBLomvO94ldy0EIfnT8uXTv0ZREGuAlnNdwanVJvoZQjhPzXDnwzW99LcG1l9ni9/c0iXwhOXBNsVp5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB5996
X-Authority-Analysis: v=2.4 cv=QbNrf8bv c=1 sm=1 tr=0 ts=695c1de5 cx=c_pps
 a=PQms4psfS+nBHIg3Mxsk7g==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=EzDU-co_b4O960HfUWoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: DbocZOXooC6iAhC5m3Bc8T2kEDvAsEsU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE3NyBTYWx0ZWRfX6Pc9Az6A5vqF
 WFJ5+44UjVPkW8V/GbvcK+0iewH/1E9nwC1G/1soDF3/8qlCInlMY9nZrtq8N8EvTeEKJgqGc8s
 5yE+nFgMUw5smLB28i8ldJenwnzwiu/KW/bM0k+dZoLHE3YAikMOHIK8MrLQqed3RiU8SXfOdY5
 +xzNzvwc99b1czpGYXNG60/IIjr7XDfBEsdaobXQjOWTgpZbrsWK8+6X/0G2Jd/oOizXCASvdWJ
 rCPwNXUlJscDb6LkwuZw4f0LN/4tXDt3i5mnx4w21Rdj1kxzMj4djfWivkwoVf9BqjCgQ0KE+O2
 OW9gzmR4PEQkDcGw4KMYGxaJYwsYKCFAMCMsdKb75ZIRn/DWYuiTAj4efFRNc5MXu9g9ih5j2pV
 eyh00dLWsE4chJ5toZ65/MCVCKA8E/P+cDedUNCpvYf+JS0d2Y26H+ZnDWbqtiOur5v3fQAqTpc
 1VRUoXmXW4wtYKFCYbQ==
X-Proofpoint-GUID: 6c_xMWQPeMaBai7Sv8-Fm4fMm4QGhxQu
Subject: Re:  [PATCH 1/5] ceph: Do not propagate page array emplacement errors
 as batch errors
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 bulkscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601050177

T24gVHVlLCAyMDI1LTEyLTMwIGF0IDE4OjQzIC0wODAwLCBTYW0gRWR3YXJkcyB3cm90ZToNCj4g
V2hlbiBmc2NyeXB0IGlzIGVuYWJsZWQsIG1vdmVfZGlydHlfZm9saW9faW5fcGFnZV9hcnJheSgp
IG1heSBmYWlsDQo+IGJlY2F1c2UgaXQgbmVlZHMgdG8gYWxsb2NhdGUgYm91bmNlIGJ1ZmZlcnMg
dG8gc3RvcmUgdGhlIGVuY3J5cHRlZA0KPiB2ZXJzaW9ucyBvZiBlYWNoIGZvbGlvLiBFYWNoIGZv
bGlvIGJleW9uZCB0aGUgZmlyc3QgYWxsb2NhdGVzIGl0cyBib3VuY2UNCj4gYnVmZmVyIHdpdGgg
R0ZQX05PV0FJVC4gRmFpbHVyZXMgYXJlIGNvbW1vbiAoYW5kIGV4cGVjdGVkKSB1bmRlciB0aGlz
DQo+IGFsbG9jYXRpb24gbW9kZTsgdGhleSBzaG91bGQgZmx1c2ggKG5vdCBhYm9ydCkgdGhlIGJh
dGNoLg0KPiANCj4gSG93ZXZlciwgY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKCkgdXNlcyB0aGUg
c2FtZSBgcmNgIHZhcmlhYmxlIGZvciBpdHMNCj4gb3duIHJldHVybiBjb2RlIGFuZCBmb3IgY2Fw
dHVyaW5nIHRoZSByZXR1cm4gY29kZXMgb2YgaXRzIHJvdXRpbmUgY2FsbHM7DQo+IGZhaWxpbmcg
dG8gcmVzZXQgYHJjYCBiYWNrIHRvIDAgcmVzdWx0cyBpbiB0aGUgZXJyb3IgYmVpbmcgcHJvcGFn
YXRlZA0KPiBvdXQgdG8gdGhlIG1haW4gd3JpdGViYWNrIGxvb3AsIHdoaWNoIGNhbm5vdCBhY3R1
YWxseSB0b2xlcmF0ZSBhbnkNCj4gZXJyb3JzIGhlcmU6IG9uY2UgYGNlcGhfd2JjLnBhZ2VzYCBp
cyBhbGxvY2F0ZWQsIGl0IG11c3QgYmUgcGFzc2VkIHRvDQo+IGNlcGhfc3VibWl0X3dyaXRlKCkg
dG8gYmUgZnJlZWQuIElmIGl0IHN1cnZpdmVzIHVudGlsIHRoZSBuZXh0IGl0ZXJhdGlvbg0KPiAo
ZS5nLiBkdWUgdG8gdGhlIGdvdG8gYmVpbmcgZm9sbG93ZWQpLCBjZXBoX2FsbG9jYXRlX3BhZ2Vf
YXJyYXkoKSdzDQo+IEJVR19PTigpIHdpbGwgb29wcyB0aGUgd29ya2VyLiAoU3Vic2VxdWVudCBw
YXRjaGVzIGluIHRoaXMgc2VyaWVzIG1ha2UNCj4gdGhlIGxvb3AgbW9yZSByb2J1c3QuKQ0KDQpJ
IHRoaW5rIHlvdSBhcmUgcmlnaHQgd2l0aCB0aGUgZml4LiBXZSBoYXZlIHRoZSBsb29wIGhlcmUg
YW5kIGlmIHdlIGFscmVhZHkNCm1vdmVkIHNvbWUgZGlydHkgZm9saW9zLCB0aGVuIHdlIHNob3Vs
ZCBmbHVzaCBpdC4gQnV0IHdoYXQgaWYgd2UgZmFpbGVkIG9uIHRoZQ0KZmlyc3Qgb25lIGZvbGlv
LCB0aGVuIHNob3VsZCB3ZSByZXR1cm4gbm8gZXJyb3IgY29kZSBpbiB0aGlzIGNhc2U/DQoNCj4g
DQo+IE5vdGUgdGhhdCB0aGlzIGZhaWx1cmUgbW9kZSBpcyBjdXJyZW50bHkgbWFza2VkIGR1ZSB0
byBhbm90aGVyIGJ1Zw0KPiAoYWRkcmVzc2VkIGxhdGVyIGluIHRoaXMgc2VyaWVzKSB0aGF0IHBy
ZXZlbnRzIG11bHRpcGxlIGVuY3J5cHRlZCBmb2xpb3MNCj4gZnJvbSBiZWluZyBzZWxlY3RlZCBm
b3IgdGhlIHNhbWUgd3JpdGUuDQoNClNvLCBtYXliZSwgdGhpcyBwYXRjaCBoYXMgYmVlbiBub3Qg
Y29ycmVjdGx5IHBsYWNlZCBpbiB0aGUgb3JkZXI/IEl0IHdpbGwgYmUNCmdvb2QgdG8gc2VlIHRo
ZSByZXByb2R1Y3Rpb24gb2YgdGhlIGlzc3VlIGFuZCB3aGljaCBzeW1wdG9tcyB3ZSBoYXZlIGZv
ciB0aGlzDQppc3N1ZS4gRG8geW91IGhhdmUgdGhlIHJlcHJvZHVjdGlvbiBzY3JpcHQgYW5kIGNh
bGwgdHJhY2Ugb2YgdGhlIGlzc3VlPw0KDQo+IA0KPiBGb3Igbm93LCBqdXN0IHJlc2V0IGByY2Ag
d2hlbiByZWRpcnR5aW5nIHRoZSBmb2xpbyBhbmQgcHJldmVudCB0aGUNCj4gZXJyb3IgZnJvbSBw
cm9wYWdhdGluZy4gQWZ0ZXIgdGhpcyBjaGFuZ2UsIGNlcGhfcHJvY2Vzc19mb2xpb19iYXRjaCgp
IG5vDQo+IGxvbmdlciByZXR1cm5zIGVycm9yczsgaXRzIG9ubHkgcmVtYWluaW5nIGZhaWx1cmUg
aW5kaWNhdG9yIGlzDQo+IGBsb2NrZWRfcGFnZXMgPT0gMGAsIHdoaWNoIHRoZSBjYWxsZXIgYWxy
ZWFkeSBoYW5kbGVzIGNvcnJlY3RseS4gVGhlDQo+IG5leHQgcGF0Y2ggaW4gdGhpcyBzZXJpZXMg
YWRkcmVzc2VzIHRoaXMuDQo+IA0KPiBGaXhlczogY2U4MGI3NmRkMzI3ICgiY2VwaDogaW50cm9k
dWNlIGNlcGhfcHJvY2Vzc19mb2xpb19iYXRjaCgpIG1ldGhvZCIpDQo+IENjOiBzdGFibGVAdmdl
ci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IFNhbSBFZHdhcmRzIDxDRlN3b3Jrc0BnbWFp
bC5jb20+DQo+IC0tLQ0KPiAgZnMvY2VwaC9hZGRyLmMgfCAxICsNCj4gIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL2NlcGgvYWRkci5jIGIvZnMv
Y2VwaC9hZGRyLmMNCj4gaW5kZXggNjNiNzVkMjE0MjEwLi4zNDYyZGYzNWQyNDUgMTAwNjQ0DQo+
IC0tLSBhL2ZzL2NlcGgvYWRkci5jDQo+ICsrKyBiL2ZzL2NlcGgvYWRkci5jDQo+IEBAIC0xMzY5
LDYgKzEzNjksNyBAQCBpbnQgY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKHN0cnVjdCBhZGRyZXNz
X3NwYWNlICptYXBwaW5nLA0KPiAgCQlyYyA9IG1vdmVfZGlydHlfZm9saW9faW5fcGFnZV9hcnJh
eShtYXBwaW5nLCB3YmMsIGNlcGhfd2JjLA0KPiAgCQkJCWZvbGlvKTsNCj4gIAkJaWYgKHJjKSB7
DQo+ICsJCQlyYyA9IDA7DQoNCkkgbGlrZSB0aGUgZml4IGJ1dCBJIHdvdWxkIGxpa2UgdG8gY2xh
cmlmeSB0aGUgYWJvdmUgcXVlc3Rpb25zIGF0IGZpcnN0Lg0KDQpUaGFua3MsDQpTbGF2YS4gDQoN
Cj4gIAkJCWZvbGlvX3JlZGlydHlfZm9yX3dyaXRlcGFnZSh3YmMsIGZvbGlvKTsNCj4gIAkJCWZv
bGlvX3VubG9jayhmb2xpbyk7DQo+ICAJCQlicmVhazsNCg==

