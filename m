Return-Path: <ceph-devel+bounces-4337-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id BE820D05FDA
	for <lists+ceph-devel@lfdr.de>; Thu, 08 Jan 2026 21:08:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3A2463012E81
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jan 2026 20:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD55232720E;
	Thu,  8 Jan 2026 20:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BMw7VmOy"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA763101BF;
	Thu,  8 Jan 2026 20:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767902935; cv=fail; b=hb9s/09op5IrpZZat9YLjJV2WpAh6gD5ow+/1awxinCufxNlqOw5Eygzrdkp4Hc5s6Xy6CEa2aX3BF1bUZQVXifyPDcTtd72Cys/bu/oAMmIivI8iXBmddGKC3CtAmq6YxzOIbHo5FoGUALT7T3f6NoPA5R6AiJtSSvGoykkss0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767902935; c=relaxed/simple;
	bh=YfYEW40mwA9+cwFTwf8sIYe0h5ZKfqnE9k+WdcpH1B4=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=X+sgbOeROANthynPGvLZJdVgJ8AQMnVdX5KZoHhVXLeyKW8yzrLnMlKBJHmWj8vlvOtV+pOyf7b3Zc/kjn/SL9QXPWMrPc1s0yQALltUAQHYtBx54+BPlpfHtxtKE3bYuNjXj4R7+JKerE2Cur64/sCh4Df8a8YDuYEMMppdDmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BMw7VmOy; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 608HgbbD007458;
	Thu, 8 Jan 2026 20:08:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=YfYEW40mwA9+cwFTwf8sIYe0h5ZKfqnE9k+WdcpH1B4=; b=BMw7VmOy
	x5Gj23OjCYiobAujPBjOv+e2Q99Wd9aQz0QoheQBe69G9GZL07xk85G0A0b2Qb9s
	FKRUmTlo5Wp2nfku1nsf73IGQ+5Q/kkMm70DKrUdEb1ki2e+8mt399E9QBfAQtA5
	t0yPwy525geaU4uJIX0PMSqMGENRWnbSr+6EDJIn7axTCpzDIFP7t5HzcqMj/vMR
	T1z+iEaVmhbGfHYPLYgwp1LvkR4NiCnQVLq3X+2fK8OemppnAUCXzGxfKmO3LIk2
	v2FfPmx02+95kpweeu/ZJ150E7jy8sLYGYvuCpdK4E0YujsqJfulKWpsaabrA6VO
	QGVz64KROM0USQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4beshf6t0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 20:08:49 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 608K1GBG027371;
	Thu, 8 Jan 2026 20:08:49 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010028.outbound.protection.outlook.com [40.93.198.28])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4beshf6t0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 20:08:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FMOhfTocZIuexOSXrptmCY9MvqFpG2tMP+uDSQKMrf1fyg+p2y6kGDUcG29u6LotqMTm5nxbsrFdb7Yd4UILKq3GlE7TR1cNUFA+yh2wtge/aYLQiYHp6dKlUC0DbL99JE0fsXZL/1J9VcWvPK+1+fn6blYoLGUhdVD2U0qgMHkDNNaE4t0n/mSuLWgR98dfutfrYLVFEinhG9854ZSGq+crLadG59/3VAYAru1dGTanzSKlxiVJX+VCQqi/MVeLb91kahDhkv8YBx3yNOiWlcvnrQndQb3zxwd9Q4FvmLqdnBEdabMGzdaQMsW0xjBcaCNdIO9A+LEdI4Xfert9FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YfYEW40mwA9+cwFTwf8sIYe0h5ZKfqnE9k+WdcpH1B4=;
 b=SAx07t27P8fTAV7ZJWj9pI5tZ5XdMQ5p6rqVjQosQrRFzODc6E4D0QpAkZUIYJvJ47WI2sC8r74IbadVhs9cVDEJ+vXFVB9cOGfz050GOvLJKn3k5+mUONR2jgRHBo4Cqvo3gREefzfhPm0YEI/1mSMnbIMR5m32++LRwYKG/OKTV/58csUYgCOirsEZA+GJDcyPRbByuTK5QI3Vsiqaf5FNE+aTQk1yp4bZ1IaY6ddboe+YnUt4rjX4JwAthEpYPVZbvRhg/D+wwSvafLHMCx4z/wOSNyowVohwTsbuU/6Qoj4z52G4tejodmDa3BIuzIDDNCUnry2np5x/h5kukw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by MW4PR15MB4377.namprd15.prod.outlook.com (2603:10b6:303:be::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Thu, 8 Jan
 2026 20:08:46 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9499.001; Thu, 8 Jan 2026
 20:08:46 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
        "cfsworks@gmail.com" <cfsworks@gmail.com>
CC: Milind Changire <mchangir@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH v2 2/6] ceph: Remove error return from
 ceph_process_folio_batch()
