Return-Path: <ceph-devel+bounces-3984-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 08259C49449
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 21:40:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 61E1D34A7AD
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 20:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5002F12C4;
	Mon, 10 Nov 2025 20:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="svU+fvHS"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E4C2F12CE;
	Mon, 10 Nov 2025 20:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762807200; cv=fail; b=IhgGdQ1WST90/5vwhJNbYegC4HXkq8MzXdks7hCmLiZc2710VgYX/reCwaMuAnRQVjzmupjPwyGPF7SA9ew6I8WrExISXrlQzS/FZHmYSvAP5haIODTPRqmYknqBuIcSfnrZfHEl1l8k/hNDbUATD+dWTznF8a/C4BFIfC0CXbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762807200; c=relaxed/simple;
	bh=HEQ6+T9AYTOsLJcujadSlpjWMdw4Or8TqO6DwHGgJmY=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=X61X2hmisFAgPGTviysSGgwflBhWqw7vq7CFmZvt/rDpC6J3XOpFCJ9tiKEEkMD02TPzpuIfTkzUFTethWoqVte8PGIo6Z7yAjIoeGUxp0xsNCLSIYS3GZTYZf1leya2wC8jmd1/BArEAt7JfcbJbLa8r/gzHFDOkz8x+tO7dMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=svU+fvHS; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AADR1kb014222;
	Mon, 10 Nov 2025 20:39:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=HEQ6+T9AYTOsLJcujadSlpjWMdw4Or8TqO6DwHGgJmY=; b=svU+fvHS
	5t3pnnD/rvDzpzs1uhM3t5ddAHmNiZOpgKrxH2pxrAP3JPutAh24BKiC3lEFJk4p
	nQyBy+VVLUqIqjRP0VzfLxhWZK+sxOlKyizh5nq8bNiM3Gd5zdZNVvCRbphwWlTd
	YshcTBnyKoRC6PA3xT8vNssQqX6JITlgTL34IOmfYw0v4X5nRXrtPfWTts+YdYld
	4ZseOuN5rAJ+u6kgaOlVKaiZIbyL07qrtYBDsQi6uE138amoE7WgaL0Q3MM7388c
	eqYq1ZCMmiJFsuAHJ3uZUdtcU0n8Uc4Lbtnhgv8BXQIFN7yQ1gjb1Jjsk2/OQhy8
	Eg+ILAbmBaz/2A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wc725vg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 20:39:52 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AAKdp3Z018709;
	Mon, 10 Nov 2025 20:39:51 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011054.outbound.protection.outlook.com [40.93.194.54])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wc725vc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 20:39:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sV1PBlqo+ebjnmP8yka0q2nGtxLnfLWxVw6h02MrnSoE7Ey/sk+PxGLgjSSLFNFPtZP2IecNGA84CKDGeCM8UC9/wAY0bSr8DmWcH8Fv+Di4LmVJhHNZnFueC4KQjN+lgJFz/kw11dR46wkvxoBfMiFADHwWRPF8OYETgYP8/NYW+fBqnAEwuaEvrcwm6ABCw26huMAkJbymLAGLR6tB7x/xtzmPyhOp3IYBBEG4L2jS4hVk7bTYZnvgczjHT3Zck3oLLqt+WpuH1ahnyBNX6Rf5zs+R51U/ddGJN2w3Wp0H+G7tFwpcP0Qnhvc3YDfppADNuxLYxQ78nHJgDHARiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEQ6+T9AYTOsLJcujadSlpjWMdw4Or8TqO6DwHGgJmY=;
 b=ghlnPqZRAn07mGJk9YKzQtALC3dcy0fzExsErctvdgnTvsutnuS/eU7WlIvbsH6/+RzxG6vkk5wD3rHL/QgWtO6K8p0SsF5dX7PqF3Vj7u8UEFj0fzBzdunw/B66qkv4UgoKfBm273Wq2Voa6ul2HYX2f+rhRyf27bThzVZdVI3RM5pyrvbzKRm3SME7lNW3wVfffnGXSSxX2qM2Q02eQXOizEDLBaZhpCJifXUI4kXUvDYT/dQWkCJFxrqcEX2NB+whW4BHkh9FQh5sEqdHaDRWeGeW8SSlz7/5LBq6Vd+aEtosDOMSiezE3aARhKslbpYun/P0pYrNYrwOXBn7gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by IA0PPF59B9BB51B.namprd15.prod.outlook.com (2603:10b6:20f:fc04::b1f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 20:39:49 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 20:39:49 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
CC: Xiubo Li <xiubli@redhat.com>,
        "justinstitt@google.com"
	<justinstitt@google.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "morbo@google.com"
	<morbo@google.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "nick.desaulniers+lkml@gmail.com" <nick.desaulniers+lkml@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH v1 1/1] libceph: Amend checking to fix
 `make W=1` build breakage
