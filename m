Return-Path: <ceph-devel+bounces-2995-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C7D4A75006
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Mar 2025 19:04:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0DD7D7A7032
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Mar 2025 18:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2838D1F130F;
	Fri, 28 Mar 2025 18:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dtjo+EMB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5595B1E6DCF
	for <ceph-devel@vger.kernel.org>; Fri, 28 Mar 2025 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743184826; cv=fail; b=sTNNovaEQh/QHPXo+rsBMI1fMMysT38IqJ/ZQsJgL9dJ2de9SY/1tNc+jt7O79pZpo3LyjpvZBI4gf5tEvdofj7r4PiWq2imRWTJ0OKzsM9Ymb16ou4W0Wr9Kp/RvFKE0hXqv3iCLZlj+WA0//pg3GHOHkRtm9uIkXgCEb23ZAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743184826; c=relaxed/simple;
	bh=vGXHA1Dzv58Iwi6DgkeYI/aLsnjzZH/2wMGhRaRS0L8=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=eucJM2jTC8Wnj9ESKP64zbdd/0Qvu+423T0ozb8mvc2178wtQGPM/8aPKl9/iH9kypDsfaR/aIitfC1/u34nZrbZ+9B3EjYkD2u7JLbL2lIq7L0UazhpFuH5A55VTM6k9HhPOele3KBYcm2qL/XTeLxZ7BxEBxYY+pgguPudK20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=fail smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dtjo+EMB; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52SHBOfK011466
	for <ceph-devel@vger.kernel.org>; Fri, 28 Mar 2025 18:00:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=RZ+w2NgEGnT59DmZp9S9XYixSzTkyAhXCCHCcCro2q0=; b=Dtjo+EMB
	HADNjeewbgt9eaUkVWuwLjnD4tBehN8WXDmKRH/UyQAD1pwJ+FRoOW+sVIQn8Ru1
	FdFs6G66BMsZNVwA1U+tG1wQwB6ymR1b44D9S8GwfTPP8c/QDKS/qvHlEGMV8RVW
	W0Ur/scNUhQgqXUr7814tVEVz5fUE/EkNb8MijnKeQ7ku2CZ7iXl9uN2LIMS0kMz
	155QuTMrWpSqTw3EuGDwXTIR8RPKD2AXkmAYoxMle49lMVvcOwxP4Wd/hqTnL8fS
	+ZuJ27a1AZu3Ap5Seu5qAkJMm8mcnqS3PDOPICBtxaZ40KSINiqUVeoXrTM9juCa
	5au9Ipdbmh0Xwg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45nyxxg855-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Fri, 28 Mar 2025 18:00:24 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 52SI0NnT024536
	for <ceph-devel@vger.kernel.org>; Fri, 28 Mar 2025 18:00:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45nyxxg84u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Mar 2025 18:00:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YuqvzwOmdgBYwKR9zR4K7LuTGazoQtp4LL/AVmxEFFq9PxKKSbX4yw9T2TIHbfByeRrslAsySbjLApjG3BPMQ07sXVdMqfMtX0iG19w+dKzan8SC11Uy/ZzE8vd8IzaqydtS1jHBvN11x1qrfzXKhnWoF1ZK4PYY169AJYx5sj/ASHIpXpAuyehpYsXQO1ii/IbA6tYY3YR254xGjsTxzyW65sTIzqBkWH8OgtI5h2fC1nKkHOQK29XkBEw0gjJcnRwrh14aqhAD1ZUUlRM/vPlACuZgQGEEQCFRexj8+igPk5eeau3fdru4ZB1a1cy21+bm43MLuD4/jXmBTzeOoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVwJ2vQiNv4jR7IAFkRfInLe5hoHWFCIc1tjssrVfJg=;
 b=Ju3GrEUX4Eo/XFT158oyyzhPCH587yuyvQLoVIHJ0NDnqVM/LIDvgfjsA1sBC48nLNryt45EUK8iLcS6CWTaIwgbGliR6lw+HRMn4464ezS4tkMPS6LBLXdYgpkCz60RUy7+4MrVFcHLkMiDi4W1uIZZ/N432uUIpeynvpCxoexIShn+qIhmBJhfd+Dpmnq6TQDjHz9WyTXDMwagx2VeEqr+/GxTer8nXuwfCx+RLkIxHJijia9s6HJ5yaD724gLYkKA0xREH8Eu5/r1KPLoBiJJSv8I18Ynns2y+vK51BSgRtn9PaDF9T63fMA6OIa/RDJbCaLnqhTecAC/ZHUV0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BY1PR15MB6151.namprd15.prod.outlook.com (2603:10b6:a03:533::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.31; Fri, 28 Mar
 2025 18:00:17 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8534.043; Fri, 28 Mar 2025
 18:00:17 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>,
        "oe-kbuild@lists.linux.dev"
	<oe-kbuild@lists.linux.dev>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "lkp@intel.com"
	<lkp@intel.com>,
        "oe-kbuild-all@lists.linux.dev"
	<oe-kbuild-all@lists.linux.dev>
Thread-Topic: [EXTERNAL] [ceph-client:tls_logger 19/40] fs/ceph/super.c:1042
 ceph_umount_begin() warn: variable dereferenced before check 'fsc' (see line
 1041)
Thread-Index: AQHbn6IJVeRSqSYfvkWdt/tYe1lG+rOI10KA
Date: Fri, 28 Mar 2025 18:00:17 +0000
Message-ID: <86150e6570b56cc35e8a3b264b60b65434d39b15.camel@ibm.com>
References: <7ffc0531-0240-4a83-8062-e77c7710d93d@stanley.mountain>
In-Reply-To: <7ffc0531-0240-4a83-8062-e77c7710d93d@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BY1PR15MB6151:EE_
x-ms-office365-filtering-correlation-id: ad512562-4a37-4527-e84c-08dd6e226605
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QUtsaks2QVBRZ2tsTC9xSDNwUWlDaEhETVBzVmdocklpZVVQZUIxM0Nsa1gx?=
 =?utf-8?B?enh6S1RSZ0twQ05sWnRkNjN4S0dmc0dCQnZITTVNVHpORDRLblkxU2J6SU9M?=
 =?utf-8?B?TWlHcHBJY3lKRG5ONFVMeDVXZjFhbUZVK0ZYemZRK1dhWWhuNG9Xc2U0UWVK?=
 =?utf-8?B?NkRJdWcxZU51cDZMdW1TRndDNjFuSkpVbXVpLzNqNzlOQ3lGWXkzT0crRGRX?=
 =?utf-8?B?TnFqYUhQWURxd1A3Q0orQS96M0ZFd3M5ZnA5NFc1UHRTRkxLdFdsYkJ3c0dH?=
 =?utf-8?B?ampzMU9lYVFHekcyV3htays4NEs2dHN2aG1YOVdWQTF5eS9LMXRVMmJYcVlk?=
 =?utf-8?B?TXlxREh1TDdMSFRJM3U0VFdpUThUbDJxQStVUEhlZUlCcEQ2YisyeG9pRWFm?=
 =?utf-8?B?eUhYSnB4ZFlSeWprTDg1cFIrc1M1ZDdmMzd6Tms1WUVjR1UwNEdDNzZGaDdj?=
 =?utf-8?B?dmk2V1hlV1dJODluZWVBVnh6OGVtVVVxUkVpZ25NQ3BVUnUvelJINEdiZzQ0?=
 =?utf-8?B?QmxRMFR0N01qckMvU1NTZVkvUm01QXJOeklsYUpIOXVMcmxRWlUrSGlwVFA4?=
 =?utf-8?B?ZWdyZ1kvYXA2azBpTjBBd0dUaWFuSFJuWlJUK2xKTHI0SWc0TG14TXYvMVVz?=
 =?utf-8?B?VS9TRGc5akdQTmgybzdxdjhVVldGaXZ5OEpxcUZmNDFZM1V3cDIzWWE5bXJR?=
 =?utf-8?B?OGZvQ1RkNXM1L2REUG1ZTWdnNWx2U0hhUy9yWVAwT1k2SUFiTFNuU1FIaHhB?=
 =?utf-8?B?eFg3VzY1WUx6MHhYWjJ5TCs0cS9xVGRseTBCRWdLWlFqR3RLV0dWNEdRK0Vh?=
 =?utf-8?B?RVdFWm4xWkVpd0VwY2haak9xTEZNVTUyT2VIMDE3SWx5K3JHdlRwOUt2WjBl?=
 =?utf-8?B?Y3lxUmMxVEJKcXI1VEhNOFB3SlhZbjJYUWI1ekU5Y3VLcWloWmpLdmRuN3o0?=
 =?utf-8?B?bU1RemJBRmJ0a0o2MHZEcGZtVHFNOFA0cW9SZWxvWWVDVVRMNU1YVnFlTXlX?=
 =?utf-8?B?SnQxTjFNVGVKRFdVd1Q5cmdpUG5qdUhsSzFOTTBHa0hDS3pWMTdzcmRNRUlZ?=
 =?utf-8?B?VHlicEowQ1VkL2hjZ0Y5SlJKOWYvZzhIN0NGYmhDMlppTzUvcVQ3MnJrUU5j?=
 =?utf-8?B?N0p6am14ZkdyYVl3MkV2eFhaeGFEa2FScnJrZjhXcUVtNDJKNHdiY0tSQ1pV?=
 =?utf-8?B?a0VTcGhSQ3dOakFDMUNsNHhaWWtwWGtMRFhmWXhINUlZblJ2cWc3eTRIcVlJ?=
 =?utf-8?B?TVRiV3ZMVEswSmE4a3VGOXdoWXYrcndqaE9VTm0xM090dWFTVlNHYi9GSlZ1?=
 =?utf-8?B?WVJLVG9pSjh3UlBCbGtpZEh6c3NLVGpuZEs0eEFPMTJTSXVnR0J5ZWgzRnV0?=
 =?utf-8?B?ZlE0a0F4TUNrTUhWRzYzaWFzTmtQL09WdnhHNStpRmtzQXpjODlYU1VWTHlG?=
 =?utf-8?B?b0NSdWxJc3hLOVdrWmVqNzJhTUFSWTQ0YXhqd0x1L00xT1A0YXhZdGNHRlNI?=
 =?utf-8?B?ejFELzlqcks4dHlkakdSRkNDWTFqNGdCNlpnQmZkeDY3NkNBSHFnQ3c3WjlH?=
 =?utf-8?B?NVhVSFBrVWQrT2xMR2g3T21nSWF5TzFGVzVmdndqTkNuRXRxbVpxR0dza2Fh?=
 =?utf-8?B?UHE3dGpxNmp1NllQRzVQS0JvTXgxaUdOOUZxaGFaZlhraFNQMzdlOEtNY0Ny?=
 =?utf-8?B?T0sxdmV4WCtWdmVHUFVYMU43Y2xJWFdIdEoySlJ6R2xta1dHb0Q5cERiTmlX?=
 =?utf-8?B?TWVBeTJzY3c5d3BFTFNnTDJEQUFDU2RFcmNyTm5PSGVYREZaMHVocVFLSnd5?=
 =?utf-8?B?ZmxIRmh2ZHdNbjVUUGs2c1o5WjRmeUxBMUU1bHRhMi9OdjZnalMwRUhCVnZj?=
 =?utf-8?B?SHZTYTZDZGpsT29xUHF5bHBiUmh6d3d4ZjdDUDdwdHhCMUE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OEJ2a0tBOXVvTEZ5MGRrd0JXbnNiQVNoakZGRVkrbzFBZWVhRWFjNDlEaEVl?=
 =?utf-8?B?ZmRQb2xCQ0RwdjhyN0pDanM0SWcxZk00WEg1T2RUZ1NsUUgzRE9lUGptclM1?=
 =?utf-8?B?WXlSUUZmK1oxNnpmLzkrRkNDK1FxdTdNRjhNbUFTelNhT3dxS29MMkRWY0ln?=
 =?utf-8?B?eEhkSFc3VStCSTkxZTFDelBDQ3Y0OWVIUTFGTzhkYkZ5aThiZ3RFc0krZ3lj?=
 =?utf-8?B?QTkrQnR5alpocTMrdENBWURnRXMzdkNFckdhYVpXd25EdUFoZWZpQWdJZXB3?=
 =?utf-8?B?QWp0SGMxbFR5K0hUZm1pais2aFhJWkJnalVOR1JxYVhQODhMSlM4c2JyTVhQ?=
 =?utf-8?B?VnZ1enlxdjVDMVQ5YVpEU044dlFYMkthajNsS2piMFlzdm5HY1RNL016SXk1?=
 =?utf-8?B?d21TZ2pRbWlUOG9TZjdaTmdqdXk2YWNXRFV5SExRV2ROQUgyM09NWVJKSUg4?=
 =?utf-8?B?ZVpIU1diME5raXorNmRjbXJVNW90NmhzS25WQ2lFTnJqcEp3TEs5QTFSYm9t?=
 =?utf-8?B?S1V6VDVqNFphS3NOUVlaTlh5ZlFUb1dLQ1o4T2llR09iUlpwaVNSYngrSlcz?=
 =?utf-8?B?N3pIK2psMnhQTDJxSGxVQy9WOU9ubi9zbEk5bmJYOVNESFVRdm9sU0RzRGNB?=
 =?utf-8?B?bWQ1SFdYNUQ2QzNFNFBySzgwMWpXSytMc0RjYXYvd0ZZcWpRMjhpQTlhZFVY?=
 =?utf-8?B?YUg4THFJd3B0Szc5cEJoQUV6d0pTMHRsb3NlZmJ0NEREaUFFRDUzbnc1akts?=
 =?utf-8?B?RFkrUzZ2dmZjVnJJUy83eTBkVDkyRW4xSFNFeEtHcWIwYkhzOWFmZE80RHBB?=
 =?utf-8?B?SDlZK2REYTNzaVMxL2JyVVpiTXhqU2hyazBKdktocGhQOGQ3K0J3a2V1MWFU?=
 =?utf-8?B?QW55eVZTKzJySmtJM09kT21HVkFXeGN5RW1ZeG5MWENCakphSDRzTEU2c1NO?=
 =?utf-8?B?LzNWRTQ0NFBoeTQ3RXNpMXozU3Q0L2pVN0VuSTJYRXMwY0FDNzF4VFN0ZDc2?=
 =?utf-8?B?MW1VUmFVZ2laa2dQTE1CdHpuMzFORVlyaEdOckxHT1kxeUt1dkhxU3d3Q0Jo?=
 =?utf-8?B?US9rVzMyYnE2R1BESmV1OE15b1doZmF0RkhVaG1zMkxXcXRyOThIWWxyTHNx?=
 =?utf-8?B?VVQ3M0NDUnloYmQ0TUpscmU2eUlmTkllcHNkMEdYK0FhR1J1NDlUMkU3dHk5?=
 =?utf-8?B?bisydXBaY0dsWG9QZXdQRWdtbUR4aXlkTFRuM0kwRW1oNSsrMVNEK3l5WWpv?=
 =?utf-8?B?akdKQVZqWmpqV0xKK1dLbE5jcG9BTVp2SVNCeW5WUERnSVBqUTNyQjJJcHVB?=
 =?utf-8?B?NE1rek83STBwMnduRVQrc1dMZnpmbmlqclNyYUlzS2JmVmg4dklOM25YRDN5?=
 =?utf-8?B?dWFnVmJ1VjNhblJiWnhJYUZ3NVlHUE11YlVHWmRpcDVyUE1lMVZNanoyUWhx?=
 =?utf-8?B?aFN6MUhGNEY4azRtSG5OZ2l4aC9mUHhRM29WUy8xY3laOHdGVWVhSjYxSkVX?=
 =?utf-8?B?REdOeUh3dm9IR3BQbmJ3aW9ISjRCR0hndVY5YklqaHNVTmxNQ1VYVkh3cjk5?=
 =?utf-8?B?QmNib2JadldCLzF1TzlBZlZPczREZW9LMnRLeDR2elNRT1VkTFZGM3BFd2Ev?=
 =?utf-8?B?bnErc2RPcVlmT0tIL0hmam82Smwrem1BblBXbGdoVTU4RWZCUzFBY1Z4d1hH?=
 =?utf-8?B?SDRLWStJNXJJK1Y0bEU1MDZvbHFjSS8wTnJwaTlWRHZSSHltSXBVa2k3NDFj?=
 =?utf-8?B?NDQ1QTJiaW83Y0xvbW9laG55K1FPVGlLdXhQYjRRZWoweEFsNkIwUmUxY00y?=
 =?utf-8?B?QzhyczYwVS92TGp1ZEk3ZDVyZmNDSldMVlBocW1wVzJrd2NaZ2hueWNDSmhr?=
 =?utf-8?B?c2grQTZrMk9aaXQzZVBpcktjQTMvaXkrRU5PVGVkdUxQbTVsMm5jUnJiOTkx?=
 =?utf-8?B?QWk0SENSL1RHdEI4dzVKbHlSZC9vSS9uNDVuOWM1eEpqYVU0MktIRi9zakRy?=
 =?utf-8?B?QTJtaHFYR0Y5azQ3YjlFWVFvSElWSGZQV3BUMXJLL1U0Y20xT0RaQnQrRWhk?=
 =?utf-8?B?dTRHUHJUZFJvSmJVdUZ5SzVycTRibFhRSVJkVzBuN1lqNXVrRXdaSXJhTTJw?=
 =?utf-8?B?RjQxY1VwWGIzdFBnM3k2YjJNRXdRcFEyS3p0Vnd0Uk5WT3RDT0hxRXpvakx6?=
 =?utf-8?B?MWc9PQ==?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad512562-4a37-4527-e84c-08dd6e226605
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2025 18:00:17.5815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dg60L22l+BXMkCCswgeTd9FeyBNFJogXm2pfhcqcKEK0n2w8aWS4YVWuy2xmW3nGaMIPZ4rJQVAMK7QSGL3isQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR15MB6151
X-Proofpoint-GUID: OOOopQa6WYe2j45pEcvUcC1EDVGpzZwT
X-Proofpoint-ORIG-GUID: OOOopQa6WYe2j45pEcvUcC1EDVGpzZwT
Content-Type: text/plain; charset="utf-8"
Content-ID: <F366B65719587E4BB2644A35A1F235F9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re:  [ceph-client:tls_logger 19/40] fs/ceph/super.c:1042
 ceph_umount_begin() warn: variable dereferenced before check 'fsc' (see
 line 1041)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-28_09,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1011 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=2
 engine=8.19.0-2502280000 definitions=main-2503280123

On Fri, 2025-03-28 at 08:26 +0300, Dan Carpenter wrote:
> tree:   https://github.com/ceph/ceph-client.git   tls_logger
> head:   3d957afa4285ed4deaaf42d200ba7ee1f3092f8d
> commit: 75b56e556ea415e29a13a8b7e98d302fbbec4c01 [19/40] cephsan new logg=
er
> config: x86_64-randconfig-r071-20250328 (https://download.01.org/0day-ci/=
archive/20250328/202503280852.YDB3pxUY-lkp@intel.com/config  )
> compiler: clang version 20.1.1 (https://github.com/llvm/llvm-project   42=
4c2d9b7e4de40d0804dd374721e6411c27d1d1)
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > Closes: https://lore.kernel.org/r/202503280852.YDB3pxUY-lkp@intel.com/ =
=20
>=20
> smatch warnings:
> fs/ceph/super.c:1042 ceph_umount_begin() warn: variable dereferenced befo=
re check 'fsc' (see line 1041)
>=20
> vim +/fsc +1042 fs/ceph/super.c
>=20
> 631ed4b0828727 Jeff Layton  2021-10-14  1037  void ceph_umount_begin(stru=
ct super_block *sb)
> 16725b9d2a2e3d Sage Weil    2009-10-06  1038  {
> 5995d90d2d19f3 Xiubo Li     2023-06-12  1039  	struct ceph_fs_client *fsc=
 =3D ceph_sb_to_fs_client(sb);
> 3d14c5d2b6e15c Yehuda Sadeh 2010-04-06  1040 =20
> 38d46409c4639a Xiubo Li     2023-06-12 @1041  	doutc(fsc->client, "starti=
ng forced umount\n");
>                                                       ^^^^^^^^^^^
> Dereferenced
>=20
> 3d14c5d2b6e15c Yehuda Sadeh 2010-04-06 @1042  	if (!fsc)
>                                                     ^^^^
> Checked too late.
>=20

Yeah, makes sense. Let me fix it.

Thanks,
Slava.

> 3d14c5d2b6e15c Yehuda Sadeh 2010-04-06  1043  		return;
> 3d14c5d2b6e15c Yehuda Sadeh 2010-04-06  1044  	fsc->mount_state =3D CEPH_=
MOUNT_SHUTDOWN;
> 50c9132ddfb202 Jeff Layton  2020-09-25  1045  	__ceph_umount_begin(fsc);
> 16725b9d2a2e3d Sage Weil    2009-10-06  1046  }
>=20


