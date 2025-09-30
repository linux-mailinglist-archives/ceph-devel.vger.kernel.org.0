Return-Path: <ceph-devel+bounces-3766-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BCCBAE51A
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Sep 2025 20:33:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BDB9324384
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Sep 2025 18:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADC28217F2E;
	Tue, 30 Sep 2025 18:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SOTNkMwf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C4033EC
	for <ceph-devel@vger.kernel.org>; Tue, 30 Sep 2025 18:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759257182; cv=fail; b=q29X0elAYUTBptmwtE7EclrrrWFF7qn7FOv/KoqOyiv/1s5mQX/2rJyW1a+xm86gW1qM/3yLCq63UYaC/6LWG4+10EC6Gzz6u/rESZh8niQiBzk4xZwYR5kY2U4vzKCIckmmGVMMgd1/iux2Bqbhhj1PiwPOrSV4rcRUE8GHGmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759257182; c=relaxed/simple;
	bh=qmfDfkFjxYtvBtpYdo+pcD5+nr+Ql7zZ4quvFKpExMg=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=st2eXG0ov4+XDH6z9fmLPEgHlI7Np8WvQ/A1CiFgPYdp+MW5Vpjop3xJvIgdzV6z6+5fTuvOCER3yRx/fbg89gYISYt1RzgBceMQh3/i9iIpmfVc2nDqubGLVOuuNq4ziit833ZtZw8ZDXq6mGogHatUAak/Q4uWpePMpmveHzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SOTNkMwf; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58UFRGuj020699;
	Tue, 30 Sep 2025 18:32:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=qmfDfkFjxYtvBtpYdo+pcD5+nr+Ql7zZ4quvFKpExMg=; b=SOTNkMwf
	wNq8RDs8ZucfPYxaPPcnXUoZcK/yyC0+bpU5OivvZ5DNj3tf9a2AZu7BvCoGzpKb
	AavSMRrtDD9z3UlhBzN5Bs1ph0yitOj4g2a1dpTe6v9nGk7SN+974txVdqr2PBgq
	SwVnRURSUgKu1TdEnS50XmrO6DSe98764nAutKo5nMwP8nCAMEPREmSpJ2QHHJgX
	yVc3GqSdEIG8NNSvNmRuCdwFIDj16RDhIyllGYEluSHNao81nrznqCGfZked3+f2
	+L/3fHJjuCPhA9YMICAGhCY9oMwBkO3l/DThqPIASmWjzbQx7nShxdw48hR8u6PM
	Wn8dw7CFxX3mrg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7jwj7r6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 18:32:46 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58UIMt30005706;
	Tue, 30 Sep 2025 18:32:46 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011033.outbound.protection.outlook.com [52.101.62.33])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7jwj7r1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 18:32:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BYwaxiHF3ry6z3JkynEd0ykdHQ3wuITIkFAQ0Cbzwsm9fJW+pBF16+yjLYf7+ITxiZhlPNZQzprOEqat9UGt400CbOq3t6m/hCKqOq20WJ+IaOypLHujigZ6LmBxlpY9+jstppDss5j/NBF9paldKKIMtZqPRY8hDyc8ThbO//OyGDg/R4X5zpat5Fhn1+ehDtC5JQNEFvtdXz0WPRpjakfx/109jl7RiI1fTAgnhL0uU6+o58gTPK8o71bwNbRp7X32KoQQ6CnWIaZguVz8YCtiyKVvn95rNXAun/8UF0ayyvLKPhI47Y+PbR7GNsDaSvkUfVlkfBsDV6wNVuEC/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qmfDfkFjxYtvBtpYdo+pcD5+nr+Ql7zZ4quvFKpExMg=;
 b=V0FZU43fjLh8w5tcsyTEn3SWNwQLWwqE/Hc8tcxd/OU5N9/cjo1ULAlC56QgZS6t3BhcjwTwFXcp1ldV8yNYwW6Cgvw/6G8PWY/6U4xrIfteOvFNu1MLpIzQJ90tbgCoz8fO8uPAKImVIlr3+nDgFszgLAY1exe/yKxVcnqp/sYJKL76q5xp5OUiRNK7TBFqYI40ywO92E049/FW6/PSc5WQ+QZ5GD6A31927ir1Q4n1DYlwMrKCKTw08cwMC0tvTvDb6GbwRGIXTMSuxKo8twoEiVWP5lRPP6MuUbogUsVZj++eLhOXaI9BcBlv37K5x+uKr3903HxWndn7045ixQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by LV8PR15MB6548.namprd15.prod.outlook.com (2603:10b6:408:269::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 18:32:42 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Tue, 30 Sep 2025
 18:32:42 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ethanwu@synology.com" <ethanwu@synology.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Xiubo Li
	<xiubli@redhat.com>,
        Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "ethan198912@gmail.com"
	<ethan198912@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH 1/2] ceph: fix snapshot context missing in
 ceph_zero_partial_object