Thread-Index: AQHcUnlPhfQgFpzlT0W0ropk0kVgoLTsX16A
Date: Mon, 10 Nov 2025 20:39:49 +0000
Message-ID: <d33fedf2943e0de53317ef19840b46aedb58186e.camel@ibm.com>
References: <20251110144653.375367-1-andriy.shevchenko@linux.intel.com>
	 <8d1983c9d4c84a6c78b72ba23aa196e849b465a1.camel@ibm.com>
	 <aRI-ohUyQLxIY1vu@smile.fi.intel.com>
In-Reply-To: <aRI-ohUyQLxIY1vu@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|IA0PPF59B9BB51B:EE_
x-ms-office365-filtering-correlation-id: 24ebe4c4-dd19-4d32-2d59-08de20994b28
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|10070799003|1800799024|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?Nlh0MEJvUmlWNldwYzc1NmxlbW15c29zNzNvb2wvRzA1cXAxREk5NlFVblhZ?=
 =?utf-8?B?NGNJdEl6VGI4cDRYVytuLzVkSGlRTzJzanFZU01oU0ZldUdIdUEwMXhRTUZH?=
 =?utf-8?B?VW5ya1RQa1lFcU04bHRZVFR0V2M4QnFxcjlORTFydUZtRHRvWGFKcDFhSS94?=
 =?utf-8?B?VkYyU2tLeVpxU3pMeThoQkpyMW4vY0J5VzVEM0ZhdUc5dEZ1WlN4SzlQdm1J?=
 =?utf-8?B?TS9qYko1NGFNVCtHNWs0OW1xd3pYN3FaWjR1RjNYcnplUXZmb2lCcVEyQi9w?=
 =?utf-8?B?b01VRnVRNUJFc1AvTEFVckoyQ0VhV25CM2NhNFBCQ1BBT1c2ZmhYK1ppS2s4?=
 =?utf-8?B?QUIrWVRDckpQVTRkNlp0REtjZ2E1ditCWllVdHFxUkhkQTAwVEZyQjBkREls?=
 =?utf-8?B?TEZLREtWeFJwSVU4L1p0eHNkSUw2R3FjTmFvRVRFK3N6RHhkOW84dkJZNFl5?=
 =?utf-8?B?SzNrSDZrQlkxVEUrWlUxdUZkNnhVQlJjWjNpSEsvOCsxbjF4a05Vb2R5eGdy?=
 =?utf-8?B?QWdJNTNaOTk1M3lNK295dzJ2SDZmNFoza0lJWkVEajRVd2JjUnZRMmRCQUFW?=
 =?utf-8?B?N3JJS0IwbUhBcCtHV05zTXNEdVFKcW82UWJaajk3ZWFIbTJFaXZYdVZ5TTlw?=
 =?utf-8?B?enhWTDV0dnQ3SFphWWpzdTcxQ0cyL0pLRUhzanpmZ210bjJ3bzk1RFUxUmNF?=
 =?utf-8?B?dFNPNWpUSk9odzRaakJFbG52OXdidTJUZGVubllBV2VBaFgvUGZzVE90Z3RY?=
 =?utf-8?B?YmZhZU1mV3grU1JTbmRqdDhVU2xYN0lhYlNVaTFoRDdVRnBRcGF2UTV4YnlL?=
 =?utf-8?B?UllySnFJWUFMS3B3OGMvVDFJalBWOXhnbW9hdk1NRXNWUDlHLy9zckxZV2lN?=
 =?utf-8?B?aDYwanA1OS83VjZPZVRVTW5rencvNXBUQkhxbXJsUnpoM2FsK0FFUis3YU5j?=
 =?utf-8?B?OXlKWllwSGc5TWJUdGN3aUtPYW45WlJaNlk3R296dUlxS1FGUGpTckhDa1FX?=
 =?utf-8?B?VVd3VGJ2Wm11VkFGaExKem9QV2hFUUtiQjdjQTNJL2tYWW1mZ1FXODFtWHJv?=
 =?utf-8?B?RW5WamlaWkVJOEtiU3lyY3pvZFhFcUMzb1JyeTVwT0dUbGRvOEZPaVMxRFBY?=
 =?utf-8?B?bkE3cGt6RlZoNERwZW1BNzNlWE43b3dJMnlPdk9CQmYvZWk4Y0t6MDV0MWVn?=
 =?utf-8?B?U29Yai9zTlFIOVV5Z1ZRcG5OcVM3cEQ1Sk5HQ3NtTGFMeVFtM2d3elRTM0tQ?=
 =?utf-8?B?WlhOQVd1NHAxRm93QUwvSUY2WkZMSG1ma1ozVHVTMGVMVHFURG5BMWI2OHJN?=
 =?utf-8?B?VHpadEp6YWU4OUtmVFFQbStWakI5U3Y3Wml6ejFrNUtJUkxjTWJzK0pjK1BB?=
 =?utf-8?B?L2plTHI3VDhUOTFGdjNMYllZYUwzWUVROUJQZ1dWYjBBR00zaldmSlNFckJE?=
 =?utf-8?B?RG4xQmRmeHlXSDhhZjBrdEJySTB1QXBuZGpFd0hYZWNBT0NySllTcmlRTWdq?=
 =?utf-8?B?YnlCUTJ5V0FQREFjOWFKSzRnRi90T1RkRDU1a3hIYmhBbTEvVml5RWkreHI4?=
 =?utf-8?B?TW5RY0NZRDlkK0ZVT25YWDNzTWFDVDdleXFMaG92a2VsT090K1lFYldWV1gz?=
 =?utf-8?B?RXliaEYrNTdSZCtYd0RpRUxKdkFqa0Z4c0VaeWZFalJsODZCcEhNa2lFS3Yr?=
 =?utf-8?B?Qkh3Um9tbjZiRzdGN1NSMG8yVW9xb1JvZVdaVnlvcjdLOVRsMjBDK3hZMjNl?=
 =?utf-8?B?V1NEMm1YbGJaMTcydkNTT2NHeGd4MmxXdmJXd1ZtYXVGSFc2OHFWM3VMRVZY?=
 =?utf-8?B?Q0dicko4SEdCOTNYakc5ZDdGZSsvbDdJcnBnL3hKV1QyOFZKektFd1g2ZEVB?=
 =?utf-8?B?bXk1ZEYyTmlRblowVnBEQlZENC9iNkZYVG9iV29lYzF0YW1JVjVrUVdFVk5Q?=
 =?utf-8?B?ajVFOUZBcCtheUc2NW00akMxZzdUY3VaUnpQVXhoS3hoeFBPcklMazhSTDBw?=
 =?utf-8?B?L0gzZ1VoaHdSUmIxaEkxbm1rblpQRjVPMm01MmtSb0pBUUJSc1VsRWE4KzN6?=
 =?utf-8?Q?8R+VBu?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(10070799003)(1800799024)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cE40UGZDNjVPRzQwTzJzTGk3VDB0d2luR0ZPWks0emhoT0dYTmdNU0JESzVj?=
 =?utf-8?B?TVVMSS9WWmpMTGxaeTh6MFFGUElTLzhYSVhyeUpMaXdaY09RVnlpWEVHQnFp?=
 =?utf-8?B?c3NBby9abWI1WE90MlNqNUFEazl2c3RWVzdkTUExQTR3dzBXdVp5K0pvdjBL?=
 =?utf-8?B?bHVldkFFQjZrcDM5R1FvSUFqa2tGOWtta3JBM1FySmhBeTBEcVFCYTRZemdy?=
 =?utf-8?B?dDlVMHlqT1JLQlZ0UFM0aDcxRXhwLy84REJMUGRiemJRSTZ3czRnQkh4V280?=
 =?utf-8?B?SzZYNm5mT0xPK3FBYWZHVGxsdDRXd0s3dTVJN3NoSkVPVytaK21xSzVBY1Z5?=
 =?utf-8?B?SHU0K0t2cDBGeVN6M3BWSTJEbDlWOW50NTZHUFRUY3phRk1jYkk5WHZZTm80?=
 =?utf-8?B?cnBvbFk1TTRlUnBqeTZ0TVBYYXQzMHhZc2dLclZzV3JHbmNRY1p3RThUUnJL?=
 =?utf-8?B?OUc2RFVpTHZHVGtrVHp5Y2FuOExuR2Y2U1dtdVoyNlVkQVhVRE9VdnlMNUpN?=
 =?utf-8?B?akpmTlVyVnB6d2lrY09HV1BTY2ZvSmpvN2xBZmtRck53UStMSEs3cWljcHlH?=
 =?utf-8?B?K29YaUNJZmVuL01zWEF5NW1xSXBHYVpsVGdjTThnZmkyNmt1SEwrbXI4K3lz?=
 =?utf-8?B?SFc2SG5DM2RvQm51WGphNmVHemw4eXFHc1Z5cUw0amNESXVqbUxIQW1uMmpJ?=
 =?utf-8?B?bFRmMXVyMnVBZm1pZ0VuOS9JcGZBZWQ5eHBtbzdIckhGb0VjM0lLRzlDcFoy?=
 =?utf-8?B?Mkt3ZGZJQ1dhVGZyOGRBSEhJT1czREVxTnl6R25IRGE1S0RtN25DVXBOK2Zz?=
 =?utf-8?B?YnJMT1FOd0VBVUIyT1MvU1EzblU0NzgxdVJ2L3JyUytyRDN4NmYrUGo2cUxn?=
 =?utf-8?B?TW9td2RvTDBvMGQxUVFHQ3IrWWV5dGNEWDhka0NiMzhrNzNrQ2xXRkMvZjYx?=
 =?utf-8?B?SmcwaFBtVUtPQmc0eTl2V3B4a2l4cVVqdGd5REthNUdBTERJM1hNSWxWSStw?=
 =?utf-8?B?WWNEU0VKaWh6d1VQd1JETEpwa3hxcjlMdnljeG10VlIwdnM2QVhJWTEyR3Fh?=
 =?utf-8?B?azluSHR0b214bzlhRkhNSVRobEVDS3dmeUdWM0EyZlhuU055cEsycUE3czYv?=
 =?utf-8?B?dlZhbHRlMkpiMm9Yby9FbW02YUZQcmwxc3hxejFhK2YrMU03dmJpSFBsTk9Q?=
 =?utf-8?B?bURZN1hFTEdnZnFEVmdvWG1PcTZwUFFONTM4a3ZmU0FGczhtWWw5ZCt5dVYz?=
 =?utf-8?B?Um9GZ2NtZHkrd3dyY09vMUxvb2lYa2xnY1lZd2o3MVFNTTl1MW9wT3hQaWpG?=
 =?utf-8?B?U0hTWTdGRFNDMUsxS3N0M0JOKzlKSzRvSitHcURFaVNUZUdEM0JmaUNTVS9z?=
 =?utf-8?B?MnIwZDVFNU5nTThtL1hRRmVqVlM2SzRtbUZmSCtKYys4VHlsOTR0aHpxQmVY?=
 =?utf-8?B?NGRHbFMzUStHTXo1SkhBNlZTQTFDc2phajM2NjRMemszbFFsL0tvNmE3ZDZt?=
 =?utf-8?B?RDZ4K3RjZnhyTTZZRE1QQUhSRUVUdW9jM1lDRXJPUkFyS1pMVHNnelovTnhX?=
 =?utf-8?B?Wll3Tno0Y2R2RjNZSWh3SkNpN1VHRWw3WjN3ZDRRUEhCSmVlSW1aWS9YelU5?=
 =?utf-8?B?bXBaangwUVFwc0dVNmdXcHJ4WDN5WE9iUjFybkFIVnNZZk94eTVlZTl5ZGJa?=
 =?utf-8?B?K0UrSXp1M1VXZGwwRU9PeGRWbkQzdUlTRUJ6dmMrVEtsS1NTMVVtdjhZUzJm?=
 =?utf-8?B?d2QwV3k1WmxMV2hOS0dyNWRKeGFUK3dtNTVzbmtDRGdWa1ZlSENON0VGZHlR?=
 =?utf-8?B?ZW9rd2IxTlBud0JnQXUxb29tVG1ibThIOXV6SllaNmZpSFZwbFZsTVV0cXRv?=
 =?utf-8?B?cytyRWVuRTdReVc2SVhLaWdJNXgrQjUvdE1McjVFNHMrMG5BTXF1MnprVFZu?=
 =?utf-8?B?bWZ5MXhzQWVBZnY1SzhteW83RmdDSHBEVXk1WFN0SHJtZFZ5cmFPaDBNQ3dD?=
 =?utf-8?B?eTlPSHM3bkpxZkFUeGd2eEliYTVwclluMVBTUndIbmY4ODdzdlp0d0Vack4w?=
 =?utf-8?B?d28yV2x6Uzl2LzljdzR5MXArTFJVb09YS2tKTWtJZDhIMVBjQ3p1WWJjSUNU?=
 =?utf-8?B?OFBhTExvMVI0OUJZcVEwNys2RERmSFpKNkFGb2YrL09GbmhsYm4rcGVsVGNR?=
 =?utf-8?Q?3ygDw9Tz0BStA/NENRYaQ30=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8685B69D259CDF49B3A2BFD396B32384@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ebe4c4-dd19-4d32-2d59-08de20994b28
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2025 20:39:49.6162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vCVNLI32f9Yc6u77ons6/PA/l6+PSrVaPI5kVB3vp2/tmlcMmv/IOpHc/QirihPfQsm+fMaZWa4o692uTyLHpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF59B9BB51B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAxOCBTYWx0ZWRfX5zO3HRYfLSes
 zpVNmBQmkDijZRJHlZnmWhAy0EXftwHCfD6lfeyVWX94K7QlCv4EpU/yrbeTtoL1WMuOpf896TL
 8Q42P2DBD1x8DZZ4so8GMpyKE2E3sF7mkfurV6OH2ooAiOV9xuo+q8dfxO1/p0ZoT9HPZpbd4p6
 e2rtOtWIjbyF7UDBL3om00Uizj1rEyPLfb7CU+hmAPflHmB6vDdwQ5ytCHvKd7b3jnUstgGB3Qg
 Im5jW+cKuPlyu1+ctUj/uqIEeuI4oEeh1+AxLUjf0siOFI02C14/s7CUFxk+nkEmx0Hsn78A9ug
 GUUtrD1fn1dTSo+o8ujeORJlFrKI5VInjkk/4fAGAb7Xib6QV6nercRoIcWOBB0LQ5RD5BovLsa
 2ZnpUrKtvMx0/EeuvAO7XtIIoX+Szg==
