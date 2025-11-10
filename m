Return-Path: <ceph-devel+bounces-3983-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A28EC492CB
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 21:03:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB22D188ECFA
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 20:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0332932C946;
	Mon, 10 Nov 2025 20:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iRfsVFhW"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603DA221F03;
	Mon, 10 Nov 2025 20:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762805020; cv=fail; b=AkftLYh/DGM9pQfFbkpfgbkFNRvdTP1gx8cN9Q1MzYHxMxPiwSx5ra9VAN774dxA7RGdvCXuWWCnfojZ3qLeriQXpcNADyvy+gVmQwZl/doQ1Vmu0aXw8MUQGSHmN3nEMYcUSAlgFZg9yXF0jrTc6NWVOBPk7y1ZppmaMzqD7w4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762805020; c=relaxed/simple;
	bh=VuBCBV/FVjMcR7ZOYwAYtlSkXYPneVaSTXFKauz2gfc=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=I6NtqnuVu5ByF3rX5IQ4fLtXVTwumLWIPY+fjcfzKecpyxsVP/yrPwX5/8cofLYcxkwPRAGwjraBrVePkCHnqPngN/oCLenEemB+Q1AeiMJBQlw2Tyv52WCoUh2BXhMI+2EmgdVxPA3F1Lfwx/HZXi46A9qZ52vFMAVfk1naO80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iRfsVFhW; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAEUvuj006823;
	Mon, 10 Nov 2025 20:03:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=VuBCBV/FVjMcR7ZOYwAYtlSkXYPneVaSTXFKauz2gfc=; b=iRfsVFhW
	Y8QtP/etTVeXWfs2Fltmg7pS2BBfeuN7FLdyitlaQGjdfTwHwFXHmo7hy3Pakklr
	FWPwB+hXgd1nZBM+UC6UdfxA4w/PgQXmKQFLuYhDYVP0pu39q01Z95Yju704Ibn7
	2hUaYg93zropMKTMYs4T/oJzVWBjry3WtlwmP0J/cvavKdTBaVhuvlq4aY/j+gEZ
	obmLWmxZRZHtBQIex4WmzQI7w3JRo3uT89mAcV6DSciD8uLZJVN27PtYMzZ+h4n1
	7/IfLQ+cmzFylmvufQEyGD1LXKcPIG/+ICJsGVT/BgouEQuTwLebjCgKdM0ANXBz
	V7Ufnq+dIK4SXQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5cj0ssp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 20:03:32 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AAK0UWM007845;
	Mon, 10 Nov 2025 20:03:31 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012008.outbound.protection.outlook.com [52.101.43.8])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5cj0ssj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 20:03:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tjCOeK1riV9sVY25CPD4RTYTGHDA8hm+IA2dPRtTMMj5ScC6hme0tsU5vw4bn/mm5b98wB0RYxmeA6V+mnyKFo51m8VfaakZx7t7ppTobfuuF1Qr6cHMDIxkTk6yHcfTSesYNLBShAZyob3kLoo7GR48lXP9tIhr4dTy/GtR/WDqIQmC74LWsk0qNCKdKQcEi6ZUIffJF7wCPcNo2o4r2biOZ5gtqJr87bOVgi5ahPh5K4GGLhfla4tIaYjGixvN0wh6saGTUnOSK32741FNRtaANIxD2F1N51zTP4cco8d97OBQCq1sxNpzSXRy01WuL67tXo3DNZeUM8IN1b9YlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VuBCBV/FVjMcR7ZOYwAYtlSkXYPneVaSTXFKauz2gfc=;
 b=uOrBfXXgKjYQHamRHrx6Ko4LVpMmWnbBXqDtIv9MVKIqNkHJNmGo8Da4K1Kg43RsxpR1D/TtaMOEBB3fCgeisBRur7gFl6uIqfbU9tyxjNX+5KG1PrCkTzwDl3wkHY+4Wt0ZzovmHizm9nbDjOmKQDMxNZbmu/3Yt9uf1bP92YqusnKyk9SI7l79Dyn4aKdD8UyRIJubXhIkLZ75pmbXHbW/gQEUkQZkgr2XnrGlacPIWsuZ/GUhj2iiFB+jLK9BdYEJqcboJpdAmY0R6OEW7oTX5N3NMDk6LaQgE/CHGioEVkHdRNDS7HuaLSs4onla+HmAen1iCkzfWLa9oap2+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by LV8PR15MB6512.namprd15.prod.outlook.com (2603:10b6:408:1ea::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Mon, 10 Nov
 2025 20:03:26 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 20:03:26 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Gregory Farnum <gfarnum@redhat.com>
CC: Xiubo Li <xiubli@redhat.com>,
        "justinstitt@google.com"
	<justinstitt@google.com>,
        "andriy.shevchenko@linux.intel.com"
	<andriy.shevchenko@linux.intel.com>,
        "llvm@lists.linux.dev"
	<llvm@lists.linux.dev>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "morbo@google.com" <morbo@google.com>,
        "idryomov@gmail.com"
	<idryomov@gmail.com>,
        "nick.desaulniers+lkml@gmail.com"
	<nick.desaulniers+lkml@gmail.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [PATCH v1 1/1] ceph: Amend checking to fix `make
 W=1` build breakage
Thread-Index: AQHcUnsZwcN+bEDhFkO0820vr4BqvrTsU3iAgAAAyQCAAADtgA==
Date: Mon, 10 Nov 2025 20:03:26 +0000
Message-ID: <8de7721da35000ff0f41b0b024a998dfecf9ef90.camel@ibm.com>
References: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
	 <9f7339a71c281e9f9e5b1ff34f7c277f62c89a69.camel@ibm.com>
	 <CAJ4mKGYPoxPS62yFigmqFPPTHOSwgtj+WKwEtdpNGsu3BJya3w@mail.gmail.com>
	 <01593a9ca971421a39c483819855d41c251da905.camel@ibm.com>
	 <CAJ4mKGbrXjC=kX5YDsX=RZUw6mK0PVPiinVsujhp+XfPVsrVVg@mail.gmail.com>
In-Reply-To:
 <CAJ4mKGbrXjC=kX5YDsX=RZUw6mK0PVPiinVsujhp+XfPVsrVVg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|LV8PR15MB6512:EE_
x-ms-office365-filtering-correlation-id: 30a073f8-5b4b-47c7-85e9-08de209435b6
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?a015Q3JhLzlFZ002R2lPSExPbDdNUVJOKzlzSm16NXdVSXhGRVBxK1YrdHRB?=
 =?utf-8?B?cWgzblRzUWxnSXFKZUUzMy9HTVpQU1ZTcU1RTUFXWlYveFVqOHFvTnlnMURi?=
 =?utf-8?B?UnFBS1cwN1NZSnJiTHNsblExUFFyWDFCNVFVdUtwTnc5NFc3eHNZeW1XSHJu?=
 =?utf-8?B?VlJHa2RhdTZqeVdYK1dMcUNBWmxBRHdSWmpwTWVMSVljeHlFQm9xWHNRWldk?=
 =?utf-8?B?SHBsUDZDWk4yRk1hbG1EaU82Z0tzbkF6TkhhOUpTLzdYL1lsWWRKV3V4Y3NN?=
 =?utf-8?B?QUVSbWJvZkVvTWZ0bGRsT3RIMEEvTjJ6L2VIVEpjTm96UEFrbjE3TGZRL0Ix?=
 =?utf-8?B?NExMMTVrRHBzZnV1cGNrOFB2OEdTdVUvQ0VnRnNTWUVUbW1SYTV0SHo3QW8r?=
 =?utf-8?B?dUcySi9lb1VrYmVtVXJKSEpUYmtPNnpCUTJKSXlWbiszRGN2K04yZi9UV3Fs?=
 =?utf-8?B?TERXMkZiNTlINjJnTW5rTDVyK0R1UDl0TlQ3YS9sY0QrV3FBcEVOWEZ3K2hR?=
 =?utf-8?B?R3FHMmg2YjYySjJDZTh1d2dqL3JyZ3lJTXpqeWZVRGFOSXA1Y2IyRzNHU3M2?=
 =?utf-8?B?eFF1aG5nL0owaHdHblFUaFI3RDlZTHJ0dXJXejhqSSs5eTNXWnYyUTFrb0pi?=
 =?utf-8?B?ejFqaVJ0Nmx5TVZYU3J3YWhnbnppZ1NHUzJZdE1wNGw3ZzBDRndwc3h5R1Zi?=
 =?utf-8?B?a2lHbGdMb1poVms5ZEt5b0szcFZSS0xTa3lCajVyRzZqL1Vud1Z5NjMrZlh6?=
 =?utf-8?B?dERkVDM4MHZQeEJnOHFUaXlZM0pYUlBHN0pIT2FyK3RwaVBKU1pWYTNRV3Rr?=
 =?utf-8?B?eDlVekFIQzc4bVJQcEtYbkx0VnoxemxsdmlBaUVuMngrYUhhOE5IY3d3bHly?=
 =?utf-8?B?RlI5Tk92aG91TUluU0NqWHpKQi9aWTVURjQ1TnREZ25SZGNhaEMyNCtyOUxV?=
 =?utf-8?B?MldTUTdKYzl4RU0yV1ZvMDJ3ZUhqWDZqOEZpaDRQKzR0eUFvTlNyd3hwRnVR?=
 =?utf-8?B?Rm1OQnJKZGc0WENYN2gvWmtSRFZCOFBUT0tRc2FHSDA4TEJBMmxIdzF1U3Za?=
 =?utf-8?B?WXlSVjZ5VjNReWZaRVhRVW00NDFsODM4dk9JUlhWODBwTDVnTkJQZFFpaGNy?=
 =?utf-8?B?RG9hRVpPZHJuNzN5OWNYVHA5K3FhU2t0K1lPbHR6Q1NkSzgrQVpoS0E0dzhi?=
 =?utf-8?B?c0JOVWpKNUNua081VTdLdEFtLzQxOWdFMFVoSXZjVDJNYXYxU09TcWliUjJj?=
 =?utf-8?B?MXJ5dFNzeTByeUFQVWZNRkJxSEVxbGh6WFl6SDBxbFp4Ty93ZjZuK3pxdEwv?=
 =?utf-8?B?SkRGRFFmL1dSdjIzYXF3U2lnRW5JTkMxZlhsb1pWVG1lWnhFT1pleWMrY3h4?=
 =?utf-8?B?a0JxS1hiRjZNbHFPdzlZd0xyM1EwL1Vab3ZuRFFzbXhySnNqOWdFSWdtOXRh?=
 =?utf-8?B?Z2FPNGhPN0RyYk5YUVB0ak9PMXRsbFBEWnZ1ZDhrdjVmUjdaVjJNQkl3MnVR?=
 =?utf-8?B?NzQ1Y29STlZuRWVSNlV0Q3hsRndFUm9YT082V1gvM0YwNUJyT2FQWlNxREQ4?=
 =?utf-8?B?Q3grdlEwVjVkSStHWHN0N05ESnczWFQ1RmhvK2pETTlRNXpzQWhYUTlBUTFG?=
 =?utf-8?B?a0VqTFZiRldWSzVDR2lhZkphMmNIL0NYbHFFcGZhOExtdWNVS2dqYzFKZE4w?=
 =?utf-8?B?N2NsWFBoREZPNEwxL01wSEsrNVZMQ2NTV0hPdmd1NEZxYWs4OGZ1NitwTDVC?=
 =?utf-8?B?Q2lwK3FKNGZ3SU9sVVJVanV5TmtlaGMyNTdNWUNZNnpnMmdBcUxtekR3c3g4?=
 =?utf-8?B?djNHc2FwMkgveG1ueUNzcVYzZGlGcWI3NXFXWk5xNlZmVnZYMUMvZm5aM2hR?=
 =?utf-8?B?MmxpMURrb1FNZm9vcWxqQUcvd0VCNjZHd3AybVQ5dThrY0NURWo4UWJvLzFQ?=
 =?utf-8?B?SVFaNU9OZWZ1ZERLTE00c1lHSGtCY3gwQUEreFBaR0NVKzRWOC85UzBlZ25G?=
 =?utf-8?B?T0JVZVZBUldRUTR2ZkM2VHZueDV1M0RBd3NkWkJLN2YvWjNIVE1XNytCV29O?=
 =?utf-8?Q?lXzopc?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bnZIMHJFVXlqZno3R1FnR0I1U0t2NU9tTm9LMHB3QktaVHFxZXdpSy9vQzVE?=
 =?utf-8?B?VTlqTWw4UGhkYXZTR25GTDBRMm9LQm9KdzBVem1XQzByVVBuR3lYSmdLNzJM?=
 =?utf-8?B?RDVVRHp1R0tVZXZIeWdZczRYOEZoN0RaSGltcWtGVmYxVzh6MVIwMmlTTDFl?=
 =?utf-8?B?YjZnSUU1WnhZN3NoOVkrZ2wxM3RPZVM3MGVTc29aeGFpLzR5RmR4TldnTGFk?=
 =?utf-8?B?NEpPTVBtaGdsVDYwY01IOEp2cm41SVhlSEtOWVVmSEIraGJrS2IvbjRnTW5W?=
 =?utf-8?B?ZXBCNEJxTUZoWnlMUFc4M0VYa1NocmtxbGxESXBDYnJsWW93UE55blQ4dDZP?=
 =?utf-8?B?M3hGVGVOZG00U0dxT1lzaDRoQnlwUGI4NytzbXpoaEVTcWNoUzNabExNYWRr?=
 =?utf-8?B?NFhWeDEwVUlGa05Fd2pvSUVDdGtxaVpzVk15bE9USm1LSEFUeEhKYkI5amVp?=
 =?utf-8?B?cUduM2JXakY3bTJFcW0xNm16K0ErMEZXUEhLaTYvckppaE5FNEtVeXVuM1g2?=
 =?utf-8?B?Ujl3TWhHRFQzbmowMElaVytqYlZITnFRL1NtNnRrYnZpZSsxdWdacVl3SkdM?=
 =?utf-8?B?ZGRjUUJuZXhZUTJWQ1JoOXVtU01TUU43VjM0a05YT280MmU3cXpCK2h6NFJP?=
 =?utf-8?B?WVJrOUhyTlVFcmxTWnRzbldBWjBpOGJWNnNzSVd2c1NFMUdka0k0WjAyQ2Zj?=
 =?utf-8?B?T2ZPYko4a0dYZ2pTditQUWs5UnZtN0RnaEx0WFhxVTlwUnRRUUpWdVFrb1Va?=
 =?utf-8?B?S2N4UW5LbjduNGIySnl1ajJvZ3hyZE4xa0tob1VOZFFnYWtpeGp4M3VpbE1D?=
 =?utf-8?B?elNPMnFHSnFjUTd6ZUN0VUNkNThlMk5aTmV4VlgrNHVMQktSSnBIalMwVEhJ?=
 =?utf-8?B?bEV2R0J0YytHa2JqdFBTeXdHdVk1VHJxUCs1SDRETnFOWlVYR203MmkrZ2wz?=
 =?utf-8?B?ekN0L0VlMjVhUHEvNjU5UnFzajlQMDBTdzk5YWZERGJpUHhZZ2xjd2RVcTFD?=
 =?utf-8?B?VkFsNGVlMmlMRmVqSERTbHQvaVVmakNYTTdQcUN3YXowc3RJdE9tRk1NMTlF?=
 =?utf-8?B?TWpGRkNQb0dtcnJvek9FU2RCRTdNdktvT3pteFFWZFF1QndVUzUydy9rK1BF?=
 =?utf-8?B?ZWNOdTlDcFRFRm12TGdXbUNIUnBqczZ2Y3FEM2ZiU05CWjhTeHU0dFVPbFFX?=
 =?utf-8?B?S1RjM1hqUlFlektqMW15emxSSUY5STRyQVUxaDl4REZvd3VyR1NvMkFQVHBt?=
 =?utf-8?B?bUFnYnZHQWpHUERsa2NwL1RnMEVGOW5pRW4xVXBMV2tqU0x6RHRtZFVxNHlQ?=
 =?utf-8?B?L1VBNmRrUlI5WTc3cDVibnJ0SktvRGpvWFpab3REV1JEUGVkNVh1cUY0QmJC?=
 =?utf-8?B?ajcvMkk0cjFDQjEvditsOHFmSzNDUnl4THhublNqWHFvZS9rQmo0RThHaHFD?=
 =?utf-8?B?L1NwaGpKTHNBdnhTbnlGMm9INFo0RVlPbms1ajQwUm9jTStXL2F6T1lOWUR4?=
 =?utf-8?B?TVYwNjNQNHM0MzFSM2VuUi9tNjNLN0hhZ0t4OW5aQm1UVkM5VHNQOGN1cHkv?=
 =?utf-8?B?M1E2RzZHajYwVlJlZS9VdjBKdFFQbmNKVDc5cDEyaW53a2xZMER3QjV4ejQy?=
 =?utf-8?B?MldGalhoakJTOUFsNkpnNE5nZ0tNZ2ZMcFdFNkpGVnJ5R3hEWWVzYjZCL0ox?=
 =?utf-8?B?ZDlYOXFrcHJmamJ6SENLcDVLcjllZFpwQ1lFZVpmZGhlaGQ0c0lYbXNiRFpk?=
 =?utf-8?B?VE5Ta0xiZUR4MEZSYlZ5N0lqOU0vOFFBaWh2RE1PNDVBdHJ4OU1TSGpoaG1s?=
 =?utf-8?B?eWZwNGVzUDVSbXBvNlJ6QTdnUmhVLy9GNWhIZWFJOVoxb1AwN292Szl5Rmw0?=
 =?utf-8?B?clNlKzJZY0FhZHZsNTdUb1NXVVA3VmUwZmJFaU5nZHZucjlDMWh3SzUzS0Fm?=
 =?utf-8?B?U2YxOTJ6YTdpVVRicEowWGtOc1ZXZmd3cFIzWC9ua2wvU0tGSmNiN2k2VmZL?=
 =?utf-8?B?ZXhDL09LZHBHY1IyNXBEempqcTlnUkdPa29mRlBQS0RydlN1UC85enZNcktJ?=
 =?utf-8?B?U1Y5Z1haN3pnYnV5Mk1ac1V0Q1Myclc3bHB6N084MDhqMWYxMDg5YWE3RXFC?=
 =?utf-8?B?ZDdvVldTRWlyWm9mN082bkhEa2s3S3E0MmVhdHczVFBkSjNKTkhuMXQwUkNK?=
 =?utf-8?Q?F9pXPAh+7eWlrm9QfSi2DS4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8862D5056373084FA7119AD880BF6371@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a073f8-5b4b-47c7-85e9-08de209435b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2025 20:03:26.1538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vtS1i+6fgdnO4d3CCxRib6UQY9x6oiVw0b1kJv8lTBrCCw37Xq5z6BpFTW7vjARo04GQr8GS0AlvcphodcdIAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR15MB6512
X-Authority-Analysis: v=2.4 cv=Ss+dKfO0 c=1 sm=1 tr=0 ts=69124514 cx=c_pps
 a=cGIxddJ9FFYnYBVvYRB3uQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=QyXUC8HyAAAA:8
 a=_hv2dD6pUnFN-eyhUAYA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5NSBTYWx0ZWRfX8tdKXp1t5Nn2
 c100JxzPkg2HrlZkwCScVUOXtdjSc32xl1d7ORcnkoeuQGeufb6h5vS7cmKgGLUNHKdmWLkSCh8
 rk5txqOzh2v1nzhVJjXKjZljECCVFjqF/tST340vZTpUvpn150Ez9HK2MJzM3J9IdxN0Vql8vDc
 ejhUcuXljgeAFnyb+C5L1df/1U1lYJMW+/Lnuj69JVg25KJsXQksUaAH24xWXfNwfulNhoou7yR
 BVKbLectA/2z2LRiKSY7Z5voIB0UrP6cZ4ss0NIcA4wM363vtJAwelm++Hx+/DUkSjJ9iVQ97oX
 PpbNHcaYdjaL7DR6ajKhSEJ9nqeMyx95Tce3uWYaEplSqD0E9ZsvEQ9VqjM/EULeUuOyNbzBnyn
 w324K+v/QpQP9z4xYxKAHpZ5DS8F0w==
X-Proofpoint-GUID: 7w0JUdIkDcfg74TZPwnvJTrf2bZs-l0C
X-Proofpoint-ORIG-GUID: YTbelCkz-dIlMDi-KCjvyAwuC7RTvJ4A
Subject: RE: [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build
 breakage
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080095

T24gTW9uLCAyMDI1LTExLTEwIGF0IDEyOjAwIC0wODAwLCBHcmVnb3J5IEZhcm51bSB3cm90ZToN
Cj4gT24gTW9uLCBOb3YgMTAsIDIwMjUgYXQgMTE6NTfigK9BTSBWaWFjaGVzbGF2IER1YmV5a28N
Cj4gPFNsYXZhLkR1YmV5a29AaWJtLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gTW9uLCAyMDI1
LTExLTEwIGF0IDExOjQ4IC0wODAwLCBHcmVnb3J5IEZhcm51bSB3cm90ZToNCj4gPiA+IE9uIE1v
biwgTm92IDEwLCAyMDI1IGF0IDExOjQy4oCvQU0gVmlhY2hlc2xhdiBEdWJleWtvDQo+ID4gPiA8
U2xhdmEuRHViZXlrb0BpYm0uY29tPiB3cm90ZToNCj4gPiA+ID4gDQo+ID4gPiA+IE9uIE1vbiwg
MjAyNS0xMS0xMCBhdCAxNTo0NCArMDEwMCwgQW5keSBTaGV2Y2hlbmtvIHdyb3RlOg0KPiA+ID4g
PiA+IEluIGEgZmV3IGNhc2VzIHRoZSBjb2RlIGNvbXBhcmVzIDMyLWJpdCB2YWx1ZSB0byBhIFNJ
WkVfTUFYIGRlcml2ZWQNCj4gPiA+ID4gPiBjb25zdGFudCB3aGljaCBpcyBtdWNoIGhpZ2hlciB0
aGFuIHRoYXQgdmFsdWUgb24gNjQtYml0IHBsYXRmb3JtcywNCj4gPiA+ID4gPiBDbGFuZywgaW4g
cGFydGljdWxhciwgaXMgbm90IGhhcHB5IGFib3V0IHRoaXMNCj4gPiA+ID4gPiANCj4gPiA+ID4g
PiBmcy9jZXBoL3NuYXAuYzozNzc6MTA6IGVycm9yOiByZXN1bHQgb2YgY29tcGFyaXNvbiBvZiBj
b25zdGFudCAyMzA1ODQzMDA5MjEzNjkzOTQ4IHdpdGggZXhwcmVzc2lvbiBvZiB0eXBlICd1MzIn
IChha2EgJ3Vuc2lnbmVkIGludCcpIGlzIGFsd2F5cyBmYWxzZSBbLVdlcnJvciwtV3RhdXRvbG9n
aWNhbC1jb25zdGFudC1vdXQtb2YtcmFuZ2UtY29tcGFyZV0NCj4gPiA+ID4gPiAgIDM3NyB8ICAg
ICAgICAgaWYgKG51bSA+IChTSVpFX01BWCAtIHNpemVvZigqc25hcGMpKSAvIHNpemVvZih1NjQp
KQ0KPiA+ID4gPiA+ICAgICAgIHwgICAgICAgICAgICAgfn5+IF4gfn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBGaXggdGhpcyBi
eSBjYXN0aW5nIHRvIHNpemVfdC4gTm90ZSwgdGhhdCBwb3NzaWJsZSByZXBsYWNlbWVudCBvZiBT
SVpFX01BWA0KPiA+ID4gPiA+IGJ5IFUzMl9NQVggbWF5IGxlYWQgdG8gdGhlIGJlaGF2aW91ciBj
aGFuZ2VzIG9uIHRoZSBjb3JuZXIgY2FzZXMuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gU2lnbmVk
LW9mZi1ieTogQW5keSBTaGV2Y2hlbmtvIDxhbmRyaXkuc2hldmNoZW5rb0BsaW51eC5pbnRlbC5j
b20+DQo+ID4gPiA+ID4gLS0tDQo+ID4gPiA+ID4gIGZzL2NlcGgvc25hcC5jIHwgMiArLQ0KPiA+
ID4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4g
PiA+ID4gPiANCj4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvZnMvY2VwaC9zbmFwLmMgYi9mcy9jZXBo
L3NuYXAuYw0KPiA+ID4gPiA+IGluZGV4IGM2NWYyYjIwMmIyYi4uNTIxNTA3ZWE4MjYwIDEwMDY0
NA0KPiA+ID4gPiA+IC0tLSBhL2ZzL2NlcGgvc25hcC5jDQo+ID4gPiA+ID4gKysrIGIvZnMvY2Vw
aC9zbmFwLmMNCj4gPiA+ID4gPiBAQCAtMzc0LDcgKzM3NCw3IEBAIHN0YXRpYyBpbnQgYnVpbGRf
c25hcF9jb250ZXh0KHN0cnVjdCBjZXBoX21kc19jbGllbnQgKm1kc2MsDQo+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gICAgICAgLyogYWxsb2MgbmV3IHNuYXAgY29udGV4dCAqLw0KPiA+ID4gPiA+ICAg
ICAgIGVyciA9IC1FTk9NRU07DQo+ID4gPiA+ID4gLSAgICAgaWYgKG51bSA+IChTSVpFX01BWCAt
IHNpemVvZigqc25hcGMpKSAvIHNpemVvZih1NjQpKQ0KPiA+ID4gPiA+ICsgICAgIGlmICgoc2l6
ZV90KW51bSA+IChTSVpFX01BWCAtIHNpemVvZigqc25hcGMpKSAvIHNpemVvZih1NjQpKQ0KPiA+
ID4gPiANCj4gPiA+ID4gVGhlIHNhbWUgcXVlc3Rpb24gaXMgaGVyZS4gRG9lcyBpdCBtYWtlcyBz
ZW5zZSB0byBkZWNsYXJlIG51bSBhcyBzaXplX3Q/IENvdWxkDQo+ID4gPiA+IGl0IGJlIG1vcmUg
Y2xlYW4gc29sdXRpb24/IE9yIGNvdWxkIGl0IGludHJvZHVjZSBhbm90aGVyIHdhcm5pbmdzL2Vy
cm9ycz8NCj4gPiA+IA0KPiA+ID4gR2l2ZW4gdGhhdCB0aGUgbnVtYmVyIG9mIHNuYXBzIGlzIGNv
bnN0cmFpbmVkIG92ZXIgdGhlIHdpcmUgYXMgYQ0KPiA+ID4gMzItYml0IGludGVnZXIsIHlvdSBw
cm9iYWJseSB3YW50IHRvIGtlZXAgdGhhdCBtYXBwaW5nLi4uKFRob3VnaCBJDQo+ID4gPiBndWVz
cyBpdCdzIHRoZSBzdW0gb2YgdHdvIDMyLWJpdCBpbnRlZ2VycyB3aGljaCB0ZWNobmljYWxseSBj
b3VsZA0KPiA+ID4gb3ZlcmZsb3csIGFuZCBJJ20gbm90IHN1cmUgd2hhdCBoYXBwZW5zIGlmIHlv
dSBhY3R1YWxseSBoaXQgdGhvc2UNCj4gPiA+IGJvdW5kYXJpZXMgb24gdGhlIHNlcnZlciDigJQg
YnV0IG5vYm9keSBnZW5lcmF0ZXMgc25hcHNob3RzIG9uIHRoZSBzYW1lDQo+ID4gPiBmaWxlIGlu
IHRoYXQgcXVhbnRpdHkpLg0KPiA+ID4gDQo+ID4gPiBBbGwgdGhhdCBzYWlkLCBpdCdkIGJlIGtp
bmQgb2YgbmljZSBpZiB3ZSBjb3VsZCBqdXN0IGFubm90YXRlIGZvcg0KPiA+ID4gY2xhbmcgdGhh
dCB3ZSBhcmUgcGVyZmVjdGx5IGhhcHB5IGZvciB0aGUgZXZhbHVhdGlvbiB0byBhbHdheXMgYmUg
dHJ1ZQ0KPiA+ID4gb24gYSA2NC1iaXQgYXJjaGl0ZWN0dXJlIChhcyBzbmFwaWRzIGFyZSA2NCBi
aXRzLCB3ZSB3aWxsIGFsd2F5cyBiZQ0KPiA+ID4gYWJsZSB0byBjb3VudCB0aGVtKS4NCj4gPiAN
Cj4gPiBTbywgYXJlIHlvdSBzdWdnZXN0aW5nIHRvIGRlY2xhcmUgbnVtIGFzIHU2NCBoZXJlPyBB
bSBJIGNvcnJlY3Q/DQo+IA0KPiBXaGF0PyBObywgdGhlIHdob2xlIHBvaW50IG9mIHRoaXMgYmxv
Y2sgaXMgY2hlY2tpbmcgdGhhdCBpdCBjYW4gdHJhY2sNCj4gYWxsIHRoZSBzbmFwc2hvdHMgYW5k
IGFsbG9jYXRlIHRoZW0gKG9uIGEgPDMyLWJpdCBhcmNoaXRlY3R1cmUsIHdoaWNoDQo+IGFyZSB0
aGUgb25seSBvbmVzIGF0IHJpc2spLCBpc24ndCBpdD8NCg0KT0suIFNvLCB3aGF0IGlzIHlvdXIg
cG9pbnQ/IEFyZSB3ZSB0YWtpbmcgdGhlIHBhdGNoIGFzIGl0IGlzPyBPciBkbyB3ZSBuZWVkIHRv
DQptYWtlIHNvbWUgbW9kaWZpY2F0aW9ucz8NCg0KVGhhbmtzLA0KU2xhdmEuDQo=

