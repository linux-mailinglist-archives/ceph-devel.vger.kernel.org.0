Return-Path: <ceph-devel+bounces-3978-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DFFDC4919B
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 20:37:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 64730343A41
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 19:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CC8C335543;
	Mon, 10 Nov 2025 19:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i0JKq5w7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57D032E124;
	Mon, 10 Nov 2025 19:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762803445; cv=fail; b=ajFNLGRllLP5Om7Tabsv3hUdOULGCE0XtJJSKYODj+nyJi+3WroDrPJnXSTs5WHPdjzbAZ5YBR5h+7fkf3nx4XP377Yvgr/nDJaLfdWOGdVzadTAqWOUx8Flr9sfCrCEoGiXqvuOjWI0EnHwMIiEcPXNEzIzkR++F19I7oLkvgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762803445; c=relaxed/simple;
	bh=LPtwn3Z3MKV0Vs8zjLYHZslaUcMmGA8wxWzuKQ2AGA4=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=FDdAj43YIiBJxnDO+lWNJRKriflfPkWzqg6gans7UTIplTpUj412VKHLkh/UDFe57gmN5vS8mk/KlDEJAANRi+Jr+IbsvTSexZSNmJ2DliMM9mWfQfej2nz1pOA0RjiLL4T1w4sRdl6gyndxElYdqWiTsi7MYur/duOhsBhd9F4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=i0JKq5w7; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AADrOIj002505;
	Mon, 10 Nov 2025 19:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=LPtwn3Z3MKV0Vs8zjLYHZslaUcMmGA8wxWzuKQ2AGA4=; b=i0JKq5w7
	koLdfezGPqMAYddVZvpJfeqQm4wwFhe2jj1vZ9psZuQlWsfy4N9tNAdg8OrjdmBX
	coz+O/7tjT9+VYf7f9s/1S+6KAkgvrLltswf5Eel4nPK4242Lk3TQgc9nYYB9h15
	bYx5xXsKriWvcMs8V75SVfHEAXVSzN4z0FerLi+wf5A8Pqj72PvdD5wsB1WrFeg0
	5sFlaT44Dk4KI78J0ui65lChI3DZhaU8hPK9bvr8DrOOwriiMugx5DT5RJdy8WDi
	IRhDwkmGbsrfbeG5ZyQDpud7Nd2iSh/FMG+GK6oT9TNgYHTjIY5wiB7nlBMzMz/E
	2A2sNO5eAm2ApQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5cj0q2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 19:37:16 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AAJVlSo015666;
	Mon, 10 Nov 2025 19:37:15 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011024.outbound.protection.outlook.com [40.107.208.24])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5cj0q27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 19:37:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T4r0u5y5TMNTQHxe4OwmxGlFlPRu0piAk6bfHIH9tRiSKgLvGeqoxlLBoyqZoK0Qf+K1K3tgOwa+gnf65Q+Bh/CxFbOA0KYQeO4Z4ap0P5DAvvcr2mB4Zfv3cdTrKUQw64Fq/byfpYZVc7NMauCxWuZ4seukVktjeQDB7FIBX5hBuWvJch3LI1tZTYNwvH8BK80DK3LMbLaQvVBkHer2liRCUB5tSJpviBbrYHk+CLt302+c+3OCObQnhUk21vXOCcDnpUCIZ8aTJKYM8YGrF8EtShp0uo9eis2hQNLjikCtGcfe+cLuHDi1qjPVUkVah+xq4SRZaK1nUCF+f4h/MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LPtwn3Z3MKV0Vs8zjLYHZslaUcMmGA8wxWzuKQ2AGA4=;
 b=mduFn0wvUTxRAe86gyWXnGGdCSED3/6jsIuEBjG8dMJkPNW83pEiAKCdn21KW5MvAeg2m4Bh6IqT700jUfINKCpt+cVIuTyPxa1/tanBcyuBF1JbSwX9SnZv9jJB/qDbKA27P62Qe8Y362bQJ+D+OCIzoUboxGl4kM6LARxyHmROQU/5oOEB4IRor9QxVNZ0KYvHxPLSUMJ2KEp4whhihZiok/gBeMdS8XwAI8SEoFtv65tYVYXtw6FmpAOWxcaC5VAxDk0ivONF3iwvUbYvv5RlxKmU+Sr+y1uYCRaXmKLdy4yTC1uh+oOt//gDVc7wld0k2wOq1+fkd/116o76zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB4551.namprd15.prod.outlook.com (2603:10b6:a03:378::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 19:37:13 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 19:37:13 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "nathan@kernel.org" <nathan@kernel.org>,
        "justinstitt@google.com"
	<justinstitt@google.com>,
        Xiubo Li <xiubli@redhat.com>,
        "idryomov@gmail.com"
	<idryomov@gmail.com>,
        "nick.desaulniers+lkml@gmail.com"
	<nick.desaulniers+lkml@gmail.com>,
        "morbo@google.com" <morbo@google.com>
