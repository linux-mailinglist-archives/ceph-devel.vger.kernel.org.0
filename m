Return-Path: <ceph-devel+bounces-4273-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A08DACFB541
	for <lists+ceph-devel@lfdr.de>; Wed, 07 Jan 2026 00:11:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 89803300CF39
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jan 2026 23:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED4682FBDE6;
	Tue,  6 Jan 2026 23:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I9hTWnrO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C20B2E542C;
	Tue,  6 Jan 2026 23:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767741086; cv=fail; b=t/6liTAob+D7n0Nv9zmpNIVq96K2g3WM8D8nWLj6WNjRdM1KxQoP6cTfsqc01RQXZpWfkP1ELab3lHF/+5zGtgi73peqjl69fOaz/Uw2ZOVGdJWAvVldJHegPgdxfqMb8ZD5b9omdgiP3MyW7FfDZEmhYASMHMpGZhn2Qqj7ct0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767741086; c=relaxed/simple;
	bh=E298h55WONg3VhL6yTfeDtt2gumWG4Wi2UebuxdCGDg=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=h9jZANkouXUlnyO+pLBgpPJ4hjQEhaUA8BVB5IfFAOM0MP/8S6frrMvnrm5bdKJjwoiPz24UYafbF9F2dDNEfdcGuEd0aHgLWVFGKvW47XiKJKbayoIwIwoULqUg0g20RMeR7T/2DZDHgaQRk2c/wzDd49wc6HjFq9buz9xXF2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=I9hTWnrO; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 606IJdOM008176;
	Tue, 6 Jan 2026 23:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=E298h55WONg3VhL6yTfeDtt2gumWG4Wi2UebuxdCGDg=; b=I9hTWnrO
	FW3g6yg0Cw+2voMwPYkCkje3/E3odQHGNFcCMr3ZPkw8cwguRxC0sBHS17kWdUIR
	SZcyKXRwQK5eA6heweBhRYmg8vvN7Iode8+4AGx+vE5W6aGEJyf1Hq6oL1hsUuGZ
	1vsno2tN2VE61Hao5OArdOMGdXbyZzk3/6Dd8hoV12fUpnSqeovMsqtHR6dOM5Ui
	v170gdfgBZdXicSbUmuKrHhshNVKV+3FLQlazLg9yTH4MXAKsGVpDR27GdawinKE
	/EQv+gAJGNQTBXzw7ioN6gXoolRgT4X9uyK9PXrZ3pUKyo3KFT22OAps4OxOIAJ4
	v/wSmdA3skGSlQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betu66782-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jan 2026 23:11:20 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 606NBKDL012596;
	Tue, 6 Jan 2026 23:11:20 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betu66781-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jan 2026 23:11:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TL1gVhdks3bsUizdp4FTSNQ1KaofTgJ/b9bmO99Ew51aKIevt4On7tFnJgQGg7ENjX1jIGSknN1VoDQ2QNvHzDTH47tFBrPdot9GQA5w7YlprzCBL0FbYPqw4sTK+9SCBv4fsGXAj5bRmlC8y1wL62i80h+YSxWtCCCi0x9RY1oY+WHbHaV8QavCbugRNNwJknz1ME3zRgzBUnBlOLIDzsa3W99qEjbg0xmhWmUrSmuwmN3q0eyX8YLtEGbjYQRLvVGHaAXxXcxZWZ3Ucpaa9G3vpWENtAj2VF6qPQgMQgToV5G124s3xDixWOrutDUMGNbe+d2HLO96yCiNN3wWtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E298h55WONg3VhL6yTfeDtt2gumWG4Wi2UebuxdCGDg=;
 b=IQCzLH/I6R/xd4XdXGqE3WFwK/cEUxRFnyQfLFV+x9EVvzi1pbXnxuETenVxOq8ce7Alyiokt8CvMRdqE+mNOXb/nQsg3dUlqKtZ1Tp/L6o4qPm1SPGYhSxgyK5+dIVb0/DwD7dAO0JCMFQMDu81D7FGcPXDyfa2nBWN4WhtblEupHLqiYnUA2YvdJ4U6N4RL6Jmr24rNzCfF/pB5DQ03/B5KtYoOXPIpIoZYiRNwQmZZVQfSz8gjyqP7TFrJP3MD0FuRi94CjczKzJjpKVQq/PWHIHwz17nhmH6KYTDncapXZjN5AjAfq9ff1DUOh61QwX3L0XxxLPohiY54zjrMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com (2603:10b6:a03:4e4::8)
 by SJ0PR15MB4155.namprd15.prod.outlook.com (2603:10b6:a03:2ee::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 23:11:17 +0000
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::7a72:f65e:b0be:f93f]) by SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::7a72:f65e:b0be:f93f%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 23:11:17 +0000
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
Thread-Topic: [EXTERNAL] Re: [PATCH 5/5] ceph: Fix write storm on fscrypted
 files
