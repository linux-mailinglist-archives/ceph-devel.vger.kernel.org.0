Return-Path: <ceph-devel+bounces-4106-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 85185C82269
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 19:49:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6ADC04E061D
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 18:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0838372628;
	Mon, 24 Nov 2025 18:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="csJ4C2O4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366AB2BE053
	for <ceph-devel@vger.kernel.org>; Mon, 24 Nov 2025 18:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010171; cv=fail; b=ahcovvi/T7p5hCCs1xcdWOf6VshCjjpLT5qzKqpXCXUeGKlS5hMahS+p7uR47gX4wxMskUBNgIoc9/l50knpgbU3qlS/g91snJGYJ5NHOTA40y30n5rerI9FHiflhxTDoTJ5KoOsQvoBKZkSPkECg9/mcitNi+5YX5E1Vixy6yw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010171; c=relaxed/simple;
	bh=KEoOHBR10npk8RBCLaa2Fyv65WTwdMulphh6skVm/50=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=BomMcmtUlGracc9JPU50Eznk5kWZPdT7o6RPTe4S3w8doheJLJfLpqY8I4Rz2YutW8g1X7DNXSq73rsAhDa+uSBseQiecYCK/0dpzuzZxBwbRz+bjM6VWS2bOblnFZpPbvgmtW0iNn1sb7i/onFeB+vgB/DSSW7uUk/LMFVtdcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=csJ4C2O4; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO9b6Tg011986
	for <ceph-devel@vger.kernel.org>; Mon, 24 Nov 2025 18:49:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=KEoOHBR10npk8RBCLaa2Fyv65WTwdMulphh6skVm/50=; b=csJ4C2O4
	vJYzMCQXMQSf/Gy55TpMqE1xiqfCpuZbMWq1teiR56KlXCl8cK5rkpvNh0gBH4va
	t3dIRWB2j7LE4M8PFt/eHdv2vs86DVKT6r9/N3LvYeYerBmDmHd31tQvJxzOwzne
	Kd3xREF5zHAGk74TiBTMxvQirBd7fnQQ+NVPwX5jQyxDcVdiQmFwa8NfnzBqRi4K
	MzmlYfMMSt/qNdo7rrBa9A5bVRURqdbl81B83qssbSYFL+UEY280J9Gkn85xpLXe
	TqRsB6qQq1GWWIHtXbH/2DPvUvZkBJGKP5Hyvun5QJPWRuDTe+tL0LhE5Fys+Bqf
	G/RUHqqOJR05JA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4uv1pqu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Mon, 24 Nov 2025 18:49:29 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AOInKP7005349
	for <ceph-devel@vger.kernel.org>; Mon, 24 Nov 2025 18:49:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4uv1pqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 18:49:28 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AOInKP5005349;
	Mon, 24 Nov 2025 18:49:28 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010030.outbound.protection.outlook.com [40.93.198.30])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4uv1pqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 18:49:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JqNqWSewBrVgEnCCcIf/CQKKpD7SZzd3KRv+9GZ2MWByOv8YEZr2ckA5CkFuKnqcADGwMU4nvhUaMyaX/aIiBnZl1Lmes8ysvvKPb6OeRo4E10jWKU8Z4VoXfK0gjwJxxAOYDR1qYuVsyRBvjfXKJ49XA2D/L5Uab/WqO6Olc2phy+L/sRAN385Yjm91OldQO+6bfijmRNs+iXQRTLbRdKxtTr9Th4/TX4N5H+ndli0ngNEI9o5GD1QogP2dwtbLG3a/IMV9AvRhGfhIvN663+LzI/F02qxv8u5N+mTTiy4uSUrzpEGwwc/GGW5NmJ2j4gdPw1jiVmDYGv6THusXdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rswYLbiB4T9/fhmNF6LnGJD2Vf4EjfDLFkcXr2YFFDM=;
 b=ih0UeDa7cuc1Nwj5peKQ2yyAS07KnGGRrehtBdchzNsNmpSZPDcytCIqQXC1WGjZuDzmae7m8fsJAWU/FvEkCYZTFb3jU9f2Cj1BpEnBAGod/id00eqF5vkxrrpUl2diFVxGG8bg0rDB+jK5pfnaGbDS1dnXzpjiQR5lxaSr4ZwZt4v8LlPQesyk7Fq9TXGkdHrjjwtTFguvWXm+OfaMTCJ5CZJJ59gBRCEcf7CEuubUaX1rroIDq0ye3FVfXQICS6edoMtDKR6r8tL13wI5kx+fq2cMkGyEt8u9AGa95Sww40r+o32GosxL2XY6F8j34NozpJ+lrjOLbVjIGzcwQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CH4PR15MB6752.namprd15.prod.outlook.com (2603:10b6:610:230::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 18:49:26 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 18:49:26 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
CC: Xiubo Li <xiubli@redhat.com>,
        "justinstitt@google.com"
	<justinstitt@google.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "morbo@google.com" <morbo@google.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "nick.desaulniers+lkml@gmail.com"
	<nick.desaulniers+lkml@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH v1 1/1] ceph: Amend checking to fix `make
 W=1` build breakage
