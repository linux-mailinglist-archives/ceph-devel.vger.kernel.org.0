Return-Path: <ceph-devel+bounces-3601-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C839B555CB
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Sep 2025 20:03:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7D5C1CC7923
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Sep 2025 18:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021B7302CB2;
	Fri, 12 Sep 2025 18:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MF2x2VXH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E34419994F
	for <ceph-devel@vger.kernel.org>; Fri, 12 Sep 2025 18:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757700206; cv=fail; b=pMxuwb9VGjq+4idZgKloj+/UjWtXLNf+IX0VeO9yeRMiwF263J7gYG3gTUh3ncY8rQtmgzSfbgaqSjsvwMB5h4E4wUFlx9B+Kgf6ZBOPxYdn5QTFmJBhK7LZRyM1Ap7u0J1R6GtW1l2VQFk8IW2o2KfVeAmWdGqF55ffMqyMOmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757700206; c=relaxed/simple;
	bh=J17kcBW6SQW78KvyGJUxipWYbY1r7vnnUYmzDaAI7QY=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=HKJKReJxyuXDx762KNa+Kc/tDH70QnS+x0QcrOwgcxqWGgnBctoQud76OFyDVGc34AVX71sREczE3CCNrvROMeCvuuD9A6ZvVXSCspI1X9uJCL2XHKpry8BWCd/qLaChqgXJMi+muRX8yfoCFf4G7itkEVxEJw3DLYHOOkWGioo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MF2x2VXH; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58CEo6wH002977
	for <ceph-devel@vger.kernel.org>; Fri, 12 Sep 2025 18:03:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=aZPYiwODSZAxpihHeVBygfziU4q24qYY/MyKsx4YcHE=; b=MF2x2VXH
	edwJaGeTB6hv1pks+570LgseOmj9tnFCGJDuGiTglsb96fw7GeKfFM1HNojaYt7C
	udBs8iuHJpPk54hdm0bLQT+js6D1e+P/7FW0rTwCyS4w1xGfkQpVFJErty+2XGDQ
	pWmrLbHtoxseqCQHUWj/ayPqbAztGw4TuDkqc2ox1I2ns9J7Evg+w5R7AYxZ0U6A
	wOZFH9ZaeoDp1jBBS8KBAWF78Y0I3cxo9DLJnELempQsewyg65WmMzQY/y+0fZnk
	xme0TyJl0tP7W+0NhVxfHWFjaze7MiLOdphb/HTU/ddCmpXugrF0mgyrrCvId905
	qgJIKePWlgHlfA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cffw70g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Fri, 12 Sep 2025 18:03:23 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58CI3MCF017937
	for <ceph-devel@vger.kernel.org>; Fri, 12 Sep 2025 18:03:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cffw705-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 18:03:22 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58CHteHQ002799;
	Fri, 12 Sep 2025 18:03:21 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cffw701-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 18:03:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T5cONv/JGqFdtF9HUqoJtw1xPrIga9152dOBGt9m+ywAy7M9nb3R1WBUbSkPIYmWXLwA1QkoDkZx+vMbxFXfKq+z2E8hUg1XCmSu2Y2p8wUqdc81l0uobk7GvKkSxQMtT+QWG9LoiEYLcJu/2+llEKvEe1ByOVy8vXuXU7pQGLZMcycR2kkf93Cy6mCGZG2DclsToDzZKc1Fd4Fls+jBAMiZ4OHmGfOpAzGlEKsoz/fKP5J6DRv7y/GsYujmCbQ5KeqfR98BkHYSzeN6aU7zTJE1zI4rimHfGZI7Z5IUh5Wa0eHlDUBUNdHi/O/qUUdzq1sLbiL/POATL+cq3pIH5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VHG0O1XVmUQ0jPOfGB+Ya+9WJbG0iC7qqA7PfM4f+oY=;
 b=Ci6irrSGByE2RCEBuedP1bkw4ZwZiaqzNfgH+f6uFiqTJ7uDzWLIoa1+FuQzuNvbcRjt2mV39FUeD12sT5ROAC4B+Rwwf9aJmEae0szANkFXVfC4Q/X1UsqCR4TEz0kSaMxj0NWJI/aPCuAyUnWIaBheU1OlJe5qzk6KmelhLOcRrBRy4YgodhJ94Xs2/wdxCBM47qufqi4Cuqa6syrkH8QgSekLEBrYEzqfznqyPEVMk3KTcOki46esM2/0gfoEp7iKuOhnuA/awnpvm/AJEBoPMucWGh5Wu7kQCcPwdJt+NBmTn49FCvUhF06FQ0JwOEbO8XjjZRUxLJu1KFSeyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com (2603:10b6:a03:4e4::8)
 by SA1PR15MB5818.namprd15.prod.outlook.com (2603:10b6:806:332::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 18:03:16 +0000
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::266c:f4fd:cac5:f611]) by SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::266c:f4fd:cac5:f611%4]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 18:03:15 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Kotresh Hiremath Ravishankar <khiremat@redhat.com>
CC: Venky Shankar <vshankar@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Alex Markuze <amarkuze@redhat.com>
Thread-Topic: [EXTERNAL] Re: [PATCH v4] ceph: Fix multifs mds auth caps issue
Thread-Index: AQHcI7JSsNwatAbrsE6vxrScHuKWBbSP16CA
Date: Fri, 12 Sep 2025 18:03:15 +0000
Message-ID: <6a8e7a752d680a79f7e613cf5a601aa490b5fe02.camel@ibm.com>
References: <20250911093235.29845-1-khiremat@redhat.com>
		 <bf1a10a3d6a85bb95f58327b6155f09abf283db4.camel@ibm.com>
	 <CAPgWtC5dB4UHio9RroKwT2jh+yRc=hDjLCoBvxJArYj7i8TcVw@mail.gmail.com>