Thread-Index: AQHcftkxkV5ajtnK3k+GceitrlsozrVFxdOA
Date: Tue, 6 Jan 2026 23:11:17 +0000
Message-ID: <f8e9a246a6a47a100e022d837b5ffc3f9e864fd8.camel@ibm.com>
References: <20251231024316.4643-1-CFSworks@gmail.com>
	 <20251231024316.4643-6-CFSworks@gmail.com>
	 <912bf88ff3b77203c2df37aa4744139a2ea0a98c.camel@ibm.com>
	 <CAH5Ym4j9Sgzng9SUB8ONcX1nLCcdRn7A9G1YbpZXOi3ctQT5BQ@mail.gmail.com>
In-Reply-To:
 <CAH5Ym4j9Sgzng9SUB8ONcX1nLCcdRn7A9G1YbpZXOi3ctQT5BQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR15MB5821:EE_|SJ0PR15MB4155:EE_
x-ms-office365-filtering-correlation-id: ee7e71de-ac15-4c31-dc71-08de4d78e5a6
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?a2kxcEZ4QXV2WERxNVo5a09PQTBMa2d6T1FqalZvVGNrVW1zODhrbm9ET0VJ?=
 =?utf-8?B?NWRMczFGSFFOSmZnQTBBRFBpazRXKzBHUXAvTWtPc3FtTlpqa0dWZTFRZFhL?=
 =?utf-8?B?ODA2VjRYT1VMcHNyck8ra3NtK1ArZTVUTjdLNXI2ckdMeE9lMDFtWEdabkcz?=
 =?utf-8?B?aWE1T2pIWXh1TVdvdXdsT3AzNURiV0NXRmhHYkpidWk2dW5YWTZsRlpJTUpK?=
 =?utf-8?B?WDNacUd5THpoMDYxYkxRc1BHL2gwVFBXWFgrUlhoaXVtRHZaSHRBWkh5MFBP?=
 =?utf-8?B?WnNsWXFvbk5HcXdvNGwxbitBQ2pqVzNRSDJLL0MxNkhXQTBnWjQ0dTdsVFdw?=
 =?utf-8?B?amlGK3NST1FvZk16VVlFSmFxSXUxcGl2eXlMTmpuTDltWnJUWDNhb1lJQUVR?=
 =?utf-8?B?bWFpdy9ZYjRvUHZIdEVCZkhZZ24reXVJVjVMRFh3cnJFTng1UzZ0UWZQdDla?=
 =?utf-8?B?WUk5MHp0dkJadjl6RGFkQlhMVE1tS3hjOXZsYzRZSHJMdkZsamUxdzBiTHFP?=
 =?utf-8?B?RXdtQjFiaXhGbGQyR0NOMFcvNTZ1RXJZWk56dnBGOWFTY0MzQnZ5V2pSMWht?=
 =?utf-8?B?YllXaUQ1N0c0eHpaVlJyZlZRUlpLUlBDZ1IrOUdoeVdMQ0cwTkoyMmJKTjQr?=
 =?utf-8?B?OWVKdm5jSmhsUjNOMEpOay9WWkdKaEU5d1Q1bEFuR3dkdmFQcVFNbXZvd3VF?=
 =?utf-8?B?dmVEQkhKRXNZMmEzN1oyWjZwU1BmcUZuRWtIMWxMSTY2UitESUVuWVVKVTYr?=
 =?utf-8?B?d0dCK203VktncFloeWxtR0RjNUwrd3FnQXVaMzYwUXZWQy9mWmF1OVlKbGNL?=
 =?utf-8?B?RmFvcHNOUzFBRkRFOWh2VEdhT011bDVFTHBmMkhvTGk5VGZUUDJ6UExzbDdn?=
 =?utf-8?B?S3ZTSXY5RUtDVVNxZmZvQ2hUTVZCc295cnc5cThLQUxiWDRLVCtzM1NMUHlN?=
 =?utf-8?B?VGsyL3lGdGZVR0tUeDJUcm01UUViaXlybUM0SDVDNmFrd25tRUhnVExBZ25G?=
 =?utf-8?B?djk3enF6SkZBN0JHVkNXczJoV1FScndvQkRaTzBvWFJ3Q3Q5WFpyY01QU2Mw?=
 =?utf-8?B?YXRBMmxPc25sVk5abXczb2MrTlhxL2NsclNyZkxhOEpTVmhrTWFzQTZJQUo4?=
 =?utf-8?B?czZxaElqR2dlVHI5NHg0c3NheGxKOTdHVFFkU2VreCtVZElpL3l0eGNCdjdJ?=
 =?utf-8?B?MVVRdHY1Nm1mek9oQ3NPa1pPYTRYRzkzRDRmeVYzN1crRk5yMXQzL3piSkNv?=
 =?utf-8?B?SFhuVTFiNE5qOStXR3hONEFNWEJKcDdjMkdHMUZJd1pJbmw3dFJSRjI0WTNh?=
 =?utf-8?B?YXNYZVVIVG84YjRrU2ZSdUxXU1lSeG5YL3AvMEtvczZmNDUzWnQ3QnpweWlM?=
 =?utf-8?B?VVJWT29BeGFScW9YVnNsMUVRYVNyb0JpUWpuaHBBZmpnR2hiVHViM1U5RkRO?=
 =?utf-8?B?UVhhdG5SajQvZGZBTndnOTBsVXNpUTNnTEtSMkJoTnRTRWJNZkNtQ1U5ak5B?=
 =?utf-8?B?SEorSnordTBIbzYxTCtTdGlWMHMyL3A1Z0NaKzBXTDltZlc4SGpvQ0hjcXc1?=
 =?utf-8?B?Nno1Vm5FVW1ORzlVMmEvWHF0bkgzUUdXYXFtcEt2WmNHY0E0aHVlczhsZmVN?=
 =?utf-8?B?ZUIva1lDOTdmaXpwd09rTkEwR3EvQXBWNS8rbk11b0pMenJhOWFRa1VHSEdu?=
 =?utf-8?B?ZkRCQ3NBTSs5RlVJSmduTkRLR21xcENDd2hFcmZBNXhSaDVPRHduYVpOMGVl?=
 =?utf-8?B?Zlh1bC96Mk5jK1JGRUJFVzJwQmx6TmdER25XOUVPemhPN1dIU2M5WkFMMlZu?=
 =?utf-8?B?cU9xY25ZcmE2OFlTOHNRaU55cnlBKzVQaXFKanl0cnpVZ2ZRbFN5UVdnZGpY?=
 =?utf-8?B?NXVQaXN0WWM5UnJzTGloQVFCSDVQU093MFFiOEpiY29FVmZlSDY2SEdkN3Bj?=
 =?utf-8?B?N0xUYVkzK2ZRQWZZOUZPNE5yNUo5RlYyNFltdVZ6U0xuMTYrWlpFUnJIYlJt?=
 =?utf-8?B?SDRsVGRxY1hObG1tOFhRY1dzcHppbFZueUx2RUJ5bWs0dVlpR0E1UnVUMjRY?=
 =?utf-8?Q?NCciIW?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR15MB5821.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aE9uM2N1ODlncGkwa29ZckJSYWV4cVpRM09ZTlB1L0R1L2NvSnpXUlM0aTY2?=
 =?utf-8?B?Qk8wd3FORk9vdEIwc3NuZmNwUC83SkR5bVVTYmRab3l0TW5vNTdGSHV4NDYy?=
 =?utf-8?B?Zk1oNFNkSHVpQ2VENFBKUmxrR05rclk5SWcwSzdIUjRNSVR2U3ZEdUhJQkhW?=
 =?utf-8?B?VWxqcm12M1dyY3Rvdy95U2dGQStsQTZSTDFlaExqQ3JJZkthdEpaNFpJK1BO?=
 =?utf-8?B?blVYdnE5OU1NWWczVmJJdmE1RnF0bnc5YWVLQTd0aWhKNFhNZUY0ZXpCamls?=
 =?utf-8?B?clJ2ak9KcXJVQVYxeUVSelhJWVFpSk9sc3ZaRnFScUR1NW56NjV0dmp0V1RK?=
 =?utf-8?B?Unk1TU5aUVd1R0J4dm5qWWY2eXN0amRuS0t4OEE2alpPQUxwNVhsOWc4bTlQ?=
 =?utf-8?B?K1lKWW5ZT2syVFVvSStVOVoxbUR5UHFINlc2L2t0ZUZzbWpEZkx3U2ZyMjFZ?=
 =?utf-8?B?TkV4b1VlK2xxL2VvVW0yNWVVTXIrVklISEI0OFUzeWV4ejRjNXB3Z1lTNjJ5?=
 =?utf-8?B?Lzk2bVByMG43ZXZYc2k1bkxqUk9ZNDNrdjUwMlFuNUN5MDZqeVFOZWJHRXNn?=
 =?utf-8?B?akdNYUNXeEMyWmNjcWl1NlBiTUZ2RDJkV2hmY0IzeTlBQU9HZGYzUDVoN0o3?=
 =?utf-8?B?QkovcDRpV0crZWtCWTlCLy9uUFVERDIwR3YrNVczckJuYmM1ODRGenpGeWpk?=
 =?utf-8?B?bTlyUkpiM1dpZU5MVVVJMUlDYUVJNW42V0pod1dXNWZPSjRWR0phSmhleEFj?=
 =?utf-8?B?RG1FY2s1a0RpM1BPNjVJdUdCMlRxZ0M5MWp5QkFKVzhyd2ZpaW5PRmpGMWcr?=
 =?utf-8?B?N2JMV0N0SFRLQ05oUTFERnVKT0RERUJ0K2xVSS8vYnM0a0ROT3d3Q0gyZjk5?=
 =?utf-8?B?d0RkdzRrRDYvR0JFVTJNOERBcHhYVkhFK2R3cUF6UTRjRytHczZoNUNlbjBm?=
 =?utf-8?B?bGNNeHNZQkZkU3pnOWt4bTNDaTBEdnV6QXBONEQyYmRVM0FTSjRDVGp6ZS9P?=
 =?utf-8?B?VnlaZFJPQzlsc3JYKytzMk9hQjFRTDlaS3dnS1BmME51aXJrbDNTd1ZYYkdC?=
 =?utf-8?B?ZUp1T2V6QStxc1ZnbmxrWVduUHhkbEJBZUxsdGgwMWg3R1prZUJPWXJseXVC?=
 =?utf-8?B?NE5lVDdTNW81aE1mVE45eis1UENkUGFIaHJ2N1N0K2F4Y0paOEQrcWV3elFk?=
 =?utf-8?B?QXpudEpJeHQ1Sk50Vm5SY051ckdldXFXeFFLMCtuQVFTQXA0NHgzcVczcGFz?=
 =?utf-8?B?K2J5OENoR0FpSkdIaTVNSWhzTXg4MGlyR2U1M3dhYTkrRzBZME95cGpOU0tU?=
 =?utf-8?B?WS91SGdWUkFBS0VIcEQvUEhpNVNRSDU0cWdEOUtrM0xQRlZMWk1oNmQxcDdr?=
 =?utf-8?B?TEc3d016d2tSa2VheFZjb2YvQURWbTBsV3pRUmRnWVRoOEFLaTQ3MlJIY2Nh?=
 =?utf-8?B?Um1xK3QvNVFCVllmYVkvbjdQWEtqb216bnBvd2loU3E5WnZidHUvNE1FKzZV?=
 =?utf-8?B?V2xWK1p4WEUxcTFkMHBqZ3VqYWx5cnFkcXRlYnRQMGpvRHF2OUZCQnptbmh0?=
 =?utf-8?B?enVNOXNrNmMyN2Vjc3BSWHpDdmsyRWRaL21PWFVZeFY2TmZ4MHBXQUg3Tysw?=
 =?utf-8?B?Rzdtak9VNDMvV1lidXpWeW5ocTdFYmVEajFYSktmWE5COXg1R2xnRnpPVTIz?=
 =?utf-8?B?dzBEenVtTHo5ZWdBc1V4SllPaXFIZExhN1QvdzlyTWRQbFNReUJpRUNyMEY0?=
 =?utf-8?B?S1Eyb0hwZjhJbDVoZ0RrSGR5bjRsWDI2cFhRMEs1T3VheUIyak9CSTZKTmFt?=
 =?utf-8?B?VjY1S1FkVjY3TjlveE1OQ2lQSktBSmNzWU5jWWNmR1JmMU9vRTliWlVNQTNS?=
 =?utf-8?B?ZXQrN0tqUjNCbHdlVHJJeGVrbzdsTDg1cDBSOEJ6cjBaWFpMUWZLaVBrSWt1?=
 =?utf-8?B?ZzhUNS9sRXZ2dDJNbUZrSG5FVXlQZStMTkhpVGdheVRSM0ZIcktIaVBtcVZD?=
 =?utf-8?B?bjJJQkd3aFZ2L1hLM2VwYXMyKzdwOWNqMFExeVN3K2o1R0hpcXRuYjFDVTdv?=
 =?utf-8?B?Yko2cWdJeHI4aFdERENVRkx3RTVqRkFJbWViT3RPc2N4NW9tWDZQNkU3RkIv?=
 =?utf-8?B?cXQ1NS9lRm55TTg4NGJnR05YUXpUaGVRSlYvVHJHQ2hlZHpVQ0ZuYUtJNG95?=
 =?utf-8?B?OXlpNXVEalpEUUp0T0ZSRmxQTkhSMk8yblVqOHE0Sk9RRTlENEYxb3JQNXVC?=
 =?utf-8?B?ZndGRHFHWUhTczRXbjlaUWtrbWoyMm9CZG9iYk1kOUlHZXZWM2VsazJtRTMv?=
 =?utf-8?B?WjBSSkw5SkxyODNuK0RzcDVjYlA4dEVPM2J6cTRNU1J3alNhVE1ZbmdKejFn?=
 =?utf-8?Q?82qE/WtHc31FRuN0YONZvGwmdGaVV+IP5w18Q?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D71817061E0A14AA075098D52F95428@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ee7e71de-ac15-4c31-dc71-08de4d78e5a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2026 23:11:17.7466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a/OHvvCyZ4wwQbei9OB6s04BrwO1CZUgvZ4fUFdtmmBjLGVmlZVwvW+m8g5FE6rSe64uVrk0rx+9TDcV2izOvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4155