Thread-Index: AQHcgBjpkqD1AjGAX0qEDecvwr1S1LVItP2A
Date: Thu, 8 Jan 2026 20:08:46 +0000
Message-ID: <a16c48a05998429d26f68887cad4abec045869c7.camel@ibm.com>
References: <20260107210139.40554-1-CFSworks@gmail.com>
	 <20260107210139.40554-3-CFSworks@gmail.com>
In-Reply-To: <20260107210139.40554-3-CFSworks@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|MW4PR15MB4377:EE_
x-ms-office365-filtering-correlation-id: 00f82fd9-7c28-43e3-3b70-08de4ef1bb10
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?L3ZYem44dTNrc1luQ0VraUZtTmU4aGEzSmJVeVJ3WGFUeUdPK3lGK3J4dFdV?=
 =?utf-8?B?RFNoa3VTYjZqN0tRTXJiMFU5NmVLTitnSVN1L1lLWU0rYXBsYi90Qjh6Z2sx?=
 =?utf-8?B?MnVNRFF2N2Zub1N3Nks2YXhubFcxTTdFeUlFb3ZIYVR3VlFvOFh3Y09kUG5p?=
 =?utf-8?B?ajdnY1d0eDZqN1VuZFUwb1lpWkdwcVBvTkpsQmNJUlNMRytldTlRaXY2dE9m?=
 =?utf-8?B?ZGVBbzVJMFlTbHF6VG9meGhpOFFvWTV3eUY2UGQ2WTRYdmhLRndQNnVPTWpM?=
 =?utf-8?B?enI3YThaVFk2TGVuWHJLc0ErbmJJY0RIRlBqRXViZVIzWmt6eFVQRVBRTnRx?=
 =?utf-8?B?WUVJSTIzenBSZi9zYXVtWGR6TVd2eElnNXVnWnpTcEg1NkhDQ3AxQlVreWJ0?=
 =?utf-8?B?OWthSHhLUFVCTFVqYnBVelhTSzgwL2FVT0VIbXlrK3FPY1dneTEyK1g5aTFH?=
 =?utf-8?B?aElZckZFdjdZN3F2Y0RvVjZtMDFldmkycDJoYkJkU3dhdC9HMzB5WDlmMGtk?=
 =?utf-8?B?YVNvSnE5amNWRXdTRVlwcWtzN2NmUU9qV1lhcXg1WTN2SVp0QVNzaVBDR1dY?=
 =?utf-8?B?dmVIN25aaCtqUkUvMjhOekNWdElWVHBTU3dLb3Q2eDMySlR0cVJVMnRBSUdB?=
 =?utf-8?B?azVLcVpBOHViZTV4L2hJa2lrV3gzMkQyMXJFbmxqd3IrN3Q2cXZpcVh2SHJ4?=
 =?utf-8?B?WUxPTTlWajZsNzNyeWRmVmtMYXBOcDNIeTRuSHhSOGJhUGd4QXRLTVR3TEdM?=
 =?utf-8?B?d3N3eVoxVTdpQXIwOUFhbG1HQjFZRnUycU1kaWg4V1duVStvZUJzdFNFZDVy?=
 =?utf-8?B?ci9ncTk2ZExBYVBQU3c1YWNHUHgybzFqMndCVnNFL1VJZWd1cHZuSFhKMzg2?=
 =?utf-8?B?R1paZnNwSkF1VTE4bkZnckFWb0VublF2YUVmT1g0bU1FdmNuQzQwZUNPY2FK?=
 =?utf-8?B?ZjZtUmtCMHQ5ZDYyZitEVTRVeFdaSW9tRXJaTkJIdkFtRFozaFR5ME9oaDZT?=
 =?utf-8?B?YkNjRmhMSEhjaUFSS1BWY01XTHpJSXFsRkZsanRQUWVFZ2xzTkhDdnhtOEdi?=
 =?utf-8?B?dDlSdkVDVDlWT2x1cHpNeDRNOUpRdmlQTEZVS3lHa2huOWltdmtKQ05xYnR5?=
 =?utf-8?B?dzhFUUtRZmpuME53KzdVeWJCZjdqaVgvamZnZDFYRER5OCtrdHVSUnBQaURq?=
 =?utf-8?B?bktCZVErRFFPaS93L01BM0xxd2cyeWszcWtEd2hKNDQ2M2d4NmpwcDdHZlVq?=
 =?utf-8?B?Rkg0K0xlTk1uWXNCSEV0cmNiODAvd1VkQWdYUmt6bmZLcWFIVC9Od01uN2VZ?=
 =?utf-8?B?TmkwN2pFWVRkUGNzZ1p4SmwwUnJPek8vUVg5czE0bVdMc0JCeUtJa0MrTGZD?=
 =?utf-8?B?NTV5MjJmQjRxcWlaNkwzd1J2WHByaE5MeUZ0WmdGK3JDbzl6Q2lHRzM0WkI3?=
 =?utf-8?B?R3FaU2REUlAzSmpnTW5iVTVPRUxNTHBVdCtJMWhybVhXd1R3Sm9VOWxFK09k?=
 =?utf-8?B?dFVpYWhYOWduNlZEVmpRVFNlWm9OcGl3eVJUTG0vWlp2KzN6a3ZVQjdVMDNl?=
 =?utf-8?B?emo2MnJ1SXI0N1V0MHJFV1g2NE1wNXF1ejJaZ0k1VzZ0WW50S1Z0V3l0Ly9Z?=
 =?utf-8?B?U1lPMGhYT1ljalhFUFl0OU05V0lOdXp5QlpyZE1FMVRzZk12T0VMZXdTUG5R?=
 =?utf-8?B?QjBTc2RRYjNlZllZN3cvWWJqT1UwRGtDL0E0bCs0SDdlaVVTSVBaSmw1cEl5?=
 =?utf-8?B?QlFCaUNLVWNZZ1hUSG1CdVIzVnd6QWkxa3JOYitBZG5SeHJxQW5BOHRqZ1pp?=
 =?utf-8?B?a3MyUzIrYk05V0dGK3ZoQUY5WFVIME8rSVdPeWlnaUxiUFNiV2M5Y1U4dDhC?=
 =?utf-8?B?R003R2lxS2pJdjE5RE5BbmplM0tPUGplc2d2YzNPQ01RYTJ5bSt1bjRzLzBL?=
 =?utf-8?B?bWJCenRoSDZXMUNGcGNpNW0zZ1BzZFk1c1RYTmg1a01nVGFydFJiWVgxcGJN?=
 =?utf-8?B?RHhJaC9VdDdYRXJRaVpxMC9qMFdTU3pReXhlMUg5VmRKNFhwcWFwQWY2aUlB?=
 =?utf-8?Q?G3oUWi?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bHJJcTI0eklEcnIrTE5FLzNndjhOSnVYZGkwR0VDdVVxU1M5K0hkVzRIOEZH?=
 =?utf-8?B?N0FKS2Q5VTJDeDhtaW45ZDFibS9kbnpwL1pmczd2RUFaSlp3UDdhaHMzaVJr?=
 =?utf-8?B?dDdZVUZiOE9yR1pweEhPbTRiSWQwODFZZy9jMGFQN2hlT0JVcjlVTFpYUmc4?=
 =?utf-8?B?Q1F0VjZzQ0I5Tks4bGRMRjZKWUFUTktRelhvSnViM0RkeW9MNEdJQTlVbGxo?=
 =?utf-8?B?UkdWYTBCM1BZV0lSN0dYcjZVVW5BQXRFc0pBWmQrZ1M1ejB5clg0V3EzUk12?=
 =?utf-8?B?bjlIMXpNblNQVTdwSTNmZWlIdmF3VTVWM1Vkc3pLVXBseTl3blhHK1VWSUNu?=
 =?utf-8?B?NjNySzdOYXAxbjgxRUwzWi9TbnVOVFNyODVGVTB6QkRzT0psc3J3bmNCZUcy?=
 =?utf-8?B?NnVZb0psWVcrbXJKbjJBL2I3cDk5OVNLdGJsK1FCb2FNeC9mcmltRHZ4TEFm?=
 =?utf-8?B?TVRxcVB1aFpiUUpURHVhYmh3aWplOUdWUUNPWnpFSnVrUyt0RTBLSXBFSnhx?=
 =?utf-8?B?TDRRbGJMc25yT3hSQnhtajB6L25wYXVNbW5wWVFkWkdDZ1hTcElyVEFnbU11?=
 =?utf-8?B?ZTFWUUxpWjBiQnRSSEIxa1pYbTgwZnlEYlF1TThON3h2UGxUbG1BSzl1NThm?=
 =?utf-8?B?UzhGOU1OTzB0K2ptQkNkd2I1NXFWZVNNTE1NZTV6a1RuODZtWElXZmdjbUQ4?=
 =?utf-8?B?ckMrdTZnS1Axb1pIL1N0bzhvNDFUVDZya0p5cWtDeHN6dGFJdldsbW1kL2Fw?=
 =?utf-8?B?Sm8xZTRMaUphVEZ5cllkQWxJaUpwQldyMndJT0V2QmZ4elRMWDBuRzJRMmFt?=
 =?utf-8?B?RkJ4L0JQMVUxWmF0NVNSa29vRWsxZzhVY1A3OUorazNPOEFtaVo3ODhRM0ho?=
 =?utf-8?B?eDk2MC9ZK0h3LzNvNTNxM1Z4WEwwRzA5emdXWks0NTY0VldiZHk3em1IR3dK?=
 =?utf-8?B?TENpN2c4YkJoYkZRdFVhdGw3ZENwSWJoZmJwaC9yV2FRWUk3OXB3UjcvRnN3?=
 =?utf-8?B?eG9CakxxejBscDQycWkyMy9PWkc3dzF2RUNoSS9KSEdudUpDZzBkb2JOM0RJ?=
 =?utf-8?B?T2hDVG96OFFvKzg3MzhoS0JKV1A1eVFoTE1uSmpKVnpvNk1pbXdzUnZGMjlz?=
 =?utf-8?B?TjlxU0wwTkwwK2IybXNObjA3eWxTYlBwSmY1NWllbDlpQ2xkTjY3UnJ2eW54?=
 =?utf-8?B?WE1nNDZaUFlmNTJZOEdraVhNcnIrK0cvZkhqWVhReE5oMkRTOTVSQWJ6U3A2?=
 =?utf-8?B?a1BwOVdrOUFIVmNhQ0NMK3JtVWRkSFRoQ1VaaWdEOUExK2xuMHZpemNTb1Q1?=
 =?utf-8?B?REhTUHVTc0NwR3FxWTQ0ZjAwcmZSUEJsdmY3cWpTbFYwcWl6MmhJZDRyQTFM?=
 =?utf-8?B?ZlY4Y01yRGx4bXZEYUN2ZG5RTHJnaW8vZko5K2JUanpFL2dRUGt1L1NTQnl5?=
 =?utf-8?B?K01BYm9HNGRQM1dkRDF4RVdZTW03QS9FTitFbEVOY3ZqZXJaSXVQa0Vyc3hF?=
 =?utf-8?B?OFN4a0Z1cVV6VW1VcUoyZGR1eTVGdjZFeUpCUzB6T04zNHhldzY0TGVMN3dj?=
 =?utf-8?B?VFAwUk5SUENjQVgwbE5lY1F0WmVhRk1Uc0tkNUdUclB4OHQ3Q2RTTjNqQ3BU?=
 =?utf-8?B?R0Y0QTE4RWtYR2JIcDVjMDVDODR1TlJrc3lweXpHNEJiR0VKYjBRT2htQWZm?=
 =?utf-8?B?elFOSzBDWDIyWjlzRUJOZnFBRFFJTENMRi9qUU1XQ1B5aUFGaVFzZHZiem12?=
 =?utf-8?B?UThoaERYQjQvNFZJbDBMa1ZadUM2VkRPR2g1MFdJN21OY2JWWjZEZHdFRDJG?=
 =?utf-8?B?VGVENTFaQmwvYUxXMXNuZHFrMWp2d0FCaGhCZFo0TlRpcnNCajM4UHBObExG?=
 =?utf-8?B?aGtHOHVqdkp5enhYdldSZnVJNEZFb0NwNlZyYU5ha29TZ1hqT2dYajlCVW9i?=
 =?utf-8?B?dHBKL2kweDNONEdwY1hQSm00WFpZd1hmVDZ3TlVCK0FTNlNVMU5Ib3RHWkR5?=
 =?utf-8?B?ZXJRN3M5bmdBa0lkeHFLSklyWDdkbjJ2bEVteENjNkRjcElZWHJiR2lFMU0r?=
 =?utf-8?B?cGx3dkQ3UVFSNkFtUGc0WStGb2I2amlxSWtBMHBxY0QreS9IcUhxNkhyZi9D?=
 =?utf-8?B?UmFlU0c1UGFNRE9pUHl4R0FTdDVqN21mYVNxOFlqQjY0blY5R1Zab3E1OUhz?=
 =?utf-8?B?ZHBPRitOTjhDZFc1Ukh3U2ZIWmpSV1d6MVdnRndYb3pzTFVtNFdmRDRYZHl1?=
 =?utf-8?B?Q2Rya0luNFRFQlZCcXpTNWNHRTROR1hyTlpsZnlkTUJwUEdpSTlZUnBEdzNz?=
 =?utf-8?B?WnJNSFEwc1pzRTFQQnVORExtOXRWdVltYmE0dXdsdldXTkdkOWtBNnpha3NZ?=
 =?utf-8?Q?ehuBLwTQWwTympjy+XVFHEV8H55o3ncWD0AxV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5FB85DA8E2D174196190BD1A44F8EE5@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 00f82fd9-7c28-43e3-3b70-08de4ef1bb10
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 20:08:46.5341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WpNKEwfCOTySXDFinuV/Vly53MawfN5ueQ6KKBSph3TKop3Vs88l96/eluZEoypofKhHqMeObSAuuuBC1gyjqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4377
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDE0OCBTYWx0ZWRfX5LFNwocTPKKq
 7TED9Dvtmfd8TR/VzWF7pA4VbbMnb5dJ7TOtHAltSAaARaq3Nr0Af9i9o68x2r7uoDj5+nRu/B2
 HChhgOT2BqlFHz18FLjDaH0ofykLLrfI67YWsfBDCZxMVdIQD3fgA5330+kYfyD8yVBfYvwFPgz
 ALsLZub4oGYKxA7qY47oDCBjz3nb3LGWYxQ2yPOa1/oFRwTUnp0okpDuNaBAY432gRBEQwuSeSp
 dVD3hkaQe8oYX2K72v7sfZ6ncnIm0GaU388z68qCBoSGR8t6/9Rgy0QWqASaQzd0+vM6D75QkUk
 kR515pua8HxKTpf9ZnB+hUdraMOLdG2dtAIEehFdiIjTAWeUJ/MxACrC7sJeFbo5i/CZmo2UO5F
 PkwCgLID8fd2CPjoifMrjP7vmCsQgf6YAItEcyO2xdAdTTrtPQYB6JCDYa+yQKMZ/OALs/Ylxsy
 W/f1Xhlaj0ZPacxBAag==
