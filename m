Return-Path: <ceph-devel+bounces-3491-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CE53B3AA92
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 21:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37B13562914
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 19:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A03BE326D50;
	Thu, 28 Aug 2025 19:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bfxkVVbz"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E6325BEF8
	for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 19:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756408119; cv=fail; b=rC2aFt2m7IWqGhKbPkPpFua6xdo9+lI2SJQpCyW58mI4rqtZZtCNYUrXd3f91aPgxoYvNR5iAtIBFCeLTXJlAXzp8UcvnEDCYwJjQGsJjt7NawJjylWoz1ulv3BmbT/zN3gwH9H1kjrqcAv3QdHHjcI7Re5iOtd/aI0S+NEXapQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756408119; c=relaxed/simple;
	bh=zdRHi6ykGPxF6IghnbmlQfljbFgrlOQrnolnq2Fe7j0=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=Bh+CxzxPJt9XdMORN0Rj5dWE80JidAotELkkKA+mv44e8gceeXq+dMcM4LrnA9sBcvpOSlee9OC+NQJq2h67Z19856yw+FXZUa3iww4EWIt8NSYfR/8aB3gyhJcrJ1CCswlY5tmB58+XT8ltlBo9SGsbAsN8n2u5lDTjBCS+jXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bfxkVVbz; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SIbjGX010495
	for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 19:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=noLHD50Z2mL4UomkDkTJ7CyWPygir/PfVLI8oPYvIKw=; b=bfxkVVbz
	zbCCaTCn+eLTeXdRO6awGhk9BUxa/kT10/pPuvVe/qNXx24ndgPveGNyd/6a5wyn
	CZhji/wVpRFMGA7cHzdp+nm48wYYvfiX1+K83JJiSruUKuxgcWURwCYjgrLY2Klj
	brEgB+gW/ahtNIQ8R4KG9JRul2y5Ie0UwpG/yGe89nANUfClZxjoxi9kaXZvdkhy
	XFlCmpOGeiPQdKb98/t7kFP9sPAmGIO7Ev1ay9ZB9M37psybfpLPw2HAj6wApvXG
	y0h5dVv35zC2JkjM2yb1TbnUIap8nFbZgZn8Q57EvEIJPVZ8LAGeWMF2ufrU3VX/
	TIPr97kXKNgKMw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48s7rw6u7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 19:08:36 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57SJ8aGe026931
	for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 19:08:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48s7rw6u7r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Aug 2025 19:08:35 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57SJ8ZlC026922;
	Thu, 28 Aug 2025 19:08:35 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48s7rw6u7p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Aug 2025 19:08:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mgfoiwsneo5LqwfEMY9/ffAUFlEtusuD03fy/nlghLvykEWOfg1cSvvOsfGTOlyWNc4Jn3eOw2Vim2aavlLdBlzS6vJPxax0vpkAD2bXkscrHwtBf07i/19YcC1AlqOiQLuznD9St7UTbkxV+08S2kkQbYk4cmocOy7s4gUnBuTvvF9gYsR5kTOGns1qcsPZdH5UIgndx4qBq+EC/ohk1LzAFf07TrKYypt2CR14THcBy4qPGpeoCAgeR7WLxNp7CqOCDXVRo24waLkz2NlaIuhrZUZdUzo7eOYLx0jxOJXnUZHWH4SnPE/tTJvQQYh1BpUwuNdbUEY1/L7MLuHcrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YV0Qi4S4WOaZwiydlvYZ4VKISPgkl2+UgEP5+YComwo=;
 b=MfW6F2aj2NAQRQ+dmTB3sEA2vXwmH8jfGz0daXRQ7gQT8XTHV6Y47QXzNEp5LUI4Q1fX3Gc8eQSPoZvI/CwqCu2ijZnBjptmyqSvh95JdjeqCG8iDqONtLmZgZUntRvWzp4nQ+pnxZJzco9ORi1y+DFNCPH3mivGpPWNFDAfjIOGmBW2GEc12UYPeCHTNZOm42LiqkwBmGWGItWpkiPJkRGK2Mlle10QteSloInH3iK37EHMBdIz9NND4wTA6MDAtIhva8VMnjoOmTRlO2xdsnMcc4XQZGwk40MRMmDRIo3Z6L8Z+I15QdO1KdRLcaWOeJmCdRuUW+/v1G/zEShUGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH0PR15MB4926.namprd15.prod.outlook.com (2603:10b6:510:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Thu, 28 Aug
 2025 19:08:27 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9031.023; Thu, 28 Aug 2025
 19:08:27 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "idryomov@gmail.com" <idryomov@gmail.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "max.kellermann@ionos.com" <max.kellermann@ionos.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Xiubo Li
	<xiubli@redhat.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Alex Markuze <amarkuze@redhat.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] fs/ceph/addr: always call
 ceph_shift_unused_folios_left()