In-Reply-To:
 <CAPgWtC5dB4UHio9RroKwT2jh+yRc=hDjLCoBvxJArYj7i8TcVw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR15MB5821:EE_|SA1PR15MB5818:EE_
x-ms-office365-filtering-correlation-id: 5f47c91a-cc9a-4d43-afd9-08ddf226a5b0
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?dVFCSzl4UlhTOVNUOGJmNWwvMms1T1lrWDZVQ2NsU1lteTdyMGk0Ymp5Nlcv?=
 =?utf-8?B?d1JPRW5hR2I5dEg1UDVKeEFIQmhydmxtdTNZTzF5dEFuODFpYWZBRTRUbElR?=
 =?utf-8?B?cHE5UEVxazFYSkhkSGF2Q29NdXZvdFVCb0kxTTZGejRVcnRVekMvZm9BaXF1?=
 =?utf-8?B?dU40Vy9CWndFREVRRCtSUTE2WDhLZXNOdk9ZSEpVTldUYm5hVVc5WTYyQVgz?=
 =?utf-8?B?MXlEdXB2TXNKYnJNOHFzR1laTzEwb0FqUTFpb1hEdVp5ZTVyT3JBSkVvVm81?=
 =?utf-8?B?UEVMS2lkdE1aeGxVNHFoWGhuNkpHck5EbDF6MmRTY0JRb0dzQkxFemFRSXNu?=
 =?utf-8?B?V1BxQVQzZUppekRmdWNHM0JmeHpQR29uTmlUMUU4THNibVE5bld5eFdUUHVS?=
 =?utf-8?B?L1FNNy9ENlZtREc4TmV6dW5nU3draUJPdlZvUWZ2S1JycnNabWIxQitmNWpw?=
 =?utf-8?B?MTNJdFNwdVc0eGZIc2E1dWJ4THVnWml5VWFrZFFubmN5cFY4V0htd2pLYjFJ?=
 =?utf-8?B?bXFYWmFlNmZyMG03bXZuNWJWbVAzMTNONTk4c0VXOHIvTWN4RE5oVzNvTGJ6?=
 =?utf-8?B?K2JUaW54azl4VGxPMGhDWDRVZzBwRVBuU1V4NlEyQkFFeHI3TkJtWFlmUW16?=
 =?utf-8?B?akRHWSt4NkF0UmJoMCtNK2Q0WXZzaTZsV0VWTm1uZnFMWWV6NjhPUERhaEwy?=
 =?utf-8?B?SkdWOFd6a1ErNHdzdHlYM1BFUXFYWWdkNkMzMlZ1aTNsL0Uza0toTkpBd1ds?=
 =?utf-8?B?VVM1NkNHNkdWWkVXOG5rNnRJdy9IZ0NVU2IrVVlPMEN4TFpnL0gxb1JZSzZZ?=
 =?utf-8?B?b1JDWGUyZWVvVFhrQmlnSE1iY0dwVUZGRytDSDk4dUhqenZ0VEVKeGJYeHBM?=
 =?utf-8?B?eWJvZ3R0WWZBYWhET25wdFc1RWlhUHhId1Zka1NlampIR05xUjgzOVpyWVo2?=
 =?utf-8?B?eWRJaTNGYXcrYU5zSHpTVmxUMGZWanVGMUttc2szNkQ0S25xYzVsdmc1SzhB?=
 =?utf-8?B?SFIwdzMrelpaTUFmZXhPekhDRkMxQ2YyLzJ4NFYzT2U1d2M4aTF1bTQ5d2Qr?=
 =?utf-8?B?bTV2YWlQRldIQTdHMCtVdU9LVmZSUjFOODJQZ2dBLzFXMW8ySlNzWWhrNUJj?=
 =?utf-8?B?TnY3dStON2ljTXJvY2pHZnc2SE85R2JWUG1ZSFVtVEdyUjI3VGxrUk5oR1ZW?=
 =?utf-8?B?b3lLVWlhdmY1ZGF6bHNJb1YzQkZOTVlKK2JGaXpmM2lMWGZjN0NhcmlSNDZj?=
 =?utf-8?B?L3dzSzkzU3VvUUFwN0hYdEVrRmpHMVlhYW15L1VSTytDczRVNkROdk8xaVQw?=
 =?utf-8?B?clZHYVQ4L0gzRFk2WU5wQXVwMFlkeVp2aThsMnVIYmhialp1WE14SmxOUmd1?=
 =?utf-8?B?djJuZHBydFJlektpR0F0ZVZmQ3lMYUJFeVJZTkNZRGI3cHlodERhUUw0ZUJi?=
 =?utf-8?B?eTVmT0lXZy9TOGdsT2NNL2dBTFNjTGVRcUtXL041TFhxNmdITUQ1MDV5aUR1?=
 =?utf-8?B?YkVVOUgvUDFIL0sxS2h5T2hwa2xZWW1rNVRSLy96YldRUGFycklNTUhOUk9x?=
 =?utf-8?B?a3piZTN4d0cxUFFzL3pmd0JOcitRVnhpZysyUVB0UWNqcTNCblZTR29GNVRv?=
 =?utf-8?B?eWRzaVZIY0RLdjI4czVQTnZRcjVwRmpZTklaUzhCSHdmTlRYeTJaV29BRnMw?=
 =?utf-8?B?MUVwSVpldmdscTY2M0dnVjFLWTcxREJuNFlzQnRPbDBvcElqSHp6KzZKSVNP?=
 =?utf-8?B?eVFJR3hLVWhTT2hNL1ZiQnBOQjRtd003cGJ4ZVFCd0UyRnBlbFdlTVEyYUJT?=
 =?utf-8?B?cGdpY0U2QTZCUEZVUEhuQ0NUamprY09WczZ0T25XbkNGRmUyQlQ3RDRIY3Av?=
 =?utf-8?B?aUduQTZ6TkN6cHp6RHU1N2psbVNiVkNocWYwTlB5Z01vaHRDQ043WkRIN3oz?=
 =?utf-8?Q?JcWBni0Jr6E=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR15MB5821.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dkF4QUVtbHd3d0hkREEyRkJPS0hzcmZabEFza3VhaXBLL2ZvTjFHVHNXQUhs?=
 =?utf-8?B?LzZjNEZZQTBqbkJkOVo5RXBsQy9LTEEweFBlNmxjRDZPakhlanJPbUd5bzll?=
 =?utf-8?B?SGhRM1BLNHlYZTdBdU9BS3B3anFvZHE2Sy9IY2ZreUo0ZGR1OUpBWkFBbGlE?=
 =?utf-8?B?VGFFTy82OEtYTkxZbDRJYS9ZeUxpYld2V2srdTdTV0JIcmprTGh6QUt2TU1p?=
 =?utf-8?B?dUQ5b0x4ZWpueXFScXJCdXpaOUtpdUhvbG9DZ3VYS0NTUlJzWVhPSERFOUJL?=
 =?utf-8?B?Vmp1ZVpLVTJyTE1jWG02MjFxRncvMStTeVAxSDAwTDVJOERZTEVGSzNJN3hV?=
 =?utf-8?B?bFJudGNIRGg1L2FsWXFnVXBId2x5RmZnK01wcGJwRWFnbnlpeVplVGVpbGx5?=
 =?utf-8?B?UGVPQVFoVmNwR2k4MWN0WGI0a0p1NURRVURDYkprT2xGb3lzbC9teUFvNGxH?=
 =?utf-8?B?d1VhMkowS3RKTHNWVnQxMlpjb1BSMzNvakNxVGVTLzNHaUlKbzIwMGF0MGgv?=
 =?utf-8?B?dUd0dytqblpvbnlpMUVLMnBzNGs4RjlpMnJSTlhLUUgvUVFkMSszWHdTOEFE?=
 =?utf-8?B?SElpVjRpcEc0YkZ5eFlNWVZGdDFxenVQRFJZMjNtbmtUMEtaM09TWXpld0Fi?=
 =?utf-8?B?U2ZNMGFEVFdGOW5XNGNrQkhnUFUvSWdWUlp3eGxsQlpicS93ajBUK0xKU0dq?=
 =?utf-8?B?ellkVlJlKyswQUJJMkxBQmlaN202L291SkFyT1B1a1FVSkNsS2lRT0pZakpz?=
 =?utf-8?B?V2V2Y2pOc1VncGJpekIxdkdYdDFucVQ5d2NXWXRMKzdMb3RoRFhrdFRBR1d4?=
 =?utf-8?B?ajNNc25kNDZ1b2hSSXJwbmM5YXF4ZkY2VVRhVHlNcEhyTHhRYzJXWEJ6SzJw?=
 =?utf-8?B?UHBMZzlhS2RSd2VHUGEyMERVdnR6MGdXVExNZjZJMnJIZks1RnlnRjg1d2NF?=
 =?utf-8?B?QThoSm9YZlB4VHREdDhMVXpFd29LT2dOWVBQWjlOWWpOY05UTjNoOFg4VGhK?=
 =?utf-8?B?NEExTXU1dVlSSzVVS1RPcHAvWTMyL3BMVVV4ZDFOOW8vWUoxaWlaWXdXbngz?=
 =?utf-8?B?bG5VMnVLVXpzVUpPUUQ4WkxROHVwLzk2dnhIS0V6aXZCc1VidXlveGMzL3Va?=
 =?utf-8?B?WWNEaDRlbmZsOWt4Rlk0Qis1TTRJYkQ3ajBMTnI0S2JNbkduaENNeDJSOWRM?=
 =?utf-8?B?WlBITDhhQkdwaDZYb0M3Y0hjRHZ5WUVQNEhMVXlQQ1pIZ2xjZWc2VVQ4Q1Rj?=
 =?utf-8?B?dDdpdkpFTXNRdDVOQXJoM1pNUTBZYWx2YWY4RzFNTFhXMWtrMEpsTVFyRS9r?=
 =?utf-8?B?RTBnRG5vWkUxUytYbXYzVkxkdm00V2FwcVJyUEZRbUw2d0RCMHNJaVdkWjZI?=
 =?utf-8?B?ai9wMmljM21yR0JqbjNZdHcwMGc2b1g2cTBETkhZR21jbWdjZkRPaHJVd3JX?=
 =?utf-8?B?RSt5c201QUZnUmJwcjZKRS9yU3VDcWNiVnJlMmkvSjUxV1VyOW1PaDBsN0FH?=
 =?utf-8?B?UUdORDQremdqK0lHVjhpQVU2M0pYN09VU2U0RkFPbG14bVlnQkxSNFdKZlJz?=
 =?utf-8?B?SElBMXJXVWJ3Ykl6VkRFQVdsVHpMMUtYV20rRHhYMU5EVXJ1T3dWYjMrTTN2?=
 =?utf-8?B?TTVjTjRCc2hMeWFSL0ZNaWZ4WWJLNFJ4aVB5YzFOSytPQTRBT24yY3VVK2tO?=
 =?utf-8?B?Rm5LRmdiY1FFR0JaTlVqcUNtSkp2dFFjOGRYOUcrclg1WUI4N25rU1hVaysz?=
 =?utf-8?B?dXpnbU54ZDRrMlQ4VVNQbmtKMW01cGthSWRBVUF0Qnl5UzVBeHJJclRDUUVF?=
 =?utf-8?B?S1F4alVGcmhtSUlweTlFRXh6dUZNMzZNUmh3OHp5aXlYMkNFb0M4bm93aXZl?=
 =?utf-8?B?MGJZVHMraXN5aUFTRnZqM2xMSDY3NVNaVEJhN28xNlBjY1JBM1QwNHBCdEtq?=
 =?utf-8?B?SzY0R3puVjJuSnhyMTJzMi9oYnA5UlJET0pZKzF2Y2kzb2FTT3VIcUVUZTBQ?=
 =?utf-8?B?ZE1ic2pJckY3bW1hOWRQTUc4dDRQdWpBQzBoU2cyVC9BRmE2d3ZSQmZDMHFH?=
 =?utf-8?B?WGUvaGV0aS95UTc2TFcvWTN6NSs4OHY3MEZjRlRPV25Kdmhsay90WjYrWjhu?=
 =?utf-8?B?VlFsSE9mT0I5QlhVZDBhczhoZC9jK0h0cXpGVHFxcWkrZEJhcjMreU54TUNw?=
 =?utf-8?Q?oavxqjs+8uCtY23V7MdS2lA=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR15MB5821.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f47c91a-cc9a-4d43-afd9-08ddf226a5b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2025 18:03:15.8897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QAbzExBU2UfYHj6U00H864zoyQueLdonnwXGjOYuKkqx2NIT7Zz67YEtD2JtVVfsgt4vZ7I20kRobDzjuzu0AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5818