Thread-Index: AQHcUnpBY6YJKfAb+keetMdZm4Ts4LTsYAYAgBWjloCAACwegIAAD86AgAABn4A=
Date: Mon, 24 Nov 2025 18:49:26 +0000
Message-ID: <1ab8c386d50d024d0deb8a8c2fee501aae30909b.camel@ibm.com>
References: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
	 <9f7339a71c281e9f9e5b1ff34f7c277f62c89a69.camel@ibm.com>
	 <aRJASMinnNnUVc3Z@smile.fi.intel.com>
	 <c2805e34c4054bfa3308af0d18712e412f024ed6.camel@ibm.com>
	 <aSR1FU6uCqpOUFeb@smile.fi.intel.com>
	 <82c49caff875cc131951a7e5d59ecb45efbb9224.camel@ibm.com>
	 <aSSnWaDHK5Yyq_Ae@smile.fi.intel.com>
In-Reply-To: <aSSnWaDHK5Yyq_Ae@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CH4PR15MB6752:EE_
x-ms-office365-filtering-correlation-id: 83453000-86d4-4b27-e91d-08de2b8a3107
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|7416014|376014|366016|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?NjBMazNxcTBONFFJTUVmb2xkekJBYm43WW9UUmFLR3JOQjc2ZjZDdWdZSUdv?=
 =?utf-8?B?eFRzRi93MG8vK3hmZGlDSll4Qm1CaDVFQ1RuTDArWHZzS0Q0UkplaGZKRDcz?=
 =?utf-8?B?YW5Vb3RnYnhpUG9DNFpTNDRoRnhUd3RPekZjZ2twOGsxd0loNVlzOUxvMkJl?=
 =?utf-8?B?eTZtckV2M3BTaENSRFNFdVdEMUdmMEFqY29FVy85YzA1R1doQVZBYzdqWmwr?=
 =?utf-8?B?YnByN0NvMys0d3NleHYrMkJNZmVaMGdodkFzUlZ1ZytFaXZqQmhDeTBtS0s1?=
 =?utf-8?B?czZtNGJudFd4YlQ0TGZtN1g2dXY0bWxuaUFUaEdnaFQ3eGQzczU2dXd3MlVo?=
 =?utf-8?B?L2V2Ti9id05wZzYwSEV3bEU1Vi96b01saTdRb01SeWNuOEdlTko5MjBKODBy?=
 =?utf-8?B?ZUx6Y01MZ2pCR2YvTW1PV05Mek1maWhySGwvSVRyTTU0QXNIWHR3Vm9YY0dR?=
 =?utf-8?B?V3VLdTlnc2NJbWc3MkVQVVdra203N1FiMWJSZzBiMFgzL0h5MU01Mi9KNkt5?=
 =?utf-8?B?Nm01Q2xtc1dwWFNDZGhabklOTFY0Y0VySjRBQmY2ajJMQmxWSzNpNHZiODRN?=
 =?utf-8?B?ejlLcDNGWk1meVJIMGdFY3pGdFhqalVLRm1Lc3FWWVp4Rmh5UUhGdzBoalVh?=
 =?utf-8?B?Q1ZGa3hhTGgvQUlVL3JQT3ZHK216WkZIazhnRGNOUVViMUdkcjlXdmdVOE54?=
 =?utf-8?B?RGhuMUt1N2xpaEZIc051MGlXcFNpRkZOMGFlNWtvcDJhNkRLTGxkL29VdjZq?=
 =?utf-8?B?emJtRlkrVHp1UXBjYXRUWDJNQlR2b0JpdnRxWWgwYnVjRm5XWTE0c0pGQ3VF?=
 =?utf-8?B?SkI4VGdnOUVYSU50MS9BZmZURXpEUE1xWnVxaE1xMHdkR2JvekdZdE5rbmQv?=
 =?utf-8?B?K1o4dEl0bzI4cm1IbEp6YVEzRFo1cmIya1k2T3JmRWMzRFRHTmtXMi9WbUZI?=
 =?utf-8?B?SkZqWVllZUZXLzJFVTY0aFJKbUtGc1ZGY0ovVkpJQWlWN0F6ZmtZK3hsM1dv?=
 =?utf-8?B?eEVXN1UzZGUxc09DT3JLYXJOV3dZOVIySmREeDRUaW1qcjhBNUEvMklaR3Vm?=
 =?utf-8?B?Sy8wRU9vNG9PUWw1NENVTGdvYUZXREZDa3l1UisxTG8xb0dRN1Z0ak9raWt6?=
 =?utf-8?B?cXhxNEV0clQ2RzZ0a3BMVThqS2FWWTl0YWU4ZkNiMGhPa0VWd1E0N0JKK1pt?=
 =?utf-8?B?cmtCWWhjSDlxYXN2THYxWm92VTZWd0JtSVZ4bXBjMTJLTmJ2MzYrZ1RBeEh5?=
 =?utf-8?B?SVd1d1A1RzlocFdjTktoZk93OVViVnMxczlVaVI0TzBDTk1EYU50MUhZVjVi?=
 =?utf-8?B?ZVBVbEFqU2ZBVXFTTXNoTTg1ZUZXdHcrWGRQbVZDZmsyMktCUUtzV2lYb3lX?=
 =?utf-8?B?TGpDNjI2d2ZTd3BMR3VLem50VWs2VXF4akFJOXVvRThGU0NmSXU3dkVuVjZI?=
 =?utf-8?B?S1hZeENnYmZCNHZRQ1paWFN2VUJ3MmlHZGJQWERuK3pWSkkzRkNXU1RnZ3Iz?=
 =?utf-8?B?elVrWVk1RlJDYWtLem9lbERBVmsvNnAwaEpwRVRFWGtlK0xIT0NxaCt4NGRn?=
 =?utf-8?B?VUNvSkdqb2tNMUwyQUZHVk9XVkcxcGY5dUVMUFZITFJpeFpPQTZoOHlVWEtw?=
 =?utf-8?B?NUx2UjkyL3lnaytVVnd4ZW5CeW9OdFg5RldsMEhpS0NpdGVwRlVPVUNDK2Fy?=
 =?utf-8?B?NldKVnlrUnVma1Ivc243eXNlcDM2WGcxNVF1b3Fvckt4Snh1YU1oamYrOExq?=
 =?utf-8?B?azZVcFZmWnEyYzAxSWJnTEJOSUh5QXQxNS95a2laMFIxcnNibkhlTDlxUW5U?=
 =?utf-8?B?YUxRZUpPRXZqb3dUbTdlb2tjS21pSmNqOWZ6VzBSSGZ5ZFhsZnIxVk9UTHdQ?=
 =?utf-8?B?aUV0NlZVWW40VTRHU09WMzI3Wit0YUQxMTRUTGtmRmxvZ0VvQjJEaHBZbUhk?=
 =?utf-8?B?N2l1MGdqL1c0Y0FQZmRFeGV4QVU4YTJHSHNHcW9xN1k5ZVRpWFBQK1pqcFkr?=
 =?utf-8?B?bFhmWUluQ1dWTllacTdsSjM1U1ZMV1o1TEM1WG5hWGNRRUdDK21nWTk4Vkli?=
 =?utf-8?Q?GIyUa5?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(7416014)(376014)(366016)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SjQ3MnVMNGtHTkRIam56SGRaUm9XRFJzQ013N3ZQdFFBSEltYVBBZ2NYeFJq?=
 =?utf-8?B?UDJCSmMvS0w1R2hYdnQ1THlRdkZZSWtCQjRGYU9mSk9JUHdMc1ZQbjI5Smlj?=
 =?utf-8?B?eUd6aU5uYTNGYTBLclJkVG54VHlJcnh3cjRBQmNwcVc4a0tWSzZzdkNaZmRz?=
 =?utf-8?B?SlBncmhaUlhwc3ZuZDBqalhnWVh1NmpoWURWbm0yL1V3aXVraERVY0dtNnFZ?=
 =?utf-8?B?LzhodXBrV0NSalRjZ2wyQWpqN0R3Tm9mbDFBczFjWmUyOGp0bEQ1OElxREwv?=
 =?utf-8?B?d3ZkRVo4RlBZa1hEL2RsMU5sTUdKQ2FNcTRCS1RHeTZUM0VSTDllVUZ6YUNR?=
 =?utf-8?B?Si9YbUFKcUlqak5JMkx6RU9vYktaWTNZVGp6KzB1Z3oydHd1VTFMTEZkU0NS?=
 =?utf-8?B?NkhYd2wvTE9EVFYweFBTR3NBR2NHek9XRkx0MFpGSDE4Q0toSFNwVmtPZTNr?=
 =?utf-8?B?ajRkL3RxbEVRaThySUJIV29xYXVqOFJrcDZpSTgrZllmWEZTMG16cTJrbzZL?=
 =?utf-8?B?cVhUZnJXNFZFL20ybEZ0djROL2lBSExZdC91aElSVW1acEtTS2U2dDJYNUs1?=
 =?utf-8?B?QTM0a2pRdE81ditoUDQvNmdDRlM2VEhUUWNGa2hzUnhOZkNZNStqaGpWOWRZ?=
 =?utf-8?B?dEplbng4OGxEc0M2T0M5OSt5a1VOemF0ZnlFNVY1Z2c3dGpMMTB6S1I2cjcz?=
 =?utf-8?B?OGl0aXg5QW1kWE1kVkErT1VZZGNRY0lQWStZeDdmbGJWNERNSjdsNDNKeTdW?=
 =?utf-8?B?bmdVWGhySHFwenk0KzBpbFBtNGM5QlZTR3hxUGZzTk42clJoMUoxSS83OFlP?=
 =?utf-8?B?TXVWR2xvVVl6cE54MXJzcVBnZy9iVFNvY1VaYjZJRktEUjVBUWJPbHZOWVpy?=
 =?utf-8?B?aFFxSVVtYVZHNGVuc3cyNmhwOTVmQXlGZUxub2tUb1FmaFFPZlIvbTAxOUFm?=
 =?utf-8?B?ZjNKK3dUVFErTCtLdmN6MUEvVlk4clBzM09RS1ZUMGdsMlpmL0luN3VqSEli?=
 =?utf-8?B?ZnhiRnovd0NpY2hSdmJTQkY0NVc2aERYckJPUVNrMVZNZDM0SHFiVWlSZGxr?=
 =?utf-8?B?cUhXQ1Y4NUs1TldOSlhJN2JPYnpQa25CaktkcXo4cXNEeW9ONTF5cUdVa3J4?=
 =?utf-8?B?WDNwblcxK2R3WmVwSmhPTHRGSVFXRUN0SmcwWlJpTVRSRFhHdDdCem5Yd1Q2?=
 =?utf-8?B?Z3ZmYjFIbGRCMllnbU04blUxRHRYL3R1c0gvRHkzaE1tT1lwK3dCT1g4NEwr?=
 =?utf-8?B?ZnVhVE1HamxmTWkwc1Y0RTdKSTJaSXNpZVNXYkZLdVNza0U2SlRQV1hUeHhn?=
 =?utf-8?B?V1JLUVkvK2hKVG4zWmx5WkFEN2lhVDFyejJtUTIrNWtRUkhQcEFKTGRzU2VC?=
 =?utf-8?B?T0MybmRRTkNONk50SnJuVGcvSDBIMk9JcE1aZ0tEbFArRFpFcm5pWGs0c2Fs?=
 =?utf-8?B?QmF3aGQxYVVxOTMyeno1WmIvMXFNMDZxWVFaK3paNzIxWDhlNm9CaVRIdmcv?=
 =?utf-8?B?VGM0MEtiNkc5ei9WRmhHamRHaDU3NGZaVFY0V3FnRytzcjdpNDN4ZFlSVWpV?=
 =?utf-8?B?bmpvYXQ4U25LV2lRL2lyTENkeEVkZlk3aXpZd0EyVWZ4djNSajUyWm5XNkYr?=
 =?utf-8?B?WndXVFhPc1NSdWF6MVcydWRvWi9zcWJmUTQxK3FaTnBTR3VibWdpZXJYdW56?=
 =?utf-8?B?QXhZZU01NlNpYjJJekF1b2o1M1plVGtaSE93NkdsaXg5ZERYbmR6cUhZSG8v?=
 =?utf-8?B?MHplQnVpRFBYZGlpM2xsWm1LTTEyUzlPYU11R0Y1N3RtTjZHUUZTL0IzNnZD?=
 =?utf-8?B?T3k0OGMweDdlcDlwR1BIMjU3UFBZTHZuWjllcVhjOFd5QmFCbjYyaUJ0Z0pF?=
 =?utf-8?B?NU9NV2dFNjVaN2dZYUFsRXNEdmdYMkE2Wm9uWVF6R2lHM1BjK1c0S3Jxclgw?=
 =?utf-8?B?WTlYbUJGZCs0bjlTUWNEcVRxSDNhSzE0bUxxWm8wUDVrRTRaeDJvY0tUa3Rx?=
 =?utf-8?B?bFNVYlRvNzlYaFpWejNkL3ltK2dCOXU3eHdScHY1MzVScFFheWNZdFhKWUd3?=
 =?utf-8?B?WUFSdkg1aE9MWDMwZkFlU0FNRVdwaGtSeVRCT1Y0RWNha1JBeGI4Z3MvRXJj?=
 =?utf-8?B?eDliZ2xMRFh4VUpMeEErSWkxUUZ6VlIzZ1EvQXVRUFl2Nmx3c3d4KzdXTmpm?=
 =?utf-8?Q?T/5BKIBGFxagw94JbMcYxsA=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83453000-86d4-4b27-e91d-08de2b8a3107
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 18:49:26.1091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SD8PqUygg2WWDPDu/xTmaFHSvbTq3hDeui8I/dXoCNjO3JnOVO3Na5DdYTGHurY/vItuGFZSGDUJhZjej9N25w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR15MB6752
X-Authority-Analysis: v=2.4 cv=PLoCOPqC c=1 sm=1 tr=0 ts=6924a8b8 cx=c_pps
 a=RshLvFd9jIxZgmNOnSXiNQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=NEAV23lmAAAA:8 a=QyXUC8HyAAAA:8
 a=VnNF1IyMAAAA:8 a=PhIL6t262XIIjMocLUsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX0jKANt6FH0BT
 dS9w07tS2h+98b1QIOZpQuVo4x1jq3yG4NHkoMZl/cmGnv+cOyhvWAjVSzIQn52aVi98DSDavGP
 fThqynItKdMUqojJNiGUWE+PxqQ0a8AggYuEQqbFK+R1f9IPuvxWht2udB88e9PO5J2CyGpMtj4
 N05IPvQG2Yrz0BJyvW3TpZWAQE+N3yD6PpfksjLl+i4BzZeuZ2abZzRnaBqBZD3TKUNFsEL3YUB
 73fk5jlNpCHEno2StxI+/a0iGzu6dyJ0FrrBlBRQYk3X6Mbh6TB35aM9Qq3ATsjPhBfCfxhe9uW
 R8OiruuscsZ7uCPiF76SyOlnJNTsN9U7UOf9e/xu+s+XxJVu0E+NEg2nAPkn/ze65n8kX6EPQlb
 OVIPJZLBVb5gSREff9L7kt1Sd8vgEQ==