Thread-Index: AQHcGE64qoYmawrjLUelljJPwcgz5rR4baUA
Date: Thu, 28 Aug 2025 19:08:27 +0000
Message-ID: <9af154da6bc21654135631d1b5040dcdb97d9e3f.camel@ibm.com>
References: <20250827181708.314248-1-max.kellermann@ionos.com>
		 <791306ab6884aa732c58ccabd9b89e3fd92d2cb0.camel@ibm.com>
	 <CAOi1vP_pCbVJFG4DqLWGmc6tfzcHvOADt75rryEyaMjtuggcUA@mail.gmail.com>
In-Reply-To:
 <CAOi1vP_pCbVJFG4DqLWGmc6tfzcHvOADt75rryEyaMjtuggcUA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH0PR15MB4926:EE_
x-ms-office365-filtering-correlation-id: 54d4fe37-2a4a-4a23-999c-08dde666450e
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VHRvd1FOSUdSZWtnYktiZHJJdHZIcUhhWGJwa2lhYVZxOStCZzlwd05BbjY1?=
 =?utf-8?B?eG5jMmd4SWZhcWZVWDlER2FvbmZ4S2lyMmlnZklIZnpIUEFGVHJ6T3J1YnN1?=
 =?utf-8?B?VGZIc0R3Nm02S1I1SjNHMkhCMU1qMTlmRWZ2UktnVEVVOXBPSDU5a2RkTnln?=
 =?utf-8?B?cGw0QXNDdW10dVNVMm5WYlFJQ3E5cExxR1N2WjVzVEMrS0cyOTVvSm56NUVK?=
 =?utf-8?B?VU5HUkFSZWRvMG1xL0dPcmxIc0hBU3N6UVpoWGR5RVR3TUVWNjFobkI4Q0x5?=
 =?utf-8?B?V2dZNXcwR0tDaG82dEVTQ1FNaVNTMVFpUWtWV0pWeUF4K0t6SGtkTWtBSlBo?=
 =?utf-8?B?Ynp2U0dkVVVCeGFnUkR1OVV3anJCOFVsYzlvaGZVRklycjVRcHRBZWg1Wmx0?=
 =?utf-8?B?c2pzWG82UmhXNWM1dDdEQ3ZURHFwMVFwd1J0MDVmK1lVdkM5YW01WXFWQUwr?=
 =?utf-8?B?RmwraGh0a1pMWWtGc3UrVk01S2hqbWVtUnZJMGJEaWYwNzd5YUNSdDUySjV6?=
 =?utf-8?B?V2NncERlZmpNUU11aVNEUHBIUTF0bmZNMnkvOE4yS2Fvc0NtbkNvMDZLV2NI?=
 =?utf-8?B?QXd6UEhpcHUweE16QW5PWlNQSGEreXJiSlJnUS84bVp1WmRkM1dnZzI5c3Z3?=
 =?utf-8?B?VFpOdkN2Q3IyQzdCc004RjJOK2ZkZjd2OTV5cG1VcjAwNzBmTmhYN3hyMVpT?=
 =?utf-8?B?cXM1dXE2YUNEbXVwdWVFWm5FampGd2d0R0JzcVc2bUl3aWs3dmxKVlVIZE9G?=
 =?utf-8?B?T1JLS0tGQjUyTGw2cFVnMXpjWjRTK2hJRFdQTXBTenpzNExlWlJmeW9KQ3lz?=
 =?utf-8?B?V2w3dXdFSzM0SHRmVVh5VS9TWmRFMmNMazd5NUd5VThLcjFqTFRCRUVVWWdh?=
 =?utf-8?B?TGVYVjJFUnlZLzd1NmZyVDFtZDFpUnRXdkszNlRRMGJwYWpFeFdIaStIK3li?=
 =?utf-8?B?UkFrQ1N6WFRvSUYxT0lDeUF5cFBkNUlKd2R2TWZIQTlRem54ZmRBVHJzM1dY?=
 =?utf-8?B?dG5iVWNQSzVOZm9oZUt0QVBIZTBHYm94NGhZZDNMZERsYTREYWNMOEUyNWRE?=
 =?utf-8?B?L0h6VXEvWmdGT0ZlaUprdjVDR01jdnZDSkMvOHV5WE9JV1ZMUlNSN1R1L3RW?=
 =?utf-8?B?S1RhL3FIQzZ5V0JCRkhsV0tEdVhUQ1RPZUh2aWVDTUxqclptSzM1SWhVREhp?=
 =?utf-8?B?OFVPWDAwRFZGZVhlRml0V1l1S3g4TllPSVBNUWFXdEs3VElmK2Z0U0h5c1E0?=
 =?utf-8?B?V3Z4cEVPUVN2Y0ozSjdySy9xaWpxRFdSRndsS295UVVjaHk5em4rWjRKaXFj?=
 =?utf-8?B?L0pHazVPaXFsdXhpU25CQloyN21wbVVwRk1zN294QmFSR2pPUWZ6ajZPc3Nv?=
 =?utf-8?B?OGMxQlY0ZEovK3hxNldEUGJVMmNUT3pPcGtyRmNvRXlyTTBBa1llV2RaWVgv?=
 =?utf-8?B?VVJNWnp5TytaNkFpV3lscll1T1U0ZmVIUWQ0TC9sYkpYeFFIczlzSFU4Ykda?=
 =?utf-8?B?VFlBMWc5UGZJUE1ZUkxpRGhsTjJxbFhERUoxaWorR09pK09idklSRm1YRmhk?=
 =?utf-8?B?NVN3S2l4cEtGUGI3Z3BiSXl1QmxaT0kxV3BEOGpMdi9NSG1sL2FlZUhMSWgv?=
 =?utf-8?B?Yzc0UHFMNkdZNm1PZDlkMVlrZkNlclZKMktUL2o5dTJRanJKU05QTWNwTDlw?=
 =?utf-8?B?c1hmRDBGQ2JqS0F3cTVxc2llRlV3OUc2eXdIMnAvdVdyK3ZIUEFmT25KenpR?=
 =?utf-8?B?dnQwR2l4QWVEUTQyaHZwSFkvRk5mV1QwSmhsNEZUbXVkRTduWGdyUnhGRXZM?=
 =?utf-8?B?OFp4TzBscUVPMHVrMUVWb2lEWkljRHExNDRUSnQ3Z1o0RTZkRFRxRlkydmVE?=
 =?utf-8?B?aWRRZ3VQbEJXbEZmZFJyajhJZXNkYzhrdXVkWTJZNWc0NkdId25HSE50UjU0?=
 =?utf-8?B?T21zNXYyR2NDWjJiRHdlUU1seWhXNEJ3cXNPVmtpei9QMjFFK2xJajZ5RDFx?=
 =?utf-8?Q?mmm0CKV2f5IJlPrEGjI6FLcZ1ZBle8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TUtDdnpBbDEyVTdjWitYTy9lMVZ4UHhYOWVUeXkvQ2dTSmRHcGxHd0Z5RERt?=
 =?utf-8?B?SGFmOHBjQ0FIWjYrenNqVlFCd0Rxb25jTWhYYXBKbXpxeWxGc25HYUtXM1hB?=
 =?utf-8?B?NTJqZzZQc3lYUG9ObHM1cXdKVUtZMHhOVmNoWG9XQU1pKzB4YndwdzVpNWFi?=
 =?utf-8?B?cWQ0cCtEbENHL1VBUk1TdG1heXVIbEJQYWlqTGRWRG14MjVjanJVRGZybWIw?=
 =?utf-8?B?VmlUanhueFNIaUM5U1lmTkJTcXo1bkg3RzQ2b2YzQ2I0VVViZ3ZSaXNQRmxX?=
 =?utf-8?B?akxOMExsTHF5ODBkaHUzL3FJQlBqUXc0M3dLM2dWTmJPak1scDBnTHFWclZk?=
 =?utf-8?B?enBEQzlIMENHRVIrNXVramprL3FRSXhqU0xtZko3TGxUTjh4cXdIWmQzYTBu?=
 =?utf-8?B?d2JySWFYaGkwc2dGcmxxSzI3MGdsSWszSFpiTmhNcXFXUWwvemVCNjBQc2dU?=
 =?utf-8?B?MGtidDhtYWdJUk1hWFkveTJJV1hJZnFjblF0K1RWb0xRNXcvejR5UnExcDFL?=
 =?utf-8?B?UmlNU3hZeHZzMVc2UWJSN1RndWtleTltd3llOFBpY0wrek9za0dqZ0hVcFFm?=
 =?utf-8?B?TytUV0tucm1yclBwNE1lREN0ZGxCd2YzdnUwa2ZnQmE5U0FZRlNwU1h0bWt0?=
 =?utf-8?B?bXNSUUFBQlQ2Y0EzVHdsSjRzNDUvVHlMVmFqUktFRE9qeG01a21RUnpWdC93?=
 =?utf-8?B?c0sybTVkaGFwYXhwOVRvN1VyK01IREE2TCs5Y3h1b3ozbmUvWGsyUzREdlZ5?=
 =?utf-8?B?TlQybTZsUC9wUHpkbEJ3RTQ4cTRHYVhqamRHVXZ3SEc5U1RjejZqc0lGZ1Bs?=
 =?utf-8?B?RnVqcjBMVVZpbGVycVNMMm1RWTVOZG8zTWE3VlQvVGk0SFE1TUo5MGF3Mzdn?=
 =?utf-8?B?bkxGYkt1K2lSZjBoWE9iakQyQm5WZlpCaDE2VkQ1ZjV1ZmlTRUU2UHRVR2tZ?=
 =?utf-8?B?T2lFMWxYNXVJam10RFVISDBiZE5lait1UllEdnB0S09HcmRYcUxoSTVzYlZZ?=
 =?utf-8?B?eFdTM1ZlNFB4SFMxTUxkUVVXWjluNXZXZFRCTDVxaE1jdmhNVm8wNm9lcmNT?=
 =?utf-8?B?QU1pZllZeFJrb1lCZmN0OFFhQnlQZnpINVdLU1lwNDJlOUtHeTdaQU5tSFN0?=
 =?utf-8?B?bklCaVM0L0N4Ulh5SGhPc3ZEN2lpL1lhRW4vanV3OVZxdklQaFhiYmN2VWpO?=
 =?utf-8?B?REU0a2pnQU5WaWpKMWNPM0tYY3diOTFsZkt0NkFxaGFjV0EveXBObDlkTjBM?=
 =?utf-8?B?cW1NRHFTM3NLNFBURXpNR2ppMVBlaGVtSWpXK2V1SlFGYWxLUERwaWJCTzBB?=
 =?utf-8?B?cEdqN0JiN0toVjdHZXVjWUtzdHR2MmZac1VoN0dnL1VpVVNPa2lTMUZYUkM5?=
 =?utf-8?B?dzg0UGxsUUNHT0JvajVaaml2MGZuTHdObFRSWjlLSHkvR1dqRjNlV0toM25Q?=
 =?utf-8?B?RWFtTWFUVFZWcmIrREdsWE1VTFlUdGhVS1ZPWTJrNUdXODB0RjRoMmxJb2Nv?=
 =?utf-8?B?M0VhUE40b0VjNWRjZ05KTEphR1E0a2ZZaEFMUXJ3NXBmSjJyR3FrYXlsQWtx?=
 =?utf-8?B?YkZqZDRiK3R0R1c0cHEvaEZxSVdBbUxOYVZrN0lFSmphYlhvR2F1cTd3aGwy?=
 =?utf-8?B?QW5HWVZmMUZ2bGFydHZ3TXpqMXpCR3UwV2JFYmxWZW5GYnVHVWI3QmgzcXp1?=
 =?utf-8?B?LzQxMWM4NUxFMXowQUpRTVpDQjVmaE12aHdQSDU0bXdENytqY2RXWWZpdklW?=
 =?utf-8?B?SXIyRlY3cjRlL3ByNUdqVFYrUUFMdUMzY2xaRnFTVjI1L093dTFHc2VHNVJC?=
 =?utf-8?B?cHlaeHBmWlVkTkFITW04SUJnbngzQWV6d0tEOG9vNEVhZStmb2xPS1liYTlW?=
 =?utf-8?B?aktIdlEwMTdDTkh4QkF6ZkJBUjlpL2pLT09UdmlIZTBIV2VFMGZsRnFaME94?=
 =?utf-8?B?YXVLdjVPM1ZuY09ab3hibE1GVzJFcTVEdlROZXEwa3hjNVdzZUJUMTNPeVZ4?=
 =?utf-8?B?SmthZ04yMzJDQm1sbzJoTzMvNWpGdVRUbmc4c3FUUlZ5UGQ2d0lqb2hnMFFK?=
 =?utf-8?B?OVRpLy9WQUVPY29sU2dhcjlBbzMwNDVaWjQ4ZWFDRElHNVd0T0tWaG1qRjlM?=
 =?utf-8?B?Q0dKRERjK29BZ1o2cktpQ1IxbGhBZktTREFHV2RqaTk4TFUzdUtZczNtZFc3?=
 =?utf-8?Q?yltJtTU63fpyPq3Cz6xct54=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d4fe37-2a4a-4a23-999c-08dde666450e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 19:08:27.5751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RPwMHyTMV/8QcA+CFxgRBW+mJQ3sKzzmYqhcPB0aeecZFBDZqhLi9Zw61vE1s3H73j43scDPSG8Jt+EumpqUig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4926