X-Proofpoint-GUID: 9dPRXd1BXyYosbAnQ7byKoeh0PQfPiJX
X-Proofpoint-ORIG-GUID: uSzFywWRGCHMKLjZ8Am_yxP6EJ8p9gnu
X-Authority-Analysis: v=2.4 cv=AOkvhdoa c=1 sm=1 tr=0 ts=69600ed1 cx=c_pps
 a=W+OgQPQm/Pc/5TU0+uq6wA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8
 a=KBVUG00mDK2Yv5t489gA:9 a=QEXdDO2ut3YA:10
Subject: Re:  [PATCH v2 2/6] ceph: Remove error return from
 ceph_process_folio_batch()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_04,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601080148

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDEzOjAxIC0wODAwLCBTYW0gRWR3YXJkcyB3cm90ZToNCj4g
Rm9sbG93aW5nIHRoZSBwcmV2aW91cyBwYXRjaCwgY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKCkg
bm8gbG9uZ2VyDQo+IHJldHVybnMgZXJyb3JzIGJlY2F1c2UgdGhlIHdyaXRlYmFjayBsb29wIGNh
bm5vdCBoYW5kbGUgdGhlbS4NCj4gDQo+IFNpbmNlIHRoaXMgZnVuY3Rpb24gYWxyZWFkeSBpbmRp
Y2F0ZXMgZmFpbHVyZSB0byBsb2NrIGFueSBwYWdlcyBieQ0KPiBsZWF2aW5nIGBjZXBoX3diYy5s
b2NrZWRfcGFnZXMgPT0gMGAsIGFuZCB0aGUgd3JpdGViYWNrIGxvb3AgaGFzIG5vIHdheQ0KPiB0
byBoYW5kbGUgYWJhbmRvbm1lbnQgb2YgYSBsb2NrZWQgYmF0Y2gsIGNoYW5nZSB0aGUgcmV0dXJu
IHR5cGUgb2YNCj4gY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKCkgdG8gYHZvaWRgIGFuZCByZW1v
dmUgdGhlIHBhdGhvbG9naWNhbCBnb3RvIGluDQo+IHRoZSB3cml0ZWJhY2sgbG9vcC4gVGhlIGxh
Y2sgb2YgYSByZXR1cm4gY29kZSBlbXBoYXNpemVzIHRoYXQNCj4gY2VwaF9wcm9jZXNzX2ZvbGlv
X2JhdGNoKCkgaXMgZGVzaWduZWQgdG8gYmUgYWJvcnQtZnJlZTogdGhhdCBpcywgb25jZQ0KPiBp
dCBjb21taXRzIGEgZm9saW8gZm9yIHdyaXRlYmFjaywgaXQgd2lsbCBub3QgbGF0ZXIgYWJhbmRv
biBpdCBvcg0KPiBwcm9wYWdhdGUgYW4gZXJyb3IgZm9yIHRoYXQgZm9saW8uDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBTYW0gRWR3YXJkcyA8Q0ZTd29ya3NAZ21haWwuY29tPg0KPiAtLS0NCj4gIGZz
L2NlcGgvYWRkci5jIHwgMTcgKysrKystLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA1
IGluc2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL2Nl
cGgvYWRkci5jIGIvZnMvY2VwaC9hZGRyLmMNCj4gaW5kZXggMzQ2MmRmMzVkMjQ1Li4yYjcyMjkx
NmZiOWIgMTAwNjQ0DQo+IC0tLSBhL2ZzL2NlcGgvYWRkci5jDQo+ICsrKyBiL2ZzL2NlcGgvYWRk
ci5jDQo+IEBAIC0xMjgzLDE2ICsxMjgzLDE2IEBAIHN0YXRpYyBpbmxpbmUgaW50IG1vdmVfZGly
dHlfZm9saW9faW5fcGFnZV9hcnJheShzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZywNCj4g
IH0NCj4gIA0KPiAgc3RhdGljDQo+IC1pbnQgY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKHN0cnVj
dCBhZGRyZXNzX3NwYWNlICptYXBwaW5nLA0KPiAtCQkJICAgICBzdHJ1Y3Qgd3JpdGViYWNrX2Nv
bnRyb2wgKndiYywNCj4gLQkJCSAgICAgc3RydWN0IGNlcGhfd3JpdGViYWNrX2N0bCAqY2VwaF93
YmMpDQo+ICt2b2lkIGNlcGhfcHJvY2Vzc19mb2xpb19iYXRjaChzdHJ1Y3QgYWRkcmVzc19zcGFj
ZSAqbWFwcGluZywNCj4gKwkJCSAgICAgIHN0cnVjdCB3cml0ZWJhY2tfY29udHJvbCAqd2JjLA0K
PiArCQkJICAgICAgc3RydWN0IGNlcGhfd3JpdGViYWNrX2N0bCAqY2VwaF93YmMpDQo+ICB7DQo+
ICAJc3RydWN0IGlub2RlICppbm9kZSA9IG1hcHBpbmctPmhvc3Q7DQo+ICAJc3RydWN0IGNlcGhf
ZnNfY2xpZW50ICpmc2MgPSBjZXBoX2lub2RlX3RvX2ZzX2NsaWVudChpbm9kZSk7DQo+ICAJc3Ry
dWN0IGNlcGhfY2xpZW50ICpjbCA9IGZzYy0+Y2xpZW50Ow0KPiAgCXN0cnVjdCBmb2xpbyAqZm9s
aW8gPSBOVUxMOw0KPiAgCXVuc2lnbmVkIGk7DQo+IC0JaW50IHJjID0gMDsNCj4gKwlpbnQgcmM7
DQo+ICANCj4gIAlmb3IgKGkgPSAwOyBjYW5fbmV4dF9wYWdlX2JlX3Byb2Nlc3NlZChjZXBoX3di
YywgaSk7IGkrKykgew0KPiAgCQlmb2xpbyA9IGNlcGhfd2JjLT5mYmF0Y2guZm9saW9zW2ldOw0K
PiBAQCAtMTMyMiwxMiArMTMyMiwxMCBAQCBpbnQgY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKHN0
cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nLA0KPiAgCQlyYyA9IGNlcGhfY2hlY2tfcGFnZV9i
ZWZvcmVfd3JpdGUobWFwcGluZywgd2JjLA0KPiAgCQkJCQkJICBjZXBoX3diYywgZm9saW8pOw0K
PiAgCQlpZiAocmMgPT0gLUVOT0RBVEEpIHsNCj4gLQkJCXJjID0gMDsNCj4gIAkJCWZvbGlvX3Vu
bG9jayhmb2xpbyk7DQo+ICAJCQljZXBoX3diYy0+ZmJhdGNoLmZvbGlvc1tpXSA9IE5VTEw7DQo+
ICAJCQljb250aW51ZTsNCj4gIAkJfSBlbHNlIGlmIChyYyA9PSAtRTJCSUcpIHsNCj4gLQkJCXJj
ID0gMDsNCj4gIAkJCWZvbGlvX3VubG9jayhmb2xpbyk7DQo+ICAJCQljZXBoX3diYy0+ZmJhdGNo
LmZvbGlvc1tpXSA9IE5VTEw7DQo+ICAJCQlicmVhazsNCj4gQEAgLTEzNjksNyArMTM2Nyw2IEBA
IGludCBjZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2goc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBp
bmcsDQo+ICAJCXJjID0gbW92ZV9kaXJ0eV9mb2xpb19pbl9wYWdlX2FycmF5KG1hcHBpbmcsIHdi
YywgY2VwaF93YmMsDQo+ICAJCQkJZm9saW8pOw0KPiAgCQlpZiAocmMpIHsNCj4gLQkJCXJjID0g
MDsNCj4gIAkJCWZvbGlvX3JlZGlydHlfZm9yX3dyaXRlcGFnZSh3YmMsIGZvbGlvKTsNCj4gIAkJ
CWZvbGlvX3VubG9jayhmb2xpbyk7DQo+ICAJCQlicmVhazsNCj4gQEAgLTEzODAsOCArMTM3Nyw2
IEBAIGludCBjZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2goc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1h
cHBpbmcsDQo+ICAJfQ0KPiAgDQo+ICAJY2VwaF93YmMtPnByb2Nlc3NlZF9pbl9mYmF0Y2ggPSBp
Ow0KPiAtDQo+IC0JcmV0dXJuIHJjOw0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMgaW5saW5lDQo+IEBA
IC0xNjg1LDEwICsxNjgwLDggQEAgc3RhdGljIGludCBjZXBoX3dyaXRlcGFnZXNfc3RhcnQoc3Ry
dWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcsDQo+ICAJCQlicmVhazsNCj4gIA0KPiAgcHJvY2Vz
c19mb2xpb19iYXRjaDoNCj4gLQkJcmMgPSBjZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2gobWFwcGlu
Zywgd2JjLCAmY2VwaF93YmMpOw0KPiArCQljZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2gobWFwcGlu
Zywgd2JjLCAmY2VwaF93YmMpOw0KPiAgCQljZXBoX3NoaWZ0X3VudXNlZF9mb2xpb3NfbGVmdCgm
Y2VwaF93YmMuZmJhdGNoKTsNCj4gLQkJaWYgKHJjKQ0KPiAtCQkJZ290byByZWxlYXNlX2ZvbGlv
czsNCj4gIA0KPiAgCQkvKiBkaWQgd2UgZ2V0IGFueXRoaW5nPyAqLw0KPiAgCQlpZiAoIWNlcGhf
d2JjLmxvY2tlZF9wYWdlcykNCg0KIEkgZG9uJ3Qgc2VlIHRoZSBwb2ludCBvZiByZW1vdmluZyB0
aGUgcmV0dXJuaW5nIGVycm9yIGNvZGUgZnJvbSB0aGUgZnVuY3Rpb24uIEkNCnByZWZlciB0byBo
YXZlIGl0IGJlY2F1c2UgdGhpcyBtZXRob2QgY2FsbHMgb3RoZXIgb25lcyB3aXRoIGNvbXBsZXgN
CmZ1bmN0aW9uYWxpdHkuIEFuZCBJIHdvdWxkIGxpa2Ugc3RpbGwgc2F2ZSB0aGUgcGF0aCBvZiBy
ZXR1cm5pbmcgZXJyb3IgY29kZSBmcm9tDQp0aGUgZnVuY3Rpb24uIFNvLCBJIGRvbid0IGFncmVl
IHdpdGggdGhpcyBwYXRjaC4NCg0KVGhhbmtzLA0KU2xhdmEuDQo=

