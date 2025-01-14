Return-Path: <ceph-devel+bounces-2444-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CF809A11562
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2025 00:28:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D6CF7A0548
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2025 23:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 804492144DB;
	Tue, 14 Jan 2025 23:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EugZppgS"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7D620F077
	for <ceph-devel@vger.kernel.org>; Tue, 14 Jan 2025 23:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736897282; cv=fail; b=khOis2m85genqppm12ggEFZQ6Au46TpAqAukpB+Nkkl0jqyeRX951MgWDZLx/Z1KK9rVimMKl0It2NmDOhfhqv+Uaac6IWe1MOeG8OZ+uzojZEl0zw2T7kGNlvfkLu9RvulqxWsa6pO3Y5AIZwHxxfPA5/Bi6zfPpxWRqQW2nho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736897282; c=relaxed/simple;
	bh=yPU+dJXqD3rGCqNoxrA02Xr9k1vHen6ypdbYlo0KA0I=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=PJQkB5nZCr1REtGHN6kYBbCDydalAYBDuVCpY6VkHXF5MAY2ajYiiCRRfgNjp48Bfk83flQRjciARNcQpwOoWGprrQmsfBuptocQnbnJy++/4KguM8fLevqza/aqdrVwrXx0/meBds9bpAgTFTFYnOfdwnKzhGn2MDgGJADp9aA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EugZppgS; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EFUTZ5005925;
	Tue, 14 Jan 2025 23:27:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=yPU+dJXqD3rGCqNoxrA02Xr9k1vHen6ypdbYlo0KA0I=; b=EugZppgS
	ExsWCutqvUK37gDrPWj941sPA4rbGzVVJDEA6HFwi6MzxGEz8nqIRKer3e00BVOC
	f+9ymuMK4fTyOCBOmOH7X0RrUUUd+EpL/pApg0lbziBjkc1KdvEciuzlRK+Jidgp
	dz4IQkGSGoPGJGTGI9vJILH63hzrmUpo5P+qjnDs6rXh5VN82/b/brL1Vxw/IMy3
	ThH33VurYyxQB2uWlkUvxJWSYvRLw+N8AGGJ6pMfE67ZW2M8NugT+Euccp9fNTzo
	G3UKBGvBnetjInmjIwe0YzA3xrh634IoFW346+Th0GGlX4eL2gfagUxK5MNPjC4K
	rWAuAQ7hTG31SA==
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 445tmghwt6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jan 2025 23:27:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hkdWxdttvhzEafTGptZTXf/6sV4lJ18JUnhI9jRsz8/fANbdFAor43sv0S5jzEcNasnTRdIyQkIzBoPby9j5Dc7b2vv8pIEQ8fc1pRC1GHTcoVN7xIsF7KqKuByqFfaON8i17LNt/vHJXuALdJgRTAlxgGZOU7tl5WEy11Ep0uGDxg6xlOlon1PusKDmlhQExxKAJ3CfYcQ8odip4KFQuP6ARJTttBMiqWiZxV8KmkMtrhNiHJB4LlcEHSk5GRs/OXnyZ/IjfMBfrdvhPQqf6Tuq/R1SZHVaa9PY1IzDJamUdWcxnsjkprV+drDGcDJ/choL/S9fD+y/yA3ZwehQWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPU+dJXqD3rGCqNoxrA02Xr9k1vHen6ypdbYlo0KA0I=;
 b=QWr5e8QrmRSVCQ/XUh4cn3pdFBL+xKUFBpusd0HqGLF+bcSakj7Sc4jqe7AWMitc76hu4ypjrD8rE2bRKNrCHf85IGPqR8YCsmHVVWUrth4U/ISpsJjhQZnLbE+dLGV8vRxJKz9N/2zRuO4ae1QBJXvNUCvuqpBvGwXfrCQEY9GOeL8tVmtEAm0lDFi7EJbanixvAd48S6j5QOOxYBX3RDzOxPMaMJy08MnGrkjqQx67MvRY31bduXGEIxwXRTtLYsDeIzOOJ4O7hN3Qz4Dr8iKOaufwunrXcErwa+1/nUscGy//JD3z3d378KUXtGKE0CMsMJm4xuyXAQ5k0RLcwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB4774.namprd15.prod.outlook.com (2603:10b6:a03:37c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Tue, 14 Jan
 2025 23:27:50 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 23:27:50 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "antoine@lesviallon.fr" <antoine@lesviallon.fr>