X-Authority-Analysis: v=2.4 cv=QbNrf8bv c=1 sm=1 tr=0 ts=695d9698 cx=c_pps
 a=BFxEMT9/7ApEM+sm6hv7VQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=Y1GpNZoN8Tr43zbMs7gA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: HJ8D0_px2wX63sbDElGrG7LbLQ-3JhGN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE5NyBTYWx0ZWRfX1ofKVRdRryMb
 6O/wraR76QfNrFRRrTKd/8nfhBLN/6n1DWnmYxVuptkNYI+VHdrpANewcCkaF9H1U5uJNPYnSOs
 i3BIX3N4ZZwOFqSoYfw4dqXTf51g4INlcupT12fY3sUkUxWM/4bhDbAXhXb4YAyrr3sJc7H8zvy
 RxJUHpa5f4aPhrvvhSzJWwuIBkPMzEnSdyqch8db+ixRto5sZ0e5bc2uQAIpU1R+xFK7rzS0MP7
 Ao4D/6JyCTmQFC8VMC9DbHVU8zlY/NLizMlql0MguykCuZZXLcCXBBqX/IQsSc+1JXWPikQ4oDa
 4MSlYLCTlzc+IxMJaNsiirJ+KvjRjC8ryErj3stzMlZSYje7QvLt3rLaie3ZbwRJClQZIfODbYc
 I2APrxRgbXZwg+3qXp9Bqiyvpv8eNRWfucCfuL9AvNYwyXX0JGQk1ZAu7ftAZqFHm3oN/i+ikEX
 jG+7duc3LrjzNB7sUng==