Thread-Topic: [EXTERNAL] [PATCH v1 1/1] ceph: Amend checking to fix `make W=1`
 build breakage
Thread-Index: AQHcUlDuzQgMVFWVSUev6uW/gd4f0bTsTjAA
Date: Mon, 10 Nov 2025 19:37:13 +0000
Message-ID: <9f7339a71c281e9f9e5b1ff34f7c277f62c89a69.camel@ibm.com>
References: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB4551:EE_
x-ms-office365-filtering-correlation-id: 659b3199-b0d1-4219-fc55-08de20908c3b
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|7416014|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SGFCbjhScEhlQy9mbzdIejNIYmhyN3QwZm0xVmZDc2xtM2dxQTNtS3llTlJP?=
 =?utf-8?B?Y0xIb2x5d0NObzRXVTJMS1Vtc2p5K2x2NnNVRmJQZDVWL08xMjBPUmJKT2lv?=
 =?utf-8?B?Rm9VeHY2WGlFcTBJaGxuTUtFcHhYbXFhdW9TNnVoSUdwL296TldlS1Uxcy9G?=
 =?utf-8?B?YXpOTEdYNWplR3UvTEc0K2o5UHQ1cGRPL001a2xoQklCWS95TnladkQzRE1u?=
 =?utf-8?B?RHhWNHlaQ1RlRndqRnFaZ2Z6cTNLazlmbHdzdTNvZEhQN2YwNVUxNDdZQTAv?=
 =?utf-8?B?L3ZLeGl5b3hhZXNaUjQ2VmlWYWV3T2dUTU5rM2ZZcVZQcXRmaWJSL0VMY2hi?=
 =?utf-8?B?allCZGpCVVErbzQ2OGQ4ZGV2UDhKWllXNGRacEUrMjdORWFlTWJKQzg0QmpR?=
 =?utf-8?B?YzF6d3R6QlRIOHJjcnFyY1FCM1B4WmRxcXBzTHdBVG5OdjNBZXIxeFV5cnhZ?=
 =?utf-8?B?akZ1U1NTZmd4Qmp0bFdrQVQzNHFOeFkyL25JdWV5OENUTEE3WitYYlF5bHpI?=
 =?utf-8?B?V2FUb1JTT3V3RTM2K2xmbk1kd01CR0JPcHBXbkI4bS9mWjJrWWZDSVkvU1Yy?=
 =?utf-8?B?bFNKbEI4dkdhbDFmVU5WaWpVNTVHVlNFdmU5M3lvK2Y3ZC84V3ZobTVxM0lY?=
 =?utf-8?B?allSNno1ck5GQlV0K3lPb1ozOXc5bFZURklWUkI2ZG1PWFhrLzFxU2xUQi9z?=
 =?utf-8?B?cHBEdHpSL2xTQ3RPQk52UkhEOGgrVXBNWGZoT0hySUY1dDl5UDk3VnZVUU1K?=
 =?utf-8?B?R1NhMHFtOWVPNUJ2U0dhVjBtcUM2S25SN0E2M2lROWtXamNCWmVXRFNtNDFM?=
 =?utf-8?B?WkJrRFBIY1VMK1lod01WeFdlck1vaHFKWU1mT3hSZDFJaG5iUjRUSVBQVnE3?=
 =?utf-8?B?MkNNczNqY1lXdSttNFZuNWVzb1Vkc0dWbGNrYjRsblIrUzJ5RUIzdHBud2hY?=
 =?utf-8?B?TmFXdHZUd0JjNFhKaVl4R0hXMElxNXZCSDNFQWtPZlRNQXBlVEhya0NKWCs5?=
 =?utf-8?B?eEtDRDNBYTFDS3c2Wk5Ec1Q0MlVrZ0JYcHhIaVhGak1ZNUUwYXlCeEFadnVv?=
 =?utf-8?B?MmN1WTg0RlpVdVpUVmxPb2Q3TVJ1NXZyd3A1Mk1CblpjMW5pSG4rZk92ZnJa?=
 =?utf-8?B?UTk0eUwzQk8vQU84N0lHc2VJWm1tNU9XRzVFemJFZTFZWkR6MGpJY0x4NVM4?=
 =?utf-8?B?RHN3d1RENFRQSVlvQkZ5MmZMNFo3dkFzT0VKS2xtUmU0dGtySFNLL2VRUXJB?=
 =?utf-8?B?V2FwRzlFek5Jc21ZVHlka0lEY3pubCtlVE5XQkVNOTE0T3poUG1raitYbG5W?=
 =?utf-8?B?bmlRcDBUZkhSQThtMFhUSDZIY0xsVi8rZHVvMEZsYzFmNkFld3Q1WjRrNlVu?=
 =?utf-8?B?TUZ2Y0FNWGZPck9lOWNqMmx1djltMksxUk8xeUhVa3RIWERJdEd6bDNtNXBq?=
 =?utf-8?B?aFRlZWZjUW11eDNnSDBmcEVWUUgraTlWVmFhNlJlMDh4MzBTTkxYUjhySWpr?=
 =?utf-8?B?SnZwVlhqZ1VFSlBSYkxTQ0xNeVdPMENRMjh1UDVsaDVoa1gydHR3TTBhaGZG?=
 =?utf-8?B?b3BFSm1MRysyNXBhV3EvQ0ZwdEZPN08vNHp6QzBSc0VscFZTZ1h2U1pPeHRU?=
 =?utf-8?B?S2lSdWpQTXZrcCtBZnVoNVB4YkhMU25Fcmpla0UvenhTRkNEMUE3M2ZyOWl5?=
 =?utf-8?B?NVRyVExYTm04TnpTdmlvUmw4dUFGejdtbnIwRGdsMTZKTDliaW0veGIyWVMx?=
 =?utf-8?B?YlY2Vm1oM2FtUmNEZ1pvQndLMmR2K1duZFIraHZSMnF0Tld5ZytjZDRWR3Bl?=
 =?utf-8?B?M0kxblBrMGZwWUdJL0lGcUV4SENQOEt6WW1NaC94MVlyTGpUeHRISG11ZFlG?=
 =?utf-8?B?STlYUUs1aUxISWNtMFpjRUpZVlY5TGcyeWhXcDJEV3FubkwzRWxyT1dpUHRY?=
 =?utf-8?B?bXRMdWRjU2VGcUlvRjJxVXFSTzNrcVBxNFUvMXYrVGFNL29JR1lWclpjM2dp?=
 =?utf-8?B?VkRvRk1xTHMxWldZY2gvMG0yZHdYbk1SVlRodzlvUGJwS0FIMWFnaUZnSFZR?=
 =?utf-8?Q?619hUC?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V1VLMWhlVk9ITldHbjNzd1BpRThXR2h5UStKRzZLRHVoczFYa2s1b05Hb3pl?=
 =?utf-8?B?MkQ5ZURJK0lQZ1Q1d2IwQk8vZU1DQ0N0cmphMlphSXNjWWo1cm43UjRBcitU?=
 =?utf-8?B?MFFyLzZoL3cyTWhIaDA0ZGxrT2N5bUEydzh0cUR0QnFGUFdjU1UxczczeEE0?=
 =?utf-8?B?ZUoySWk1T3BReENKT0tGNXExY0lyVzMwcHd3OHlHZFdUeW9lVGR6WVZ6c1VZ?=
 =?utf-8?B?WEY1MCs0VXNEUWRUSnVDRlNBU1FnSTAxVWNpTGk5WEdSUExieGMyYjlyUW1t?=
 =?utf-8?B?cGpaS0lZNHNZUmJWUy9jcEV3OW9vYWJIdlB4cjZNdXdnMWV2WGU0VVdNWk1E?=
 =?utf-8?B?UFAxVzREL3I0RTBjNjFaT0YxMFlrT3U5TmFmcHJhdzFsaHZmRlFrdVlPZGxK?=
 =?utf-8?B?Mkdxam9tdCsxVTJudEZmcDNqOGFtQ2lJR3czOXdjWTAybnp1RkhCUTduWmR2?=
 =?utf-8?B?Zkc1NXRzV3FHaElvblZlTXhPcTFIYTJ1WldnR3FKaC94RzlJY3FlMjV3SGdl?=
 =?utf-8?B?SitZSFQ2cGx6dFdHdWtycmNNOFExQkFsOWQzZWNLNW1WUUFEYlZxcjd1WFc3?=
 =?utf-8?B?NmxyNmFjMVNaelQyRHdlSnIvd3YvNVhNUTF4b0p4SGJYUTRzV2pVSkc2c3Fr?=
 =?utf-8?B?dmgvK0JCTkc5ZzJuWnhOYmdKOUFUd1pjMEUwdDE4dGpvV1Rra2NEZDhXMlBx?=
 =?utf-8?B?MGpaK0FWQkI2QkVueWk3NnMrcVN0UGJiVTVCV0ZKaWI2OHh2Q0FrWmJhNU10?=
 =?utf-8?B?T0tpZWs0SEJ0UG54Q2N2WUROSmt1Mm9xTHAwVGN3Zmg3aGswRkpWVUNadzRr?=
 =?utf-8?B?ZkprYzlsZGlQaHJCMzRTd3IvMmtXUmdrd3Y1dW90bnVkTTk2T3NYWG4wWGR5?=
 =?utf-8?B?Uy9uOWJTc0YzV3VRTytsZlQ2RGFJY05iMFI2ay9sOE9tbE9oZTBrdnIwc01y?=
 =?utf-8?B?TmE4d0xPMGxrTnpXNzZUUGFZNHlVK2Q1QmtiTnhKdmRZalpwZDdKTTN2THFv?=
 =?utf-8?B?VEZNeWFBZkJiU0kyTEs2S3daUWlnUUozS29FZG15bVRSNXpIUUE5TjAwMGVK?=
 =?utf-8?B?SVU3YTNya1Q2OXd3R3NDakdWRG51R2t5RFVOSXJIank0WnVwZjVISWJmVnBK?=
 =?utf-8?B?cTNXaklWYjVPTzkxNno2ZGgydzEvankzZ3kvUVphNzFjbWtLMTMvQmtRUFR2?=
 =?utf-8?B?c1cwUTZENVNkaDN5enBWbG1XNGh4WGlsQnR6dXFOSnFaS3Bqc0xBek41RDNJ?=
 =?utf-8?B?ak1oSXhDNnc5VVpCbTNRN2RONmJ4ZEVGODhlaXpBMnhiTVYyZVpwUFdQeFR4?=
 =?utf-8?B?NFEweTdrOVRPdnREL3ZFeGFub0FaNGk5WmRQVlR2ZmI2bi9kYVF1dDBFNXVv?=
 =?utf-8?B?cHJoWlg5azBDVHkrV25DdGJUd3RudkV5c3dQNjk4MlBJQzVWSXpXMHJnTWRC?=
 =?utf-8?B?RUtpRGdxZ25vQlMwREV1OHhWSThsMStJVkVma0YzUGRGTFM5dE9iQTE3c1Vx?=
 =?utf-8?B?emtMSWV4dGQxL01TZElwa2JOOVhVSW9rLzhOanJkOGM2dkxkUEhEbHN5RnRT?=
 =?utf-8?B?YWVrNTh6OWFJMS92VVVBbWwzL25vMW94VHAxQmxiYUgwZGcxWlliN1BWMGRQ?=
 =?utf-8?B?d1FCT0NBUWQ1K1laR2J6ekFkczZsYmxNN09GWmZ4RTJNYkIzWENhd1U2QUQv?=
 =?utf-8?B?KzNnTFRaM2VoNmtNL1VQK0Z1UlNJOHVsN3UrdUNmbm05Ni9ZNXo5a2Fnd2lv?=
 =?utf-8?B?bmJCYmJ5Y0xsWUhrb0lNTkpoZHdkZEZoR2wrd1BVYTNvTVRyZWtHUWdWM0RU?=
 =?utf-8?B?VE9RRXhGSEVPbktUSzZHcldWa1M5R2ltbnlwZlpmNWVPR1ZWUVBpalhseXhN?=
 =?utf-8?B?bngvbHgzZ1FVVUFBTnV1dE0rWEVNSkhkM0xyNWQ0QUJveHJnVVFranlaUEsy?=
 =?utf-8?B?QStjNzk5bjdiNjhVcUIzc3R2ckM3VHBWUUJ2K3NLNXN6d3R3bm1PV0tjTjBq?=
 =?utf-8?B?RlNaVXN1aG5XREdsV1pWdEpSNnN3Z2pzaVhFczJzdFhVWVdMR1JRVVlJT08v?=
 =?utf-8?B?N2MreEEyZm9WL3NDeS9UdEpVWmVVL0toN1pWVzF5RXRzd1ZEN3RHVGhmd0hL?=
 =?utf-8?B?dkIwaitjZmozcFlrbm5yMitPVUt2eTBBWXJIdDl4eUIxZnQzTWNiMHptU2tp?=
 =?utf-8?Q?tJlBQy6J6lTK+lKzAhItWWE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34109F035949214FA4993AE80390FED2@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 659b3199-b0d1-4219-fc55-08de20908c3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2025 19:37:13.2705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UzoyKzlM5WptZy+1lbi17GAzFBFWGYei/h9CcIpq2qPPGY1DwLYuIhyk33EAE8NzreWWnnJjKf8jfU5xQqitqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4551
