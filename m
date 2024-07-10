Return-Path: <ceph-devel+bounces-1516-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33CC492D80D
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 20:11:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D8741C20EB3
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 18:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43B6195F17;
	Wed, 10 Jul 2024 18:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="fKqeCeoh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AB719580B;
	Wed, 10 Jul 2024 18:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720635069; cv=none; b=dHA0lkOX3cN96qYJKQXGSwXeA+tXakLIsbNDy0579C+PnZgRy539djNx6X0GdMx432T0rjEtWs7WDWxXni9gvA8plbAgg9kXI8eqPbiXteJeP35NoUjpW44Ru3byh1DrgF82e28980u6E9SrS7aiP2GuyLqDXwxSxiB18NiHtlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720635069; c=relaxed/simple;
	bh=NH51Gm1ebO405FZGc6l9wG2SFCxWaOHSn18QhugIZZQ=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=hcO6iCgK3wduuU/IpaBe62nLXVX0lwtv1XtpRxjrb5Qphr4Yq8n4T4slOrsDYWSUqneofQ5GgAyJNyfZWq4jPlDZ82GTNDetOBjq2HxqHESSELEfyfY51QSwqPsW8xqEK6vWLqb74WdOXu9/kXYdbHiIl6E3t1Cpq2t4sXRjcCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=fKqeCeoh; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46A9WJh8028685;
	Wed, 10 Jul 2024 18:10:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=usBp91UXvjAj150cjj8l6p
	Ff5frheSfqpKqhqAsv8lQ=; b=fKqeCeohz+MF5v3aUEEfLsV80qfh3QWM/Dl5av
	pe2lIeYatdrzrSPPBP2RXzZ0wufXwMKUHIFFxI6/gV6bI+nPZ8InmWxaJcjOcoh/
	GWcH519zRHS8po7lEMhBhLNm1X0UI8UBobGSQsMEzhFJYfO072KCvKO/QYKCgl73
	tCju0EFXfIeYAgF48Fjb/73ga8FZ5SanlFnTe4RsSnQQLyru9nLkdi+HDKsJDTod
	buD1BDjT0L41iJs8EuA2LP0goJ1+PRroAKhXmYgKL54JmDdIVgw/5ALaHwXZOz9b
	KaX/qKHyCI2vO4t/I69SS3QANsexPomyNymhlvEDfJbA+dqw==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 406we920se-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 18:10:53 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46AIACfC006468
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 18:10:12 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 10 Jul
 2024 11:10:12 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: [PATCH net-next 0/2] libceph: fix kernel-doc warnings
Date: Wed, 10 Jul 2024 11:10:02 -0700
Message-ID: <20240710-kd-crush_choose_indep-v1-0-fe2b85f322c6@quicinc.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHrOjmYC/x2MUQqDMBAFryL73YUo0mKvUorE+GyWtqtkVQTx7
 k39HIaZnQxJYHQvdkpYxWTUDOWloBC9vsDSZ6bKVbW7lY7fPYe0WGxDHEdDK9pjYlf5ZmjcFQN
 qyu2UMMh2fh+kmFmxzfTMpvMG7pLXEP/fj+iynZa/3mYkOo4fhvjTdJUAAAA=
To: Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
        "David S.
 Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: <ceph-devel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.14.0
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: QA4s98LEogaza9TrzQDAWY2QNNHl5D1V
X-Proofpoint-GUID: QA4s98LEogaza9TrzQDAWY2QNNHl5D1V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_13,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 bulkscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=858 malwarescore=0 mlxscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2407100128

I split this into two patches due to the nature of the two fixes.
Let me know if you prefer them to be squashed.

---
Jeff Johnson (2):
      libceph: suppress crush_choose_indep() kernel-doc warnings
      libceph: fix crush_choose_firstn() kernel-doc warnings

 net/ceph/crush/mapper.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)
---
base-commit: 523b23f0bee3014a7a752c9bb9f5c54f0eddae88
change-id: 20240710-kd-crush_choose_indep-02a9f906efe4