X-Proofpoint-ORIG-GUID: t0z4yCKErzwG-nTgHJZqsgPKaoVLM9_X
X-Authority-Analysis: v=2.4 cv=fbCty1QF c=1 sm=1 tr=0 ts=68b0a933 cx=c_pps
 a=NmDNviYhsTavHyS1iw/olw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=UgJECxHJAAAA:8 a=VnNF1IyMAAAA:8
 a=GuK08OZpwnMSjZ4j7VUA:9 a=QEXdDO2ut3YA:10 a=-El7cUbtino8hM1DCn8D:22
X-Proofpoint-GUID: 2-VgS9xlGfatSpe2SmaUJXRGYfL88g1Z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI2MDA1NSBTYWx0ZWRfXxauoV+QC8OrU
 xRy32nY0Cklr1Yy6OFDfpdxFxsQSUjg9xjnD9vRbtPjNgoW5szvnt+pHq65kdJUt+XUq0nOImDx
 JxZNE7XJYFXgvMR8Pm8eaoZokUKpCS0tRME/WXIIJMIoU3NlA6QYAvnHxJXskIHLEXYMTB+ZOz8
 mfkhCjUQhuYusgSiPC+08zoyYNFsrsYdYapR9kl+s994jH/ZbZOjWv0Nr1MGsXEcIrZUldw9+Tj
 zWOrW9C6m/k72v5qeRx9OTdT0aOm4kQIfejv3utdNeeRarhxR0UID/oV6YClfkOzePal/KCgvQ5
 s80a1t4QkrGysVzLklouPNaBZjbrKlEpKdRUkJ1YtmHDtDmZgWpQlJEhjV8XxeAbOfWPhrrlJHC
 cIwRcwXz