Thread-Index: AQHcMdjuXYLBAWDkZUuhC/83CstMFrSsDYOA
Date: Tue, 30 Sep 2025 18:32:41 +0000
Message-ID: <6e8d05e8302521104a00abf8412568b8baf25d7f.camel@ibm.com>
References: <20250925104228.95018-1-ethanwu@synology.com>
	 <20250925104228.95018-2-ethanwu@synology.com>
	 <d9f111e47c7b9ab202f27bf46956c3a5f4d51671.camel@ibm.com>
	 <af89b60b-17e9-4362-bccf-977b4a573a93@Mail>
In-Reply-To: <af89b60b-17e9-4362-bccf-977b4a573a93@Mail>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|LV8PR15MB6548:EE_
x-ms-office365-filtering-correlation-id: c046e141-db82-4470-5401-08de004fbdd1
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?RXZSMzNLNmx1OU5LTG9RSUJrQVZTdmQ0VGd1ZzQxZjR3TlhRUTBZODJRNFRK?=
 =?utf-8?B?OFBOcVRFNlpVMHRxdStLT3VyS2s3bnB4TFV4K1FvYitLcGhkRm42cXFxTm9j?=
 =?utf-8?B?QjF4RXpyU1JIV3l4TWU5SnBMSUxPNXZpOHI4Nmxpbkd5RlVmQmZ3U2RpZDZq?=
 =?utf-8?B?ejdlNzJoSzJuOWN2bzNIOUZNNEhhWi9WaG8yNE1uNGhVTFE0MFpjUklEZjRZ?=
 =?utf-8?B?TDdqZjN3ZFVBcDZFYXdqNDg0Y0o3ekgvM1NIZ3dmMEZmOUF3bk5abW9HM0tu?=
 =?utf-8?B?TklNUWtOTmlHSm5oVjRVREIvdDV2ZGNMbk80WDYvdjlTN3ZRakhHVHU3LzRz?=
 =?utf-8?B?UGNBOFhycU1YRnp0OHUvd0YyNDM2c0FaSEtTMEJNTDdYbGtWOXlKNElHM1du?=
 =?utf-8?B?VHJtV3NBdlpkWnFBUnFQeTdxVmZCQUVMT2hMU0xNK2tqeVppMlcwU3BuN3Yr?=
 =?utf-8?B?NGIvdTFkV0Ryc3Z6Y0Y1c3VpYnFvZjlGTnAzOEl6S1ZiY1VZVUR4V1lLU0FX?=
 =?utf-8?B?T2tvVWw1TllneG9wclF1WTlBaXpldlNGM1NqZWVTQVQ5eU5qUjFxZk8yUkZN?=
 =?utf-8?B?bGJKRnVCUHlkL3lrRXBUeGw3SGx0aWpKbExML0tzRFBhRVViSEhwak94YVlK?=
 =?utf-8?B?bVExQTgzb0srbDZsNUNIZmhvV0VMOTBBSzN0WVpkbGtodTR2UEROSVJiSURt?=
 =?utf-8?B?NnpvTXkrMDVJbmZWYllHSXVBWnh1eEJIaFNGaWJZZWdOT0d5VmxRcWh5dW15?=
 =?utf-8?B?d3F6d2x4TlVlVjZqaVAxNGhtSE9MbE9sRWdWaEx3Z1NRN0ZDWVVrY08rNmZT?=
 =?utf-8?B?T2VjQWVFc283QVNJNVVTU3RvczdUSVgrR1ZZZElNQ05xSUZ2Z09XbHpxYzRX?=
 =?utf-8?B?bHVPOXV3cUJQQjU5TzNFZzBSVEMrZTJsc2NQVlRNZWRvS2ZnYVh1c0hsY0k5?=
 =?utf-8?B?UDZ2WmxITVRpOWxiZWptaGJucHprVzJzQ3hPeWQ4NlYvN2N5b1ROVk11bURh?=
 =?utf-8?B?b1dIMllUc1U4dmVWbG9zWFEvSXBpT0lIZVBkanBRUGxMZkhrRlVnUytLR1Yx?=
 =?utf-8?B?WEpjeGlpTXVHMGIyZXkrZjFzMzJEaE1rRW5jVWVPejVoZjZmK2VQNk5NcWxB?=
 =?utf-8?B?RFdJelg5a09pL1FPbEozRW1MenEreVZRd2RKZkZyYXZ5VXcyby9oSVNOUTNp?=
 =?utf-8?B?cXFJUXZVZ3YyYVZySWNVWGowTjRUcC9jZEIvMzNtdktITlIyWE5MQlNMYkdQ?=
 =?utf-8?B?MG81Qmd6dFFIS2FIYUFhSk5LdDY2R05oMU5jY0w1cVVNU0hUVzhZMUI0N3ZM?=
 =?utf-8?B?dUh2dlREVldJSlBub2NqOEg1cHRmR1dVOFNERWYxWURJdWlURURGbllDZVls?=
 =?utf-8?B?V0o0cDhqM21LWWFPdXJZV1IxQk1Ga3BjWFdNM25LMThTVEtaQ0RlYXJMUDdE?=
 =?utf-8?B?MXZKVVowUktoVzhUUmE0cUV5MXYydnFkajVLM0ZJZDNhaGZUZlNQVjVYZ0hZ?=
 =?utf-8?B?eFFqV3FQejhSZXJpTDlTSzQxd1JGeVViZGs5dm5HSFpMcitPUFMwcjdCOUVj?=
 =?utf-8?B?VUpSL0g1bGhTUWdtZTVFUGdJNWEwb1JTeXd3ay9QT0dURGUvQVcwWUI4bHZL?=
 =?utf-8?B?b3JTYktISGh4QWVyeE5JU2txMm96VE00aXBqK3JBQTdnUVlVcm5FVTdOYkIr?=
 =?utf-8?B?TUZZM3JyWVJpSys5Z1NoenBDd3RnMFVqV3BpVlFYTmpvS29nYU9EeVhSck45?=
 =?utf-8?B?ckFxdUxsc3lETXdlblpzcWhwSHpKRWJ5alZYYm9OQnRxQVZPeEJEQ1ZQVm4y?=
 =?utf-8?B?U3dldE9kU0F6NCtKbGZseXA1UnJqRTJscTNWbkxGM1EzMTVZMTNWN1NNMml4?=
 =?utf-8?B?S011aU1TdW9BTmNuOXFkMXoyQ0NVU29lcmgrRlJvbXdqaUIyQXR1U1hTbmdK?=
 =?utf-8?B?UzNlTkxVRUc1Y25HakVhODVRVnBNbmxYZFdHOVNkM29id1RFQ2g4a2pSQ1J0?=
 =?utf-8?B?UnBjdVFZd2hOZk5MNUhTVHFZejFySTRkUFkzSWU1S1I5V05LY3M0UWFRNVZw?=
 =?utf-8?Q?sNGkPB?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eUtHTmZvUS9jMmpPc1NTWWdoTHhraW10MFpwY0FmUkRFT09CTGhSZHM4bmxy?=
 =?utf-8?B?RElWNVB2QTRTQkQvck9hb1d6Q0FYdlRnRC92SVFySmdjVkQxV0xzbWJERXFC?=
 =?utf-8?B?eDkwOERQaVV2RkpMNzNmY1IyVGJmV1oyeEtGdDd0djcvbVhSbUNTdjVSYkJS?=
 =?utf-8?B?b3g5SnJPYzVSaitPVWZYVThFVldFUkYrbmRvUmk3U3VNam5SUkhMdEEvWXZp?=
 =?utf-8?B?ZFovN21RTWJrUFU5VnpsMWVVQU5rVHMzY2dldTlwRzBFQTFKdER5TEpFc0FI?=
 =?utf-8?B?cjhZUXNMakF1THVocFhVSnNXS1JGMGVOTTFLTUdzRkFIWDZZWEQ3aCtkRnNV?=
 =?utf-8?B?VXd4VEtXbVFsR2ltVDFDbGN0VFQ5dmdXWmhoS0NLVDZvekxFdkxZeWNhWlFx?=
 =?utf-8?B?R25sdkVpSHZiSTV0OEVKTkhjSDdYTUg3a1crV0RINzQ5a3g1ZlQwRUJCOVZK?=
 =?utf-8?B?U1NraXN5eWlYeFc1dld5TklkMjM1NzNkeEl0YTJqLzV4aExEY1Q5Q2NHTVJl?=
 =?utf-8?B?NjUwZWE4RnFvN2I1ZDdLR3RHa0FqbTM5SHRSMUVmU2xLeFNZdnh1b3dCRFdY?=
 =?utf-8?B?YjVGNmlnb0diWjdSQzZsQTJMVE94empNckkrLzVkdzBYOW43ZmR6STYweUVs?=
 =?utf-8?B?eld2aGszRzFJNm90THprb1lEZ1N2WC9EQUxiTGxXbXZ6cXUrT3d0WEdFa0ph?=
 =?utf-8?B?cTZHak5iK1VlWGhlbXdHRlRlSC8rZmNUWlFibnljbnBKenJOSlcreHArWXpL?=
 =?utf-8?B?Wkl5Vm01Q2QySUhYaERDUmR0UUx3NjdPWWx1S3JlVTVvdlNjaGpJdHdvVW9n?=
 =?utf-8?B?UWdSa2tEM29UL2ZPbjBlL2RhTnlCQ0lLNHlKWnRUWWlkMzFHYXZKQ042SWpN?=
 =?utf-8?B?aHoydytGNTNhVzR3MGI1ekU1dVBtb0VoQzRieEFYM3JEUWFiWFdvMkI2d2I4?=
 =?utf-8?B?NzJMQ20xT1JvTHc0U08yYWZ6Y2NKMWZzOWl0aitZanM2V0N3ZHliZ2llc09U?=
 =?utf-8?B?ZGZIZkNLallvaENsTHlhc0Q1MVI3Mk5XSk8vc2FDN1ZDbmZRSjd3Zm9icXBF?=
 =?utf-8?B?YU9JNzc0TXRWWmRmYXNFaW5IZlNnOU5HRXZZVmlpVWlhdzRLYzdwNlBpODAr?=
 =?utf-8?B?REVEYUhBMzVyV1ZVUUdCVDlIY2VkOTl0emUxLzRnRDdEREpibDFWVlJJTzN2?=
 =?utf-8?B?Wk9IcEZ5RjhKd1RxVXhsejRRRFFJeVRXbTZWMm9QTUw2K296bHR5SlJOYnJh?=
 =?utf-8?B?WXVzSThwOTBweUIwTnVlU3luRmM5RkhTYlIzZytBdW1INGd5djJXU1hRaWVm?=
 =?utf-8?B?ODhoYjhSZ3ZYRVJzcms1SlRPMFdIRWZUVlRrOGpqUEpmOWNKRjVVb2hSOXNH?=
 =?utf-8?B?M0RSZUN2d29qTDlmWDZlTnFiVVE5Lyt0ZmVISVVJMnpYVDdSUE1NYzREdmZq?=
 =?utf-8?B?WEZhZTZQalRER3QxOFliL3d3RUVFdFdveDd4V2YraEJIcU1xaHI0Ym9Fb3Yr?=
 =?utf-8?B?WU1VMkhnN0tPRVl0R1hHVzl2MmN0cUVVVnl0b2hUOTRxcVJ4ejJ0a1JqNlBi?=
 =?utf-8?B?SE16dXZwSTlLMDdWTkZKU0FEN28vbnByb0dOMGRMQkUyOUxoOWxVeFI0TlBy?=
 =?utf-8?B?VVV3eS9ERXJhSzZRUEVzWEtEV2UwYzhrM2h4Mkh3YUMwVnltem9RMUhYYzgy?=
 =?utf-8?B?WXN0YTJxMDZMOUEzQXp2ci93cXNvUC8vOXdKMVVjWlZvUFAzeThMdzFGTTFh?=
 =?utf-8?B?UlFNSVk5K3ZlaEQ4bjNHRmRPcll1TkljbG9DT2Z2QlB5U2FLUis1bStWR3VZ?=
 =?utf-8?B?WHdaL0xsWE83eEFyRzBHYkwxUWN4cHBlQnhSTkhKQjNDZWtaM2t5Y3RXT3dx?=
 =?utf-8?B?WnIzL1RXbjZsckZSa0ppRldhaWZ2b3IrN3FwZEJicDJ5YXI5ZVE0S1JjMG4w?=
 =?utf-8?B?SjVKbW9mNWlZNDFKR0pjMVk5VUZheStmTFlTQVhsZkhXY0ZMdncybW1Idnoy?=
 =?utf-8?B?K21SdTdSSlJMWWsxaHRmaU9uOGNzU24yQ0ZMNGNBSGFYenVPRXNTN0xneFh4?=
 =?utf-8?B?SXFkWmM3N0dFQlB5c2tpV0ExYmtyMGZjU251NW9tU3JSYUtZakNpcm93ZUQw?=
 =?utf-8?B?SEQ2UXNXZGJQVXYzL3NPTEQ5SVk3QThUbXZWVm9JcW1EZnFjTVNMUnhHLzha?=
 =?utf-8?Q?ERoRoL94cNvLZTnCXKa58O4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A4A74DA9A4B314681960011994188A5@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c046e141-db82-4470-5401-08de004fbdd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2025 18:32:41.9639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wiLDmJ4eV9MgztxMPRndMGb+2+QJAA23muDRW/LjggOwNsf87QM6cl1JajZ+4OrStdq26RDSY2exipwuRhULNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR15MB6548
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfXyXFjSSo23f79
 VuxiqzX2uJgtkGtLca6e8nRZwNqSnAU+IC0i0kP2sZjwr4hZKZwVfjdKLuNonXcvL44OjwpKi7M
 vMPvYeilbhBkX8PoHf4LNbIS3fQ5kQM+Dd54kxsZmu4V/EHB7d24GfIACjwoF+LZ2iFKK5vw2aG
 qci9duZHzSRTfUTXFP85/vCx8GZKaQL+XUSiQUGMLtIXN+1u2NMQoHzFomNqyTJs3dmohL/sSOG
 3jwOHOk4cSq7eyclrCnD8vyIzxczBN66H57r0zkMxBbks3QHZ0Lc4g2A5aA7TwcCZ0Jfnhxpbwu
 uv2ZoxuXIXv0zQc6Bos1Tln5KaAGUyr/IVC0f/AfuhIT6Lh3MgNfrFdxz7jSkKgyZ7+rLhuzWVl
 zejFmoREMdMoeE9YZ2FEo4PrfQY2Bw==
