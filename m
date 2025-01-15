Return-Path: <ceph-devel+bounces-2446-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67D08A11638
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2025 01:49:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45B09188A3F5
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2025 00:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB3835968;
	Wed, 15 Jan 2025 00:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qMBaQXe+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66EC35949;
	Wed, 15 Jan 2025 00:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736902176; cv=fail; b=uLEdcNjwJ5hU1tm/6JZ4ISEsyryBzqZOL8ezLYEqz5X9JB8/JVx2MVvZ9sngbmYZA284z2Vsh4HSFN/23y10W2QikVaNsAeZwFNv8/uivtim+VigVhrbcCYmRyjAWJemRAYTdnHo866bspkk6ZjlsdN6vzK2lr40HwhGYv39cDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736902176; c=relaxed/simple;
	bh=iuaq7yH0giZVBuxMBKyl+4YS0Ebr7ilNj49nJWwsDqc=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=nWqla/kUkPfDxxtn1OuXp/ElWp1QQbSiywMYNuD4KH9qclwCtYJH2LzmV96ACRLdc/H5sDGQgpoB3RM9yOZFD4n3SPAdRN0IMFWnySFuGlxWUbpS3ixfAOJl8nxu9bucd70hIrG9EbTyoTnMCnlshQRB0yiRf2DB8IVqo+6wWM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qMBaQXe+; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EJsTIH022211;
	Wed, 15 Jan 2025 00:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=pp1; bh=iuaq7yH0giZVBuxMB
	Kyl+4YS0Ebr7ilNj49nJWwsDqc=; b=qMBaQXe+boE+Em1j1LnpIoSsjqEiQG3PM
	CzJUKDeSmfozgafoBBXwNN6uHFhBixiWonV5fUE03TJzU4fjxUIp1HOg6LGDXEJT
	h9CIVbWXgs/iNxc1ConVUZ7elAMRxzVLgSvYa1Qs027C2Gd/Pu+Y3m6In71tMcNF
	z4Pu4BM7Om236ySvYuAEANuAYdkggw1qAhB+JyHkI8tx7zsqlRDaTzU0In4thSg+
	9TiWnW48vMmpZqax0Gfvw887dPfhvLzfUG4En3wptscHAZp6eeht56Q3rzxUSXkY
	J6ysBNgqlL0xJSeznCub+cDuBVcL+bei33DqELprRliqe5pNZZ/Lg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 445m433ugj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 00:49:31 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50F0kZa0032479;
	Wed, 15 Jan 2025 00:49:30 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 445m433ugg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 00:49:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EghohZ8M2hY5C018HJN5I02QW6bpUpcMCBOw8gyLoXhtxHUDO3YeP3U7JsMmZ8NL1CH1GDmMdBFhB+MIKnxIrg1Mmpti4ivDvCftCZBnM0AVDeZvrN+p+V032J6yG24yTU+uMXeRr31EQOWpugChazAuxfFX0NkU0WTlnA0gEQRzVBw0gdIA6nVxVs6aODJyEWmaphEnPI2T285BjttV910t+9+Nr3EZAGpw2PLoQUvaVF9Eit9IlbG52YdDmEhdCaLqZ+Ha7XiD0++iPBTKfE2Nz+z6Ov8tRdo5H0FRhWDwIShv0mwTAIzx8RxmzdUczEIzl+in2cnPly9M/QlzBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iuaq7yH0giZVBuxMBKyl+4YS0Ebr7ilNj49nJWwsDqc=;
 b=Knib+W5ybA+SHLaVkO6lmZaOWaoejGVftdYFy79QNFsFMx6VKVTPmBqECvX+XsrnGEOink4mzeC82MpZu5bMVorgDOJWnvZoHVjKWUyt63obx1+RzdDONIaKs8E/anADduT4YX+b/qKQAyQRHR0KavS4k3gSx5mhWsfKshNip6OkQQNEfu+p9K91PsbfMtfLTeT1gox9YJzUxNj07AJqJTo4OLa3LWeZ+UCF7L+WkE3DuGzTpkXI0LkBN7Tb36CGyDUHv1CVQ7e7vspuiNNdYUcT8cMS3QaUVQHk6SVrG1Uar7RftdtVrUZ1Na4S+Trn0IDgEwBxWJc9ds6Uviq3DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by MW4PR15MB4617.namprd15.prod.outlook.com (2603:10b6:303:10a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Wed, 15 Jan
 2025 00:49:28 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 00:49:27 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
CC: Alex Markuze <amarkuze@redhat.com>,
        "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>,
        "slava@dubeyko.com" <slava@dubeyko.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>
Subject: [RFC PATCH] ceph: Fix kernel crash in generic/397 test
Thread-Topic: [RFC PATCH] ceph: Fix kernel crash in generic/397 test
Thread-Index: AQHbZudU+k3K5wcZb0uhK36QvE8a4Q==
Date: Wed, 15 Jan 2025 00:49:27 +0000
Message-ID: <266c50167604c606c95a6efe575de5430c31168b.camel@ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|MW4PR15MB4617:EE_
x-ms-office365-filtering-correlation-id: 16968e63-b893-4f70-a0e6-08dd34fe7701
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dVA1WktKR3oxSzkxc1lpdXduc1RKemJsWGZKZTA0YkVIdENNQzVrdW9UdXdz?=
 =?utf-8?B?U3hHd3FKMHQxaXNCQUppbjNydUhRQWREQlNYTHNKN2Rta1hpYldIbkJ4a3NT?=
 =?utf-8?B?N3Y4TkcrQ1J4N1ZlVDJKU3pLb1dnc3dhQ2lISTd5RjhSUHAwaU43bXRsY2NS?=
 =?utf-8?B?VzhtYkE3VkltOFJSbHZmVU5JWXRkaDREbGFkbG5aR1ZXb1JxNzJWRG1NK0JQ?=
 =?utf-8?B?di9PenJlOWV3Nzd3M1k0VWJueUpseFlBb2tGTjIrTlUzOUozWU9FSjZXWVNN?=
 =?utf-8?B?UDl0Qlh6MEdSZ3JVUitrQ1I3N1p5V0hUWE42MXc0cDVQZk9WUUMxYmx6Nysw?=
 =?utf-8?B?WlZ3ZWRCanhVMjZtOHJIVE5rb0tUSTh6TC9LTm15M3BONFZWc2I2cUd3KzdK?=
 =?utf-8?B?dTUzN3UrOGM2UGJxZCs3TkFURzlJN0ZSQ3A4YmxSZHdKb2tWRXd6c3lrQmxr?=
 =?utf-8?B?SFJPOVBkY285d0hPMWwyN2hQQ3lERTg0SW5ZNTBYeVNETUZaa1g3UUxLZzQ4?=
 =?utf-8?B?M2NhQVVXZE9OT0pURUdyZDJYNVNCeEp5WmxNMEZRUmNKVXJZb3BUZHFHV21w?=
 =?utf-8?B?M0UxaWRZdVJZb09rdys5RVl4aUNpZGtFaG95U2RtemUzSHF1YmZMUFFOT055?=
 =?utf-8?B?UFJucHY1cEpIRWlJTmlEby9SSWVrUlo1SWZQeXVlNDdtbld6dndGaTN3VlAz?=
 =?utf-8?B?M2hnZ09Rai94UWFOaEM3WkJQNlVtUGgweWpjY2FNYUhES2xWQ3BuNXJROEt6?=
 =?utf-8?B?M1RSZjVFTmc2UmpXTUZXSUZaMGZxa0lJdi9kN2VEWUhBbFNTUjRqM1E0Rmo5?=
 =?utf-8?B?MCtOOVFBTjg2OEgvVTdXQUtXY0M1WENNUGh6eWR5ZFRiTHZXU3BrTWFSNFc0?=
 =?utf-8?B?UGdDYTlPaThPUnVoQ3dFVVZiNk9QdzJHUzFVcCtxNm9BZFZoUlZybTdkYXBH?=
 =?utf-8?B?MFJ6dHNlRDN5c1BZVE5PY3VFTHA4K2JMaFIxT2hkUEVWS0RXV1RLUzJiTDVn?=
 =?utf-8?B?RnBEUlRldkc4R1ZWZHB2Q1NLNThRSE1RVDJmVGpvaGNmbWVxNGFENlFQNXFl?=
 =?utf-8?B?ZExSODNrRlpNc09yU2M4RFRtb2FtbDZDVEFVQmN0SHh3aTFTYnhaU2ZvT3JT?=
 =?utf-8?B?cTh6aDBHQ1dzNlN3REd5SUpBSDhGSGlvYmRpSTJNZi9zRG84ZUR5SDZVeGVo?=
 =?utf-8?B?QVhpSnROOXlGenZycFVWMk5NRUFJK01rdjV6THV1NGZueHRGNTBEc21XaitR?=
 =?utf-8?B?aGl0V0F1Zko0TWFuY3RtRHR4eXM4UGk0bmt4OFdwYVJWTjZoOFJSL2VKcEhE?=
 =?utf-8?B?SHVVWURrMG5KbnJsK0NBYkhydTdnNUJUbHQ3alBsUEtpVjE3cmxUTVNGSWk5?=
 =?utf-8?B?OWE2YTcycWZ1Tk55WEhTQkdDZ3I0ZUd2c2g3Q2VOU1ZVMzlxL1JQUWsyMk9w?=
 =?utf-8?B?Y0RURFl1MXZOMDJ6b01wMEl4OXd4SHV0VktRTDZhZ0RqRmVtY2JoRHlmYnR4?=
 =?utf-8?B?blUySXhLRnlIdFljNUZOTGpRKzZhR2NoY0lLbWFIY2I3b3FySkFWV2w2MDFU?=
 =?utf-8?B?MmZHL3ZEZmdhQTBDNzVIYjlJQlpMUEtHRDduck55ejhaODVLSzNWZlBHREdI?=
 =?utf-8?B?UlRiRkw0SHl1MDhmWW1WSjZJUGJrTnk1eTUzcW1aaFp4SlFBR3lFUmc5WW1Y?=
 =?utf-8?B?NVovT285TXV5bUpKc01pMUlHNXlzOGQxQU9KMmI0U1NWY3pGSFpBd0dFekM2?=
 =?utf-8?B?ZzRhdXNMT2VNcmlDRit0eEFJbnVJdHhEUjJGdjVjQThoZW1RTzlIK0VLYVdY?=
 =?utf-8?B?R2FOdVhUY2I3Zml1NTJ1Y3I0SG9oVGhvbUg4eHRNR3B2eUZMcFhnNjUyTFp6?=
 =?utf-8?B?bTZwMkEyRTdpV1JscjFnRWdHS0hONG5RQVFzeXRTcTMwOVVyRlhxZzNreFpz?=
 =?utf-8?Q?usbZb3UMMqRIjY4WYE1OSJRV7BL3Rb2A?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dlFhbVBwNUZoTVlJVmtNNnhzNDNhL2srQ0xINTlONURGUFNuUFZqaXN1RDB2?=
 =?utf-8?B?aCtCNFdIRUNrSDhHQ1VaaVpDcU02QVp1dU1jRHV0SEM4KzVSZVJ4bWZRZEpw?=
 =?utf-8?B?T21mZXpGWFUvYUlYcjA1eE5DQVlteGF5clhsWFloU3ZUNHNLdUJMV1BUYndk?=
 =?utf-8?B?RG5ZMkFtR1FMTmFyQzBFSGRyZEZDdlVENUl5NllTeXA4alh3YXdRWG5kVWdv?=
 =?utf-8?B?eWQybzE3d0l3S240K3ZNN0VETDAzTEgxeDFDWlF1dTd6VWVNQ2RyWFloWFRp?=
 =?utf-8?B?bmdwY0N1ZnVTbFRwd2E5RC9RM01YN0xmQTYrY2ZDYks2d3Q5RDRwbExhMWxL?=
 =?utf-8?B?UjhXaXoweWJlSjA1dDBMODdKeVhDVFgxdjFpOTV1b3Frd1dKbUZlQ3hEeW96?=
 =?utf-8?B?bGxMS0xhTCsyKys1TlFScVJxc1ZjT2FRRTZBQ0lueW5NZWlSQm14WU9rbmJ4?=
 =?utf-8?B?aGtjNWd5UTRkeEMrRElaSmduRVZNaHNVeG4xVkpjY0xwWFJQaVhsdXRmM3E5?=
 =?utf-8?B?NWRVNlIvODRwUHlkOXIzcC81RVFiVW9EOHNmck9Vc0tKL0E5RTJxN1NyYTk0?=
 =?utf-8?B?QkxzTjN4VUorVFI2eHF2NFBPdmhuV2tBOUM2cURIVmFoTUhsSi9GODdNMFBv?=
 =?utf-8?B?ejcvWXFKVDkrSEFJNFRmQzZIeXNlb3g4d2dyZzREbmJsRlZhR0NSV2lLTnE4?=
 =?utf-8?B?dzh0bG0vWkNucS9obWJxN2RUcTFKcmxrdFhMdHlBMHZOU0NiYjRVdVJubHJO?=
 =?utf-8?B?MEtHYmIrMHhtaXVUcG5uaTVZNGtTSDdFQ3MxSlhvV29CL0JCeGdEQW5Za1ha?=
 =?utf-8?B?bCtOaGVNS3dKRzJnTWJidnhVczdjQ0YxV3ZORThJenZVWStxdWx6UzJvZjR5?=
 =?utf-8?B?S05EOW95L3JlN2hJZHVjTlh0ZWliUVZUVzJyWUNwa3FlZmhDMFZId0MycGor?=
 =?utf-8?B?aHBMa0g3NHo0cW01citpNU1ZNHBUVkVCeUIwaHRpbzM0S3ZhSzVTRlZhazdW?=
 =?utf-8?B?QytWbU5OVVdPUEI0d3d1TEh6L2NtOVdEVVJTc3llMTBPdWJoUmJiTnlBb2Y2?=
 =?utf-8?B?ZzR3czlLU3ltZ1J4WmZja1JkUW8zUUZtUHNEVjA0dlptTEF0ZUJ0T1lMTDFT?=
 =?utf-8?B?VVFPalIzVmdFYjRQamU5ei9IMjd5TVhlZm0rUW9NSHA3RHQwVUpMdVdTaURn?=
 =?utf-8?B?b29nMzZWdW1mV3UveHdkOHVDdHBBRGdta0Iyamx5eUhhK3VKWjhGSmNSMWdX?=
 =?utf-8?B?STJPcmUzbmthY0pLbDBGNmE3WmQvUW4yeG01ZUxwWjNxRTByQ2U5LzRRYy8v?=
 =?utf-8?B?VnZxMXl1SzBDVzZDbnExUzZnbHZPbnd2R0RwdjhZT2hWeElEZVQ3SDRwNmlu?=
 =?utf-8?B?S0hrdE9ZaDBINXc0b1g0ZUp2MkhkL1Z6ZTBlbGNtUmh0QlFvR0ZOM3pvOStQ?=
 =?utf-8?B?eWtWM1NqUzFnRUdWYzNYbHg2Y1dWSFZnYXJqTmFLWXdmbzZLQ1FOdFhJRWI1?=
 =?utf-8?B?QXVGZXkyR0VHNlpIbjVneXNKaUI1TjFpNjdPdjVjZU52REpDMVcwbmZ3ZUpJ?=
 =?utf-8?B?STlMYnRhaW51ZjllNlpuTTAwZFZqYXQ3ZVlwclE1d3dSTkwrdjc3cWs5TTlG?=
 =?utf-8?B?Qzc3L2JyWVRHQnRpeUlSTWxENUFFSGZhM0xGUkw0dFhUcnBFNTJjeHFnUlF5?=
 =?utf-8?B?dUVva2Z6L2RXMWY1dHc0UzA2THhvZnFmYk9DeklXeVVKbHNqaGlmWElBdnBJ?=
 =?utf-8?B?N1NjRVQrcFJBOVg1NENKTzdML2F5UXY0cFY4T1JJenA2QzNham5vWlNSTXVH?=
 =?utf-8?B?MDFvQWkwQjRBT2VZdFlKTnNodUdGV1dsRzMxYmRGNk1qRHFiY3pxRUFpSTZV?=
 =?utf-8?B?c21OWmIvUzR5emxuNE1ZS1ZPRkVuOXVwbmV4WkNUM2Q3VnRsbWZ5OXNycm8w?=
 =?utf-8?B?RmtUeDdob1QwN0l1Q0dIZ1Zham5Yc3BpTVZKWFgwR2I0OUdLVVJCTE5GOVVP?=
 =?utf-8?B?Qi9HL215TjdjWGcrcXhsU25pbHlGOTlkQ25LQ2hOVWdqd2hTakZTZDZVUUtN?=
 =?utf-8?B?Vm1xNTI5VGZBY0FVaVVuM1hzN1RaY3l2QktTYUFYUjBzZktiSEt2Y0p4ZjlJ?=
 =?utf-8?B?S0ZFbDJPNGxuOGh6WjRQS2Z4R0ZLRXByUGowaXN3QkpSbFFXbHVSd0p4RlRB?=
 =?utf-8?Q?pjIzfT5m8cr7aKsD3rXlmtE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FF54251C4F0C0478A3BE273EA405AE4@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 16968e63-b893-4f70-a0e6-08dd34fe7701
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 00:49:27.9156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NLfPD3rWAiGoLXKfQo/klNp+mteqTn4XCDTeV38e/nFhW6NAXNerD6urGmvzsu/3HTGBqyCYLS1zUbwFraLzJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4617
X-Proofpoint-ORIG-GUID: 7ZxNb4RIQzx8keHdZmfBTbeE5cB_qP3I
X-Proofpoint-GUID: 9z6YqiNJeiOUNj2dYGrmXBBs2Fkf2i9E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-14_08,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 impostorscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501150001

SGVsbG8sDQoNClRoZSBnZW5lcmljLzM5NyB0ZXN0IGdlbmVyYXRlIGtlcm5lbCBjcmFzaCBmb3Ig
dGhlIGNhc2Ugb2YNCmVuY3J5cHRlZCBpbm9kZSB3aXRoIHVuYWxpZ25lZCBmaWxlIHNpemUgKGZv
ciBleGFtcGxlLCAzM0sNCm9yIDFLKToNCg0KSmFuIDMgMTI6MzQ6NDAgY2VwaC10ZXN0aW5nLTAw
MDEgcm9vdDogcnVuIHhmc3Rlc3QgZ2VuZXJpYy8zOTcNCkphbiAzIDEyOjM0OjQwIGNlcGgtdGVz
dGluZy0wMDAxIGtlcm5lbDogWyA4NzcuNzM3ODExXSBydW4gZnN0ZXN0cw0KZ2VuZXJpYy8zOTcg
YXQgMjAyNS0wMS0wMyAxMjozNDo0MA0KSmFuIDMgMTI6MzQ6NDAgY2VwaC10ZXN0aW5nLTAwMDEg
c3lzdGVtZDE6IFN0YXJ0ZWQgL3Vzci9iaW4vYmFzaCBjIHRlc3QNCi13IC9wcm9jL3NlbGYvb29t
X3Njb3JlX2FkaiAmJiBlY2hvIDI1MCA+IC9wcm9jL3NlbGYvb29tX3Njb3JlX2FkajsNCmV4ZWMg
Li90ZXN0cy9nZW5lcmljLzM5Ny4NCkphbiAzIDEyOjM0OjQwIGNlcGgtdGVzdGluZy0wMDAxIGtl
cm5lbDogWyA4NzcuODc1NzYxXSBsaWJjZXBoOiBtb24wDQooMikxMjcuMC4wLjE6NDA2NzQgc2Vz
c2lvbiBlc3RhYmxpc2hlZA0KSmFuIDMgMTI6MzQ6NDAgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVs
OiBbIDg3Ny44NzYxMzBdIGxpYmNlcGg6DQpjbGllbnQ0NjE0IGZzaWQgMTliOTBiY2EtZjFhZS00
N2E2LTkzZGQtMGIwM2VlNjM3OTQ5DQpKYW4gMyAxMjozNDo0MCBjZXBoLXRlc3RpbmctMDAwMSBr
ZXJuZWw6IFsgODc3Ljk5MTk2NV0gbGliY2VwaDogbW9uMA0KKDIpMTI3LjAuMC4xOjQwNjc0IHNl
c3Npb24gZXN0YWJsaXNoZWQNCkphbiAzIDEyOjM0OjQwIGNlcGgtdGVzdGluZy0wMDAxIGtlcm5l
bDogWyA4NzcuOTkyMzM0XSBsaWJjZXBoOg0KY2xpZW50NDYxNyBmc2lkIDE5YjkwYmNhLWYxYWUt
NDdhNi05M2RkLTBiMDNlZTYzNzk0OQ0KSmFuIDMgMTI6MzQ6NDAgY2VwaC10ZXN0aW5nLTAwMDEg
a2VybmVsOiBbIDg3OC4wMTcyMzRdIGxpYmNlcGg6IG1vbjANCigyKTEyNy4wLjAuMTo0MDY3NCBz
ZXNzaW9uIGVzdGFibGlzaGVkDQpKYW4gMyAxMjozNDo0MCBjZXBoLXRlc3RpbmctMDAwMSBrZXJu
ZWw6IFsgODc4LjAxNzU5NF0gbGliY2VwaDoNCmNsaWVudDQ2MjAgZnNpZCAxOWI5MGJjYS1mMWFl
LTQ3YTYtOTNkZC0wYjAzZWU2Mzc5NDkNCkphbiAzIDEyOjM0OjQwIGNlcGgtdGVzdGluZy0wMDAx
IGtlcm5lbDogWyA4NzguMDMxMzk0XSB4ZnNfaW8gKHBpZA0KMTg5ODgpIGlzIHNldHRpbmcgZGVw
cmVjYXRlZCB2MSBlbmNyeXB0aW9uIHBvbGljeTsgcmVjb21tZW5kIHVwZ3JhZGluZw0KdG8gdjIu
DQpKYW4gMyAxMjozNDo0MCBjZXBoLXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgODc4LjA1NDUyOF0g
bGliY2VwaDogbW9uMA0KKDIpMTI3LjAuMC4xOjQwNjc0IHNlc3Npb24gZXN0YWJsaXNoZWQNCkph
biAzIDEyOjM0OjQwIGNlcGgtdGVzdGluZy0wMDAxIGtlcm5lbDogWyA4NzguMDU0ODkyXSBsaWJj
ZXBoOg0KY2xpZW50NDYyMyBmc2lkIDE5YjkwYmNhLWYxYWUtNDdhNi05M2RkLTBiMDNlZTYzNzk0
OQ0KSmFuIDMgMTI6MzQ6NDAgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDg3OC4wNzAyODdd
IGxpYmNlcGg6IG1vbjANCigyKTEyNy4wLjAuMTo0MDY3NCBzZXNzaW9uIGVzdGFibGlzaGVkDQpK
YW4gMyAxMjozNDo0MCBjZXBoLXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgODc4LjA3MDcwNF0gbGli
Y2VwaDoNCmNsaWVudDQ2MjYgZnNpZCAxOWI5MGJjYS1mMWFlLTQ3YTYtOTNkZC0wYjAzZWU2Mzc5
NDkNCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGluZy0wMDAxIGtlcm5lbDogWyA4NzguMjY0NTg2
XSBsaWJjZXBoOiBtb24wDQooMikxMjcuMC4wLjE6NDA2NzQgc2Vzc2lvbiBlc3RhYmxpc2hlZA0K
SmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDg3OC4yNjUyNThdIGxp
YmNlcGg6DQpjbGllbnQ0NjI5IGZzaWQgMTliOTBiY2EtZjFhZS00N2E2LTkzZGQtMGIwM2VlNjM3
OTQ5DQpKYW4gMyAxMjozNDo0MSBjZXBoLXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgODc4LjM3NDU3
OF0gLS0tLS0tLS0tLS1bIGN1dA0KaGVyZSBdLS0tLS0tLS0tLS0tDQpKYW4gMyAxMjozNDo0MSBj
ZXBoLXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgODc4LjM3NDU4Nl0ga2VybmVsIEJVRyBhdA0KbmV0
L2NlcGgvbWVzc2VuZ2VyLmM6MTA3MCENCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGluZy0wMDAx
IGtlcm5lbDogWyA4NzguMzc1MTUwXSBPb3BzOiBpbnZhbGlkDQpvcGNvZGU6IDAwMDAgWyMxXSBQ
UkVFTVBUIFNNUCBOT1BUSQ0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVs
OiBbIDg3OC4zNzgxNDVdIENQVTogMiBVSUQ6IDANClBJRDogNDc1OSBDb21tOiBrd29ya2VyLzI6
OSBOb3QgdGFpbnRlZCA2LjEzLjAtcmM1KyAjMQ0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5n
LTAwMDEga2VybmVsOiBbIDg3OC4zNzg5NjldIEhhcmR3YXJlIG5hbWU6DQpRRU1VIFN0YW5kYXJk
IFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyByZWwtMS4xNi4zLTAtDQpnYTZlZDZiNzAx
ZjBhLXByZWJ1aWx0LnFlbXUub3JnIDA0LzAxLzIwMTQNCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVz
dGluZy0wMDAxIGtlcm5lbDogWyA4NzguMzgwMTY3XSBXb3JrcXVldWU6IGNlcGgtDQptc2dyIGNl
cGhfY29uX3dvcmtmbg0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVsOiBb
IDg3OC4zODE2MzldIFJJUDoNCjAwMTA6Y2VwaF9tc2dfZGF0YV9jdXJzb3JfaW5pdCsweDQyLzB4
NTANCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGluZy0wMDAxIGtlcm5lbDogWyA4NzguMzgyMTUy
XSBDb2RlOiA4OSAxNyA0OA0KOGIgNDYgNzAgNTUgNDggODkgNDcgMDggYzcgNDcgMTggMDAgMDAg
MDAgMDAgNDggODkgZTUgZTggZGUgY2MgZmYgZmYgNWQNCjMxIGMwIDMxIGQyIDMxIGY2IDMxIGZm
IGMzIGNjIGNjIGNjIGNjIDBmIDBiIDwwZj4gMGIgMGYgMGIgNjYgMmUgMGYgMWYNCjg0IDAwIDAw
IDAwIDAwIDAwIDkwIDkwIDkwIDkwIDkwIDkwIDkwIDkwDQpKYW4gMyAxMjozNDo0MSBjZXBoLXRl
c3RpbmctMDAwMSBrZXJuZWw6IFsgODc4LjM4MzkyOF0gUlNQOg0KMDAxODpmZmZmYjRmZmM3Y2Ji
ZDI4IEVGTEFHUzogMDAwMTAyODcNCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGluZy0wMDAxIGtl
cm5lbDogWyA4NzguMzg0NDQ3XSBSQVg6DQpmZmZmZmZmZjgyYmI5YWMwIFJCWDogZmZmZjk4MTM5
MGMyZjFmOCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDANCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGlu
Zy0wMDAxIGtlcm5lbDogWyA4NzguMzg1MTI5XSBSRFg6DQowMDAwMDAwMDAwMDA5MDAwIFJTSTog
ZmZmZjk4MTI4ODIzMmI1OCBSREk6IGZmZmY5ODEzOTBjMmYzNzgNCkphbiAzIDEyOjM0OjQxIGNl
cGgtdGVzdGluZy0wMDAxIGtlcm5lbDogWyA4NzguMzg1ODM5XSBSQlA6DQpmZmZmYjRmZmM3Y2Ji
ZTE4IFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDANCkphbiAzIDEy
OjM0OjQxIGNlcGgtdGVzdGluZy0wMDAxIGtlcm5lbDogWyA4NzguMzg2NTM5XSBSMTA6DQowMDAw
MDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6IGZmZmY5ODEzOTBjMmYwMzAN
CkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGluZy0wMDAxIGtlcm5lbDogWyA4NzguMzg3MjAzXSBS
MTM6DQpmZmZmOTgxMjg4MjMyYjU4IFIxNDogMDAwMDAwMDAwMDAwMDAyOSBSMTU6IDAwMDAwMDAw
MDAwMDAwMDENCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGluZy0wMDAxIGtlcm5lbDogWyA4Nzgu
Mzg3ODc3XSBGUzoNCjAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjk4MTRiNzkwMDAwMCgw
MDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwDQpKYW4gMyAxMjozNDo0MSBjZXBoLXRlc3Rpbmct
MDAwMSBrZXJuZWw6IFsgODc4LjM4ODY2M10gQ1M6IDAwMTAgRFM6DQowMDAwIEVTOiAwMDAwIENS
MDogMDAwMDAwMDA4MDA1MDAzMw0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEga2Vy
bmVsOiBbIDg3OC4zODkyMTJdIENSMjoNCjAwMDA1ZTEwNmEwNTU0ZTAgQ1IzOiAwMDAwMDAwMTEy
YmYwMDAxIENSNDogMDAwMDAwMDAwMDc3MmVmMA0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5n
LTAwMDEga2VybmVsOiBbIDg3OC4zODk5MjFdIERSMDoNCjAwMDAwMDAwMDAwMDAwMDAgRFIxOiAw
MDAwMDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMA0KSmFuIDMgMTI6MzQ6NDEgY2Vw
aC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDg3OC4zOTA2MjBdIERSMzoNCjAwMDAwMDAwMDAwMDAw
MDAgRFI2OiAwMDAwMDAwMGZmZmUwZmYwIERSNzogMDAwMDAwMDAwMDAwMDQwMA0KSmFuIDMgMTI6
MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDg3OC4zOTEzMDddIFBLUlU6IDU1NTU1
NTU0DQpKYW4gMyAxMjozNDo0MSBjZXBoLXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgODc4LjM5MTU2
N10gQ2FsbCBUcmFjZToNCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGluZy0wMDAxIGtlcm5lbDog
WyA4NzguMzkxODA3XSA8VEFTSz4NCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGluZy0wMDAxIGtl
cm5lbDogWyA4NzguMzkyMDIxXSA/DQpzaG93X3JlZ3MrMHg3MS8weDkwDQpKYW4gMyAxMjozNDo0
MSBjZXBoLXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgODc4LjM5MjM5MV0gPyBkaWUrMHgzOC8weGEw
DQpKYW4gMyAxMjozNDo0MSBjZXBoLXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgODc4LjM5MjY2N10g
Pw0KZG9fdHJhcCsweGRiLzB4MTAwDQpKYW4gMyAxMjozNDo0MSBjZXBoLXRlc3RpbmctMDAwMSBr
ZXJuZWw6IFsgODc4LjM5Mjk4MV0gPw0KZG9fZXJyb3JfdHJhcCsweDc1LzB4YjANCkphbiAzIDEy
OjM0OjQxIGNlcGgtdGVzdGluZy0wMDAxIGtlcm5lbDogWyA4NzguMzkzMzcyXSA/DQpjZXBoX21z
Z19kYXRhX2N1cnNvcl9pbml0KzB4NDIvMHg1MA0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5n
LTAwMDEga2VybmVsOiBbIDg3OC4zOTM4NDJdID8NCmV4Y19pbnZhbGlkX29wKzB4NTMvMHg4MA0K
SmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDg3OC4zOTQyMzJdID8N
CmNlcGhfbXNnX2RhdGFfY3Vyc29yX2luaXQrMHg0Mi8weDUwDQpKYW4gMyAxMjozNDo0MSBjZXBo
LXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgODc4LjM5NDY5NF0gPw0KYXNtX2V4Y19pbnZhbGlkX29w
KzB4MWIvMHgyMA0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDg3
OC4zOTUwOTldID8NCmNlcGhfbXNnX2RhdGFfY3Vyc29yX2luaXQrMHg0Mi8weDUwDQpKYW4gMyAx
MjozNDo0MSBjZXBoLXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgODc4LjM5NTU4M10gPw0KY2VwaF9j
b25fdjJfdHJ5X3JlYWQrMHhkMTYvMHgyMjIwDQpKYW4gMyAxMjozNDo0MSBjZXBoLXRlc3Rpbmct
MDAwMSBrZXJuZWw6IFsgODc4LjM5NjAyN10gPw0KX3Jhd19zcGluX3VubG9jaysweGUvMHg0MA0K
SmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDg3OC4zOTY0MjhdID8N
CnJhd19zcGluX3JxX3VubG9jaysweDEwLzB4NDANCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGlu
Zy0wMDAxIGtlcm5lbDogWyA4NzguMzk2ODQyXSA/DQpmaW5pc2hfdGFza19zd2l0Y2guaXNyYS4w
KzB4OTcvMHgzMTANCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGluZy0wMDAxIGtlcm5lbDogWyA4
NzguMzk3MzM4XSA/DQpfX3NjaGVkdWxlKzB4NDRiLzB4MTZiMA0KSmFuIDMgMTI6MzQ6NDEgY2Vw
aC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDg3OC4zOTc3MzhdDQpjZXBoX2Nvbl93b3JrZm4rMHgz
MjYvMHg3NTANCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGluZy0wMDAxIGtlcm5lbDogWyA4Nzgu
Mzk4MTIxXQ0KcHJvY2Vzc19vbmVfd29yaysweDE4OC8weDNkMA0KSmFuIDMgMTI6MzQ6NDEgY2Vw
aC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDg3OC4zOTg1MjJdID8NCl9fcGZ4X3dvcmtlcl90aHJl
YWQrMHgxMC8weDEwDQpKYW4gMyAxMjozNDo0MSBjZXBoLXRlc3RpbmctMDAwMSBrZXJuZWw6IFsg
ODc4LjM5ODkyOV0NCndvcmtlcl90aHJlYWQrMHgyYjUvMHgzYzANCkphbiAzIDEyOjM0OjQxIGNl
cGgtdGVzdGluZy0wMDAxIGtlcm5lbDogWyA4NzguMzk5MzEwXSA/DQpfX3BmeF93b3JrZXJfdGhy
ZWFkKzB4MTAvMHgxMA0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVsOiBb
IDg3OC4zOTk3MjddDQprdGhyZWFkKzB4ZTEvMHgxMjANCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVz
dGluZy0wMDAxIGtlcm5lbDogWyA4NzguNDAwMDMxXSA/DQpfX3BmeF9rdGhyZWFkKzB4MTAvMHgx
MA0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDg3OC40MDA0MzFd
DQpyZXRfZnJvbV9mb3JrKzB4NDMvMHg3MA0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAw
MDEga2VybmVsOiBbIDg3OC40MDA3NzFdID8NCl9fcGZ4X2t0aHJlYWQrMHgxMC8weDEwDQpKYW4g
MyAxMjozNDo0MSBjZXBoLXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgODc4LjQwMTEyN10NCnJldF9m
cm9tX2ZvcmtfYXNtKzB4MWEvMHgzMA0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEg
a2VybmVsOiBbIDg3OC40MDE1NDNdIDwvVEFTSz4NCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGlu
Zy0wMDAxIGtlcm5lbDogWyA4NzguNDAxNzYwXSBNb2R1bGVzIGxpbmtlZA0KaW46IGhjdHIyIG5o
cG9seTEzMDVfYXZ4MiBuaHBvbHkxMzA1X3NzZTIgbmhwb2x5MTMwNSBjaGFjaGFfZ2VuZXJpYw0K
Y2hhY2hhX3g4Nl82NCBsaWJjaGFjaGEgYWRpYW50dW0gbGlicG9seTEzMDUgZXNzaXYgYXV0aGVu
YyBtcHRjcF9kaWFnDQp4c2tfZGlhZyB0Y3BfZGlhZyB1ZHBfZGlhZyByYXdfZGlhZyBpbmV0X2Rp
YWcgdW5peF9kaWFnIGFmX3BhY2tldF9kaWFnDQpuZXRsaW5rX2RpYWcgaW50ZWxfcmFwbF9tc3Ig
aW50ZWxfcmFwbF9jb21tb24NCmludGVsX3VuY29yZV9mcmVxdWVuY3lfY29tbW9uIHNreF9lZGFj
X2NvbW1vbiBuZml0IGt2bV9pbnRlbCBrdm0NCmNyY3QxMGRpZl9wY2xtdWwgY3JjMzJfcGNsbXVs
IHBvbHl2YWxfY2xtdWxuaSBwb2x5dmFsX2dlbmVyaWMNCmdoYXNoX2NsbXVsbmlfaW50ZWwgc2hh
MjU2X3Nzc2UzIHNoYTFfc3NzZTMgYWVzbmlfaW50ZWwgam95ZGV2DQpjcnlwdG9fc2ltZCBjcnlw
dGQgcmFwbCBpbnB1dF9sZWRzIHBzbW91c2Ugc2NoX2ZxX2NvZGVsIHNlcmlvX3JhdyBib2Nocw0K
aTJjX3BpaXg0IGZsb3BweSBxZW11X2Z3X2NmZyBpMmNfc21idXMgbWFjX2hpZCBwYXRhX2FjcGkg
bXNyIHBhcnBvcnRfcGMNCnBwZGV2IGxwIHBhcnBvcnQgZWZpX3BzdG9yZSBpcF90YWJsZXMgeF90
YWJsZXMNCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGluZy0wMDAxIGtlcm5lbDogWyA4NzguNDA3
MzE5XSAtLS1bIGVuZCB0cmFjZQ0KMDAwMDAwMDAwMDAwMDAwMCBdLS0tDQpKYW4gMyAxMjozNDo0
MSBjZXBoLXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgODc4LjQwNzc3NV0gUklQOg0KMDAxMDpjZXBo
X21zZ19kYXRhX2N1cnNvcl9pbml0KzB4NDIvMHg1MA0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0
aW5nLTAwMDEga2VybmVsOiBbIDg3OC40MDgzMTddIENvZGU6IDg5IDE3IDQ4DQo4YiA0NiA3MCA1
NSA0OCA4OSA0NyAwOCBjNyA0NyAxOCAwMCAwMCAwMCAwMCA0OCA4OSBlNSBlOCBkZSBjYyBmZiBm
ZiA1ZA0KMzEgYzAgMzEgZDIgMzEgZjYgMzEgZmYgYzMgY2MgY2MgY2MgY2MgMGYgMGIgPDBmPiAw
YiAwZiAwYiA2NiAyZSAwZiAxZg0KODQgMDAgMDAgMDAgMDAgMDAgOTAgOTAgOTAgOTAgOTAgOTAg
OTAgOTANCkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGluZy0wMDAxIGtlcm5lbDogWyA4NzguNDEw
MDg3XSBSU1A6DQowMDE4OmZmZmZiNGZmYzdjYmJkMjggRUZMQUdTOiAwMDAxMDI4Nw0KSmFuIDMg
MTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDg3OC40MTA2MDldIFJBWDoNCmZm
ZmZmZmZmODJiYjlhYzAgUkJYOiBmZmZmOTgxMzkwYzJmMWY4IFJDWDogMDAwMDAwMDAwMDAwMDAw
MA0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDg3OC40MTEzMThd
IFJEWDoNCjAwMDAwMDAwMDAwMDkwMDAgUlNJOiBmZmZmOTgxMjg4MjMyYjU4IFJESTogZmZmZjk4
MTM5MGMyZjM3OA0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDg3
OC40MTIwMTRdIFJCUDoNCmZmZmZiNGZmYzdjYmJlMTggUjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIw
OTogMDAwMDAwMDAwMDAwMDAwMA0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5nLTAwMDEga2Vy
bmVsOiBbIDg3OC40MTI3MzVdIFIxMDoNCjAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAwMDAwMDAw
MDAwMDAwIFIxMjogZmZmZjk4MTM5MGMyZjAzMA0KSmFuIDMgMTI6MzQ6NDEgY2VwaC10ZXN0aW5n
LTAwMDEga2VybmVsOiBbIDg3OC40MTM0MzhdIFIxMzoNCmZmZmY5ODEyODgyMzJiNTggUjE0OiAw
MDAwMDAwMDAwMDAwMDI5IFIxNTogMDAwMDAwMDAwMDAwMDAwMQ0KSmFuIDMgMTI6MzQ6NDEgY2Vw
aC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDg3OC40MTQxMjFdIEZTOg0KMDAwMDAwMDAwMDAwMDAw
MCgwMDAwKSBHUzpmZmZmOTgxNGI3OTAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAN
CkphbiAzIDEyOjM0OjQxIGNlcGgtdGVzdGluZy0wMDAxIGtlcm5lbDogWyA4NzguNDE0OTM1XSBD
UzogMDAxMCBEUzoNCjAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzDQpKYW4gMyAx
MjozNDo0MSBjZXBoLXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgODc4LjQxNTUxNl0gQ1IyOg0KMDAw
MDVlMTA2YTA1NTRlMCBDUjM6IDAwMDAwMDAxMTJiZjAwMDEgQ1I0OiAwMDAwMDAwMDAwNzcyZWYw
DQpKYW4gMyAxMjozNDo0MSBjZXBoLXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgODc4LjQxNjIxMV0g
RFIwOg0KMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAwMDAw
MDAwMDAwMDAwDQpKYW4gMyAxMjozNDo0MSBjZXBoLXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgODc4
LjQxNjkwN10gRFIzOg0KMDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZmZTBmZjAgRFI3
OiAwMDAwMDAwMDAwMDAwNDAwDQpKYW4gMyAxMjozNDo0MSBjZXBoLXRlc3RpbmctMDAwMSBrZXJu
ZWw6IFsgODc4LjQxNzYzMF0gUEtSVTogNTU1NTU1NTQNCg0KQlVHX09OKGxlbmd0aCA+IG1zZy0+
ZGF0YV9sZW5ndGgpIHRyaWdnZXJzIHRoZSBpc3N1ZToNCg0KKGdkYikgbCAqY2VwaF9tc2dfZGF0
YV9jdXJzb3JfaW5pdCsweDQyDQoweGZmZmZmZmZmODIzYjQ1YTIgaXMgaW4gY2VwaF9tc2dfZGF0
YV9jdXJzb3JfaW5pdA0KKG5ldC9jZXBoL21lc3Nlbmdlci5jOjEwNzApLg0KMTA2NQ0KMTA2NiB2
b2lkIGNlcGhfbXNnX2RhdGFfY3Vyc29yX2luaXQoc3RydWN0IGNlcGhfbXNnX2RhdGFfY3Vyc29y
DQoqY3Vyc29yLA0KMTA2NyBzdHJ1Y3QgY2VwaF9tc2cgKm1zZywgc2l6ZV90IGxlbmd0aCkNCjEw
Njggew0KMTA2OSBCVUdfT04oIWxlbmd0aCk7DQoxMDcwIEJVR19PTihsZW5ndGggPiBtc2ctPmRh
dGFfbGVuZ3RoKTsNCjEwNzEgQlVHX09OKCFtc2ctPm51bV9kYXRhX2l0ZW1zKTsNCjEwNzINCjEw
NzMgY3Vyc29yLT50b3RhbF9yZXNpZCA9IGxlbmd0aDsNCjEwNzQgY3Vyc29yLT5kYXRhID0gbXNn
LT5kYXRhOw0KDQpUaGUgaXNzdWUgdGFrZXMgcGxhY2UgYmVjYXVzZSBvZiB0aGlzOg0KSmFuIDYg
MTQ6NTk6MjQgY2VwaC10ZXN0aW5nLTAwMDEga2VybmVsOiBbIDIwMi42Mjg4NTNdIGxpYmNlcGg6
IHBpZA0KMTQ0Om5ldC9jZXBoL21lc3Nlbmdlcl92Mi5jOjIwMzQgcHJlcGFyZV9zcGFyc2VfcmVh
ZF9kYXRhKCk6IG1zZy0NCj5kYXRhX2xlbmd0aCAzMzc5MiwgbXNnLT5zcGFyc2VfcmVhZF90b3Rh
bCAzNjg2NA0KMTA3MCBCVUdfT04obGVuZ3RoID4gbXNnLT5kYXRhX2xlbmd0aCk7DQptc2ctPnNw
YXJzZV9yZWFkX3RvdGFsIDM2ODY0ID4gbXNnLT5kYXRhX2xlbmd0aCAzMzc5Mg0KDQpUaGUgZ2Vu
ZXJpYy8zOTcgdGVzdCAoeGZzdGVzdHMpIGV4ZWN1dGVzIHN1Y2ggc3RlcHM6DQooMSkgY3JlYXRl
IGVuY3J5cHRlZCBmaWxlcyBhbmQgZGlyZWN0b3JpZXM7DQooMikgYWNjZXNzIHRoZSBjcmVhdGVk
IGZpbGVzIGFuZCBmb2xkZXJzIHdpdGggZW5jcnlwdGlvbiBrZXk7DQooMykgYWNjZXNzIHRoZSBj
cmVhdGVkIGZpbGVzIGFuZCBmb2xkZXJzIHdpdGhvdXQgZW5jcnlwdGlvbiBrZXkuDQoNCldlIGhh
dmUgaXNzdWUgYmVjYXVzZSB0aGVyZSBpcyBhbGlnbm1lbnQgb2YgbGVuZ3RoIGJlZm9yZSBjYWxs
aW5nDQpjZXBoX29zZGNfbmV3X3JlcXVlc3QoKToNCg0KSmFuIDggMTI6NDk6MjIgY2VwaC10ZXN0
aW5nLTAwMDEga2VybmVsOiBbIDMwMS41MjIxMjBdIGNlcGg6IHBpZA0KODkzMTpmcy9jZXBoL2Ny
eXB0by5oOjE0OCBjZXBoX2ZzY3J5cHRfYWRqdXN0X29mZl9hbmRfbGVuKCk6IGlubw0KMHgxMDAw
MDAwMDlkNTogZW5jcnlwdGVkIDB4NDAwMCwgbGVuIDMzNzkyDQpKYW4gOCAxMjo0OToyMiBjZXBo
LXRlc3RpbmctMDAwMSBrZXJuZWw6IFsgMzAxLjUyMzcwNl0gY2VwaDogcGlkDQo4OTMxOmZzL2Nl
cGgvY3J5cHRvLmg6MTU1IGNlcGhfZnNjcnlwdF9hZGp1c3Rfb2ZmX2FuZF9sZW4oKTogaW5vDQow
eDEwMDAwMDAwOWQ1OiBlbmNyeXB0ZWQgMHg0MDAwLCBsZW4gMzY4NjQNCg0KVGhpcyBwYXRjaCB1
c2VzIHVuYWxpZ25lZCBzaXplIGZvciByZXRyaWV2aW5nIGZpbGUncyBjb250ZW50DQpmcm9tIE9T
RCBhbmQsIHRoZW4sIGFsaWduZWQgdGhlIHNpemUgb2Ygc3BhcnNlIGV4dGVudCBpbiB0aGUNCmNh
c2UgaWYgaW5vZGUgaXMgZW5jcnlwdGVkLg0KDQouL2NoZWNrIGdlbmVyaWMvMzk3DQpGU1RZUCAg
ICAgICAgIC0tIGNlcGgNClBMQVRGT1JNICAgICAgLS0gTGludXgveDg2XzY0IGNlcGgtdGVzdGlu
Zy0wMDAxIDYuMTMuMC1yYzcrICM1OCBTTVANClBSRUVNUFRfRFlOQU1JQyBXZWQgSmFuIDE1IDAw
OjA3OjA2IFVUQyAyMDI1DQpNS0ZTX09QVElPTlMgIC0tIDEyNy4wLjAuMTo0MDYyOTovc2NyYXRj
aA0KTU9VTlRfT1BUSU9OUyAtLSAtbw0KbmFtZT1mcyxzZWNyZXQ9PGhpZGRlbj4sbXNfbW9kZT1j
cmMsbm93c3luYyxjb3B5ZnJvbQ0KMTI3LjAuMC4xOjxwb3J0Pjovc2NyYXRjaCAvbW50L3NjcmF0
Y2gNCg0KZ2VuZXJpYy8zOTcgMXMgLi4uICAxcw0KUmFuOiBnZW5lcmljLzM5Nw0KUGFzc2VkIGFs
bCAxIHRlc3RzDQoNClNpZ25lZC1vZmYtYnk6IFZpYWNoZXNsYXYgRHViZXlrbyA8U2xhdmEuRHVi
ZXlrb0BpYm0uY29tPg0KLS0tDQogZnMvY2VwaC9hZGRyLmMgfCAzMCArKysrKysrKysrKysrKysr
KysrKysrKystLS0tLS0NCiBmcy9jZXBoL2ZpbGUuYyB8IDIwICsrKysrKysrKysrKysrKysrLS0t
DQogMiBmaWxlcyBjaGFuZ2VkLCA0MSBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQ0KDQpk
aWZmIC0tZ2l0IGEvZnMvY2VwaC9hZGRyLmMgYi9mcy9jZXBoL2FkZHIuYw0KaW5kZXggODU5MzZm
NmQyYmY3Li41YTdhNjk4YWQ4ZTggMTAwNjQ0DQotLS0gYS9mcy9jZXBoL2FkZHIuYw0KKysrIGIv
ZnMvY2VwaC9hZGRyLmMNCkBAIC0yMzUsNiArMjM1LDE1IEBAIHN0YXRpYyB2b2lkIGZpbmlzaF9u
ZXRmc19yZWFkKHN0cnVjdA0KY2VwaF9vc2RfcmVxdWVzdCAqcmVxKQ0KIAkJICAgIHN1YnJlcS0+
cnJlcS0+b3JpZ2luICE9IE5FVEZTX0RJT19SRUFEKQ0KIAkJCV9fc2V0X2JpdChORVRGU19TUkVR
X0NMRUFSX1RBSUwsICZzdWJyZXEtDQo+ZmxhZ3MpOw0KIAkJaWYgKElTX0VOQ1JZUFRFRChpbm9k
ZSkgJiYgZXJyID4gMCkgew0KKwkJCXN0cnVjdCBjZXBoX3NwYXJzZV9leHRlbnQgKmV4dDsNCisJ
CQlpbnQgaTsNCisNCisJCQlmb3IgKGkgPSAwOyBpIDwgb3AtPmV4dGVudC5zcGFyc2VfZXh0X2Nu
dDsNCmkrKykgew0KKwkJCQlleHQgPSAmb3AtPmV4dGVudC5zcGFyc2VfZXh0W2ldOw0KKwkJCQlj
ZXBoX2ZzY3J5cHRfYWRqdXN0X29mZl9hbmRfbGVuKGlub2RlLA0KKwkJCQkJCSZleHQtPm9mZiwg
JmV4dC0+bGVuKTsNCisJCQl9DQorDQogCQkJZXJyID0gY2VwaF9mc2NyeXB0X2RlY3J5cHRfZXh0
ZW50cyhpbm9kZSwNCiAJCQkJCW9zZF9kYXRhLT5wYWdlcywgc3VicmVxLQ0KPnN0YXJ0LA0KIAkJ
CQkJb3AtPmV4dGVudC5zcGFyc2VfZXh0LA0KQEAgLTM1NywxMyArMzY2LDEyIEBAIHN0YXRpYyB2
b2lkIGNlcGhfbmV0ZnNfaXNzdWVfcmVhZChzdHJ1Y3QNCm5ldGZzX2lvX3N1YnJlcXVlc3QgKnN1
YnJlcSkNCiAJaWYgKGNlcGhfaGFzX2lubGluZV9kYXRhKGNpKSAmJg0KY2VwaF9uZXRmc19pc3N1
ZV9vcF9pbmxpbmUoc3VicmVxKSkNCiAJCXJldHVybjsNCiANCi0JLy8gVE9ETzogVGhpcyByb3Vu
ZGluZyBoZXJlIGlzIHNsaWdodGx5IGRvZGd5LiAgSXQgKnNob3VsZCoNCndvcmssIGZvcg0KLQkv
LyBub3csIGFzIHRoZSBjYWNoZSBvbmx5IGRlYWxzIGluIGJsb2NrcyB0aGF0IGFyZSBhIG11bHRp
cGxlDQpvZg0KLQkvLyBQQUdFX1NJWkUgYW5kIGZzY3J5cHQgYmxvY2tzIGFyZSBhdCBtb3N0IFBB
R0VfU0laRS4gIFdoYXQNCm5lZWRzIHRvDQotCS8vIGhhcHBlbiBpcyBmb3IgdGhlIGZzY3J5cHQg
ZHJpdmluZyB0byBiZSBtb3ZlZCBpbnRvIG5ldGZzbGliDQphbmQgdGhlDQotCS8vIGRhdGEgaW4g
dGhlIGNhY2hlIGFsc28gdG8gYmUgc3RvcmVkIGVuY3J5cHRlZC4NCisJLyoNCisJICogSXQgbmVl
ZHMgdG8gcHJvdmlkZSB0aGUgcmVhbCBsZWd0aCAobm90IGFsaWduZWQpIGZvcg0KbmV0d29yayBz
dWJzeXN0ZW0uDQorCSAqIE90aGVyd2lzZSwgY2VwaF9tc2dfZGF0YV9jdXJzb3JfaW5pdCgpIHRy
aWdnZXJzIEJVR19PTigpIGluDQp0aGUgY2FzZQ0KKwkgKiBpZiBtc2ctPnNwYXJzZV9yZWFkX3Rv
dGFsID4gbXNnLT5kYXRhX2xlbmd0aC4NCisJICovDQogCWxlbiA9IHN1YnJlcS0+bGVuOw0KLQlj
ZXBoX2ZzY3J5cHRfYWRqdXN0X29mZl9hbmRfbGVuKGlub2RlLCAmb2ZmLCAmbGVuKTsNCiANCiAJ
cmVxID0gY2VwaF9vc2RjX25ld19yZXF1ZXN0KCZmc2MtPmNsaWVudC0+b3NkYywgJmNpLT5pX2xh
eW91dCwNCnZpbm8sDQogCQkJb2ZmLCAmbGVuLCAwLCAxLCBzcGFyc2UgPw0KQ0VQSF9PU0RfT1Bf
U1BBUlNFX1JFQUQgOiBDRVBIX09TRF9PUF9SRUFELA0KQEAgLTM3NSw2ICszODMsMTYgQEAgc3Rh
dGljIHZvaWQgY2VwaF9uZXRmc19pc3N1ZV9yZWFkKHN0cnVjdA0KbmV0ZnNfaW9fc3VicmVxdWVz
dCAqc3VicmVxKQ0KIAkJZ290byBvdXQ7DQogCX0NCiANCisJLy8gVE9ETzogVGhpcyByb3VuZGlu
ZyBoZXJlIGlzIHNsaWdodGx5IGRvZGd5LiAgSXQgKnNob3VsZCoNCndvcmssIGZvcg0KKwkvLyBu
b3csIGFzIHRoZSBjYWNoZSBvbmx5IGRlYWxzIGluIGJsb2NrcyB0aGF0IGFyZSBhIG11bHRpcGxl
DQpvZg0KKwkvLyBQQUdFX1NJWkUgYW5kIGZzY3J5cHQgYmxvY2tzIGFyZSBhdCBtb3N0IFBBR0Vf
U0laRS4gIFdoYXQNCm5lZWRzIHRvDQorCS8vIGhhcHBlbiBpcyBmb3IgdGhlIGZzY3J5cHQgZHJp
dmluZyB0byBiZSBtb3ZlZCBpbnRvIG5ldGZzbGliDQphbmQgdGhlDQorCS8vIGRhdGEgaW4gdGhl
IGNhY2hlIGFsc28gdG8gYmUgc3RvcmVkIGVuY3J5cHRlZC4NCisJY2VwaF9mc2NyeXB0X2FkanVz
dF9vZmZfYW5kX2xlbihpbm9kZSwgJm9mZiwgJmxlbik7DQorDQorCWRvdXRjKGNsLCAiJWxseC4l
bGx4IHBvcz0lbGx1IG9yaWdfbGVuPSV6dSBsZW49JWxsdVxuIiwNCisJICAgICAgY2VwaF92aW5v
cChpbm9kZSksIHN1YnJlcS0+c3RhcnQsIHN1YnJlcS0+bGVuLCBsZW4pOw0KKw0KIAlpZiAoc3Bh
cnNlKSB7DQogCQlleHRlbnRfY250ID0gX19jZXBoX3NwYXJzZV9yZWFkX2V4dF9jb3VudChpbm9k
ZSwgbGVuKTsNCiAJCWVyciA9IGNlcGhfYWxsb2Nfc3BhcnNlX2V4dF9tYXAoJnJlcS0+cl9vcHNb
MF0sDQpleHRlbnRfY250KTsNCmRpZmYgLS1naXQgYS9mcy9jZXBoL2ZpbGUuYyBiL2ZzL2NlcGgv
ZmlsZS5jDQppbmRleCA4NTFkNzAyMDBjNmIuLjk0NDZhNWYwMDFhYSAxMDA2NDQNCi0tLSBhL2Zz
L2NlcGgvZmlsZS5jDQorKysgYi9mcy9jZXBoL2ZpbGUuYw0KQEAgLTEwOTMsMTIgKzEwOTMsMTUg
QEAgc3NpemVfdCBfX2NlcGhfc3luY19yZWFkKHN0cnVjdCBpbm9kZSAqaW5vZGUsDQpsb2ZmX3Qg
KmtpX3BvcywNCiAJCXU2NCByZWFkX2xlbiA9IGxlbjsNCiAJCWludCBleHRlbnRfY250Ow0KIA0K
LQkJLyogZGV0ZXJtaW5lIG5ldyBvZmZzZXQvbGVuZ3RoIGlmIGVuY3J5cHRlZCAqLw0KLQkJY2Vw
aF9mc2NyeXB0X2FkanVzdF9vZmZfYW5kX2xlbihpbm9kZSwgJnJlYWRfb2ZmLA0KJnJlYWRfbGVu
KTsNCi0NCiAJCWRvdXRjKGNsLCAib3JpZyAlbGx1fiVsbHUgcmVhZGluZyAlbGx1fiVsbHUiLCBv
ZmYsDQpsZW4sDQogCQkgICAgICByZWFkX29mZiwgcmVhZF9sZW4pOw0KIA0KKwkJLyoNCisJCSAq
IEl0IG5lZWRzIHRvIHByb3ZpZGUgdGhlIHJlYWwgbGVndGggKG5vdCBhbGlnbmVkKQ0KZm9yIG5l
dHdvcmsgc3Vic3lzdGVtLg0KKwkJICogT3RoZXJ3aXNlLCBjZXBoX21zZ19kYXRhX2N1cnNvcl9p
bml0KCkgdHJpZ2dlcnMNCkJVR19PTigpIGluIHRoZSBjYXNlDQorCQkgKiBpZiBtc2ctPnNwYXJz
ZV9yZWFkX3RvdGFsID4gbXNnLT5kYXRhX2xlbmd0aC4NCisJCSAqLw0KKw0KIAkJcmVxID0gY2Vw
aF9vc2RjX25ld19yZXF1ZXN0KG9zZGMsICZjaS0+aV9sYXlvdXQsDQogCQkJCQljaS0+aV92aW5v
LCByZWFkX29mZiwNCiZyZWFkX2xlbiwgMCwgMSwNCiAJCQkJCXNwYXJzZSA/DQpDRVBIX09TRF9P
UF9TUEFSU0VfUkVBRCA6DQpAQCAtMTExMSw2ICsxMTE0LDkgQEAgc3NpemVfdCBfX2NlcGhfc3lu
Y19yZWFkKHN0cnVjdCBpbm9kZSAqaW5vZGUsDQpsb2ZmX3QgKmtpX3BvcywNCiAJCQlicmVhazsN
CiAJCX0NCiANCisJCS8qIGRldGVybWluZSBuZXcgb2Zmc2V0L2xlbmd0aCBpZiBlbmNyeXB0ZWQg
Ki8NCisJCWNlcGhfZnNjcnlwdF9hZGp1c3Rfb2ZmX2FuZF9sZW4oaW5vZGUsICZyZWFkX29mZiwN
CiZyZWFkX2xlbik7DQorDQogCQkvKiBhZGp1c3QgbGVuIGRvd253YXJkIGlmIHRoZSByZXF1ZXN0
IHRydW5jYXRlZCB0aGUNCmxlbiAqLw0KIAkJaWYgKG9mZiArIGxlbiA+IHJlYWRfb2ZmICsgcmVh
ZF9sZW4pDQogCQkJbGVuID0gcmVhZF9vZmYgKyByZWFkX2xlbiAtIG9mZjsNCkBAIC0xMTY4LDcg
KzExNzQsMTUgQEAgc3NpemVfdCBfX2NlcGhfc3luY19yZWFkKHN0cnVjdCBpbm9kZSAqaW5vZGUs
DQpsb2ZmX3QgKmtpX3BvcywNCiAJCX0NCiANCiAJCWlmIChJU19FTkNSWVBURUQoaW5vZGUpKSB7
DQorCQkJc3RydWN0IGNlcGhfc3BhcnNlX2V4dGVudCAqZXh0Ow0KIAkJCWludCBmcmV0Ow0KKwkJ
CWludCBpOw0KKw0KKwkJCWZvciAoaSA9IDA7IGkgPCBvcC0+ZXh0ZW50LnNwYXJzZV9leHRfY250
Ow0KaSsrKSB7DQorCQkJCWV4dCA9ICZvcC0+ZXh0ZW50LnNwYXJzZV9leHRbaV07DQorCQkJCWNl
cGhfZnNjcnlwdF9hZGp1c3Rfb2ZmX2FuZF9sZW4oaW5vZGUsDQorCQkJCQkJJmV4dC0+b2ZmLCAm
ZXh0LT5sZW4pOw0KKwkJCX0NCiANCiAJCQlmcmV0ID0gY2VwaF9mc2NyeXB0X2RlY3J5cHRfZXh0
ZW50cyhpbm9kZSwNCnBhZ2VzLA0KIAkJCQkJcmVhZF9vZmYsIG9wLQ0KPmV4dGVudC5zcGFyc2Vf
ZXh0LA0KLS0gDQoyLjQ3LjENCg0K