Content-Type: text/plain; charset="utf-8"
Content-ID: <D059172C19E7AC4AA8C59D681D35575B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: RE: [PATCH] fs/ceph/addr: always call ceph_shift_unused_folios_left()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=2 engine=8.19.0-2507300000 definitions=main-2508260055

On Thu, 2025-08-28 at 21:05 +0200, Ilya Dryomov wrote:
> On Thu, Aug 28, 2025 at 8:55=E2=80=AFPM Viacheslav Dubeyko
> <Slava.Dubeyko@ibm.com> wrote:
> >=20
> > On Wed, 2025-08-27 at 20:17 +0200, Max Kellermann wrote:
> > > The function ceph_process_folio_batch() sets folio_batch entries to
> > > NULL, which is an illegal state.  Before folio_batch_release() crashes
> > > due to this API violation, the function
> > > ceph_shift_unused_folios_left() is supposed to remove those NULLs from
> > > the array.
> > >=20
> > > However, since commit ce80b76dd327 ("ceph: introduce
> > > ceph_process_folio_batch() method"), this shifting doesn't happen
> > > anymore because the "for" loop got moved to
> > > ceph_process_folio_batch(), and now the `i` variable that remains in
> > > ceph_writepages_start() doesn't get incremented anymore, making the
> > > shifting effectively unreachable much of the time.
> > >=20
> > > Later, commit 1551ec61dc55 ("ceph: introduce ceph_submit_write()
> > > method") added more preconditions for doing the shift, replacing the
> > > `i` check (with something that is still just as broken):
> > >=20
> > > - if ceph_process_folio_batch() fails, shifting never happens
> > >=20
> > > - if ceph_move_dirty_page_in_page_array() was never called (because
> > >   ceph_process_folio_batch() has returned early for some of various
> > >   reasons), shifting never happens
> > >=20
> > > - if `processed_in_fbatch` is zero (because ceph_process_folio_batch()
> > >   has returned early for some of the reasons mentioned above or
> > >   because ceph_move_dirty_page_in_page_array() has failed), shifting
> > >   never happens
> > >=20
> > > Since those two commits, any problem in ceph_process_folio_batch()
> > > could crash the kernel, e.g. this way:
> > >=20
> > >  BUG: kernel NULL pointer dereference, address: 0000000000000034
> > >  #PF: supervisor write access in kernel mode
> > >  #PF: error_code(0x0002) - not-present page
> > >  PGD 0 P4D 0
> > >  Oops: Oops: 0002 [#1] SMP NOPTI
> > >  CPU: 172 UID: 0 PID: 2342707 Comm: kworker/u778:8 Not tainted 6.15.1=
0-cm4all1-es #714 NONE
> > >  Hardware name: Dell Inc. PowerEdge R7615/0G9DHV, BIOS 1.6.10 12/08/2=
023
> > >  Workqueue: writeback wb_workfn (flush-ceph-1)
> > >  RIP: 0010:folios_put_refs+0x85/0x140
> > >  Code: 83 c5 01 39 e8 7e 76 48 63 c5 49 8b 5c c4 08 b8 01 00 00 00 4d=
 85 ed 74 05 41 8b 44 ad 00 48 8b 15 b0 >
> > >  RSP: 0018:ffffb880af8db778 EFLAGS: 00010207
> > >  RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000003
> > >  RDX: ffffe377cc3b0000 RSI: 0000000000000000 RDI: ffffb880af8db8c0
> > >  RBP: 0000000000000000 R08: 000000000000007d R09: 000000000102b86f
> > >  R10: 0000000000000001 R11: 00000000000000ac R12: ffffb880af8db8c0
> > >  R13: 0000000000000000 R14: 0000000000000000 R15: ffff9bd262c97000
> > >  FS:  0000000000000000(0000) GS:ffff9c8efc303000(0000) knlGS:00000000=
00000000
> > >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > >  CR2: 0000000000000034 CR3: 0000000160958004 CR4: 0000000000770ef0
> > >  PKRU: 55555554
> > >  Call Trace:
> > >   <TASK>
> > >   ceph_writepages_start+0xeb9/0x1410
> > >=20
> > > The crash can be reproduced easily by changing the
> > > ceph_check_page_before_write() return value to `-E2BIG`.
> > >=20
> >=20
> > I cannot reproduce the crash/issue. If ceph_check_page_before_write() r=
eturns
> > `-E2BIG`, then nothing happens. There is no crush and no write operatio=
ns could
> > be processed by file system driver anymore. So, it doesn't look like re=
cipe to
> > reproduce the issue. I cannot confirm that the patch fixes the issue wi=
thout
> > clear way to reproduce the issue.
> >=20
> > Could you please provide more clear explanation of the issue reproducti=
on path?
>=20
> Hi Slava,
>=20
> Was this bit taken into account?
>=20
>   (Interestingly, the crash happens only if `huge_zero_folio` has
>   already been allocated; without `huge_zero_folio`,
>   is_huge_zero_folio(NULL) returns true and folios_put_refs() skips NULL
>   entries instead of dereferencing them.  That makes reproducing the bug
>   somewhat unreliable.  See
>   https://lore.kernel.org/20250826231626.218675-1-max.kellermann@ionos.co=
m =20
>   for a discussion of this detail.)
>=20
>=20
Hi Ilya,

And which practical step of actions do you see to repeat and reproduce it? =
:)

Thanks,
Slava.