X-Authority-Analysis: v=2.4 cv=Ss+dKfO0 c=1 sm=1 tr=0 ts=69123eec cx=c_pps
 a=DvLgf67dpzRpeCMgcWG2JQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=QyXUC8HyAAAA:8
 a=FF_KH25-5A4sr-J8Ev8A:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5NSBTYWx0ZWRfX5Aa8Na0h6vzl
 XJO2vuAmwUuwvuqRIhE1rnlbRmPqFaJrw52wZYs3iKeWruZ19/EfZIGeByS5jel0QwI+I3WaVuX
 nOJUKhlBB4SbsW4nyS1EKFdGBFAFxQRIisTC/WclNJEs9DzRmEfxTjpp0cmP16WDsUZv0fCvVw5
 dBXP2ajxLvIXqCGpmdEcAoaNKrHg2l2zEh81tHokw+d9hQ6JCMEM5GR6GmxPyzw5STbU5yVW2uD
 4aNYBliG7azqBWlE02o2ExtDhMujFvIU99FeJVktmzRwxesXW6SoYH0pHUygL9rIj5J5/qecQev
 iiySsH17uf6ivdKQFq1r5jzTdm2+BQNZY7byPobDsFZLWMzUwpjIq6G9Fmo5BN7/wrkscqvUw/c
 SylUmfvx7cmBWFsBjj48dtbxhTKpCw==