X-Authority-Analysis: v=2.4 cv=GcEaXAXL c=1 sm=1 tr=0 ts=69124d98 cx=c_pps
 a=cVuenkWoTzwZy9czxFkdkA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=QyXUC8HyAAAA:8 a=VnNF1IyMAAAA:8
 a=NR7hJ6MFRv4FvV7vwXcA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: p2mN_K0aE1ymrCEtFucUh0hrfXBB7zBa
X-Proofpoint-ORIG-GUID: yECdSB5XtXPNMTYn6PDVzFcRUJ8wPIMl
Subject: RE: [PATCH v1 1/1] libceph: Amend checking to fix `make W=1` build
 breakage
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080018

T24gTW9uLCAyMDI1LTExLTEwIGF0IDIxOjM2ICswMjAwLCBhbmRyaXkuc2hldmNoZW5rb0BsaW51
eC5pbnRlbC5jb20gd3JvdGU6DQo+IE9uIE1vbiwgTm92IDEwLCAyMDI1IGF0IDA3OjI4OjM2UE0g
KzAwMDAsIFZpYWNoZXNsYXYgRHViZXlrbyB3cm90ZToNCj4gPiBPbiBNb24sIDIwMjUtMTEtMTAg
YXQgMTU6NDYgKzAxMDAsIEFuZHkgU2hldmNoZW5rbyB3cm90ZToNCj4gDQo+IC4uLg0KPiANCj4g
PiA+ICAJY2VwaF9kZWNvZGVfMzJfc2FmZShwLCBlbmQsIGxlbiwgZV9pbnZhbCk7DQo+ID4gPiAg
CWlmIChsZW4gPT0gMCAmJiBpbmNyZW1lbnRhbCkNCj4gPiA+ICAJCXJldHVybiBOVUxMOwkvKiBu
ZXdfcGdfdGVtcDogW10gdG8gcmVtb3ZlICovDQo+ID4gPiAtCWlmIChsZW4gPiAoU0laRV9NQVgg
LSBzaXplb2YoKnBnKSkgLyBzaXplb2YodTMyKSkNCj4gPiA+ICsJaWYgKChzaXplX3QpbGVuID4g
KFNJWkVfTUFYIC0gc2l6ZW9mKCpwZykpIC8gc2l6ZW9mKHUzMikpDQo+ID4gPiAgCQlyZXR1cm4g
RVJSX1BUUigtRUlOVkFMKTsNCj4gPiA+ICANCj4gPiA+ICAJY2VwaF9kZWNvZGVfbmVlZChwLCBl
bmQsIGxlbiAqIHNpemVvZih1MzIpLCBlX2ludmFsKTsNCj4gDQo+ID4gSSBhbSBndWVzc2luZy4u
LiBXaGF0IGlmIHdlIGNoYW5nZSB0aGUgZGVjbGFyYXRpb24gb2YgbGVuIG9uIHNpemVfdCwgdGhl
biBjb3VsZA0KPiA+IGl0IGJlIG1vcmUgY2xlYXIgc29sdXRpb24gaGVyZT8gRm9yIGV4YW1wbGUs
IGxldCdzIGNvbnNpZGVyIHRoaXMgZm9yIGJvdGggY2FzZXM6DQo+ID4gDQo+ID4gc2l6ZV90IGxl
biwgaTsNCj4gPiANCj4gPiBDb3VsZCBpdCBlbGltaW5hdGUgdGhlIGlzc3VlIGFuZCB0byBtYWtl
IHRoZSBDbGFuZyBoYXBweT8gT3IgY291bGQgaXQgaW50cm9kdWNlDQo+ID4gYW5vdGhlciB3YXJu
aW5ncy9pc3N1ZXM/DQo+IA0KPiBQcm9iYWJseSwgYnV0IHRoZSBjb2RlIGlzIHBpZXJjZWQgd2l0
aCB0aGUgc2l6ZW9mKHUzMikgYW5kIGFsaWtlLCBtb3Jlb3Zlcg0KPiBzaXplX3QgaXMgYXJjaGl0
ZWN0dXJlLWRlcGVuZGVudCB0eXBlLCB3aGlsZSB0aGUgc2V0IG9mIG1hY3JvcyBpbiBkZWNvZGUu
aA0KPiBzZWVtcyB0byBvcGVyYXRlIG9uIHRoZSBmaXhlZC13aWR0aCB0eXBlLiBUaGF0IHNhaWQs
IEkgcHJlZmVyIG15IHdheSBvZiBmaXhpbmcNCj4gdGhpcy4gQnV0IGlmIHlvdSBmaW5kIGFub3Ro
ZXIsIGJldHRlciBvbmUsIEkgYW0gYWxsIGVhcnMhDQo+IA0KPiAqQWxzbyBub3RlLCBJJ20gbm90
IGZhbWlsaWFyIHdpdGggdGhlIGd1dHMgb2YgdGhlIGNlcGgsIHNvIG1heWJlIHlvdXIgc29sdXRp
b24NCj4gaXMgdGhlIGJlc3QsIGJ1dCBJIHdhbnQgbW9yZSBwZW9wbGUgdG8gY29uZmlybSB0aGlz
Lg0KDQpJIHRoaW5rIHRoZSBwYXRjaCBsb29rcyBnb29kIGFzIGl0IGlzLiBBbmQgd2UgY2FuIHRh
a2UgaXQuIElmIHdlIGZpbmQgdGhlIGJldHRlcg0Kd2F5DQpvZiBmaXhpbmcgdGhpcywgdGhlbiB3
ZSBjYW4gZG8gaXQgYW55dGltZS4NCg0KUmV2aWV3ZWQtYnk6IFZpYWNoZXNsYXYgRHViZXlrbyA8
U2xhdmEuRHViZXlrb0BpYm0uY29tPg0KDQpUaGFua3MsDQpTbGF2YS4NCg==