X-Proofpoint-ORIG-GUID: yOY4nop2vqE0Yc6GVnej84sw6KdLHecJ
X-Proofpoint-GUID: VkIff_3OW5w8PAwSDFDf29e0_2n4WrfW
Content-Type: text/plain; charset="utf-8"
Content-ID: <383C81C154B0254499F278CBDCB3A054@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: RE: [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build
 breakage
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_07,2025-11-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=2 engine=8.19.0-2510240000 definitions=main-2511220021

On Mon, 2025-11-24 at 20:43 +0200, andriy.shevchenko@linux.intel.com wrote:
> On Mon, Nov 24, 2025 at 05:47:04PM +0000, Viacheslav Dubeyko wrote:
> > On Mon, 2025-11-24 at 17:09 +0200, andriy.shevchenko@linux.intel.com wr=
ote:
> > > On Mon, Nov 10, 2025 at 08:42:13PM +0000, Viacheslav Dubeyko wrote:
> > > > On Mon, 2025-11-10 at 21:43 +0200, andriy.shevchenko@linux.intel.co=
m wrote:
>=20
> ...
>=20
> > > > I think we can take the patch as it. It looks good. Probably, it ma=
kes sense to
> > > > take a deeper look in the code on our side.
> > > >=20
> > > > Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> > >=20
> > > Thanks, can this be applied? My builds are still broken.
> >=20
> > The patchset has been applied on testing branch already [1].
>=20
> Thanks for the information. The Linux Next still has no that branch in.
> I recommend to write Stephen a message to include your testing branch or
> something like that into Linux Next, so it will get more test coverage.

It's not my personal branch. :) It's the branch that receives all new patch=
es
for CephFS kernel client and, usually, it is used for internal testing by C=
eph
team. Ilya gathers all patches from there and sends it upstream. So, we nee=
d to
ping Ilya. :)

Thanks,
Slava.

>=20
> > Ilya, when are we planning to send this patchset upstream?
>=20
> > [1] https://github.com/ceph/ceph-client.git =20


