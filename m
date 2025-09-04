Return-Path: <ceph-devel+bounces-3524-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58521B448BB
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 23:44:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B7A8A00303
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 21:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF6A2C21DB;
	Thu,  4 Sep 2025 21:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tP6EAdX+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973832C0F61;
	Thu,  4 Sep 2025 21:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757022239; cv=fail; b=VRSOdYEmQ0FsjBHvwai/hJfBikrl6Fx/ajV+2YiYljcdyWp263911UwzdHhLLnjwbcJXEyvtFCJF2bx70kPeM+ehR7DJKtxPClwPW+kIjf2whInJnjvT2WPzjsEXQr/DQU2cpKAXoWoFgJpiAmPMplWm4wd1MTdmjStwJEXyMLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757022239; c=relaxed/simple;
	bh=0l+VAl2WcNomlKiIYFiuCrcyoJVRpiCfQdm5g9REl4o=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=TsrDi2l7YPtWlyyqxyhldmWze8f2SoTvcqEknopMUUSbLBnmzhKSv6xfZ2F4mEMWmJdpGBKX2VB4DWaF70cKZSJYglRwPgjmBaoHSfjkfrcU9xmIZXsp0lsZQrw+ap1FjUNtWvsEiltylGpyfm7hJbNoahQWljKXCPyBhcYQQVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tP6EAdX+; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584D965B014516;
	Thu, 4 Sep 2025 21:43:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=0l+VAl2WcNomlKiIYFiuCrcyoJVRpiCfQdm5g9REl4o=; b=tP6EAdX+
	dNBu23qA9+KK5Q+wRwBtDZXbYC8NKLTJXSLFSaXZIJwpBvhxmvY1xYf6WW5vSQly
	M51lY6i2jSqTtguVFJhnG1pkMinRPwM5goiNglK2WQBzAEUnL2PDmSwDffFSnINc
	PFCSK6/XJZeDDdmW7LuDHTwiq2cWYlS027cxwWWH5VS5ssk1E2UvUbz/3ffJ2j0O
	sefeMW1+VYU2CFj5oNkl+XWNyK9pxILlCgrnvvgcZC7lqoqhtdAWwh89xAD5q8s1
	tDlGpwsh0tV9dKY/k82jL/x50w89uvK7MH9RgSAxycxY02uEGmEuIzmiucn2Id0n
	wg03xojxU0uYfg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usurcu01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Sep 2025 21:43:52 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 584Lhqla015976;
	Thu, 4 Sep 2025 21:43:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usurctyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Sep 2025 21:43:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YnBb+Mct1/iGwxO5+cVswiJk3euUI3zIKTylJ5cXq2SnVOziA04T9FJTH5ol2oNqpJbNFDTlm2+9y0B4ron2xWQ9Z/XR1ADGLdjI0Fh5KUnJskWZVZNNkp0owLyNjkjwbbluN4DfrP5zOfetHhmhG/lyvx/SE3YDnj11GGS+kUhwF6rRJJOztn/7MLXM248kp5g+srq3ujMyrz5I3DYnd349N7lDQKeAJ7rj3l+sMFWGNsBgJabgxDy8YOgZlX+PNJeAfKxcdG9SMIERT/auOyTJ9W5ICH3Ws8NCfLgnqh6ochEV2W/fppFPcSPJEC9RiQrGB76i++oW28ZY31UzuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0l+VAl2WcNomlKiIYFiuCrcyoJVRpiCfQdm5g9REl4o=;
 b=Ihg95l0qtIHem5t5vjMMD8iCv7Bo64k9928cZ5von+6n488Rq+d5hofEjEque9TmfdtDzxrUeqAjih1s2TFpgpBJ5mmIUqz/BehULk0gwtrDHo9fLti5KFj9gT02nF+9lRzexgfys5nG+HGuLW7r9QQC0AS0Z1iJXxelIbl+LHXhNuVGB5AA6SSfKaPOU1GBN5i2Jsyi9H/M6LX7DioWlGsL76p9JtFVDJknryjuDKaa78PVHY71GVz+X08bmnCQDhWMG8tn5cau1wANxdoIGPHeV7hwfLkM7diVvAMMw4wmV4ATTYhN+wAc+bXjMPMlIXku4IG0AdlhEKMg0D08HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ4PPFFB312818C.namprd15.prod.outlook.com (2603:10b6:a0f:fc02::8d6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 21:43:49 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9094.015; Thu, 4 Sep 2025
 21:43:49 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "max.kellermann@ionos.com" <max.kellermann@ionos.com>
CC: Xiubo Li <xiubli@redhat.com>, Alex Markuze <amarkuze@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [PATCH] fs/ceph/addr: always call
 ceph_shift_unused_folios_left()
Thread-Index: AQHcGE64qoYmawrjLUelljJPwcgz5rR4baUAgAApqoCACwH7AA==
Date: Thu, 4 Sep 2025 21:43:49 +0000
Message-ID: <25a072e4691ec1ec56149c7266825cee4f82dee3.camel@ibm.com>
References: <20250827181708.314248-1-max.kellermann@ionos.com>
	 <791306ab6884aa732c58ccabd9b89e3fd92d2cb0.camel@ibm.com>
	 <CAOi1vP_pCbVJFG4DqLWGmc6tfzcHvOADt75rryEyaMjtuggcUA@mail.gmail.com>
	 <9af154da6bc21654135631d1b5040dcdb97d9e3f.camel@ibm.com>
	 <CAKPOu+8Eae6nXWPxV+BGLBVNwSu5dFEtbmo3geZi+uprkisMbg@mail.gmail.com>
In-Reply-To:
 <CAKPOu+8Eae6nXWPxV+BGLBVNwSu5dFEtbmo3geZi+uprkisMbg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ4PPFFB312818C:EE_
x-ms-office365-filtering-correlation-id: 6e27a3e7-28dc-427c-ebc9-08ddebfc221a
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?L1p3YVBqVlRYRm9vYnJYaDNtSUVPaFg2dXltZWgxdnZOM0xwY2VxL0JmM1hY?=
 =?utf-8?B?RVBqUmJRK2lHaENVM2I0c0N0amM5S3JVOXhLTFoxSkRqNk5CVWZpV3NGYzla?=
 =?utf-8?B?dzZXWnB6OXQvY09OUXZPRVdtZDhWUDQrNWdWeUJwTDB2ZTY2N0o0UGljM1JO?=
 =?utf-8?B?NmxISFBIV0hnS1hPZnhrUk5KeWM5TXZkUXBLM29CZXpJYmIxV2pvcU41ZUgv?=
 =?utf-8?B?K3JPa1ozK3lUTG5HQ3RPazZ2QzdWeDlLTmtVNmpSNzVLbThoREREZHhKUWZi?=
 =?utf-8?B?UkUvTW0rY0JqMzJpczMvZGgzVCsyZ3ZiL2ptT3cweUxjSGFwL2RZNVp0Q0hE?=
 =?utf-8?B?ZlU2Q294SlNNd3NLK2ZmMERXaERuY3JRZWVMakpmQ3dGTHI4Mk55dVd3c3RV?=
 =?utf-8?B?d0tRc3R2aVkzWVB4SThEY2FuMTd1MXlaWnREZXkxUlhlZkFtZ3NHSzZSay96?=
 =?utf-8?B?R2RuYlhaZHk3bnZIY3NNZ09lZVg2a3F3SUpWWGNYUG9DaEVGQ0pJUVlDcGRQ?=
 =?utf-8?B?VFU3RzZDVEMvY0orNlhPUnlnZmNFVHhSdzhqUFBWM3ovQ2w1eXVkUUZPSzV6?=
 =?utf-8?B?M2RVT05VVWN1aExoUHB4TVMvVGVtblFoclYwblFVMm8rdjNpREJaSThOVTJQ?=
 =?utf-8?B?UlNvdGVqZ0dEYit2cWVpMzNoU3JTa3dubk1IejNIdnZDUTFsbVo4aFJPNThn?=
 =?utf-8?B?cmN4a1hNd0JFYklsT3RHMmltY1lFc2d0QmZlYmNuYlgyYSt5bXJPb0xINHQ2?=
 =?utf-8?B?emw2SXUrU05DT2hVNkdFNUQ4bEJTTytYZzJQVWVyOFhGbXNiQ0IxbWJPaENZ?=
 =?utf-8?B?K1Uvc2Y4T29jUU5CWGYvYmZuWWkwaFF3cHZWbUJSS0V5TFkxeG5KRXMvQjFI?=
 =?utf-8?B?Q3E1MVhhdGpMWmJVQ2FFcXE0eG5vd2VTaVQ5VlBjVGUvL2pCS29sbXhZNVFO?=
 =?utf-8?B?LzhwSmM4T1AyeHZiaUt2N0ZtVm9PWVhReW92eFFYeWYxNFpxV2JqSCt5VU5J?=
 =?utf-8?B?NmpOdVFzS0FpbDVYdk9GQVJTcVBsS3NFY3g2bnJQUjM0ZzkwaDRoL0U3VFRh?=
 =?utf-8?B?WFc3ZjVMeDhmR216K2tJS3o2d252dFZPZDByZVVmcStqNGgyQ0hFMUxvRnVG?=
 =?utf-8?B?b21DeHdteXhSMnh0NjNDUkZnK01PSmtNckdqZTg5eE5rNzFBUmEyMGdFME1H?=
 =?utf-8?B?SVp0bEFFVVFPV01KY2oyREFyYm9FN0tBdThjSURFS2Q5ZzdZdUhXbncxRjRM?=
 =?utf-8?B?emZGZ1Q3LzZ6aUVZbFp6TENBNUFmNmczQ2ptRC9wUUoxZTljWmNXTnZqUXVm?=
 =?utf-8?B?Y21wSWVTVFBDdDd6YmM3bzhKRHlqWGZYSlVuV3Exc2dXMmZKNzhpVmNjQm1w?=
 =?utf-8?B?UzF4bERKY1R6ejNuL24vbnRzMzJIek4yWXJXak9TbEZmWExmeGxRUUpZS2RO?=
 =?utf-8?B?ZWJ3WnhMeEpDeWVOUmJNSDAwQnBVSFQvcitNdlBxZXk5dlhDQ256R1JQTi8w?=
 =?utf-8?B?MlU0SXFYbHE4eTUwQVV4UmdkK1ZSZnJmbUxhM3FwVHMrOTAxQWRkQWpITkRp?=
 =?utf-8?B?MC9Xc1VVMFh2cDNjL25KVTdMemppZ0ZFcDBkbmp6dmQzR2JTRTNLUExIeHJI?=
 =?utf-8?B?ZTFiMlBRZHpocVlPVHdtMHo3UHFHYVJIQ3pnWnlFbEFnc1NDaUNlWWNCVllT?=
 =?utf-8?B?dm9tNXF3YXJoQ1ZSOEw5aFU4V3pCTVhoU0tEQktabStWQ0Zsd25kWnFqRXJQ?=
 =?utf-8?B?M1FncWRCU2wzRXY4VFpINVlUTWVhdDcrQlNCKzc2bVRFc0NjVW82RUhqR2hi?=
 =?utf-8?B?VlZtWlZIR0RSSkNheGFhL3pyNkRhd0c1Vm1TS0hhYzUyUXViNUllWnE0RnBa?=
 =?utf-8?B?dFBLNWVYTEVzZDZCL2RDaTRpNnR4QjNTUWxEN2JUSzI2VUY5S3h2a01ESW44?=
 =?utf-8?B?WjkvRTdMcTdLRGY0Q3lPbmQyN0NHRGMwS0lobVp3TGJPSlFHaDM5blFxVHhm?=
 =?utf-8?Q?k7+WFSZyKSAlphwRkqxoDQ08m90gMc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Ukw1SWVTTmtnMDdTeS9kd3J4cW9KUnRsaWt2V0NKbHdyU1lqamdIREoxR0k0?=
 =?utf-8?B?bWhtcTVmWG1RcXVUa1ZjQXJ6SmI1RnhqSStzUGRkS3NXaUxjTHF0QmxsL0pk?=
 =?utf-8?B?QzB0M04xQzBNOVRQU3p6Nk4wN1pFOGoxNGRiWUpOREdDVVJ2S0xKNDJzcUJV?=
 =?utf-8?B?UU12R0ZWWGYzVGdWV2NFRjhRbVdOYmNQcGxCNWRhNzBQTlhLazF5VTZIbERa?=
 =?utf-8?B?T1RwQXZSaVE4ZytJZEQwd3hIR05QTGVRUDN6UFRURzBHWHpXYmtGVjlkWkVT?=
 =?utf-8?B?M1g0SFNmYVVPRFNmQlZBRHUzaU4xd1JJc0lIL1RvRkd3TkR0ZjVhamxXb0k2?=
 =?utf-8?B?OGdtVFdpVVB6b3Z2MnNvQktlaHJxWHlyb1AxRlV1b081S055UC9XSHdrTFQr?=
 =?utf-8?B?cnVlM0FHTGwvRjgvZ2R2cENDbGU4aEJTcDhsVzJTamprM292NE9JTUF4VTNM?=
 =?utf-8?B?b3hCeUlzcXc1SXBOUXlSNXFtNU1CM3lYWUZ4b1p3b0ZQQ1hOYVdUOXhPNEh3?=
 =?utf-8?B?akk0MEZ2Zkw1QkxXTm9Rd1RMcFcyMjltUTYxMTBoaUNyTU5IbU5vb0hoL0Fn?=
 =?utf-8?B?QjJFU1JtVndwZlBsUG51ZjVBMERrOGFKYVRKSGJuYmFZa2JyUFBKTmpWN3ls?=
 =?utf-8?B?eHFGVUplZEFVMlVGZkZPbWczMW9OUmxwK09TZkNBekJaWjBieHQ2OWs5TFRl?=
 =?utf-8?B?QTBrNnA4QVhRbFJSeVk1ZWFwOU1IVnVQWjRGV0VXMzh1cWoxeTEra2ZJN3F0?=
 =?utf-8?B?UUZsNU1MblFJQXEvOE16VDdqUUxkU1c4c2ZMd1hBTk1NM0JiUEZTamlZblVU?=
 =?utf-8?B?MkRlSFdnVlRJUTFNMW45TGZjY0dhVld3cmR4TndRMXZkZ0MvcDdzWS8vMmFq?=
 =?utf-8?B?c0RVUFFHUkpzM0QrOFdBYlpuR0lsdW54ME8ycGR4ZHIyY2tiNmoyWEthUkF3?=
 =?utf-8?B?b2Z4ZnBjdkpqcE5ZMC9pYUJzb3lxY0xpWkNrMm00Z0IyRU5jTS8rSUNTSHZs?=
 =?utf-8?B?aXZLK3FVb2tJU0hnUS9iWmhIUWhFWk9aZ01iZEc0V1RBaTdraVhpYVBPT2Vj?=
 =?utf-8?B?bTYvNDhnR2dRbzZpUjZBeHpFeFFyNXcwUDBwSU0xN2tQYk9lenFoSmdpNk5u?=
 =?utf-8?B?SmxUbUQxNStPQnF4bnNLejE5M3pKVG8vR0xTc1RuMGNCTURTeEdxaEpCYVlM?=
 =?utf-8?B?dzh0TWhJN1Y1R1JlWXNmQnltVDd4b2czQlpTZHdTWCtkbDZ4Um1oSVpIK3c0?=
 =?utf-8?B?TXhJTXRJU201NE81cmlNQllLelpaVkRnL0p5aU5RTVo2NEY1RE1pdGRwLzdq?=
 =?utf-8?B?MXl5RzhUTGFTRUp2Z2xMdGJUZlBRbDIrNHVVU0hycnlRaXJLTEVnTkhabVpU?=
 =?utf-8?B?bFUwRVg1Q1BEeVRucVI2NzdxdFBOb05EUzBtNTgzbXN0UUJoRlZxVnpTcGcw?=
 =?utf-8?B?ZTZYSlprcU5Vb3hGaWFERnliY2tmakxMT3VXdTkveUl4NFh0UVJDL0EvbmQx?=
 =?utf-8?B?aXl5MElIUjhOS1MxM2tKY0s1aHQ0RUhvYnJueGk1NVhrL2FmczRSaVJYMzdt?=
 =?utf-8?B?YU01OGxhdDRWZHFjemxyVXRYZXArSWlWWXRUU2tGSUtRc3prRGw5RnRZMmVB?=
 =?utf-8?B?N2ttKzZZdHBRK2RNQWgwRVhmT1lsMU5JbFJvaHBOUk9La0V3VGw5aTFUTmRu?=
 =?utf-8?B?YnAvUUhTQTByMUQ0MENEcXFveElFQXo4YlRpWTFvNGxpY0xGcVB3amVrZ2h4?=
 =?utf-8?B?NkNaMWNXNTY4dFpQVDdYM2hHUW1Ma3FGNmtTOG1pbFY4NXpQMjhhTHkzRFo0?=
 =?utf-8?B?bm5QbjA5TmlqVjNWOEZaemh3WjBTUWRENGZ1TVJGYTBUQUMrcEl2eldpenpS?=
 =?utf-8?B?amJBZUtrTGxhemxNT2l5enRhVHMxY3VOOFU1ek92VkkyQno3M3NhcXlpOE9C?=
 =?utf-8?B?OWxtYlU1K3MyZ0lKaXE5YzFCeTZFcW5EOVpwaTNlVnQveHVjOERLd2VBVFZk?=
 =?utf-8?B?WjBCN3hGZmNVUU92SGN3dVJIMS90OXBIRGU0WXViUUlWV3czZWc5M1lxUFpo?=
 =?utf-8?B?THRhRFhHNnVUbm4vRDdrM1RPZVE5MVEzajhsUG1HSEVrTXdvRTJSRmh5a0lM?=
 =?utf-8?B?TlBuOTdPeTkvU2xrdmgrUDRMZExacFczcDVlRVpxZmFzUVlZaFZCNUlxamc2?=
 =?utf-8?Q?dnOON7xG54zei/jo4AfK9Oo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <96C37491D6B75542A8516F9589530390@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e27a3e7-28dc-427c-ebc9-08ddebfc221a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2025 21:43:49.2443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: it/rtsYgNzQvSvgUxiUrU2AvqXtbrka75jZMjKUXd+BMcO0aO+fTK6a46MH6H9IBxe43XT0K18b4yg2OTVXA+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ4PPFFB312818C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMCBTYWx0ZWRfX8XpscfPxLoqs
 QS+Q7Uq5Ffl8dASiWoQMsj9QAiH9V5MiKgD7CGsKSGqKdG91zdWpzHysWyQenqs41fUSZHGj3B2
 f0K8PMxGonb+GRWEXQrGwI9aw9SnH9LRcP7JELuXG4Kxjrd+IqN6MIvNgceWBL4nmTx1wM1mjy+
 Z0SsxLnRVcHz8DitoWwZD/bgXpAEPwetLl3lLggJoN61RDsh+DgPUKL6P6V9vnCh+bZS+Z6RcJg
 fRWVqB1U5Ez3h/aGC1YJTSQ7TWY0xWiOjxspeT6bqyPTGHcG0gjtuo+ovPEB0NRkeZMmPttg2mj
 0PvL6d2RmIy3zSiUK117TxjNnZmMZKK5aUYRmpBx1ZaE+HvnIRKIbMEOusPgBPoWCFLCwWjr89l
 hD332gRG
X-Proofpoint-GUID: 1plrvisibGABTphb7BHEww5gPblOFFJD
X-Proofpoint-ORIG-GUID: RzlrPbEzMeXtvi4pbp3tNHvxKU4iq8_9
X-Authority-Analysis: v=2.4 cv=Ao/u3P9P c=1 sm=1 tr=0 ts=68ba0818 cx=c_pps
 a=vtFmJWl4sHo/TFLPmrN7Aw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=UgJECxHJAAAA:8 a=VnNF1IyMAAAA:8
 a=wWjM_QlCfiAJXpEbFLgA:9 a=QEXdDO2ut3YA:10 a=-El7cUbtino8hM1DCn8D:22
Subject: RE: [PATCH] fs/ceph/addr: always call ceph_shift_unused_folios_left()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_07,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508300030

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDIzOjM3ICswMjAwLCBNYXggS2VsbGVybWFubiB3cm90ZToN
Cj4gT24gVGh1LCBBdWcgMjgsIDIwMjUgYXQgOTowOOKAr1BNIFZpYWNoZXNsYXYgRHViZXlrbw0K
PiA8U2xhdmEuRHViZXlrb0BpYm0uY29tPiB3cm90ZToNCj4gPiBBbmQgd2hpY2ggcHJhY3RpY2Fs
IHN0ZXAgb2YgYWN0aW9ucyBkbyB5b3Ugc2VlIHRvIHJlcGVhdCBhbmQgcmVwcm9kdWNlIGl0PyA6
KQ0KPiANCj4gQXBwbHkgdGhlIHBhdGNoIGluIHRoZSBsaW5rLiBEaWQgeW91IHJlYWQgdGhhdCB0
aHJlYWQvcGF0Y2g/DQoNCkJ5IGFwcGx5aW5nIHRoZSBwYXRjaCBbMV0sIGVuYWJsaW5nIENPTkZJ
R19ERUJVR19WTSwgYW5kIHJldHVybmluZyAtRTJCSUcgZnJvbQ0KY2VwaF9jaGVja19wYWdlX2Jl
Zm9yZV93cml0ZSgpLCBJIHdhcyBhYmxlIHRvIHJlcHJvZHVjZSB0aGlzIHdhcm5pbmc6DQoNCiBb
ICAxMjMuMTQ3ODMzXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0NCiBbICAx
MjMuMTQ3ODYxXSBXQVJOSU5HOiBDUFU6IDUgUElEOiA3MiBhdCAuL2luY2x1ZGUvbGludXgvaHVn
ZV9tbS5oOjQ4Mg0KZm9saW9zX3B1dF9yZWZzKzB4NGMyLzB4NjAwDQogWyAgMTIzLjE0NzkwMF0g
TW9kdWxlcyBsaW5rZWQgaW46IGludGVsX3JhcGxfbXNyIGludGVsX3JhcGxfY29tbW9uDQppbnRl
bF91bmNvcmVfZnJlcXVlbmN5X2NvbW1vbiBpbnRlbF9wbWNfY29yZSBwbXRfdGVsZW1ldHJ5IHBt
dF9kaXNjb3ZlcnkNCnBtdF9jbGFzcyBpbnRlbF9wbWNfc3NyYW1fdGVsZW1ldHJ5IGludGVsX3Zz
ZWMga3ZtX2ludGVsIGt2bSBpcnFieXBhc3Mgam95ZGV2DQpwb2x5dmFsX2NsbXVsbmkgZ2hhc2hf
Y2xtdWxuaV9pbnRlbCBhZXNuaV9pbnRlbCByYXBsIGlucHV0X2xlZHMgcHNtb3VzZQ0KaTJjX3Bp
aXg0IHZnYTE2ZmIgcGF0YV9hY3BpIGJvY2hzIHZnYXN0YXRlIGkyY19zbWJ1cyBzZXJpb19yYXcg
ZmxvcHB5DQpxZW11X2Z3X2NmZyBtYWNfaGlkIHNjaF9mcV9jb2RlbCByYmQgbXNyIHBhcnBvcnRf
cGMgcHBkZXYgbHAgcGFycG9ydCBlZmlfcHN0b3JlDQogWyAgMTIzLjE0Nzk4OF0gQ1BVOiA1IFVJ
RDogMCBQSUQ6IDcyIENvbW06IGt3b3JrZXIvdTMyOjIgTm90IHRhaW50ZWQgNi4xNy4wLQ0KcmM0
KyAjOSBQUkVFTVBUKHZvbHVudGFyeSkgDQogWyAgMTIzLjE0Nzk5NV0gSGFyZHdhcmUgbmFtZTog
UUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MNCjEuMTcuMC01LmZj
NDIgMDQvMDEvMjAxNA0KIFsgIDEyMy4xNDgwMDJdIFdvcmtxdWV1ZTogd3JpdGViYWNrIHdiX3dv
cmtmbiAoZmx1c2gtY2VwaC0xKQ0KIFsgIDEyMy4xNDgwMjFdIFJJUDogMDAxMDpmb2xpb3NfcHV0
X3JlZnMrMHg0YzIvMHg2MDANCiBbICAxMjMuMTQ4MDMxXSBDb2RlOiBjYyBjNiBkYiAwNSAwZiA4
NSAxOSAwMSAwMCAwMCA0OCA4MSBjNCBiOCAwMCAwMCAwMCA1YiA0MQ0KNWMgNDEgNWQgNDEgNWUg
NDEgNWYgNWQgMzEgYzAgMzEgZDIgMzEgYzkgMzEgZjYgMzEgZmYgYzMgY2MgY2MgY2MgY2MgPDBm
PiAwYiBlOQ0KMWUgZmUgZmYgZmYgZTggYzIgZmUgMjQgMDAgZTkgZGEgZmIgZmYgZmYgNGMgODkg
ZWYgZTggYjUNCiBbICAxMjMuMTQ4MDM1XSBSU1A6IDAwMTg6ZmZmZjg4ODEwMWM2ZjIyOCBFRkxB
R1M6IDAwMDEwMjQ2DQogWyAgMTIzLjE0ODA1MV0gUkFYOiBmZmZmZWQxMDIwMzhkZWE0IFJCWDog
MDAwMDAwMDAwMDAwMDAwMCBSQ1g6DQowMDAwMDAwMDAwMDAwMDAwDQogWyAgMTIzLjE0ODA1N10g
UkRYOiAwMDAwMDAwMDAwMDAwMDAxIFJTSTogMDAwMDAwMDAwMDAwMDAwMCBSREk6DQpmZmZmODg4
MTAxYzZmNTIwDQogWyAgMTIzLjE0ODA2MF0gUkJQOiBmZmZmODg4MTAxYzZmMzA4IFIwODogMDAw
MDAwMDAwMDAwMDAwMCBSMDk6DQowMDAwMDAwMDAwMDAwMDAwDQogWyAgMTIzLjE0ODA2M10gUjEw
OiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6DQowMDAwMDAwMDAw
MDAwMDAwDQogWyAgMTIzLjE0ODA2Nl0gUjEzOiBmZmZmODg4MTAxYzZmNTIwIFIxNDogMDAwMDAw
MDAwMDAwMDAwMCBSMTU6DQpkZmZmZmMwMDAwMDAwMDAwDQogWyAgMTIzLjE0ODA2OV0gRlM6ICAw
MDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4ODgyNGEwMzQwMDAoMDAwMCkNCmtubEdTOjAw
MDAwMDAwMDAwMDAwMDANCiBbICAxMjMuMTQ4MDcyXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAw
MDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzDQogWyAgMTIzLjE0ODA3NV0gQ1IyOiAwMDAwNzAwNzk4
MDAwMDIwIENSMzogMDAwMDAwMDExMWI2YTAwNSBDUjQ6DQowMDAwMDAwMDAwNzcyZWYwDQogWyAg
MTIzLjE0ODA4Ml0gUEtSVTogNTU1NTU1NTQNCiBbICAxMjMuMTQ4MDg1XSBDYWxsIFRyYWNlOg0K
IFsgIDEyMy4xNDgwODhdICA8VEFTSz4NCiBbICAxMjMuMTQ4MDkzXSAgPyBfX3BmeF9mb2xpb3Nf
cHV0X3JlZnMrMHgxMC8weDEwDQogWyAgMTIzLjE0ODA5OV0gID8gX19wZnhfZmlsZW1hcF9nZXRf
Zm9saW9zX3RhZysweDEwLzB4MTANCiBbICAxMjMuMTQ4MTEwXSAgX19mb2xpb19iYXRjaF9yZWxl
YXNlKzB4NTIvMHhlMA0KIFsgIDEyMy4xNDgxMTVdICBjZXBoX3dyaXRlcGFnZXNfc3RhcnQrMHgy
NzdhLzB4NDVmMA0KIFsgIDEyMy4xNDgxMjldICA/IHVwZGF0ZV9sb2FkX2F2ZysweDFiZC8weDFm
ZTANCiBbICAxMjMuMTQ4MTQ1XSAgPyBkZXF1ZXVlX2VudGl0eSsweDNlNS8weDE0NTANCiBbICAx
MjMuMTQ4MTUxXSAgPyBhdGFfc2ZmX3FjX2lzc3VlKzB4NDQzLzB4YTkwDQogWyAgMTIzLjE0ODE3
NV0gID8ga3ZtX3NjaGVkX2Nsb2NrX3JlYWQrMHgxMS8weDIwDQogWyAgMTIzLjE0ODE5OF0gID8g
c2NoZWRfY2xvY2tfbm9pbnN0cisweDkvMHgxMA0KIFsgIDEyMy4xNDgyMDNdICA/IHNjaGVkX2Ns
b2NrKzB4MTAvMHgzMA0KIFsgIDEyMy4xNDgyMTZdICA/IF9fcGZ4X2NlcGhfd3JpdGVwYWdlc19z
dGFydCsweDEwLzB4MTANCiBbICAxMjMuMTQ4MjIxXSAgPyBwc2lfZ3JvdXBfY2hhbmdlKzB4M2Zh
LzB4OGEwDQogWyAgMTIzLjE0ODIzM10gID8gX19wZnhfc2NoZWRfY2xvY2tfY3B1KzB4MTAvMHgx
MA0KIFsgIDEyMy4xNDgyMzhdICA/IHNldF9uZXh0X2VudGl0eSsweDMyNS8weGI0MA0KIFsgIDEy
My4xNDgyNDVdICA/IG5jc2lfY2hhbm5lbF9tb25pdG9yLmNvbGQrMHgzNmQvMHg1NTMNCiBbICAx
MjMuMTQ4MjY5XSAgPyBfX2thc2FuX2NoZWNrX3dyaXRlKzB4MTQvMHgzMA0KIFsgIDEyMy4xNDgy
ODNdICA/IF9yYXdfc3Bpbl9sb2NrKzB4ODIvMHhmMA0KIFsgIDEyMy4xNDgyOTNdICA/IF9fcGZ4
X19yYXdfc3Bpbl9sb2NrKzB4MTAvMHgxMA0KIFsgIDEyMy4xNDgyOThdICBkb193cml0ZXBhZ2Vz
KzB4MWUxLzB4NTQwDQogWyAgMTIzLjE0ODMwM10gID8gZG9fd3JpdGVwYWdlcysweDFlMS8weDU0
MA0KIFsgIDEyMy4xNDgzMDhdICBfX3dyaXRlYmFja19zaW5nbGVfaW5vZGUrMHhhNy8weDk0MA0K
IFsgIDEyMy4xNDgzMTJdICA/IF9yYXdfc3Bpbl91bmxvY2srMHhlLzB4NDANCiBbICAxMjMuMTQ4
MzE1XSAgPyB3YmNfYXR0YWNoX2FuZF91bmxvY2tfaW5vZGUrMHg0NDAvMHg2MTANCiBbICAxMjMu
MTQ4MzI1XSAgPyBfX3BmeF9jYWxsX2Z1bmN0aW9uX3NpbmdsZV9wcmVwX2lwaSsweDEwLzB4MTAN
CiBbICAxMjMuMTQ4MzM2XSAgd3JpdGViYWNrX3NiX2lub2RlcysweDU2My8weGU0MA0KIFsgIDEy
My4xNDgzNDFdICA/IF9fcGZ4X3dyaXRlYmFja19zYl9pbm9kZXMrMHgxMC8weDEwDQogWyAgMTIz
LjE0ODM0OF0gID8gX19wZnhfbW92ZV9leHBpcmVkX2lub2RlcysweDEwLzB4MTANCiBbICAxMjMu
MTQ4MzYwXSAgX193cml0ZWJhY2tfaW5vZGVzX3diKzB4YmUvMHgyMTANCiBbICAxMjMuMTQ4MzY0
XSAgd2Jfd3JpdGViYWNrKzB4NGU0LzB4NmYwDQogWyAgMTIzLjE0ODM2OF0gID8gX19wZnhfd2Jf
d3JpdGViYWNrKzB4MTAvMHgxMA0KIFsgIDEyMy4xNDg0MTZdICA/IGdldF9ucl9kaXJ0eV9pbm9k
ZXMrMHhkYy8weDFlMA0KIFsgIDEyMy4xNDg0MjZdICB3Yl93b3JrZm4rMHg1YTkvMHhiMzANCiBb
ICAxMjMuMTQ4NDMwXSAgPyBfX3BmeF93Yl93b3JrZm4rMHgxMC8weDEwDQogWyAgMTIzLjE0ODQz
M10gID8gX19wZnhfX19zY2hlZHVsZSsweDEwLzB4MTANCiBbICAxMjMuMTQ4NDM4XSAgPyBfX3Bm
eF9fcmF3X3NwaW5fbG9ja19pcnErMHgxMC8weDEwDQogWyAgMTIzLjE0ODQ0Ml0gIHByb2Nlc3Nf
b25lX3dvcmsrMHg2MTEvMHhlMjANCiBbICAxMjMuMTQ4NDQ4XSAgPyBfX2thc2FuX2NoZWNrX3dy
aXRlKzB4MTQvMHgzMA0KIFsgIDEyMy4xNDg0NTJdICB3b3JrZXJfdGhyZWFkKzB4N2UzLzB4MTU4
MA0KIFsgIDEyMy4xNDg0NTZdICA/IF9fcGZ4X3dvcmtlcl90aHJlYWQrMHgxMC8weDEwDQogWyAg
MTIzLjE0ODQ1OF0gIGt0aHJlYWQrMHgzODEvMHg3YTANCiBbICAxMjMuMTQ4NDYzXSAgPyBfX3Bm
eF9fcmF3X3NwaW5fbG9ja19pcnErMHgxMC8weDEwDQogWyAgMTIzLjE0ODQ2Nl0gID8gX19wZnhf
a3RocmVhZCsweDEwLzB4MTANCiBbICAxMjMuMTQ4NDY4XSAgPyBfX2thc2FuX2NoZWNrX3dyaXRl
KzB4MTQvMHgzMA0KIFsgIDEyMy4xNDg0NzFdICA/IHJlY2FsY19zaWdwZW5kaW5nKzB4MTYwLzB4
MjIwDQogWyAgMTIzLjE0ODQ3OF0gID8gX3Jhd19zcGluX3VubG9ja19pcnErMHhlLzB4NTANCiBb
ICAxMjMuMTQ4NDgxXSAgPyBjYWxjdWxhdGVfc2lncGVuZGluZysweDc4LzB4YjANCiBbICAxMjMu
MTQ4NDg0XSAgPyBfX3BmeF9rdGhyZWFkKzB4MTAvMHgxMA0KIFsgIDEyMy4xNDg0ODddICByZXRf
ZnJvbV9mb3JrKzB4Mjg1LzB4MzUwDQogWyAgMTIzLjE0ODQ5MF0gID8gX19wZnhfa3RocmVhZCsw
eDEwLzB4MTANCiBbICAxMjMuMTQ4NDkzXSAgcmV0X2Zyb21fZm9ya19hc20rMHgxYS8weDMwDQog
WyAgMTIzLjE0ODQ5OV0gIDwvVEFTSz4NCiBbICAxMjMuMTQ4NTAxXSAtLS1bIGVuZCB0cmFjZSAw
MDAwMDAwMDAwMDAwMDAwIF0tLS0NCg0KVGhlIHdhcm5pbmcgaGFzIGJlZW4gZWxpbWluYXRlZCBi
eSBhcHBseWluZyBzdWdnZXN0ZWQgZml4LiBUaGUgc3VnZ2VzdGVkIHBhdGNoDQpoYXMgYmVlbiB0
ZXN0ZWQgYnkgeGZzdGVzdHMgYW5kIG5vIHJlZ3Jlc3Npb24gb3IgaXNzdWUgaGFzIGJlZW4gZGV0
ZWN0ZWQuDQoNClJldmlld2VkLWJ5OiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5a29A
aWJtLmNvbT4NClRlc3RlZC1ieTogVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGli
bS5jb20+DQoNClRoYW5rcywNClNsYXZhLg0KDQpbMV0NCmh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2FsbC8yMDI1MDgyNjIzMTYyNi4yMTg2NzUtMS1tYXgua2VsbGVybWFubkBpb25vcy5jb20vDQo=