X-Proofpoint-ORIG-GUID: cCuRLi-tDJscVuuHk6A4Zy5GddrU8fFu
X-Proofpoint-GUID: P2e-cyH41z4Dee0BgKIAe6fpYEA1DDjC
X-Authority-Analysis: v=2.4 cv=EYDIQOmC c=1 sm=1 tr=0 ts=68c4606a cx=c_pps
 a=PuJdnknN+GvnnVP6qVLFMA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=4u6H09k7AAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8
 a=1SHZ0DTFgFYrjABfHmkA:9 a=QEXdDO2ut3YA:10 a=5yerskEF2kbSkDMynNst:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyMCBTYWx0ZWRfX3UiKStvUmU0I
 K5nxa5p26pYqpIb9l0PJtL+Tw+5qfL9CkuBLcIebogI8oD6btXYqSVnwD6MX9Kt9Nm+pJsoZaZ3
 0haOMLmPATceLCIRgWJDG3pMGMoDD2U3aBhuvqF4PrlP8QPAoBd2J5MmHkR7Y6NvTPNaGZPBGOe
 oarF/Mk2sMkG0IW/9puDFvjO1HZ9/zn6usDsN4mj8XS9NsiTlHHw6BKNzIVEziVnGcqccL3Fnc7
 QeiMgnZ9Lk/vuWE0CT3srGjFwm3vR59s3MRqerTb1tvrIaBPwSyShDpi4VEsKvEWH9fWYAUP+p+
 Uav7HG93KA7rTv0DGFnXGkilxKQu2VNtJu0cDs8BwiwRl7KlEw9h/V+TUfkSklONGfZJ27pQMPR
 wlSwmUhT