Thread-Topic: [EXTERNAL] [PATCH v2] ceph: fix memory leak in
 ceph_mds_auth_match()
Thread-Index: AQHbZtYErAs7xsHLA0ycXULUhWND4bMW6i4A
Date: Tue, 14 Jan 2025 23:27:50 +0000
Message-ID: <752b6575c3a8a6042bba51ad56a3d4b71c5a3bb0.camel@ibm.com>
References: <20250114123806.2339159-1-antoine@lesviallon.fr>
	 <20250114224514.2399813-1-antoine@lesviallon.fr>
In-Reply-To: <20250114224514.2399813-1-antoine@lesviallon.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB4774:EE_
x-ms-office365-filtering-correlation-id: 883b7bd3-1411-44d2-89bb-08dd34f31006
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YVJoaHUva0FtV1ZOQ3pGY0wwUDVjYTBSdjBBUHVSdnFVd3o1UUIzOHlHUkxx?=
 =?utf-8?B?VU1LYU1KMkNZUUZBQi91YnY2RHhLa01tb1cwRHloWnhmcFA2U3VLd2pnMGhh?=
 =?utf-8?B?TDZZMDdBTzJDMUtjd2pJNEFsVUkxampkQlRuNTZKTklCRDhYQ1lJVTNDNWpX?=
 =?utf-8?B?S29mSjVMbGpTc3pRQmlLdkJYL2lTaUUzQU5EOUk2R2ordmlLQStNbzZsdWJu?=
 =?utf-8?B?RGRxb1RBV3BEdXQ2eHZkZzVSQzF0enkyTS9Vei82dEVXSXgxK0JhRVIrVEUw?=
 =?utf-8?B?UER5VFJNVkJnREg1K1JFcTlsTmhndTYzSnI0Z0lBSDNOUU55a0lnNXhZWU90?=
 =?utf-8?B?dnhNYmZmK1I1V0pXZ1BuWW54aUxscnVLVzdrbXcrRWl3aGRLMnowejl1SldM?=
 =?utf-8?B?VjN1R0t0c0tvRWxFaHZQZGVhRndidlZRMklZMVJPOVZQTjJBRDFodzZjMEty?=
 =?utf-8?B?eU9adzBNcXVJTU03WnN3ckk1cWpiekdmZXQzZnJ1dk8rSnVBcXdrYnVDKzFN?=
 =?utf-8?B?MHd4aUVOWWlIem1PVlBrRm14RzVlVjV0RDZHYU9WcGpmOWt3UzBjWjhOb0kr?=
 =?utf-8?B?djFDRnRoVVI1aWV0R2JhcmdPOUQxSkd3Q3lDbDc4WkJQbGhtc0ZQY2NGUm9H?=
 =?utf-8?B?Y2lzWTNpY01Sa1VkVjhkY3lZTk1iV0VTWmY2cDNUUUFTYW1PUmowRCtIWGRN?=
 =?utf-8?B?cFpOd1pXc2VBZ2hiN2FzakNFTkR0bG9Zb2hOYVBWd0toVUhJT010aGFTR0F1?=
 =?utf-8?B?dzc3ZktJdHJKZTk0ZnNrTjZXSGtnRFYxMFRKZHhMTlRyenVKSEpPYlBrTDBh?=
 =?utf-8?B?ejROcjk4TFUvVDdBaU1sSm5JRjhyaTlKUGllNUxVbktOQlNmTmg2YWMxK2Nz?=
 =?utf-8?B?SHBGRTVCK0xsNFdGbHVuODRydVJsd2Y5UFVnUlp5UkpKVWdEd0g4ZVVaUEk0?=
 =?utf-8?B?Q1M4YU9GbTM2Vkd3aDhjY2gzUUdMbGFQUlZGcVZHYUV4WFpzeEZKWk5SSEhM?=
 =?utf-8?B?NHk3R0JVQ1cyV2xGa1dERHlHYVBvanJzM29DNXRZSEtrSmsvUEtaUFB0cU1Y?=
 =?utf-8?B?Z0hsTnJSSlNvbjE1ZHphajZLaHNWVEZZa3VHSVB3MnphejczZE9RVjgvd0Jz?=
 =?utf-8?B?NitDVENWVFBXbkFXY2I1NzkyMm5pdEVnZ0NSZ1VWb0tzd2MyR2FMbUozTUR6?=
 =?utf-8?B?bElnYWZQVUx5ZllreFJvUVpoVTd3QUFocUpRYXo3S0xOZmRaalZ4MDRXeWJL?=
 =?utf-8?B?UVZQK1paTlgvak56dlRlUTBScS9ialdTR280aWlncU84QUNtbnF2dCs2OE5p?=
 =?utf-8?B?VGNzd0hoM2pNT0lVcndqZUFURW1JSEkxcmVOSW9FV0ZPbHE0TmNvcHk4aitr?=
 =?utf-8?B?VXZZT0JrK1lhcmorS1BHVGlkdWZyRTJvNlY2VHpBRlIrQnl4N3FkMnpMNzRo?=
 =?utf-8?B?Y2xDdE5rVUlCbEFuVGgxWTJLOUo0NWsyMXhYdlM2Qjg5U1piQmFLdXh2UHhh?=
 =?utf-8?B?TTBaeU5RcW1EL21hQ2hvbGtkd2ExNDlDOUt2ZGxxalkxaU9zbzVGQ2RiSVAx?=
 =?utf-8?B?dVErTmtEZ1ZTb21wQ3pOZDFsanNQYlUzb2xtSlFVeEpwQ3VWOGk3eFRZTFNn?=
 =?utf-8?B?T0VaYzNCQkh0NkdMbmRmczhCLzhvTENtaVJKdlBibzVYckdrc0d4ZDZmVFZ1?=
 =?utf-8?B?akM5OG1vL2tYYTM1Nkw0clV4ajNaNlpmWlFEU1RFckltMnFtamVaZERnNHBX?=
 =?utf-8?B?Rm5XazNRWDBreTlDWjd0WDVoZVhuazFpd1BSbkxXOVJJQml6bzdqMkRpK0Qy?=
 =?utf-8?B?elpUbm15K1Z6cjkvK1dHeHI0ek5GT3doaTVZR2U0OEZuakEyQ3B4RHAyQzVz?=
 =?utf-8?B?enVrRThqNXJkOU1oNjVvOUdhdkM0NWpxV1o1UG4yYlBKRlE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?enZzVlo4bXdEUjF5dFRYVjZGeHJrNE1IUm9BdjI3WVhGai9mcUw0b3lpUm4y?=
 =?utf-8?B?Y1hHK3hzenlkU1hZRlBXT2JSRnlMaHlSbFZXOXRneEprZ0NuTWFjT0JFVGtG?=
 =?utf-8?B?Sno4YmdwVk55Y0lpUllndGpMSjduZW1pd1ZnOHZWdi9lUDBSaTR4V1h5NGZm?=
 =?utf-8?B?OW9kS0dXdDltUVR6c0s5VDFRZnlyN3dBdDRBNk9iNXR2Z3BOVTZBTmgveE9u?=
 =?utf-8?B?c2xqUzFsVGVEQVVnK2JKZVJFMVBUNVVYV010QzVMd1pKOWQ5aWdRN1hpYUla?=
 =?utf-8?B?OU9OUTZEUm5qQVdhYkdTc3hXTzQ3YS83YldFS0pjQVJXQkRJZGhiT3JQMEJi?=
 =?utf-8?B?enZmOFNRWWVSSVdqRUhVWERqYkFudWxWbU1sdFptRi9oaFhDWWdqMUdkOEIx?=
 =?utf-8?B?NnJuTklCRHpFVVdTNHkrZkI5WHRVODJUNk1qanZhUmwwdng3emNtUmZpL1M5?=
 =?utf-8?B?d3dLMzFObDZ4SksrT21wN0gvczRuMnJTVEdxSXBVL3VvWFM3WkZhcUtMWlVy?=
 =?utf-8?B?ZVJLUkxvVkUwMzJ3TUhtaGMvYnpvQnJER0ZSd2dpU29OK1Y2S1RWYk5rWW5j?=
 =?utf-8?B?MWtiWFNmMTNTbVV2Y1JLeDNJSFNaNng4bXRxTkxVcnJEbnFmYjY5ZlNIRytI?=
 =?utf-8?B?QVRjTHNkYWtBVlJucGV0Wmo3R0ZXOEl1OWw3VmFSeU1ocVd0dEFhV3k4aUQv?=
 =?utf-8?B?VjVJOU0rS3JtMjVYeEkyZmNlOGJhRXp2eVZqOFFBS2h3aUovV0hBdTF6Vmxv?=
 =?utf-8?B?QjgxQ2FobSt5T1phenpkaWg4aUNiRXNWWG03ZDBQRTRRL2VZSHB5ZUFCeHB5?=
 =?utf-8?B?aFpxQVlGbnI4Z0EzTjFrRi9rZEJZaWVuaDNGTjZ3NXR5MUY5RGFrOFlIY2xI?=
 =?utf-8?B?bkp4d0JKcnRXZFdjS3lsNmVRVjZoVnVYTWx4WHNHVm5FbExWZVRXU3ppOU94?=
 =?utf-8?B?VTJ5aE9LT0UwK242WFZqVHIrYmJ1SHJwQk1kdlJ2VXhLR1huZVdoOGFIdWZ2?=
 =?utf-8?B?SzlvZVJIYzZpSkZDMUMvbnM5aWFVcnJBdHdsY3YwNjE1K3BCNkVKREwyWTVr?=
 =?utf-8?B?VFpnbUZ4TmR4R3lQM0JsRko3R2dlQm00Y0YrUjdMajlsbzRIdi9yWTBHTXZm?=
 =?utf-8?B?cHZ4ZHY2SFlXVUxDeEdtYWgzWTQwVmR4Sk53bXcyT3lLSlhGTUJaZmJpRGhT?=
 =?utf-8?B?RitCRDBzdzBGMUlmWDF1V0Irc21BSkJDcVVZVTRQSlBTT0E5T0dROHZUUGxM?=
 =?utf-8?B?MmczcGMrNDQzOCtuanBqYXMvUCtORzlYay9wQUh2TUdrblpRWWdZMkZ1L3lG?=
 =?utf-8?B?eW1nTnVLMWdad294eTBUMVdrT1lGWENNTUxTbm1xY0w4RFFQc1YyYTQwM0Rj?=
 =?utf-8?B?RHlNcVFnYlF3bC9YWGJMMmVITmtJMUIvQjhlVEkwSDlmMUJveSs4Tk5uRnRl?=
 =?utf-8?B?NDB3ZDBlNWkwREFsazNFanM4Ykh0cnEvajViWkMzdUp2MnVzc1F0eXQ0bUZx?=
 =?utf-8?B?d2FpeEl3K3BNN1o4c3FNMUNxK2xHSWZSNHVCUjRLUHJ4WmQwUERpME94S2VG?=
 =?utf-8?B?QVBxNHBGSnBrT1JMYnhPUDBPTGN5QVVwMHdCbU9ISjdvRGk0aE54SkNhbG0r?=
 =?utf-8?B?ZzNYSDJERVJVZzBmN3duaTZhSE9acTFjajJrZ01XblMvNW81VjdTT1k4WTd4?=
 =?utf-8?B?Q3J6UThxRVdaaHNvNU1DYnJ4RWtsT25JclBhSFVUS3dpOE0xanExeGx1L2JB?=
 =?utf-8?B?akNUYkVYbnNDS2kzQ1JYMEUya2FVWnFuQng4RWpZME5vd0xKTXVSVmhpK0s3?=
 =?utf-8?B?azRZRW9DNkNFVDZaSXBOV1dwenhZODVJZW9vSXV1SENmRVk2QUQvME1QQVlq?=
 =?utf-8?B?N3cyK2dlQXJOUE91RWF4eXRER1lpZ3hTellwaEo2S3hyN3FNbXkxYWlTQkhn?=
 =?utf-8?B?NEYrUXNLUGZBUmRJaTNvamY5WG9MdUZ2M2RUaGtGeERKYUtqL1JKMitNK2pX?=
 =?utf-8?B?U01VdWk1amY4dE5ISmQ3cmdqTkhPOTVJbXVOLy81aE1Sa3gvYUVjSEpQRWE4?=
 =?utf-8?B?ankrS2M1ZnNHUFBvdTU2cHljK2RFV2NpUEYzNlgrdXNwQk9PQ2Z2KzA3ZDdU?=
 =?utf-8?B?SHFaT1cvb1VWa1VUOVZ4dEpaOTFNMmNaRy9SNys2OCtVQXRkTm1BcTNiRlJL?=
 =?utf-8?Q?DzEX3yHaXMkB/WPH0dVYelU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B24D827CEBCC04E9B2C079095856A3F@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 883b7bd3-1411-44d2-89bb-08dd34f31006
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2025 23:27:50.6418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bHu151CQ4uhaHxpQNBHmj6W/RXMfdgV1NSD/vZYEj1va7c2VorEnuO57KOOFWBSvEzepI7Wns5CryCb8nxYNHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4774
X-Proofpoint-GUID: sxYKIENBIHuB60X01ZS-3yLx2kxug94L
X-Proofpoint-ORIG-GUID: sxYKIENBIHuB60X01ZS-3yLx2kxug94L
Subject: Re:  [PATCH v2] ceph: fix memory leak in ceph_mds_auth_match()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-14_08,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501140173