X-Proofpoint-GUID: lHtyJUGYc4pVMvgKitQCdcUX5i6m5uac
X-Proofpoint-ORIG-GUID: rAC5vfuEVIzFPrl2ah6lXDyr1sBqj_oY
Subject: Re:  [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build
 breakage
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080095

T24gTW9uLCAyMDI1LTExLTEwIGF0IDE1OjQ0ICswMTAwLCBBbmR5IFNoZXZjaGVua28gd3JvdGU6
DQo+IEluIGEgZmV3IGNhc2VzIHRoZSBjb2RlIGNvbXBhcmVzIDMyLWJpdCB2YWx1ZSB0byBhIFNJ
WkVfTUFYIGRlcml2ZWQNCj4gY29uc3RhbnQgd2hpY2ggaXMgbXVjaCBoaWdoZXIgdGhhbiB0aGF0
IHZhbHVlIG9uIDY0LWJpdCBwbGF0Zm9ybXMsDQo+IENsYW5nLCBpbiBwYXJ0aWN1bGFyLCBpcyBu
b3QgaGFwcHkgYWJvdXQgdGhpcw0KPiANCj4gZnMvY2VwaC9zbmFwLmM6Mzc3OjEwOiBlcnJvcjog
cmVzdWx0IG9mIGNvbXBhcmlzb24gb2YgY29uc3RhbnQgMjMwNTg0MzAwOTIxMzY5Mzk0OCB3aXRo
IGV4cHJlc3Npb24gb2YgdHlwZSAndTMyJyAoYWthICd1bnNpZ25lZCBpbnQnKSBpcyBhbHdheXMg
ZmFsc2UgWy1XZXJyb3IsLVd0YXV0b2xvZ2ljYWwtY29uc3RhbnQtb3V0LW9mLXJhbmdlLWNvbXBh
cmVdDQo+ICAgMzc3IHwgICAgICAgICBpZiAobnVtID4gKFNJWkVfTUFYIC0gc2l6ZW9mKCpzbmFw
YykpIC8gc2l6ZW9mKHU2NCkpDQo+ICAgICAgIHwgICAgICAgICAgICAgfn5+IF4gfn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4NCj4gDQo+IEZpeCB0aGlzIGJ5IGNhc3Rp
bmcgdG8gc2l6ZV90LiBOb3RlLCB0aGF0IHBvc3NpYmxlIHJlcGxhY2VtZW50IG9mIFNJWkVfTUFY
DQo+IGJ5IFUzMl9NQVggbWF5IGxlYWQgdG8gdGhlIGJlaGF2aW91ciBjaGFuZ2VzIG9uIHRoZSBj
b3JuZXIgY2FzZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbmR5IFNoZXZjaGVua28gPGFuZHJp
eS5zaGV2Y2hlbmtvQGxpbnV4LmludGVsLmNvbT4NCj4gLS0tDQo+ICBmcy9jZXBoL3NuYXAuYyB8
IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2ZzL2NlcGgvc25hcC5jIGIvZnMvY2VwaC9zbmFwLmMNCj4gaW5k
ZXggYzY1ZjJiMjAyYjJiLi41MjE1MDdlYTgyNjAgMTAwNjQ0DQo+IC0tLSBhL2ZzL2NlcGgvc25h
cC5jDQo+ICsrKyBiL2ZzL2NlcGgvc25hcC5jDQo+IEBAIC0zNzQsNyArMzc0LDcgQEAgc3RhdGlj
IGludCBidWlsZF9zbmFwX2NvbnRleHQoc3RydWN0IGNlcGhfbWRzX2NsaWVudCAqbWRzYywNCj4g
IA0KPiAgCS8qIGFsbG9jIG5ldyBzbmFwIGNvbnRleHQgKi8NCj4gIAllcnIgPSAtRU5PTUVNOw0K
PiAtCWlmIChudW0gPiAoU0laRV9NQVggLSBzaXplb2YoKnNuYXBjKSkgLyBzaXplb2YodTY0KSkN
Cj4gKwlpZiAoKHNpemVfdCludW0gPiAoU0laRV9NQVggLSBzaXplb2YoKnNuYXBjKSkgLyBzaXpl
b2YodTY0KSkNCg0KVGhlIHNhbWUgcXVlc3Rpb24gaXMgaGVyZS4gRG9lcyBpdCBtYWtlcyBzZW5z
ZSB0byBkZWNsYXJlIG51bSBhcyBzaXplX3Q/IENvdWxkDQppdCBiZSBtb3JlIGNsZWFuIHNvbHV0
aW9uPyBPciBjb3VsZCBpdCBpbnRyb2R1Y2UgYW5vdGhlciB3YXJuaW5ncy9lcnJvcnM/DQoNClRo
YW5rcywNClNsYXZhLg0KDQo+ICAJCWdvdG8gZmFpbDsNCj4gIAlzbmFwYyA9IGNlcGhfY3JlYXRl
X3NuYXBfY29udGV4dChudW0sIEdGUF9OT0ZTKTsNCj4gIAlpZiAoIXNuYXBjKQ0K