Content-Type: text/plain; charset="utf-8"
Content-ID: <9ACAAE7AAE691C4689E769E1F3A69350@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: RE: [PATCH v4] ceph: Fix multifs mds auth caps issue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_06,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=2 engine=8.19.0-2507300000 definitions=main-2509060020

On Fri, 2025-09-12 at 12:25 +0530, Kotresh Hiremath Ravishankar wrote:
> On Fri, Sep 12, 2025 at 12:46=E2=80=AFAM Viacheslav Dubeyko
> <Slava.Dubeyko@ibm.com> wrote:
> >=20
> > On Thu, 2025-09-11 at 15:02 +0530, khiremat@redhat.com wrote:
> > > From: Kotresh HR <khiremat@redhat.com>
> > >=20
> > > The mds auth caps check should also validate the
> > > fsname along with the associated caps. Not doing
> > > so would result in applying the mds auth caps of
> > > one fs on to the other fs in a multifs ceph cluster.
> > > The bug causes multiple issues w.r.t user
> > > authentication, following is one such example.
> > >=20
> > > Steps to Reproduce (on vstart cluster):
> > > 1. Create two file systems in a cluster, say 'fsname1' and 'fsname2'
> > > 2. Authorize read only permission to the user 'client.usr' on fs 'fsn=
ame1'
> > >     $ceph fs authorize fsname1 client.usr / r
> > > 3. Authorize read and write permission to the same user 'client.usr' =
on fs 'fsname2'
> > >     $ceph fs authorize fsname2 client.usr / rw
> > > 4. Update the keyring
> > >     $ceph auth get client.usr >> ./keyring
> > >=20
> > > With above permssions for the user 'client.usr', following is the
> > > expectation.
> > >   a. The 'client.usr' should be able to only read the contents
> > >      and not allowed to create or delete files on file system 'fsname=
1'.
> > >   b. The 'client.usr' should be able to read/write on file system 'fs=
name2'.
> > >=20
> > > But, with this bug, the 'client.usr' is allowed to read/write on file
> > > system 'fsname1'. See below.
> > >=20
> > > 5. Mount the file system 'fsname1' with the user 'client.usr'
> > >      $sudo bin/mount.ceph usr@.fsname1=3D/ /kmnt_fsname1_usr/
> > > 6. Try creating a file on file system 'fsname1' with user 'client.usr=
'. This
> > >    should fail but passes with this bug.
> > >      $touch /kmnt_fsname1_usr/file1
> > > 7. Mount the file system 'fsname1' with the user 'client.admin' and c=
reate a
> > >    file.
> > >      $sudo bin/mount.ceph admin@.fsname1=3D/ /kmnt_fsname1_admin
> > >      $echo "data" > /kmnt_fsname1_admin/admin_file1
> > > 8. Try removing an existing file on file system 'fsname1' with the us=
er
> > >    'client.usr'. This shoudn't succeed but succeeds with the bug.
> > >      $rm -f /kmnt_fsname1_usr/admin_file1
> > >=20
> > > For more information, please take a look at the corresponding mds/fus=
e patch
> > > and tests added by looking into the tracker mentioned below.
> > >=20
> > > v2: Fix a possible null dereference in doutc
> > > v3: Don't store fsname from mdsmap, validate against
> > >     ceph_mount_options's fsname and use it
> > > v4: Code refactor, better warning message and
> > >     fix possible compiler warning
> > >=20
> > > URL: https://tracker.ceph.com/issues/72167 =20
> > > Signed-off-by: Kotresh HR <khiremat@redhat.com>
> > > ---
> > >  fs/ceph/mds_client.c |  8 ++++++++
> > >  fs/ceph/mdsmap.c     | 13 ++++++++++++-
> > >  fs/ceph/super.c      | 14 --------------
> > >  fs/ceph/super.h      | 14 ++++++++++++++
> > >  4 files changed, 34 insertions(+), 15 deletions(-)
> > >=20
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index 179130948041..97f9de888713 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -5689,11 +5689,19 @@ static int ceph_mds_auth_match(struct ceph_md=
s_client *mdsc,
> > >       u32 caller_uid =3D from_kuid(&init_user_ns, cred->fsuid);
> > >       u32 caller_gid =3D from_kgid(&init_user_ns, cred->fsgid);
> > >       struct ceph_client *cl =3D mdsc->fsc->client;
> > > +     const char *fs_name =3D mdsc->fsc->mount_options->mds_namespace;
> > >       const char *spath =3D mdsc->fsc->mount_options->server_path;
> > >       bool gid_matched =3D false;
> > >       u32 gid, tlen, len;
> > >       int i, j;
> > >=20
> > > +     doutc(cl, "fsname check fs_name=3D%s  match.fs_name=3D%s\n",
> > > +           fs_name, auth->match.fs_name ? auth->match.fs_name : "");
> > > +     if (auth->match.fs_name && strcmp(auth->match.fs_name, fs_name)=
) {
> > > +             /* fsname check failed, try next one */
> >=20
> > I am still thinking that "check failed" sounds too strong here. Names s=
imply
> > don't match to each others and we need to check next one. But "check fa=
iled"
> > sounds like error condition but not the normal flow. Potentially, I use=
d the
> > word "fail" too frequently for commenting the error conditions. :)
>=20
> Yeah, 'fsname mismatch, try next one' is a better choice. Please feel free
> to change that while you submit.
>=20

Sounds good.

> >=20
> > > +             return 0;
> > > +     }
> > > +
> > >       doutc(cl, "match.uid %lld\n", auth->match.uid);
> > >       if (auth->match.uid !=3D MDS_AUTH_UID_ANY) {
> > >               if (auth->match.uid !=3D caller_uid)
> > > diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> > > index 8109aba66e02..de457470d07c 100644
> > > --- a/fs/ceph/mdsmap.c
> > > +++ b/fs/ceph/mdsmap.c
> > > @@ -353,10 +353,21 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct c=
eph_mds_client *mdsc, void **p,
> > >               __decode_and_drop_type(p, end, u8, bad_ext);
> > >       }
> > >       if (mdsmap_ev >=3D 8) {
> > > +             u32 fsname_len;
> > >               /* enabled */
> > >               ceph_decode_8_safe(p, end, m->m_enabled, bad_ext);
> > >               /* fs_name */
> > > -             ceph_decode_skip_string(p, end, bad_ext);
> > > +             ceph_decode_32_safe(p, end, fsname_len, bad_ext);
> > > +
> > > +             /* validate fsname against mds_namespace */
> > > +             if (!namespace_equals(mdsc->fsc->mount_options, (const =
char *)*p, fsname_len)) {
> > > +                     pr_warn_client(cl, "fsname %*pE doesn't match m=
ds_namespace %s\n",
> > > +                                    (int)fsname_len, (char *)*p,
> > > +                                    mdsc->fsc->mount_options->mds_na=
mespace);
> > > +                     goto bad;
> > > +             }
> > > +             // skip fsname after validation
> > > +             ceph_decode_skip_n(p, end, fsname_len, bad);
> > >       }
> > >       /* damaged */
> > >       if (mdsmap_ev >=3D 9) {
> > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > index 0e6787501b2f..2c6c45b2056d 100644
> > > --- a/fs/ceph/super.c
> > > +++ b/fs/ceph/super.c
> > > @@ -246,20 +246,6 @@ static void canonicalize_path(char *path)
> > >       path[j] =3D '\0';
> > >  }
> > >=20
> > > -/*
> > > - * Check if the mds namespace in ceph_mount_options matches
> > > - * the passed in namespace string. First time match (when
> > > - * ->mds_namespace is NULL) is treated specially, since
> > > - * ->mds_namespace needs to be initialized by the caller.
> > > - */
> > > -static int namespace_equals(struct ceph_mount_options *fsopt,
> > > -                         const char *namespace, size_t len)
> > > -{
> > > -     return !(fsopt->mds_namespace &&
> > > -              (strlen(fsopt->mds_namespace) !=3D len ||
> > > -               strncmp(fsopt->mds_namespace, namespace, len)));
> > > -}
> > > -
> > >  static int ceph_parse_old_source(const char *dev_name, const char *d=
ev_name_end,
> > >                                struct fs_context *fc)
> > >  {
> > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > index 8cba1ce3b8b0..bb992f12e3b0 100644
> > > --- a/fs/ceph/super.h
> > > +++ b/fs/ceph/super.h
> > > @@ -104,6 +104,20 @@ struct ceph_mount_options {
> > >       struct fscrypt_dummy_policy dummy_enc_policy;
> > >  };
> > >=20
> > > +/*
> > > + * Check if the mds namespace in ceph_mount_options matches
> > > + * the passed in namespace string. First time match (when
> > > + * ->mds_namespace is NULL) is treated specially, since
> > > + * ->mds_namespace needs to be initialized by the caller.
> > > + */
> > > +static inline int namespace_equals(struct ceph_mount_options *fsopt,
> > > +                                const char *namespace, size_t len)
> > > +{
> > > +     return !(fsopt->mds_namespace &&
> > > +              (strlen(fsopt->mds_namespace) !=3D len ||
> > > +               strncmp(fsopt->mds_namespace, namespace, len)));
> > > +}
> > > +
> > >  /* mount state */
> > >  enum {
> > >       CEPH_MOUNT_MOUNTING,
> >=20
> > Looks good.
> >=20
> > Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> >=20
> > Let me run xfstests on your patch. I'll be back with the results ASAP.
> >=20

The xfstests has finished successfully. I don't see any regression.

Tested-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

Thanks,
Slava.