X-Proofpoint-GUID: 8U28rVvMdmcPuTqCJ8iuFmGSzTMCOchL
Subject: RE: [PATCH 5/5] ceph: Fix write storm on fscrypted files
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_02,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 bulkscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601060197

T24gTW9uLCAyMDI2LTAxLTA1IGF0IDIyOjUzIC0wODAwLCBTYW0gRWR3YXJkcyB3cm90ZToNCj4g
T24gTW9uLCBKYW4gNSwgMjAyNiBhdCAyOjM04oCvUE0gVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2
YS5EdWJleWtvQGlibS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFR1ZSwgMjAyNS0xMi0zMCBh
dCAxODo0MyAtMDgwMCwgU2FtIEVkd2FyZHMgd3JvdGU6DQo+ID4gPiBDZXBoRlMgc3RvcmVzIGZp
bGUgZGF0YSBhY3Jvc3MgbXVsdGlwbGUgUkFET1Mgb2JqZWN0cy4gQW4gb2JqZWN0IGlzIHRoZQ0K
PiA+ID4gYXRvbWljIHVuaXQgb2Ygc3RvcmFnZSwgc28gdGhlIHdyaXRlYmFjayBjb2RlIG11c3Qg
Y2xlYW4gb25seSBmb2xpb3MNCj4gPiA+IHRoYXQgYmVsb25nIHRvIHRoZSBzYW1lIG9iamVjdCB3
aXRoIGVhY2ggT1NEIHJlcXVlc3QuDQo+ID4gPiANCj4gPiA+IENlcGhGUyBhbHNvIHN1cHBvcnRz
IFJBSUQwLXN0eWxlIHN0cmlwaW5nIG9mIGZpbGUgY29udGVudHM6IGlmIGVuYWJsZWQsDQo+ID4g
PiBlYWNoIG9iamVjdCBzdG9yZXMgbXVsdGlwbGUgdW5icm9rZW4gInN0cmlwZSB1bml0cyIgY292
ZXJpbmcgZGlmZmVyZW50DQo+ID4gPiBwb3J0aW9ucyBvZiB0aGUgZmlsZTsgaWYgZGlzYWJsZWQs
IGEgInN0cmlwZSB1bml0IiBpcyBzaW1wbHkgdGhlIHdob2xlDQo+ID4gPiBvYmplY3QuIFRoZSBz
dHJpcGUgdW5pdCBpcyAodXN1YWxseSkgcmVwb3J0ZWQgYXMgdGhlIGlub2RlJ3MgYmxvY2sgc2l6
ZS4NCj4gPiA+IA0KPiA+ID4gVGhvdWdoIHRoZSB3cml0ZWJhY2sgbG9naWMgY291bGQsIGluIHBy
aW5jaXBsZSwgbG9jayBhbGwgZGlydHkgZm9saW9zDQo+ID4gPiBiZWxvbmdpbmcgdG8gdGhlIHNh
bWUgb2JqZWN0LCBpdHMgY3VycmVudCBkZXNpZ24gaXMgdG8gbG9jayBvbmx5IGENCj4gPiA+IHNp
bmdsZSBzdHJpcGUgdW5pdCBhdCBhIHRpbWUuIEV2ZXIgc2luY2UgdGhpcyBjb2RlIHdhcyBmaXJz
dCB3cml0dGVuLA0KPiA+ID4gaXQgaGFzIGRldGVybWluZWQgdGhpcyBzaXplIGJ5IGNoZWNraW5n
IHRoZSBpbm9kZSdzIGJsb2NrIHNpemUuDQo+ID4gPiBIb3dldmVyLCB0aGUgcmVsYXRpdmVseS1u
ZXcgZnNjcnlwdCBzdXBwb3J0IG5lZWRlZCB0byByZWR1Y2UgdGhlIGJsb2NrDQo+ID4gPiBzaXpl
IGZvciBlbmNyeXB0ZWQgaW5vZGVzIHRvIHRoZSBjcnlwdG8gYmxvY2sgc2l6ZSAoc2VlICdmaXhl
cycgY29tbWl0KSwNCj4gPiA+IHdoaWNoIGNhdXNlcyBhbiB1bm5lY2Vzc2FyaWx5IGhpZ2ggbnVt
YmVyIG9mIHdyaXRlIG9wZXJhdGlvbnMgKH4xMDI0eCBhcw0KPiA+ID4gbWFueSwgd2l0aCA0TWlC
IG9iamVjdHMpIGFuZCBncm9zc2x5IGRlZ3JhZGVkIHBlcmZvcm1hbmNlLg0KPiANCj4gSGkgU2xh
dmEsDQo+IA0KPiA+IERvIHlvdSBoYXZlIGFueSBiZW5jaG1hcmtpbmcgcmVzdWx0cyB0aGF0IHBy
b3ZlIHlvdXIgcG9pbnQ/DQo+IA0KPiBJIGhhdmVuJ3QgZG9uZSBhbnkgInJlYWwiIGJlbmNobWFy
a2luZyBmb3IgdGhpcyBjaGFuZ2UuIE9uIG15IHNldHVwDQo+IChjbG9zZXIgdG8gYSBob21lIHNl
cnZlciB0aGFuIGEgdHlwaWNhbCBDZXBoIGRlcGxveW1lbnQpLCBzZXF1ZW50aWFsDQo+IHdyaXRl
IHRocm91Z2hwdXQgaW5jcmVhc2VkIGZyb20gfjEuNyB0byB+NjYgTUIvcyB3aXRoIHRoaXMgcGF0
Y2gNCj4gYXBwbGllZC4gSSBkb24ndCBjb25zaWRlciB0aGlzIHNpbmdsZSBkYXRhcG9pbnQgcmVw
cmVzZW50YXRpdmUsIHNvDQo+IHJhdGhlciB0aGFuIHByZXNlbnRpbmcgaXQgYXMgYSBnZW5lcmFs
IGJlbmNobWFyayBpbiB0aGUgY29tbWl0DQo+IG1lc3NhZ2UsIEkgY2hvc2UgdGhlIHF1YWxpdGF0
aXZlIHdvcmRpbmcgImdyb3NzbHkgZGVncmFkZWQNCj4gcGVyZm9ybWFuY2UuIiBBY3R1YWwgaW1w
YWN0IHdpbGwgdmFyeSBkZXBlbmRpbmcgb24gd29ya2xvYWQsIGRpc2sNCj4gdHlwZSwgT1NEIGNv
dW50LCBldGMuDQo+IA0KPiBUaG9zZSBjdXJpb3VzIGFib3V0IHRoZSBidWcncyBwZXJmb3JtYW5j
ZSBpbXBhY3QgaW4gdGhlaXIgZW52aXJvbm1lbnQNCj4gY2FuIGZpbmQgb3V0IHdpdGhvdXQgZW5h
YmxpbmcgZnNjcnlwdCwgdXNpbmc6IG1vdW50IC1vIHdzaXplPTQwOTYNCj4gDQo+IEhvd2V2ZXIs
IHRoZSBjb3JlIHJhdGlvbmFsZSBmb3IgbXkgY2xhaW0gaXMgYmFzZWQgb24gcHJpbmNpcGxlcywg
bm90DQo+IG9uIG1lYXN1cmVtZW50czogYmF0Y2hpbmcgd3JpdGVzIGludG8gZmV3ZXIgb3BlcmF0
aW9ucyBuZWNlc3NhcmlseQ0KPiBzcHJlYWRzIHBlci1vcGVyYXRpb24gb3ZlcmhlYWQgYWNyb3Nz
IG1vcmUgYnl0ZXMuIFNvIHRoaXMgY2hhbmdlDQo+IHJlbW92ZXMgYW4gYXJ0aWZpY2lhbCBwZXIt
b3AgYm90dGxlbmVjayBvbiBzZXF1ZW50aWFsIHdyaXRlDQo+IHBlcmZvcm1hbmNlLiBUaGUgZXhh
Y3QgaW1wYWN0IHZhcmllcywgYnV0IHRoZSBwYXRjaCBkb2VzIGltcHJvdmUNCj4gKGZzY3J5cHQt
ZW5hYmxlZCkgd3JpdGUgdGhyb3VnaHB1dCBpbiBuZWFybHkgZXZlcnkgY2FzZS4NCj4gDQoNCklm
IHlvdSBjbGFpbSBpbiBjb21taXQgbWVzc2FnZSB0aGF0ICJ0aGlzIHBhdGNoIGZpeGVzIHBlcmZv
cm1hbmNlIGRlZ3JhZGF0aW9uIiwNCnRoZW4geW91IE1VU1Qgc2hhcmUgdGhlIGV2aWRlbmNlIChi
ZW5jaG1hcmtpbmcgcmVzdWx0cykuIE90aGVyd2lzZSwgeW91IGNhbm5vdA0KbWFrZSBzdWNoIHN0
YXRlbWVudHMgaW4gY29tbWl0IG1lc3NhZ2UuIFllcywgaXQgY291bGQgYmUgYSBnb29kIGZpeCBi
dXQgcGxlYXNlDQpkb24ndCBtYWtlIGEgcHJvbWlzZSBvZiBwZXJmb3JtYW5jZSBpbXByb3ZlbWVu
dC4gQmVjYXVzZSwgZW5kLXVzZXJzIGhhdmUgdmVyeQ0KZGlmZmVyZW50IGVudmlyb25tZW50cyBh
bmQgd29ya2xvYWRzLiBBbmQgd2hhdCBjb3VsZCB3b3JrIG9uIHlvdXIgc2lkZSBtYXkgbm90DQp3
b3JrIGZvciBvdGhlciB1c2UtY2FzZXMgYW5kIGVudmlyb25tZW50cy4gUG90ZW50aWFsbHksIHlv
dSBjb3VsZCBkZXNjcmliZSB5b3VyDQplbnZpcm9ubWVudCwgd29ya2xvYWQgYW5kIHRvIHNoYXJl
IHlvdXIgZXN0aW1hdGlvbi9leHBlY3RhdGlvbiBvZiBwb3RlbnRpYWwNCnBlcmZvcm1hbmNlIGlt
cHJvdmVtZW50Lg0KDQpUaGFua3MsDQpTbGF2YS4NCg0KPiBXYXJtIHJlZ2FyZHMsDQo+IFNhbQ0K
PiANCj4gDQo+ID4gDQo+ID4gVGhhbmtzLA0KPiA+IFNsYXZhLg0KPiA+IA0KPiA+ID4gDQo+ID4g
PiBGaXggdGhpcyAoYW5kIGNsYXJpZnkgaW50ZW50KSBieSB1c2luZyBpX2xheW91dC5zdHJpcGVf
dW5pdCBkaXJlY3RseSBpbg0KPiA+ID4gY2VwaF9kZWZpbmVfd3JpdGVfc2l6ZSgpIHNvIHRoYXQg
ZW5jcnlwdGVkIGlub2RlcyBhcmUgd3JpdHRlbiBiYWNrIHdpdGgNCj4gPiA+IHRoZSBzYW1lIG51
bWJlciBvZiBvcGVyYXRpb25zIGFzIGlmIHRoZXkgd2VyZSB1bmVuY3J5cHRlZC4NCj4gPiA+IA0K
PiA+ID4gRml4ZXM6IDk0YWYwNDcwOTI0YyAoImNlcGg6IGFkZCBzb21lIGZzY3J5cHQgZ3VhcmRy
YWlscyIpDQo+ID4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gU2lnbmVkLW9m
Zi1ieTogU2FtIEVkd2FyZHMgPENGU3dvcmtzQGdtYWlsLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4g
IGZzL2NlcGgvYWRkci5jIHwgMyArKy0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9mcy9jZXBo
L2FkZHIuYyBiL2ZzL2NlcGgvYWRkci5jDQo+ID4gPiBpbmRleCBiMzU2OWQ0NGQ1MTAuLmNiMWRh
OGUyN2MyYiAxMDA2NDQNCj4gPiA+IC0tLSBhL2ZzL2NlcGgvYWRkci5jDQo+ID4gPiArKysgYi9m
cy9jZXBoL2FkZHIuYw0KPiA+ID4gQEAgLTEwMDAsNyArMTAwMCw4IEBAIHVuc2lnbmVkIGludCBj
ZXBoX2RlZmluZV93cml0ZV9zaXplKHN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nKQ0KPiA+
ID4gIHsNCj4gPiA+ICAgICAgIHN0cnVjdCBpbm9kZSAqaW5vZGUgPSBtYXBwaW5nLT5ob3N0Ow0K
PiA+ID4gICAgICAgc3RydWN0IGNlcGhfZnNfY2xpZW50ICpmc2MgPSBjZXBoX2lub2RlX3RvX2Zz
X2NsaWVudChpbm9kZSk7DQo+ID4gPiAtICAgICB1bnNpZ25lZCBpbnQgd3NpemUgPSBpX2Jsb2Nr
c2l6ZShpbm9kZSk7DQo+ID4gPiArICAgICBzdHJ1Y3QgY2VwaF9pbm9kZV9pbmZvICpjaSA9IGNl
cGhfaW5vZGUoaW5vZGUpOw0KPiA+ID4gKyAgICAgdW5zaWduZWQgaW50IHdzaXplID0gY2ktPmlf
bGF5b3V0LnN0cmlwZV91bml0Ow0KPiA+ID4gDQo+ID4gPiAgICAgICBpZiAoZnNjLT5tb3VudF9v
cHRpb25zLT53c2l6ZSA8IHdzaXplKQ0KPiA+ID4gICAgICAgICAgICAgICB3c2l6ZSA9IGZzYy0+
bW91bnRfb3B0aW9ucy0+d3NpemU7DQo=