X-Proofpoint-ORIG-GUID: us5OXkq1_MwgiOv8XDrZJqWSIXdm6I6Z
X-Proofpoint-GUID: 4wFWAs-qMbm_OALWCrEQzkP2yHa6G2r1
X-Authority-Analysis: v=2.4 cv=GdUaXAXL c=1 sm=1 tr=0 ts=68dc224e cx=c_pps
 a=4QVYENZnsEoURNel/cbnog==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=LM7KSAFEAAAA:8 a=9aJW4fxuBXnc7BeT0GgA:9
 a=QEXdDO2ut3YA:10
Subject: RE: [PATCH 1/2] ceph: fix snapshot context missing in
 ceph_zero_partial_object
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_03,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 phishscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025

T24gVHVlLCAyMDI1LTA5LTMwIGF0IDE1OjA3ICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiBWaWFj
aGVzbGF2IER1YmV5a28gPFNsYXZhLuKAikR1YmV5a29A4oCKaWJtLuKAimNvbT4g5pa8IDIwMjUt
MDktMjcgMDU64oCKNDEg5a+r6YGT77yaIE9uIFRodSwgMjAyNS0wOS0yNSBhdCAxODrigIo0MiAr
MDgwMCwgZXRoYW53dSB3cm90ZTogPiBUaGUgY2VwaF96ZXJvX3BhcnRpYWxfb2JqZWN0IGZ1bmN0
aW9uIHdhcyBtaXNzaW5nIHByb3BlciBzbmFwc2hvdCA+IGNvbnRleHQgZm9yIGl0cyBPU0Qgd3Jp
dGUgb3BlcmF0aW9ucywgd2hpY2gNCj4gDQo+IFZpYWNoZXNsYXYgRHViZXlrbyA8U2xhdmEuRHVi
ZXlrb0BpYm0uY29tPiDmlrwgMjAyNS0wOS0yNyAwNTo0MSDlr6vpgZPvvJoNCj4gPiBPbiBUaHUs
IDIwMjUtMDktMjUgYXQgMTg6NDIgKzA4MDAsIGV0aGFud3Ugd3JvdGU6DQo+ID4gPiBUaGUgY2Vw
aF96ZXJvX3BhcnRpYWxfb2JqZWN0IGZ1bmN0aW9uIHdhcyBtaXNzaW5nIHByb3BlciBzbmFwc2hv
dA0KPiA+ID4gY29udGV4dCBmb3IgaXRzIE9TRCB3cml0ZSBvcGVyYXRpb25zLCB3aGljaCBjb3Vs
ZCBsZWFkIHRvIGRhdGENCj4gPiA+IGluY29uc2lzdGVuY2llcyBpbiBzbmFwc2hvdHMuDQo+ID4g
PiANCj4gPiA+IFJlcHJvZHVjZXI6DQo+ID4gPiAuLi9zcmMvdnN0YXJ0LnNoIC0tbmV3IC14IC0t
bG9jYWxob3N0IC0tYmx1ZXN0b3JlDQo+ID4gPiAuL2Jpbi9jZXBoIGF1dGggY2FwcyBjbGllbnQu
ZnNfYSBtZHMgJ2FsbG93IHJ3cHMgZnNuYW1lPWEnIG1vbiAnYWxsb3cgciBmc25hbWU9YScgb3Nk
ICdhbGxvdyBydyB0YWcgY2VwaGZzIGRhdGE9YScNCj4gPiA+IG1vdW50IC10IGNlcGggZnNfYUAu
YT0vIC9tbnQvbXljZXBoZnMvIC1vIGNvbmY9Li9jZXBoLmNvbmYNCj4gPiA+IGRkIGlmPS9kZXYv
dXJhbmRvbSBvZj0vbW50L215Y2VwaGZzL2ZvbyBicz02NEsgY291bnQ9MQ0KPiA+ID4gbWtkaXIg
L21udC9teWNlcGhmcy8uc25hcC9zbmFwMQ0KPiA+ID4gbWQ1c3VtIC9tbnQvbXljZXBoZnMvLnNu
YXAvc25hcDEvZm9vDQo+ID4gPiBmYWxsb2NhdGUgLXAgLW8gMCAtbCA0MDk2IC9tbnQvbXljZXBo
ZnMvZm9vDQo+ID4gPiBlY2hvIDMgPiAvcHJvYy9zeXMvdm0vZHJvcC9jYWNoZXMNCj4gPiANCj4g
PiBJIGhhdmUgb24gbXkgc2lkZTogJ2VjaG8gMyA+IC9wcm9jL3N5cy92bS9kcm9wX2NhY2hlcycu
DQo+IA0KPiBUaGFua3MgZm9yIHBvaW50aW5nIHRoaXMgb3V0LCBJJ2xsIHVwZGF0ZSBpbiBWMi4N
Cj4gPiANCj4gPiANCj4gPiA+IG1kNXN1bSAvbW50L215Y2VwaGZzLy5zbmFwL3NuYXAxL2ZvbyAj
IGdldCBkaWZmZXJlbnQgbWQ1c3VtISENCj4gPiA+IA0KPiA+ID4gRml4ZXM6IGFkN2E2MGRlODgy
YWMgKCJjZXBoOiBwdW5jaCBob2xlIHN1cHBvcnQiKQ0KPiA+ID4gU2lnbmVkLW9mZi1ieTogZXRo
YW53dSA8ZXRoYW53dUBzeW5vbG9neS5jb20+DQo+ID4gPiAtLS0NCj4gPiA+IMKgZnMvY2VwaC9m
aWxlLmMgfCAxNyArKysrKysrKysrKysrKysrLQ0KPiA+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMTYg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEv
ZnMvY2VwaC9maWxlLmMgYi9mcy9jZXBoL2ZpbGUuYw0KPiA+ID4gaW5kZXggYzAyZjEwMGY4NTUy
Li41OGNjMmNiYWU4YmMgMTAwNjQ0DQo+ID4gPiAtLS0gYS9mcy9jZXBoL2ZpbGUuYw0KPiA+ID4g
KysrIGIvZnMvY2VwaC9maWxlLmMNCj4gPiA+IEBAIC0yNTcyLDYgKzI1NzIsNyBAQCBzdGF0aWMg
aW50IGNlcGhfemVyb19wYXJ0aWFsX29iamVjdChzdHJ1Y3QgaW5vZGUgKmlub2RlLA0KPiA+ID4g
wqDCoHN0cnVjdCBjZXBoX2lub2RlX2luZm8gKmNpID0gY2VwaF9pbm9kZShpbm9kZSk7DQo+ID4g
PiDCoMKgc3RydWN0IGNlcGhfZnNfY2xpZW50ICpmc2MgPSBjZXBoX2lub2RlX3RvX2ZzX2NsaWVu
dChpbm9kZSk7DQo+ID4gPiDCoMKgc3RydWN0IGNlcGhfb3NkX3JlcXVlc3QgKnJlcTsNCj4gPiA+
ICsgc3RydWN0IGNlcGhfc25hcF9jb250ZXh0ICpzbmFwYzsNCj4gPiA+IMKgwqBpbnQgcmV0ID0g
MDsNCj4gPiA+IMKgwqBsb2ZmX3QgemVybyA9IDA7DQo+ID4gPiDCoMKgaW50IG9wOw0KPiA+ID4g
QEAgLTI1ODYsMTIgKzI1ODcsMjUgQEAgc3RhdGljIGludCBjZXBoX3plcm9fcGFydGlhbF9vYmpl
Y3Qoc3RydWN0IGlub2RlICppbm9kZSwNCj4gPiA+IMKgwqDCoG9wID0gQ0VQSF9PU0RfT1BfWkVS
TzsNCj4gPiA+IMKgwqB9DQo+ID4gPiANCj4gPiA+ICsgc3Bpbl9sb2NrKCZjaS0+aV9jZXBoX2xv
Y2spOw0KPiA+ID4gKyBpZiAoX19jZXBoX2hhdmVfcGVuZGluZ19jYXBfc25hcChjaSkpIHsNCj4g
PiA+ICsgIHN0cnVjdCBjZXBoX2NhcF9zbmFwICpjYXBzbmFwID0NCj4gPiA+ICsgICAgbGlzdF9s
YXN0X2VudHJ5KCZjaS0+aV9jYXBfc25hcHMsDQo+ID4gPiArICAgICAgc3RydWN0IGNlcGhfY2Fw
X3NuYXAsDQo+ID4gPiArICAgICAgY2lfaXRlbSk7DQo+ID4gPiArICBzbmFwYyA9IGNlcGhfZ2V0
X3NuYXBfY29udGV4dChjYXBzbmFwLT5jb250ZXh0KTsNCj4gPiA+ICsgfSBlbHNlIHsNCj4gPiA+
ICsgIEJVR19PTighY2ktPmlfaGVhZF9zbmFwYyk7DQo+ID4gDQo+ID4gQnkgdGhlIHdheSwgd2h5
IGFyZSBkZWNpZGVkIHRvIHVzZSBCVUdfT04oKSBpbnN0ZWFkIG9mIHJldHVybmluZyBlcnJvciBo
ZXJlPyANCj4gDQo+IEkgZm9sbG93IHRoZSByZXN0IG9mIHRoZSBwbGFjZXMgdGhhdCB1c2UgaV9o
ZWFkX3NuYXBjLg0KPiBUaGV5IGNhbGwgQlVHX09OIHdoZW4gY2ktPmlfaGVhZF9zbmFwYyBpcyBO
VUxMOw0KPiBidXQgcnVubmluZ8KgLi9zY3JpcHRzL2NoZWNrcGF0Y2gucGwgLS1zdHJpY3QsIGl0
IHdhcm5zIHRoYXQgYXZvaWQgdXNpbmcgQlVHX09OLMKgDQo+IGlmIHRoaXMgaXMgdGhlIGxhdGVz
dCBjb2Rpbmcgc3R5bGUsIEkgY2FuIGNoYW5nZSBpdC4NCg0KRnJhbmtseSBzcGVha2luZywgaXQg
aXMgcG9zc2libGUgdG8gY29uc2lkZXIgdmFyaW91cyB3YXlzIG9mIHByb2Nlc3NpbmcgbGlrZXdp
c2UNCnNpdHVhdGlvbnMuIERldmVsb3BlcnMgY291bGQgcHJlZmVyIHRvIGhhdmUgQlVHX09OKCkg
dG8gc3RvcCB0aGUgY29kZSBleGVjdXRpb24NCmluIHRoZSBwbGFjZSBvZiBwcm9ibGVtLiBIb3dl
dmVyLCBlbmQtdXNlcnMgd291bGQgbGlrZSB0byBzZWUgdGhlIGNvZGUgcnVubmluZw0KYnV0IG5v
dCBjcmFzaGluZy4gU28sIGVuZC11c2VycyB3b3VsZCBwcmVmZXIgdG8gc2VlIHRoZSBlcnJvciBj
b2RlIHJldHVybmVkLiBBbmQNCndlIGFyZSB3cml0aW5nIHRoZSBjb2RlIGZvciBlbmQtdXNlcnMu
IDopIFNvLCByZXR1cm5pbmcgZXJyb3IgY29kZSBpcyBtb3JlDQpnZW50bGUgd2F5LCBmcm9tIG15
IHBvaW50IG9mIHZpZXcuDQoNCj4gPiBBbmQgeW91IGRlY2lkZWQgbm90IHRvIGNoZWNrIGNpLT5p
X2NhcF9zbmFwcyBhYm92ZS4NCj4gDQo+IEknbSBub3QgcXVpdGUgc3VyZSB3aGF0IHlvdSBtZWFu
LsKgDQo+IF9fY2VwaF9oYXZlX3BlbmRpbmdfY2FwX3NuYXAgYWxyZWFkeSBjaGVja2VkIGlmIGlf
Y2FwX3NuYXBzIGlzIGVtcHR5IG9yIG5vdC4NCj4gSXMgdGhpcyB0aGUgY2hlY2sgeW91IHdhbnQ/
DQo+IMKgDQoNCkkgYW0gc2ltcGx5IHRyeWluZyB0byBkb3VibGUgY2hlY2sgdGhhdCBhbGwgbmVj
ZXNzYXJ5IGNvZGUgY2hlY2tzIGFyZSBpbiBwbGFjZS4NCklmIGlfY2FwX3NuYXBzIGlzIGFscmVh
ZHkgY2hlY2tlZCwgdGhlbiB3ZSBkb24ndCBuZWVkIHRvIGFkZCBhbm90aGVyIG9uZSBjaGVjay4N
Cg0KVGhhbmtzLA0KU2xhdmEuDQoNCj4gVGhhbmtzLA0KPiBldGhhbnd1DQo+ID4gDQo+ID4gPiAr
ICBzbmFwYyA9IGNlcGhfZ2V0X3NuYXBfY29udGV4dChjaS0+aV9oZWFkX3NuYXBjKTsNCj4gPiA+
ICsgfQ0KPiA+ID4gKyBzcGluX3VubG9jaygmY2ktPmlfY2VwaF9sb2NrKTsNCj4gPiA+ICsNCj4g
PiA+IMKgwqByZXEgPSBjZXBoX29zZGNfbmV3X3JlcXVlc3QoJmZzYy0+Y2xpZW50LT5vc2RjLCAm
Y2ktPmlfbGF5b3V0LA0KPiA+ID4gwqDCoMKgwqDCoMKgY2VwaF92aW5vKGlub2RlKSwNCj4gPiA+
IMKgwqDCoMKgwqDCoG9mZnNldCwgbGVuZ3RoLA0KPiA+ID4gwqDCoMKgwqDCoMKgMCwgMSwgb3As
DQo+ID4gPiDCoMKgwqDCoMKgwqBDRVBIX09TRF9GTEFHX1dSSVRFLA0KPiA+ID4gLSAgICAgTlVM
TCwgMCwgMCwgZmFsc2UpOw0KPiA+ID4gKyAgICAgc25hcGMsIDAsIDAsIGZhbHNlKTsNCj4gPiA+
IMKgwqBpZiAoSVNfRVJSKHJlcSkpIHsNCj4gPiA+IMKgwqDCoHJldCA9IFBUUl9FUlIocmVxKTsN
Cj4gPiA+IMKgwqDCoGdvdG8gb3V0Ow0KPiA+ID4gQEAgLTI2MDUsNiArMjYxOSw3IEBAIHN0YXRp
YyBpbnQgY2VwaF96ZXJvX3BhcnRpYWxfb2JqZWN0KHN0cnVjdCBpbm9kZSAqaW5vZGUsDQo+ID4g
PiDCoMKgY2VwaF9vc2RjX3B1dF9yZXF1ZXN0KHJlcSk7DQo+ID4gPiDCoA0KPiA+ID4gDQo+ID4g
PiANCj4gPiA+IA0KPiA+ID4gwqBvdXQ6DQo+ID4gPiArIGNlcGhfcHV0X3NuYXBfY29udGV4dChz
bmFwYyk7DQo+ID4gPiDCoMKgcmV0dXJuIHJldDsNCj4gPiA+IMKgfQ0KPiA+ID4gwqANCj4gPiA+
IA0KPiA+ID4gDQo+ID4gPiANCj4gPiANCj4gPiBMb29rcyBnb29kLg0KPiA+IA0KPiA+IFJldmll
d2VkLWJ5OiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5a29AaWJtLmNvbT4NCj4gPiBU
ZXN0ZWQtYnk6IFZpYWNoZXNsYXYgRHViZXlrbyA8U2xhdmEuRHViZXlrb0BpYm0uY29tPg0KPiA+
IA0KPiA+IFRoYW5rcywNCj4gPiBTbGF2YS4NCj4gRGlzY2xhaW1lcjogVGhlIGNvbnRlbnRzIG9m
IHRoaXMgZS1tYWlsIG1lc3NhZ2UgYW5kIGFueSBhdHRhY2htZW50cyBhcmUgY29uZmlkZW50aWFs
IGFuZCBhcmUgaW50ZW5kZWQgc29sZWx5IGZvciBhZGRyZXNzZWUuIFRoZSBpbmZvcm1hdGlvbiBt
YXkgYWxzbyBiZSBsZWdhbGx5IHByaXZpbGVnZWQuIFRoaXMgdHJhbnNtaXNzaW9uIGlzIHNlbnQg
aW4gdHJ1c3QsIGZvciB0aGUgc29sZSBwdXJwb3NlIG9mIGRlbGl2ZXJ5IHRvIHRoZSBpbnRlbmRl
ZCByZWNpcGllbnQuIElmIHlvdSBoYXZlIHJlY2VpdmVkIHRoaXMgdHJhbnNtaXNzaW9uIGluIGVy
cm9yLCBhbnkgdXNlLCByZXByb2R1Y3Rpb24gb3IgZGlzc2VtaW5hdGlvbiBvZiB0aGlzIHRyYW5z
bWlzc2lvbiBpcyBzdHJpY3RseSBwcm9oaWJpdGVkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5k
ZWQgcmVjaXBpZW50LCBwbGVhc2UgaW1tZWRpYXRlbHkgbm90aWZ5IHRoZSBzZW5kZXIgYnkgcmVw
bHkgZS1tYWlsIG9yIHBob25lIGFuZCBkZWxldGUgdGhpcyBtZXNzYWdlIGFuZCBpdHMgYXR0YWNo
bWVudHMsIGlmIGFueS4NCg==