T24gVHVlLCAyMDI1LTAxLTE0IGF0IDIzOjQ1ICswMTAwLCBBbnRvaW5lIFZpYWxsb24gd3JvdGU6
DQo+IFdlIG5vdyBmcmVlIHRoZSB0ZW1wb3JhcnkgdGFyZ2V0IHBhdGggc3Vic3RyaW5nIGFsbG9j
YXRpb24gb24gZXZlcnkNCj4gcG9zc2libGUgYnJhbmNoLCBpbnN0ZWFkIG9mIG9taXR0aW5nIHRo
ZSBkZWZhdWx0IGJyYW5jaC4NCj4gSW4gc29tZSBjYXNlcywgYSBtZW1vcnkgbGVhayBvY2N1cmVk
LCB3aGljaCBjb3VsZCByYXBpZGx5IGNyYXNoIHRoZQ0KPiBzeXN0ZW0gKGRlcGVuZGluZyBvbiBo
b3cgbWFueSBmaWxlIGFjY2Vzc2VzIHdlcmUgYXR0ZW1wdGVkKS4NCj4gDQo+IFRoaXMgd2FzIGRl
dGVjdGVkIGluIHByb2R1Y3Rpb24gYmVjYXVzZSBpdCBjYXVzZWQgYSBjb250aW51b3VzIG1lbW9y
eQ0KPiBncm93dGgsDQo+IGV2ZW50dWFsbHkgdHJpZ2dlcmluZyBrZXJuZWwgT09NIGFuZCBjb21w
bGV0ZWx5IGhhcmQtbG9ja2luZyB0aGUNCj4ga2VybmVsLg0KPiANCj4gUmVsZXZhbnQga21lbWxl
YWsgc3RhY2t0cmFjZToNCj4gDQo+IMKgwqDCoCB1bnJlZmVyZW5jZWQgb2JqZWN0IDB4ZmZmZjg4
ODEzMWU2OTkwMCAoc2l6ZSAxMjgpOg0KPiDCoMKgwqDCoMKgIGNvbW0gImdpdCIsIHBpZCA2NjEw
NCwgamlmZmllcyA0Mjk1NDM1OTk5DQo+IMKgwqDCoMKgwqAgaGV4IGR1bXAgKGZpcnN0IDMyIGJ5
dGVzKToNCj4gwqDCoMKgwqDCoMKgwqAgNzYgNmYgNmMgNzUgNmQgNjUgNzMgMmYgNjMgNmYgNmUg
NzQgNjEgNjkgNmUgNjXCoA0KPiB2b2x1bWVzL2NvbnRhaW5lDQo+IMKgwqDCoMKgwqDCoMKgIDcy
IDczIDJmIDY3IDY5IDc0IDY1IDYxIDJmIDY3IDY5IDc0IDY1IDYxIDJmIDY3wqANCj4gcnMvZ2l0
ZWEvZ2l0ZWEvZw0KPiDCoMKgwqDCoMKgIGJhY2t0cmFjZSAoY3JjIDJmM2JiNDUwKToNCj4gwqDC
oMKgwqDCoMKgwqAgWzxmZmZmZmZmZmFhNjhmYjQ5Pl0gX19rbWFsbG9jX25vcHJvZisweDM1OS8w
eDUxMA0KPiDCoMKgwqDCoMKgwqDCoCBbPGZmZmZmZmZmYzMyYmYxZGY+XSBjZXBoX21kc19jaGVj
a19hY2Nlc3MrMHg1YmYvMHgxNGUwDQo+IFtjZXBoXQ0KPiDCoMKgwqDCoMKgwqDCoCBbPGZmZmZm
ZmZmYzMyMzU3MjI+XSBjZXBoX29wZW4rMHgzMTIvMHhkODAgW2NlcGhdDQo+IMKgwqDCoMKgwqDC
oMKgIFs8ZmZmZmZmZmZhYTdkZDc4Nj5dIGRvX2RlbnRyeV9vcGVuKzB4NDU2LzB4MTEyMA0KPiDC
oMKgwqDCoMKgwqDCoCBbPGZmZmZmZmZmYWE3ZTM3Mjk+XSB2ZnNfb3BlbisweDc5LzB4MzYwDQo+
IMKgwqDCoMKgwqDCoMKgIFs8ZmZmZmZmZmZhYTgzMjg3NT5dIHBhdGhfb3BlbmF0KzB4MWRlNS8w
eDQzOTANCj4gwqDCoMKgwqDCoMKgwqAgWzxmZmZmZmZmZmFhODM0ZmNjPl0gZG9fZmlscF9vcGVu
KzB4MTljLzB4M2MwDQo+IMKgwqDCoMKgwqDCoMKgIFs8ZmZmZmZmZmZhYTdlNDRhMT5dIGRvX3N5
c19vcGVuYXQyKzB4MTQxLzB4MTgwDQo+IMKgwqDCoMKgwqDCoMKgIFs8ZmZmZmZmZmZhYTdlNDk0
NT5dIF9feDY0X3N5c19vcGVuKzB4ZTUvMHgxYTANCj4gwqDCoMKgwqDCoMKgwqAgWzxmZmZmZmZm
ZmFjMmNjMmY3Pl0gZG9fc3lzY2FsbF82NCsweGI3LzB4MjEwDQo+IMKgwqDCoMKgwqDCoMKgIFs8
ZmZmZmZmZmZhYzQwMDEzMD5dIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDc3LzB4
N2YNCj4gDQo+IEl0IGNhbiBiZSB0cmlnZ2VyZWQgYnkgbW91dGluZyBhIHN1YmRpcmVjdG9yeSBv
ZiBhIENlcGhGUyBmaWxlc3lzdGVtLA0KPiBhbmQgdGhlbiB0cnlpbmcgdG8gYWNjZXNzIGZpbGVz
IG9uIHRoaXMgc3ViZGlyZWN0b3J5IHdpdGggYW4gYXV0aA0KPiB0b2tlbiB1c2luZyBhIHBhdGgt
c2NvcGVkIGNhcGFiaWxpdHk6DQo+IA0KPiDCoMKgwqAgJCBjZXBoIGF1dGggZ2V0IGNsaWVudC5z
ZXJ2aWNlcw0KPiDCoMKgwqAgW2NsaWVudC5zZXJ2aWNlc10NCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBrZXkgPSBSRURBQ1RFRA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNhcHMgbWRzID0g
ImFsbG93IHJ3IGZzbmFtZT1jZXBoZnMgcGF0aD0vdm9sdW1lcy8iDQo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgY2FwcyBtb24gPSAiYWxsb3cgciBmc25hbWU9Y2VwaGZzIg0KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGNhcHMgb3NkID0gImFsbG93IHJ3IHRhZyBjZXBoZnMgZGF0YT1jZXBoZnMi
DQo+IA0KPiDCoMKgwqAgJCBjYXQgL3Byb2Mvc2VsZi9tb3VudHMNCj4gwqDCoMKgDQo+IHNlcnZp
Y2VzQDAwMDAwMDAwLTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAwMC5jZXBoZnM9L3ZvbHVtZXMv
Y29udGFpbg0KPiBlcnMgL2NlcGgvY29udGFpbmVycyBjZXBoDQo+IHJ3LG5vYXRpbWUsbmFtZT1z
ZXJ2aWNlcyxzZWNyZXQ9PGhpZGRlbj4sbXNfbW9kZT1wcmVmZXItDQo+IGNyYyxtb3VudF90aW1l
b3V0PTMwMCxhY2wsbW9uX2FkZHI9W1JFREFDVEVEXTozMzAwLHJlY292ZXJfc2Vzc2lvbj1jbA0K
PiBlYW4gMCAwDQo+IA0KPiDCoMKgwqAgJCBzZXEgMSAxMDAwMDAwIHwgeGFyZ3MgLVAzMiAtLXJl
cGxhY2U9e30gdG91Y2gNCj4gL2NlcGgvY29udGFpbmVycy9maWxlLXt9ICYmIFwNCj4gwqDCoMKg
IHNlcSAxIDEwMDAwMDAgfCB4YXJncyAtUDMyIC0tcmVwbGFjZT17fSBjYXQNCj4gL2NlcGgvY29u
dGFpbmVycy9maWxlLXt9DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbnRvaW5lIFZpYWxsb24gPGFu
dG9pbmVAbGVzdmlhbGxvbi5mcj4NCj4gLS0tDQo+IMKgZnMvY2VwaC9tZHNfY2xpZW50LmMgfCAx
NSArKysrKysrKystLS0tLS0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA2
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL2NlcGgvbWRzX2NsaWVudC5jIGIv
ZnMvY2VwaC9tZHNfY2xpZW50LmMNCj4gaW5kZXggNzg1ZmU0ODllZjRiLi5jM2I2MzI0M2MyZGQg
MTAwNjQ0DQo+IC0tLSBhL2ZzL2NlcGgvbWRzX2NsaWVudC5jDQo+ICsrKyBiL2ZzL2NlcGgvbWRz
X2NsaWVudC5jDQo+IEBAIC01NjkwLDE4ICs1NjkwLDIxIEBAIHN0YXRpYyBpbnQgY2VwaF9tZHNf
YXV0aF9tYXRjaChzdHJ1Y3QNCj4gY2VwaF9tZHNfY2xpZW50ICptZHNjLA0KPiDCoAkJCSAqDQo+
IMKgCQkJICogQWxsIHRoZSBvdGhlciBjYXNlc8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgDQo+IC0tPiBtaXNtYXRjaA0KPiDCoAkJCSAqLw0KPiArCQkJaW50IHJj
ID0gMTsNCj4gwqAJCQljaGFyICpmaXJzdCA9IHN0cnN0cihfdHBhdGgsIGF1dGgtDQo+ID5tYXRj
aC5wYXRoKTsNCj4gwqAJCQlpZiAoZmlyc3QgIT0gX3RwYXRoKSB7DQo+IC0JCQkJaWYgKGZyZWVf
dHBhdGgpDQo+IC0JCQkJCWtmcmVlKF90cGF0aCk7DQo+IC0JCQkJcmV0dXJuIDA7DQo+ICsJCQkJ
cmMgPSAwOw0KPiDCoAkJCX0NCj4gwqANCj4gwqAJCQlpZiAodGxlbiA+IGxlbiAmJiBfdHBhdGhb
bGVuXSAhPSAnLycpIHsNCj4gLQkJCQlpZiAoZnJlZV90cGF0aCkNCj4gLQkJCQkJa2ZyZWUoX3Rw
YXRoKTsNCj4gLQkJCQlyZXR1cm4gMDsNCj4gKwkJCQlyYyA9IDA7DQo+IMKgCQkJfQ0KPiArDQo+
ICsJCQlpZiAoZnJlZV90cGF0aCkNCj4gKwkJCcKgIGtmcmVlKF90cGF0aCk7DQoNCkkgaGF2ZSBz
b21lIHdvcnJ5IGhlcmUuIE1heWJlLCBJIGFtIHdyb25nLiBJbml0aWFsbHksIHdlIHJlY2VpdmUg
dHBhdGgNCnBvaW50ZXIgYXMgZnVuY3Rpb24gYXJndW1lbnQ6DQoNCmh0dHBzOi8vZWxpeGlyLmJv
b3RsaW4uY29tL2xpbnV4L3Y2LjEzLXJjMy9zb3VyY2UvZnMvY2VwaC9tZHNfY2xpZW50LmMjTDU2
MDUNCg0KVGhlbiwgd2UgYXNzaWduIHRwYXRoIHRvIF90cGF0aDoNCg0KaHR0cHM6Ly9lbGl4aXIu
Ym9vdGxpbi5jb20vbGludXgvdjYuMTMtcmMzL3NvdXJjZS9mcy9jZXBoL21kc19jbGllbnQuYyNM
NTY1MQ0KDQpXZSBhbGxvY2F0ZSBtZW1vcnkgYnkgY29uZGl0aW9uOg0KDQoJCQlpZiAoc3BhdGgg
JiYgKG0gPSBzdHJsZW4oc3BhdGgpKSAhPSAxKSB7DQoJCQkJLyogbW91bnQgcGF0aCArICcvJyAr
IHRwYXRoICsgYW4gZXh0cmENCnNwYWNlICovDQoJCQkJbiA9IG0gKyAxICsgdGxlbiArIDE7DQoJ
CQkJX3RwYXRoID0ga21hbGxvYyhuLCBHRlBfTk9GUyk7DQoJCQkJaWYgKCFfdHBhdGgpDQoJCQkJ
CXJldHVybiAtRU5PTUVNOw0KCQkJCS8qIHJlbW92ZSB0aGUgbGVhZGluZyAnLycgKi8NCgkJCQlz
bnByaW50ZihfdHBhdGgsIG4sICIlcy8lcyIsIHNwYXRoICsNCjEsIHRwYXRoKTsNCgkJCQlmcmVl
X3RwYXRoID0gdHJ1ZTsNCgkJCQl0bGVuID0gc3RybGVuKF90cGF0aCk7DQoJCQl9DQoNCmh0dHBz
Oi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L3Y2LjEzLXJjMy9zb3VyY2UvZnMvY2VwaC9tZHNf
Y2xpZW50LmMjTDU2NjANCg0KV2hhdCBpZiBjb25kaXRpb24gaXMgbm90IHRydWUgYW5kIHdlIGRv
bid0IGFsbG9jYXRlIG1lbW9yeT8gV2Ugc3RpbGwNCmhhdmUgX3RwYXRoIGtlZXBpbmcgdGhlIHBv
aW50ZXIgb24gdHBhdGggYW5kIGtmcmVlKCkgd2lsbCBiZSBjYWxsZWQuIEl0DQpzb3VuZHMgZm9y
IG1lIHRoYXQgd2UgY2FuIGZyZWUgdHBhdGggYW5kIGNhbGxlciBvZg0KY2VwaF9tZHNfYXV0aF9t
YXRjaCgpIHdpbGwgaGF2ZSB1c2UtYWZ0ZXItZnJlZSBpc3N1ZS4gQW0gSSByaWdodCBoZXJlPw0K
RG8gSSBtaXNzIHNvbWV0aGluZyBoZXJlPw0KDQpUaGFua3MsDQpTbGF2YS4NCg0KDQo+ICsNCj4g
KwkJCWlmICghcmMpDQo+ICsJCQnCoCByZXR1cm4gMDsNCj4gwqAJCX0NCj4gwqAJfQ0KPiDCoA0K
DQo=

